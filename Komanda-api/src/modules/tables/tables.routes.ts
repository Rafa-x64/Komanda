import { Router } from "express";
import { TablesController } from "./tables.controller";
import { authMiddleware, requireRole } from "../../shared/middleware/auth.middleware";

const router = Router();

// Todas las rutas requieren autenticación
router.use(authMiddleware);

// Listar mesas (disponible para admin, mesero, cajero, cocina)
router.get("/", requireRole("admin", "mesero", "cajero", "cocina"), TablesController.getAll);

// Obtener una mesa específica
router.get("/:id", requireRole("admin", "mesero", "cajero"), TablesController.getById);

// Rutas de administración (Crear, Editar, Eliminar)
router.post("/", requireRole("admin"), TablesController.create);
router.put("/:id", requireRole("admin", "mesero", "cajero"), TablesController.update); // Mesero puede actualizar estado
router.delete("/:id", requireRole("admin"), TablesController.delete);

export default router;
