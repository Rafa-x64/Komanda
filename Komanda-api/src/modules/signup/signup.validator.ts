import { z } from "zod";

export const signupSchema = z.object({
    restaurant: z.object({
        name: z.string().min(2, "Nombre del restaurante muy corto"),
        phone: z.string().optional(),
        address: z.string().optional(),
        email: z.string().email("Correo del restaurante no válido").optional().or(z.literal("")),
        currency: z.string().default("USD"),
        zone: z.string().default("America/Caracas"),
        tax: z.coerce.string().optional(),  // input type="number" manda number, lo convertimos a string
        tip: z.coerce.string().optional(),  // input type="number" manda number, lo convertimos a string
        restaurantLogo: z.string().optional(),
    }),
    admin: z.object({
        name: z.string().min(2, "Nombre del administrador muy corto"),
        userName: z.string().min(3, "El nombre de usuario debe tener al menos 3 caracteres"),
        email: z.string().email("Correo del administrador no válido"),
        password: z.string().min(6, "La contraseña debe tener al menos 6 caracteres"),
        confirmPassword: z.string(),
    }),
}).refine((data) => data.admin.password === data.admin.confirmPassword, {
    message: "Las contraseñas no coinciden",
    path: ["admin", "confirmPassword"],
});

export type SignupInput = z.infer<typeof signupSchema>;
