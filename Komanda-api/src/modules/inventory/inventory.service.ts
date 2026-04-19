import { Conexion } from "../../config/database";
import { Ingrediente } from "./inventory.model";
import { Merma } from "./domain/merma.entity";
import { UpdateIngredientInput, CreateMermaInput } from "./inventory.validator";

export class InventoryService {
  private repository = Conexion.getRepository(Ingrediente);

  // 1. Obtener inventario con unidad
  async getAllByRestaurant(restauranteId: number) {
    return await Conexion.query(
      `SELECT 
        ingrediente.id AS id,
        ingrediente.nombre AS nombre,
        ingrediente.cantidad_disponible AS cantidad_disponible,
        ingrediente.cantidad_minima AS cantidad_minima,
        ingrediente.costo_promedio AS costo_promedio,
        unidad.abreviatura AS unidad_nombre
       FROM inventario.ingredientes ingrediente
       LEFT JOIN core.unidad_medida unidad ON unidad.id = ingrediente.unidad_id
       WHERE ingrediente.restaurante_id = $1
       ORDER BY ingrediente.nombre ASC`,
      [restauranteId]
    );
  }

  // 2. Actualizar ingrediente (ajustes básicos)
  async updateIngredient(id: number, data: UpdateIngredientInput, restauranteId: number) {
    const ingrediente = await this.repository.findOne({ where: { id, restaurante_id: restauranteId } });
    if (!ingrediente) throw new Error("Ingrediente no encontrado");

    Object.assign(ingrediente, data);
    await this.repository.save(ingrediente);
    return ingrediente;
  }

  // 3. Obtener Mermas
  async getMermas(restauranteId: number) {
    return await Conexion.query(
      `SELECT 
        merma.id AS id,
        merma.cantidad AS cantidad,
        merma.tipo AS tipo,
        merma.razon AS razon,
        merma.created_at AS created_at,
        ingrediente.nombre AS ingrediente_nombre,
        ingrediente.costo_promedio AS costo_promedio
       FROM inventario.mermas merma
       INNER JOIN inventario.ingredientes ingrediente ON ingrediente.id = merma.ingrediente_id
       WHERE merma.restaurante_id = $1
       ORDER BY merma.created_at DESC`,
      [restauranteId]
    );
  }

  // 4. Crear Merma (Ajuste Negativo) con asiento contable
  async createMerma(data: CreateMermaInput, restauranteId: number, userId: number) {
    const queryRunner = Conexion.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
        const ingrediente = await queryRunner.manager.findOne(Ingrediente, {
            where: { id: data.ingrediente_id, restaurante_id: restauranteId }
        });

        if (!ingrediente) throw new Error("Ingrediente no encontrado");

        const stockActual = Number(ingrediente.cantidad_disponible);
        const cantidadMerma = Number(data.cantidad);

        if (stockActual < cantidadMerma) {
            throw new Error(`Stock insuficiente. Solo hay ${stockActual} disponible.`);
        }

        // Restar stock
        ingrediente.cantidad_disponible = stockActual - cantidadMerma;
        await queryRunner.manager.save(ingrediente);

        // Crear registro de Merma
        const mermaRepo = queryRunner.manager.getRepository(Merma);
        const merma = mermaRepo.create({
            ...data,
            reportado_por: userId,
            restaurante_id: restauranteId
        });
        await mermaRepo.save(merma);

        // Crear Asiento Contable (Opcional pero recomendado para robustez)
        // DEBE: Pérdida por Merma | HABER: Inventario de Insumos
        const costoTotalMerma = cantidadMerma * Number(ingrediente.costo_promedio);
        
        if (costoTotalMerma > 0) {
            const fechaActual = new Date().toISOString().slice(0, 10);
            await queryRunner.manager.query(
                `INSERT INTO contabilidad.libro_diario 
                (fecha, descripcion, tipo, debe, haber, referencia_tipo, referencia_id, restaurante_id)
                VALUES 
                ($1, $2, 'ajuste_inventario', $3, 0, 'merma', $4, $5),
                ($1, $6, 'ajuste_inventario', 0, $3, 'merma', $4, $5)`,
                [
                  fechaActual,
                  `Pérdida por merma (${data.tipo}): ${ingrediente.nombre}`,
                  costoTotalMerma,
                  merma.id,
                  restauranteId,
                  `Salida de inventario: ${ingrediente.nombre}`
                ]
              );
        }

        await queryRunner.commitTransaction();
        return { success: true, message: "Merma registrada y stock actualizado", data: merma };
    } catch (error) {
        await queryRunner.rollbackTransaction();
        throw error;
    } finally {
        await queryRunner.release();
    }
  }
}
