<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { Send, ShoppingCart, AlertCircle, CheckCircle, CreditCard, X, Plus } from 'lucide-vue-next'
import ProductCard from '../components/ProductCard.vue'
import PosCategoryFilter from '../components/PosCategoryFilter.vue'
import CartItemRow from '../components/CardItemRow.vue'
import { useCart } from '../composables/useCart'
import {
  sendOrder,
  fetchCategories,
  fetchProducts,
  fetchTables,
  fetchMetodosPago,
} from '../pos.api'

const { cartItems, selectedTable, addItem, updateQuantity, addKitchenNote, removeItem, clearCart, subtotal, total } = useCart()

// UI state
const loading = ref(false)
const loadingData = ref(true)
const toast = ref<{ type: 'success' | 'error'; message: string } | null>(null)
const activeCategory = ref<number | null>(null)
const showPaymentModal = ref(false)
const clienteNombre = ref('')

// Data from API
const categories = ref<{ id: number; nombre: string }[]>([])
const tables = ref<{ id: number; nombre: string | null; numero: number }[]>([])
const products = ref<{ id: number; nombre: string; precio_venta: number; categoria_id: number; imagen_url?: string }[]>([])
const metodosPago = ref<{ id: number; nombre: string; tipo: string }[]>([])

// Payment state — múltiples pagos por venta (Regla 3 enunciado maestro)
const pagos = ref<{ metodo_pago_id: number; monto: number; referencia: string; nombre: string }[]>([])

const addPago = () => {
  if (!metodosPago.value.length) return
  const primero = metodosPago.value[0]
  if (primero) pagos.value.push({ metodo_pago_id: primero.id, monto: 0, referencia: '', nombre: primero.nombre })
}

const removePago = (idx: number) => pagos.value.splice(idx, 1)

const totalPagado = computed(() => pagos.value.reduce((s, p) => s + Number(p.monto), 0))
const vuelto = computed(() => Math.max(0, totalPagado.value - total.value))
const faltante = computed(() => Math.max(0, total.value - totalPagado.value))

const onMetodoChange = (idx: number, id: number) => {
  const m = metodosPago.value.find(m => m.id === Number(id))
  if (m && pagos.value[idx]) pagos.value[idx].nombre = m.nombre
}

// Filtered products by category
const filteredProducts = computed(() => {
  if (!activeCategory.value) return products.value
  return products.value.filter(p => p.categoria_id === activeCategory.value)
})
const itemCount = computed(() => cartItems.value.reduce((sum, i) => sum + i.quantity, 0))

// Toast helper
const showToast = (type: 'success' | 'error', message: string) => {
  toast.value = { type, message }
  setTimeout(() => { toast.value = null }, 4000)
}

// Tracking removed since we use undefined check

// Open payment modal
const openPaymentModal = () => {
  if (!cartItems.value.length) { showToast('error', 'El carrito está vacío'); return }
  if (tables.value.length > 0 && selectedTable.value === undefined) {
    showToast('error', 'Selecciona una mesa o elige "Sin mesa (para llevar)"'); return
  }
  // Auto-llenar con el total completo en el primer método
  if (metodosPago.value.length && !pagos.value.length) {
    const primero = metodosPago.value[0]
    if (primero) pagos.value = [{ metodo_pago_id: primero.id, monto: total.value, referencia: '', nombre: primero.nombre }]
  }
  showPaymentModal.value = true
}

const closePaymentModal = () => {
  showPaymentModal.value = false
  pagos.value = []
}

// Submit order
const handleConfirm = async () => {
  if (pagos.value.length === 0) { showToast('error', 'Agrega al menos un método de pago'); return }
  if (pagos.value.some(p => !p.monto || p.monto <= 0)) { showToast('error', 'Todos los pagos deben tener un monto mayor a 0'); return }

  loading.value = true
  try {
    await sendOrder({
      mesa_id: selectedTable.value,
      cliente: clienteNombre.value || null,
      items: cartItems.value.map(i => ({
        receta_id: i.product.id,
        cantidad: i.quantity,
        notas: i.notes,
      })),
      pagos: pagos.value.map(p => ({
        metodo_pago_id: p.metodo_pago_id,
        monto: Number(p.monto),
        referencia: p.referencia || undefined,
      })),
    })
    closePaymentModal()
    clearCart()
    clienteNombre.value = ''
    showToast('success', '¡Venta registrada! Pedido enviado a cocina 🍳')
  } catch (e: unknown) {
    const msg = e instanceof Error ? e.message : 'Error desconocido'
    showToast('error', msg)
  } finally {
    loading.value = false
  }
}

