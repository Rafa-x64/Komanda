import { Conexion } from "../../config/database";
import { Order, OrderStatus } from "./domain/orders.model";
import { OrderItem } from "./domain/order-items.model";
import { Restaurant } from "../signup/domain/restaurant.entity";
import { CreateOrderInput } from "./order.validator";

export const OrderService = {
    async processNewOrder(data: CreateOrderInput, restaurantId: number, userId: number) {
        const qr = Conexion.createQueryRunner();
        await qr.connect();
        await qr.startTransaction();

        try {
            // 1. Obtener impuesto del restaurante
            const restaurant = await qr.manager.findOne(Restaurant, {
                where: { id: restaurantId },
            });
            if (!restaurant) throw new Error("Restaurante no encontrado");

            const taxRate = parseFloat(restaurant.impuesto_porcentaje as unknown as string) / 100;

            // 2. Obtener precios reales de la BD (el frontend no dicta precios)
            const productIds = data.items.map((i) => i.product_id);
            const products: Array<{ id: number; price: number }> = await qr.manager.query(
                `SELECT id, precio AS price FROM inventory.products WHERE id = ANY($1)`,
                [productIds]
            );

            if (products.length !== productIds.length) {
                throw new Error("Uno o más productos no existen o no están disponibles");
            }

            const priceMap = new Map(products.map((p) => [p.id, p.price]));

            // 3. Calcular importes
            const orderItems = data.items.map((item) => {
                const unitPrice = parseFloat(priceMap.get(item.product_id) as unknown as string);
                return {
                    product_id: item.product_id,
                    quantity: item.quantity,
                    unit_price: unitPrice,
                    subtotal: parseFloat((unitPrice * item.quantity).toFixed(2)),
                    notes: item.notes ?? null,
                };
            });

            const subtotal = parseFloat(
                orderItems.reduce((acc, i) => acc + i.subtotal, 0).toFixed(2)
            );
            const taxAmount = parseFloat((subtotal * taxRate).toFixed(2));
            const totalAmount = parseFloat((subtotal + taxAmount).toFixed(2));

            // 4. INSERT order (transacción ACID)
            const order = qr.manager.create(Order, {
                restaurant_id: restaurantId,
                user_id: userId,
                table_id: data.table_id ?? null,
                status: OrderStatus.PENDING,
                subtotal,
                tax_amount: taxAmount,
                total_amount: totalAmount,
                notes: data.notes ?? null,
            });
            await qr.manager.save(order);

            // 5. INSERT order_items referenciando el id de la orden recién creada
            const items = orderItems.map((i) =>
                qr.manager.create(OrderItem, { ...i, order_id: order.id })
            );
            await qr.manager.save(items);

            // TODO: Integración futura — disparar evento a InventoryService
            // para descontar insumos por cada order_item.

            await qr.commitTransaction();

            return { ...order, items };
        } catch (error) {
            await qr.rollbackTransaction();
            throw error;
        } finally {
            await qr.release();
        }
    },
};
