import { Router } from "express";
import { ReportsController } from "./reports.controller";
import { authMiddleware, requireRole } from "../../shared/middleware/auth.middleware";

export const reportsRouter = Router();

// Todas las rutas de reportes requieren auth + rol admin
reportsRouter.use(authMiddleware, requireRole("admin"));

reportsRouter.get("/overview", ReportsController.getOverview);
reportsRouter.get("/", ReportsController.getReport);
