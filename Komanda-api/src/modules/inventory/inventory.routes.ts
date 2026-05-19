import { Router } from "express";
import { InventoryController } from "./inventory.controller";
import { authMiddleware } from "../../shared/middleware/auth.middleware";

export const inventoryRouter = Router();

inventoryRouter.use(authMiddleware);

inventoryRouter.get("/", InventoryController.getInventory);
inventoryRouter.post("/", InventoryController.createIngredient);
inventoryRouter.put("/:id", InventoryController.updateIngredient);
inventoryRouter.get("/mermas", InventoryController.getMermas);
inventoryRouter.post("/mermas", InventoryController.createMerma);
