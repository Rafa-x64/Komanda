import { z } from "zod";

export const updateOrderStatusSchema = z.object({
  estado: z.enum(["pendiente", "preparando", "listo"]),
});

export type UpdateOrderStatusInput = z.infer<typeof updateOrderStatusSchema>;
