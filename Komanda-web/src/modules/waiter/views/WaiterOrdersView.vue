<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import {
  Send, LayoutGrid, Trash2, Plus, Minus, RefreshCw,
  ChefHat, CheckCircle2, Clock, XCircle, UtensilsCrossed
} from 'lucide-vue-next'
import Sidebar from '../../../components/Sidebar.vue'
import { useAuth } from '../../../core/composables/useAuth'
import { waiterApi, type ActiveOrder } from '../waiter.api'

const auth = useAuth()
const router = useRouter()

// ─── Data ────────────────────────────────────────────────
const tables = ref<any[]>([])
const products = ref<any[]>([])
const categories = ref<any[]>([])
const loading = ref(true)
const sending = ref(false)

// ─── Cart / Form ─────────────────────────────────────────
const selectedTable = ref<number | null | undefined>(undefined)
const clienteName = ref('')
const activeCategory = ref<number | null>(null)
const cart = ref<{ product: any; quantity: number; notes: string }[]>([])

const toast = ref<{ type: 'success' | 'error'; message: string } | null>(null)

const showToast = (type: 'success' | 'error', message: string) => {
  toast.value = { type, message }
  setTimeout(() => { toast.value = null }, 3500)
}

// ─── Computed ─────────────────────────────────────────────
const filteredProducts = computed(() =>
  activeCategory.value
    ? products.value.filter(p => p.categoria_id === activeCategory.value)
    : products.value
)

const cartTotal = computed(() =>
  cart.value.reduce((sum, item) => sum + Number(item.product.precio_venta) * item.quantity, 0)
)

const cartCount = computed(() => cart.value.reduce((s, i) => s + i.quantity, 0))

// ─── Cart actions ─────────────────────────────────────────
const addToCart = (product: any) => {
  const existing = cart.value.find(i => i.product.id === product.id)
  if (existing) { existing.quantity++ } 
  else { cart.value.push({ product, quantity: 1, notes: '' }) }
}

const changeQty = (productId: number, delta: number) => {
  const item = cart.value.find(i => i.product.id === productId)
  if (!item) return
  item.quantity += delta
  if (item.quantity <= 0) cart.value = cart.value.filter(i => i.product.id !== productId)
}

const removeFromCart = (productId: number) => {
  cart.value = cart.value.filter(i => i.product.id !== productId)
}

const clearCart = () => { cart.value = []; clienteName.value = ''; selectedTable.value = undefined }

// ─── Send order ───────────────────────────────────────────
const sendOrder = async () => {
  if (!cart.value.length) { showToast('error', 'El carrito está vacío'); return }
  if (selectedTable.value === undefined) { showToast('error', 'Selecciona una mesa'); return }

  sending.value = true
  try {
    await waiterApi.sendOrder({
      mesa_id: selectedTable.value,
      cliente: clienteName.value || null,
      items: cart.value.map(i => ({
        receta_id: i.product.id,
        cantidad: i.quantity,
        notas: i.notes
      }))
    })
    showToast('success', '¡Pedido enviado a cocina! 🍳')
    clearCart()
  } catch (e: any) {
    showToast('error', e.message || 'Error enviando pedido')
  } finally {
    sending.value = false
  }
}

// ─── Fetch ────────────────────────────────────────────────

onMounted(async () => {
  try {
    const [t, p, c] = await Promise.all([
      waiterApi.getTables(),
      waiterApi.getProducts(),
      waiterApi.getCategories()
    ])
    tables.value = t
    products.value = p.map((x: any) => ({ ...x, precio_venta: parseFloat(x.precio_venta) }))
    categories.value = c
  } catch (e) {
    showToast('error', 'Error cargando datos del servidor')
  } finally {
    loading.value = false
  }
})

// ─── Helpers ──────────────────────────────────────────────
</script>

