<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { Send, ShoppingCart, AlertCircle, CheckCircle } from 'lucide-vue-next'
import ProductCard from '../components/ProductCard.vue'
import PosCategoryFilter from '../components/PosCategoryFilter.vue'
import CartItemRow from '../components/CardItemRow.vue'
import { useCart } from '../composables/useCart'
import { sendOrder } from '../pos.api'

// Cart composable
const { cartItems, selectedTable, addItem, updateQuantity, addKitchenNote, removeItem, clearCart, subtotal, taxes, total } = useCart()

// UI state
const loading = ref(false)
const toast = ref<{ type: 'success' | 'error'; message: string } | null>(null)
const activeCategory = ref<number | null>(null)

// Mock data (will be replaced by API calls)
const categories = ref([
  { id: 1, nombre: 'Entradas' },
  { id: 2, nombre: 'Platos Fuertes' },
  { id: 3, nombre: 'Bebidas' },
  { id: 4, nombre: 'Postres' },
])

const tables = ref([
  { id: 1, nombre: 'Mesa 1' },
  { id: 2, nombre: 'Mesa 2' },
  { id: 3, nombre: 'Mesa 3' },
  { id: 4, nombre: 'Mesa 4' },
  { id: 5, nombre: 'Mesa 5' },
  { id: 6, nombre: 'Mesa 6' },
])

const products = ref([
  { id: 1, nombre: 'Nachos con Guacamole', precio_venta: 6.50, categoria_id: 1 },
  { id: 2, nombre: 'Alitas BBQ', precio_venta: 8.00, categoria_id: 1 },
  { id: 3, nombre: 'Sopa del Día', precio_venta: 4.50, categoria_id: 1 },
  { id: 4, nombre: 'Hamburguesa Komanda', precio_venta: 9.50, categoria_id: 2 },
  { id: 5, nombre: 'Filete de Res', precio_venta: 15.00, categoria_id: 2 },
  { id: 6, nombre: 'Pollo a la Parrilla', precio_venta: 11.50, categoria_id: 2 },
  { id: 7, nombre: 'Pasta Alfredo', precio_venta: 10.00, categoria_id: 2 },
  { id: 8, nombre: 'Limonada Natural', precio_venta: 3.00, categoria_id: 3 },
  { id: 9, nombre: 'Coca-Cola', precio_venta: 2.50, categoria_id: 3 },
  { id: 10, nombre: 'Café Americano', precio_venta: 2.00, categoria_id: 3 },
  { id: 11, nombre: 'Flan Napolitano', precio_venta: 5.00, categoria_id: 4 },
  { id: 12, nombre: 'Brownie con Helado', precio_venta: 6.00, categoria_id: 4 },
])

// Filtered products by category
const filteredProducts = computed(() => {
  if (!activeCategory.value) return products.value
  return products.value.filter(p => p.categoria_id === activeCategory.value)
})

const itemCount = computed(() =>
  cartItems.value.reduce((sum, i) => sum + i.quantity, 0)
)

// Toast helper
const showToast = (type: 'success' | 'error', message: string) => {
  toast.value = { type, message }
  setTimeout(() => { toast.value = null }, 3500)
}

// Submit order
const handleConfirm = async () => {
  if (!selectedTable.value) { showToast('error', 'Selecciona una mesa primero'); return }
  if (!cartItems.value.length) { showToast('error', 'El carrito está vacío'); return }

  loading.value = true
  try {
    await sendOrder({
      mesa_id: selectedTable.value,
      items: cartItems.value.map(i => ({
        receta_id: i.product.id,
        cantidad: i.quantity,
        notas: i.notes,
      })),
    })
    clearCart()
    showToast('success', '¡Orden enviada a cocina con éxito! 🎉')
  } catch (e: unknown) {
    const msg = e instanceof Error ? e.message : 'Error desconocido'
    showToast('error', msg)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  // TODO: fetch categories, products & tables from API
})
</script>

<template>
  <div class="pos-layout">
    <!-- Toast Notification -->
    <Transition name="toast-slide">
      <div v-if="toast" class="pos-toast" :class="`pos-toast--${toast.type}`">
        <CheckCircle v-if="toast.type === 'success'" :size="20" />
        <AlertCircle v-else :size="20" />
        <span>{{ toast.message }}</span>
      </div>
    </Transition>

    <!-- LEFT: Catalogue (70%) -->
    <section class="pos-catalog">
      <header class="pos-catalog__header">
        <h1 class="pos-catalog__title">Punto de Venta</h1>
        <PosCategoryFilter
          :categories="categories"
          :active-category="activeCategory"
          @filter-changed="activeCategory = $event"
        />
      </header>

      <div class="pos-catalog__grid">
        <ProductCard
          v-for="p in filteredProducts"
          :key="p.id"
          :product="p"
          @add-to-cart="addItem"
        />
      </div>

      <p v-if="!filteredProducts.length" class="text-center text-secondary-custom mt-4">
        No hay productos en esta categoría.
      </p>
    </section>

    <!-- RIGHT: Ticket / Cart (30%) -->
    <aside class="pos-ticket">
      <!-- Table Selector -->
      <div class="pos-ticket__header">
        <ShoppingCart :size="20" class="text-korange" />
        <select
          v-model="selectedTable"
          class="form-select form-select-sm pos-ticket__select"
        >
          <option :value="null" disabled>Seleccionar Mesa</option>
          <option v-for="t in tables" :key="t.id" :value="t.id">
            {{ t.nombre }}
          </option>
        </select>
      </div>

      <!-- Cart Items -->
      <div class="pos-ticket__body">
        <div v-if="!cartItems.length" class="pos-ticket__empty">
          <span class="pos-ticket__empty-icon">🛒</span>
          <span>Agrega productos</span>
        </div>

        <CartItemRow
          v-for="ci in cartItems"
          :key="ci.product.id"
          :item="ci"
          @increase="updateQuantity(ci.product.id, 1)"
          @decrease="updateQuantity(ci.product.id, -1)"
          @add-note="addKitchenNote(ci.product.id, $event)"
          @remove="removeItem(ci.product.id)"
        />
      </div>

      <!-- Footer: Totals + Confirm -->
      <div class="pos-ticket__footer">
        <div class="pos-ticket__totals">
          <div class="pos-ticket__row">
            <span>Subtotal</span>
            <span>${{ subtotal.toFixed(2) }}</span>
          </div>
          <div class="pos-ticket__row">
            <span>IVA (12%)</span>
            <span>${{ taxes.toFixed(2) }}</span>
          </div>
          <div class="pos-ticket__row pos-ticket__row--total">
            <span>Total</span>
            <span>${{ total.toFixed(2) }}</span>
          </div>
        </div>

        <button
          class="pos-confirm-btn"
          :disabled="loading || !cartItems.length"
          @click="handleConfirm"
        >
          <Send :size="20" />
          <span v-if="loading">Enviando...</span>
          <span v-else>ENVIAR A COCINA ({{ itemCount }})</span>
        </button>
      </div>
    </aside>
  </div>
