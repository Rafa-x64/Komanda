import { Conexion } from "../../config/database";
import { User } from "../signup/domain/user.entity";
import { Role } from "../signup/domain/role.entity";
import bcrypt from "bcrypt";
import { CreateEmployeeInput, UpdateEmployeeInput } from "./employees.validator";

export const EmployeesService = {
    async list(restaurantId: number) {
        const employees = await Conexion.manager.query(
            `SELECT u.id, u.nombre, u.email, u.username, u.activo, u.rol_id,
                    r.nombre AS rol_nombre, u.created_at
             FROM core.usuarios u
             JOIN core.roles r ON u.rol_id = r.id
             WHERE u.restaurante_id = $1
             ORDER BY u.nombre ASC`,
            [restaurantId]
        );
        return employees;
    },

    async getRoles(restaurantId: number) {
        return Conexion.getRepository(Role).find({
            order: { nombre: "ASC" },
        });
    },

    async create(data: CreateEmployeeInput, restaurantId: number) {
        // Verificar username único
        const existing = await Conexion.manager.findOne(User, {
            where: { username: data.username },
        });
        if (existing) throw new Error("El nombre de usuario ya está en uso");

        // Verificar que el rol existe (ahora roles son globales)
        const role = await Conexion.manager.findOne(Role, {
            where: { id: data.rol_id },
        });
        if (!role) throw new Error("Rol no válido");

        const salt = await bcrypt.genSalt(10);
        const passwordHash = await bcrypt.hash(data.password, salt);

        const user = Conexion.manager.create(User, {
            nombre: data.nombre,
            email: data.email,
            username: data.username,
            password_hash: passwordHash,
            rol_id: data.rol_id,
            restaurante_id: restaurantId,
            activo: true,
        });
        await Conexion.manager.save(user);

        return { id: user.id, nombre: user.nombre, username: user.username, email: user.email, rol: role.nombre };
    },

    async update(id: number, data: UpdateEmployeeInput, restaurantId: number) {
        const user = await Conexion.manager.findOne(User, {
            where: { id, restaurante_id: restaurantId },
        });
        if (!user) throw new Error("Empleado no encontrado");

        if (data.username && data.username !== user.username) {
            const dup = await Conexion.manager.findOne(User, { where: { username: data.username } });
            if (dup) throw new Error("El nombre de usuario ya está en uso");
        }

        if (data.password) {
            const salt = await bcrypt.genSalt(10);
            (data as any).password_hash = await bcrypt.hash(data.password, salt);
            delete (data as any).password;
        }

        await Conexion.manager.update(User, { id, restaurante_id: restaurantId }, data as any);
        return { message: "Empleado actualizado" };
    },

    async remove(id: number, restaurantId: number) {
        const user = await Conexion.manager.findOne(User, {
            where: { id, restaurante_id: restaurantId },
        });
        if (!user) throw new Error("Empleado no encontrado");

        await Conexion.manager.update(User, { id }, { activo: false });
        return { message: "Empleado desactivado" };
    },
};
