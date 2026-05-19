<template>
  <div class="d-flex w-100">
    <Sidebar role="admin" :userName="userName" />

    <main class="accounting-wrapper p-3 p-md-4 main-content">
      <!-- Header -->
      <header class="mb-4 d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
        <div>
          <h1 class="fw-bold mb-1 text-primary-custom d-flex align-items-center">
            <i class="bi bi-bank text-korange me-2"></i>
            Balance General
          </h1>
          <p class="text-secondary-custom mb-0 small">
            Estado de Situación Financiera de <strong class="text-korange">{{ restaurantName }}</strong>
          </p>
        </div>

        <!-- Filtros de Fecha y Reportes -->
        <div class="d-flex align-items-center gap-2 flex-wrap">
          <div class="date-filter shadow-sm px-3 py-2 bg-light rounded-pill border">
            <i class="bi bi-calendar-check text-success me-2"></i>
            <span class="small fw-bold text-muted">A la fecha: {{ new Date().toLocaleDateString() }} (Acumulado)</span>
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
      <div id="balance-sheet-report" class="bg-white p-5 rounded-4 shadow-sm text-dark formal-doc mx-auto" style="max-width: 900px;">
        <div class="text-center mb-5 border-bottom pb-4">
          <h2 class="fw-bold mb-1">{{ restaurantName }}</h2>
          <h4 class="text-uppercase mb-2">Estado de Situación Financiera (Balance General)</h4>
          <p class="mb-0 text-muted">Al {{ new Date().toLocaleDateString() }}</p>
          <p class="mb-0 text-muted">Expresado en Dólares Estadounidenses (USD)</p>
        </div>

        <div class="row g-5">
          <!-- Columna Activos -->
          <div class="col-12 col-md-6">
            <h5 class="fw-bold text-uppercase border-bottom pb-2 mb-3">Activos</h5>
            <table class="table table-borderless table-sm formal-table">
              <tbody>
                <tr v-for="item in activos" :key="item.codigo">
                  <td class="ps-3"><span class="me-2 text-muted small">{{ item.codigo }}</span>{{ item.cuenta }}</td>
                  <td class="text-end">{{ formatCurrency(item.saldo) }}</td>
                </tr>
              </tbody>
              <tfoot>
                <tr class="fw-bold border-top">
                  <td class="py-2">TOTAL ACTIVOS</td>
                  <td class="text-end py-2 text-success">{{ formatCurrency(totalActivos) }}</td>
                </tr>
              </tfoot>
            </table>
          </div>

          <!-- Columna Pasivos y Patrimonio -->
          <div class="col-12 col-md-6">
            <h5 class="fw-bold text-uppercase border-bottom pb-2 mb-3">Pasivos</h5>
            <table class="table table-borderless table-sm formal-table mb-4">
              <tbody>
                <tr v-for="item in pasivos" :key="item.codigo">
                  <td class="ps-3"><span class="me-2 text-muted small">{{ item.codigo }}</span>{{ item.cuenta }}</td>
                  <td class="text-end">{{ formatCurrency(item.saldo) }}</td>
                </tr>
              </tbody>
              <tfoot>
                <tr class="fw-bold border-top">
                  <td class="py-2">TOTAL PASIVOS</td>
                  <td class="text-end py-2 text-danger">{{ formatCurrency(totalPasivos) }}</td>
                </tr>
              </tfoot>
            </table>

            <h5 class="fw-bold text-uppercase border-bottom pb-2 mb-3 mt-4">Patrimonio</h5>
            <table class="table table-borderless table-sm formal-table">
              <tbody>
                <tr v-for="item in patrimonio" :key="item.codigo">
                  <td class="ps-3"><span class="me-2 text-muted small">{{ item.codigo }}</span>{{ item.cuenta }}</td>
                  <td class="text-end">{{ formatCurrency(item.saldo) }}</td>
                </tr>
              </tbody>
              <tfoot>
                <tr class="fw-bold border-top">
                  <td class="py-2">TOTAL PATRIMONIO</td>
                  <td class="text-end py-2 text-primary">{{ formatCurrency(totalPatrimonio) }}</td>
                </tr>
                <tr class="fw-bold border-top bg-light mt-3">
                  <td class="py-3">TOTAL PASIVO Y PATRIMONIO</td>
                  <td class="text-end py-3 text-dark">{{ formatCurrency(totalPasivos + totalPatrimonio) }}</td>
                </tr>
              </tfoot>
            </table>
          </div>
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
import { fetchVBalanceGeneral, fetchVEstadoResultados } from '../accounting.api'

const auth = useAuth()
const restaurantName = computed(() => auth.restaurant.value?.nombre || 'Komanda Restaurant')
const userName = computed(() => auth.user.value?.nombre || 'Contador')

const today = new Date().toISOString().split('T')[0]
const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0]
const filterDateFrom = ref(thirtyDaysAgo)
const filterDateTo = ref(today)
const loading = ref(false)

const activos = ref<any[]>([])
const pasivos = ref<any[]>([])
const patrimonio = ref<any[]>([])

const totalActivos = computed(() => activos.value.reduce((acc, curr) => acc + Number(curr.saldo), 0))
const totalPasivos = computed(() => pasivos.value.reduce((acc, curr) => acc + Number(curr.saldo), 0))
const totalPatrimonio = computed(() => patrimonio.value.reduce((acc, curr) => acc + Number(curr.saldo), 0))

const formatCurrency = (val: number | string) => {
  return new Intl.NumberFormat('es-US', {
    style: 'currency',
    currency: 'USD',
  }).format(Number(val))
}

const printReport = () => {
  const element = document.getElementById('balance-sheet-report')
  if (!element) return

  const opt = {
    margin:       0.5,
    filename:     `balance_general_${filterDateFrom.value}_${filterDateTo.value}.pdf`,
    image:        { type: 'jpeg' as const, quality: 0.98 },
    html2canvas:  { scale: 2 },
    jsPDF:        { unit: 'in' as const, format: 'letter' as const, orientation: 'portrait' as const }
  }
  html2pdf().set(opt).from(element).save()
}

const fetchData = async () => {
  loading.value = true
  try {
    const data = await fetchVBalanceGeneral()
    activos.value = data.filter(d => d.tipo === 'activo')
    pasivos.value = data.filter(d => d.tipo === 'pasivo')
    
    // El balance general debe incluir la Utilidad del Ejercicio acumulada en el patrimonio
    // para que Activo = Pasivo + Patrimonio
    const erData = await fetchVEstadoResultados().catch(() => []) || []
    let totalIngresos = 0
    let totalCostosGastos = 0
    erData.forEach(item => {
      if (item.tipo === 'ingreso') totalIngresos += Number(item.total)
      else totalCostosGastos += Number(item.total)
    })
    const utilidadAcumulada = totalIngresos - totalCostosGastos

    const rawPatrimonio = (data || []).filter(d => d.tipo === 'patrimonio')
    patrimonio.value = [
      ...rawPatrimonio,
      { codigo: '3.0.00', cuenta: 'Utilidad del Ejercicio (Acumulada)', saldo: utilidadAcumulada, tipo: 'patrimonio' }
    ]
  } catch (error) {
    console.error('Error fetching balance sheet:', error)
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
