import { Request, Response } from "express";
import { ReportsService } from "./reports.service";

export class ReportsController {
    static async getReport(req: Request, res: Response): Promise<void> {
        try {
            const { type, dateFrom, dateTo } = req.query;
            const restaurantId = (req as any).user.restaurantId;
            
            if (!type) {
                res.status(400).json({ status: "error", message: "El tipo de reporte es requerido" });
                return;
            }

            const data = await ReportsService.getReportData(
                restaurantId, 
                type as string, 
                dateFrom as string, 
                dateTo as string
            );

            res.status(200).json({ status: "success", data });
        } catch (error: any) {
            console.error("ReportsController.getReport error:", error);
            res.status(500).json({ status: "error", message: error.message });
        }
    }

    static async getOverview(req: Request, res: Response): Promise<void> {
        try {
            const restaurantId = (req as any).user.restaurantId;
            const data = await ReportsService.getDashboardOverview(restaurantId);
            res.status(200).json({ status: "success", data });
        } catch (error: any) {
            console.error("ReportsController.getOverview error:", error);
            res.status(500).json({ status: "error", message: error.message });
        }
    }
}
