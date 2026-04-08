import { Router } from "express";
import { InventoryController } from "./inventory.controller";

export const inventoryRouter = Router();

inventoryRouter.get("/", InventoryController.getInventory);
inventoryRouter.post("/purchase", InventoryController.createPurchase);
