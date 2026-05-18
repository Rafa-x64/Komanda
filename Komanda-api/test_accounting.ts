import { Conexion } from './src/config/database';
import { AccountingService } from './src/modules/accounting/accounting.service';

async function testAccounting() {
    try {
        console.log("Conectando a la BD...");
        await Conexion.initialize();
        
        // Asiento descuadrado (debe tirar error)
        try {
            console.log("Probando asiento descuadrado...");
            await AccountingService.registrarAsientoContable(
                new Date(),
                "Test Descuadrado",
                "ajuste",
                [
                    { cuenta_id: 1, tipo_movimiento: 'debe', monto: 100 },
                    { cuenta_id: 2, tipo_movimiento: 'haber', monto: 90 }
                ],
                1
            );
            console.log("ERROR: No tiró excepción de descuadre");
        } catch (e: any) {
            console.log("OK: Excepción capturada -", e.message);
        }

        // Asiento cuadrado
        console.log("Probando asiento cuadrado...");
        const asientoId = await AccountingService.registrarAsientoContable(
            new Date(),
            "Venta del dia",
            "venta",
            [
                { cuenta_id: 1, tipo_movimiento: 'debe', monto: 150.50, descripcion: "Ingreso a Caja" }, // Asumimos cuenta_id 1 es Caja
                { cuenta_id: 2, tipo_movimiento: 'haber', monto: 150.50, descripcion: "Ingreso por Ventas" } // Asumimos cuenta_id 2 es Ingresos
            ],
            1, // restaurante_id
            101 // origen_id (ej. factura 101)
        );
        console.log("OK: Asiento creado con ID", asientoId);

        console.log("Consultando Diario...");
        const diario = await AccountingService.getJournalEntries(1, '2020-01-01', '2030-01-01');
        console.log(`OK: Diario tiene ${diario.length} asientos. Último:`, JSON.stringify(diario[0], null, 2));

        console.log("Consultando Balance General...");
        const bg = await AccountingService.getBalanceGeneral(1);
        console.log(`OK: Balance General tiene ${bg.length} registros.`);

        console.log("Consultando Estado de Resultados...");
        const er = await AccountingService.getEstadoResultados(1);
        console.log(`OK: Estado de Resultados tiene ${er.length} registros.`);

    } catch (error) {
        console.error("Error en test:", error);
    } finally {
        process.exit();
    }
}

testAccounting();
