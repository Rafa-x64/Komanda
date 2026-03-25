import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET || "komanda_secret_key_2026";

export interface AuthPayload {
    userId: number;
    restaurantId: number;
    role: string;
}

declare global {
    namespace Express {
        interface Request {
            user?: AuthPayload;
        }
    }
}

export const authMiddleware = (req: Request, res: Response, next: NextFunction) => {
    const header = req.headers.authorization;
    if (!header?.startsWith("Bearer ")) {
        return res.status(401).json({ status: "error", message: "Token no proporcionado" });
    }

    try {
        const token = header.split(" ")[1];
        req.user = jwt.verify(token, JWT_SECRET) as AuthPayload;
        next();
    } catch {
        return res.status(401).json({ status: "error", message: "Token inválido o expirado" });
    }
};

export const requireRole = (...roles: string[]) => {
    return (req: Request, res: Response, next: NextFunction) => {
        if (!req.user || !roles.includes(req.user.role)) {
            return res.status(403).json({ status: "error", message: "No tienes permisos para esta acción" });
        }
        next();
    };
};

export { JWT_SECRET };
