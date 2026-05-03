import { Conexion } from "../../config/database";

export class AccountingService {
    static async getBalanceSheet(restaurantId: number, dateFrom?: string, dateTo?: string) {
        // Obtenemos los movimientos del libro diario para calcular saldos
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

        // Mapeo de saldos por tipo de movimiento
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

        // Cálculos simplificados basados en los tipos de movimiento
        // En una contabilidad real esto usaría los IDs de las cuentas del plan_cuentas
        
        // 1. Efectivo (Caja/Bancos): Incrementa con Ventas (Debe), disminuye con Compras y Gastos (Haber)
        const cashBalance = venta.debe - (compra.haber + gasto.haber);
        
        // 2. Inventario: Incrementa con Compras (Debe), disminuye con Costo de Venta (Haber)
        const inventoryBalance = compra.debe - costoVenta.haber;

        // 3. Resultados (Utilidad/Pérdida): Ingresos - Costos - Gastos
        const revenue = venta.haber;
        const costs = costoVenta.debe;
        const expenses = gasto.debe;
        const netIncome = revenue - costs - expenses;

        // Estructura para el frontend
        return {
            assets: [
                { id: '1.1.01', name: 'Caja y Bancos', balance: cashBalance },
                { id: '1.1.03', name: 'Inventario de Insumos', balance: inventoryBalance },
                { id: '1.2.01', name: 'Propiedad, Planta y Equipo', balance: 0 } // No implementado aún
            ],
            liabilities: [
                { id: '2.1.01', name: 'Cuentas por Pagar', balance: 0 }, // No implementado aún
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