<template>
<div class="d-flex w-100">
  <Sidebar :role="auth.user.value?.role || 'mesero'" :userName="auth.user.value?.nombre" />

  <div class="orders-main main-content">
    <!-- Toast -->
    <div v-if="toast" class="orders-toast" :class="toast.type === 'success' ? 'toast-ok' : 'toast-err'">
      {{ toast.type === 'success' ? '✅' : '⚠️' }} {{ toast.message }}
    </div>

    <div v-if="loading" class="d-flex align-items-center justify-content-center" style="min-height:100vh">
      <div class="text-center">
        <div class="spinner-border text-korange mb-3" style="width:3rem;height:3rem;"></div>
        <p class="text-secondary-custom">Cargando módulo de pedidos...</p>
      </div>
    </div>

    <div v-else class="orders-layout">
      <!-- ═══ CENTRO: Catálogo de platos ═══ -->
      <section class="orders-catalog">
        <div class="p-3 border-bottom border-color">
          <h5 class="fw-bold text-primary-custom mb-0 d-flex align-items-center gap-2">
            <LayoutGrid :size="20" class="text-korange" /> Menú
          </h5>
          <!-- Filtro de categorías -->
          <div class="d-flex flex-wrap gap-2 mt-2">
            <button
              @click="activeCategory = null"
              :class="['btn btn-sm rounded-pill fw-semibold', !activeCategory ? 'btn-korange' : 'btn-outline-secondary']"
            >Todos</button>
            <button
              v-for="cat in categories" :key="cat.id"
              @click="activeCategory = cat.id"
              :class="['btn btn-sm rounded-pill fw-semibold', activeCategory === cat.id ? 'btn-korange' : 'btn-outline-secondary']"
            >{{ cat.nombre }}</button>
          </div>
        </div>

        <div class="catalog-grid p-3">
          <div
            v-for="product in filteredProducts" :key="product.id"
            @click="addToCart(product)"
            class="product-card rounded-3 border border-color p-3 text-center cursor-pointer bg-surface-custom hover-card"
          >
            <div class="product-icon mb-2">🍽️</div>
            <p class="small fw-bold text-primary-custom mb-1 text-truncate">{{ product.nombre }}</p>
            <span class="text-korange fw-bold small">Bs. {{ Number(product.precio_venta).toFixed(2) }}</span>
          </div>
        </div>
      </section>

      <!-- ═══ DERECHA: Ticket / carrito ═══ -->
      <aside class="orders-ticket bg-surface-custom border-start border-color d-flex flex-column">
        <div class="p-3 border-bottom border-color">
          <h5 class="fw-bold text-primary-custom mb-0 d-flex align-items-center gap-2">
            <Send :size="18" class="text-korange" /> Nuevo Pedido
          </h5>
        </div>

        <!-- Mesa + cliente -->
        <div class="p-3 border-bottom border-color">
          <label class="form-label small fw-bold text-secondary-custom">Mesa</label>
          <select v-model="selectedTable" class="form-select form-select-sm bg-transparent border-color text-primary-custom mb-2">
            <option :value="undefined" disabled>— Selecciona mesa —</option>
            <option v-for="t in tables" :key="t.id" :value="t.id">
              {{ t.nombre || `Mesa ${t.numero}` }}
            </option>
          </select>
          <input v-model="clienteName" type="text" class="form-control form-control-sm bg-transparent border-color text-primary-custom" placeholder="Nombre del cliente (opcional)" />
        </div>

        <!-- Cart items -->
        <div class="ticket-body flex-grow-1 overflow-auto p-3">
          <div v-if="!cart.length" class="text-center text-secondary-custom small py-4">
            <div style="font-size:2rem">🛒</div>
            Selecciona platos del menú
          </div>
          <div v-for="item in cart" :key="item.product.id" class="ticket-item mb-2 pb-2 border-bottom border-color">
            <div class="d-flex justify-content-between align-items-start">
              <span class="small fw-bold text-primary-custom" style="max-width:130px">{{ item.product.nombre }}</span>
              <button @click="removeFromCart(item.product.id)" class="btn btn-sm btn-link text-danger p-0">
                <Trash2 :size="14" />
              </button>
            </div>
            <div class="d-flex justify-content-between align-items-center mt-1">
              <div class="d-flex align-items-center gap-1">
                <button @click="changeQty(item.product.id, -1)" class="btn btn-sm btn-outline-secondary rounded-circle p-0" style="width:22px;height:22px;line-height:1">
                  <Minus :size="12" />
                </button>
                <span class="small fw-bold px-1">{{ item.quantity }}</span>
                <button @click="changeQty(item.product.id, 1)" class="btn btn-sm btn-outline-secondary rounded-circle p-0" style="width:22px;height:22px;line-height:1">
                  <Plus :size="12" />
                </button>
              </div>
              <span class="small fw-bold text-korange">Bs. {{ (Number(item.product.precio_venta) * item.quantity).toFixed(2) }}</span>
            </div>
            <input v-model="item.notes" type="text" class="form-control form-control-sm bg-transparent border-color text-secondary-custom mt-1" placeholder="Nota para cocina (opcional)" style="font-size:0.75rem" />
          </div>
        </div>

        <!-- Footer -->
        <div class="p-3 border-top border-color">
          <div class="d-flex justify-content-between fw-bold text-primary-custom mb-3">
            <span>TOTAL</span>
            <span class="text-korange">Bs. {{ cartTotal.toFixed(2) }}</span>
          </div>
          <button
            @click="sendOrder"
            :disabled="sending || !cart.length"
            class="btn btn-korange w-100 fw-bold rounded-3 d-flex align-items-center justify-content-center gap-2 py-2"
          >
            <span v-if="sending" class="spinner-border spinner-border-sm"></span>
            <ChefHat v-else :size="18" />
            {{ sending ? 'Enviando...' : `Enviar a Cocina (${cartCount})` }}
          </button>
          <button v-if="cart.length" @click="clearCart" class="btn btn-outline-secondary w-100 mt-2 btn-sm rounded-3">
            Limpiar carrito
          </button>
        </div>
      </aside>
    </div>
  </div>