onMounted(async () => {
  try {
    const results = await Promise.allSettled([
      fetchCategories(),
      fetchProducts(),
      fetchTables(),
      fetchMetodosPago(),
    ])

    if (results[0].status === 'fulfilled') categories.value = results[0].value || []
    if (results[1].status === 'fulfilled') {
      products.value = (results[1].value || []).map((p: any) => ({ ...p, precio_venta: parseFloat(p.precio_venta) }))
    }
    if (results[2].status === 'fulfilled') tables.value = results[2].value || []
    if (results[3].status === 'fulfilled') metodosPago.value = results[3].value || []
    else showToast('error', 'No se pudieron cargar los métodos de pago')

  } catch (e: unknown) {
    const msg = e instanceof Error ? e.message : 'No se pudo conectar con el servidor'
    showToast('error', msg)
  } finally {
    loadingData.value = false
  }
})
</script>

<template>
  <div class="pos-layout">
    <!-- Toast Notification -->
    <Transition name="toast-slide">
      <div v-if="toast" class="pos-toast" :class="`pos-toast--${toast.type}`">
        <CheckCircle v-if="toast.type === 'success'" :size="18" />
        <AlertCircle v-else :size="18" />
        <span>{{ toast.message }}</span>
      </div>
    </Transition>

    <!-- LEFT: Catalogue -->
    <section class="pos-catalog">
      <header class="pos-catalog__header">
        <h1 class="pos-catalog__title">Punto de Venta</h1>
        <div class="pos-catalog__controls">
          <input
            v-model="clienteNombre"
            type="text"
            class="form-control form-control-sm pos-client-input"
            placeholder="Nombre del cliente (opcional)"
          />
        </div>
        <PosCategoryFilter
          :categories="categories"
          :active-category="activeCategory"
          @filter-changed="activeCategory = $event"
        />
      </header>

      <!-- Loading Skeleton -->
      <div v-if="loadingData" class="pos-loading">
        <div v-for="n in 8" :key="n" class="pos-skeleton-card"></div>
      </div>

      <div v-else class="pos-catalog__grid">
        <ProductCard
          v-for="p in filteredProducts"
          :key="p.id"
          :product="p"
          @add-to-cart="addItem"
        />
      </div>

      <p v-if="!loadingData && !filteredProducts.length" class="pos-empty-catalog">
        No hay productos en esta categoría.
      </p>
    </section>

    <!-- RIGHT: Ticket / Cart -->
    <aside class="pos-ticket">
      <!-- Table Selector -->
      <div class="pos-ticket__header">
        <ShoppingCart :size="20" class="text-korange" />
        <select
          v-model="selectedTable"
          class="form-select form-select-sm pos-ticket__select"
        >
          <option :value="undefined" disabled>— Selecciona mesa —</option>
          <option :value="null">Sin mesa (para llevar)</option>
          <option v-for="t in tables" :key="t.id" :value="t.id">
            {{ t.nombre || `Mesa ${t.numero}` }}
          </option>
        </select>
      </div>

      <!-- Cart Items -->
      <div class="pos-ticket__body">
        <div v-if="!cartItems.length" class="pos-ticket__empty">
          <span class="pos-ticket__empty-icon">🛒</span>
          <span>Selecciona productos del catálogo</span>
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

      <!-- Footer: Totals -->
      <div class="pos-ticket__footer">
        <div class="pos-ticket__totals">
          <div class="pos-ticket__row">
            <span>Subtotal</span>
            <span>Bs. {{ subtotal.toFixed(2) }}</span>
          </div>
          <div class="pos-ticket__row pos-ticket__row--total">
            <span>TOTAL</span>
            <span>Bs. {{ total.toFixed(2) }}</span>
          </div>
        </div>

        <button
          class="pos-confirm-btn"
          :disabled="!cartItems.length"
          @click="openPaymentModal"
        >
          <CreditCard :size="20" />
          <span>COBRAR ({{ itemCount }} ítem{{ itemCount !== 1 ? 's' : '' }})</span>
        </button>

        <button
          v-if="cartItems.length"
          class="pos-clear-btn"
          @click="clearCart"
        >
          Limpiar carrito
        </button>
      </div>
    </aside>

    <!-- ===== PAYMENT MODAL (Regla 3: múltiples métodos) ===== -->
    <Transition name="modal-fade">
      <div v-if="showPaymentModal" class="pos-modal-overlay" @click.self="closePaymentModal">
        <div class="pos-modal">
          <div class="pos-modal__header">
            <h2>Registrar Cobro</h2>
            <button class="pos-modal__close" @click="closePaymentModal">
              <X :size="20" />
            </button>
          </div>

          <div class="pos-modal__body">
            <!-- Order Summary -->
            <div class="pos-modal__summary">
              <div class="pos-modal__summary-row">
                <span>Total a cobrar</span>
                <strong class="pos-modal__total">Bs. {{ total.toFixed(2) }}</strong>
              </div>
            </div>

            <!-- Payment Methods List -->
            <div class="pos-modal__section-title">Métodos de Pago</div>

            <div v-if="!metodosPago.length" class="pos-modal__warn">
              ⚠️ No hay métodos de pago configurados. Configúralos en Administración.
            </div>

            <div
              v-for="(pago, idx) in pagos"
              :key="idx"
              class="pos-pago-row"
            >
              <select
                v-model="pago.metodo_pago_id"
                class="form-select form-select-sm pos-pago-row__select"
                @change="onMetodoChange(idx, pago.metodo_pago_id)"
              >
                <option v-for="m in metodosPago" :key="m.id" :value="m.id">
                  {{ m.nombre }}
                </option>
              </select>

              <input
                v-model.number="pago.monto"
                type="number"
                min="0"
                step="0.01"
                class="form-control form-control-sm pos-pago-row__amount"
                placeholder="Monto"
              />

              <input
                v-if="pago.metodo_pago_id"
                v-model="pago.referencia"
                type="text"
                class="form-control form-control-sm pos-pago-row__ref"
                placeholder="Referencia (opcional)"
              />

              <button class="pos-pago-row__remove" @click="removePago(idx)" aria-label="Eliminar pago">
                <X :size="14" />
              </button>
            </div>

            <button
              v-if="metodosPago.length"
              class="pos-add-pago-btn"
              @click="addPago"
            >
              <Plus :size="16" /> Agregar otro método de pago
            </button>

            <!-- Change / Balance Summary -->
            <div class="pos-modal__balance">
              <div class="pos-modal__balance-row">
                <span>Total cobrado</span>
                <span :class="totalPagado >= total ? 'pos-ok' : 'pos-warn'">
                  Bs. {{ totalPagado.toFixed(2) }}
                </span>
              </div>
              <div v-if="faltante > 0" class="pos-modal__balance-row">
                <span>Faltante</span>
                <span class="pos-warn">Bs. {{ faltante.toFixed(2) }}</span>
              </div>
              <div v-if="vuelto > 0" class="pos-modal__balance-row pos-modal__balance-row--change">
                <span>Vuelto</span>
                <strong class="pos-ok">Bs. {{ vuelto.toFixed(2) }}</strong>
              </div>
            </div>
          </div>

          <div class="pos-modal__footer">
            <button class="pos-btn-cancel" @click="closePaymentModal">Cancelar</button>
            <button
              class="pos-btn-confirm"
              :disabled="loading || pagos.length === 0"
              @click="handleConfirm"
            >
              <Send :size="16" />
              <span v-if="loading">Procesando...</span>
              <span v-else>Confirmar Venta</span>
            </button>
          </div>
        </div>
      </div>
    </Transition>
  </div>
