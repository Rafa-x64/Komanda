import { Request, Response } from "express";
import { Conexion } from "../../config/database";
import { Restaurant } from "../signup/domain/restaurant.entity";
import { User } from "../signup/domain/user.entity";
import { updateRestaurantSchema, updateProfileSchema } from "./settings.validator";
import { ZodError } from "zod";
import * as bcrypt from "bcrypt";

export class SettingsController {
  
  static async getRestaurantInfo(req: Request, res: Response): Promise<void> {
    try {
      const restaurantId = (req as any).user?.restaurantId || (req as any).user?.restaurante_id;
      if (!restaurantId) {
         res.status(403).json({ status: "error", message: "Restaurante no identificado" });
         return;
      }

      const info = await Conexion.getRepository(Restaurant).findOne({ where: { id: restaurantId } });
      if (!info) {
         res.status(404).json({ status: "error", message: "Restaurante no existe" });
         return;
      }

      res.status(200).json({ status: "success", data: info });
    } catch (error: any) {
      res.status(500).json({ status: "error", message: error.message });
    }
  }

  static async updateRestaurantInfo(req: Request, res: Response): Promise<void> {
    try {
      const restaurantId = (req as any).user?.restaurantId || (req as any).user?.restaurante_id;
      const role = (req as any).user?.role;
      
      if (role !== 'admin') {
         res.status(403).json({ status: "error", message: "Permisos insuficientes" });
         return;
      }
      
      const validData = updateRestaurantSchema.parse(req.body);
      
      const restaurantRepo = Conexion.getRepository(Restaurant);
      const restaurant = await restaurantRepo.findOne({ where: { id: restaurantId } });
      if (!restaurant) {
          res.status(404).json({ status: "error", message: "Restaurante no encontrado" });
          return;
      }

      restaurant.nombre = validData.nombre;
      if (validData.direccion !== undefined) restaurant.direccion = validData.direccion;
      if (validData.telefono !== undefined) restaurant.telefono = validData.telefono;
      if (validData.email !== undefined) restaurant.email = validData.email;
      if (validData.moneda !== undefined) restaurant.moneda = validData.moneda;
      if (validData.impuesto_porcentaje !== undefined) restaurant.impuesto_porcentaje = Number(validData.impuesto_porcentaje);

      await restaurantRepo.save(restaurant);

      res.status(200).json({ status: "success", message: "Datos actualizados exitosamente", data: restaurant });
    } catch (error: any) {
      if (error instanceof ZodError) {
          res.status(400).json({ status: "fail", message: "Error de validación", details: error.issues });
      } else {
          res.status(500).json({ status: "error", message: error.message });
      }
    }
  }

  static async updateProfile(req: Request, res: Response): Promise<void> {
      try {
        const userId = (req as any).user?.id;
        const validData = updateProfileSchema.parse(req.body);
        
        const userRepo = Conexion.getRepository(User);
        const userFound = await userRepo.findOne({ where: { id: userId } });
        
        if (!userFound) {
           res.status(404).json({ status: "error", message: "Usuario no encontrado" });
           return;
        }

        userFound.nombre = validData.nombre;
        userFound.correo = validData.email;
        
        if (validData.password && validData.password.trim() !== '') {
            userFound.password = await bcrypt.hash(validData.password, 10);
        }

        await userRepo.save(userFound);

        // Retornamos sin exponer la contraseña
        const { password, ...safeUser } = userFound;
        res.status(200).json({ status: "success", message: "Perfil actualizado exitosamente", data: safeUser });
      } catch (error: any) {
          if (error instanceof ZodError) {
              res.status(400).json({ status: "fail", message: "Error de validación", details: error.issues });
          } else {
              res.status(500).json({ status: "error", message: error.message });
          }
      }
  }
}
