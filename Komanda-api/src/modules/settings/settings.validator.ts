import { z } from "zod";

export const updateRestaurantSchema = z.object({
  nombre: z.string().min(2, "El nombre debe tener al menos 2 caracteres"),
  direccion: z.string().optional(),
  telefono: z.string().optional(),
  email: z.string().email("Correo inválido").optional().or(z.literal("")),
  moneda: z.string().length(3, "La moneda debe ser 3 caracteres (ej. USD, VES)").optional(),
  impuesto_porcentaje: z.number().min(0, "El impuesto no puede ser menor a 0").optional(),
});

export const updateProfileSchema = z.object({
  nombre: z.string().min(2, "El nombre debe tener al menos 2 caracteres"),
  email: z.string().email("Correo inválido"),
  password: z.string().min(6, "La contraseña debe tener mínimo 6 caracteres").optional().or(z.literal("")),
});