</template>

<style scoped>
/* ========== LAYOUT ========== */
.pos-layout {
  display: grid;
  grid-template-columns: 1fr 360px;
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
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.pos-catalog__title {
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--text-main);
  margin: 0;
}

.pos-catalog__controls {
  display: flex;
  gap: 0.5rem;
}

.pos-client-input {
  max-width: 280px;
}

.pos-catalog__grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 1rem;
}

.pos-empty-catalog {
  text-align: center;
  color: var(--text-muted);
  margin-top: 2rem;
}

/* Loading skeleton */
.pos-loading {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 1rem;
}

.pos-skeleton-card {
  height: 160px;
  border-radius: 1rem;
  background: linear-gradient(90deg, var(--bg-surface) 25%, var(--border-color) 50%, var(--bg-surface) 75%);
  background-size: 200% 100%;
  animation: shimmer 1.4s infinite;
}

@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
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

.pos-ticket__select { flex: 1; font-weight: 600; }

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
  text-align: center;
}

.pos-ticket__empty-icon { font-size: 2.5rem; opacity: 0.5; }

/* ========== FOOTER TOTALS ========== */
.pos-ticket__footer {
  padding: 1rem 1.25rem;
  border-top: 1px solid var(--border-color);
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.pos-ticket__totals { display: flex; flex-direction: column; gap: 0.25rem; }

.pos-ticket__row {
  display: flex;
  justify-content: space-between;
  font-size: 0.875rem;
  color: var(--text-muted);
  padding: 0.2rem 0;
}

.pos-ticket__row--total {
  font-size: 1.3rem;
  font-weight: 700;
  color: var(--text-main);
  padding-top: 0.5rem;
  margin-top: 0.25rem;
  border-top: 2px solid var(--border-color);
}

/* ========== BUTTONS ========== */
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
  background: linear-gradient(135deg, var(--KOrange), var(--KOrange-hover));
  color: #fff;
  cursor: pointer;
  transition: all var(--transition-speed);
  user-select: none;
}

