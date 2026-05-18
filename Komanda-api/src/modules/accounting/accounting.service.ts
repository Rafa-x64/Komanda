import { Conexion } from "../../config/database";

export class AccountingService {
    static async registrarAsientoContable(
        fecha: string | Date,
        descripcion: string,
        tipo_origen: string,
        lineas_debe_haber: Array<{ cuenta_id: number; tipo_movimiento: 'debe' | 'haber'; monto: number; descripcion?: string }>,
        restaurante_id: number,
        origen_id?: number,
        creado_por?: number
    ) {
        // Reglas de Cuadre
        let sumDebe = 0;
        let sumHaber = 0;

        for (const linea of lineas_debe_haber) {
            const m = Number(linea.monto) || 0;
            if (linea.tipo_movimiento === 'debe') {
                sumDebe += m;
            } else if (linea.tipo_movimiento === 'haber') {
                sumHaber += m;
            }
        }

        // Evitar problemas de precisión de coma flotante
        if (Math.abs(sumDebe - sumHaber) > 0.001) {
            throw new Error('Asiento Descuadrado');
        }

        const queryRunner = Conexion.createQueryRunner();
        await queryRunner.connect();
        await queryRunner.startTransaction();

        try {
            // Insertar asiento
            const insertAsientoQuery = `
                INSERT INTO contabilidad.asientos 
                (fecha, descripcion, origen_tipo, origen_id, total_debe, total_haber, restaurante_id, creado_por)
                VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
                RETURNING id
            `;
            const asientoResult = await queryRunner.query(insertAsientoQuery, [
                fecha, descripcion, tipo_origen, origen_id || null, sumDebe, sumHaber, restaurante_id, creado_por || null
            ]);
            const asientoId = asientoResult[0].id;

            // Insertar lineas
            const insertLineaQuery = `
                INSERT INTO contabilidad.asiento_lineas
                (asiento_id, cuenta_id, tipo_movimiento, monto, descripcion, restaurante_id)
                VALUES ($1, $2, $3, $4, $5, $6)
            `;

            for (const linea of lineas_debe_haber) {
                await queryRunner.query(insertLineaQuery, [
                    asientoId,
                    linea.cuenta_id,
                    linea.tipo_movimiento,
                    linea.monto,
                    linea.descripcion || null,
                    restaurante_id
                ]);
            }

            await queryRunner.commitTransaction();
            return asientoId;
        } catch (error) {
            await queryRunner.rollbackTransaction();
            throw error;
        } finally {
            await queryRunner.release();
        }
    }

    static async getBalanceGeneral(restaurante_id: number, dateFrom?: string, dateTo?: string) {
        let query = `
            SELECT 
                tipo,
                codigo,
                cuenta,
                saldo
            FROM contabilidad.v_balance_general
            WHERE restaurante_id = $1
        `;
        const params: any[] = [restaurante_id];

        // Nota: v_balance_general podría requerir un enfoque diferente si el rango de fechas aplica a los asientos, 
        // pero como es una vista, podemos filtrar si expone fecha. La vista v_balance_general en la BD mostrada no parece 
        // exponer fecha de manera sencilla a nivel de vista, sino que pre-calcula los saldos totales. 
        // Si no expone fecha, el filtro de fechas se ignoraría aquí, o habría que hacer el join en la vista.
        // Nos apegamos a la consulta simple solicitada.
        
        query += ` ORDER BY codigo`;
        
        const result = await Conexion.query(query, params);
        return result;
    }

    static async getEstadoResultados(restaurante_id: number, dateFrom?: string, dateTo?: string) {
        let query = `
            SELECT 
                tipo,
                cuenta,
                SUM(monto) as total
            FROM contabilidad.v_estado_resultados
            WHERE restaurante_id = $1
        `;
        const params: any[] = [restaurante_id];

        if (dateFrom && dateTo) {
            query += ` AND fecha BETWEEN $2 AND $3`;
            params.push(dateFrom, dateTo);
        }

        query += ` GROUP BY tipo, cuenta ORDER BY tipo`;

        const result = await Conexion.query(query, params);
        return result;
    }

