import { Request, Response } from "express";
import { InventoryService } from "./inventory.service";
import { updateIngredientSchema, createMermaSchema } from "./inventory.validator";
import { ZodError } from "zod";

const inventoryService = new InventoryService();

export class InventoryController {
    static async getInventory(req: Request, res: Response): Promise<void> {
        try {
            const restaurantId = (req as any).user?.restaurante_id || (req as any).user?.restaurantId || 1;
            const data = await inventoryService.getAllByRestaurant(restaurantId);
            res.status(200).json({ status: "success", data });
        } catch (error: any) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }

    static async updateIngredient(req: Request, res: Response): Promise<void> {
        try {
            const payload = updateIngredientSchema.parse(req.body);
            const restaurantId = (req as any).user?.restaurante_id || (req as any).user?.restaurantId || 1;
            const data = await inventoryService.updateIngredient(Number(req.params.id), payload, restaurantId);
            res.status(200).json({ status: "success", data });
        } catch (error: any) {
            if (error instanceof ZodError) {
                res.status(400).json({ status: "error", message: "Datos inválidos", details: error.issues });
            } else {
                res.status(400).json({ status: "error", message: error.message });
            }
        }
    }

    static async getMermas(req: Request, res: Response): Promise<void> {
        try {
            const restaurantId = (req as any).user?.restaurante_id || (req as any).user?.restaurantId || 1;
            const data = await inventoryService.getMermas(restaurantId);
            res.status(200).json({ status: "success", data });
        } catch (error: any) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }

    static async createMerma(req: Request, res: Response): Promise<void> {
        try {
            const payload = createMermaSchema.parse(req.body);
            const restaurantId = (req as any).user?.restaurante_id || (req as any).user?.restaurantId || 1;
            const userId = (req as any).user?.userId || 1;
            const result = await inventoryService.createMerma(payload, restaurantId, userId);
            
            res.status(201).json({ status: "success", data: result.data });
        } catch (error: any) {
            if (error instanceof ZodError) {
                res.status(400).json({ status: "error", message: "Error de validación", details: error.issues });
            } else {
                res.status(400).json({ status: "error", message: error.message });
            }
        }
    }
}
