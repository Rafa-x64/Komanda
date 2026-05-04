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
      <button class="btn btn-sm text-primary hover-bg-light rounded-circle p-2" @click="$emit('edit', item)" title="Editar Mínimos y Unidad">
        <Edit2 :size="16" />
      </button>
    </td>
  </tr>
</template>

<script setup lang="ts">
import { Edit2 } from 'lucide-vue-next';
import StockBadge from './StockBadge.vue';

defineProps<{
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

defineEmits(['edit']);
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
