<template>
  <div class="d-flex w-100">
    <Sidebar role="admin" :userName="userName" />

    <main class="reports-wrapper p-3 p-md-4 main-content">

      <!-- Header -->
      <header class="mb-4">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-3">
          <div>
            <h1 class="fw-bold mb-1 text-primary-custom">
              <i class="bi bi-graph-up-arrow text-korange me-2"></i>
              Panel de Reportes
            </h1>
            <p class="text-secondary-custom mb-0 small">
              Análisis de rentabilidad para <strong class="text-korange">{{ restaurantName }}</strong>
              — {{ currentDate }}
            </p>
          </div>
        </div>
      </header>

      <!-- Este Div envuelve el contenido principal -->
      <div class="p-1">
        
        <!-- KPI Cards -->
        <section class="row g-3 mb-4">
          <div class="col-12 col-sm-6 col-xl-3" v-for="kpi in kpis" :key="kpi.label">
            <KpiCard v-bind="kpi" />
          </div>
        </section>

        <!-- Chart + Donut -->
        <section class="row g-3 mb-4">
          <div class="col-12 col-xl-8">
            <SalesChart :data="overviewData?.chartData || []" />
          </div>
          <div class="col-12 col-xl-4">
            <div class="summary-panel h-100">
              <h6 class="summary-panel__title">Distribución de Margen</h6>
              <p class="summary-panel__sub">Ingresos del período seleccionado</p>

              <div class="donut-chart mx-auto mb-4" :style="{ background: donutGradient }">
                <div class="donut-inner">
                  <span class="donut-value">{{ donutPct }}</span>
                  <span class="donut-label">Utilidad</span>
                </div>
              </div>

              <div class="summary-items">
                <div class="summary-item" v-for="s in summaryItems" :key="s.label">
                  <div class="d-flex justify-content-between align-items-center mb-1">
                    <span class="summary-item__label">
                      <span class="dot" :style="{ background: s.color }"></span>
                      {{ s.label }}
                    </span>
                    <span class="summary-item__value">{{ s.value }}</span>
                  </div>
                  <div class="progress" style="height: 4px; border-radius: 2px;">
                    <div class="progress-bar" :style="{ width: s.pct + '%', background: s.color }"></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- Profitability Table -->
        <section class="mb-4">
          <ProfitabilityTable :data="overviewData?.rentabilidad || []" />
        </section>

        <!-- Detailed Data Table Seleccionada -->
        <section class="mb-4" id="report-content">
          <div class="card shadow-sm p-4 h-100 bg-surface-custom border border-color">
              
              <!-- Controles de exportación (Botón PDF encima de los filtros) -->
              <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-3 gap-2">
                <h5 class="fw-bold mb-0 text-primary-custom d-flex align-items-center">
                  <i class="bi bi-funnel text-korange me-2"></i>
                  Extracción de Datos
                </h5>
                <button @click="downloadPDF" class="btn-korange px-4 py-2 rounded-pill shadow-sm d-flex align-items-center gap-2 align-self-start align-self-md-auto" style="color: white !important; font-weight: bold; background-color: var(--KOrange); border: none; cursor: pointer;" :disabled="isGeneratingPDF" data-html2canvas-ignore="true">
                  <i class="bi bi-file-earmark-pdf-fill fs-5"></i> 
                  {{ isGeneratingPDF ? 'Generando PDF...' : 'Descargar Reporte PDF' }}
                </button>
              </div>

              <!-- Barra de filtros integrada en la tabla -->
              <div class="row g-3 align-items-end mb-4 border-bottom border-color pb-4">
                 <div class="col-12 col-md-12 col-xl-4">
                   <label class="form-label small text-secondary-custom fw-bold mb-1">Tipo de Reporte a evaluar</label>
                   <select v-model="selectedReportType" class="form-select form-select-sm border-color text-primary-custom" @change="generateReportData">
                     <option value="ventas">Ventas y Rentabilidad</option>
                     <option value="inventario">Estado de Inventario</option>
                     <option value="empleados">Rendimiento por Empleado</option>
                     <option value="gastos">Gastos Operativos (Opex)</option>
                     <option value="contabilidad">Libro Diario Contable</option>
                     <option value="mermas">Control de Mermas</option>
                     <option value="predicciones">Pronóstico de Ventas (Predicciones)</option>
                   </select>
                 </div>
                 <div class="col-12 col-sm-6 col-xl-3">
                   <label class="form-label small text-secondary-custom fw-bold mb-1">Desde Fecha</label>
                   <input type="date" v-model="dateFrom" :max="todayString" class="form-control form-control-sm border-color text-primary-custom">
                 </div>
                 <div class="col-12 col-sm-6 col-xl-3">
                   <label class="form-label small text-secondary-custom fw-bold mb-1">Hasta Fecha</label>
                   <input type="date" v-model="dateTo" :max="todayString" class="form-control form-control-sm border-color text-primary-custom">
                 </div>
                 <div class="col-12 col-xl-2 ms-auto mt-3 mt-xl-0">
                   <button class="btn btn-outline-korange btn-sm w-100 fw-bold" @click="generateReportData">
                     <i class="bi bi-funnel me-1"></i> Filtrar Datos
                   </button>
                 </div>
              </div>

              <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold mb-0 text-primary-custom d-flex align-items-center">
                  <i class="bi bi-table text-korange me-2"></i>
                  Detalle del Reporte: <span class="text-secondary-custom ms-2 fs-6 fw-normal">{{ reportTitle }}</span>
                </h5>
              </div>
              
              <div class="table-responsive">
                <table class="table table-custom table-hover-custom table-hover-orange align-middle mb-0">
                  <thead class="bg-surface-custom">
                    <tr v-if="currentDisplayedReportType === 'ventas'">
                      <th>Fecha de Transacción</th>
                      <th>Ticket / Factura</th>
                      <th>Monto Base</th>
                      <th>Impuestos</th>
                      <th>Total Recaudado</th>
                    </tr>
                    <tr v-else-if="currentDisplayedReportType === 'inventario'">
                      <th>Nombre del Insumo</th>
                      <th>Stock Actual Mínimo</th>
                      <th>Punto de Reorden Configurado</th>
                      <th>Estado / Alerta</th>
                    </tr>
                    <tr v-else-if="currentDisplayedReportType === 'empleados'">
                      <th>Nombre del Empleado</th>
                      <th>Cargo Actual</th>
                      <th>Total Ventas Reportadas</th>
                      <th>Horas Turno</th>
                    </tr>
                    <tr v-else-if="currentDisplayedReportType === 'gastos'">
                      <th>Fecha</th>
                      <th>Categoría OpEx</th>
                      <th>Descripción</th>
                      <th>Monto</th>
                      <th>Responsable</th>
                    </tr>
                    <tr v-else-if="currentDisplayedReportType === 'contabilidad'">
                      <th>Fecha Entrada</th>
                      <th>Asiento Contable</th>
                      <th>Cuenta (Debe)</th>
                      <th>Cuenta (Haber)</th>
                      <th>Monto Movimiento</th>
                    </tr>
                    <tr v-else-if="currentDisplayedReportType === 'mermas'">
                      <th>Fecha Registro</th>
                      <th>Insumo</th>
                      <th>Cantidad Mermada</th>
                      <th>Motivo Desperdicio</th>
                      <th>Costo Perdido</th>
                    </tr>
                    <tr v-else-if="currentDisplayedReportType === 'predicciones'">
                      <th>Fecha Proyectada</th>
                      <th>Concepto de Pronóstico</th>
                      <th>Monto Estimado</th>
                      <th>Método de Análisis</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(row, i) in visibleReportData" :key="i">
                      <td v-for="(val, key) in row" :key="key">
                        <span v-if="key === 'estado'">
                          <span class="badge" :class="val === 'Crítico' ? 'bg-danger-subtle text-danger' : 'bg-success-subtle text-success'">
                            {{ val }}
                          </span>
                        </span>
                        <span v-else class="text-primary-custom">{{ val }}</span>
                      </td>
                    </tr>
                    <tr v-if="!visibleReportData.length">
                      <td colspan="5" class="text-center text-secondary-custom py-4">
                        Aún no se han generado datos para los filtros seleccionados.
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <!-- Paginador Visivo -->
              <div class="d-flex justify-content-center mt-4" data-html2canvas-ignore="true" v-if="visibleLimit < reportData.length">
                <button @click="loadMore" class="btn btn-outline-secondary btn-sm px-4 py-2 rounded-pill fw-bold shadow-sm d-flex align-items-center gap-2">
                  <i class="bi bi-chevron-down border-color"></i>
                  Mostrar más registros (<span class="text-korange">{{ reportData.length - visibleLimit }} restantes</span>)
                </button>
              </div>

          </div>
        </section>

        <!-- Insight Banner -->
        <section class="insight-banner mb-2" v-if="worstDish">
          <i class="bi bi-lightbulb-fill text-warning me-2 fs-5"></i>
          <div>
            <strong>Insight Automatizado:</strong>
            <span class="ms-1 text-secondary-custom">
              Durante este período el platillo <span class="text-korange fw-bold">{{ worstDish.name }}</span> refleja
              un margen crítico de <span class="text-danger fw-bold">${{ worstDish.totalGain.toFixed(2) }}</span> atribuído al costo de sus insumos internos. 
              Sugerencia Comercial: Alterar precio final o ajustar gramaje de la receta.
            </span>
          </div>
        </section>
      </div>

    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import Sidebar from '../../../components/Sidebar.vue'
