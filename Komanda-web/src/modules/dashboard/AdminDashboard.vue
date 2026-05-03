<template>
  <div class="d-flex w-100">
    <Sidebar role="admin" :userName="userName" />
    <div class="admin-wrapper p-3 p-md-5 main-content">

      <header class="row mb-5 align-items-center">
        <div class="col-12 col-md-8 text-center text-md-start">
          <h1 class="fw-bold mb-1 text-primary-custom">¡Bienvenido, <span class="text-korange">Administrador</span>!
          </h1>
          <p class="text-secondary-custom">Panel de control administrativo — {{ currentDate }}</p>
        </div>
        <div class="col-12 col-md-4 text-center text-md-end mt-3 mt-md-0">
          <button class="btn-korange rounded-pill px-4 shadow-sm">
            <i class="bi bi-printer me-2"></i>Reporte Diario
          </button>
        </div>
      </header>

      <div class="row g-4 mb-5">
        <div class="col-12 col-md-6 col-xl-3">
          <div class="card  shadow-sm h-100 card-custom">
            <div class="card-body">
              <h6 class="text-secondary-custom small fw-bold mb-2 text-uppercase">Ventas del día</h6>
              <div v-if="loading" class="placeholder-glow"><span class="placeholder col-8"></span></div>
              <template v-else>
                <div class="d-flex align-items-baseline">
                  <h3 class="fw-bold mb-0 text-primary-custom">${{ stats.ventas.total_hoy.toFixed(2) }}</h3>
                  <span v-if="stats.ventas.variacion_porcentaje !== null"
                    :class="parseFloat(stats.ventas.variacion_porcentaje) >= 0 ? 'text-success' : 'text-danger'"
                    class="small fw-bold ms-2">
                    <i :class="parseFloat(stats.ventas.variacion_porcentaje) >= 0 ? 'bi bi-caret-up-fill' : 'bi bi-caret-down-fill'"></i>
                    {{ Math.abs(parseFloat(stats.ventas.variacion_porcentaje)) }}%
                  </span>
                </div>
                <div class="mt-2 small text-secondary-custom">Ayer: ${{ stats.ventas.total_ayer.toFixed(2) }}</div>
              </template>
            </div>
          </div>
        </div>

        <div class="col-12 col-md-6 col-xl-3">
          <div class="card  shadow-sm h-100 card-custom">
            <div class="card-body">
              <h6 class="text-secondary-custom small fw-bold mb-2 text-uppercase">Margen de Utilidad</h6>
              <div v-if="loading" class="placeholder-glow"><span class="placeholder col-6"></span></div>
              <template v-else>
                <h3 class="fw-bold mb-1 text-primary-custom">{{ stats.margen_utilidad }}%</h3>
                <div class="progress bg-korange-light" style="height: 6px;">
                  <div class="progress-bar bg-korange" role="progressbar" :style="{ width: Math.min(stats.margen_utilidad, 100) + '%' }"></div>
                </div>
                <small class="text-secondary-custom mt-2 d-block">Objetivo: 40%</small>
              </template>
            </div>
          </div>
        </div>

        <div class="col-12 col-md-6 col-xl-3">
          <div class="card  shadow-sm h-100 card-custom">
            <div class="card-body">
              <h6 class="text-secondary-custom small fw-bold mb-2 text-uppercase">Top 3 Vendidos</h6>
              <div v-if="loading" class="placeholder-glow"><span class="placeholder col-10"></span></div>
              <ul v-else-if="stats.top_productos.length" class="list-unstyled mb-0 small">
                <li v-for="(p, i) in stats.top_productos" :key="i"
                  :class="['d-flex justify-content-between text-primary-custom py-1', i < stats.top_productos.length - 1 ? 'border-bottom border-color' : '']">
                  {{ i + 1 }}. {{ p.nombre }} <span class="fw-bold">{{ p.cantidad }}</span>
                </li>
              </ul>
              <p v-else class="small text-secondary-custom mb-0">Sin ventas hoy</p>
            </div>
          </div>
        </div>

        <div class="col-12 col-md-6 col-xl-3">
          <div class="card  shadow-sm h-100 border-start border-danger border-4 card-custom">
            <div class="card-body">
              <h6 class="text-danger small fw-bold mb-2 text-uppercase">Stock Crítico</h6>
              <div v-if="loading" class="placeholder-glow"><span class="placeholder col-6"></span></div>
              <template v-else>
                <h3 class="fw-bold text-danger mb-0">{{ stats.stock_critico }} Insumos</h3>
                <p class="text-secondary-custom mb-0 small">{{ stats.stock_critico > 0 ? 'Revisar inventario ahora' : '¡Stock en orden!' }}</p>
              </template>
            </div>
          </div>
        </div>
      </div>

      <div class="row g-4 mb-5">
        <div class="col-12 col-lg-8">
          <div class="card  shadow-sm p-4 h-100 card-custom">
            <div class="d-flex justify-content-between align-items-center mb-4">
              <h5 class="fw-bold mb-0 text-primary-custom">Ingresos vs Egresos Semanal</h5>
              <div class="dropdown">
                <button class="btn btn-sm border border-color text-secondary bg-surface-custom dropdown-toggle"
                  type="button" data-bs-toggle="dropdown">
                  Últimos 7 días
                </button>
              </div>
            </div>
            <div class="chart-container rounded d-flex align-items-end justify-content-around p-3">
              <template v-if="loading">
                <div class="align-self-center text-center w-100">
                  <div class="spinner-border text-secondary"></div>
                </div>
              </template>
              <template v-else-if="stats.ingresos_egresos_semana.length === 0">
                <div class="align-self-center text-center w-100">
                  <p class="text-secondary-custom small mb-0">Sin datos de esta semana</p>
                </div>
              </template>
              <template v-else>
                <div v-for="day in stats.ingresos_egresos_semana" :key="day.dia" class="d-flex flex-column align-items-center h-100" style="width: 12%">
                  <div class="d-flex align-items-end h-100 w-100 mb-2 gap-1 border-bottom border-color">
                    <div class="bg-success w-50" :style="{ height: Math.max((day.ingresos / maxSemana) * 100, 2) + '%' }" :title="'Ingresos: $' + day.ingresos.toFixed(2)"></div>
                    <div class="bg-danger w-50 opacity-75" :style="{ height: Math.max((day.egresos / maxSemana) * 100, 2) + '%' }" :title="'Egresos: $' + day.egresos.toFixed(2)"></div>
                  </div>
                  <small class="text-secondary-custom" style="font-size: 0.7rem">{{ day.dia }}</small>
                </div>
              </template>
            </div>
            <div class="d-flex justify-content-center mt-3 gap-4 small text-secondary-custom">
              <span><i class="bi bi-square-fill text-success me-1"></i> Ingresos</span>
              <span><i class="bi bi-square-fill text-danger opacity-75 me-1"></i> Egresos</span>
            </div>
          </div>
        </div>

        <div class="col-12 col-lg-4">
          <div class="card  shadow-sm p-4 h-100 card-custom">
            <h5 class="fw-bold mb-4 text-center text-lg-start text-primary-custom">Ventas por Categoría</h5>
            <div class="pie-placeholder mx-auto mb-4 shadow-sm" :style="{ background: pieGradient }"></div>
            <div class="legend small">
              <div v-if="loading" class="placeholder-glow"><span class="placeholder col-12"></span></div>
              <template v-else-if="stats.ventas_por_categoria.length > 0">
                <div v-for="(cat, index) in stats.ventas_por_categoria" :key="cat.nombre" class="d-flex justify-content-between border-bottom border-color pb-2 mb-2">
                  <span><i class="bi bi-circle-fill me-2" :style="{ color: pieColors[index % pieColors.length] }"></i> {{ cat.nombre }}</span>
                  <span class="fw-bold">{{ cat.porcentaje }}%</span>
                </div>
              </template>
              <p v-else class="text-secondary-custom small text-center mb-0">Sin ventas hoy</p>
            </div>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="col-12">
          <div class="card  shadow-sm p-4 border-top border-danger border-4 card-custom">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
              <h5 class="fw-bold text-danger mb-0">Mermas Recientes Reportadas</h5>
              <button class="btn btn-sm btn-outline-danger px-3 rounded-pill">Gestionar todas las mermas</button>
            </div>
            <div class="table-responsive">
              <table class="table table-custom table-hover-custom align-middle mb-0">
                <thead>
                  <tr>
                    <th>Ingrediente</th>
                    <th>Cantidad</th>
                    <th>Razón de Merma</th>
                    <th>Reportado</th>
                    <th>Fecha y Hora</th>
                  </tr>
                </thead>
                <tbody>
                  <template v-if="loading">
                    <tr><td colspan="5" class="text-center py-3"><div class="spinner-border spinner-border-sm text-secondary"></div></td></tr>
                  </template>
                  <template v-else-if="!stats.mermas_recientes.length">
                    <tr><td colspan="5" class="text-center py-3 text-secondary-custom">Sin mermas recientes</td></tr>
                  </template>
                  <template v-else>
                    <tr v-for="m in stats.mermas_recientes" :key="m.fecha">
                      <td><span class="fw-bold">{{ m.ingrediente }}</span></td>
                      <td>{{ m.cantidad }}</td>
                      <td><span class="badge rounded-pill bg-warning-subtle text-dark px-3">{{ m.razon }}</span></td>
                      <td>{{ m.reportado_por }}</td>
                      <td class="text-secondary-custom">{{ formatFecha(m.fecha) }}</td>
                    </tr>
                  </template>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import Sidebar from '../../components/Sidebar.vue';
