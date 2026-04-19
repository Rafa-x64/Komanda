import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from "typeorm";
import { Restaurant } from "../../signup/domain/restaurant.entity";

@Entity({ name: "proveedores", schema: "inventario" })
export class Proveedor {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "varchar", length: 30 })
    identificacion!: string;

    @Column({ type: "varchar", length: 100 })
    nombre!: string;

    @Column({ type: "varchar", length: 20, nullable: true })
    telefono!: string | null;

    @Column({ type: "varchar", length: 100, nullable: true })
    email!: string | null;

    @Column({ type: "text", nullable: true })
    direccion!: string | null;

    @Column({ type: "int" })
    restaurante_id!: number;

    @Column({ type: "varchar", length: 50, nullable: true })
    banco_nombre!: string | null;

    @Column({ type: "varchar", length: 30, nullable: true })
    banco_cuenta_numero!: string | null;

    @Column({ type: "boolean", default: true })
    activo!: boolean;

    @Column({ type: "text", nullable: true })
    observaciones!: string | null;

    @CreateDateColumn({ name: "created_at" })
    created_at!: Date;

    @UpdateDateColumn({ name: "updated_at" })
    updated_at!: Date;
}
