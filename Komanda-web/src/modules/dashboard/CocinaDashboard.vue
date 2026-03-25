<template>
  <div class="d-flex w-100">
    <Sidebar role="cocina" :userName="auth.user.value?.nombre" />
    <div class="kitchen-wrapper p-4 main-content">
      <header class="row mb-4 align-items-center">
        <div class="col-12 col-md-6">
          <h2 class="fw-bold mb-1 text-primary-custom">Monitor de <span class="text-korange">Cocina</span> (KDS)</h2>
          <p class="text-secondary-custom small">Turno Actual: <strong>Mañana</strong> | Responsable: {{ auth.user.value?.nombre }}</p>
        </div>
        <div class="col-12 col-md-6 text-md-end text-primary-custom">
          <h2>{{ currentTime }}</h2>
        </div>
      </header>

      <div class="row g-4">
        <!-- Pendientes -->
        <div class="col-12 col-xl-4">
          <div class="card h-100 shadow-sm border-color bg-surface">
            <div class="card-header bg-danger text-white py-3">
              <h5 class="mb-0 fw-bold"><i class="bi bi-clock-history me-2"></i>Pendientes (2)</h5>
            </div>
            <div class="card-body bg-body p-2 custom-scrollbar" style="max-height: 70vh; overflow-y: auto;">
              <div class="kds-ticket border-danger mb-3 shadow-sm rounded">
                <div class="ticket-header bg-danger-subtle text-danger p-2 pb-1 d-flex justify-content-between align-items-center">
                  <h6 class="fw-bold mb-0">Mesa 4 | PED-001</h6>
                  <span class="small fw-bold">12 min</span>
                </div>
                <div class="ticket-body p-3 bg-surface text-main">
                  <ul class="list-unstyled mb-0 font-monospace fs-5">
                    <li class="border-bottom border-color py-2 d-flex justify-content-between">
                      <span>2x Hamburguesa Komanda</span>
                    </li>
                    <li class="border-bottom border-color py-2 d-flex justify-content-between">
                      <span class="text-danger">1x Alitas BBQ (Sin salsa picante)</span>
                    </li>
                  </ul>
                </div>
                <div class="ticket-footer p-2 bg-surface text-end border-top border-color">
                  <button class="btn btn-warning fw-bold w-100 rounded-pill">PREPARAR 👨‍🍳</button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- En Preparación -->
        <div class="col-12 col-xl-4">
          <div class="card h-100 shadow-sm border-color bg-surface">
            <div class="card-header bg-warning text-dark py-3">
              <h5 class="mb-0 fw-bold"><i class="bi bi-fire me-2"></i>Preparando (1)</h5>
            </div>
            <div class="card-body bg-body p-2 custom-scrollbar" style="max-height: 70vh; overflow-y: auto;">
              <div class="kds-ticket border-warning mb-3 shadow-sm rounded">
                <div class="ticket-header bg-warning-subtle text-dark p-2 pb-1 d-flex justify-content-between align-items-center">
                  <h6 class="fw-bold mb-0">Mesa 2 | PED-002</h6>
                  <span class="small fw-bold">5 min</span>
                </div>
                <div class="ticket-body p-3 bg-surface text-main">
                  <ul class="list-unstyled mb-0 font-monospace fs-5">
                    <li class="border-bottom border-color py-2 d-flex justify-content-between">
                      <span>1x Pasta Alfredo</span>
                    </li>
                  </ul>
                </div>
                <div class="ticket-footer p-2 bg-surface text-end border-top border-color">
                  <button class="btn btn-success fw-bold w-100 rounded-pill text-white">LISTO ✅</button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Listos -->
        <div class="col-12 col-xl-4">
          <div class="card h-100 shadow-sm border-color bg-surface">
            <div class="card-header bg-success text-white py-3">
              <h5 class="mb-0 fw-bold"><i class="bi bi-check-circle me-2"></i>Listos para Entregar</h5>
            </div>
            <div class="card-body bg-body p-2 custom-scrollbar" style="max-height: 70vh; overflow-y: auto;">
              <div class="kds-ticket border-success mb-3 shadow-sm rounded opacity-75">
                <div class="ticket-header bg-success-subtle text-success p-2 pb-1 d-flex justify-content-between align-items-center">
                  <h6 class="fw-bold mb-0">Mesa 7 | PED-003</h6>
                  <span class="small fw-bold">Esperando Mesero...</span>
                </div>
                <div class="ticket-body p-3 bg-surface text-main">
                  <ul class="list-unstyled mb-0 font-monospace fs-6">
                    <li class="border-bottom border-color py-1">2x Limonada Natural</li>
                    <li class="border-bottom border-color py-1">1x Flan Napolitano</li>
                  </ul>
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
import { ref, onMounted } from 'vue'
import Sidebar from '../../components/Sidebar.vue'
import { useAuth } from '../../core/composables/useAuth'

const auth = useAuth()
const currentTime = ref("")

onMounted(() => {
  setInterval(() => {
    currentTime.value = new Date().toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit', second: '2-digit' })
  }, 1000)
})
</script>

<style scoped>
.kitchen-wrapper { background-color: var(--bg-body); min-height: 100vh; width: 100%; }
@media (min-width: 768px) { .main-content { margin-left: 260px; width: calc(100% - 260px); } }
.text-korange { color: var(--KOrange) !important; }
.bg-surface { background-color: var(--bg-surface) !important; }
.bg-body { background-color: var(--bg-body) !important; }
.border-color { border-color: var(--border-color) !important; }
.text-primary-custom { color: var(--text-main) !important; }
.text-secondary-custom { color: var(--text-muted) !important; }
.text-main { color: var(--text-main) !important; }

.kds-ticket { border-top: 5px solid; overflow: hidden; }
.custom-scrollbar::-webkit-scrollbar { width: 6px; }
.custom-scrollbar::-webkit-scrollbar-track { background: var(--bg-body); }
.custom-scrollbar::-webkit-scrollbar-thumb { background: var(--border-color); border-radius: 4px; }
</style>
