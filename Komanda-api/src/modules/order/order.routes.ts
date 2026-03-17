import { Router } from "express";
import { OrderController } from "./order.controller";

export const orderRouter = Router();

// POST /api/v1/orders
orderRouter.post("/", OrderController.createOrder);
