import { Router } from "express";
import { POSController } from "./pos.controller";
import { authMiddleware } from "../../shared/middleware/auth.middleware";

export const posRouter = Router();

// Todas las rutas de POS requieren autenticación (y proveen userId y restaurantId)
posRouter.use(authMiddleware);

// Catálogos e información
posRouter.get("/categories", POSController.getCategories);
posRouter.get("/products", POSController.getProducts);
posRouter.get("/tables", POSController.getTables);

// Operaciones principales POS
posRouter.post("/sales", POSController.createSale);
posRouter.post("/cash-closures", POSController.closeCashRegister);
