<template>
  <div class="d-flex w-100">
    <Sidebar role="admin" :userName="userName" />

    <main class="accounting-wrapper p-3 p-md-4 main-content">
      <!-- Header -->
      <header class="mb-4 d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
        <div>
          <h1 class="fw-bold mb-1 text-primary-custom d-flex align-items-center">
            <i class="bi bi-graph-up-arrow text-korange me-2"></i>
            Estado de Resultados
          </h1>
          <p class="text-secondary-custom mb-0 small">
            Ganancias y Pérdidas de <strong class="text-korange">{{ restaurantName }}</strong>
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
          <button class="btn btn-outline-secondary fw-semibold shadow-sm d-flex align-items-center gap-2" @click="printReport" :disabled="loading">
            <i class="bi bi-file-earmark-pdf"></i> PDF
          </button>
          <button class="btn btn-korange fw-semibold shadow-sm d-flex align-items-center gap-2" @click="fetchData" :disabled="loading">
            <i class="bi bi-arrow-clockwise" :class="{ 'spinner-border spinner-border-sm': loading }"></i>
            Actualizar
          </button>
        </div>
      </header>

      <!-- Documento Formal -->
      <div id="income-statement-report" class="bg-white p-5 rounded-4 shadow-sm text-dark formal-doc mx-auto" style="max-width: 800px;">
        <div class="text-center mb-5 border-bottom pb-4">
          <h2 class="fw-bold mb-1">{{ restaurantName }}</h2>
          <h4 class="text-uppercase mb-2">Estado de Resultados</h4>
          <p class="mb-0 text-muted">Período: {{ formattedDateFrom }} - {{ formattedDateTo }}</p>
          <p class="mb-0 text-muted">Expresado en Dólares Estadounidenses (USD)</p>
        </div>

        <div class="report-content px-md-4">
          <table class="table table-borderless table-sm formal-table">
            <tbody>
              <!-- Ingresos -->
              <tr>
                <td colspan="2"><h5 class="fw-bold text-uppercase border-bottom pb-2 mt-2 mb-3">Ingresos Operativos</h5></td>
              </tr>
              <tr v-for="item in ingresos" :key="item.cuenta">
                <td class="ps-3">{{ item.cuenta }}</td>
                <td class="text-end">{{ formatCurrency(item.total) }}</td>
              </tr>
              <tr class="fw-bold border-top bg-light">
                <td class="py-2">TOTAL INGRESOS</td>
                <td class="text-end py-2 text-success">{{ formatCurrency(totalIngresos) }}</td>
              </tr>

              <!-- Costos -->
              <tr>
                <td colspan="2"><h5 class="fw-bold text-uppercase border-bottom pb-2 mt-5 mb-3">Costos de Ventas</h5></td>
              </tr>
              <tr v-for="item in costos" :key="item.cuenta">
                <td class="ps-3">{{ item.cuenta }}</td>
                <td class="text-end text-danger">- {{ formatCurrency(item.total) }}</td>
              </tr>
              <tr class="fw-bold border-top bg-light">
                <td class="py-2">TOTAL COSTOS</td>
                <td class="text-end py-2 text-danger">- {{ formatCurrency(totalCostos) }}</td>
              </tr>

              <!-- Utilidad Bruta -->
              <tr class="fw-bold" style="border-bottom: 2px solid #000; border-top: 2px solid #000;">
                <td class="py-3 text-uppercase fs-5">Utilidad Bruta</td>
                <td class="text-end py-3 fs-5">{{ formatCurrency(utilidadBruta) }}</td>
              </tr>

              <!-- Gastos -->
              <tr>
                <td colspan="2"><h5 class="fw-bold text-uppercase border-bottom pb-2 mt-5 mb-3">Gastos Operativos</h5></td>
              </tr>
              <tr v-for="item in gastos" :key="item.cuenta">
                <td class="ps-3">{{ item.cuenta }}</td>
                <td class="text-end text-danger">- {{ formatCurrency(item.total) }}</td>
              </tr>
              <tr class="fw-bold border-top bg-light">
                <td class="py-2">TOTAL GASTOS</td>
                <td class="text-end py-2 text-danger">- {{ formatCurrency(totalGastos) }}</td>
              </tr>

              <!-- Utilidad Neta -->
              <tr class="fw-bold text-white mt-4" :class="utilidadNeta >= 0 ? 'bg-success' : 'bg-danger'">
                <td class="py-3 text-uppercase fs-4 ps-3">Utilidad / (Pérdida) Neta</td>
                <td class="text-end py-3 fs-4 pe-3">{{ formatCurrency(utilidadNeta) }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import html2pdf from 'html2pdf.js'
import Sidebar from '../../../components/Sidebar.vue'
import { useAuth } from '../../../core/composables/useAuth'
import { fetchVEstadoResultados } from '../accounting.api'

const auth = useAuth()
const restaurantName = computed(() => auth.restaurant.value?.nombre || 'Komanda Restaurant')
const userName = computed(() => auth.user.value?.nombre || 'Contador')

const today = new Date().toISOString().split('T')[0]
const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0]
const filterDateFrom = ref(thirtyDaysAgo)
const filterDateTo = ref(today)
const loading = ref(false)

const ingresos = ref<any[]>([])
const costos = ref<any[]>([])
const gastos = ref<any[]>([])

const totalIngresos = computed(() => ingresos.value.reduce((acc, curr) => acc + Number(curr.total), 0))
const totalCostos = computed(() => costos.value.reduce((acc, curr) => acc + Number(curr.total), 0))
const totalGastos = computed(() => gastos.value.reduce((acc, curr) => acc + Number(curr.total), 0))

const utilidadBruta = computed(() => totalIngresos.value - totalCostos.value)
const utilidadNeta = computed(() => utilidadBruta.value - totalGastos.value)

const formattedDateFrom = computed(() => filterDateFrom.value ? new Date(filterDateFrom.value).toLocaleDateString() : '')
const formattedDateTo = computed(() => filterDateTo.value ? new Date(filterDateTo.value).toLocaleDateString() : '')

const formatCurrency = (val: number | string) => {
  return new Intl.NumberFormat('es-US', {
    style: 'currency',
    currency: 'USD',
  }).format(Number(val))
}

const printReport = () => {
  const element = document.getElementById('income-statement-report')
  if (!element) return

  const opt = {
    margin:       0.5,
    filename:     `estado_resultados_${filterDateFrom.value}_${filterDateTo.value}.pdf`,
    image:        { type: 'jpeg' as const, quality: 0.98 },
    html2canvas:  { scale: 2 },
    jsPDF:        { unit: 'in' as const, format: 'letter' as const, orientation: 'portrait' as const }
  }
  html2pdf().set(opt).from(element).save()
}

const fetchData = async () => {
  loading.value = true
  try {
    const data = await fetchVEstadoResultados(filterDateFrom.value, filterDateTo.value).catch(() => []) || []
    ingresos.value = data.filter((d: any) => d.tipo === 'ingreso')
    costos.value = data.filter((d: any) => d.tipo === 'costo')
    gastos.value = data.filter((d: any) => d.tipo === 'gasto')
  } catch (error) {
    console.error('Error fetching income statement:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchData()
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

/* Formal Document Print Styles */
.formal-doc {
  font-family: 'Times New Roman', Times, serif;
}
.formal-table td {
  padding-top: 0.25rem;
  padding-bottom: 0.25rem;
}
.formal-table tfoot td {
  border-top: 2px solid #000;
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
