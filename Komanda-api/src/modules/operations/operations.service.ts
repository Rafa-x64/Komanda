import { Conexion } from "../../config/database";
import { Proveedor } from "./domain/proveedor.entity";
import { Compra } from "./domain/compra.entity";
import { CompraDetalle } from "./domain/compra-detalle.entity";
import { GastoOperativo } from "./domain/gasto-operativo.entity";
import { CreateProveedorInput, UpdateProveedorInput, CreateCompraInput, CreateGastoInput } from "./operations.validator";
import { AccountingService } from "../accounting/accounting.service";

export class OperationsService {
    // ==========================================
    // PROVEEDORES
    // ==========================================
    static async getProveedores(restaurantId: number) {
        return Conexion.getRepository(Proveedor).find({
            where: { restaurante_id: restaurantId },
            order: { nombre: "ASC" }
        });
    }

    static async getUnidadesCompra(restaurantId: number) {
        return Conexion.query(
            `SELECT id, nombre FROM inventario.unidad_compra WHERE restaurante_id = $1 ORDER BY id`,
            [restaurantId]
        );
    }

    static async createProveedor(data: CreateProveedorInput, restaurantId: number) {
        const repo = Conexion.getRepository(Proveedor);
        
        // Validación robusta: evitar identificaciones duplicadas
        const existente = await repo.findOne({ 
            where: { identificacion: data.identificacion, restaurante_id: restaurantId } 
        });
        if (existente) {
            throw new Error(`Ya existe un proveedor con la identificación ${data.identificacion}`);
        }

        const proveedor = repo.create({ ...data, restaurante_id: restaurantId });
        await repo.save(proveedor);
        return proveedor;
    }

    static async updateProveedor(id: number, data: UpdateProveedorInput, restaurantId: number) {
        const repo = Conexion.getRepository(Proveedor);
        const proveedor = await repo.findOne({ where: { id, restaurante_id: restaurantId } });
        if (!proveedor) throw new Error("Proveedor no encontrado");
        
        if (data.identificacion && data.identificacion !== proveedor.identificacion) {
            const existente = await repo.findOne({ 
                where: { identificacion: data.identificacion, restaurante_id: restaurantId } 
            });
            if (existente) {
                throw new Error(`Ya existe otro proveedor con la identificación ${data.identificacion}`);
            }
        }

        Object.assign(proveedor, data);
        await repo.save(proveedor);
        return proveedor;
    }

    // ==========================================
    // GASTOS OPERATIVOS
    // ==========================================
    static async getGastos(restaurantId: number) {
        return Conexion.getRepository(GastoOperativo).find({
            where: { restaurante_id: restaurantId },
            order: { fecha: "DESC", id: "DESC" },
            take: 100
        });
    }

    static async createGasto(data: CreateGastoInput, restaurantId: number, userId: number) {
        const qr = Conexion.createQueryRunner();
        await qr.connect();
        await qr.startTransaction();

        try {
            const fechaParts = data.fecha.split("-");
            const periodo_anio = parseInt(fechaParts[0]);
            const periodo_mes = parseInt(fechaParts[1]);

            // 1. Crear el gasto en finanzas.gastos_operativos
            const gasto = qr.manager.create(GastoOperativo, {
                ...data,
                periodo_anio,
                periodo_mes,
                usuario_id: userId,
                restaurante_id: restaurantId
            });
            await qr.manager.save(gasto);

            // Buscar cuenta de gasto (auxiliar) y cuenta de caja
            let [cuentaGasto] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE tipo = 'gasto' AND es_auxiliar = true LIMIT 1`);
            if (!cuentaGasto) [cuentaGasto] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE tipo = 'gasto' LIMIT 1`);
            
            let [cuentaCaja] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE codigo = '1.1.01' LIMIT 1`);
            if (!cuentaCaja) [cuentaCaja] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE nombre ILIKE '%caja%' LIMIT 1`);
            
            if (!cuentaGasto || !cuentaCaja) {
                throw new Error("No se encontraron las cuentas contables necesarias (Gasto o Caja) para registrar el asiento.");
            }

            await AccountingService.registrarAsientoContable(
                data.fecha,
                `Gasto Operativo: ${data.categoria.toUpperCase()}${data.descripcion ? ' - ' + data.descripcion : ''}`,
                'gasto_operativo',
                [
                    { cuenta_id: cuentaGasto.id, tipo_movimiento: 'debe', monto: data.monto, descripcion: 'Registro de Gasto' },
                    { cuenta_id: cuentaCaja.id, tipo_movimiento: 'haber', monto: data.monto, descripcion: 'Pago de Gasto' }
                ],
                restaurantId,
                gasto.id,
                userId,
                qr
            );

