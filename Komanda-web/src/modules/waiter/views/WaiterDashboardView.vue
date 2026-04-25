<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { ClipboardList, UtensilsCrossed, CheckCircle2, Clock, Table2, Plus, RefreshCw } from 'lucide-vue-next'
import Sidebar from '../../../components/Sidebar.vue'
import { useAuth } from '../../../core/composables/useAuth'
import { waiterApi, type ActiveOrder } from '../waiter.api'

const auth = useAuth()
const router = useRouter()

const orders = ref<ActiveOrder[]>([])
const loading = ref(true)
const toast = ref<{ type: 'success' | 'error'; message: string } | null>(null)
const selectedOrder = ref<ActiveOrder | null>(null)

let pollInterval: ReturnType<typeof setInterval> | null = null

const showToast = (type: 'success' | 'error', message: string) => {
  toast.value = { type, message }
  setTimeout(() => { toast.value = null }, 3500)
}

const fetchOrders = async () => {
  try {
    orders.value = await waiterApi.getActiveOrders()
  } catch (e: any) {
    showToast('error', 'Error cargando pedidos')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchOrders()
  // Poll cada 30s para refrescar sin WebSocket
  pollInterval = setInterval(fetchOrders, 30000)
})

onUnmounted(() => {
  if (pollInterval) clearInterval(pollInterval)
})

// KPI calculados (solo 2 estados como se solicitó)
const visibleOrders = computed(() => orders.value.filter(o => o.estado !== 'listo'))
const pendingOrders = computed(() => orders.value.filter(o => o.estado !== 'listo').length)
const readyOrders = computed(() => orders.value.filter(o => o.estado === 'listo').length)

const kpis = computed(() => [
  { label: 'Pendientes', value: pendingOrders.value, icon: Clock, color: 'text-warning', bg: 'bg-warning-subtle' },
  { label: 'Listos', value: readyOrders.value, icon: CheckCircle2, color: 'text-success', bg: 'bg-success-subtle' },
  { label: 'Total Activos', value: orders.value.length, icon: ClipboardList, color: 'text-korange', bg: 'bg-korange-subtle' },
])

const statusBadge = (estado: string) => {
  if (estado === 'listo') return { class: 'badge-ready', label: '¡Listo!' }
  if (estado === 'anulado') return { class: 'badge-cancelled', label: 'Anulado' }
  // Cualquier otro estado (pendiente, preparando) se considera Pendiente para el mesero
  return { class: 'badge-pending', label: 'Pendiente' }
}

const formatTime = (dateStr: string) => {
  const d = new Date(dateStr)
  return d.toLocaleTimeString('es-VE', { hour: '2-digit', minute: '2-digit' })
}

const viewOrderDetails = (order: ActiveOrder) => {
  selectedOrder.value = order
}
const closeOrderDetails = () => {
  selectedOrder.value = null
}

const updating = ref(false)
const cancelOrder = async (order: ActiveOrder) => {
  if (!confirm(`¿Estás seguro de que deseas anular el pedido #${order.codigo}?`)) return
  
  updating.value = true
  try {
    await waiterApi.updateOrderStatus(order.id, 'anulado')
    showToast('success', 'Pedido anulado correctamente')
    closeOrderDetails()
    await fetchOrders()
  } catch (e: any) {
    showToast('error', e.message || 'Error anulando pedido')
  } finally {
    updating.value = false
  }
}
</script>

