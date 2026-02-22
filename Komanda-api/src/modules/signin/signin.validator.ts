import { z } from "zod";

export const SignInSchema = z.object({
    username: z.string().min(3, "El nombre de usuario debe tener al menos 3 caracteres"),
    password: z.string().min(3, "La contraseña debe tener al menos 3 caracteres"),
    restaurantName: z.string().min(3, "El nombre del restaurante debe tener al menos 3 caracteres"),
});

export type SignInSchema = z.infer<typeof SignInSchema>;