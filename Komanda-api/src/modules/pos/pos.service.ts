import { Conexion } from "../../config/database";
import { Categoria } from "./domain/categoria.entity";
import { Receta } from "./domain/receta.entity";
import { Mesa } from "./domain/mesa.entity";
import { Pedido } from "./domain/pedido.entity";
import { PedidoDetalle } from "./domain/pedido-detalle.entity";
import { Restaurant } from "../signup/domain/restaurant.entity";
import { CreateSaleInput, CashClosureInput, CheckoutOrderInput } from "./pos.validator";
import { broadcastNewOrderToKitchen } from "../kitchen/kitchen.socket";

/** Genera código único: PED-20260401-0001 */
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

export class POSService {
    static async getCategories(restaurantId: number) {
        return Conexion.getRepository(Categoria).find({
            where: { restaurante_id: restaurantId, activo: true }
        });
    }

    static async getProducts(restaurantId: number) {
        return Conexion.getRepository(Receta).find({
            where: { restaurante_id: restaurantId, activo: true }
        });
    }

    static async getTables(restaurantId: number) {
        return Conexion.getRepository(Mesa).find({
            where: { restaurante_id: restaurantId }
        });
    }

    static async getPaymentMethods(restaurantId: number) {
        return Conexion.query(
            `SELECT id, nombre, activo FROM core.metodos_pago 
             WHERE (restaurante_id = $1) AND activo = true 
             ORDER BY nombre`,
            [restaurantId]
        );
    }

    static async getSales(restaurantId: number) {
        return Conexion.query(
            `SELECT p.id, p.codigo, p.cliente, p.estado, p.estado_cuenta, p.subtotal, p.impuestos, p.total, p.fecha_hora
             FROM operaciones.pedidos p
             WHERE p.restaurante_id = $1
             ORDER BY p.fecha_hora DESC LIMIT 50`,
            [restaurantId]
        );
    }

    static async getActiveOrders(restaurantId: number) {
        return Conexion.query(
            `SELECT 
                p.id, p.codigo, p.cliente, p.estado, p.estado_cuenta, 
                p.subtotal, p.total, p.fecha_hora,
                m.numero AS mesa_numero, m.nombre AS mesa_nombre, m.estado AS mesa_estado,
                json_agg(
                    json_build_object(
                        'id', pd.id,
                        'receta_id', pd.receta_id,
                        'nombre', r.nombre,
                        'cantidad', pd.cantidad,
                        'precio_unitario', pd.precio_unitario,
                        'subtotal', pd.subtotal,
                        'notas', pd.notas
                    ) ORDER BY pd.id
                ) AS items
             FROM operaciones.pedidos p
             LEFT JOIN operaciones.mesas m ON m.id = p.mesa_id
             LEFT JOIN operaciones.pedido_detalle pd ON pd.pedido_id = p.id
             LEFT JOIN menu.recetas r ON r.id = pd.receta_id
             WHERE p.restaurante_id = $1
               AND p.estado IN ('pendiente', 'preparando', 'listo')
             GROUP BY p.id, m.numero, m.nombre, m.estado
             ORDER BY p.fecha_hora DESC`,
            [restaurantId]
        );
    }

    // Cola del cajero: pedidos con cuenta abierta (sin importar si ya está en cocina)
    static async getReadyOrders(restaurantId: number) {
        return Conexion.query(
            `SELECT 
                p.id, p.codigo, p.cliente, p.estado, p.estado_cuenta,
                p.subtotal, p.impuestos, p.total, p.fecha_hora,
                m.numero AS mesa_numero, m.nombre AS mesa_nombre,
                json_agg(
                    json_build_object(
                        'id', pd.id,
                        'nombre', r.nombre,
                        'cantidad', pd.cantidad,
                        'precio_unitario', pd.precio_unitario,
                        'subtotal', pd.subtotal,
                        'notas', pd.notas
                    ) ORDER BY pd.id
                ) AS items
             FROM operaciones.pedidos p
             LEFT JOIN operaciones.mesas m ON m.id = p.mesa_id
             LEFT JOIN operaciones.pedido_detalle pd ON pd.pedido_id = p.id
             LEFT JOIN menu.recetas r ON r.id = pd.receta_id
             WHERE p.restaurante_id = $1
               AND p.estado_cuenta = 'abierta'
               AND p.estado IN ('pendiente', 'preparando', 'listo')
             GROUP BY p.id, m.numero, m.nombre
             ORDER BY
               CASE p.estado WHEN 'listo' THEN 0 WHEN 'preparando' THEN 1 ELSE 2 END,
               p.fecha_hora ASC`,
            [restaurantId]
        );
    }