import KpiCard from '../components/KpiCard.vue'
import SalesChart from '../components/SalesChart.vue'
import ProfitabilityTable from '../components/ProfitabilityTable.vue'
import { useAuth } from '../../../core/composables/useAuth'
import { fetchWithAuth } from '../../../core/api/auth.api'

// @ts-ignore
import html2pdf from 'html2pdf.js'

const auth = useAuth()
const userName = computed(() => auth.user.value?.nombre || 'Administrador')
const restaurantName = computed(() => (auth.user.value as any)?.restaurantName || 'Mi Restaurante')

const currentDate = new Date().toLocaleDateString('es-ES', {
  weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
})

// === Filtros y Controles ===
const hoy = new Date()
const hoyStr = hoy.toISOString().split('T')[0]
const haceSieteDias = new Date(hoy)
haceSieteDias.setDate(hoy.getDate() - 7)
const haceSieteDiasStr = haceSieteDias.toISOString().split('T')[0]

const todayString = hoyStr
const dateFrom = ref(haceSieteDiasStr)
const dateTo = ref(todayString)
type ReportType = 'ventas' | 'inventario' | 'empleados' | 'gastos' | 'contabilidad' | 'mermas'
const selectedReportType = ref<ReportType>('ventas')

const currentDisplayedReportType = ref<ReportType | null>(null)
const reportData = ref<Record<string, any>[]>([])
const isGeneratingPDF = ref(false)

