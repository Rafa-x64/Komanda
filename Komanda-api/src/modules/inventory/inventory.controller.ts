import { Request, Response } from "express";
import { InventoryService } from "./inventory.service";
import { purchaseSchema } from "./inventory.validator";
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

    static async createPurchase(req: Request, res: Response): Promise<void> {
        try {
            // Validacion de Zod
            console.log("REQ BODY LLEGANDO AL CONTROLLER:", req.body);
            const payload = purchaseSchema.parse(req.body);
            const items = payload.items;
            
            const restaurantId = (req as any).user?.restaurante_id || (req as any).user?.restaurantId || 1;
            const result = await inventoryService.registerPurchase(items, restaurantId);
            
            res.status(201).json({ status: "success", data: result });
        } catch (error: any) {
            if (error instanceof ZodError) {
                res.status(400).json({ status: "fail", message: "Error de validación", details: error.issues });
            } else {
                res.status(500).json({ status: "error", message: error.message });
            }
        }
    }
}
