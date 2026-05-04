<template>
  <span class="badge rounded-pill px-3 py-1" :class="badgeClass">
    {{ label }}
  </span>
</template>

<script setup lang="ts">
import { computed } from 'vue';

const props = defineProps<{ disponible: number; minimo: number }>();

const isCritical = computed(() => props.disponible <= props.minimo);
const badgeClass = computed(() =>
  isCritical.value ? 'badge-danger-custom' : 'badge-success-custom'
);
const label = computed(() => (isCritical.value ? 'Stock Bajo' : 'Normal'));
</script>