const reportTitle = computed(() => {
  if (currentDisplayedReportType.value === 'ventas') return 'Ventas y Rentabilidad de Órdenes'
  if (currentDisplayedReportType.value === 'inventario') return 'Alertas y Estado de Inventario'
  if (currentDisplayedReportType.value === 'empleados') return 'Rendimiento y Productividad por Personal'
  if (currentDisplayedReportType.value === 'gastos') return 'Gastos Operativos y Administrativos'
  if (currentDisplayedReportType.value === 'contabilidad') return 'Libro Diario - Asientos Contables'
  if (currentDisplayedReportType.value === 'mermas') return 'Control de Mermas y Desperdicios'
  if (currentDisplayedReportType.value === 'predicciones') return 'Predicciones y Pronósticos de Ventas (7 días)'
  return '-'
})

// === Paginación y Filtrado ===
const visibleLimit = ref(30)

const visibleReportData = computed(() => {
  return reportData.value.slice(0, visibleLimit.value)
})

const loadMore = () => {
  visibleLimit.value += 30
}

const generateReportData = async () => {
  currentDisplayedReportType.value = selectedReportType.value
  reportData.value = [] // clear while loading
  visibleLimit.value = 30 // reset visible en cada filtro

  try {
    let url = `/reports?type=${selectedReportType.value}`
    if (dateFrom.value && dateTo.value) {
      url += `&dateFrom=${dateFrom.value}&dateTo=${dateTo.value}`
    }
    const res = await fetchWithAuth(url)
    if (res.status === 'success') {
      reportData.value = res.data || []
    } else {
      console.error("Error fetching report data:", res.message)
    }
  } catch (error) {
    console.error("Error connecting to reports API:", error)
  }
}

// === Exportación PDF ====
const downloadPDF = () => {
  isGeneratingPDF.value = true
  const element = document.getElementById('report-content')
  
  if (!element) {
    isGeneratingPDF.value = false
    return
  }

  const opt: any = {
    margin:       [0.3, 0.3, 0.3, 0.3],
    filename:     `Komanda_Reporte_${currentDisplayedReportType.value || 'General'}_${dateFrom.value}_al_${dateTo.value}.pdf`,
    image:        { type: 'jpeg', quality: 0.98 },
    html2canvas:  { scale: 1.5, useCORS: true, backgroundColor: document.documentElement.getAttribute('data-theme') === 'dark' ? '#1a1b1e' : '#ffffff' },
    jsPDF:        { unit: 'in', format: 'letter', orientation: 'portrait' }
  }

  html2pdf().set(opt).from(element).save().then(() => {
    isGeneratingPDF.value = false
  }).catch(() => {
    isGeneratingPDF.value = false
  })
}

// === Datos Dinámicos del Dashboard Overview ===
const overviewData = ref<any>(null)

const fetchOverview = async () => {
  try {
    const res = await fetchWithAuth('/reports/overview')
    if (res.status === 'success') {
      overviewData.value = res.data
    }
  } catch (e) {
    console.error(e)
  }
}

