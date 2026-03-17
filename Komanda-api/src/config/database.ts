import { DataSource } from "typeorm";
import { Restaurant } from "../modules/signup/domain/restaurant.entity";
import { User } from "../modules/signup/domain/user.entity";
import { Role } from "../modules/signup/domain/role.entity";
import { Order } from "../modules/order/domain/orders.model";
import { OrderItem } from "../modules/order/domain/order-items.model";

export const Conexion = new DataSource({
    type: "postgres",
    host: "localhost",
    port: 5432,
    username: "postgres",
    password: "postgres",
    database: "Komanda",
    synchronize: false, // OFF: trabajamos contra la BD existente, no creamos tablas
    logging: false,
    entities: [Restaurant, User, Role, Order, OrderItem],
    subscribers: [],
    migrations: [],
});