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

      <!-- Este Div envuelve lo que se generará en el PDF -->
      <div id="report-content" class="p-1">
        
        <!-- KPI Cards -->
        <section class="row g-3 mb-4">
          <div class="col-6 col-lg-3" v-for="kpi in kpis" :key="kpi.label">
            <KpiCard v-bind="kpi" />
          </div>
        </section>

        <!-- Chart + Donut -->
        <section class="row g-3 mb-4">
          <div class="col-12 col-xl-8">
            <SalesChart />
          </div>
          <div class="col-12 col-xl-4">
            <div class="summary-panel h-100">
              <h6 class="summary-panel__title">Distribución de Margen</h6>
              <p class="summary-panel__sub">Ingresos del período seleccionado</p>

              <div class="donut-chart mx-auto mb-4">
                <div class="donut-inner">
                  <span class="donut-value">34.2%</span>
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
          <ProfitabilityTable />
        </section>

        <!-- Detailed Data Table Seleccionada -->
        <section class="mb-4">
          <div class="card shadow-sm p-4 h-100 bg-surface-custom border border-color">
              
              <!-- Controles de exportación (Botón PDF encima de los filtros) -->
              <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold mb-0 text-primary-custom d-flex align-items-center">
                  <i class="bi bi-funnel text-korange me-2"></i>
                  Extracción de Datos
                </h5>
                <button @click="downloadPDF" class="btn-korange px-4 py-2 rounded-pill shadow-sm d-flex align-items-center gap-2" style="color: white !important; font-weight: bold; background-color: var(--KOrange); border: none; cursor: pointer;" :disabled="isGeneratingPDF">
                  <i class="bi bi-file-earmark-pdf-fill fs-5"></i> 
                  {{ isGeneratingPDF ? 'Generando PDF...' : 'Descargar Reporte PDF' }}
                </button>
              </div>

              <!-- Barra de filtros integrada en la tabla -->
              <div class="row g-3 align-items-end mb-4 border-bottom border-color pb-4">
                 <div class="col-12 col-md-4 col-xl-4">
                   <label class="form-label small text-secondary-custom fw-bold mb-1">Tipo de Reporte a evaluar</label>
                   <select v-model="selectedReportType" class="form-select form-select-sm border-color text-primary-custom" @change="generateReportData">
                     <option value="ventas">Ventas y Rentabilidad</option>
                     <option value="inventario">Estado de Inventario</option>
                     <option value="empleados">Rendimiento por Empleado</option>
                     <option value="gastos">Gastos Operativos (Opex)</option>
                     <option value="contabilidad">Libro Diario Contable</option>
                     <option value="mermas">Control de Mermas</option>
                   </select>
                 </div>
                 <div class="col-6 col-md-3 col-xl-3">
                   <label class="form-label small text-secondary-custom fw-bold mb-1">Desde Fecha</label>
                   <input type="date" v-model="dateFrom" :max="todayString" class="form-control form-control-sm border-color text-primary-custom">
                 </div>
                 <div class="col-6 col-md-3 col-xl-3">
                   <label class="form-label small text-secondary-custom fw-bold mb-1">Hasta Fecha</label>
                   <input type="date" v-model="dateTo" :max="todayString" class="form-control form-control-sm border-color text-primary-custom">
                 </div>
                 <div class="col-12 col-md-2 col-xl-2 ms-auto mt-3 mt-md-0">
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
                  </thead>
                  <tbody>
                    <tr v-for="(row, i) in reportData" :key="i">
                      <td v-for="(val, key) in row" :key="key">
                        <span v-if="key === 'estado'">
                          <span class="badge" :class="val === 'Crítico' ? 'bg-danger-subtle text-danger' : 'bg-success-subtle text-success'">
                            {{ val }}
                          </span>
                        </span>
                        <span v-else class="text-primary-custom">{{ val }}</span>
                      </td>
                    </tr>
                    <tr v-if="!reportData.length">
                      <td colspan="5" class="text-center text-secondary-custom py-4">
                        Aún no se han generado datos para los filtros seleccionados.
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
          </div>
        </section>

        <!-- Insight Banner -->
        <section class="insight-banner mb-2">
          <i class="bi bi-lightbulb-fill text-warning me-2 fs-5"></i>
          <div>
            <strong>Insight Automatizado:</strong>
            <span class="ms-1 text-secondary-custom">
              Durante este período el platillo <span class="text-korange fw-bold">Sopa del Día</span> refleja
              una pérdida progresiva de <span class="text-danger fw-bold">-$117.00</span> atribuído al costo de sus insumos internos. 
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
  return '-'
})

// === Datos Simulados basados en el Tipo de Reporte ===
const mockDataVentas = [
  { fecha: todayString, ticket: '#T-4201', base: '$45.00', tax: '$7.20', total: '$52.20' },
  { fecha: todayString, ticket: '#T-4202', base: '$120.00', tax: '$19.20', total: '$139.20' },
  { fecha: todayString, ticket: '#T-4203', base: '$22.50', tax: '$3.60', total: '$26.10' },
  { fecha: todayString, ticket: '#T-4204', base: '$89.00', tax: '$14.24', total: '$103.24' },
  { fecha: todayString, ticket: '#T-4205', base: '$150.00', tax: '$24.00', total: '$174.00' },
  { fecha: todayString, ticket: '#T-4206', base: '$30.00', tax: '$4.80', total: '$34.80' },
]

