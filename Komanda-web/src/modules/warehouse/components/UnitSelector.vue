<template>
  <select
    class="form-select"
    :value="modelValue"
    @input="$emit('update:modelValue', Number(($event.target as HTMLSelectElement).value))"
    required
  >
    <option value="" disabled selected>Seleccione una unidad...</option>
    <option v-for="u in unidades" :key="u.id" :value="u.id">
      {{ u.nombre }} ({{ u.abreviatura }})
    </option>
  </select>
</template>

<script setup lang="ts">
defineProps<{
  modelValue: number | string;
  unidades: Array<{ id: number; nombre: string; abreviatura: string }>;
}>();
defineEmits(['update:modelValue']);
</script>
