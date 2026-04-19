import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, OneToMany } from "typeorm";
import { CompraDetalle } from "./compra-detalle.entity";

@Entity({ name: "compras", schema: "inventario" })
export class Compra {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "date" })
    fecha!: string;

    @Column({ type: "varchar", length: 50, nullable: true })
    numero_factura_proveedor!: string | null;

    @Column({ type: "numeric", precision: 12, scale: 2, transformer: { to: (val) => val, from: (val) => parseFloat(val) } })
    total!: number;

    @Column({ type: "varchar", default: "pagada" })
    estado_pago!: string; // estado_pago_compra enum

    @Column({ type: "numeric", precision: 12, scale: 2, default: 0, transformer: { to: (val) => val, from: (val) => parseFloat(val) } })
    saldo_pendiente!: number;

    @Column({ type: "varchar", length: 255, nullable: true })
    descripcion!: string | null;

    @Column({ type: "int", nullable: true })
    proveedor_id!: number | null;

    @Column({ type: "int" })
    restaurante_id!: number;

    @CreateDateColumn({ name: "created_at" })
    created_at!: Date;

    @OneToMany(() => CompraDetalle, (detalle) => detalle.compra)
    detalles!: CompraDetalle[];
}
