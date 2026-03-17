<script setup lang="ts">
interface Category {
  id: number
  nombre: string
}

defineProps<{ categories: Category[]; activeCategory: number | null }>()
const emit = defineEmits<{ 'filter-changed': [categoryId: number | null] }>()
</script>

<template>
  <div class="pos-category-filter">
    <button
      class="pos-pill"
      :class="{ 'pos-pill--active': activeCategory === null }"
      @click="emit('filter-changed', null)"
    >
      Todas
    </button>
    <button
      v-for="cat in categories"
      :key="cat.id"
      class="pos-pill"
      :class="{ 'pos-pill--active': activeCategory === cat.id }"
      @click="emit('filter-changed', cat.id)"
    >
      {{ cat.nombre }}
    </button>
  </div>
</template>

<style scoped>
.pos-category-filter {
  display: flex;
  gap: 0.5rem;
  overflow-x: auto;
  padding-bottom: 0.5rem;
  -webkit-overflow-scrolling: touch;
}

.pos-pill {
  white-space: nowrap;
  border: 1.5px solid var(--border-color);
  background: var(--bg-surface);
  color: var(--text-main);
  border-radius: 2rem;
  padding: 0.5rem 1.25rem;
  font-weight: 600;
  font-size: 0.875rem;
  cursor: pointer;
  transition: all var(--transition-speed);
  flex-shrink: 0;
}

.pos-pill:hover {
  border-color: var(--KOrange);
  color: var(--KOrange);
}

.pos-pill--active {
  background: var(--KOrange);
  border-color: var(--KOrange);
  color: #fff;
}

.pos-pill--active:hover {
  background: var(--KOrange-hover);
  color: #fff;
}
</style>
