import { z } from "zod";

export const RecipeIngredientSchema = z.object({
    ingrediente_id: z.coerce.number().int().positive(),
    cantidad: z.coerce.number().positive(),
    unidad: z.string().optional()
});

export const CreateRecipeSchema = z.object({
    nombre: z.string().min(2, "Nombre muy corto"),
    descripcion: z.string().optional(),
    categoria_id: z.coerce.number().nullable().optional(),
    imagen_url: z.string().optional(),
    precio_venta: z.coerce.number().min(0),
    precio_sugerido: z.coerce.number().min(0).optional(),
    costo_produccion: z.coerce.number().min(0).optional(),
    margen_utilidad: z.coerce.number().optional(),
    activo: z.boolean().default(true),
    ingredientes: z.array(RecipeIngredientSchema).optional().default([]),
});

export type CreateRecipeInput = z.infer<typeof CreateRecipeSchema>;

export const UpdateRecipeSchema = CreateRecipeSchema.partial();
export type UpdateRecipeInput = z.infer<typeof UpdateRecipeSchema>;

export const CreateCategorySchema = z.object({
    nombre: z.string().min(2)
});
export type CreateCategoryInput = z.infer<typeof CreateCategorySchema>;
