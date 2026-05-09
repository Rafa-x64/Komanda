<template>
  <tr :class="{'bg-danger bg-opacity-10': item.alerta_critica}">
    <td class="px-4 fw-bold">{{ item.nombre }}</td>
    <td class="px-4 text-end fw-bold fs-6">
      {{ Number(item.cantidad_disponible).toFixed(3) }} <span class="text-muted small">{{ item.unidad_nombre || 'Ud.' }}</span>
    </td>
    <td class="px-4 text-end text-muted">{{ Number(item.cantidad_minima).toFixed(3) }}</td>
    <td class="px-4 text-center">
      <StockBadge :disponible="Number(item.cantidad_disponible)" :minimo="Number(item.cantidad_minima)" />
    </td>
    <td class="px-4 text-end fw-medium text-secondary">
      ${{ Number(item.costo_promedio).toFixed(2) }}
    </td>
    <td class="px-4 text-center">
      <div class="d-flex justify-content-center gap-1">
        <button class="btn btn-sm text-primary hover-bg-light rounded-circle p-2" @click="$emit('edit', item)" title="Editar Configuración">
          <Edit2 :size="16" />
        </button>
        <button type="button" class="btn btn-sm text-danger hover-bg-light rounded-circle p-2" @click.prevent.stop="confirmDelete" title="Eliminar Ingrediente">
          <Trash2 :size="16" />
        </button>
      </div>
    </td>
  </tr>
</template>

<script setup lang="ts">
import { Edit2, Trash2 } from 'lucide-vue-next';
import StockBadge from './StockBadge.vue';

const props = defineProps<{
  item: {
    id: number;
    nombre: string;
    cantidad_disponible: number;
    cantidad_minima: number;
    costo_promedio: number;
    unidad_nombre: string;
    alerta_critica: boolean;
  };
}>();

const emit = defineEmits(['edit', 'delete']);

const confirmDelete = () => {
  if (window.confirm(`¿Está seguro de eliminar "${props.item.nombre}"? Esta acción no se puede deshacer y fallará si tiene compras asociadas.`)) {
    emit('delete', props.item.id);
  }
};
</script>

<style scoped>
.hover-bg-light:hover { background-color: #f8f9fa; }
.badge-danger-custom {
  background-color: var(--bs-danger);
  color: white;
}
.badge-success-custom {
  background-color: rgba(25, 135, 84, 0.1);
  color: var(--bs-success);
}
</style>
