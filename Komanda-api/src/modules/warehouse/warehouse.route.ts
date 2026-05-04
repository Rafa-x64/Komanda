import { Router } from "express";
import { WarehouseController } from "./warehouse.controller";

export const warehouseRouter = Router();

warehouseRouter.get("/", WarehouseController.list);
warehouseRouter.get("/unidades", WarehouseController.getUnidades);
warehouseRouter.post("/", WarehouseController.create);
warehouseRouter.patch("/:id", WarehouseController.update);
