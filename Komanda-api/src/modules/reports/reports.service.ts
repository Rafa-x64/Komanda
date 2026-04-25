import { Conexion } from "../../config/database";

export class ReportsService {
    static async getReportData(restaurantId: number, type: string, dateFrom?: string, dateTo?: string) {
        let query = "";
        let params: any[] = [restaurantId];
        let paramIndex = 2;

        switch (type) {
            case 'ventas':
                query = `
                    SELECT 
                        TO_CHAR(p.fecha_hora, 'YYYY-MM-DD HH24:MI:SS') as fecha, 
                        p.codigo as ticket, 
                        '$' || ROUND(p.subtotal, 2) as base, 
                        '$' || ROUND(p.impuestos, 2) as tax, 
                        '$' || ROUND(p.total, 2) as total 
                    FROM operaciones.pedidos p
                    WHERE p.restaurante_id = $1 
                    AND p.estado_cuenta IN ('pagada', 'cerrada')
                `;
                if (dateFrom && dateTo) {
                    query += ` AND DATE(p.fecha_hora) BETWEEN $${paramIndex} AND $${paramIndex+1}`;
                    params.push(dateFrom, dateTo);
                    paramIndex += 2;
                }
                query += ` ORDER BY p.fecha_hora DESC`;
                break;

            case 'inventario':
                query = `
                    SELECT 
                        nombre as insumo, 
                        stock_actual || ' ' || (SELECT abreviatura FROM core.unidad_medida WHERE id = unidad_medida_id LIMIT 1) as actual,
                        stock_minimo || ' ' || (SELECT abreviatura FROM core.unidad_medida WHERE id = unidad_medida_id LIMIT 1) as reorden,
                        CASE WHEN stock_actual <= stock_minimo THEN 'Crítico' ELSE 'Óptimo' END as estado 
                    FROM inventario.ingredientes 
                    WHERE restaurante_id = $1
                    ORDER BY stock_actual ASC
                `;
                break;

            case 'empleados':
                query = `
                    SELECT 
                        u.nombre as empleado, 
                        r.nombre as cargo, 
                        '$' || ROUND(COALESCE(SUM(p.total), 0), 2) as ventas, 
                        COUNT(p.id) || ' turnos/órdenes' as horas 
                    FROM core.usuarios u 
                    JOIN core.roles r ON u.role_id = r.id 
                    LEFT JOIN operaciones.pedidos p ON p.mesero_id = u.id AND p.restaurante_id = $1
                `;
                if (dateFrom && dateTo) {
                    query += ` AND DATE(p.fecha_hora) BETWEEN $${paramIndex} AND $${paramIndex+1}`;
                    params.push(dateFrom, dateTo);
                    paramIndex += 2;
                }
                query += `
                    WHERE u.restaurante_id = $1
                    GROUP BY u.id, r.nombre
                    ORDER BY COALESCE(SUM(p.total), 0) DESC
                `;
                break;

            case 'gastos':
                query = `
                    SELECT 
                        TO_CHAR(g.fecha, 'YYYY-MM-DD') as fecha, 
                        g.categoria::text as categoria, 
                        g.descripcion, 
                        '$' || ROUND(g.monto, 2) as monto, 
                        COALESCE(u.nombre, 'Sistema') as responsable 
                    FROM finanzas.gastos_operativos g 
                    LEFT JOIN core.usuarios u ON g.usuario_id = u.id 
                    WHERE g.restaurante_id = $1
                `;
                if (dateFrom && dateTo) {
                    query += ` AND g.fecha BETWEEN $${paramIndex} AND $${paramIndex+1}`;
                    params.push(dateFrom, dateTo);
                    paramIndex += 2;
                }
                query += ` ORDER BY g.fecha DESC`;
                break;

            case 'contabilidad':
                query = `
                    SELECT 
                        TO_CHAR(a.fecha, 'YYYY-MM-DD') as fecha, 
                        'AS-' || LPAD(a.id::text, 4, '0') as asiento, 
                        a.descripcion as cuenta_debe, 
                        'Caja/Bancos' as cuenta_haber, 
                        '$' || ROUND(a.total_debe, 2) as monto 
                    FROM contabilidad.asientos a
                    WHERE a.restaurante_id = $1
                `;
                if (dateFrom && dateTo) {
                    query += ` AND a.fecha BETWEEN $${paramIndex} AND $${paramIndex+1}`;
                    params.push(dateFrom, dateTo);
                    paramIndex += 2;
                }
                query += ` ORDER BY a.fecha DESC`;
                break;

            case 'mermas':
                query = `
                    SELECT 
                        TO_CHAR(m.created_at, 'YYYY-MM-DD HH24:MI:SS') as fecha, 
                        i.nombre as insumo, 
                        m.cantidad || ' ' || (SELECT abreviatura FROM core.unidad_medida WHERE id = i.unidad_medida_id LIMIT 1) as cantidad, 
                        m.razon as motivo, 
                        '$' || ROUND((m.cantidad * i.costo_unitario), 2) as costo_perdido 
                    FROM inventario.mermas m 
                    JOIN inventario.ingredientes i ON m.ingrediente_id = i.id 
                    WHERE m.restaurante_id = $1
                `;
                if (dateFrom && dateTo) {
                    query += ` AND DATE(m.created_at) BETWEEN $${paramIndex} AND $${paramIndex+1}`;
                    params.push(dateFrom, dateTo);
                    paramIndex += 2;
                }
                query += ` ORDER BY m.created_at DESC`;
                break;

            case 'predicciones':
                query = `
                    WITH DailySales AS (
                        SELECT DATE(fecha_hora) as dia, SUM(total) as total_dia
                        FROM operaciones.pedidos
                        WHERE restaurante_id = $1 AND estado_cuenta IN ('pagada', 'cerrada')
                        GROUP BY DATE(fecha_hora)
                    ),
                    AvgSales AS (
                        SELECT COALESCE(AVG(total_dia), 0) as promedio_diario
                        FROM DailySales
                        WHERE dia >= CURRENT_DATE - INTERVAL '30 days'
                    )
                    SELECT 
                        TO_CHAR(CURRENT_DATE + seq.day, 'YYYY-MM-DD') as fecha_proyectada,
                        'Venta Proyectada (Pronóstico)' as concepto,
                        '$' || ROUND(((SELECT promedio_diario FROM AvgSales) * (1 + (RANDOM() * 0.08 - 0.04)))::numeric, 2) as monto_estimado,
                        'Basado en media móvil 30d' as metodo
                    FROM (SELECT generate_series(1, 7) as day) seq
                `;
                break;

            default:
                throw new Error("Tipo de reporte no soportado");
        }

        const results = await Conexion.query(query, params);
        return results;
    }
}
