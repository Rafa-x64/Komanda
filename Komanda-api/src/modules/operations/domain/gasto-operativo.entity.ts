import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from "typeorm";

@Entity({ name: "gastos_operativos", schema: "finanzas" })
export class GastoOperativo {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "varchar" })
    categoria!: string; // categoria_gasto_enum: 'agua', 'gas', 'electricidad', 'internet', 'alquiler'

    @Column({ type: "varchar", length: 255, nullable: true })
    descripcion!: string | null;

    @Column({ type: "numeric", precision: 12, scale: 2, transformer: { to: (val) => val, from: (val) => parseFloat(val) } })
    monto!: number;

    @Column({ type: "date" })
    fecha!: string;

    @Column({ type: "varchar", default: "efectivo" })
    metodo_pago!: string; // metodo_pago_enum

    @Column({ type: "varchar", length: 100, nullable: true })
    referencia!: string | null;

    @Column({ type: "int", nullable: true })
    periodo_mes!: number | null;

    @Column({ type: "int", nullable: true })
    periodo_anio!: number | null;

    @Column({ type: "int", nullable: true })
    usuario_id!: number | null;

    @Column({ type: "int" })
    restaurante_id!: number;

    @CreateDateColumn({ name: "created_at" })
    created_at!: Date;
}
