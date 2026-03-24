import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from "typeorm";

@Entity({ name: "recetas", schema: "menu" })
export class Receta {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "varchar", length: 100 })
    nombre!: string;

    @Column({ type: "text", nullable: true })
    descripcion!: string | null;

    @Column({ type: "int", nullable: true })
    categoria_id!: number | null;

    @Column({ type: "text", nullable: true })
    imagen_url!: string | null;

    @Column({ type: "decimal", precision: 10, scale: 2, default: 0 })
    precio_venta!: number;

    @Column({ type: "boolean", default: true })
    activo!: boolean;

    @Column({ type: "int" })
    restaurante_id!: number;

    @CreateDateColumn({ type: "timestamp" })
    created_at!: Date;

    @UpdateDateColumn({ type: "timestamp" })
    updated_at!: Date;
}
