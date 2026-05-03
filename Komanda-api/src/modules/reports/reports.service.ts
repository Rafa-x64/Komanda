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
                        cantidad_disponible || ' ' || (SELECT abreviatura FROM core.unidad_medida WHERE id = unidad_id LIMIT 1) as actual,
                        cantidad_minima || ' ' || (SELECT abreviatura FROM core.unidad_medida WHERE id = unidad_id LIMIT 1) as reorden,
                        CASE WHEN cantidad_disponible <= cantidad_minima THEN 'Crítico' ELSE 'Óptimo' END as estado 
                    FROM inventario.ingredientes 
                    WHERE restaurante_id = $1
                    ORDER BY cantidad_disponible ASC
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
                    JOIN core.roles r ON u.rol_id = r.id 
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
                        m.cantidad || ' ' || (SELECT abreviatura FROM core.unidad_medida WHERE id = i.unidad_id LIMIT 1) as cantidad, 
                        m.razon as motivo, 
                        '$' || ROUND((m.cantidad * i.costo_promedio), 2) as costo_perdido 
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

    static async getDashboardOverview(restaurantId: number) {
        // KPIs (This week vs Last week would be ideal, but let's just do "This Week" totals)
        const [kpis] = await Conexion.query(
            `SELECT 
                COALESCE(SUM(CASE WHEN tipo = 'venta' THEN debe ELSE 0 END), 0) as ingreso_bruto,
                COALESCE(SUM(CASE WHEN tipo IN ('costo_venta', 'gasto') THEN debe ELSE 0 END), 0) as costo_operativo
             FROM contabilidad.libro_diario
             WHERE restaurante_id = $1 AND fecha >= CURRENT_DATE - INTERVAL '7 days'`,
            [restaurantId]
        );
        
        const [tickets] = await Conexion.query(
            `SELECT COUNT(id) as total_tickets
             FROM operaciones.pedidos
             WHERE restaurante_id = $1 AND fecha_hora >= CURRENT_DATE - INTERVAL '7 days'`,
            [restaurantId]
        );

        // Profitability (Sales vs Cost)
        const rentabilidad = await Conexion.query(
            `SELECT 
                r.nombre as name,
                '🍽️' as emoji,
                CAST(r.precio_venta AS NUMERIC) as price,
                CAST(r.costo_produccion AS NUMERIC) as cost,
                CAST(COALESCE(SUM(pd.cantidad), 0) AS INTEGER) as units
             FROM menu.recetas r
             LEFT JOIN operaciones.pedido_detalle pd ON pd.receta_id = r.id
             LEFT JOIN operaciones.pedidos p ON p.id = pd.pedido_id AND p.fecha_hora >= CURRENT_DATE - INTERVAL '30 days'
             WHERE r.restaurante_id = $1
             GROUP BY r.id, r.nombre, r.precio_venta, r.costo_produccion
             ORDER BY units DESC`,
            [restaurantId]
        );

        // Chart Data (Last 7 days)
        const chartData = await Conexion.query(
            `SELECT 
                TO_CHAR(fecha, 'DD/MM') as date,
                COALESCE(SUM(CASE WHEN tipo = 'venta' THEN debe ELSE 0 END), 0) as revenue,
                COALESCE(SUM(CASE WHEN tipo IN ('costo_venta', 'gasto') THEN debe ELSE 0 END), 0) as cost
             FROM contabilidad.libro_diario
             WHERE restaurante_id = $1 AND fecha >= CURRENT_DATE - INTERVAL '6 days'
             GROUP BY fecha
             ORDER BY fecha ASC`,
            [restaurantId]
        );

        return {
            kpis: {
                ingreso_bruto: parseFloat(kpis.ingreso_bruto),
                costo_operativo: parseFloat(kpis.costo_operativo),
                tickets_semana: parseInt(tickets.total_tickets)
            },
            rentabilidad: rentabilidad.map((r: any) => {
                const margin = r.price - r.cost;
                const marginPct = r.price > 0 ? (margin / r.price) * 100 : 0;
                return {
                    name: r.name,
                    emoji: r.emoji,
                    price: parseFloat(r.price),
                    cost: parseFloat(r.cost),
                    units: r.units,
                    margin: margin,
                    marginPct: marginPct,
                    totalGain: margin * r.units
                }
            }),
            chartData: chartData.map((c: any) => ({
                date: c.date,
                revenue: parseFloat(c.revenue),
                cost: parseFloat(c.cost)
            }))
        };
    }
}
