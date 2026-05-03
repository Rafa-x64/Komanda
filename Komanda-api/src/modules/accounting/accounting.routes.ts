import { Router } from "express";
import { AccountingController } from "./accounting.controller";
import { authMiddleware, requireRole } from "../../shared/middleware/auth.middleware";

export const accountingRouter = Router();

accountingRouter.use(authMiddleware, requireRole("admin"));

accountingRouter.get("/balance-sheet", AccountingController.getBalanceSheet);
