import { Router } from "express";
import { MenuController } from "./menu.controller";
import { authMiddleware } from "../../shared/middleware/auth.middleware";

export const menuRouter = Router();

menuRouter.use(authMiddleware);

menuRouter.get("/recetas", MenuController.getRecipes);
menuRouter.post("/recetas", MenuController.createRecipe);
menuRouter.put("/recetas/:id", MenuController.updateRecipe);
menuRouter.delete("/recetas/:id", MenuController.deleteRecipe);

menuRouter.get("/categorias", MenuController.getCategories);
menuRouter.post("/categorias", MenuController.createCategory);
