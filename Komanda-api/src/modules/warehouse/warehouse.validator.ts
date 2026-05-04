import { z } from "zod";

export const CreateIngredientSchema = z.object({
  nombre: z.string().min(2, "El nombre debe tener al menos 2 caracteres").max(100),
  unidad_id: z.number().int().positive("La unidad de medida es requerida"),
  cantidad_minima: z.number().min(0, "El stock mínimo no puede ser negativo").default(0),
  merma_teorica_porcentaje: z.number().min(0).max(100, "El porcentaje no puede superar 100").default(0),
});

export const StockAdjustmentSchema = z.object({
  nombre: z.string().min(2).max(100).optional(),
  unidad_id: z.number().int().positive().optional(),
  cantidad_minima: z.number().min(0).optional(),
  merma_teorica_porcentaje: z.number().min(0).max(100).optional(),
});

export type CreateIngredientInput = z.infer<typeof CreateIngredientSchema>;
export type StockAdjustmentInput = z.infer<typeof StockAdjustmentSchema>;
