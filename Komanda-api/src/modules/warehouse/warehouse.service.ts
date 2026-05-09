import { Conexion } from "../../config/database";
import { Ingrediente } from "../inventory/inventory.model";
import type { CreateIngredientInput, StockAdjustmentInput } from "./warehouse.validator";

export class WarehouseService {
  private repo = Conexion.getRepository(Ingrediente);

  async getAll(restauranteId: number) {
    const rows = await Conexion.query(
      `SELECT
        i.id,
        i.nombre,
        i.cantidad_disponible,
        i.cantidad_minima,
        i.costo_promedio,
        i.merma_teorica_porcentaje,
        i.unidad_id,
        u.abreviatura AS unidad_nombre,
        (i.cantidad_disponible <= i.cantidad_minima) AS alerta_critica
       FROM inventario.ingredientes i
       LEFT JOIN core.unidad_medida u ON u.id = i.unidad_id
       WHERE i.restaurante_id = $1
       ORDER BY i.nombre ASC`,
      [restauranteId]
    );
    return rows;
  }

  async getUnidades() {
    return Conexion.query(
      `SELECT id, nombre, abreviatura FROM core.unidad_medida ORDER BY nombre ASC`
    );
  }

  async create(data: CreateIngredientInput, restauranteId: number) {
    const existe = await this.repo.createQueryBuilder("i")
      .where("LOWER(i.nombre) = LOWER(:nombre)", { nombre: data.nombre })
      .andWhere("i.restaurante_id = :restauranteId", { restauranteId })
      .getOne();
    if (existe) throw new Error(`Ya existe un ingrediente llamado "${data.nombre}"`);

    const nuevo = this.repo.create({
      nombre: data.nombre,
      unidad_id: data.unidad_id,
      cantidad_minima: data.cantidad_minima,
      merma_teorica_porcentaje: data.merma_teorica_porcentaje,
      cantidad_disponible: data.cantidad_disponible ?? 0,
      costo_promedio: data.costo_promedio ?? 0,
      restaurante_id: restauranteId,
    });
    return await this.repo.save(nuevo);
  }

  async update(id: number, data: StockAdjustmentInput, restauranteId: number) {
    const ingrediente = await this.repo.findOne({ where: { id, restaurante_id: restauranteId } });
    if (!ingrediente) throw new Error("Ingrediente no encontrado");

    if (data.nombre && data.nombre.toLowerCase() !== ingrediente.nombre.toLowerCase()) {
      const existe = await this.repo.createQueryBuilder("i")
        .where("LOWER(i.nombre) = LOWER(:nombre)", { nombre: data.nombre })
        .andWhere("i.restaurante_id = :restauranteId", { restauranteId })
        .andWhere("i.id != :id", { id })
        .getOne();
      
      if (existe) {
        throw new Error(`Ya existe otro ingrediente con el nombre "${data.nombre}"`);
      }
    }

    Object.assign(ingrediente, data);
    return await this.repo.save(ingrediente);
  }

  async delete(id: number, restauranteId: number) {
    const ingrediente = await this.repo.findOne({ where: { id, restaurante_id: restauranteId } });
    if (!ingrediente) throw new Error("Ingrediente no encontrado");

    // Eliminar dependencias primero para evitar error de foreign key
    await Conexion.query(`DELETE FROM inventario.compra_detalle WHERE ingrediente_id = $1`, [id]);
    await Conexion.query(`DELETE FROM inventario.mermas WHERE ingrediente_id = $1`, [id]);

    await this.repo.remove(ingrediente);
    return true;
  }
}
