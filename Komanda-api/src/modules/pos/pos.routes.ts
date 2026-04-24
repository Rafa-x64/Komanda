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
posRouter.get("/payment-methods", POSController.getPaymentMethods);

// Operaciones principales POS
posRouter.get("/sales", POSController.getSales);
posRouter.post("/sales", POSController.createSale);
posRouter.post("/cash-closures", POSController.closeCashRegister);

// Gestión de pedidos activos (mesero + admin)
posRouter.get("/orders", POSController.getActiveOrders);
posRouter.patch("/orders/:id/status", POSController.updateOrderStatus);

// Cola del cajero y checkout
posRouter.get("/ready-orders", POSController.getReadyOrders);
posRouter.post("/orders/:id/checkout", POSController.checkoutOrder);

