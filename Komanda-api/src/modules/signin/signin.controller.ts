import { Request, Response } from "express";
import jwt from "jsonwebtoken";
import { SignInSchema } from "./signin.validator";
import { SignInService } from "./signin.service";
import { JWT_SECRET } from "../../shared/middleware/auth.middleware";

export const SignInController = {
    async login(req: Request, res: Response) {
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

            // Generar JWT (expira en 8 horas — un turno de trabajo)
            const token = jwt.sign(
                { userId: user.id, restaurantId: restaurant.id, role: user.role },
                JWT_SECRET,
                { expiresIn: "8h" }
            );

            return res.status(200).json({
                status: "success",
                message: "Inicio de sesión exitoso",
                data: {
                    token,
                    user: {
                        id: user.id,
                        nombre: user.nombre,
                        username: user.username,
                        email: user.email,
                        role: user.role,
                    },
                    restaurant: {
                        id: restaurant.id,
                        nombre: restaurant.nombre,
                    },
                },
            });
        } catch (error: unknown) {
            console.error("❌ Error en login:", error);
            const message = error instanceof Error ? error.message : "Error al iniciar sesión";
            return res.status(401).json({ status: "error", message });
        }
    },
};
