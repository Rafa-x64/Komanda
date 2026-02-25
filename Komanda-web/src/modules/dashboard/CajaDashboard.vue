<template>
  <div class="d-flex w-100">
    <Sidebar role="cajero" :userName="userName" />
    <div class="finance-container p-4 main-content">
    <header class="row mb-4 align-items-center">
      <div class="col-12 col-md-6">
        <h2 class="fw-bold mb-1">Control de <span class="text-korange">Caja y Finanzas</span></h2>
        <p class="text-secondary small">Turno Actual: <strong>Mañana</strong> | Responsable: {{ userName }}</p>
      </div>
      <div class="col-12 col-md-6 text-md-end d-flex gap-2 justify-content-md-end">
        <button @click="registrarEgreso" class="btn btn-outline-dark rounded-pill px-3">
          <i class="bi bi-dash-circle me-2"></i>Egreso Rápido
        </button>
        <button @click="toggleCaja" :class="['btn rounded-pill px-4 shadow-sm', cajaAbierta ? 'btn-danger' : 'btn-success']">
          <i :class="['bi me-2', cajaAbierta ? 'bi-lock-fill' : 'bi-unlock-fill']"></i>
          {{ cajaAbierta ? 'Cerrar Caja' : 'Abrir Caja' }}
        </button>
      </div>
    </header>

    <div class="row g-4 mb-5">
      <div class="col-12 col-md-4">
        <div class="card kpi-finance border-0 shadow-sm border-start border-korange border-4">
          <div class="card-body">
            <h6 class="text-secondary small fw-bold text-uppercase">Estado de Caja (Teórico)</h6>
            <h2 class="fw-bold mb-0 text-korange">${{ montoCaja.toLocaleString() }}</h2>
            <small class="text-muted">Efectivo + Tarjetas + Digital</small>
          </div>
        </div>
      </div>
      <div class="col-12 col-md-4">
        <div class="card kpi-finance border-0 shadow-sm">
          <div class="card-body">
            <h6 class="text-secondary small fw-bold text-uppercase">Ventas del Turno</h6>
            <h2 class="fw-bold mb-0">${{ ventasTurno.toLocaleString() }}</h2>
            <small class="text-success fw-bold"><i class="bi bi-graph-up"></i> +15% vs ayer</small>
          </div>
        </div>
      </div>
      <div class="col-12 col-md-4">
        <div class="card kpi-finance border-0 shadow-sm">
          <div class="card-body">
            <h6 class="text-secondary small fw-bold text-uppercase">Facturas Emitidas</h6>
            <h2 class="fw-bold mb-0">{{ numFacturas }}</h2>
            <small class="text-muted">Tickets de venta legal</small>
          </div>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col-12">
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
          <div class="card-header bg-white py-3 border-bottom border-color">
            <h5 class="fw-bold mb-0">
              <i class="bi bi-receipt-cutoff me-2 text-korange"></i>
              Cuentas por Cobrar (Pendientes)
            </h5>
          </div>
          <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
              <thead class="bg-surface">
                <tr>
                  <th class="ps-4">Mesa</th>
                  <th>Mesero</th>
                  <th>Total Orden</th>
                  <th>Tiempo de Espera</th>
                  <th class="text-end pe-4">Acción</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="cuenta in cuentasPendientes" :key="cuenta.id">
                  <td class="ps-4"><span class="badge bg-dark fs-6">Mesa {{ cuenta.mesa }}</span></td>
                  <td class="fw-bold">{{ cuenta.mesero }}</td>
                  <td class="fw-bold text-korange fs-5">${{ cuenta.total }}</td>
                  <td>
                    <span class="text-secondary"><i class="bi bi-clock me-1"></i>{{ cuenta.espera }} min</span>
                  </td>
                  <td class="text-end pe-4">
                    <button class="btn btn-korange px-4 fw-bold">COBRAR</button>
                  </td>
                </tr>
                <tr v-if="cuentasPendientes.length === 0">
                  <td colspan="5" class="text-center py-5 text-secondary italic">
                    No hay cuentas solicitadas en este momento.
                  </td>
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
import { ref } from 'vue';
import Sidebar from '../../components/Sidebar.vue';

const userName = "Luis Landaeta";
const cajaAbierta = ref(true);
const montoCaja = ref(2450.75);
const ventasTurno = ref(1820.00);
const numFacturas = ref(42);

const cuentasPendientes = ref([
  { id: 1, mesa: "04", mesero: "Carlos R.", total: 45.50, espera: 5 },
  { id: 2, mesa: "12", mesero: "Ana M.", total: 120.00, espera: 2 },
  { id: 3, mesa: "01", mesero: "Carlos R.", total: 22.15, espera: 10 }
]);

const toggleCaja = () => {
  if(confirm(`¿Estás seguro de que deseas ${cajaAbierta.value ? 'CERRAR' : 'ABRIR'} la caja?`)) {
    cajaAbierta.value = !cajaAbierta.value;
  }
};

const registrarEgreso = () => {
  const monto = prompt("Monto del egreso:");
  const motivo = prompt("Motivo del egreso:");
  if(monto && motivo) alert(`Registrado: $${monto} por ${motivo}`);
};
</script>

<style scoped>
.finance-container {
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

.bg-surface { background-color: var(--bg-surface) !important; }
.border-color { border-color: var(--border-color) !important; }

.kpi-finance {
  background-color: var(--bg-body);
  border: 1px solid var(--border-color);
  border-radius: 1rem;
  transition: transform var(--transition-speed);
}

.kpi-finance:hover {
  transform: translateY(-5px);
}

.table thead th {
  border-bottom: none;
  font-size: 0.8rem;
  text-transform: uppercase;
  color: var(--text-secondary);
  padding-top: 15px;
  padding-bottom: 15px;
}

.btn-korange {
  background-color: var(--KOrange);
  color: white;
  border: none;
  transition: all var(--transition-speed);
}
.btn-korange:hover {
  background-color: var(--KOrange-hover);
  transform: translateY(-2px);
}
</style>