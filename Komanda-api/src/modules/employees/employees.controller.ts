import { Request, Response } from "express";
import { CreateEmployeeSchema, UpdateEmployeeSchema } from "./employees.validator";
import { EmployeesService } from "./employees.service";

export const EmployeesController = {
    async list(req: Request, res: Response) {
        try {
            const data = await EmployeesService.list(req.user!.restaurantId);
            return res.json({ status: "success", data });
        } catch (error: unknown) {
            const msg = error instanceof Error ? error.message : "Error al listar empleados";
            return res.status(500).json({ status: "error", message: msg });
        }
    },

    async getRoles(req: Request, res: Response) {
        try {
            const data = await EmployeesService.getRoles(req.user!.restaurantId);
            return res.json({ status: "success", data });
        } catch (error: unknown) {
            const msg = error instanceof Error ? error.message : "Error al listar roles";
            return res.status(500).json({ status: "error", message: msg });
        }
    },

    async seedRoles(req: Request, res: Response) {
        try {
            const { Conexion } = await import("../../config/database");
            await Conexion.query(`
                INSERT INTO core.roles (nombre, descripcion, restaurante_id)
                VALUES 
                ('cajero', 'Rol de cajero para ventas', 1),
                ('mesero', 'Rol de mesero para pedidos', 1),
                ('cocina', 'Rol de cocina para ordenes', 1)
                ON CONFLICT (nombre) DO NOTHING;
            `);
            return res.json({ status: "success", message: "Roles seeded" });
        } catch (error: unknown) {
            const msg = error instanceof Error ? error.message : "Error";
            return res.status(500).json({ status: "error", message: msg });
        }
    },

    async create(req: Request, res: Response) {
        const parsed = CreateEmployeeSchema.safeParse(req.body);
        if (!parsed.success) {
            return res.status(400).json({
                status: "error",
                message: "Datos inválidos: " + parsed.error.issues.map((e) => e.message).join(", ")
            });
        }
        try {
            const data = await EmployeesService.create(parsed.data, req.user!.restaurantId);
            return res.status(201).json({ status: "success", data });
        } catch (error: unknown) {
            const msg = error instanceof Error ? error.message : "Error al crear empleado";
            return res.status(400).json({ status: "error", message: msg });
        }
    },

    async update(req: Request, res: Response) {
        const parsed = UpdateEmployeeSchema.safeParse(req.body);
        if (!parsed.success) {
            return res.status(400).json({
                status: "error",
                message: "Datos inválidos: " + parsed.error.issues.map((e) => e.message).join(", ")
            });
        }
        try {
            const idParam = typeof req.params.id === 'string' ? req.params.id : req.params.id[0];
            const id = parseInt(idParam as string);
            const data = await EmployeesService.update(id, parsed.data, req.user!.restaurantId);
            return res.json({ status: "success", data });
        } catch (error: unknown) {
            const msg = error instanceof Error ? error.message : "Error al actualizar empleado";
            return res.status(400).json({ status: "error", message: msg });
        }
    },

    async remove(req: Request, res: Response) {
        try {
            const idParam = typeof req.params.id === 'string' ? req.params.id : req.params.id[0];
            const id = parseInt(idParam as string);
            const data = await EmployeesService.remove(id, req.user!.restaurantId);
            return res.json({ status: "success", data });
        } catch (error: unknown) {
            const msg = error instanceof Error ? error.message : "Error al eliminar empleado";
            return res.status(400).json({ status: "error", message: msg });
        }
    },
};
