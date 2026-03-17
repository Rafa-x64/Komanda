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