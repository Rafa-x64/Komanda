import { Request, Response } from "express";
import { AccountingService } from "./accounting.service";

export class AccountingController {
    static async getBalanceSheet(req: Request, res: Response) {
        try {
            const restaurantId = (req as any).user.restaurantId;
            const { dateFrom, dateTo } = req.query;

            const data = await AccountingService.getBalanceSheet(
                restaurantId,
                dateFrom as string,
                dateTo as string
            );

            res.status(200).json({
                status: "success",
                data
            });
        } catch (error: any) {
            console.error("AccountingController.getBalanceSheet error:", error);
            res.status(500).json({
                status: "error",
                message: error.message
            });
        }
    }
}
