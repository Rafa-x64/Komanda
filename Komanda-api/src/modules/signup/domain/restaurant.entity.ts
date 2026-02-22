import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { User } from './user.entity';

@Entity({ name: "restaurante", schema: "core" })
export class Restaurant {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "varchar", length: 100 })
    nombre!: string;

    @Column({ type: "text", nullable: true })
    direccion!: string;

    @Column({ type: "varchar", length: 20, nullable: true })
    telefono!: string;

    @Column({ type: "varchar", length: 100, nullable: true })
    email!: string;

    @Column({ type: "text", nullable: true })
    logo_url!: string;

    @Column({ type: "varchar", length: 3, default: "USD" })
    moneda!: string;

    @Column({ type: "varchar", length: 50, default: "America/Caracas" })
    zona_horaria!: string;

    @Column({ type: "decimal", precision: 5, scale: 2, default: 0 })
    impuesto_porcentaje!: number;

    @Column({ type: "decimal", precision: 5, scale: 2, default: 0 })
    propina_porcentaje!: number;

    @Column({ type: "decimal", precision: 12, scale: 2, default: 0 })
    patrimonio_inicial!: number;

    @Column({ type: "boolean", default: true })
    activo!: boolean;

    @Column({ type: "timestamp", default: () => "CURRENT_TIMESTAMP" })
    created_at!: Date;

    @Column({ type: "timestamp", default: () => "CURRENT_TIMESTAMP" })
    updated_at!: Date;

    @OneToMany(() => User, (user) => user.restaurant)
    usuarios!: User[];
}
