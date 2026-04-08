import { Router } from "express";
import { getActiveOrders, updateOrderStatus } from "./kitchen.controller";
import { authMiddleware, requireRole } from "../../shared/middleware/auth.middleware";

export const kitchenRouter = Router();

// Middleware de autenticación global para este router
kitchenRouter.use(authMiddleware);

// Solo usuarios con rol admin o cocina pueden ver la pantalla de KDS 
// Opcionalmente los cajeros si se requiere, pero por enunciado la cocina es para rol 'cocina' o 'admin'
kitchenRouter.get("/", requireRole('admin', 'cocina'), getActiveOrders);

// Endpoint para actualizar estado
kitchenRouter.put("/:id/status", requireRole('admin', 'cocina'), updateOrderStatus);
