import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from "typeorm";

@Entity({ name: "categorias", schema: "menu" })
export class Categoria {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "varchar", length: 50 })
    nombre!: string;

    @Column({ type: "int", default: 0 })
    orden!: number;

    @Column({ type: "boolean", default: true })
    activo!: boolean;

    @Column({ type: "int" })
    restaurante_id!: number;

    @CreateDateColumn({ type: "timestamp" })
    created_at!: Date;

    @UpdateDateColumn({ type: "timestamp" })
    updated_at!: Date;
}
