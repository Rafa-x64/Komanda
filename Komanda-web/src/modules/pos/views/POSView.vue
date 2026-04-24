<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { RefreshCw, CreditCard, CheckCircle2, Clock, UtensilsCrossed, AlertCircle } from 'lucide-vue-next'
import Sidebar from '../../../components/Sidebar.vue'
import { useAuth } from '../../../core/composables/useAuth'
import {
  fetchReadyOrders, fetchMetodosPago, checkoutOrder,
  type ReadyOrder, type Pago
} from '../pos.api'

const auth = useAuth()

// ─── Estado ───────────────────────────────────────────────
const orders     = ref<ReadyOrder[]>([])
const metodos    = ref<{ id: number; nombre: string }[]>([])
const loading    = ref(true)
const selected   = ref<ReadyOrder | null>(null)
const processing = ref(false)
const toast      = ref<{ type: 'success' | 'error'; message: string } | null>(null)
let pollInterval: ReturnType<typeof setInterval> | null = null

// Pagos del modal
const pagos = ref<Pago[]>([])

// ─── Helpers ──────────────────────────────────────────────
const showToast = (type: 'success' | 'error', message: string) => {
  toast.value = { type, message }
  setTimeout(() => { toast.value = null }, 4500)
}

const formatTime = (d: string) =>
  new Date(d).toLocaleTimeString('es-VE', { hour: '2-digit', minute: '2-digit' })

const mesaLabel = (o: ReadyOrder) =>
  o.mesa_nombre || (o.mesa_numero ? `Mesa ${o.mesa_numero}` : '🛵 Para llevar')

const estadoBadge = (estado: string) => {
  const map: Record<string, { cls: string; label: string }> = {
    listo:      { cls: 'bg-success text-white',   label: '✅ Listo' },
    preparando: { cls: 'bg-primary text-white',   label: '👨‍🍳 En Cocina' },
    pendiente:  { cls: 'bg-warning text-dark',    label: '⏳ Pendiente' },
    enviado:    { cls: 'bg-info text-dark',       label: '📡 Enviado' },
  }
  return map[estado] ?? { cls: 'bg-secondary text-white', label: estado }
}

// ─── KPIs ─────────────────────────────────────────────────
const kpis = computed(() => [
  { label: '¡Listos!',    value: orders.value.filter(o => o.estado === 'listo').length,      cls: 'text-success', bg: 'bg-success-subtle' },
  { label: 'En Cocina',  value: orders.value.filter(o => o.estado === 'preparando').length,  cls: 'text-primary', bg: 'bg-primary-subtle' },
  { label: 'Pendientes', value: orders.value.filter(o => o.estado === 'pendiente').length,   cls: 'text-warning', bg: 'bg-warning-subtle' },
  { label: 'Total Cola', value: orders.value.length,                                         cls: 'text-korange', bg: 'bg-korange-subtle' },
])

// ─── Carga de datos ───────────────────────────────────────
const load = async () => {
  try {
    const [ords, mets] = await Promise.all([fetchReadyOrders(), fetchMetodosPago()])
    orders.value  = ords
    metodos.value = mets
  } catch {
    showToast('error', 'Error cargando datos')
  } finally {
    loading.value = false
  }
}

onMounted(() => { load(); pollInterval = setInterval(load, 15000) })
onUnmounted(() => { if (pollInterval) clearInterval(pollInterval) })

// ─── Modal de cobro ───────────────────────────────────────
const openCheckout = (order: ReadyOrder) => {
  selected.value = order
  // Prellenar con el total en el primer método
  const primero = metodos.value[0]
  pagos.value = primero
    ? [{ metodo_pago_id: primero.id, monto: Number(order.total), referencia: '' }]
    : []
}

const closeModal = () => { selected.value = null; pagos.value = [] }

const addPago = () => {
  const primero = metodos.value[0]
  if (primero) pagos.value.push({ metodo_pago_id: primero.id, monto: 0, referencia: '' })
}
const removePago = (i: number) => pagos.value.splice(i, 1)

const totalPagado  = computed(() => pagos.value.reduce((s, p) => s + Number(p.monto), 0))
const totalOrden   = computed(() => selected.value ? Number(selected.value.total) : 0)
const vuelto       = computed(() => Math.max(0, totalPagado.value - totalOrden.value))
const faltante     = computed(() => Math.max(0, totalOrden.value - totalPagado.value))
const canCheckout  = computed(() => pagos.value.length > 0 && faltante.value === 0)

