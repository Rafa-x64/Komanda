import { Request, Response } from "express";
import { OperationsService } from "./operations.service";
import { createProveedorSchema, updateProveedorSchema, createCompraSchema, createGastoSchema } from "./operations.validator";

export class OperationsController {
    // ==========================================
    // PROVEEDORES
    // ==========================================
    static async getProveedores(req: Request, res: Response) {
        try {
            const result = await OperationsService.getProveedores(req.user!.restaurantId);
            res.json({ status: "success", data: result });
        } catch (error: any) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }

    static async getUnidadesCompra(req: Request, res: Response) {
        try {
            const result = await OperationsService.getUnidadesCompra(req.user!.restaurantId);
            res.json({ status: "success", data: result });
        } catch (error: any) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }

    static async createProveedor(req: Request, res: Response) {
        try {
            const data = createProveedorSchema.parse(req.body);
            const result = await OperationsService.createProveedor(data, req.user!.restaurantId);
            res.status(201).json({ status: "success", data: result });
        } catch (error: any) {
            res.status(400).json({ status: "error", message: error.errors || error.message });
        }
    }

    static async updateProveedor(req: Request, res: Response) {
        try {
            const data = updateProveedorSchema.parse(req.body);
            const result = await OperationsService.updateProveedor(Number(req.params.id), data, req.user!.restaurantId);
            res.json({ status: "success", data: result });
        } catch (error: any) {
            res.status(400).json({ status: "error", message: error.errors || error.message });
        }
    }

    // ==========================================
    // GASTOS OPERATIVOS
    // ==========================================
    static async getGastos(req: Request, res: Response) {
        try {
            const result = await OperationsService.getGastos(req.user!.restaurantId);
            res.json({ status: "success", data: result });
        } catch (error: any) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }

    static async createGasto(req: Request, res: Response) {
        try {
            const data = createGastoSchema.parse(req.body);
            const result = await OperationsService.createGasto(data, req.user!.restaurantId, req.user!.userId);
            res.status(201).json({ status: "success", data: result });
        } catch (error: any) {
            res.status(400).json({ status: "error", message: error.errors || error.message });
        }
    }

    // ==========================================
    // COMPRAS
    // ==========================================
    static async getCompras(req: Request, res: Response) {
        try {
            const result = await OperationsService.getCompras(req.user!.restaurantId);
            res.json({ status: "success", data: result });
        } catch (error: any) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }

    static async createCompra(req: Request, res: Response) {
        try {
            const data = createCompraSchema.parse(req.body);
            const result = await OperationsService.createCompra(data, req.user!.restaurantId);
            res.status(201).json({ status: "success", data: result });
        } catch (error: any) {
            res.status(400).json({ status: "error", message: error.errors || error.message });
        }
    }

    // ==========================================
    // SEED DATA
    // ==========================================
    static async seedOperationsData(req: Request, res: Response) {
        try {
            const restaurantId = req.user!.restaurantId;
            const provs = await OperationsService.getProveedores(restaurantId);
            
            if (provs.length === 0) {
                await OperationsService.createProveedor({
                    identificacion: "J-12345678-9",
                    nombre: "Distribuidora de Alimentos Polar",
                    telefono: "0212-555-1234",
                    email: "ventas@polar.com",
                    direccion: "Caracas, Venezuela",
                    banco_nombre: "Banesco",
                    banco_cuenta_numero: "0134-XXXX-XXXX-XXXX"
                }, restaurantId);

                await OperationsService.createProveedor({
                    identificacion: "J-98765432-1",
                    nombre: "Hortalizas El Campo",
                    telefono: "0414-555-4321",
                    email: "contacto@elcampo.com",
                    direccion: "Mercado Mayorista"
                }, restaurantId);
            }

            res.json({ status: "success", message: "Datos seed generados correctamente" });
        } catch (error: any) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
}
