<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { RefreshCw, CreditCard, CheckCircle2, Clock, TrendingUp } from 'lucide-vue-next'
import Sidebar from '../../components/Sidebar.vue'
import { useAuth } from '../../core/composables/useAuth'
import { fetchReadyOrders, type ReadyOrder } from '../pos/pos.api'

const auth   = useAuth()
const router = useRouter()

const userName = computed(() => auth.user.value?.nombre || 'Cajero')

// ─── Estado ───────────────────────────────────────────────
const orders  = ref<ReadyOrder[]>([])
const loading = ref(true)
const toast   = ref<{ type: 'success' | 'error'; message: string } | null>(null)
let pollInterval: ReturnType<typeof setInterval> | null = null

// ─── KPIs derivados de datos reales ───────────────────────
const listasParaCobrar = computed(() => orders.value.filter(o => o.estado === 'listo').length)
const enCocina         = computed(() => orders.value.filter(o => o.estado === 'preparando').length)
const pendientes       = computed(() => orders.value.filter(o => o.estado === 'pendiente').length)
const totalEnCola      = computed(() =>
  orders.value.reduce((s, o) => s + Number(o.total), 0).toFixed(2)
)

// ─── Helpers ──────────────────────────────────────────────
const showToast = (type: 'success' | 'error', msg: string) => {
  toast.value = { type, message: msg }
  setTimeout(() => { toast.value = null }, 4000)
}

const formatTime = (d: string) =>
  new Date(d).toLocaleTimeString('es-VE', { hour: '2-digit', minute: '2-digit' })

const mesaLabel = (o: ReadyOrder) =>
  o.mesa_nombre || (o.mesa_numero ? `Mesa ${o.mesa_numero}` : '🛵 Para llevar')

const badgeCls = (estado: string) => ({
  listo:      'bg-success text-white',
  preparando: 'bg-primary text-white',
  pendiente:  'bg-warning text-dark',
}[estado] ?? 'bg-secondary text-white')

const badgeLabel = (estado: string) => ({
  listo:      '✅ Listo',
  preparando: '👨‍🍳 En Cocina',
  pendiente:  '⏳ Pendiente',
}[estado] ?? estado)

const tiempoEspera = (fechaHora: string) => {
  const mins = Math.floor((Date.now() - new Date(fechaHora).getTime()) / 60000)
  return mins < 60 ? `${mins} min` : `${Math.floor(mins / 60)}h ${mins % 60}m`
}

// ─── Carga de datos ───────────────────────────────────────
const load = async () => {
  try {
    orders.value = await fetchReadyOrders()
  } catch {
    showToast('error', 'Error cargando pedidos')
  } finally {
    loading.value = false
  }
}

onMounted(() => { load(); pollInterval = setInterval(load, 20000) })
onUnmounted(() => { if (pollInterval) clearInterval(pollInterval) })
</script>

