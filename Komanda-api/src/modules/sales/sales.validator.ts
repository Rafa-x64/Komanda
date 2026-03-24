import { z } from "zod";

const orderItemSchema = z.object({
    receta_id: z.number().int().positive("receta_id debe ser un entero positivo"),
    cantidad: z.number().int().positive("La cantidad debe ser al menos 1"),
    notas: z.string().max(500).optional().default(""),
});

export const CreateOrderSchema = z.object({
    mesa_id: z.number().int().positive("mesa_id debe ser un entero positivo"),
    items: z.array(orderItemSchema).min(1, "Debe incluir al menos un producto"),
});

export type CreateOrderInput = z.infer<typeof CreateOrderSchema>;
