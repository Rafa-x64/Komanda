import { Request, Response } from "express";
import { MenuService } from "./menu.service";
import { CreateRecipeSchema, UpdateRecipeSchema, CreateCategorySchema } from "./menu.validator";

export const MenuController = {
    async getRecipes(req: Request, res: Response) {
        try {
            const data = await MenuService.getRecipes(req.user!.restaurantId);
            return res.json({ status: "success", data });
        } catch (error: any) {
            return res.status(500).json({ status: "error", message: error.message });
        }
    },
    async getCategories(req: Request, res: Response) {
        try {
            const data = await MenuService.getCategories(req.user!.restaurantId);
            return res.json({ status: "success", data });
        } catch (error: any) {
            return res.status(500).json({ status: "error", message: error.message });
        }
    },
    async createRecipe(req: Request, res: Response) {
        const parsed = CreateRecipeSchema.safeParse(req.body);
        if(!parsed.success) return res.status(400).json({ status: "error", message: "Datos inválidos", errors: parsed.error.issues.map(e => e.message) });
        try {
            const data = await MenuService.createRecipe(parsed.data, req.user!.restaurantId);
            return res.status(201).json({ status: "success", data });
        } catch(error: any) {
            return res.status(400).json({ status: "error", message: error.message });
        }
    },
    async updateRecipe(req: Request, res: Response) {
        const parsed = UpdateRecipeSchema.safeParse(req.body);
        if(!parsed.success) return res.status(400).json({ status: "error", message: "Datos inválidos", errors: parsed.error.issues.map(e => e.message) });
        try {
            const data = await MenuService.updateRecipe(Number(req.params.id), parsed.data, req.user!.restaurantId);
            return res.json({ status: "success", data });
        } catch(error: any) {
            return res.status(400).json({ status: "error", message: error.message });
        }
    },
    async deleteRecipe(req: Request, res: Response) {
        try {
            await MenuService.deleteRecipe(Number(req.params.id), req.user!.restaurantId);
            return res.json({ status: "success", data: null });
        } catch(error: any) {
            return res.status(400).json({ status: "error", message: error.message });
        }
    },
    async createCategory(req: Request, res: Response) {
        const parsed = CreateCategorySchema.safeParse(req.body);
        if(!parsed.success) return res.status(400).json({ status: "error", message: "Datos inválidos", errors: parsed.error.issues.map(e => e.message) });
        try {
            const data = await MenuService.createCategory(parsed.data, req.user!.restaurantId);
            return res.status(201).json({ status: "success", data });
        } catch(error: any) {
            return res.status(400).json({ status: "error", message: error.message });
        }
    }
};
