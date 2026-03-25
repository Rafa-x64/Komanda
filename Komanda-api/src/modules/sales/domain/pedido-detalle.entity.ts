import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from "typeorm";
import { Pedido } from "./pedido.entity";

@Entity({ name: "pedido_detalle", schema: "operaciones" })
export class PedidoDetalle {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "int" })
    pedido_id!: number;

    @Column({ type: "int" })
    receta_id!: number;

    @Column({ type: "int" })
    cantidad!: number;

    @Column({ type: "decimal", precision: 10, scale: 2 })
    precio_unitario!: number;

    @Column({ type: "decimal", precision: 10, scale: 2 })
    subtotal!: number;

    @Column({ type: "text", nullable: true })
    notas!: string | null;

    @Column({ type: "int" })
    restaurante_id!: number;

    @ManyToOne(() => Pedido, (p) => p.detalles)
    @JoinColumn({ name: "pedido_id" })
    pedido!: Pedido;
}
