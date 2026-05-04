import { ref, computed } from 'vue';
import { useAuth } from '../../core/composables/useAuth';

interface Ingrediente {
  id: number;
  nombre: string;
  cantidad_disponible: number;
  cantidad_minima: number;
  costo_promedio: number;
  merma_teorica_porcentaje: number;
  unidad_id: number;
  unidad_nombre: string;
  alerta_critica: boolean;
}

interface Unidad {
  id: number;
  nombre: string;
  abreviatura: string;
}

const BASE = 'http://localhost:3000/api/v1/warehouse';

const getHeaders = (token: string) => ({
  'Content-Type': 'application/json',
  Authorization: `Bearer ${token}`,
});

export function useWarehouse() {
  const auth = useAuth();
  const ingredientes = ref<Ingrediente[]>([]);
  const unidades = ref<Unidad[]>([]);
  const loading = ref(false);
  const error = ref<string | null>(null);

  const stockCriticoCount = computed(
    () => ingredientes.value.filter(i => i.alerta_critica).length
  );

  const fetchAll = async () => {
    loading.value = true;
    error.value = null;
    try {
      const token = auth.token.value ?? '';
      const res = await fetch(BASE, { headers: getHeaders(token) });
      const json = await res.json();
      if (!res.ok) throw new Error(json.message ?? 'Error al cargar');
      ingredientes.value = json.data;
    } catch (e: unknown) {
      error.value = e instanceof Error ? e.message : 'Error de red';
    } finally {
      loading.value = false;
    }
  };

  const fetchUnidades = async () => {
    try {
      const token = auth.token.value ?? '';
      const res = await fetch(`${BASE}/unidades`, { headers: getHeaders(token) });
      const json = await res.json();
      unidades.value = json.data ?? [];
    } catch { /* silencioso */ }
  };

  const createIngredient = async (data: Omit<Ingrediente, 'id' | 'cantidad_disponible' | 'costo_promedio' | 'unidad_nombre' | 'alerta_critica'>) => {
    const token = auth.token.value ?? '';
    const res = await fetch(BASE, {
      method: 'POST',
      headers: getHeaders(token),
      body: JSON.stringify(data),
    });
    const json = await res.json();
    if (!res.ok) throw new Error(json.message ?? 'Error al crear');
    await fetchAll();
    return json.data;
  };

  const updateIngredient = async (id: number, data: Partial<Ingrediente>) => {
    const token = auth.token.value ?? '';
    const res = await fetch(`${BASE}/${id}`, {
      method: 'PATCH',
      headers: getHeaders(token),
      body: JSON.stringify(data),
    });
    const json = await res.json();
    if (!res.ok) throw new Error(json.message ?? 'Error al actualizar');
    await fetchAll();
    return json.data;
  };

  return { ingredientes, unidades, loading, error, stockCriticoCount, fetchAll, fetchUnidades, createIngredient, updateIngredient };
}
