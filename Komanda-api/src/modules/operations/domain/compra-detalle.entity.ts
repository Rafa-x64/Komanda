import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from "typeorm";
import { Compra } from "./compra.entity";

@Entity({ name: "compra_detalle", schema: "inventario" })
export class CompraDetalle {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "int" })
    compra_id!: number;

    @Column({ type: "int" })
    ingrediente_id!: number;

    @Column({ type: "numeric", precision: 10, scale: 3, transformer: { to: (val) => val, from: (val) => parseFloat(val) } })
    cantidad_compra!: number;

    @Column({ type: "int" })
    unidad_compra_id!: number;

    @Column({ type: "numeric", precision: 10, scale: 2, transformer: { to: (val) => val, from: (val) => parseFloat(val) } })
    precio_unitario!: number;

    @Column({ type: "numeric", precision: 10, scale: 3, transformer: { to: (val) => val, from: (val) => parseFloat(val) } })
    factor_conversion!: number;

    @Column({ type: "int" })
    restaurante_id!: number;

    @ManyToOne(() => Compra, (compra) => compra.detalles)
    @JoinColumn({ name: "compra_id" })
    compra!: Compra;
}
