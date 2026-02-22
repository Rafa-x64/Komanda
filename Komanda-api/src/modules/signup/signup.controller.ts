import { Request, Response } from "express";
import { signupSchema } from "./signup.validator";
import { SignupService } from "./signup.service";

export const SignupController = {
    async register(req: Request, res: Response) {
        try {
            // 1. Validar entrada con Zod
            const parseResult = signupSchema.safeParse(req.body);

            if (!parseResult.success) {
                const errors = parseResult.error.issues.map((e) => e.message);
                return res.status(400).json({
                    status: "error",
                    message: "Datos inválidos",
                    errors,
                });
            }

            // 2. Delegar al servicio
            const result = await SignupService.register(parseResult.data);

            // 3. Responder éxito
            return res.status(201).json({
                status: "success",
                data: result,
            });
        } catch (error: unknown) {
            console.error("❌ Error en signup:", error);
            const message = error instanceof Error ? error.message : "Error al registrar";
            return res.status(400).json({
                status: "error",
                message,
            });
        }
    },
};