import { useAuth } from '../../core/composables/useAuth';
import { fetchAdminStats, type AdminStats } from './dashboard.api';

const auth = useAuth();
const userName = computed(() => auth.user.value?.nombre || 'Administrador');
const loading = ref(true);

const currentDate = new Date().toLocaleDateString('es-ES', {
  weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
});

const stats = ref<AdminStats>({
  ventas: { total_hoy: 0, total_ayer: 0, pedidos_hoy: 0, variacion_porcentaje: null },
  top_productos: [],
  stock_critico: 0,
  margen_utilidad: 0,
  mermas_recientes: [],
  ventas_por_categoria: [],
  ingresos_egresos_semana: [],
});

const pieColors = ['var(--KOrange)', '#0d6efd', '#ffc107', '#198754', '#dc3545', '#6c757d'];

const pieGradient = computed(() => {
  if (stats.value.ventas_por_categoria.length === 0) return 'var(--bg-surface)';
  let gradient = 'conic-gradient(';
  let currentPercentage = 0;
  stats.value.ventas_por_categoria.forEach((cat, index) => {
    const color = pieColors[index % pieColors.length];
    gradient += `${color} ${currentPercentage}% ${currentPercentage + cat.porcentaje}%, `;
    currentPercentage += cat.porcentaje;
  });
  return gradient.slice(0, -2) + ')';
});

