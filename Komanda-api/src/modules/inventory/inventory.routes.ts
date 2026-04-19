import { Router } from "express";
import { InventoryController } from "./inventory.controller";

export const inventoryRouter = Router();

inventoryRouter.get("/", InventoryController.getInventory);
inventoryRouter.put("/:id", InventoryController.updateIngredient);
inventoryRouter.get("/mermas", InventoryController.getMermas);
inventoryRouter.post("/mermas", InventoryController.createMerma);
