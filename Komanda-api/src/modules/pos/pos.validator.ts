import { z } from "zod";

export const CreateSaleSchema = z.object({
    mesa_id: z.number().int().positive().nullable().optional(),
    cliente: z.string().max(100).nullable().optional(),
    items: z.array(
        z.object({
            receta_id: z.number().int().positive(),
            cantidad: z.number().int().positive(),
            notas: z.string().nullable().optional(),
        })
    ).min(1, "La venta debe tener al menos un artículo"),
    pagos: z.array(
        z.object({
            metodo_pago_id: z.number().int().positive(),
            monto: z.number().positive(),
            referencia: z.string().nullable().optional()
        })
    ).optional(), // opcional si la cuenta queda "abierta"
});

export type CreateSaleInput = z.infer<typeof CreateSaleSchema>;

export const CashClosureSchema = z.object({
    monto_final: z.number().min(0, "El monto final no puede ser negativo"),
    observaciones: z.string().nullable().optional()
});

export type CashClosureInput = z.infer<typeof CashClosureSchema>;
