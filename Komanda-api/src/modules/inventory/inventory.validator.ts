import { z } from "zod";

export const updateIngredientSchema = z.object({
    nombre: z.string().min(2, "Nombre requerido").max(100).optional(),
    cantidad_minima: z.number().min(0, "La cantidad mínima no puede ser negativa").optional(),
    merma_teorica_porcentaje: z.number().min(0).max(100, "El porcentaje no puede superar 100").optional(),
});

export const createIngredientSchema = z.object({
    nombre: z.string().min(2, "Nombre requerido").max(100),
    cantidad_minima: z.number().min(0, "La cantidad mínima no puede ser negativa").default(0),
    cantidad_disponible: z.number().min(0, "La cantidad disponible no puede ser negativa").default(0),
    unidad_id: z.number().int().positive().default(1),
    costo_promedio: z.number().nonnegative().default(0),
    merma_teorica_porcentaje: z.number().min(0).max(100).default(0),
    unidades_por_paquete: z.number().positive().default(1),
});


export const createMermaSchema = z.object({
    ingrediente_id: z.number().int().positive("ID de ingrediente inválido"),
    cantidad: z.number().positive("La cantidad debe ser mayor a 0"),
    tipo: z.enum(["desperdicio", "vencimiento", "rotura", "otro"], {
        errorMap: () => ({ message: "Tipo de merma no válido" })
    }),
    razon: z.string().min(3, "Debe especificar una razón").max(255).optional().nullable(),
});

export type UpdateIngredientInput = z.infer<typeof updateIngredientSchema>;
export type CreateIngredientInput = z.infer<typeof createIngredientSchema>;
export type CreateMermaInput = z.infer<typeof createMermaSchema>;
