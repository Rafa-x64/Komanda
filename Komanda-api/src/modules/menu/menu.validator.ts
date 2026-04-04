import { z } from "zod";

export const CreateRecipeSchema = z.object({
    nombre: z.string().min(2, "Nombre muy corto"),
    descripcion: z.string().optional(),
    categoria_id: z.number().nullable().optional(),
    imagen_url: z.string().optional(),
    precio_venta: z.number().min(0),
    activo: z.boolean().default(true),
});

export type CreateRecipeInput = z.infer<typeof CreateRecipeSchema>;

export const UpdateRecipeSchema = CreateRecipeSchema.partial();
export type UpdateRecipeInput = z.infer<typeof UpdateRecipeSchema>;

export const CreateCategorySchema = z.object({
    nombre: z.string().min(2)
});
export type CreateCategoryInput = z.infer<typeof CreateCategorySchema>;
