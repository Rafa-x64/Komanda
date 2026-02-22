import { Entity, PrimaryGeneratedColumn, Column } from "typeorm";

@Entity({ name: "roles", schema: "core" })
export class Role {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "varchar", length: 50 })
    nombre!: string;

    @Column({ type: "int" })
    restaurante_id!: number;

    @Column({ type: "timestamp", default: () => "CURRENT_TIMESTAMP" })
    created_at!: Date;
}
