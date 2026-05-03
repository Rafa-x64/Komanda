<template>
  <div class="d-flex w-100">
    <Sidebar role="mesero" :userName="userName" />
    <div class="waiter-wrapper p-4 main-content">
      <header class="row mb-4 align-items-center">
        <div class="col-12 col-md-6">
          <h2 class="fw-bold mb-0 text-primary-custom">Atención de <span class="text-korange">Salón</span></h2>
          <p class="text-secondary-custom">Servicio activo: <strong>{{ userName }}</strong></p>
        </div>
        <div class="col-12 col-md-6 text-md-end">
          <div class="d-inline-block bg-surface-custom shadow-sm rounded-pill px-4 py-2 border border-color">
            <span class="text-secondary-custom small">Reloj de turno:</span>
            <span class="fw-bold ms-2 text-primary-custom">{{ currentTime }}</span>
          </div>
        </div>
      </header>

      <!-- KPIs reales -->
      <div class="row g-3 mb-4">
        <div class="col-6 col-lg-3">
          <div class="card shadow-sm h-100 p-2 border-bottom border-primary border-4 card-kpi-custom">
            <div class="card-body text-center">
              <h6 class="text-secondary-custom small fw-bold text-uppercase">Mis Pedidos</h6>
              <h2 class="fw-bold text-primary mb-0 text-primary-custom">
                <span v-if="loading" class="placeholder col-4 d-inline-block"></span>
                <span v-else>{{ waiterStats.pedidos_activos }}</span>
              </h2>
            </div>
          </div>
        </div>
        <div class="col-6 col-lg-3">
          <div class="card shadow-sm h-100 p-2 border-bottom border-success border-4 card-kpi-custom">
            <div class="card-body text-center">
              <h6 class="text-secondary-custom small fw-bold text-uppercase">Ventas Turno</h6>
              <h2 class="fw-bold text-success mb-0">
                <span v-if="loading" class="placeholder col-6 d-inline-block"></span>
                <span v-else>Bs. {{ waiterStats.ventas_turno.toFixed(2) }}</span>
              </h2>
            </div>
          </div>
        </div>
        <div class="col-6 col-lg-3">
          <div class="card shadow-sm h-100 p-2 border-bottom border-warning border-4 card-kpi-custom">
            <div class="card-body text-center position-relative">
              <h6 class="text-secondary-custom small fw-bold text-uppercase">Entregar Pedido</h6>
              <h2 class="fw-bold text-warning mb-0">
                <span v-if="loading" class="placeholder col-4 d-inline-block"></span>
                <span v-else>{{ waiterStats.listos_entregar }}</span>
              </h2>
              <span v-if="waiterStats.listos_entregar > 0"
                class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger shadow">!</span>
            </div>
          </div>
        </div>
        <div class="col-6 col-lg-3">
          <div class="card shadow-sm h-100 p-2 border-bottom border-danger border-4 card-kpi-custom">
            <div class="card-body text-center">
              <h6 class="text-secondary-custom small fw-bold text-uppercase">Mesas Libres</h6>
              <h2 class="fw-bold text-danger mb-0">
                <span v-if="loading" class="placeholder col-4 d-inline-block"></span>
                <span v-else>{{ waiterStats.mesas_libres }}</span>
              </h2>
            </div>
          </div>
        </div>
      </div>

      <div class="row g-4">
        <!-- Mapa de Mesas Real -->
        <div class="col-12 col-xl-8">
          <div class="card shadow-sm p-4 h-100 bg-body-custom card-kpi-custom">
            <div class="d-flex justify-content-between align-items-center mb-4">
              <h5 class="fw-bold mb-0 text-primary-custom">Mapa de Mesas</h5>
              <div class="d-flex gap-2 align-items-center">
                <span class="badge bg-success small-dot">Libre</span>
                <span class="badge bg-danger small-dot">Ocupada</span>
                <span class="badge bg-primary small-dot">Reservada</span>
                <button @click="refreshData" class="btn btn-sm btn-outline-secondary ms-2 rounded-pill">
                  <i class="bi bi-arrow-clockwise"></i>
                </button>
              </div>
            </div>

            <div v-if="loading" class="text-center py-5">
              <div class="spinner-border text-korange"></div>
            </div>

            <div v-else class="row row-cols-2 row-cols-sm-3 row-cols-md-4 g-4">
              <div v-for="mesa in mesas" :key="mesa.id" class="col">
                <div :class="['mesa-card shadow-sm', mesa.estado]" @click="abrirMesa(mesa)">
                  <div class="mesa-header">
                    <span class="fw-bold">{{ mesa.nombre || `Mesa ${mesa.numero}` }}</span>
                    <i v-if="mesa.pedido_listo" class="bi bi-bell-fill text-korange pulse"></i>
                  </div>
                  <div class="mesa-body text-primary-custom">
                    <i class="bi bi-people-fill me-1"></i> {{ mesa.capacidad }}
                  </div>
                  <div class="mesa-footer">
                    {{ mesa.estado.toUpperCase() }}
                  </div>
                </div>
              </div>
              <div v-if="!mesas.length" class="col-12 text-center text-secondary-custom py-3">
                Sin mesas configuradas
              </div>
            </div>
          </div>
        </div>

        <!-- Info lateral -->
        <div class="col-12 col-xl-4">
          <div class="card shadow-sm p-4 h-100 bg-body-custom card-kpi-custom">
            <h5 class="fw-bold mb-4 text-primary-custom"><i class="bi bi-info-circle me-2"></i>Resumen del Turno</h5>
            <div class="list-group list-group-flush">
              <div class="list-group-item px-0 py-3 bg-transparent border-color">
                <div class="d-flex justify-content-between align-items-center">
                  <span class="text-secondary-custom small fw-bold">Total mesas</span>
                  <span class="badge bg-primary-subtle text-primary rounded-pill px-3">{{ mesas.length }}</span>
                </div>
              </div>
              <div class="list-group-item px-0 py-3 bg-transparent border-color">
                <div class="d-flex justify-content-between align-items-center">
                  <span class="text-secondary-custom small fw-bold">Ocupadas</span>
                  <span class="badge bg-danger-subtle text-danger rounded-pill px-3">
                    {{ mesas.filter(m => m.estado === 'ocupada').length }}
                  </span>
                </div>
              </div>
              <div class="list-group-item px-0 py-3 bg-transparent border-color">
                <div class="d-flex justify-content-between align-items-center">
                  <span class="text-secondary-custom small fw-bold">Reservadas</span>
                  <span class="badge bg-warning-subtle text-warning rounded-pill px-3">
                    {{ mesas.filter(m => m.estado === 'reservada').length }}
                  </span>
                </div>
              </div>
              <div class="list-group-item px-0 py-3 bg-transparent border-color">
                <div class="d-flex justify-content-between align-items-center">
                  <span class="text-secondary-custom small fw-bold">Pedidos listos para entregar</span>
                  <span class="badge rounded-pill px-3" :class="waiterStats.listos_entregar > 0 ? 'bg-success text-white' : 'bg-secondary-subtle text-secondary'">
                    {{ waiterStats.listos_entregar }}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { useRouter } from 'vue-router';
