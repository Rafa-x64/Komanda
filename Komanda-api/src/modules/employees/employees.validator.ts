import { z } from "zod";

export const CreateEmployeeSchema = z.object({
    nombre: z.string().min(2, "Nombre muy corto").max(100),
    email: z.string().email("Correo no válido"),
    username: z.string().min(3, "Username muy corto").max(50),
    password: z.string().min(6, "Contraseña mínimo 6 caracteres"),
    rol_id: z.number().int().positive("Debe seleccionar un rol"),
});

export const UpdateEmployeeSchema = z.object({
    nombre: z.string().min(2).max(100).optional(),
    email: z.string().email().optional(),
    username: z.string().min(3).max(50).optional(),
    password: z.string().min(6).optional(),
    rol_id: z.number().int().positive().optional(),
    activo: z.boolean().optional(),
});

export type CreateEmployeeInput = z.infer<typeof CreateEmployeeSchema>;
export type UpdateEmployeeInput = z.infer<typeof UpdateEmployeeSchema>;
