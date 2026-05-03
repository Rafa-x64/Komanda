import { ref } from 'vue';
import { fetchWaiterTables, fetchWaiterStats, type WaiterTable, type WaiterStats } from '../dashboard.api';

const tables = ref<WaiterTable[]>([]);
const stats  = ref<WaiterStats>({ pedidos_activos: 0, listos_entregar: 0, ventas_turno: 0, mesas_libres: 0 });
const loading = ref(true);

export function useMeseroData() {
    const load = async () => {
        try {
            const [t, s] = await Promise.all([fetchWaiterTables(), fetchWaiterStats()]);
            tables.value  = t;
            stats.value   = s;
        } catch (e) {
            console.error('Error cargando datos del mesero:', e);
        } finally {
            loading.value = false;
        }
    };

    return { tables, stats, loading, load };
}
