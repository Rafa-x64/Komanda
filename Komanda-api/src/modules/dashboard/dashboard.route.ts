import { Router } from "express";
import { DashboardController } from "./dashboard.controller";
import { authMiddleware, requireRole } from "../../shared/middleware/auth.middleware";

export const dashboardRouter = Router();

dashboardRouter.use(authMiddleware);

// Admin
dashboardRouter.get("/admin/stats", requireRole("admin"), DashboardController.adminStats);

// Cocina (KDS)
dashboardRouter.get("/kitchen/orders", requireRole("admin", "cocina"), DashboardController.kitchenOrders);

// Mesero
dashboardRouter.get("/waiter/tables", requireRole("admin", "mesero"), DashboardController.waiterTables);
dashboardRouter.get("/waiter/stats", requireRole("admin", "mesero"), DashboardController.waiterStats);
