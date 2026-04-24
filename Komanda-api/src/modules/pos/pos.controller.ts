import { Request, Response } from "express";
import { POSService } from "./pos.service";
import { CreateSaleSchema, CashClosureSchema, CheckoutOrderSchema } from "./pos.validator";
import { ZodError } from "zod";

export class POSController {
    static async getCategories(req: Request, res: Response): Promise<void> {
        try {
            const { restaurantId } = (req as any).user;
            const categories = await POSService.getCategories(restaurantId);
            res.status(200).json({ status: "success", data: categories });
        } catch (error: any) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }

    static async getProducts(req: Request, res: Response): Promise<void> {
        try {
            const { restaurantId } = (req as any).user;
            const recipes = await POSService.getProducts(restaurantId);
            res.status(200).json({ status: "success", data: recipes });
        } catch (error: any) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }

    static async getTables(req: Request, res: Response): Promise<void> {
        try {
            const { restaurantId } = (req as any).user;
            const mesas = await POSService.getTables(restaurantId);
            res.status(200).json({ status: "success", data: mesas });
        } catch (error: any) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }

    static async getPaymentMethods(req: Request, res: Response): Promise<void> {
        try {
            const { restaurantId } = (req as any).user;
            const methods = await POSService.getPaymentMethods(restaurantId);
            res.status(200).json({ status: "success", data: methods });
        } catch (error: any) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }

    static async getSales(req: Request, res: Response): Promise<void> {
        try {
            const { restaurantId } = (req as any).user;
            const sales = await POSService.getSales(restaurantId);
            res.status(200).json({ status: "success", data: sales });
        } catch (error: any) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }

    // Pedidos listos para pagar (Cola del cajero)
    static async getReadyOrders(req: Request, res: Response): Promise<void> {
        try {
            const { restaurantId } = (req as any).user;
            const orders = await POSService.getReadyOrders(restaurantId);
            res.status(200).json({ status: "success", data: orders });
        } catch (error: any) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }

    static async checkoutOrder(req: Request, res: Response): Promise<void> {
        try {
            const payload = CheckoutOrderSchema.parse(req.body);
            const { restaurantId, userId } = (req as any).user;
            const pedidoId = Number(req.params.id);
            const result = await POSService.checkoutOrder(pedidoId, payload, restaurantId, userId);
            res.status(200).json({ status: "success", data: result });
        } catch (error: any) {
            if (error?.constructor?.name === 'ZodError') {
                res.status(400).json({ status: "fail", message: error.message });
            } else {
                res.status(error.message.includes('no encontrado') || error.message.includes('ya fue pagado') ? 422 : 500)
                   .json({ status: "error", message: error.message });
            }
        }
    }

    static async getActiveOrders(req: Request, res: Response): Promise<void> {
        try {
            const { restaurantId } = (req as any).user;
            const orders = await POSService.getActiveOrders(restaurantId);
            res.status(200).json({ status: "success", data: orders });
        } catch (error: any) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }

    static async updateOrderStatus(req: Request, res: Response): Promise<void> {
        try {
            const { restaurantId } = (req as any).user;
            const pedidoId = Number(req.params.id);
            const { estado } = req.body;
            if (!estado) {
                res.status(400).json({ status: "error", message: "El estado es requerido" });
                return;
            }
            const updated = await POSService.updateOrderStatus(pedidoId, estado, restaurantId);
            res.status(200).json({ status: "success", data: updated });
        } catch (error: any) {
            res.status(400).json({ status: "error", message: error.message });
        }
    }

    static async createSale(req: Request, res: Response): Promise<void> {
        try {
            const payload = CreateSaleSchema.parse(req.body);
            const { restaurantId, userId } = (req as any).user;

            const sale = await POSService.createSale(payload, restaurantId, userId);
            res.status(201).json({ status: "success", data: sale });
        } catch (error: any) {
            if (error instanceof ZodError) {
                res.status(400).json({ status: "fail", message: "Error de validación", details: error.issues });
            } else {
                res.status(500).json({ status: "error", message: error.message });
            }
        }
    }

    static async closeCashRegister(req: Request, res: Response): Promise<void> {
        try {
            const payload = CashClosureSchema.parse(req.body);
            const { restaurantId, id: userId } = (req as any).user;

            const closure = await POSService.closeCashRegister(payload, restaurantId, userId);
            res.status(200).json({ status: "success", data: closure });
        } catch (error: any) {
            if (error instanceof ZodError) {
                res.status(400).json({ status: "fail", message: "Error de validación", details: error.issues });
            } else {
                res.status(500).json({ status: "error", message: error.message });
            }
        }
    }

    static async getCashReport(req: Request, res: Response): Promise<void> {
        try {
            const { restaurantId } = (req as any).user;
            const report = await POSService.getCashReport(restaurantId);
            res.status(200).json({ status: "success", data: report });
        } catch (error: any) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
}