<template>
<div class="d-flex w-100">
  <Sidebar role="cajero" :userName="userName" />

  <main class="caja-main main-content">

    <!-- Toast -->
    <div v-if="toast" class="caja-toast" :class="toast.type === 'success' ? 'caja-toast--ok' : 'caja-toast--err'">
      {{ toast.message }}
    </div>

    <div class="container-fluid py-4 px-3 px-md-4 caja-content">

      <!-- Header -->
      <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
          <span class="text-korange fw-bold small text-uppercase">Turno Activo</span>
          <h2 class="fw-bold mt-1 mb-1 text-primary-custom">
            Control de <span class="text-korange">Caja y Finanzas</span>
          </h2>
          <p class="text-secondary-custom small mb-0">Responsable: <strong>{{ userName }}</strong></p>
        </div>
        <div class="d-flex gap-2 flex-wrap">
          <button @click="load" class="btn btn-outline-secondary btn-sm rounded-pill d-flex align-items-center gap-2">
            <RefreshCw :size="15" /> Actualizar
          </button>
          <button @click="router.push('/pos')" class="btn btn-korange rounded-pill px-4 fw-bold d-flex align-items-center gap-2">
            <CreditCard :size="16" /> Ir a Cobrar
          </button>
        </div>
      </div>

      <!-- KPI Cards -->
      <div class="row g-3 mb-4">
        <div class="col-6 col-xl-3">
          <div class="kpi-card rounded-4 p-3 h-100">
            <div class="kpi-icon rounded-3 bg-success-subtle d-flex align-items-center justify-content-center mb-2">
              <CheckCircle2 :size="20" class="text-success" />
            </div>
            <div class="fw-black text-success" style="font-size:1.9rem;line-height:1;">{{ listasParaCobrar }}</div>
            <div class="text-secondary-custom" style="font-size:.75rem;">Listos para cobrar</div>
          </div>
        </div>
        <div class="col-6 col-xl-3">
          <div class="kpi-card rounded-4 p-3 h-100">
            <div class="kpi-icon rounded-3 bg-primary-subtle d-flex align-items-center justify-content-center mb-2">
              <Clock :size="20" class="text-primary" />
            </div>
            <div class="fw-black text-primary" style="font-size:1.9rem;line-height:1;">{{ enCocina }}</div>
            <div class="text-secondary-custom" style="font-size:.75rem;">En preparación</div>
          </div>
        </div>
        <div class="col-6 col-xl-3">
          <div class="kpi-card rounded-4 p-3 h-100">
            <div class="kpi-icon rounded-3 bg-warning-subtle d-flex align-items-center justify-content-center mb-2">
              <Clock :size="20" class="text-warning" />
            </div>
            <div class="fw-black text-warning" style="font-size:1.9rem;line-height:1;">{{ pendientes }}</div>
            <div class="text-secondary-custom" style="font-size:.75rem;">Pendientes de cocina</div>
          </div>
        </div>
        <div class="col-6 col-xl-3">
          <div class="kpi-card rounded-4 p-3 h-100">
            <div class="kpi-icon rounded-3 bg-korange-subtle d-flex align-items-center justify-content-center mb-2">
              <TrendingUp :size="20" class="text-korange" />
            </div>
            <div class="fw-black text-korange" style="font-size:1.9rem;line-height:1;">Bs. {{ totalEnCola }}</div>
            <div class="text-secondary-custom" style="font-size:.75rem;">Total en cola</div>
          </div>
        </div>
      </div>

      <!-- Tabla de cuentas por cobrar -->
      <div class="card rounded-4 shadow-sm border border-color bg-surface-custom overflow-hidden">
        <div class="card-header border-bottom border-color py-3 px-4 d-flex justify-content-between align-items-center">
          <h5 class="fw-bold mb-0 text-primary-custom">
            <CreditCard :size="18" class="me-2 text-korange" />
            Cuentas por Cobrar ({{ orders.length }})
          </h5>
          <span class="badge bg-korange-subtle text-korange rounded-pill">
            Actualiza cada 20s
          </span>
        </div>

        <!-- Loading -->
        <div v-if="loading" class="text-center py-5">
          <div class="spinner-border text-korange"></div>
        </div>

        <!-- Empty -->
        <div v-else-if="!orders.length" class="text-center py-5">
          <CheckCircle2 :size="48" class="text-success opacity-50 mb-3" />
          <p class="fw-bold text-primary-custom mb-1">¡Todo cobrado!</p>
          <p class="text-secondary-custom small">No hay pedidos con cuentas pendientes.</p>
        </div>

        <!-- Tabla responsive -->
        <div v-else class="table-responsive">
          <table class="table table-hover align-middle mb-0">
            <thead>
              <tr class="text-secondary-custom" style="font-size:.78rem;text-transform:uppercase;">
                <th class="ps-4 py-3 border-0">Mesa / Cliente</th>
                <th class="py-3 border-0">Estado</th>
                <th class="py-3 border-0">Items</th>
                <th class="py-3 border-0">Tiempo</th>
                <th class="py-3 border-0 fw-bold text-primary-custom">Total</th>
                <th class="text-end pe-4 py-3 border-0">Acción</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="order in orders" :key="order.id"
                  :class="{ 'table-success-subtle': order.estado === 'listo' }"
                  style="border-bottom:1px solid var(--border-color);">
                <td class="ps-4">
                  <div class="fw-bold text-primary-custom">{{ mesaLabel(order) }}</div>
                  <div v-if="order.cliente" class="text-secondary-custom small">{{ order.cliente }}</div>
                  <div class="text-secondary-custom" style="font-size:.72rem;">{{ order.codigo }}</div>
                </td>
                <td>
                  <span class="badge rounded-pill fw-semibold" :class="badgeCls(order.estado)">
                    {{ badgeLabel(order.estado) }}
                  </span>
                </td>
                <td class="text-secondary-custom small">
                  {{ (order.items || []).length }} artículo(s)
                </td>
                <td>
                  <span class="text-secondary-custom small">
                    <Clock :size="12" class="me-1" />{{ tiempoEspera(order.fecha_hora) }}
                  </span>
                </td>
                <td class="fw-black text-korange fs-6">
                  Bs. {{ Number(order.total).toFixed(2) }}
                </td>
                <td class="text-end pe-4">
                  <button
                    @click="router.push('/pos')"
                    class="btn btn-korange btn-sm rounded-pill px-3 fw-bold"
                  >
                    Cobrar
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

    </div>
  </main>
</div>
</template>

<style scoped>
.caja-main {
  background-color: var(--bg-body);
  min-height: 100vh;
  width: 100%;
}
@media (min-width: 768px) {
  .main-content { margin-left: 260px; width: calc(100% - 260px); }
}
@media (max-width: 767.98px) {
  .caja-content { padding-top: 4.5rem !important; }
}

.kpi-card {
  background: var(--bg-surface);
  border: 1px solid var(--border-color);
  transition: transform .2s ease;
}
.kpi-card:hover { transform: translateY(-3px); }
.kpi-icon { width: 40px; height: 40px; }

.bg-surface-custom { background: var(--bg-surface); }
.text-primary-custom { color: var(--text-primary); }
.text-secondary-custom { color: var(--text-muted); }
.border-color { border-color: var(--border-color) !important; }
.text-korange { color: var(--KOrange) !important; }
.btn-korange { background: var(--KOrange); border: none; color: white; }
.btn-korange:hover { background: #e06d0e; color: white; }
.bg-korange-subtle { background: rgba(253,126,20,.12) !important; }

.table-success-subtle { background: rgba(25,135,84,.04); }

/* Toast */
.caja-toast {
  position: fixed; top: 1rem; right: 1rem; z-index: 9999;
  padding: .75rem 1.25rem; border-radius: .75rem;
  font-weight: 600; font-size: .9rem;
  box-shadow: 0 4px 20px rgba(0,0,0,.15);
  animation: slideIn .3s ease;
}
.caja-toast--ok  { background: #d1e7dd; color: #0a3622; border: 1px solid #a3cfbb; }
.caja-toast--err { background: #f8d7da; color: #58151c; border: 1px solid #f1aeb5; }
@keyframes slideIn { from { transform: translateX(60px); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
</style>