</template>

<style scoped>
/* ========== LAYOUT ========== */
.pos-layout {
  display: grid;
  grid-template-columns: 1fr 380px;
  min-height: 100vh;
  background: var(--bg-body);
  position: relative;
}

/* ========== CATALOG ========== */
.pos-catalog {
  padding: 1.5rem 2rem;
  overflow-y: auto;
  max-height: 100vh;
}

.pos-catalog__header {
  margin-bottom: 1.5rem;
}

.pos-catalog__title {
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--text-main);
  margin-bottom: 1rem;
}

.pos-catalog__grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 1rem;
}

/* ========== TICKET ========== */
.pos-ticket {
  display: flex;
  flex-direction: column;
  background: var(--bg-surface);
  border-left: 1px solid var(--border-color);
  max-height: 100vh;
}

.pos-ticket__header {
  padding: 1rem 1.25rem;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  border-bottom: 1px solid var(--border-color);
}

.pos-ticket__select {
  flex: 1;
  font-weight: 600;
}

.pos-ticket__body {
  flex: 1;
  overflow-y: auto;
  padding: 0.75rem 1.25rem;
}

.pos-ticket__empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  gap: 0.5rem;
  color: var(--text-muted);
  font-size: 0.9rem;
}

.pos-ticket__empty-icon {
  font-size: 2.5rem;
  opacity: 0.5;
}

/* ========== FOOTER TOTALS ========== */
.pos-ticket__footer {
  padding: 1rem 1.25rem;
  border-top: 1px solid var(--border-color);
}

.pos-ticket__totals {
  margin-bottom: 1rem;
}

.pos-ticket__row {
  display: flex;
  justify-content: space-between;
  font-size: 0.875rem;
  color: var(--text-muted);
  padding: 0.2rem 0;
}

.pos-ticket__row--total {
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--text-main);
  padding-top: 0.5rem;
  margin-top: 0.35rem;
  border-top: 2px solid var(--border-color);
}

/* ========== CONFIRM BUTTON ========== */
.pos-confirm-btn {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.6rem;
  padding: 1rem;
  border: none;
  border-radius: 0.75rem;
  font-weight: 700;
  font-size: 1rem;
  background: linear-gradient(135deg, #28a745, #218838);
  color: #fff;
  cursor: pointer;
  transition: all var(--transition-speed);
}

.pos-confirm-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(40, 167, 69, 0.35);
}

.pos-confirm-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* ========== TOAST ========== */
.pos-toast {
  position: fixed;
  top: 1.5rem;
  left: 50%;
  transform: translateX(-50%);
  z-index: 9999;
  display: flex;
  align-items: center;
  gap: 0.6rem;
  padding: 0.85rem 1.5rem;
  border-radius: 0.75rem;
  font-weight: 600;
  font-size: 0.9rem;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
}

.pos-toast--success {
  background: #d4edda;
  color: #155724;
  border: 1px solid #c3e6cb;
}

.pos-toast--error {
  background: #f8d7da;
  color: #721c24;
  border: 1px solid #f5c6cb;
}

.toast-slide-enter-active,
.toast-slide-leave-active {
  transition: all 0.35s ease;
}

.toast-slide-enter-from,
.toast-slide-leave-to {
  opacity: 0;
  transform: translateX(-50%) translateY(-20px);
}

/* ========== RESPONSIVE ========== */
@media (max-width: 992px) {
  .pos-layout {
    grid-template-columns: 1fr;
    grid-template-rows: 1fr auto;
  }

  .pos-catalog {
    max-height: none;
    padding: 1rem;
  }

  .pos-ticket {
    border-left: none;
    border-top: 1px solid var(--border-color);
    max-height: 55vh;
  }

  .pos-catalog__grid {
    grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
  }
}

@media (max-width: 576px) {
  .pos-catalog__grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 0.75rem;
  }

  .pos-catalog {
    padding: 0.75rem;
  }

  .pos-catalog__title {
    font-size: 1.25rem;
  }
}
</style>
