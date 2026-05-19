import { Request, Response } from "express";
import { ZodError } from "zod";
import { WarehouseService } from "./warehouse.service";
import { CreateIngredientSchema, StockAdjustmentSchema } from "./warehouse.validator";

const service = new WarehouseService();

export class WarehouseController {
  private static getRestaurantId(req: Request, res: Response): number | null {
    const id = (req as any).user?.restaurantId;
    if (!id) {
      res.status(401).json({ status: "error", message: "Token sin restaurante válido. Vuelve a iniciar sesión." });
      return null;
    }
    return Number(id);
  }

  static async list(req: Request, res: Response): Promise<void> {
    try {
      const restauranteId = WarehouseController.getRestaurantId(req, res);
      if (!restauranteId) return;
      const data = await service.getAll(restauranteId);
      res.json({ status: "success", data });
    } catch (error: unknown) {
      const msg = error instanceof Error ? error.message : "Error interno";
      res.status(500).json({ status: "error", message: msg });
    }
  }

  static async getUnidades(_req: Request, res: Response): Promise<void> {
    try {
      const data = await service.getUnidades();
      res.json({ status: "success", data });
    } catch (error: unknown) {
      const msg = error instanceof Error ? error.message : "Error interno";
      res.status(500).json({ status: "error", message: msg });
    }
  }

  static async create(req: Request, res: Response): Promise<void> {
    try {
      const payload = CreateIngredientSchema.parse(req.body);
      const restauranteId = WarehouseController.getRestaurantId(req, res);
      if (!restauranteId) return;
      const data = await service.create(payload, restauranteId);
      res.status(201).json({ status: "success", data });
    } catch (error: unknown) {
      if (error instanceof ZodError) {
        res.status(400).json({ status: "error", message: "Datos inválidos", errors: error.issues.map(e => e.message) });
      } else {
        const msg = error instanceof Error ? error.message : "Error al crear";
        res.status(400).json({ status: "error", message: msg });
      }
    }
  }

  static async update(req: Request, res: Response): Promise<void> {
    try {
      const payload = StockAdjustmentSchema.parse(req.body);
      const restauranteId = WarehouseController.getRestaurantId(req, res);
      if (!restauranteId) return;
      const data = await service.update(Number(req.params.id), payload, restauranteId);
      res.json({ status: "success", data });
    } catch (error: unknown) {
      if (error instanceof ZodError) {
        res.status(400).json({ status: "error", message: "Datos inválidos", errors: error.issues.map(e => e.message) });
      } else {
        const msg = error instanceof Error ? error.message : "Error al actualizar";
        res.status(400).json({ status: "error", message: msg });
      }
    }
  }

  static async delete(req: Request, res: Response): Promise<void> {
    try {
      const restauranteId = WarehouseController.getRestaurantId(req, res);
      if (!restauranteId) return;
      await service.delete(Number(req.params.id), restauranteId);
      res.json({ status: "success", message: "Ingrediente eliminado" });
    } catch (error: unknown) {
      const msg = error instanceof Error ? error.message : "Error al eliminar";
      res.status(400).json({ status: "error", message: msg });
    }
  }
}