            await qr.commitTransaction();
            return gasto;
        } catch (error) {
            await qr.rollbackTransaction();
            throw error;
        } finally {
            await qr.release();
        }
    }

    // ==========================================
    // COMPRAS E INVENTARIO
    // ==========================================
    static async getCompras(restaurantId: number) {
        return Conexion.query(
            `SELECT c.*, p.nombre as proveedor_nombre 
             FROM inventario.compras c 
             LEFT JOIN inventario.proveedores p ON c.proveedor_id = p.id 
             WHERE c.restaurante_id = $1 
             ORDER BY c.fecha DESC, c.id DESC LIMIT 100`,
            [restaurantId]
        );
    }

    static async createCompra(data: CreateCompraInput, restaurantId: number) {
        const qr = Conexion.createQueryRunner();
        await qr.connect();
        await qr.startTransaction();

        try {
            // 1. Calcular total de la compra basado en items
            let totalCompra = 0;
            data.items.forEach(item => {
                totalCompra += item.cantidad_compra * item.precio_unitario;
            });

            // 2. Crear cabecera de compra
            const compra = qr.manager.create(Compra, {
                fecha: data.fecha,
                numero_factura_proveedor: data.numero_factura_proveedor,
                total: totalCompra,
                estado_pago: data.estado_pago,
                saldo_pendiente: data.estado_pago === 'pendiente' ? totalCompra : 0,
                descripcion: data.descripcion,
                proveedor_id: data.proveedor_id,
                restaurante_id: restaurantId
            });
            await qr.manager.save(compra);

            // 3. Procesar items
            for (const item of data.items) {
                let ingredienteId = item.ingrediente_id;

                // Si viene nombre de nuevo ingrediente, crearlo primero
                if (!ingredienteId && item.ingrediente_nombre) {
                    const [newIng] = await qr.manager.query(
                        `INSERT INTO inventario.ingredientes 
                         (nombre, cantidad_disponible, cantidad_minima, unidad_id, costo_promedio, merma_teorica_porcentaje, restaurante_id)
                         VALUES ($1, 0, $6, $2, $3, $4, $5)
                         RETURNING id`,
                        [
                            item.ingrediente_nombre,
                            item.unidad_id ?? 4, // default: Unidades
                            item.precio_unitario,
                            item.merma_teorica_porcentaje ?? 0,
                            restaurantId,
                            item.cantidad_minima ?? 0
                        ]
                    );
                    ingredienteId = newIng.id;
                }

                if (!ingredienteId) continue; // skip si no hay id ni nombre

                // Insertar detalle
                const detalle = qr.manager.create(CompraDetalle, {
                    compra_id: compra.id,
                    ingrediente_id: ingredienteId,
                    cantidad_compra: item.cantidad_compra,
                    unidad_compra_id: item.unidad_compra_id,
                    precio_unitario: item.precio_unitario,
                    factor_conversion: item.factor_conversion,
                    restaurante_id: restaurantId
                });
                await qr.manager.save(detalle);

                const cantidadInventarioAumentada = item.cantidad_compra * item.factor_conversion;
                const costoTotalItem = item.cantidad_compra * item.precio_unitario;

                // Actualizar CPP y stock
                await qr.manager.query(
                    `UPDATE inventario.ingredientes 
                     SET 
                        costo_promedio = CASE 
                            WHEN (cantidad_disponible + $1) > 0 THEN 
                                ((cantidad_disponible * costo_promedio) + $2) / (cantidad_disponible + $1)
                            ELSE costo_promedio 
                        END,
                        cantidad_disponible = cantidad_disponible + $1,
                        updated_at = CURRENT_TIMESTAMP
                     WHERE id = $3 AND restaurante_id = $4`,
                    [cantidadInventarioAumentada, costoTotalItem, ingredienteId, restaurantId]
                );
            }

            // 4. Integración Contable
            // DEBE: Inventario | HABER: Caja (si pagada) o CxP (si pendiente)
            const descripcionCompra = `Compra de mercancía${data.numero_factura_proveedor ? ' Fac: ' + data.numero_factura_proveedor : ''}`;
            const descripcionHaber = data.estado_pago === 'pendiente' ? 'Cuentas por Pagar Proveedores' : 'Salida de Caja/Bancos por Compra';

            let [cuentaInventario] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE codigo = '1.1.03' LIMIT 1`);
            if (!cuentaInventario) [cuentaInventario] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE nombre ILIKE '%inventario%' LIMIT 1`);
            
            let [cuentaCaja] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE codigo = '1.1.01' LIMIT 1`);
            if (!cuentaCaja) [cuentaCaja] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE nombre ILIKE '%caja%' LIMIT 1`);
            
            let [cuentaPorPagar] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE codigo = '2.1.01' LIMIT 1`);
            if (!cuentaPorPagar) [cuentaPorPagar] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE nombre ILIKE '%pagar%' LIMIT 1`);

            const cuentaHaber = data.estado_pago === 'pendiente' ? cuentaPorPagar : cuentaCaja;

            if (!cuentaInventario || !cuentaHaber) {
                throw new Error("No se encontraron las cuentas contables (Inventario, Caja o CxP) para registrar el asiento de la compra.");
            }

            await AccountingService.registrarAsientoContable(
                data.fecha,
                descripcionCompra,
                'compra_insumo',
                [
                    { cuenta_id: cuentaInventario.id, tipo_movimiento: 'debe', monto: totalCompra, descripcion: 'Ingreso al Inventario' },
                    { cuenta_id: cuentaHaber.id, tipo_movimiento: 'haber', monto: totalCompra, descripcion: descripcionHaber }
                ],
                restaurantId,
                compra.id,
                undefined,
                qr
            );

            await qr.commitTransaction();
            return compra;
        } catch (error) {
            await qr.rollbackTransaction();
            throw error;
        } finally {
            await qr.release();
        }
    }
}
