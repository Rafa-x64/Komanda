import { Request, Response } from "express";
import { TablesService } from "./tables.service";
import { createTableSchema, updateTableSchema } from "./tables.validator";

export class TablesController {
    static async getAll(req: Request, res: Response) {
        try {
            const tables = await TablesService.getTables(req.user!.restaurantId);
            res.status(200).json({ status: "success", data: tables });
        } catch (error: any) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }

    static async getById(req: Request, res: Response) {
        try {
            const tableId = Number(req.params.id);
            const table = await TablesService.getTableById(req.user!.restaurantId, tableId);
            
            if (!table) {
                return res.status(404).json({ status: "error", message: "Mesa no encontrada" });
            }
            res.status(200).json({ status: "success", data: table });
        } catch (error: any) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }

    static async create(req: Request, res: Response) {
        try {
            const validatedData = createTableSchema.parse(req.body);
            
            const newTable = await TablesService.createTable(req.user!.restaurantId, validatedData);
            res.status(201).json({ status: "success", data: newTable });
        } catch (error: any) {
            if (error.name === 'ZodError') {
                return res.status(400).json({ status: "error", message: error.errors[0].message });
            }
            res.status(400).json({ status: "error", message: error.message });
        }
    }

    static async update(req: Request, res: Response) {
        try {
            const tableId = Number(req.params.id);
            const validatedData = updateTableSchema.parse(req.body);
            
            const updatedTable = await TablesService.updateTable(req.user!.restaurantId, tableId, validatedData);
            res.status(200).json({ status: "success", data: updatedTable });
        } catch (error: any) {
            if (error.name === 'ZodError') {
                return res.status(400).json({ status: "error", message: error.errors[0].message });
            }
            res.status(400).json({ status: "error", message: error.message });
        }
    }

    static async delete(req: Request, res: Response) {
        try {
            const tableId = Number(req.params.id);
            
            await TablesService.deleteTable(req.user!.restaurantId, tableId);
            res.status(200).json({ status: "success", message: "Mesa eliminada correctamente" });
        } catch (error: any) {
            res.status(400).json({ status: "error", message: error.message });
        }
    }
}
