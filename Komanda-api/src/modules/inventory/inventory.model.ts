import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn, OneToMany } from "typeorm";

@Entity({ name: "categorias", schema: "inventory" })
export class CategoriaIngrediente {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "varchar", length: 100 })
    nombre!: string;
}

@Entity({ name: "unidad_medida", schema: "core" })
export class UnidadMedida {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "varchar", length: 20 })
    nombre!: string;

    @Column({ type: "varchar", length: 5 })
    abreviatura!: string;
}

@Entity({ name: "ingredientes", schema: "inventario" })
export class Ingrediente {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "varchar", length: 100 })
    nombre!: string;

    @Column({ type: "decimal", precision: 10, scale: 3, default: 0 })
    cantidad_disponible!: number;

    @Column({ type: "decimal", precision: 10, scale: 3, default: 0 })
    cantidad_minima!: number;

    @Column({ type: "int" })
    unidad_id!: number;

    @Column({ type: "decimal", precision: 10, scale: 2, default: 0 })
    costo_promedio!: number;

    @Column({ type: "decimal", precision: 5, scale: 2, default: 0 })
    merma_teorica_porcentaje!: number;

    @Column({ type: "int" })
    restaurante_id!: number;
    
    // Agregados según lo acordado:
    @Column({ type: "int", nullable: true })
    categoria_id!: number | null;

    @Column({ type: "date", nullable: true })
    fecha_caducidad!: Date | null;

    @CreateDateColumn({ type: "timestamp" })
    created_at!: Date;

    @UpdateDateColumn({ type: "timestamp" })
    updated_at!: Date;

    // Relaciones
    @ManyToOne(() => CategoriaIngrediente)
    @JoinColumn({ name: "categoria_id" })
    categoria!: CategoriaIngrediente;

    @ManyToOne(() => UnidadMedida)
    @JoinColumn({ name: "unidad_id" })
    unidad!: UnidadMedida;
}

@Entity({ name: "compras", schema: "inventario" })
export class Compra {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "date" })
    fecha!: Date;

    @Column({ type: "varchar", length: 50, nullable: true })
    numero_factura_proveedor!: string | null;

    @Column({ type: "decimal", precision: 12, scale: 2 })
    total!: number;

    @Column({ type: "varchar", length: 50, default: 'pagada' })
    estado_pago!: string;

    @Column({ type: "decimal", precision: 12, scale: 2, default: 0 })
    saldo_pendiente!: number;

    @Column({ type: "varchar", length: 255, nullable: true })
    descripcion!: string | null;

    @Column({ type: "int", nullable: true })
    proveedor_id!: number | null;

    @Column({ type: "int" })
    restaurante_id!: number;

    @CreateDateColumn({ type: "timestamp" })
    created_at!: Date;
    
    @OneToMany(() => CompraDetalle, detalle => detalle.compra, { cascade: true })
    detalles!: CompraDetalle[];
}

@Entity({ name: "compra_detalle", schema: "inventario" })
export class CompraDetalle {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "int" })
    compra_id!: number;

    @Column({ type: "int" })
    ingrediente_id!: number;

    @Column({ type: "decimal", precision: 10, scale: 3 })
    cantidad_compra!: number;

    @Column({ type: "int" })
    unidad_compra_id!: number;

    @Column({ type: "decimal", precision: 10, scale: 2 })
    precio_unitario!: number;

    @Column({ type: "decimal", precision: 10, scale: 3 })
    factor_conversion!: number;

    @Column({ type: "int" })
    restaurante_id!: number;

    @ManyToOne(() => Compra, compra => compra.detalles)
    @JoinColumn({ name: "compra_id" })
    compra!: Compra;
}
