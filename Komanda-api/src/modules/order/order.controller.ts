import { Request, Response } from "express";
import { CreateOrderSchema } from "./order.validator";
import { OrderService } from "./order.service";

export const OrderController = {
    async createOrder(req: Request, res: Response) {
        const parsed = CreateOrderSchema.safeParse(req.body);
        if (!parsed.success) {
            const errors = parsed.error.issues.map((e) => e.message);
            return res.status(400).json({ status: "error", message: "Datos inválidos", errors });
        }

        try {
            // TODO: extraer restaurantId y userId del JWT cuando se implemente auth
            const restaurantId: number = req.body.restaurant_id ?? 1;
            const userId: number = req.body.user_id ?? 1;

            const order = await OrderService.processNewOrder(parsed.data, restaurantId, userId);
            return res.status(201).json({ status: "success", data: order });
        } catch (error: unknown) {
            const message = error instanceof Error ? error.message : "Error al procesar la orden";
            return res.status(400).json({ status: "error", message });
        }
    },
};
