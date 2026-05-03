import { Request, Response } from "express";
import { DashboardService } from "./dashboard.service";

export const DashboardController = {
    async adminStats(req: Request, res: Response) {
        try {
            const restaurantId = req.user!.restaurantId;
            const data = await DashboardService.getAdminStats(restaurantId);
            return res.json({ status: "success", data });
        } catch (error: unknown) {
            const msg = error instanceof Error ? error.message : "Error en dashboard";
            return res.status(500).json({ status: "error", message: msg });
        }
    },

    async kitchenOrders(req: Request, res: Response) {
        try {
            const restaurantId = req.user!.restaurantId;
            const data = await DashboardService.getKitchenOrders(restaurantId);
            return res.json({ status: "success", data });
        } catch (error: unknown) {
            const msg = error instanceof Error ? error.message : "Error en dashboard";
            return res.status(500).json({ status: "error", message: msg });
        }
    },

    async waiterTables(req: Request, res: Response) {
        try {
            const restaurantId = req.user!.restaurantId;
            const data = await DashboardService.getWaiterTables(restaurantId);
            return res.json({ status: "success", data });
        } catch (error: unknown) {
            const msg = error instanceof Error ? error.message : "Error en dashboard";
            return res.status(500).json({ status: "error", message: msg });
        }
    },

    async waiterStats(req: Request, res: Response) {
        try {
            const restaurantId = req.user!.restaurantId;
            const data = await DashboardService.getWaiterStats(restaurantId);
            return res.json({ status: "success", data });
        } catch (error: unknown) {
            const msg = error instanceof Error ? error.message : "Error en dashboard";
            return res.status(500).json({ status: "error", message: msg });
        }
    },
};
