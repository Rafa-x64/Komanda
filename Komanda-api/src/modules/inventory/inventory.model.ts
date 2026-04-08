import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from "typeorm";

@Entity({ schema: "inventario", name: "ingredientes" })
export class Ingrediente {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "varchar", length: 100 })
    nombre!: string;

    @Column({ type: "numeric", precision: 10, scale: 3, default: 0, name: "cantidad_disponible", transformer: { to: (val) => val, from: (val) => parseFloat(val) } })
    cantidad_disponible!: number;

    @Column({ type: "numeric", precision: 10, scale: 3, default: 0, name: "cantidad_minima", transformer: { to: (val) => val, from: (val) => parseFloat(val) } })
    cantidad_minima!: number;

    @Column({ type: "int", name: "unidad_id" })
    unidad_id!: number;

    @Column({ type: "numeric", precision: 10, scale: 2, default: 0, name: "costo_promedio", transformer: { to: (val) => val, from: (val) => parseFloat(val) } })
    costo_promedio!: number;

    @Column({ type: "numeric", precision: 5, scale: 2, default: 0, name: "merma_teorica_porcentaje", transformer: { to: (val) => val, from: (val) => parseFloat(val) } })
    merma_teorica_porcentaje!: number;

    @Column({ type: "int", name: "restaurante_id" })
    restaurante_id!: number;

    @Column({ type: "varchar", length: 100, nullable: true })
    categoria!: string | null;

    @Column({ type: "date", nullable: true, name: "fecha_caducidad" })
    fecha_caducidad!: string | null;

    @CreateDateColumn({ name: "created_at" })
    created_at!: Date;

    @UpdateDateColumn({ name: "updated_at" })
    updated_at!: Date;
}
