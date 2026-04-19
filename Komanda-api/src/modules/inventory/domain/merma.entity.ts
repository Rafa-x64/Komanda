import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from "typeorm";

@Entity({ schema: "inventario", name: "mermas" })
export class Merma {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "int" })
    ingrediente_id!: number;

    @Column({ type: "numeric", precision: 10, scale: 3, transformer: { to: (val) => val, from: (val) => parseFloat(val) } })
    cantidad!: number;

    @Column({ type: "enum", enum: ["desperdicio", "vencimiento", "rotura", "otro"] })
    tipo!: "desperdicio" | "vencimiento" | "rotura" | "otro";

    @Column({ type: "text", nullable: true })
    razon!: string | null;

    @Column({ type: "int" })
    reportado_por!: number;

    @Column({ type: "int" })
    restaurante_id!: number;

    @CreateDateColumn({ name: "created_at" })
    created_at!: Date;
}