const mockDataInventario = [
  { insumo: 'Carne Sirloin', actual: '1.2 kg', reorden: '5.0 kg', estado: 'Crítico' },
  { insumo: 'Tomate Cherry', actual: '0.8 kg', reorden: '3.0 kg', estado: 'Crítico' },
  { insumo: 'Cebolla Blanca', actual: '24.0 kg', reorden: '10.0 kg', estado: 'Óptimo' },
  { insumo: 'Queso Mozzarella', actual: '2.5 kg', reorden: '4.0 kg', estado: 'Crítico' },
  { insumo: 'Pan de Hamburguesa', actual: '150 un', reorden: '50 un', estado: 'Óptimo' },
]

const mockDataEmpleados = [
  { empleado: 'Juan Pérez', cargo: 'Mesero', ventas: '$1,420.00', horas: '42 hs' },
  { empleado: 'Ana Gómez', cargo: 'Cajera', ventas: '$3,800.00', horas: '38 hs' },
  { empleado: 'Luis Martínez', cargo: 'Mesero', ventas: '$980.00', horas: '24 hs' },
  { empleado: 'Carlos Chef', cargo: 'Cocinero', ventas: 'N/A', horas: '45 hs' },
]

const mockDataGastos = [
  { fecha: haceSieteDiasStr, categoria: 'Servicios Básicos', descripcion: 'Pago de Electricidad y Agua', monto: '$450.00', responsable: 'Admin' },
  { fecha: todayString, categoria: 'Mantenimiento', descripcion: 'Reparación de Horno Industrial', monto: '$120.00', responsable: 'Admin' },
  { fecha: todayString, categoria: 'Suministros', descripcion: 'Compra de Empaques y Desechables', monto: '$85.00', responsable: 'Admin' },
]

const mockDataContabilidad = [
  { fecha: todayString, asiento: 'AS-1020', cuenta_debe: 'Banco (Caja Principal)', cuenta_haber: 'Ventas de Servicios', monto: '$174.00' },
  { fecha: todayString, asiento: 'AS-1021', cuenta_debe: 'Costo de Ventas', cuenta_haber: 'Inventario de Materia Prima', monto: '$58.20' },
  { fecha: todayString, asiento: 'AS-1022', cuenta_debe: 'Gastos Operativos (Opex)', cuenta_haber: 'Caja Chica', monto: '$85.00' },
]

const mockDataMermas = [
  { fecha: todayString, insumo: 'Carne Sirloin', cantidad: '0.5 kg', motivo: 'Caducidad de lote B-20', costo_perdido: '$4.90' },
  { fecha: todayString, insumo: 'Lechuga', cantidad: '2 un', motivo: 'Deterioro por mal almacenamiento', costo_perdido: '$1.20' },
  { fecha: haceSieteDiasStr, insumo: 'Tomate Cherry', cantidad: '0.3 kg', motivo: 'Caída accidental en manipulación', costo_perdido: '$1.10' },
]

const generateReportData = () => {
  currentDisplayedReportType.value = selectedReportType.value
  
  // Simulamos carga de datos basada en el dropdown select
  if (selectedReportType.value === 'ventas') {
    reportData.value = mockDataVentas
  } else if (selectedReportType.value === 'inventario') {
    reportData.value = mockDataInventario
  } else if (selectedReportType.value === 'empleados') {
    reportData.value = mockDataEmpleados
  } else if (selectedReportType.value === 'gastos') {
    reportData.value = mockDataGastos
  } else if (selectedReportType.value === 'contabilidad') {
    reportData.value = mockDataContabilidad
  } else if (selectedReportType.value === 'mermas') {
    reportData.value = mockDataMermas
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

// === Datos de Componentes Superiores (Mockeados para la gráfica rápida) ===
const kpis = [
  { label: 'Ingreso Bruto',    value: '$9,930.00', icon: 'bi-cash-stack',    variant: 'revenue' as const, trend: 12,  subtitle: 'Esta semana' },
  { label: 'Costo Operativo', value: '$6,516.00', icon: 'bi-receipt-cutoff', variant: 'cost'    as const, trend: -3,  subtitle: 'Esta semana' },
  { label: 'Utilidad Neta',   value: '$3,414.00', icon: 'bi-graph-up',       variant: 'profit'  as const, trend: 8,   subtitle: 'Margen: 34.4%' },
  { label: 'Tickets / Día',   value: '47',        icon: 'bi-ticket-perforated', variant: 'tickets' as const, trend: 5, subtitle: 'Promedio semanal' },
]

const summaryItems = [
  { label: 'Ingreso',         value: '$9,930', pct: 100, color: 'var(--KOrange)' },
  { label: 'Costo Ingredientes', value: '$6,516', pct: 65.6, color: '#dc3545' },
  { label: 'Utilidad',        value: '$3,414', pct: 34.4, color: '#20c997' },
]

onMounted(() => {
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
  background: conic-gradient(
    var(--KOrange) 0% 34.4%,
    #dc3545 34.4% 100%
  );
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
