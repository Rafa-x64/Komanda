import { Conexion } from "../../config/database";
import { Restaurant } from "../signup/domain/restaurant.entity";
import { User } from "../signup/domain/user.entity";
import bcrypt from "bcrypt";

interface SignInInput {
    username: string;
    password: string;
    restaurantName: string;
}

export const SignInService = async ({ username, password, restaurantName }: SignInInput) => {
    if (!Conexion.isInitialized) {
        throw new Error("La base de datos no está lista. Intenta de nuevo en unos segundos.");
    }

    // Usar manager directamente es más robusto ante discrepancias de metadatos
    const restaurant = await Conexion.manager.findOne(Restaurant, {
        where: { nombre: restaurantName }
    });

    if (!restaurant) throw new Error("Restaurante no encontrado");

    const user = await Conexion.manager.findOne(User, {
        where: { username, restaurante_id: restaurant.id }
    });

    if (!user) throw new Error("Usuario no encontrado");

    const isPasswordValid = await bcrypt.compare(password, user.password_hash);
    if (!isPasswordValid) throw new Error("Contraseña inválida");

    return { user, restaurant };
};