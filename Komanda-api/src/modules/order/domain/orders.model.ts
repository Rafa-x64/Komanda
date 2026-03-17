import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    OneToMany,
    CreateDateColumn,
    UpdateDateColumn,
} from "typeorm";
import { OrderItem } from "./order-items.model";

export enum OrderStatus {
    PENDING = "pending",
    PREPARING = "preparing",
    READY = "ready",
    DELIVERED = "delivered",
    CANCELLED = "cancelled",
}

@Entity({ name: "orders", schema: "sales" })
export class Order {
    @PrimaryGeneratedColumn("uuid")
    id!: string;

    @Column({ type: "int" })
    restaurant_id!: number;

    @Column({ type: "int" })
    user_id!: number;

    @Column({ type: "int", nullable: true })
    table_id!: number | null;

    @Column({ type: "enum", enum: OrderStatus, default: OrderStatus.PENDING })
    status!: OrderStatus;

    @Column({ type: "decimal", precision: 10, scale: 2, default: 0 })
    subtotal!: number;

    @Column({ type: "decimal", precision: 10, scale: 2, default: 0 })
    tax_amount!: number;

    @Column({ type: "decimal", precision: 10, scale: 2, default: 0 })
    total_amount!: number;

    @Column({ type: "varchar", length: 255, nullable: true })
    notes!: string | null;

    @CreateDateColumn({ type: "timestamp" })
    created_at!: Date;

    @UpdateDateColumn({ type: "timestamp" })
    updated_at!: Date;

    @OneToMany(() => OrderItem, (item: OrderItem) => item.order, { cascade: true })
    items!: OrderItem[];
}
