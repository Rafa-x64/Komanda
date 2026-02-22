import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from "typeorm";
import { Restaurant } from "./restaurant.entity";

@Entity({ name: "usuarios", schema: "core" })
export class User {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "int" })
    restaurante_id!: number;

    @Column({ type: "int" })
    rol_id!: number;

    @Column({ type: "varchar", length: 100 })
    nombre!: string;

    @Column({ type: "varchar", length: 100 })
    email!: string;

    @Column({ type: "varchar", length: 50, unique: true })
    username!: string;

    @Column({ type: "varchar", length: 255 })
    password_hash!: string;

    @Column({ type: "boolean", default: true })
    activo!: boolean;

    @Column({ type: "timestamp", default: () => "CURRENT_TIMESTAMP" })
    created_at!: Date;

    @Column({ type: "timestamp", default: () => "CURRENT_TIMESTAMP" })
    updated_at!: Date;

    @ManyToOne(() => Restaurant, (restaurant) => restaurant.usuarios)
    @JoinColumn({ name: "restaurante_id" })
    restaurant!: Restaurant;
}