import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    ManyToOne,
    JoinColumn,
    CreateDateColumn,
} from "typeorm";
import { Order } from "./orders.model";

@Entity({ name: "order_items", schema: "sales" })
export class OrderItem {
    @PrimaryGeneratedColumn("uuid")
    id!: string;

    @Column({ type: "uuid" })
    order_id!: string;

    @Column({ type: "int" })
    product_id!: number;

    @Column({ type: "int" })
    quantity!: number;

    /** Precio snapshot en el momento de la venta (historial) */
    @Column({ type: "decimal", precision: 10, scale: 2 })
    unit_price!: number;

    @Column({ type: "decimal", precision: 10, scale: 2 })
    subtotal!: number;

    @Column({ type: "varchar", length: 255, nullable: true })
    notes!: string | null;

    @CreateDateColumn({ type: "timestamp" })
    created_at!: Date;

    @ManyToOne(() => Order, (order) => order.items)
    @JoinColumn({ name: "order_id" })
    order!: Order;
}