    static async getJournalEntries(restaurante_id: number, dateFrom?: string, dateTo?: string) {
        // Obtenemos los asientos con sus lineas
        let queryAsientos = `
            SELECT 
                a.id as asiento_id,
                a.fecha,
                a.descripcion,
                a.origen_tipo,
                a.origen_id,
                a.total_debe,
                a.total_haber
            FROM contabilidad.asientos a
            WHERE a.restaurante_id = $1
        `;
        const params: any[] = [restaurante_id];

        if (dateFrom && dateTo) {
            queryAsientos += ` AND a.fecha BETWEEN $2 AND $3`;
            params.push(dateFrom, dateTo);
        }
        
        queryAsientos += ` ORDER BY a.fecha DESC, a.id DESC`;

        const asientosResult = await Conexion.query(queryAsientos, params);
        const asientos = asientosResult;

        if (asientos.length === 0) return [];

        const asientoIds = asientos.map((a: any) => a.asiento_id);

        const queryLineas = `
            SELECT 
                al.asiento_id,
                al.cuenta_id,
                pc.nombre as cuenta_nombre,
                pc.codigo as cuenta_codigo,
                al.tipo_movimiento,
                al.monto,
                al.descripcion
            FROM contabilidad.asiento_lineas al
            JOIN contabilidad.plan_cuentas pc ON pc.id = al.cuenta_id
            WHERE al.asiento_id = ANY($1)
            ORDER BY al.asiento_id, al.tipo_movimiento DESC, al.id
        `;
        const lineasResult = await Conexion.query(queryLineas, [asientoIds]);
        
        const lineasByAsiento: Record<number, any[]> = {};
        lineasResult.forEach((linea: any) => {
            if (!lineasByAsiento[linea.asiento_id]) {
                lineasByAsiento[linea.asiento_id] = [];
            }
            lineasByAsiento[linea.asiento_id].push(linea);
        });

        return asientos.map((a: any) => ({
            ...a,
            lineas: lineasByAsiento[a.asiento_id] || []
        }));
    }

    static async getBalanceSheet(restaurantId: number, dateFrom?: string, dateTo?: string) {
        // Mantener este método por compatibilidad con código existente (si es necesario)
        let query = `
            SELECT 
                tipo,
                SUM(debe) as total_debe,
                SUM(haber) as total_haber
            FROM contabilidad.libro_diario
            WHERE restaurante_id = $1
        `;
        const params: any[] = [restaurantId];

        if (dateFrom && dateTo) {
            query += ` AND fecha BETWEEN $2 AND $3`;
            params.push(dateFrom, dateTo);
        }

        query += ` GROUP BY tipo`;

        const movements = await Conexion.query(query, params);

        const balances: Record<string, { debe: number, haber: number }> = {};
        movements.forEach((m: any) => {
            balances[m.tipo] = {
                debe: parseFloat(m.total_debe),
                haber: parseFloat(m.total_haber)
            };
        });

        const getBalance = (tipo: string) => balances[tipo] || { debe: 0, haber: 0 };

        const venta = getBalance('venta');
        const costoVenta = getBalance('costo_venta');
        const gasto = getBalance('gasto_operativo');
        const compra = getBalance('compra_insumo');

        const cashBalance = venta.debe - (compra.haber + gasto.haber);
        const inventoryBalance = compra.debe - costoVenta.haber;

        const revenue = venta.haber;
        const costs = costoVenta.debe;
        const expenses = gasto.debe;
        const netIncome = revenue - costs - expenses;

        return {
            assets: [
                { id: '1.1.01', name: 'Caja y Bancos', balance: cashBalance },
                { id: '1.1.03', name: 'Inventario de Insumos', balance: inventoryBalance },
                { id: '1.2.01', name: 'Propiedad, Planta y Equipo', balance: 0 }
            ],
            liabilities: [
                { id: '2.1.01', name: 'Cuentas por Pagar', balance: 0 },
                { id: '2.1.02', name: 'Impuestos por Pagar', balance: 0 }
            ],
            equity: [
                { id: '3.1.01', name: 'Capital Social', balance: 0 },
                { id: '3.1.02', name: 'Utilidad / Pérdida del Ejercicio', balance: netIncome }
            ],
            totals: {
                assets: cashBalance + inventoryBalance,
                liabilities: 0,
                equity: netIncome
            }
        };
    }
}
