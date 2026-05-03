<template>
  <div class="d-flex w-100">
    <!-- El Sidebar ya lo importará el layout o podemos importarlo directamente si es la convención -->
    <Sidebar role="admin" :userName="userName" />

    <main class="accounting-wrapper p-3 p-md-4 main-content">
      
      <!-- Header -->
      <header class="mb-4 d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
        <div>
          <h1 class="fw-bold mb-1 text-primary-custom d-flex align-items-center">
            <i class="bi bi-bank text-korange me-2"></i>
            Estado de Situación Financiera
          </h1>
          <p class="text-secondary-custom mb-0 small">
            Balance General de <strong class="text-korange">{{ restaurantName }}</strong>
          </p>
        </div>

        <!-- Filtros de Fecha y Reportes -->
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
            <i class="bi bi-printer"></i> Imprimir Reporte
          </button>
          <button class="btn btn-korange fw-semibold shadow-sm d-flex align-items-center gap-2" @click="fetchBalanceSheet">
            <i class="bi bi-arrow-clockwise"></i>
            Actualizar
          </button>
        </div>
      </header>

      <div class="row g-4 mb-4">
        <!-- KPI Resumen -->
        <div class="col-12 col-md-4">
          <div class="kpi-card shadow-sm border-color border rounded-4 p-3 d-flex align-items-center gap-3 bg-surface-custom">
            <div class="kpi-icon bg-info-subtle text-info">
              <i class="bi bi-cash-stack"></i>
            </div>
            <div>
              <p class="text-secondary-custom mb-0 small fw-bold">Total Activos</p>
              <h4 class="mb-0 fw-bold text-main">{{ formatCurrency(totalAssets) }}</h4>
            </div>
          </div>
        </div>
        <div class="col-12 col-md-4">
          <div class="kpi-card shadow-sm border-color border rounded-4 p-3 d-flex align-items-center gap-3 bg-surface-custom">
            <div class="kpi-icon bg-danger-subtle text-danger">
              <i class="bi bi-credit-card"></i>
            </div>
            <div>
              <p class="text-secondary-custom mb-0 small fw-bold">Total Pasivos</p>
              <h4 class="mb-0 fw-bold text-main">{{ formatCurrency(totalLiabilities) }}</h4>
            </div>
          </div>
        </div>
        <div class="col-12 col-md-4">
          <div class="kpi-card shadow-sm border-color border rounded-4 p-3 d-flex align-items-center gap-3 bg-surface-custom">
            <div class="kpi-icon bg-success-subtle text-success">
              <i class="bi bi-briefcase"></i>
            </div>
            <div>
              <p class="text-secondary-custom mb-0 small fw-bold">Patrimonio Neto</p>
              <h4 class="mb-0 fw-bold text-main">{{ formatCurrency(totalEquity) }}</h4>
            </div>
          </div>
        </div>
      </div>

      <!-- Tabla Estructurada del Balance -->
      <div class="table-card shadow-sm border border-color rounded-4 overflow-hidden bg-surface-custom">
        <div class="table-responsive">
          <table class="table table-custom mb-0">
            <thead class="bg-surface-custom border-bottom">
              <tr>
                <th scope="col" class="py-3 px-4 text-secondary-custom font-monospace small">CUENTA CONTABLE</th>
                <th scope="col" class="py-3 px-4 text-end text-secondary-custom font-monospace small">SALDO (USD)</th>
              </tr>
            </thead>
            <tbody>
              <!-- Activos -->
              <tr class="bg-light-orange">
                <td colspan="2" class="py-3 px-4 fw-bold text-korange d-flex align-items-center">
                  <i class="bi bi-plus-circle-fill me-2 bg-white rounded-circle"></i>
                  ACTIVOS
                </td>
              </tr>
              <CollapsibleAccountRow :accounts="assetsData" :depth="0" />
              
              <!-- Pasivos -->
              <tr class="bg-light-danger mt-3">
                <td colspan="2" class="py-3 px-4 fw-bold text-danger d-flex align-items-center border-top">
                  <i class="bi bi-dash-circle-fill me-2 bg-white rounded-circle"></i>
                  PASIVOS
                </td>
              </tr>
              <CollapsibleAccountRow :accounts="liabilitiesData" :depth="0" />
              
              <!-- Patrimonio -->
              <tr class="bg-light-success mt-3">
                <td colspan="2" class="py-3 px-4 fw-bold text-success d-flex align-items-center border-top">
                  <i class="bi bi-briefcase-fill me-2 bg-white rounded-circle"></i>
                  PATRIMONIO
                </td>
              </tr>
              <CollapsibleAccountRow :accounts="equityData" :depth="0" />
            </tbody>
          </table>
        </div>
      </div>

    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import Sidebar from '../../../components/Sidebar.vue'
import CollapsibleAccountRow from '../components/CollapsibleAccountRow.vue'
import { useAuth } from '../../../core/composables/useAuth'
import { fetchBalanceSheet as fetchBalanceSheetApi, type Account } from '../accounting.api'

const auth = useAuth()
// @ts-ignore
const restaurantName = computed(() => (auth.user.value as any)?.restaurantName || 'Komanda Restaurant')
const userName = computed(() => auth.user.value?.nombre || 'Contador')

const today = new Date().toISOString().split('T')[0]
const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0]
const filterDateFrom = ref(thirtyDaysAgo)
const filterDateTo = ref(today)
const loading = ref(false)

// --- DATA --- //
const assetsData = ref<Account[]>([])
const liabilitiesData = ref<Account[]>([])
const equityData = ref<Account[]>([])
const totals = ref({ assets: 0, liabilities: 0, equity: 0 })

const totalAssets = computed(() => totals.value.assets)
const totalLiabilities = computed(() => totals.value.liabilities)
const totalEquity = computed(() => totals.value.equity)

const formatCurrency = (val: number) => {
  return new Intl.NumberFormat('es-US', {
    style: 'currency',
    currency: 'USD',
  }).format(val)
}

const printReport = () => {
  window.print()
}

const fetchBalanceSheet = async () => {
  loading.value = true
  try {
    const data = await fetchBalanceSheetApi(filterDateFrom.value, filterDateTo.value)
    assetsData.value = data.assets
    liabilitiesData.value = data.liabilities
    equityData.value = data.equity
    totals.value = data.totals
  } catch (error) {
    console.error('Error fetching balance sheet:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchBalanceSheet()
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

/* KPIs */
.kpi-icon {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
}

/* Category Headers in table */
.bg-light-orange { background-color: rgba(253, 126, 20, 0.08); }
.bg-light-danger { background-color: rgba(220, 53, 69, 0.05); }
.bg-light-success { background-color: rgba(25, 135, 84, 0.08); }

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
