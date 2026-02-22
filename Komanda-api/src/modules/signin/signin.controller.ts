import { Request, Response } from "express";
import { SignInSchema } from "./signin.validator";
import { SignInService } from "./signin.service";

export const SignInController = {
    async login(req: Request, res: Response) {
        // Validar entrada con Zod
        const parsed = SignInSchema.safeParse(req.body);
        if (!parsed.success) {
            return res.status(400).json({
                status: "error",
                message: "Datos inválidos",
                errors: parsed.error.flatten().fieldErrors,
            });
        }

        try {
            const { user, restaurant } = await SignInService(parsed.data);
            return res.status(200).json({
                status: "success",
                message: "Inicio de sesión exitoso",
                user: { id: user.id, nombre: user.nombre, username: user.username, email: user.email },
                restaurant: { id: restaurant.id, nombre: restaurant.nombre },
            });
        } catch (error: unknown) {
            console.error("❌ Error en login:", error);
            const message = error instanceof Error ? error.message : "Error al iniciar sesión";
            return res.status(401).json({ status: "error", message });
        }
    }
};