const onMetodoChange = (idx: number, id: number) => {
  if (pagos.value[idx]) pagos.value[idx].metodo_pago_id = Number(id)
}

const submitCheckout = async () => {
  if (!selected.value || !canCheckout.value) return
  processing.value = true
  try {
    const result = await checkoutOrder(selected.value.id, pagos.value)
    showToast('success', `✅ Cobrado! Vuelto: Bs. ${result.vuelto.toFixed(2)}`)
    closeModal()
    await load()
  } catch (e: any) {
    showToast('error', e.message || 'Error al procesar el cobro')
  } finally {
    processing.value = false
  }
}
</script>

<template>
<div class="d-flex w-100">
  <Sidebar :role="auth.user.value?.role || 'cajero'" :userName="auth.user.value?.nombre" />

  <main class="pos-main main-content">

    <!-- Toast -->
    <div v-if="toast" class="pos-toast" :class="toast.type === 'success' ? 'pos-toast--ok' : 'pos-toast--err'">
      {{ toast.message }}
    </div>

    <div class="container-fluid py-4 px-3 px-md-4">

      <!-- Header -->
      <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
          <span class="text-korange fw-bold small text-uppercase tracking-wide">Caja Registradora</span>
          <h2 class="fw-bold mt-1 mb-0 text-primary-custom">Cola de Cobros</h2>
          <p class="text-secondary-custom small mb-0">Pedidos con cuenta abierta, ordenados por prioridad</p>
        </div>
        <button @click="load" class="btn btn-outline-secondary btn-sm rounded-pill d-flex align-items-center gap-2">
          <RefreshCw :size="15" /> Actualizar
        </button>
      </div>

      <!-- KPIs -->
      <div class="row g-3 mb-4">
        <div v-for="k in kpis" :key="k.label" class="col-6 col-xl-3">
          <div class="kpi-card rounded-4 p-3 h-100">
            <div :class="['kpi-icon rounded-3 mb-2 d-flex align-items-center justify-content-center', k.bg]">
              <CreditCard :size="20" :class="k.cls" />
            </div>
            <div :class="['kpi-value fw-black', k.cls]">{{ k.value }}</div>
            <div class="kpi-label text-secondary-custom">{{ k.label }}</div>
          </div>
        </div>
      </div>

      <!-- Spinner -->
      <div v-if="loading" class="text-center py-5">
        <div class="spinner-border text-korange"></div>
        <p class="mt-3 text-secondary-custom small">Cargando cola de cobros...</p>
      </div>

      <!-- Empty state -->
      <div v-else-if="!orders.length" class="text-center py-5 rounded-4 bg-surface-custom border border-color">
        <CheckCircle2 :size="52" class="text-success opacity-50 mb-3" />
        <h5 class="fw-bold text-primary-custom">¡Todo cobrado!</h5>
        <p class="text-secondary-custom small">No hay pedidos con cuentas pendientes de pago.</p>
      </div>

      <!-- Cola de pedidos -->
      <div v-else class="row g-3">
        <div v-for="order in orders" :key="order.id" class="col-12 col-md-6 col-xl-4">
          <div
            class="order-card rounded-4 h-100 border border-color bg-surface-custom"
            :class="{ 'order-card--ready': order.estado === 'listo' }"
          >
            <!-- Header -->
            <div class="p-3 pb-2 d-flex justify-content-between align-items-start border-bottom border-color">
              <div>
                <span class="fw-bold text-primary-custom d-block">{{ order.codigo }}</span>
                <span class="text-secondary-custom small">
                  <Clock :size="12" class="me-1" />{{ formatTime(order.fecha_hora) }}
                </span>
              </div>
              <span class="badge rounded-pill fw-semibold" :class="estadoBadge(order.estado).cls">
                {{ estadoBadge(order.estado).label }}
              </span>
            </div>

            <!-- Mesa / Cliente -->
            <div class="px-3 pt-2 pb-1 d-flex align-items-center gap-2">
              <span class="badge bg-secondary-subtle text-secondary border border-secondary border-opacity-25 rounded-pill">
                {{ mesaLabel(order) }}
              </span>
              <span v-if="order.cliente" class="text-secondary-custom small">{{ order.cliente }}</span>
            </div>

            <!-- Items resumidos -->
            <ul class="list-unstyled px-3 mb-0 small">
              <li v-for="item in (order.items || []).slice(0, 4)" :key="item.id"
                  class="d-flex justify-content-between text-secondary-custom py-1 border-bottom border-color"
                  style="border-style: dashed !important;">
                <span>{{ item.cantidad }}× {{ item.nombre }}</span>
                <span>Bs. {{ Number(item.subtotal).toFixed(2) }}</span>
              </li>
              <li v-if="(order.items || []).length > 4" class="text-korange small pt-1">
                +{{ (order.items || []).length - 4 }} más
              </li>
            </ul>

            <!-- Footer con total y botón cobrar -->
            <div class="p-3 pt-2 d-flex justify-content-between align-items-center">
              <div>
                <div class="text-secondary-custom" style="font-size:0.7rem;">TOTAL</div>
                <div class="fw-black text-korange fs-5">Bs. {{ Number(order.total).toFixed(2) }}</div>
              </div>
              <button
                @click="openCheckout(order)"
                class="btn btn-korange rounded-pill px-3 fw-bold d-flex align-items-center gap-2"
              >
                <CreditCard :size="16" /> Cobrar
              </button>
            </div>
          </div>
        </div>
      </div>

    </div>
  </main>

  <!-- ══════════ MODAL DE COBRO ══════════ -->
  <template v-if="selected">
    <div class="modal-backdrop fade show" style="z-index:1050;"></div>
    <div class="modal fade show d-block" tabindex="-1" style="z-index:1055;" @click.self="closeModal">
      <div class="modal-dialog modal-dialog-centered" style="max-width:520px;">
        <div class="modal-content bg-surface-custom border-color shadow-lg">

          <!-- Header -->
          <div class="modal-header border-bottom border-color">
            <div>
              <h5 class="modal-title fw-bold text-primary-custom mb-0">
                <CreditCard :size="20" class="me-2 text-korange" />Cobrar {{ selected.codigo }}
              </h5>
              <small class="text-secondary-custom">{{ mesaLabel(selected) }}</small>
            </div>
            <button class="btn-close" @click="closeModal"></button>
          </div>

          <!-- Resumen del pedido -->
          <div class="modal-body px-4 py-3">
            <h6 class="fw-bold text-secondary-custom text-uppercase small mb-2">Resumen del Pedido</h6>
            <ul class="list-unstyled mb-3">
              <li v-for="item in selected.items" :key="item.id"
                  class="d-flex justify-content-between py-1 border-bottom border-color text-primary-custom small"
                  style="border-style:dashed !important;">
                <span>{{ item.cantidad }}× {{ item.nombre }}</span>
                <span class="fw-semibold">Bs. {{ Number(item.subtotal).toFixed(2) }}</span>
              </li>
            </ul>
            <div class="d-flex justify-content-between text-secondary-custom small mb-1">
              <span>Subtotal</span><span>Bs. {{ Number(selected.subtotal).toFixed(2) }}</span>
            </div>
            <div class="d-flex justify-content-between text-secondary-custom small mb-2">
              <span>IVA</span><span>Bs. {{ Number(selected.impuestos).toFixed(2) }}</span>
            </div>
            <div class="d-flex justify-content-between fw-black fs-5 text-primary-custom border-top border-color pt-2 mb-3">
              <span>Total</span><span class="text-korange">Bs. {{ Number(selected.total).toFixed(2) }}</span>
            </div>

            <!-- Métodos de pago -->
            <div class="d-flex justify-content-between align-items-center mb-2">
              <h6 class="fw-bold text-secondary-custom text-uppercase small mb-0">Métodos de Pago</h6>
              <button @click="addPago" class="btn btn-sm btn-outline-secondary rounded-pill px-2 py-0" style="font-size:0.75rem;">
                + Agregar
              </button>
            </div>

            <div v-for="(pago, idx) in pagos" :key="idx" class="mb-2 p-2 rounded-3 border border-color">
              <div class="d-flex gap-2 align-items-center">
                <select
                  class="form-select form-select-sm bg-transparent border-color text-primary-custom"
                  :value="pago.metodo_pago_id"
                  @change="onMetodoChange(idx, Number(($event.target as HTMLSelectElement).value))"
                >
                  <option v-for="m in metodos" :key="m.id" :value="m.id">{{ m.nombre }}</option>
                </select>
                <input
                  v-model.number="pago.monto"
                  type="number" min="0" step="0.01"
                  class="form-control form-control-sm bg-transparent border-color text-primary-custom"
                  placeholder="Monto"
                  style="max-width:110px;"
                />
                <button v-if="pagos.length > 1" @click="removePago(idx)"
                  class="btn btn-sm btn-outline-danger rounded-circle p-1">✕</button>
              </div>
              <input
                v-model="pago.referencia"
                type="text"
                class="form-control form-control-sm bg-transparent border-color text-secondary-custom mt-1"
                placeholder="Referencia / N° operación (opcional)"
              />
            </div>

            <!-- Resumen de pagos -->
            <div class="rounded-3 p-3 mt-2" :class="faltante > 0 ? 'bg-danger-subtle' : 'bg-success-subtle'">
              <div class="d-flex justify-content-between small mb-1">
                <span class="text-secondary-custom">Total pagado</span>
                <span class="fw-bold">Bs. {{ totalPagado.toFixed(2) }}</span>
              </div>
              <div v-if="faltante > 0" class="d-flex justify-content-between small text-danger fw-bold">
                <span>Faltante</span><span>Bs. {{ faltante.toFixed(2) }}</span>
              </div>
              <div v-if="vuelto > 0" class="d-flex justify-content-between small text-success fw-bold">
                <span>Vuelto</span><span>Bs. {{ vuelto.toFixed(2) }}</span>
              </div>
            </div>

            <!-- Alerta pago insuficiente -->
            <div v-if="faltante > 0" class="d-flex align-items-center gap-2 mt-2 text-danger small">
              <AlertCircle :size="15" /> El monto ingresado es menor al total del pedido.
            </div>
          </div>

          <!-- Footer -->
          <div class="modal-footer border-top border-color justify-content-between">
            <button @click="closeModal" class="btn btn-outline-secondary rounded-pill px-4">Cancelar</button>
            <button
              @click="submitCheckout"
              :disabled="!canCheckout || processing"
              class="btn btn-korange rounded-pill px-4 fw-bold d-flex align-items-center gap-2"
            >
              <span v-if="processing" class="spinner-border spinner-border-sm"></span>
              <CheckCircle2 v-else :size="18" />
              {{ processing ? 'Procesando...' : 'Confirmar Cobro' }}
            </button>
          </div>

        </div>
      </div>
    </div>
  </template>