.pos-confirm-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(253, 126, 20, 0.35);
}

.pos-confirm-btn:disabled { opacity: 0.45; cursor: not-allowed; }

.pos-clear-btn {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid var(--border-color);
  border-radius: 0.5rem;
  background: transparent;
  color: var(--text-muted);
  font-size: 0.8rem;
  cursor: pointer;
  transition: all var(--transition-speed);
}

.pos-clear-btn:hover { border-color: #dc3545; color: #dc3545; }

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
  white-space: nowrap;
}

.pos-toast--success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
.pos-toast--error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

.toast-slide-enter-active, .toast-slide-leave-active { transition: all 0.35s ease; }
.toast-slide-enter-from, .toast-slide-leave-to { opacity: 0; transform: translateX(-50%) translateY(-20px); }

/* ========== MODAL ========== */
.pos-modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1050;
  padding: 1rem;
}

.pos-modal {
  background: var(--bg-body);
  border-radius: 1rem;
  width: 100%;
  max-width: 520px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  display: flex;
  flex-direction: column;
  max-height: 90vh;
  overflow: hidden;
}

.pos-modal__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.25rem 1.5rem;
  border-bottom: 1px solid var(--border-color);
}

.pos-modal__header h2 {
  margin: 0;
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--text-main);
}

.pos-modal__close {
  border: none;
  background: transparent;
  color: var(--text-muted);
  cursor: pointer;
  padding: 0.25rem;
  border-radius: 0.375rem;
  line-height: 1;
  transition: color var(--transition-speed);
}

.pos-modal__close:hover { color: var(--text-main); }

