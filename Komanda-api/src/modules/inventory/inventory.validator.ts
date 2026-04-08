import { z } from "zod";

export const purchaseItemSchema = z.object({
  name: z.string().min(1, "El nombre del insumo es requerido"),
  quantity: z.number().positive("La cantidad debe ser mayor a 0"),
  unit: z.string().optional().default("Kg"),
  category: z.string().optional(),
  expiryDate: z.string().optional()
});

export const purchaseSchema = z.object({
  items: z.array(purchaseItemSchema).min(1, "Debe enviar al menos un item para registrar compra")
});
