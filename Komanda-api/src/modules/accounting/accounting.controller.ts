import { Request, Response } from "express";
import { AccountingService } from "./accounting.service";
import { DateRangeSchema } from "./accounting.validator";

export class AccountingController {
    static async getVBalanceGeneral(req: Request, res: Response) {
        const parsed = DateRangeSchema.safeParse(req.query);
        if (!parsed.success) {
            return res.status(400).json({ status: "error", errors: parsed.error.flatten().fieldErrors });
        }
        try {
            const restaurantId = (req as any).user.restaurantId;
            const { dateFrom, dateTo } = parsed.data;
            const data = await AccountingService.getBalanceGeneral(restaurantId, dateFrom, dateTo);
            res.status(200).json({ status: "success", data });
        } catch (error: any) {
            console.error("AccountingController.getVBalanceGeneral error:", error);
            res.status(500).json({ status: "error", message: error.message });
        }
    }

    static async getVEstadoResultados(req: Request, res: Response) {
        const parsed = DateRangeSchema.safeParse(req.query);
        if (!parsed.success) {
            return res.status(400).json({ status: "error", errors: parsed.error.flatten().fieldErrors });
        }
        try {
            const restaurantId = (req as any).user.restaurantId;
            const { dateFrom, dateTo } = parsed.data;
            const data = await AccountingService.getEstadoResultados(restaurantId, dateFrom, dateTo);
            res.status(200).json({ status: "success", data });
        } catch (error: any) {
            console.error("AccountingController.getVEstadoResultados error:", error);
            res.status(500).json({ status: "error", message: error.message });
        }
    }

    static async getJournalEntries(req: Request, res: Response) {
        const parsed = DateRangeSchema.safeParse(req.query);
        if (!parsed.success) {
            return res.status(400).json({ status: "error", errors: parsed.error.flatten().fieldErrors });
        }
        try {
            const restaurantId = (req as any).user.restaurantId;
            const { dateFrom, dateTo } = parsed.data;
            const data = await AccountingService.getJournalEntries(restaurantId, dateFrom, dateTo);
            res.status(200).json({ status: "success", data });
        } catch (error: any) {
            console.error("AccountingController.getJournalEntries error:", error);
            res.status(500).json({ status: "error", message: error.message });
        }
    }
}