.pos-modal__body {
  padding: 1.25rem 1.5rem;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.pos-modal__summary {
  background: var(--bg-surface);
  border-radius: 0.75rem;
  padding: 1rem;
}

.pos-modal__summary-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.pos-modal__total {
  font-size: 1.5rem;
  font-weight: 800;
  color: var(--KOrange);
}

.pos-modal__section-title {
  font-weight: 700;
  font-size: 0.85rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  color: var(--text-muted);
}

.pos-modal__warn {
  font-size: 0.875rem;
  color: #856404;
  background: #fff3cd;
  border: 1px solid #ffc107;
  border-radius: 0.5rem;
  padding: 0.75rem 1rem;
}

/* Payment Row */
.pos-pago-row {
  display: flex;
  gap: 0.5rem;
  align-items: center;
  flex-wrap: wrap;
}

.pos-pago-row__select { flex: 2; min-width: 120px; }
.pos-pago-row__amount { flex: 1; min-width: 90px; }
.pos-pago-row__ref { flex: 2; min-width: 100px; font-size: 0.8rem; }

.pos-pago-row__remove {
  border: none;
  background: transparent;
  color: #dc3545;
  cursor: pointer;
  padding: 0.25rem;
  border-radius: 0.375rem;
  line-height: 1;
  flex-shrink: 0;
}

.pos-add-pago-btn {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  border: 1.5px dashed var(--border-color);
  background: transparent;
  color: var(--text-muted);
  border-radius: 0.5rem;
  padding: 0.5rem 0.75rem;
  font-size: 0.875rem;
  cursor: pointer;
  transition: all var(--transition-speed);
  width: fit-content;
}

.pos-add-pago-btn:hover { border-color: var(--KOrange); color: var(--KOrange); }

/* Balance */
.pos-modal__balance {
  background: var(--bg-surface);
  border-radius: 0.75rem;
  padding: 0.875rem 1rem;
  display: flex;
  flex-direction: column;
  gap: 0.35rem;
}

.pos-modal__balance-row {
  display: flex;
  justify-content: space-between;
  font-size: 0.9rem;
  color: var(--text-muted);
}

.pos-modal__balance-row--change {
  font-size: 1rem;
  font-weight: 700;
  padding-top: 0.4rem;
  margin-top: 0.25rem;
  border-top: 1px solid var(--border-color);
}

.pos-ok { color: #198754; font-weight: 700; }
.pos-warn { color: #dc3545; font-weight: 700; }

/* Modal Footer */
.pos-modal__footer {
  padding: 1.25rem 1.5rem;
  border-top: 1px solid var(--border-color);
  display: flex;
  gap: 0.75rem;
  justify-content: flex-end;
}

.pos-btn-cancel {
  padding: 0.75rem 1.5rem;
  border: 1px solid var(--border-color);
  border-radius: 0.6rem;
  background: transparent;
  color: var(--text-muted);
  cursor: pointer;
  font-weight: 600;
  transition: all var(--transition-speed);
}

.pos-btn-cancel:hover { border-color: var(--text-main); color: var(--text-main); }

.pos-btn-confirm {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.75rem;
  border: none;
  border-radius: 0.6rem;
  background: linear-gradient(135deg, var(--KOrange), var(--KOrange-hover));
  color: #fff;
  font-weight: 700;
  font-size: 1rem;
  cursor: pointer;
  transition: all var(--transition-speed);
}

.pos-btn-confirm:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 4px 16px rgba(253, 126, 20, 0.4);
}

.pos-btn-confirm:disabled { opacity: 0.5; cursor: not-allowed; }

/* Modal animation */
.modal-fade-enter-active, .modal-fade-leave-active { transition: all 0.3s ease; }
.modal-fade-enter-from, .modal-fade-leave-to { opacity: 0; }
.modal-fade-enter-from .pos-modal, .modal-fade-leave-to .pos-modal {
  transform: scale(0.95) translateY(20px);
}

/* ========== RESPONSIVE ========== */
@media (max-width: 992px) {
  .pos-layout {
    grid-template-columns: 1fr;
    grid-template-rows: 1fr auto;
  }
  .pos-catalog { max-height: none; padding: 1rem; }
  .pos-ticket { border-left: none; border-top: 1px solid var(--border-color); max-height: 55vh; }
  .pos-catalog__grid { grid-template-columns: repeat(auto-fill, minmax(130px, 1fr)); }
}

@media (max-width: 576px) {
  .pos-catalog__grid { grid-template-columns: repeat(2, 1fr); gap: 0.75rem; }
  .pos-catalog { padding: 0.75rem; }
  .pos-catalog__title { font-size: 1.25rem; }
  .pos-pago-row { flex-direction: column; }
  .pos-pago-row__select, .pos-pago-row__amount, .pos-pago-row__ref { min-width: 100%; }
}
</style>