import Sidebar from '../../components/Sidebar.vue';
import { useAuth } from '../../core/composables/useAuth';
import { useMeseroData } from './composables/useMeseroSocket';
import type { WaiterTable } from './dashboard.api';

const auth     = useAuth();
const router   = useRouter();
const userName = computed(() => auth.user.value?.nombre || 'Mesero');
const currentTime = ref("");

const { tables: mesas, stats: waiterStats, loading, load } = useMeseroData();

const refreshData = () => load();

const abrirMesa = (mesa: WaiterTable) => {
  if (mesa.estado === 'ocupada') {
    router.push('/pos');
  }
};

let clockTimer: ReturnType<typeof setInterval> | null = null;
let pollTimer:  ReturnType<typeof setInterval> | null = null;

onMounted(() => {
  load();
  pollTimer  = setInterval(load, 20000);
  clockTimer = setInterval(() => {
    currentTime.value = new Date().toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit', second: '2-digit' });
  }, 1000);
});

onUnmounted(() => {
  if (pollTimer)  clearInterval(pollTimer);
  if (clockTimer) clearInterval(clockTimer);
});
</script>

<style scoped>
.waiter-wrapper { background-color: var(--bg-body); min-height: 100vh; width: 100%; }

@media (min-width: 768px) {
  .main-content { margin-left: 260px; width: calc(100% - 260px); }
}

.text-korange { color: var(--KOrange) !important; }
.text-primary-custom { color: var(--text-main) !important; }
.text-secondary-custom { color: var(--text-muted) !important; }
.bg-surface-custom { background-color: var(--bg-surface); }
.bg-body-custom { background-color: var(--bg-body); }
.border-color { border-color: var(--border-color) !important; }

.card-kpi-custom {
  background-color: var(--bg-body);
  border: 1px solid var(--border-color) !important;
}

.mesa-card {
  background: var(--bg-body);
  border-radius: 16px;
  padding: 15px;
  text-align: center;
  cursor: pointer;
  transition: all var(--transition-speed) cubic-bezier(0.4, 0, 0.2, 1);
  border: 2px solid var(--border-color);
}
.mesa-card:hover { transform: translateY(-5px); border-color: var(--KOrange); box-shadow: 0 10px 20px rgba(0,0,0,.1) !important; }
.libre    { border-color: #28a745; color: #28a745; }
.ocupada  { border-color: #dc3545; color: #dc3545; }
.reservada { border-color: #007bff; color: #007bff; }
.mesa-header { display: flex; justify-content: space-between; font-size: 1rem; margin-bottom: 5px; }
.mesa-body   { font-size: 1.5rem; margin: 10px 0; }
.mesa-footer { font-size: 0.7rem; font-weight: bold; letter-spacing: 1px; }

.pulse { animation: pulse-orange 2s infinite; }
@keyframes pulse-orange {
  0%, 100% { transform: scale(0.95); opacity: 1; }
  50%       { transform: scale(1.3);  opacity: 0.7; }
}

.small-dot::before { content: "•"; margin-right: 5px; font-size: 1.2rem; }
</style>