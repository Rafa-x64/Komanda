import { Conexion } from "../../config/database";
import { Categoria } from "./domain/categoria.entity";
import { Receta } from "./domain/receta.entity";
import { Mesa } from "./domain/mesa.entity";
import { Pedido } from "./domain/pedido.entity";
import { PedidoDetalle } from "./domain/pedido-detalle.entity";
import { Restaurant } from "../signup/domain/restaurant.entity";
import { CreateOrderInput } from "./sales.validator";

/** Genera código único: PED-20260324-0001 */
const generateOrderCode = async (restaurantId: number): Promise<string> => {
    const today = new Date().toISOString().slice(0, 10).replace(/-/g, "");
    const result = await Conexion.getRepository(Pedido)
        .createQueryBuilder("p")
        .where("p.restaurante_id = :rid", { rid: restaurantId })
        .andWhere("p.codigo LIKE :prefix", { prefix: `PED-${today}-%` })
        .getCount();
    const seq = String(result + 1).padStart(4, "0");
    return `PED-${today}-${seq}`;
};

export const SalesService = {
    async getCategories(restaurantId: number) {
        return Conexion.getRepository(Categoria).find({
            where: { restaurante_id: restaurantId, activo: true },
            order: { orden: "ASC", nombre: "ASC" },
        });
    },

    async getProducts(restaurantId: number) {
        return Conexion.getRepository(Receta).find({
            where: { restaurante_id: restaurantId, activo: true },
            order: { nombre: "ASC" },
        });
    },

    async getTables(restaurantId: number) {
        return Conexion.getRepository(Mesa).find({
            where: { restaurante_id: restaurantId },
            order: { numero: "ASC" },
        });
    },

    async createOrder(data: CreateOrderInput, restaurantId: number) {
        const qr = Conexion.createQueryRunner();
        await qr.connect();
        await qr.startTransaction();

        try {
            // 1. Verificar que la mesa existe y pertenece al restaurante
            const mesa = await qr.manager.findOne(Mesa, {
                where: { id: data.mesa_id, restaurante_id: restaurantId },
            });
            if (!mesa) throw new Error("La mesa seleccionada no existe");

            // 2. Obtener impuesto del restaurante
            const restaurant = await qr.manager.findOne(Restaurant, {
                where: { id: restaurantId },
            });
            if (!restaurant) throw new Error("Restaurante no encontrado");
            const taxRate = parseFloat(String(restaurant.impuesto_porcentaje)) / 100;

            // 3. Obtener precios reales desde BD (nunca confiar en el frontend)
            const recetaIds = data.items.map((i) => i.receta_id);
            const recetas = await qr.manager
                .getRepository(Receta)
                .createQueryBuilder("r")
                .where("r.id IN (:...ids)", { ids: recetaIds })
                .andWhere("r.restaurante_id = :rid", { rid: restaurantId })
                .andWhere("r.activo = true")
                .getMany();

            if (recetas.length !== recetaIds.length) {
                throw new Error("Una o más recetas no existen o no están activas");
            }

            const priceMap = new Map(recetas.map((r) => [r.id, parseFloat(String(r.precio_venta))]));

            // 4. Calcular importes de cada item
            const detailItems = data.items.map((item) => {
                const unitPrice = priceMap.get(item.receta_id)!;
                const itemSubtotal = parseFloat((unitPrice * item.cantidad).toFixed(2));
                return {
                    receta_id: item.receta_id,
                    cantidad: item.cantidad,
                    precio_unitario: unitPrice,
                    subtotal: itemSubtotal,
                    notas: item.notas || null,
                    restaurante_id: restaurantId,
                };
            });

            const subtotal = parseFloat(detailItems.reduce((acc, i) => acc + i.subtotal, 0).toFixed(2));
            const impuestos = parseFloat((subtotal * taxRate).toFixed(2));
            const total = parseFloat((subtotal + impuestos).toFixed(2));

            // 5. Generar código y crear pedido
            const codigo = await generateOrderCode(restaurantId);

            const pedido = qr.manager.create(Pedido, {
                codigo,
                mesa_id: data.mesa_id,
                estado: "pendiente",
                estado_cuenta: "abierta",
                subtotal,
                descuento: 0,
                impuestos,
                total,
                restaurante_id: restaurantId,
            });
            await qr.manager.save(pedido);

            // 6. Insertar detalle del pedido
            const detalles = detailItems.map((d) =>
                qr.manager.create(PedidoDetalle, { ...d, pedido_id: pedido.id })
            );
            await qr.manager.save(detalles);

            // 7. Marcar mesa como ocupada
            await qr.manager.update(Mesa, { id: data.mesa_id }, { estado: "ocupada" });

            await qr.commitTransaction();

            return {
                id: pedido.id,
                codigo: pedido.codigo,
                mesa_id: pedido.mesa_id,
                estado: pedido.estado,
                subtotal: pedido.subtotal,
                impuestos: pedido.impuestos,
                total: pedido.total,
                items: detalles.map((d) => ({
                    receta_id: d.receta_id,
                    cantidad: d.cantidad,
                    precio_unitario: d.precio_unitario,
                    subtotal: d.subtotal,
                    notas: d.notas,
                })),
                created_at: pedido.created_at,
            };
        } catch (error) {
            await qr.rollbackTransaction();
            throw error;
        } finally {
            await qr.release();
        }
    },
};
