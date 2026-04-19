import { Router } from "express";
import { OperationsController } from "./operations.controller";
import { authMiddleware, requireRole } from "../../shared/middleware/auth.middleware";

const router = Router();

// Todo el módulo de gestión requiere autenticación y rol de admin o cajero
router.use(authMiddleware);
router.use(requireRole("admin", "cajero"));

// Proveedores
router.get("/proveedores", OperationsController.getProveedores);
router.post("/proveedores", OperationsController.createProveedor);
router.put("/proveedores/:id", OperationsController.updateProveedor);

// Unidades de compra (lookup)
router.get("/unidades-compra", OperationsController.getUnidadesCompra);

// Gastos Operativos
router.get("/gastos", OperationsController.getGastos);
router.post("/gastos", OperationsController.createGasto);

// Compras e Inventario
router.get("/compras", OperationsController.getCompras);
router.post("/compras", OperationsController.createCompra);

// Seed (desarrollo/pruebas)
router.post("/seed", OperationsController.seedOperationsData);

export default router;