const kpis = computed(() => {
  if (!overviewData.value) return []
  const o = overviewData.value.kpis
  return [
    { label: 'Ingreso Bruto',    value: `$${o.ingreso_bruto.toFixed(2)}`, icon: 'bi-cash-stack',    variant: 'revenue' as const, subtitle: 'Últimos 7 días' },
    { label: 'Costo Operativo', value: `$${o.costo_operativo.toFixed(2)}`, icon: 'bi-receipt-cutoff', variant: 'cost'    as const, subtitle: 'Últimos 7 días' },
    { label: 'Utilidad Neta',   value: `$${(o.ingreso_bruto - o.costo_operativo).toFixed(2)}`, icon: 'bi-graph-up',       variant: 'profit'  as const },
    { label: 'Tickets',         value: `${o.tickets_semana}`,        icon: 'bi-ticket-perforated', variant: 'tickets' as const, subtitle: 'Últimos 7 días' },
  ]
})

const summaryItems = computed(() => {
  if (!overviewData.value) return []
  const o = overviewData.value.kpis
  const margin = o.ingreso_bruto - o.costo_operativo
  return [
    { label: 'Ingreso Bruto', value: `$${o.ingreso_bruto.toFixed(2)}`, pct: 100, color: 'var(--KOrange)' },
    { label: 'Costo Operativo', value: `$${o.costo_operativo.toFixed(2)}`, pct: o.ingreso_bruto > 0 ? (o.costo_operativo / o.ingreso_bruto)*100 : 0, color: '#dc3545' },
    { label: 'Utilidad Neta', value: `$${margin.toFixed(2)}`, pct: o.ingreso_bruto > 0 ? (margin / o.ingreso_bruto)*100 : 0, color: '#20c997' },
  ]
})

const donutPct = computed(() => {
  if (!overviewData.value) return '0%'
  const o = overviewData.value.kpis
  if (o.ingreso_bruto === 0) return '0%'
  return ((o.ingreso_bruto - o.costo_operativo) / o.ingreso_bruto * 100).toFixed(1) + '%'
})

const donutGradient = computed(() => {
  if (!overviewData.value) return 'conic-gradient(#ccc 0% 100%)'
  const o = overviewData.value.kpis
  if (o.ingreso_bruto === 0) return 'conic-gradient(#ccc 0% 100%)'
  const marginPct = ((o.ingreso_bruto - o.costo_operativo) / o.ingreso_bruto * 100).toFixed(1)
  return `conic-gradient(var(--KOrange) 0% ${marginPct}%, #dc3545 ${marginPct}% 100%)`
})

const worstDish = computed(() => {
  if (!overviewData.value || !overviewData.value.rentabilidad?.length) return null
  return [...overviewData.value.rentabilidad].sort((a: any, b: any) => a.totalGain - b.totalGain)[0]
})

onMounted(() => {
  fetchOverview()
  generateReportData()
})
</script>

<style scoped>
.reports-wrapper {
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

/* Custom Surface Card */
.bg-surface-custom {
  background-color: var(--bg-surface) !important;
}

.border-color {
  border-color: var(--border-color) !important;
}

/* Summary Panel */
.summary-panel {
  background-color: var(--bg-surface);
  border: 1px solid var(--border-color);
  border-radius: 1rem;
  padding: 1.5rem;
}

.summary-panel__title {
  font-weight: 700;
  color: var(--text-main);
  margin: 0;
}

.summary-panel__sub {
  font-size: 0.72rem;
  color: var(--text-muted);
  margin: 0.2rem 0 1rem;
}

/* Donut */
.donut-chart {
  width: 140px;
  height: 140px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
}

.donut-inner {
  width: 90px;
  height: 90px;
  border-radius: 50%;
  background: var(--bg-surface);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.donut-value {
  font-size: 1.1rem;
  font-weight: 700;
  color: var(--KOrange);
  line-height: 1;
}

.donut-label {
  font-size: 0.65rem;
  color: var(--text-muted);
}

/* Summary items */
.summary-items { display: flex; flex-direction: column; gap: 0.75rem; }

.summary-item__label {
  font-size: 0.8rem;
  color: var(--text-muted);
  display: flex;
  align-items: center;
  gap: 0.4rem;
}

.summary-item__value {
  font-size: 0.85rem;
  font-weight: 700;
  color: var(--text-main);
}

.dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  display: inline-block;
  flex-shrink: 0;
}

/* Insight Banner */
.insight-banner {
  display: flex;
  align-items: flex-start;
  gap: 0.5rem;
  background: rgba(255, 193, 7, 0.08);
  border: 1px solid rgba(255, 193, 7, 0.25);
  border-radius: 0.75rem;
  padding: 1rem 1.25rem;
  font-size: 0.875rem;
  color: var(--text-main);
}

/* Table overrides to fit well */
.table th {
  font-size: 0.8rem;
}

.table td {
  font-size: 0.9rem;
}
</style>
