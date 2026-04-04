import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from "typeorm";

@Entity({ name: "mesas", schema: "operaciones" })
export class Mesa {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "int" })
    numero!: number;

    @Column({ type: "varchar", length: 50, nullable: true })
    nombre!: string | null;

    @Column({ type: "int" })
    capacidad!: number;

    @Column({ type: "enum", enum: ["libre", "ocupada", "reservada", "inactiva"], default: "libre" })
    estado!: string;

    @Column({ type: "int" })
    restaurante_id!: number;

    @CreateDateColumn({ type: "timestamp" })
    created_at!: Date;

    @UpdateDateColumn({ type: "timestamp" })
    updated_at!: Date;
}
