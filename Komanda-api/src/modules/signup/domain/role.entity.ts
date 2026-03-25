import { Entity, PrimaryGeneratedColumn, Column } from "typeorm";

@Entity({ name: "roles", schema: "core" })
export class Role {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "varchar", length: 50, unique: true })
    nombre!: string;

    @Column({ type: "timestamp", default: () => "CURRENT_TIMESTAMP" })
    created_at!: Date;
}