</div>
</template>

<style scoped>
.pos-main {
  background-color: var(--bg-body);
  min-height: 100vh;
  width: 100%;
}
@media (min-width: 768px) {
  .main-content { margin-left: 260px; width: calc(100% - 260px); }
}

/* KPIs */
.kpi-card {
  background: var(--bg-surface);
  border: 1px solid var(--border-color);
  transition: transform 0.2s ease;
}
.kpi-card:hover { transform: translateY(-3px); }
.kpi-icon { width: 40px; height: 40px; }
.kpi-value { font-size: 1.9rem; line-height: 1; }
.kpi-label { font-size: 0.75rem; }

/* Tarjeta de pedido */
.order-card {
  transition: box-shadow 0.2s ease;
}
.order-card:hover { box-shadow: 0 4px 24px rgba(0,0,0,.1) !important; }
.order-card--ready {
  border-color: #198754 !important;
  box-shadow: 0 0 0 2px rgba(25,135,84,.2);
}

/* Toast */
.pos-toast {
  position: fixed; top: 1rem; right: 1rem; z-index: 9999;
  padding: .75rem 1.25rem; border-radius: .75rem;
  font-weight: 600; font-size: .9rem; box-shadow: 0 4px 20px rgba(0,0,0,.15);
  animation: slideIn .3s ease;
}
.pos-toast--ok  { background: #d1e7dd; color: #0a3622; border: 1px solid #a3cfbb; }
.pos-toast--err { background: #f8d7da; color: #58151c; border: 1px solid #f1aeb5; }
@keyframes slideIn { from { transform: translateX(60px); opacity: 0; } to { transform: translateX(0); opacity: 1; } }

/* Tokens */
.text-primary-custom   { color: var(--text-primary); }
.text-secondary-custom { color: var(--text-muted); }
.bg-surface-custom     { background: var(--bg-surface); }
.border-color          { border-color: var(--border-color) !important; }
.text-korange          { color: var(--KOrange) !important; }
.btn-korange           { background: var(--KOrange); border: none; color: white; }
.btn-korange:hover     { background: #e06d0e; color: white; }
.btn-korange:disabled  { background: #f0a060; cursor: not-allowed; }
.bg-korange-subtle     { background: rgba(253,126,20,.12) !important; }
</style>
