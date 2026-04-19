import * as dotenv from "dotenv";
import * as path from "path";
dotenv.config({ path: path.join(__dirname, "../../.env") });
import { DataSource } from "typeorm";
import { Restaurant } from "../modules/signup/domain/restaurant.entity";
import { User } from "../modules/signup/domain/user.entity";
import { Role } from "../modules/signup/domain/role.entity";
import { Pedido } from "../modules/pos/domain/pedido.entity";
import { PedidoDetalle } from "../modules/pos/domain/pedido-detalle.entity";
import { Mesa } from "../modules/pos/domain/mesa.entity";
import { Receta } from "../modules/pos/domain/receta.entity";
import { Categoria } from "../modules/pos/domain/categoria.entity";
import { Ingrediente } from "../modules/inventory/inventory.model";
import { Proveedor } from "../modules/operations/domain/proveedor.entity";
import { Compra } from "../modules/operations/domain/compra.entity";
import { CompraDetalle } from "../modules/operations/domain/compra-detalle.entity";
import { GastoOperativo } from "../modules/operations/domain/gasto-operativo.entity";
import { Merma } from "../modules/inventory/domain/merma.entity";

export const Conexion = new DataSource({
    type: "postgres",
    host: process.env.DB_HOST ?? "localhost",
    port: Number(process.env.DB_PORT ?? 5432),
    username: process.env.DB_USER ?? "postgres",
    password: process.env.DB_PASSWORD ?? "",
    database: process.env.DB_NAME ?? "komanda_db",
    synchronize: false,
    logging: false,
    entities: [Restaurant, User, Role, Pedido, PedidoDetalle, Mesa, Receta, Categoria, Ingrediente, Proveedor, Compra, CompraDetalle, GastoOperativo, Merma],
    subscribers: [],
    migrations: [],
});