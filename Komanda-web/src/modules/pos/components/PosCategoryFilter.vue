<<<<<<< HEAD
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
=======
<script setup lang='ts'>
import { ref } from 'vue';
interface Category { 
    id: number | string,
    name: string
}

const props = defineProps<{
    categories: Category[],
    activeCategory: number | string | null
}>();

const emits = defineEmits<{
    (e: 'select-category', id: number | string): void;
}>()
</script>
<template>
    <div class="row m-0">
        <div class="col-12 category-filter d-flex gap-2 overflow-auto m-0 py-2">
            <button
            v-for="category in categories"
            :key = "category.id"
            class="btn-outline-korange rounded-pill px-2 py-1 m-0"
            :class="category.id === activeCategory ? 'btn-korange' : 'btn-outline-korange'"
            @click="emits('select-category', category.id)"
            >
                {{ category.name }}
            </button>
        </div>
    </div>
</template>
<style scoped>
    .category-filter{
        background-color: var(--bg-body) ;
    }

    .btn-outline-korange{
        background-color: var(--bg-surface) !important;
        font-size: 0.65rem !important;
        border: 1px solid var(--border-color);
        white-space: nowrap;
    }
</style>
>>>>>>> 39ceec68e5e9e06da700d490dcef3eacc9fea992
