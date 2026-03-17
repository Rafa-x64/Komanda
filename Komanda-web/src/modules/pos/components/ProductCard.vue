<script setup lang="ts">
import { Plus } from 'lucide-vue-next'

interface Product {
  id: number
  nombre: string
  precio_venta: number
  categoria_id: number
  imagen_url?: string
}

defineProps<{ product: Product }>()
const emit = defineEmits<{ 'add-to-cart': [product: Product] }>()
</script>

<template>
  <div class="pos-product-card" @click="emit('add-to-cart', product)">
    <div class="pos-product-card__img">
      <span class="pos-product-card__emoji">🍽️</span>
    </div>
    <div class="pos-product-card__body">
      <span class="pos-product-card__name">{{ product.nombre }}</span>
      <span class="pos-product-card__price">${{ product.precio_venta.toFixed(2) }}</span>
    </div>
    <div class="pos-product-card__add">
      <Plus :size="20" />
    </div>
  </div>
</template>

<style scoped>
.pos-product-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  background: var(--bg-surface);
  border: 1px solid var(--border-color);
  border-radius: 1rem;
  padding: 1.25rem 1rem;
  cursor: pointer;
  transition: all var(--transition-speed) ease;
  user-select: none;
  position: relative;
  text-align: center;
  min-height: 160px;
  justify-content: center;
}

.pos-product-card:hover,
.pos-product-card:active {
  border-color: var(--KOrange);
  transform: translateY(-3px);
  box-shadow: 0 6px 20px rgba(253, 126, 20, 0.15);
}

.pos-product-card__img {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: var(--KOrange-light);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 0.75rem;
}

.pos-product-card__emoji {
  font-size: 1.6rem;
}

.pos-product-card__body {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.pos-product-card__name {
  font-weight: 600;
  font-size: 0.9rem;
  color: var(--text-main);
  line-height: 1.2;
}

.pos-product-card__price {
  font-weight: 700;
  font-size: 1.05rem;
  color: var(--KOrange);
}

.pos-product-card__add {
  position: absolute;
  top: 0.6rem;
  right: 0.6rem;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: var(--KOrange);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity var(--transition-speed);
}

.pos-product-card:hover .pos-product-card__add,
.pos-product-card:active .pos-product-card__add {
  opacity: 1;
}
</style>
