import { z } from "zod";

const itemSchema = z.object({
    product_id: z.number().int().positive(),
    quantity: z.number().int().positive("La cantidad debe ser al menos 1"),
    notes: z.string().max(255).optional(),
});

export const CreateOrderSchema = z.object({
    table_id: z.number().int().positive().optional(),
    notes: z.string().max(255).optional(),
    items: z.array(itemSchema).min(1, "Debe incluir al menos un producto"),
});

export type CreateOrderInput = z.infer<typeof CreateOrderSchema>;
