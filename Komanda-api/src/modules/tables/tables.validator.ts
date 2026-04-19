import { z } from "zod";

export const createTableSchema = z.object({
    numero: z.number().int().positive("El número de mesa debe ser un entero positivo"),
    nombre: z.string().max(50, "El nombre no puede exceder los 50 caracteres").optional().nullable(),
    capacidad: z.number().int().positive("La capacidad debe ser mayor a 0"),
    estado: z.enum(["libre", "ocupada", "reservada", "inactiva"]).default("libre")
});

export const updateTableSchema = z.object({
    numero: z.number().int().positive("El número de mesa debe ser un entero positivo").optional(),
    nombre: z.string().max(50, "El nombre no puede exceder los 50 caracteres").optional().nullable(),
    capacidad: z.number().int().positive("La capacidad debe ser mayor a 0").optional(),
    estado: z.enum(["libre", "ocupada", "reservada", "inactiva"]).optional()
});

export type CreateTableInput = z.infer<typeof createTableSchema>;
export type UpdateTableInput = z.infer<typeof updateTableSchema>;
