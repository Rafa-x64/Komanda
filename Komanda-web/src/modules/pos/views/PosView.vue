<script setup lang='ts'>
import { ref } from 'vue';
import PosCategoryFilter from '../components/PosCategoryFilter.vue';
const categories = [
    { id: 1, name: "hamburguesa" }, 
    { id: 2, name: "ensalada" },
    { id: 2, name: "sopa" }
]
</script>
<template>
    <PosCategoryFilter :categories="categories" :active-category="null" />
</template>
<style scoped>

</style>