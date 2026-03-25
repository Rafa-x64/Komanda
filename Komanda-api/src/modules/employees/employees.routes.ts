import { Router } from "express";
import { EmployeesController } from "./employees.controller";
import { authMiddleware, requireRole } from "../../shared/middleware/auth.middleware";

export const employeesRouter = Router();

employeesRouter.get("/seed-roles", EmployeesController.seedRoles);

// Todas las rutas de empleados requieren auth + rol admin
employeesRouter.use(authMiddleware, requireRole("admin"));

employeesRouter.get("/", EmployeesController.list);
employeesRouter.get("/roles", EmployeesController.getRoles);
employeesRouter.post("/", EmployeesController.create);
employeesRouter.put("/:id", EmployeesController.update);
employeesRouter.delete("/:id", EmployeesController.remove);
