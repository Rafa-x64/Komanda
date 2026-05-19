import { Router } from "express";
import { WarehouseController } from "./warehouse.controller";
import { authMiddleware } from "../../shared/middleware/auth.middleware";

export const warehouseRouter = Router();

warehouseRouter.use(authMiddleware);

warehouseRouter.get("/", WarehouseController.list);
warehouseRouter.get("/unidades", WarehouseController.getUnidades);
warehouseRouter.post("/", WarehouseController.create);
warehouseRouter.patch("/:id", WarehouseController.update);
warehouseRouter.delete("/:id", WarehouseController.delete);
