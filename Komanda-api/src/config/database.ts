import { DataSource } from "typeorm";
import { Restaurant } from "../modules/signup/domain/restaurant.entity";
import { User } from "../modules/signup/domain/user.entity";
import { Role } from "../modules/signup/domain/role.entity";
import { Pedido } from "../modules/sales/domain/pedido.entity";
import { PedidoDetalle } from "../modules/sales/domain/pedido-detalle.entity";
import { Mesa } from "../modules/sales/domain/mesa.entity";
import { Receta } from "../modules/sales/domain/receta.entity";
import { Categoria } from "../modules/sales/domain/categoria.entity";

export const Conexion = new DataSource({
    type: "postgres",
    host: "localhost",
    port: 5432,
    username: "postgres",
    password: "postgres",
    database: "Komanda",
    synchronize: false,
    logging: false,
    entities: [Restaurant, User, Role, Pedido, PedidoDetalle, Mesa, Receta, Categoria],
    subscribers: [],
    migrations: [],
});