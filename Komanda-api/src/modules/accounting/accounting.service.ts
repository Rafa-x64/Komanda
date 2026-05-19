import { Conexion } from "../../config/database";

export class AccountingService {

    static async registrarAsientoContable(
        fecha: string | Date,
        descripcion: string,
        tipo_origen: string,
        lineas_debe_haber: Array<{ cuenta_id: number; tipo_movimiento: 'debe' | 'haber'; monto: number; descripcion?: string }>,
        restaurante_id: number,
        origen_id?: number,
        creado_por?: number,
        providedQueryRunner?: any
    ) {
        let sumDebe = 0;
        let sumHaber = 0;

        for (const linea of lineas_debe_haber) {
            const m = Number(linea.monto) || 0;
            if (linea.tipo_movimiento === 'debe') sumDebe += m;
            else if (linea.tipo_movimiento === 'haber') sumHaber += m;
        }

        if (Math.abs(sumDebe - sumHaber) > 0.001) {
            throw new Error('Asiento Descuadrado');
        }

        const isExternalTransaction = !!providedQueryRunner;
        const queryRunner = providedQueryRunner || Conexion.createQueryRunner();
        
        if (!isExternalTransaction) {
            await queryRunner.connect();
            await queryRunner.startTransaction();
        }

        try {
            const asientoResult = await queryRunner.query(
                `INSERT INTO contabilidad.asientos 
                 (fecha, descripcion, origen_tipo, origen_id, total_debe, total_haber, restaurante_id, creado_por)
                 VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
                 RETURNING id`,
                [fecha, descripcion, tipo_origen, origen_id ?? null, sumDebe, sumHaber, restaurante_id, creado_por ?? null]
            );
            const asientoId = asientoResult[0].id;

            for (const linea of lineas_debe_haber) {
                await queryRunner.query(
                    `INSERT INTO contabilidad.asiento_lineas
                     (asiento_id, cuenta_id, tipo_movimiento, monto, descripcion, restaurante_id)
                     VALUES ($1, $2, $3, $4, $5, $6)`,
                    [asientoId, linea.cuenta_id, linea.tipo_movimiento, linea.monto, linea.descripcion ?? null, restaurante_id]
                );
            }

            if (!isExternalTransaction) {
                await queryRunner.commitTransaction();
            }
            return asientoId;
        } catch (error) {
            if (!isExternalTransaction) {
                await queryRunner.rollbackTransaction();
            }
            throw error;
        } finally {
            if (!isExternalTransaction) {
                await queryRunner.release();
            }
        }
    }

    static async getBalanceGeneral(restaurante_id: number, dateFrom?: string, dateTo?: string) {
        const query = `
            SELECT tipo, codigo, cuenta, saldo
            FROM contabilidad.v_balance_general
            WHERE restaurante_id = $1
            ORDER BY codigo
        `;
        return Conexion.query(query, [restaurante_id]);
    }

    static async getEstadoResultados(restaurante_id: number, dateFrom?: string, dateTo?: string) {
        let query = `
            SELECT tipo, cuenta, SUM(monto) as total
            FROM contabilidad.v_estado_resultados
            WHERE restaurante_id = $1
        `;
        const params: (number | string)[] = [restaurante_id];

        if (dateFrom && dateTo) {
            query += ` AND fecha BETWEEN $2 AND $3`;
            params.push(dateFrom, dateTo);
        }

        query += ` GROUP BY tipo, cuenta ORDER BY tipo`;
        return Conexion.query(query, params);
    }

    static async getJournalEntries(restaurante_id: number, dateFrom?: string, dateTo?: string) {
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
        const params: (number | string)[] = [restaurante_id];

        if (dateFrom && dateTo) {
            queryAsientos += ` AND a.fecha BETWEEN $2 AND $3`;
            params.push(dateFrom, dateTo);
        }

        queryAsientos += ` ORDER BY a.fecha DESC, a.id DESC`;

        const asientos = await Conexion.query(queryAsientos, params);
        if (asientos.length === 0) return [];

        const asientoIds = asientos.map((a: { asiento_id: number }) => a.asiento_id);

        const lineas = await Conexion.query(
            `SELECT 
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
             ORDER BY al.asiento_id, al.tipo_movimiento DESC, al.id`,
            [asientoIds]
        );

        const lineasByAsiento: Record<number, typeof lineas> = {};
        lineas.forEach((linea: { asiento_id: number }) => {
            if (!lineasByAsiento[linea.asiento_id]) lineasByAsiento[linea.asiento_id] = [];
            lineasByAsiento[linea.asiento_id].push(linea);
        });

        return asientos.map((a: { asiento_id: number }) => ({
            ...a,
            lineas: lineasByAsiento[a.asiento_id] || []
        }));
    }
}