const maxSemana = computed(() => {
  if (!stats.value.ingresos_egresos_semana.length) return 1;
  return Math.max(...stats.value.ingresos_egresos_semana.map(d => Math.max(d.ingresos, d.egresos)));
});

const formatFecha = (iso: string) =>
  new Date(iso).toLocaleString('es-VE', { day: '2-digit', month: '2-digit', hour: '2-digit', minute: '2-digit' });

onMounted(async () => {
  try {
    stats.value = await fetchAdminStats();
  } catch (e) {
    console.error('Error cargando stats del admin:', e);
  } finally {
    loading.value = false;
  }
});
</script>

<style scoped>
/* Aplicación de tus variables de style.css */
.admin-wrapper {
  background-color: var(--bg-body);
  color: var(--text-main);
  min-height: 100vh;
  width: 100%;
}

@media (min-width: 768px) {
  .main-content {
    margin-left: 260px;
    width: calc(100% - 260px);
  }
}

.card-custom {
  background-color: var(--bg-body);
  border: 1px solid var(--border-color) !important;
  transition: all var(--transition-speed) ease;
}

.card-custom:hover {
  transform: translateY(-8px);
  border-color: var(--KOrange) !important;
  box-shadow: 0 1rem 3rem rgba(0, 0, 0, 0.1) !important;
}

.text-korange {
  color: var(--KOrange) !important;
}

.bg-korange {
  background-color: var(--KOrange) !important;
}

.bg-korange-light {
  background-color: var(--KOrange-light) !important;
}

.bg-surface-custom {
  background-color: var(--bg-surface);
}

.text-primary-custom {
  color: var(--text-main);
}

.text-secondary-custom {
  color: var(--text-muted);
}

.border-color {
  border-color: var(--border-color) !important;
}

/* Gráficos */
.chart-container {
  height: 300px;
  background-color: var(--bg-surface);
  border: 2px dashed var(--border-color);
}

.pie-placeholder {
  width: 180px;
  height: 180px;
  border-radius: 50%;
  transition: transform var(--transition-speed) ease;
}

.pie-placeholder:hover {
  transform: scale(1.05);
}

/* Tablas */
.table thead th {
  font-size: 0.85rem;
  font-weight: bold;
}
</style>