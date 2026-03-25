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
              <div class="d-flex align-items-baseline">
                <h3 class="fw-bold mb-0 text-primary-custom">$1,420.50</h3>
                <span class="text-success small fw-bold ms-2">
                  <i class="bi bi-caret-up-fill"></i> 12%
                </span>
              </div>
              <div class="mt-2 small text-secondary-custom">Ayer: $1,262.00</div>
            </div>
          </div>
        </div>

        <div class="col-12 col-md-6 col-xl-3">
          <div class="card  shadow-sm h-100 card-custom">
            <div class="card-body">
              <h6 class="text-secondary-custom small fw-bold mb-2 text-uppercase">Margen de Utilidad</h6>
              <h3 class="fw-bold mb-1 text-primary-custom">34.2%</h3>
              <div class="progress bg-korange-light" style="height: 6px;">
                <div class="progress-bar bg-korange" role="progressbar" style="width: 34%"></div>
              </div>
              <small class="text-secondary-custom mt-2 d-block">Objetivo: 40%</small>
            </div>
          </div>
        </div>

        <div class="col-12 col-md-6 col-xl-3">
          <div class="card  shadow-sm h-100 card-custom">
            <div class="card-body">
              <h6 class="text-secondary-custom small fw-bold mb-2 text-uppercase">Top 3 Vendidos</h6>
              <ul class="list-unstyled mb-0 small">
                <li class="d-flex justify-content-between text-primary-custom border-bottom border-color py-1">1. 🍔
                  Hamburguesa <span class="fw-bold">45</span></li>
                <li class="d-flex justify-content-between text-primary-custom border-bottom border-color py-1">2. 🌮
                  Tacos <span class="fw-bold">38</span></li>
                <li class="d-flex justify-content-between text-primary-custom py-1">3. 🍝 Pasta <span
                    class="fw-bold">30</span></li>
              </ul>
            </div>
          </div>
        </div>

        <div class="col-12 col-md-6 col-xl-3">
          <div class="card  shadow-sm h-100 border-start border-danger border-4 card-custom">
            <div class="card-body">
              <h6 class="text-danger small fw-bold mb-2 text-uppercase">Stock Crítico</h6>
              <h3 class="fw-bold text-danger mb-0">4 Insumos</h3>
              <p class="text-secondary-custom mb-0 small">Revisar inventario ahora</p>
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
            <div class="chart-container rounded d-flex align-items-center justify-content-center">
              <div class="text-center">
                <i class="bi bi-bar-chart-line fs-1 text-secondary-custom opacity-25"></i>
                <p class="text-secondary-custom small mt-2">Área reservada para Chart.js</p>
              </div>
            </div>
          </div>
        </div>

        <div class="col-12 col-lg-4">
          <div class="card  shadow-sm p-4 h-100 card-custom">
            <h5 class="fw-bold mb-4 text-center text-lg-start text-primary-custom">Ventas por Categoría</h5>
            <div class="pie-placeholder mx-auto mb-4 shadow-sm"></div>
            <div class="legend small">
              <div class="d-flex justify-content-between border-bottom border-color pb-2 mb-2">
                <span><i class="bi bi-circle-fill text-korange me-2"></i> Platos Fuertes</span>
                <span class="fw-bold">60%</span>
              </div>
              <div class="d-flex justify-content-between border-bottom border-color pb-2 mb-2">
                <span><i class="bi bi-circle-fill text-primary me-2"></i> Entradas</span>
                <span class="fw-bold">25%</span>
              </div>
              <div class="d-flex justify-content-between">
                <span><i class="bi bi-circle-fill text-warning me-2"></i> Bebidas</span>
                <span class="fw-bold">15%</span>
              </div>
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
                  <tr>
                    <td><span class="fw-bold">Carne Sirloin</span></td>
                    <td>1.5 kg</td>
                    <td><span class="badge rounded-pill bg-danger-subtle text-danger px-3">Vencimiento</span></td>
                    <td>Chef Carlos</td>
                    <td class="text-secondary-custom">Hoy, 14:30</td>
                  </tr>
                  <tr>
                    <td><span class="fw-bold">Tomate Cherry</span></td>
                    <td>0.8 kg</td>
                    <td><span class="badge rounded-pill bg-warning-subtle text-dark px-3">Deterioro</span></td>
                    <td>Cocinero Juan</td>
                    <td class="text-secondary-custom">Ayer, 18:20</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import Sidebar from '../../components/Sidebar.vue';
import { useAuth } from '../../core/composables/useAuth';

const auth = useAuth()
const userName = computed(() => auth.user.value?.nombre || 'Administrador')

const currentDate = new Date().toLocaleDateString('es-ES', {
  weekday: 'long',
  year: 'numeric',
  month: 'long',
  day: 'numeric'
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
  /* Usamos tu KOrange para el sector mayoritario */
  background: conic-gradient(var(--KOrange) 0% 60%, #0d6efd 60% 85%, #ffc107 85% 100%);
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