</div>
</template>

<style scoped>
.orders-main {
  background: var(--bg-body);
  min-height: 100vh;
  width: 100%;
}
@media (min-width: 768px) {
  .main-content { margin-left: 260px; width: calc(100% - 260px); }
}

.orders-layout {
  display: grid;
  grid-template-columns: 1fr 300px;
  height: 100vh;
  overflow: hidden;
}
@media (max-width: 991px) {
  .orders-layout {
    grid-template-columns: 1fr;
    grid-template-rows: auto;
    height: auto;
    overflow: auto;
  }
  .orders-ticket { min-height: 350px; }
}

/* Catálogo */
.orders-catalog { overflow-y: auto; }
.catalog-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
  gap: 0.75rem;
}
.product-card { cursor: pointer; transition: all 0.15s ease; }
.hover-card:hover { border-color: var(--KOrange) !important; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(253,126,20,.15); }
.product-icon { font-size: 1.75rem; }

/* Ticket */
.orders-ticket { overflow: hidden; }
.ticket-body { }

/* Toast */
.orders-toast {
  position: fixed; top: 1rem; right: 1rem; z-index: 9999;
  padding: 0.75rem 1.25rem; border-radius: 0.75rem; font-weight: 600; font-size: 0.9rem;
  box-shadow: 0 4px 20px rgba(0,0,0,.15);
}
.toast-ok { background: #d1e7dd; color: #0a3622; border: 1px solid #a3cfbb; }
.toast-err { background: #f8d7da; color: #58151c; border: 1px solid #f1aeb5; }

.bg-surface-custom { background: var(--bg-surface); }
.text-primary-custom { color: var(--text-primary); }
.text-secondary-custom { color: var(--text-muted); }
.border-color { border-color: var(--border-color) !important; }
.text-korange { color: var(--KOrange) !important; }
.btn-korange { background: var(--KOrange); border: none; color: white; }
.btn-korange:hover:not(:disabled) { background: #e06d0e; color: white; }
.btn-korange:disabled { opacity: 0.5; }
</style>
