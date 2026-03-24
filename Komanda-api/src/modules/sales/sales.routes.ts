import { Router } from "express";
import { SalesController } from "./sales.controller";

export const salesRouter = Router();

salesRouter.get("/categories", SalesController.getCategories);
salesRouter.get("/products", SalesController.getProducts);
salesRouter.get("/tables", SalesController.getTables);
salesRouter.post("/orders", SalesController.createOrder);
