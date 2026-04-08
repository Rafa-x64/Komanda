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
      for (const item of items) {
        // Normalizamos fecha_caducidad si viene vacia
        const validExpiryDate = item.expiryDate && item.expiryDate.trim() !== '' ? item.expiryDate : null;
        
        // Buscar ignorando case si es posible, pero TypeORM findOne or ILIKE is better
        // Vamos a usar queryBuilder para case-insensitive search
        let ingredient = await queryRunner.manager.createQueryBuilder(Ingrediente, "ingrediente")
            .where("LOWER(ingrediente.nombre) = LOWER(:nombre)", { nombre: item.name })
            .andWhere("ingrediente.restaurante_id = :restauranteId", { restauranteId })
            .getOne();

        if (ingredient) {
            ingredient.cantidad_disponible = Number(ingredient.cantidad_disponible) + Number(item.quantity);
            ingredient.categoria = item.category || ingredient.categoria;
            if (validExpiryDate) {
              ingredient.fecha_caducidad = validExpiryDate;
            }
            await queryRunner.manager.save(ingredient);
            savedItems.push(ingredient);
        } else {
            ingredient = new Ingrediente();
            ingredient.nombre = item.name;
            ingredient.cantidad_disponible = Number(item.quantity);
            ingredient.cantidad_minima = 5; 
            ingredient.unidad_id = 1; // Default
            ingredient.categoria = item.category || 'General';
            ingredient.fecha_caducidad = validExpiryDate;
            ingredient.restaurante_id = restauranteId;
            await queryRunner.manager.save(ingredient);
            savedItems.push(ingredient);
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
