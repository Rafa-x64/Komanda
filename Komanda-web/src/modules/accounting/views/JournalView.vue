<template>
  <div class="d-flex w-100">
    <Sidebar role="admin" :userName="userName" />

    <main class="accounting-wrapper p-3 p-md-4 main-content">
      <!-- Header -->
      <header class="mb-4 d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
        <div>
          <h1 class="fw-bold mb-1 text-primary-custom d-flex align-items-center">
            <i class="bi bi-journal-text text-korange me-2"></i>
            Libro Diario
          </h1>
          <p class="text-secondary-custom mb-0 small">
            Asientos contables cronológicos
          </p>
        </div>

        <div class="d-flex align-items-center gap-2 flex-wrap">
          <div class="date-filter shadow-sm">
            <i class="bi bi-calendar3 text-muted ms-2"></i>
            <span class="ms-2 small fw-bold text-muted">Desde:</span>
            <input type="date" v-model="filterDateFrom" class="form-control border-0 bg-transparent text-primary-custom shadow-none" title="Seleccionar fecha inicial">
            <span class="mx-2 text-muted fw-bold">-</span>
            <span class="small fw-bold text-muted">Hasta:</span>
            <input type="date" v-model="filterDateTo" class="form-control border-0 bg-transparent text-primary-custom shadow-none" title="Seleccionar fecha final">
          </div>
          <button class="btn btn-outline-secondary fw-semibold shadow-sm d-flex align-items-center gap-2" @click="printReport">
            <i class="bi bi-printer"></i> Imprimir
          </button>
          <button class="btn btn-korange fw-semibold shadow-sm d-flex align-items-center gap-2" @click="fetchEntries" :disabled="loading">
            <i class="bi bi-arrow-clockwise" :class="{ 'spinner-border spinner-border-sm': loading }"></i>
            Actualizar
          </button>
        </div>
      </header>

      <!-- Tabla del Libro Diario -->
      <div id="journal-report" class="table-card shadow-sm border border-color rounded-4 overflow-hidden bg-surface-custom">
        <div class="table-responsive">
          <table class="table table-custom mb-0">
            <thead class="bg-surface-custom border-bottom">
              <tr>
                <th scope="col" class="py-3 px-4 text-secondary-custom font-monospace small">FECHA</th>
                <th scope="col" class="py-3 px-4 text-secondary-custom font-monospace small">DESCRIPCIÓN</th>
                <th scope="col" class="py-3 px-4 text-secondary-custom font-monospace small">ORIGEN</th>
                <th scope="col" class="py-3 px-4 text-secondary-custom font-monospace small text-end">DEBE</th>
                <th scope="col" class="py-3 px-4 text-secondary-custom font-monospace small text-end">HABER</th>
              </tr>
            </thead>
            <tbody>
              <template v-for="asiento in entries" :key="asiento.asiento_id">
                <!-- Cabecera del asiento -->
                <tr class="bg-light-secondary cursor-pointer" @click="toggleAsiento(asiento.asiento_id)">
                  <td class="py-3 px-4 fw-bold">
                    <i class="bi me-2" :class="expandedAsientos.includes(asiento.asiento_id) ? 'bi-chevron-down' : 'bi-chevron-right'"></i>
                    {{ new Date(asiento.fecha).toLocaleDateString() }}
                  </td>
                  <td class="py-3 px-4 fw-bold">{{ asiento.descripcion }}</td>
                  <td class="py-3 px-4">
                    <span class="badge bg-secondary cursor-pointer" v-if="asiento.origen_tipo" @click.stop="verOrigen(asiento)">
                      {{ asiento.origen_tipo }} #{{ asiento.origen_id }}
                    </span>
                  </td>
                  <td class="py-3 px-4 text-end fw-bold text-success">{{ formatCurrency(asiento.total_debe) }}</td>
                  <td class="py-3 px-4 text-end fw-bold text-danger">{{ formatCurrency(asiento.total_haber) }}</td>
                </tr>
                <!-- Líneas del asiento (expandibles) -->
                <template v-if="expandedAsientos.includes(asiento.asiento_id)">
                  <tr v-for="linea in asiento.lineas" :key="linea.cuenta_id + linea.tipo_movimiento" class="bg-surface-custom border-bottom-0">
                    <td class="py-2 px-4"></td>
                    <td class="py-2 px-4 ps-5">
                      <span class="text-muted small me-2">{{ linea.cuenta_codigo }}</span>
                      {{ linea.cuenta_nombre }}
                    </td>
                    <td class="py-2 px-4"></td>
                    <td class="py-2 px-4 text-end text-success">{{ linea.tipo_movimiento === 'debe' ? formatCurrency(linea.monto) : '' }}</td>
                    <td class="py-2 px-4 text-end text-danger">{{ linea.tipo_movimiento === 'haber' ? formatCurrency(linea.monto) : '' }}</td>
                  </tr>
                </template>
              </template>
              <tr v-if="entries.length === 0">
                <td colspan="5" class="text-center py-5 text-muted">No hay asientos contables en este período</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </main>

    <!-- Modal para Drill-Down (simulado) -->
    <div class="modal fade" id="drillDownModal" tabindex="-1" aria-hidden="true" ref="modalRef">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow rounded-4 bg-surface-custom">
          <div class="modal-header border-bottom-0 pb-0">
            <h5 class="modal-title fw-bold text-primary-custom d-flex align-items-center">
              <i class="bi bi-search text-korange me-2"></i>
              Detalle de Origen
            </h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <p v-if="selectedOrigen">
              Tipo: <strong>{{ selectedOrigen.origen_tipo }}</strong><br>
              ID: <strong>{{ selectedOrigen.origen_id }}</strong><br><br>
              <em>En una implementación completa, aquí se mostraría el ticket o factura correspondiente a esta operación.</em>
            </p>
          </div>
          <div class="modal-footer border-top-0 pt-0">
            <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cerrar</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
