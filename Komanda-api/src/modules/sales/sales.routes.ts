import { Router } from "express";
import { SalesController } from "./sales.controller";
import { authMiddleware } from "../../shared/middleware/auth.middleware";

export const salesRouter = Router();

salesRouter.use(authMiddleware);

salesRouter.get("/categories", SalesController.getCategories);
salesRouter.get("/products", SalesController.getProducts);
salesRouter.get("/tables", SalesController.getTables);
salesRouter.post("/orders", SalesController.createOrder);