    static async updateOrderStatus(pedidoId: number, estado: string, restaurantId: number) {
        const validEstados = ['pendiente', 'preparando', 'listo', 'anulado'];
        if (!validEstados.includes(estado)) throw new Error('Estado inválido');

        const result = await Conexion.query(
            `UPDATE operaciones.pedidos 
             SET estado = $1, updated_at = NOW()
             WHERE id = $2 AND restaurante_id = $3
             RETURNING id, codigo, estado, mesa_id`,
            [estado, pedidoId, restaurantId]
        );
        if (!result.length) throw new Error('Pedido no encontrado');
        return result[0];
    }

    static async createSale(data: CreateSaleInput, restaurantId: number, userId: number) {
        const qr = Conexion.createQueryRunner();
        await qr.connect();
        await qr.startTransaction();

        try {
            // 1. Validar mesa si es provista
            if (data.mesa_id) {
                const mesa = await qr.manager.findOne(Mesa, { where: { id: data.mesa_id, restaurante_id: restaurantId } });
                if (!mesa) throw new Error("La mesa seleccionada no existe o no pertenece al restaurante");
            }

            // 2. Impuesto
            const restaurant = await qr.manager.findOne(Restaurant, { where: { id: restaurantId } });
            if (!restaurant) throw new Error("Restaurante no encontrado");
            const taxRate = Number(restaurant.impuesto_porcentaje || 0) / 100;

            // 3. Precios reales
            const recetaIds = data.items.map(i => i.receta_id);
            const recetas = await qr.manager
                .getRepository(Receta)
                .createQueryBuilder("r")
                .where("r.id IN (:...ids)", { ids: recetaIds })
                .andWhere("r.restaurante_id = :rid", { rid: restaurantId })
                .getMany();

            if (recetas.length !== recetaIds.length) {
                throw new Error("Una o más recetas no están disponibles");
            }

            const priceMap = new Map(recetas.map(r => [r.id, Number(r.precio_venta)]));

            // [NUEVO LOGICA: Bloqueo de Stock y Back-flushing]
            const itemsJson = JSON.stringify(data.items.map(i => ({ receta_id: i.receta_id, cantidad: i.cantidad })));
            const stockCheck: any[] = await qr.manager.query(`
                WITH required AS (
                    SELECT 
                        ri.ingrediente_id,
                        SUM(ri.cantidad * (i.value->>'cantidad')::numeric) AS cantidad_requerida
                    FROM menu.receta_ingredientes ri
                    CROSS JOIN json_array_elements($1::json) AS i
                    WHERE ri.receta_id = (i.value->>'receta_id')::int
                    AND ri.restaurante_id = $2
                    GROUP BY ri.ingrediente_id
                )
                SELECT 
                    r.ingrediente_id, 
                    r.cantidad_requerida,
                    i.nombre,
                    i.cantidad_disponible,
                    i.costo_promedio
                FROM required r
                JOIN inventario.ingredientes i ON i.id = r.ingrediente_id
                WHERE i.restaurante_id = $2
            `, [itemsJson, restaurantId]);

            let totalCostoVenta = 0;
            // 4. Validar Inventario antes de proseguir
            for (const req of stockCheck) {
                if (Number(req.cantidad_disponible) < Number(req.cantidad_requerida)) {
                    throw new Error(`Stock insuficiente para el ingrediente: ${req.nombre}`);
                }
                totalCostoVenta += Number(req.cantidad_requerida) * Number(req.costo_promedio);

                // Ejecutar Back-flushing
                await qr.manager.query(
                    `UPDATE inventario.ingredientes 
                     SET cantidad_disponible = cantidad_disponible - $1, 
                         updated_at = CURRENT_TIMESTAMP 
                     WHERE id = $2 AND restaurante_id = $3`,
                    [req.cantidad_requerida, req.ingrediente_id, restaurantId]
                );
            }

            // 5. Calcular detalle
            const detallesData = data.items.map(item => {
                const unitPrice = priceMap.get(item.receta_id)!;
                const subtotal = Number((unitPrice * item.cantidad).toFixed(2));
                return {
                    receta_id: item.receta_id,
                    cantidad: item.cantidad,
                    precio_unitario: unitPrice,
                    subtotal: subtotal,
                    notas: item.notas || null,
                    restaurante_id: restaurantId
                };
            });

            const subtotal = Number(detallesData.reduce((acc, curr) => acc + curr.subtotal, 0).toFixed(2));
            const impuestos = Number((subtotal * taxRate).toFixed(2));
            const total = Number((subtotal + impuestos).toFixed(2));

            // 6. Validar pagos
            let totalPagado = 0;
            if (data.pagos && data.pagos.length > 0) {
                totalPagado = data.pagos.reduce((acc, p) => acc + p.monto, 0);
            }
            const estado_cuenta = (totalPagado >= total) ? "pagada" : "abierta";

            // 7. Crear Pedido
            const codigo = await generateOrderCode(restaurantId);
            const pedido = qr.manager.create(Pedido, {
                codigo,
                mesa_id: data.mesa_id || null,
                mesero_id: null, // operaciones.meseros es independiente de core.usuarios
                cliente: data.cliente || null,
                estado: "pendiente", // Se envía a cocina como pendiente
                estado_cuenta,
                subtotal,
                descuento: 0,
                impuestos,
                total,
                restaurante_id: restaurantId
            });
            await qr.manager.save(pedido);

            // 8. Insertar Detalle
            const detallesEntities = detallesData.map(d => qr.manager.create(PedidoDetalle, { ...d, pedido_id: pedido.id }));
            await qr.manager.save(detallesEntities);

            // 9. Ocupar mesa si hay y no está pagada
            if (data.mesa_id) {
                const estadoMesa = estado_cuenta === 'pagada' ? 'libre' : 'ocupada';
                await qr.manager.update(Mesa, { id: data.mesa_id }, { estado: estadoMesa });
            }

            // 10. Registrar transacciones de pago si las hay (Tabla: operaciones.transacciones_pago)
            if (data.pagos && data.pagos.length > 0) {
                const metodosIds = data.pagos.map(p => p.metodo_pago_id);
                const dbMetodos: any[] = await qr.manager.query(`SELECT id, nombre FROM core.metodos_pago WHERE id = ANY($1)`, [metodosIds]);
                
                for (const pago of data.pagos) {
                    const foundMetodo = dbMetodos.find(m => m.id === pago.metodo_pago_id);
                    let enumVal = 'efectivo'; // por defecto
                    if (foundMetodo) {
                        const nom = foundMetodo.nombre.toLowerCase();
                        if (nom.includes('móvil') || nom.includes('movil') || nom.includes('zelle')) enumVal = 'pago_movil';
                        else if (nom.includes('tarjeta') || nom.includes('punto')) enumVal = 'tarjeta';
                        else if (nom.includes('divisa') || nom.includes('dólar') || nom.includes('dolar')) enumVal = 'divisa';
                    }

                    await qr.manager.query(
                        `INSERT INTO operaciones.transacciones_pago 
                        (pedido_id, metodo, monto, referencia, tasa_cambio, usuario_id, restaurante_id) 
                        VALUES ($1, $2, $3, $4, $5, $6, $7)`,
                        [pedido.id, enumVal, pago.monto, pago.referencia || null, 1.0, userId, restaurantId]
                    );
                }
            }

            // 11. Integración Contable -> Generar asientos en contabilidad.libro_diario
            const fechaActual = new Date().toISOString().slice(0, 10);
            
            await qr.manager.query(
                `INSERT INTO contabilidad.libro_diario 
                (fecha, descripcion, tipo, debe, haber, referencia_tipo, referencia_id, restaurante_id)
                VALUES 
                ($1, 'Ingreso a Caja/Bancos por Venta', 'venta', $2, 0, 'venta', $3, $4),
                ($1, 'Ingresos por Ventas', 'venta', 0, $2, 'venta', $3, $4),
                ($1, 'Costo de Ventas', 'costo_venta', $5, 0, 'venta', $3, $4),
                ($1, 'Inventario', 'costo_venta', 0, $5, 'venta', $3, $4)`,
                [fechaActual, total, pedido.id, restaurantId, totalCostoVenta]
            );

            await qr.commitTransaction();

            // Notify Kitchen through WebSocket
            broadcastNewOrderToKitchen({ id: pedido.id, codigo: pedido.codigo, restaurante_id: restaurantId });

            return {
                id: pedido.id,
                codigo: pedido.codigo,
                subtotal,
                impuestos,
                total,
                estado_cuenta
            };
        } catch (error) {
            await qr.rollbackTransaction();
            throw error;
        } finally {
            await qr.release();
        }
    }

