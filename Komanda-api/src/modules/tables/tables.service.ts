import { Conexion } from "../../config/database";
import { Mesa } from "../pos/domain/mesa.entity";
import { CreateTableInput, UpdateTableInput } from "./tables.validator";

export class TablesService {
    static async getTables(restaurantId: number) {
        return Conexion.getRepository(Mesa).find({
            where: { restaurante_id: restaurantId },
            order: { numero: 'ASC' }
        });
    }

    static async getTableById(restaurantId: number, tableId: number) {
        return Conexion.getRepository(Mesa).findOne({
            where: { id: tableId, restaurante_id: restaurantId }
        });
    }

    static async createTable(restaurantId: number, data: CreateTableInput) {
        const repo = Conexion.getRepository(Mesa);
        
        // Verificar que el número de mesa no exista ya en este restaurante
        const existing = await repo.findOne({ 
            where: { numero: data.numero, restaurante_id: restaurantId } 
        });
        if (existing) {
            throw new Error(`La mesa número ${data.numero} ya existe en este restaurante.`);
        }

        const newTable = repo.create({
            ...data,
            restaurante_id: restaurantId
        });

        return await repo.save(newTable);
    }

    static async updateTable(restaurantId: number, tableId: number, data: UpdateTableInput) {
        const repo = Conexion.getRepository(Mesa);
        
        const table = await repo.findOne({ 
            where: { id: tableId, restaurante_id: restaurantId } 
        });
        
        if (!table) {
            throw new Error('Mesa no encontrada');
        }

        // Si cambia el número, verificar que no colisione
        if (data.numero && data.numero !== table.numero) {
            const existing = await repo.findOne({ 
                where: { numero: data.numero, restaurante_id: restaurantId } 
            });
            if (existing) {
                throw new Error(`La mesa número ${data.numero} ya existe en este restaurante.`);
            }
        }

        repo.merge(table, data);
        return await repo.save(table);
    }

    static async deleteTable(restaurantId: number, tableId: number) {
        const repo = Conexion.getRepository(Mesa);
        
        const table = await repo.findOne({ 
            where: { id: tableId, restaurante_id: restaurantId } 
        });
        
        if (!table) {
            throw new Error('Mesa no encontrada');
        }

        // Podríamos hacer un delete físico o lógico. En este caso un remove físico.
        // NOTA: Si la mesa tiene pedidos asociados, PostgreSQL fallará por Foreign Key si no es ON DELETE CASCADE.
        // Pero en pos/domain/mesa.entity.ts, pedidos.mesa_id referencia a mesas.
        // Si PostgreSQL arroja error de FK, el controlador atrapará el error.
        try {
            await repo.remove(table);
        } catch (e: any) {
            if (e.code === '23503') { // Foreign Key violation
                // Soft delete: cambiar a inactiva
                table.estado = 'inactiva';
                await repo.save(table);
                throw new Error('La mesa tiene pedidos históricos y no puede ser eliminada, se ha marcado como inactiva.');
            }
            throw e;
        }
    }
}
