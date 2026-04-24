import { Entity, PrimaryGeneratedColumn, Column, OneToMany, CreateDateColumn, UpdateDateColumn } from "typeorm";
import { PedidoDetalle } from "./pedido-detalle.entity";

@Entity({ name: "pedidos", schema: "operaciones" })
export class Pedido {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "varchar", length: 20, unique: true })
    codigo!: string;

    @Column({ type: "int", nullable: true })
    mesa_id!: number | null;

    @Column({ type: "int", nullable: true })
    mesero_id!: number | null;

    @Column({ type: "varchar", length: 100, nullable: true })
    cliente!: string | null;

    @Column({ type: "enum", enum: ["pendiente", "enviado", "preparando", "listo", "pagado", "completado", "anulado"], default: "pendiente" })
    estado!: string;

    @Column({ type: "enum", enum: ["abierta", "cuenta_pedida", "pagada", "cerrada"], default: "abierta" })
    estado_cuenta!: string;



    @Column({ type: "timestamp", default: () => "CURRENT_TIMESTAMP" })
    fecha_hora!: Date;

    @Column({ type: "decimal", precision: 12, scale: 2, default: 0 })
    subtotal!: number;

    @Column({ type: "decimal", precision: 12, scale: 2, default: 0 })
    descuento!: number;

    @Column({ type: "decimal", precision: 12, scale: 2, default: 0 })
    impuestos!: number;

    @Column({ type: "decimal", precision: 12, scale: 2, default: 0 })
    total!: number;

    @Column({ type: "int" })
    restaurante_id!: number;

    @CreateDateColumn({ type: "timestamp" })
    created_at!: Date;

    @UpdateDateColumn({ type: "timestamp" })
    updated_at!: Date;

    @OneToMany(() => PedidoDetalle, (d) => d.pedido, { cascade: true })
    detalles!: PedidoDetalle[];
}