    // ─── CHECKOUT: Pagar una orden ya existente (estado: listo → pagada) ───
    static async checkoutOrder(pedidoId: number, data: CheckoutOrderInput, restaurantId: number, userId: number) {
        const qr = Conexion.createQueryRunner();
        await qr.connect();
        await qr.startTransaction();

        try {
            // 1. Cargar la orden con sus detalles
            const [pedido] = await qr.manager.query(
                `SELECT p.id, p.estado, p.estado_cuenta, p.total, p.mesa_id, p.subtotal, p.impuestos
                 FROM operaciones.pedidos p
                 WHERE p.id = $1 AND p.restaurante_id = $2`,
                [pedidoId, restaurantId]
            );

            if (!pedido) throw new Error('Pedido no encontrado');
            if (pedido.estado_cuenta === 'pagada') throw new Error('Este pedido ya fue pagado');
            if (!['listo', 'pendiente', 'preparando', 'enviado'].includes(pedido.estado))
                throw new Error('El pedido no tiene un estado válido para cobrar');

            // 2. Validar monto cubierto
            const totalPagado = data.pagos.reduce((acc, p) => acc + p.monto, 0);
            if (totalPagado < Number(pedido.total))
                throw new Error(`Pago insuficiente. Total: ${pedido.total}, Pagado: ${totalPagado.toFixed(2)}`);

            // 3. Resolver metodo_pago_id → enum BD
            const metodosIds = data.pagos.map(p => p.metodo_pago_id);
            const dbMetodos: any[] = await qr.manager.query(
                `SELECT id, nombre FROM core.metodos_pago WHERE id = ANY($1)`, [metodosIds]
            );
            const toEnum = (id: number) => {
                const m = dbMetodos.find(x => x.id === id);
                if (!m) return 'efectivo';
                const n = m.nombre.toLowerCase();
                if (n.includes('móvil') || n.includes('movil') || n.includes('zelle')) return 'pago_movil';
                if (n.includes('tarjeta') || n.includes('punto')) return 'tarjeta';
                if (n.includes('divisa') || n.includes('dólar') || n.includes('dolar') || n.includes('usd')) return 'divisa';
                return 'efectivo';
            };

            // 4. Insertar transacciones de pago
            for (const pago of data.pagos) {
                await qr.manager.query(
                    `INSERT INTO operaciones.transacciones_pago
                     (pedido_id, metodo, monto, referencia, tasa_cambio, usuario_id, restaurante_id)
                     VALUES ($1, $2, $3, $4, 1.0, $5, $6)`,
                    [pedidoId, toEnum(pago.metodo_pago_id), pago.monto, pago.referencia || null, userId, restaurantId]
                );
            }

            // 5. Marcar pedido como pagado y entregado
            await qr.manager.query(
                `UPDATE operaciones.pedidos
                 SET estado = 'entregado', estado_cuenta = 'pagada', updated_at = NOW()
                 WHERE id = $1 AND restaurante_id = $2`,
                [pedidoId, restaurantId]
            );

            // 6. Liberar la mesa si la hay
            if (pedido.mesa_id) {
                await qr.manager.query(
                    `UPDATE operaciones.mesas SET estado = 'libre', updated_at = NOW()
                     WHERE id = $1 AND restaurante_id = $2`,
                    [pedido.mesa_id, restaurantId]
                );
            }

            // 7. Asientos contables
            const fecha = new Date().toISOString().slice(0, 10);
            await qr.manager.query(
                `INSERT INTO contabilidad.libro_diario
                 (fecha, descripcion, tipo, debe, haber, referencia_tipo, referencia_id, restaurante_id)
                 VALUES
                 ($1, 'Cobro de Pedido - Caja', 'venta', $2, 0, 'venta', $3, $4),
                 ($1, 'Ingresos por Ventas', 'venta', 0, $2, 'venta', $3, $4)`,
                [fecha, pedido.total, pedidoId, restaurantId]
            );

            await qr.commitTransaction();

            return {
                pedido_id: pedidoId,
                total: pedido.total,
                total_pagado: totalPagado,
                vuelto: Number((totalPagado - Number(pedido.total)).toFixed(2)),
                estado: 'entregado',
                estado_cuenta: 'pagada'
            };
        } catch (error) {
            await qr.rollbackTransaction();
            throw error;
        } finally {
            await qr.release();
        }
    }

    static async closeCashRegister(data: CashClosureInput, restaurantId: number, userId: number) {
        const qr = Conexion.createQueryRunner();
        await qr.connect();
        await qr.startTransaction();

        try {
            // Se calcula el monto_teorico a partir de las transacciones_pago de los pedidos creados en la última caja abierta
            // Este es un bosquejo para insertar la caja en finanzas.caja
            const result = await qr.manager.query(
                `INSERT INTO finanzas.caja 
                (fecha_apertura, fecha_cierre, monto_inicial, monto_final, monto_teorico, diferencia, estado, usuario_apertura_id, usuario_cierre_id, observaciones, restaurante_id)
                VALUES (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 0, $1, $1, 0, 'cerrada', $2, $2, $3, $4)`,
                [data.monto_final, userId, data.observaciones || null, restaurantId]
            );

            await qr.commitTransaction();
            return { caja_id: result[0]?.id, status: "Caja cerrada exitosamente" };
        } catch (error) {
            await qr.rollbackTransaction();
            throw error;
        } finally {
            await qr.release();
        }
    }
}