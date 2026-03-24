import { Request, Response } from "express";
import { CreateOrderSchema } from "./sales.validator";
import { SalesService } from "./sales.service";

export const SalesController = {
    async getCategories(_req: Request, res: Response) {
        try {
            const restaurantId = 1; // TODO: extraer del JWT
            const data = await SalesService.getCategories(restaurantId);
            return res.json({ status: "success", data });
        } catch (error: unknown) {
            const message = error instanceof Error ? error.message : "Error al obtener categorías";
            return res.status(500).json({ status: "error", message });
        }
    },

    async getProducts(_req: Request, res: Response) {
        try {
            const restaurantId = 1; // TODO: extraer del JWT
            const data = await SalesService.getProducts(restaurantId);
            return res.json({ status: "success", data });
        } catch (error: unknown) {
            const message = error instanceof Error ? error.message : "Error al obtener productos";
            return res.status(500).json({ status: "error", message });
        }
    },

    async getTables(_req: Request, res: Response) {
        try {
            const restaurantId = 1; // TODO: extraer del JWT
            const data = await SalesService.getTables(restaurantId);
            return res.json({ status: "success", data });
        } catch (error: unknown) {
            const message = error instanceof Error ? error.message : "Error al obtener mesas";
            return res.status(500).json({ status: "error", message });
        }
    },

    async createOrder(req: Request, res: Response) {
        const parsed = CreateOrderSchema.safeParse(req.body);
        if (!parsed.success) {
            const errors = parsed.error.issues.map((e) => e.message);
            return res.status(400).json({ status: "error", message: "Datos inválidos", errors });
        }

        try {
            const restaurantId = 1; // TODO: extraer del JWT
            const order = await SalesService.createOrder(parsed.data, restaurantId);
            return res.status(201).json({ status: "success", data: order });
        } catch (error: unknown) {
            const message = error instanceof Error ? error.message : "Error al procesar la orden";
            return res.status(400).json({ status: "error", message });
        }
    },
};