<template>
<div class="d-flex w-100">
  <Sidebar :role="auth.user.value?.role || 'mesero'" :userName="auth.user.value?.nombre" />

  <main class="waiter-main main-content">
    <!-- Toast -->
    <div v-if="toast" class="waiter-toast" :class="toast.type === 'success' ? 'waiter-toast--ok' : 'waiter-toast--err'">
      {{ toast.type === 'success' ? '✅' : '⚠️' }} {{ toast.message }}
    </div>

    <div class="container-fluid py-4 px-3 px-md-4">
      <!-- Header -->
      <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
        <div>
          <span class="text-korange fw-bold text-uppercase small tracking-wide">Bienvenido de vuelta</span>
          <h2 class="fw-bold mt-1 mb-1 text-primary-custom">
            {{ auth.user.value?.nombre || 'Mesero' }} 👋
          </h2>
          <p class="text-secondary-custom small mb-0">Aquí está el resumen de pedidos activos en tu turno</p>
        </div>
        <div class="d-flex gap-2">
          <button @click="fetchOrders" class="btn btn-outline-secondary btn-sm rounded-pill d-flex align-items-center gap-2">
            <RefreshCw :size="15" /> Actualizar
          </button>
          <button @click="router.push('/pedidos')" class="btn btn-korange rounded-pill px-4 fw-bold d-flex align-items-center gap-2">
            <Plus :size="18" /> Tomar Pedido
          </button>
        </div>
      </div>

      <div class="row g-3 mb-4">
        <div class="col-12 col-md-4" v-for="kpi in kpis" :key="kpi.label">
          <div class="kpi-card rounded-4 p-3 h-100">
            <div class="d-flex align-items-center gap-3">
              <div :class="['kpi-icon rounded-3 d-flex align-items-center justify-content-center', kpi.bg]">
                <component :is="kpi.icon" :size="22" :class="kpi.color" />
              </div>
              <div>
                <div class="kpi-value fw-black text-primary-custom">{{ kpi.value }}</div>
                <div class="kpi-label text-secondary-custom">{{ kpi.label }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Loading -->
      <div v-if="loading" class="text-center py-5">
        <div class="spinner-border text-korange"></div>
        <p class="mt-3 text-secondary-custom small">Cargando pedidos...</p>
      </div>

      <!-- Empty state -->
      <div v-else-if="!visibleOrders.length" class="text-center py-5 rounded-4 bg-surface-custom border border-color">
        <Table2 :size="48" class="text-secondary-custom mb-3 opacity-40" />
        <h5 class="fw-bold text-primary-custom">No hay pedidos activos</h5>
        <p class="text-secondary-custom small mb-4">¡Perfecto! Cuando registres un nuevo pedido aparecerá aquí.</p>
        <button @click="router.push('/pedidos')" class="btn btn-korange rounded-pill px-4 fw-bold">
          Tomar Primer Pedido
        </button>
      </div>

      <!-- Pedidos activos -->
      <div v-else>
        <h6 class="fw-bold text-secondary-custom text-uppercase small mb-3">Pedidos Activos ({{ visibleOrders.length }})</h6>
        <div class="row g-3">
          <div class="col-12 col-md-6 col-xl-4" v-for="order in visibleOrders" :key="order.id">
            <div class="order-card rounded-4 p-3 h-100 border border-color bg-surface-custom">
              <!-- Header del card -->
              <div class="d-flex justify-content-between align-items-start mb-2">
                <div>
                  <span class="order-code fw-bold text-primary-custom">#{{ order.codigo }}</span>
                  <div class="text-secondary-custom small mt-1">
                    🕒 {{ formatTime(order.fecha_hora) }}
                  </div>
                </div>
                <span class="badge rounded-pill fw-bold" :class="statusBadge(order.estado).class">
                  {{ statusBadge(order.estado).label }}
                </span>
              </div>

              <!-- Mesa y cliente -->
              <div class="d-flex align-items-center gap-2 mb-2">
                <span class="badge bg-secondary-subtle text-secondary border border-secondary border-opacity-25 rounded-pill">
                  {{ order.mesa_nombre || (order.mesa_numero ? `Mesa ${order.mesa_numero}` : '🛵 Para llevar') }}
                </span>
                <span v-if="order.cliente" class="text-secondary-custom small">{{ order.cliente }}</span>
              </div>

              <!-- Items resumidos -->
              <ul class="list-unstyled mb-2 small">
                <li v-for="item in (order.items || []).slice(0, 3)" :key="item.id" class="text-secondary-custom d-flex justify-content-between">
                  <span>{{ item.cantidad }}× {{ item.nombre }}</span>
                </li>
                <li v-if="(order.items || []).length > 3" class="text-korange small">
                  +{{ (order.items || []).length - 3 }} más...
                </li>
              </ul>

              <!-- Total y acciones -->
              <div class="d-flex justify-content-between align-items-center border-top border-color pt-2 mt-2">
                <span class="fw-bold text-primary-custom">Bs. {{ Number(order.total).toFixed(2) }}</span>
                <button @click="viewOrderDetails(order)" class="btn btn-sm btn-outline-korange rounded-pill">
                  Ver detalles
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>

  <!-- Modal de Detalles del Pedido -->
  <div v-if="selectedOrder" class="modal-backdrop fade show" style="z-index: 1050;"></div>
  <div v-if="selectedOrder" class="modal fade show d-block" tabindex="-1" style="z-index: 1055;" @click.self="closeOrderDetails">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content bg-surface-custom border-color shadow">
        <div class="modal-header border-bottom border-color">
          <h5 class="modal-title fw-bold text-primary-custom">Pedido #{{ selectedOrder.codigo }}</h5>
          <button type="button" class="btn-close" @click="closeOrderDetails"></button>
        </div>
        <div class="modal-body text-primary-custom">
          <div class="d-flex justify-content-between mb-3">
            <div>
              <span class="fw-bold d-block">Mesa:</span>
              <span class="text-secondary-custom">{{ selectedOrder.mesa_nombre || (selectedOrder.mesa_numero ? 'Mesa ' + selectedOrder.mesa_numero : '🛵 Para llevar') }}</span>
            </div>
            <div class="text-end">
              <span class="fw-bold d-block">Estado:</span>
              <span class="badge rounded-pill fw-bold" :class="statusBadge(selectedOrder.estado).class">
                {{ statusBadge(selectedOrder.estado).label }}
              </span>
            </div>
          </div>
          
          <div v-if="selectedOrder.cliente" class="mb-3">
            <span class="fw-bold">Cliente:</span> <span class="text-secondary-custom">{{ selectedOrder.cliente }}</span>
          </div>

          <h6 class="fw-bold border-bottom border-color pb-2 mb-2">Artículos ({{ selectedOrder.items?.length || 0 }})</h6>
          <ul class="list-unstyled mb-0">
            <li v-for="item in selectedOrder.items" :key="item.id" class="d-flex justify-content-between py-2 border-bottom border-color" style="border-style: dashed !important;">
              <div>
                <span class="fw-bold">{{ item.cantidad }}×</span> {{ item.nombre }}
                <div v-if="item.notas" class="small text-korange mt-1 fst-italic">Nota: {{ item.notas }}</div>
              </div>
              <span class="fw-bold">Bs. {{ Number(item.subtotal).toFixed(2) }}</span>
            </li>
          </ul>
        </div>
        <div class="modal-footer border-top border-color d-flex justify-content-between align-items-center bg-body-tertiary">
          <span class="fw-bold fs-5 text-primary-custom">Total: <span class="text-korange">Bs. {{ Number(selectedOrder.total).toFixed(2) }}</span></span>
          <div class="d-flex gap-2">
            <button 
              type="button" 
              class="btn btn-outline-danger rounded-pill px-3" 
              @click="cancelOrder(selectedOrder)"
              :disabled="updating"
            >
              <span v-if="updating" class="spinner-border spinner-border-sm me-1"></span>
              Anular
            </button>
            <button type="button" class="btn btn-outline-secondary rounded-pill px-3" @click="closeOrderDetails">Cerrar</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</template>

<style scoped>
.waiter-main {
  background-color: var(--bg-body);
  min-height: 100vh;
  width: 100%;
}
@media (min-width: 768px) {
  .main-content { margin-left: 260px; width: calc(100% - 260px); }
}

.kpi-card {
  background: var(--bg-surface);
  border: 1px solid var(--border-color);
  transition: transform 0.2s ease;
}
.kpi-card:hover { transform: translateY(-3px); }
.kpi-icon { width: 48px; height: 48px; }
.kpi-value { font-size: 1.8rem; line-height: 1; }
.kpi-label { font-size: 0.75rem; }

.order-card { transition: box-shadow 0.2s ease; }
.order-card:hover { box-shadow: 0 4px 20px rgba(0,0,0,.08) !important; }
.order-code { font-size: 0.95rem; }

/* Badges de estado */
.badge-pending { background: #fff3cd; color: #856404; border: 1px solid #ffc107; }
.badge-prep { background: #cfe2ff; color: #084298; border: 1px solid #9ec5fe; }
.badge-ready { background: #d1e7dd; color: #0a3622; border: 1px solid #a3cfbb; }
.badge-cancelled { background: #f8d7da; color: #58151c; border: 1px solid #f1aeb5; }

/* Toast */
.waiter-toast {
  position: fixed; top: 1rem; right: 1rem; z-index: 9999;
  padding: 0.75rem 1.25rem; border-radius: 0.75rem;
  font-weight: 600; font-size: 0.9rem; box-shadow: 0 4px 20px rgba(0,0,0,.15);
}
.waiter-toast--ok { background: #d1e7dd; color: #0a3622; border: 1px solid #a3cfbb; }
.waiter-toast--err { background: #f8d7da; color: #58151c; border: 1px solid #f1aeb5; }

.bg-surface-custom { background: var(--bg-surface); }
.text-primary-custom { color: var(--text-primary); }
.text-secondary-custom { color: var(--text-muted); }
.border-color { border-color: var(--border-color) !important; }
.text-korange { color: var(--KOrange) !important; }
.btn-korange { background: var(--KOrange); border: none; color: white; }
.btn-korange:hover { background: #e06d0e; color: white; }
.btn-outline-korange { border-color: var(--KOrange); color: var(--KOrange); }
.btn-outline-korange:hover { background: var(--KOrange); color: white; }
.bg-korange-subtle { background: rgba(253,126,20,.12) !important; }
</style>
