import { Conexion } from "../../config/database";
import { Receta } from "../sales/domain/receta.entity";
import { Categoria } from "../sales/domain/categoria.entity";
import { CreateRecipeInput, UpdateRecipeInput, CreateCategoryInput } from "./menu.validator";

export const MenuService = {
    async getRecipes(restaurantId: number) {
        return Conexion.getRepository(Receta).find({
            where: { restaurante_id: restaurantId },
            order: { nombre: "ASC" },
        });
    },

    async getCategories(restaurantId: number) {
        return Conexion.getRepository(Categoria).find({
            where: { restaurante_id: restaurantId },
            order: { orden: "ASC", nombre: "ASC" },
        });
    },

    async createRecipe(data: CreateRecipeInput, restaurantId: number) {
        const repo = Conexion.getRepository(Receta);
        const newRecipe = repo.create({
            ...data,
            restaurante_id: restaurantId,
            precio_venta: data.precio_venta || 0
        });
        return repo.save(newRecipe);
    },

    async updateRecipe(id: number, data: UpdateRecipeInput, restaurantId: number) {
        const repo = Conexion.getRepository(Receta);
        const recipe = await repo.findOne({ where: { id, restaurante_id: restaurantId } });
        if (!recipe) throw new Error("Receta no encontrada");
        
        Object.assign(recipe, data);
        return repo.save(recipe);
    },

    async deleteRecipe(id: number, restaurantId: number) {
        const repo = Conexion.getRepository(Receta);
        const recipe = await repo.findOne({ where: { id, restaurante_id: restaurantId } });
        if (!recipe) throw new Error("Receta no encontrada");
        await repo.remove(recipe);
        return true;
    },

    async createCategory(data: CreateCategoryInput, restaurantId: number) {
        const repo = Conexion.getRepository(Categoria);
        const maxCat = await repo.findOne({ where: { restaurante_id: restaurantId }, order: { orden: "DESC" }});
        const nextOrder = maxCat ? maxCat.orden + 1 : 1;
        const newCat = repo.create({
            ...data,
            orden: nextOrder,
            restaurante_id: restaurantId,
            activo: true
        });
        return repo.save(newCat);
    }
};
