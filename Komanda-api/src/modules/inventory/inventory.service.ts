import { Conexion } from "../../config/database";
import { Ingrediente } from "./inventory.model";

export class InventoryService {
  private repository = Conexion.getRepository(Ingrediente);

  async getAllByRestaurant(restauranteId: number): Promise<Ingrediente[]> {
    return this.repository.find({
      where: { restaurante_id: restauranteId },
      order: { nombre: "ASC" }
    });
  }

  async registerPurchase(items: any[], restauranteId: number): Promise<any> {
    const queryRunner = Conexion.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      const savedItems = [];
      const fechaActual = new Date().toISOString().slice(0, 10);

      for (const item of items) {
        const validExpiryDate = item.expiryDate && item.expiryDate.trim() !== '' ? item.expiryDate : null;
        const cantidadComprada = Number(item.quantity);
        const precioCompra = Number(item.price || 0);

        let ingredient = await queryRunner.manager
          .createQueryBuilder(Ingrediente, "ingrediente")
          .where("LOWER(ingrediente.nombre) = LOWER(:nombre)", { nombre: item.name })
          .andWhere("ingrediente.restaurante_id = :restauranteId", { restauranteId })
          .getOne();

        if (ingredient) {
          const stockActual = Number(ingredient.cantidad_disponible);
          const cppAnterior = Number(ingredient.costo_promedio);

          // REGLA 1: Cálculo del Costo Promedio Ponderado (CPP)
          const cppNuevo = precioCompra > 0
            ? ((stockActual * cppAnterior) + (cantidadComprada * precioCompra)) / (stockActual + cantidadComprada)
            : cppAnterior;

          ingredient.cantidad_disponible = stockActual + cantidadComprada;
          ingredient.costo_promedio = Number(cppNuevo.toFixed(4));
          ingredient.categoria = item.category || ingredient.categoria;
          if (validExpiryDate) ingredient.fecha_caducidad = validExpiryDate;

          await queryRunner.manager.save(ingredient);
          savedItems.push(ingredient);
        } else {
          ingredient = new Ingrediente();
          ingredient.nombre = item.name;
          ingredient.cantidad_disponible = cantidadComprada;
          ingredient.cantidad_minima = 5;
          ingredient.unidad_id = 1;
          ingredient.costo_promedio = precioCompra;
          ingredient.categoria = item.category || 'General';
          ingredient.fecha_caducidad = validExpiryDate;
          ingredient.restaurante_id = restauranteId;

          await queryRunner.manager.save(ingredient);
          savedItems.push(ingredient);
        }

        // REGLA 4: Generar asiento contable automático (Compra de ingrediente)
        // DEBE: Inventario | HABER: Caja/Banco
        const montoCompra = cantidadComprada * precioCompra;
        if (montoCompra > 0) {
          await queryRunner.manager.query(
            `INSERT INTO contabilidad.libro_diario 
            (fecha, descripcion, tipo, debe, haber, referencia_tipo, referencia_id, restaurante_id)
            VALUES 
            ($1, $2, 'compra_insumo', $3, 0, 'ingrediente', $4, $5),
            ($1, $6, 'compra_insumo', 0, $3, 'ingrediente', $4, $5)`,
            [
              fechaActual,
              `Compra de insumo: ${ingredient.nombre}`,
              montoCompra,
              ingredient.id,
              restauranteId,
              `Pago compra: ${ingredient.nombre}`
            ]
          );
        }
      }

      await queryRunner.commitTransaction();
      return { success: true, message: "Compras registradas correctamente", data: savedItems };
    } catch (error) {
      await queryRunner.rollbackTransaction();
      throw new Error("Error al registrar la compra en el inventario");
    } finally {
      await queryRunner.release();
    }
  }
}