// @ts-ignore
import * as bootstrap from 'bootstrap'
import html2pdf from 'html2pdf.js'
import Sidebar from '../../../components/Sidebar.vue'
import { useAuth } from '../../../core/composables/useAuth'
import { fetchJournalEntries } from '../accounting.api'

const auth = useAuth()
const userName = computed(() => auth.user.value?.nombre || 'Contador')

const today = new Date().toISOString().split('T')[0]
const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0]
const filterDateFrom = ref(thirtyDaysAgo)
const filterDateTo = ref(today)
const loading = ref(false)

const entries = ref<any[]>([])
const expandedAsientos = ref<number[]>([])

const modalRef = ref<HTMLElement | null>(null)
let modalInstance: any = null
const selectedOrigen = ref<any>(null)

const formatCurrency = (val: number | string) => {
  return new Intl.NumberFormat('es-US', {
    style: 'currency',
    currency: 'USD',
  }).format(Number(val))
}

const toggleAsiento = (id: number) => {
  if (expandedAsientos.value.includes(id)) {
    expandedAsientos.value = expandedAsientos.value.filter(e => e !== id)
  } else {
    expandedAsientos.value.push(id)
  }
}

const verOrigen = (asiento: any) => {
  selectedOrigen.value = asiento
  if (modalInstance) {
    modalInstance.show()
  }
}

const fetchEntries = async () => {
  loading.value = true
  try {
    const data = await fetchJournalEntries(filterDateFrom.value, filterDateTo.value)
    entries.value = data
  } catch (error) {
    console.error('Error fetching journal entries:', error)
  } finally {
    loading.value = false
  }
}

const printReport = () => {
  const element = document.getElementById('journal-report')
  const opt = {
    margin:       0.5,
    filename:     `libro_diario_${filterDateFrom.value}_${filterDateTo.value}.pdf`,
    image:        { type: 'jpeg', quality: 0.98 },
    html2canvas:  { scale: 2 },
    jsPDF:        { unit: 'in', format: 'letter', orientation: 'landscape' }
  }
  html2pdf().set(opt).from(element).save()
}

onMounted(() => {
  if (modalRef.value) {
    modalInstance = new bootstrap.Modal(modalRef.value)
  }
  fetchEntries()
})
</script>

<style scoped>
.accounting-wrapper {
  background-color: var(--bg-body);
  min-height: 100vh;
  width: 100%;
}

@media (min-width: 768px) {
  .main-content {
    margin-left: 260px;
    width: calc(100% - 260px);
  }
}

.text-primary-custom { color: var(--text-main); }
.text-secondary-custom { color: var(--text-muted); }
.bg-surface-custom { background-color: var(--bg-surface) !important; }
.border-color { border-color: var(--border-color) !important; }
.bg-light-secondary { background-color: rgba(108, 117, 125, 0.05); }

/* Date Filter Custom */
.date-filter {
  display: flex;
  align-items: center;
  background: var(--bg-surface);
  border: 1px solid var(--border-color);
  border-radius: 50rem; /* pill */
  padding: 0.25rem 0.5rem;
  min-width: 200px;
}
.date-filter input {
  color: var(--text-main);
  outline: none;
}
.date-filter input::-webkit-calendar-picker-indicator {
  filter: invert(0.5);
  cursor: pointer;
}

.table-custom {
  color: var(--text-main);
}
.table-custom th {
  background-color: transparent !important;
  border-bottom-width: 2px;
}
.table-custom td {
  border-color: var(--border-color);
  vertical-align: middle;
}

.cursor-pointer {
  cursor: pointer;
}

/* Botones KOrange */
.btn-korange {
  background-color: var(--KOrange);
  color: white;
  border: none;
  border-radius: 50rem;
  padding: 0.5rem 1.25rem;
  transition: all 0.2s;
}
.btn-korange:hover {
  background-color: var(--KOrange-hover);
  transform: translateY(-1px);
}
</style>
