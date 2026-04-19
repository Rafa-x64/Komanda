<template>
  <div class="d-flex w-100">
    <Sidebar :role="userRole" :userName="userName" />

    <main class="settings-wrapper p-3 p-md-4 main-content">
      <!-- Header -->
      <header class="mb-4">
        <h1 class="fw-bold mb-1 text-primary-custom">
          <i class="bi bi-gear-fill text-korange me-2"></i>
          Configuración
        </h1>
        <p class="text-secondary-custom mb-0 small">
          Gestiona tus datos personales y las reglas de negocio del sistema
        </p>
      </header>

      <!-- Layout con Pestañas -->
      <div class="card shadow-sm bg-surface-custom border border-color border-0 rounded-4 overflow-hidden">
        
        <!-- Tabs Nav -->
        <ul class="nav nav-tabs custom-tabs px-4 pt-3 border-bottom border-color" id="settingsTabs" role="tablist">
          <li class="nav-item" role="presentation">
            <button class="nav-link active fw-bold text-secondary-custom" id="profile-tab" data-bs-toggle="tab" data-bs-target="#profile-tab-pane" type="button" role="tab" aria-controls="profile-tab-pane" aria-selected="true">
              <i class="bi bi-person-badge me-2"></i> Mi Perfil
            </button>
          </li>
          <li class="nav-item" role="presentation" v-if="isAdmin">
            <button class="nav-link fw-bold text-secondary-custom" id="business-tab" data-bs-toggle="tab" data-bs-target="#business-tab-pane" type="button" role="tab" aria-controls="business-tab-pane" aria-selected="false">
              <i class="bi bi-shop me-2"></i> Datos del Negocio
            </button>
          </li>
          <li class="nav-item" role="presentation" v-if="isAdmin">
            <button class="nav-link fw-bold text-secondary-custom" id="rules-tab" data-bs-toggle="tab" data-bs-target="#rules-tab-pane" type="button" role="tab" aria-controls="rules-tab-pane" aria-selected="false">
              <i class="bi bi-sliders me-2"></i> Reglas Operativas
            </button>
          </li>
        </ul>

        <!-- Tabs Content -->
        <div class="tab-content p-4" id="settingsTabsContent">
          
          <!-- TAB: MI PERFIL -->
          <div class="tab-pane fade show active" id="profile-tab-pane" role="tabpanel" aria-labelledby="profile-tab" tabindex="0">
            <div class="row">
              <div class="col-12 col-md-4 text-center mb-4 mb-md-0 d-flex flex-column align-items-center">
                <div class="avatar-lg bg-primary text-white rounded-circle d-flex align-items-center justify-content-center fw-bold shadow-sm mb-3">
                  {{ (userName?.charAt(0) || 'U').toUpperCase() }}
                </div>
                <h5 class="fw-bold text-primary-custom mb-1">{{ userName }}</h5>
                <span class="badge bg-korange-subtle text-korange text-capitalize px-3 py-1">{{ userRole }}</span>
                <button class="btn btn-outline-secondary btn-sm mt-3 px-3 rounded-pill disabled" title="Función no habilitada en demostración">
                  Cambiar Avatar
                </button>
              </div>
              <div class="col-12 col-md-8">
                <h5 class="fw-bold mb-3 text-primary-custom border-bottom border-color pb-2">Datos Personales</h5>
                <form @submit.prevent="saveProfile">
                  <div class="row g-3">
                    <div class="col-md-6">
                      <label class="form-label small fw-bold text-secondary-custom">Nombre Completo</label>
                      <input type="text" class="form-control bg-transparent border-color text-primary-custom" v-model="profileForm.name" required>
                    </div>
                    <div class="col-md-6">
                      <label class="form-label small fw-bold text-secondary-custom">Correo Electrónico</label>
                      <input type="email" class="form-control bg-transparent border-color text-primary-custom" v-model="profileForm.email" required>
                    </div>
                    
                    <h5 class="fw-bold mt-4 mb-2 text-primary-custom border-bottom border-color pb-2 w-100">Seguridad</h5>
                    
                    <div class="col-md-6">
                      <label class="form-label small fw-bold text-secondary-custom">Nueva Contraseña</label>
                      <input type="password" class="form-control bg-transparent border-color text-primary-custom" v-model="profileForm.newPassword" placeholder="Dejar en blanco para no cambiar">
                    </div>
                    <div class="col-md-6">
                      <label class="form-label small fw-bold text-secondary-custom">Confirmar Contraseña</label>
                      <input type="password" class="form-control bg-transparent border-color text-primary-custom" v-model="profileForm.confirmPassword" placeholder="Repite la nueva contraseña">
                    </div>
                    
                    <div class="col-12 text-end mt-4">
                      <button type="submit" class="btn btn-korange px-4 py-2 rounded-pill shadow-sm" style="color: white; font-weight: bold;">
                        Guardar Cambios del Perfil
                      </button>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>

          <!-- TAB: NEGOCIO (Solo Admin) -->
          <div class="tab-pane fade" id="business-tab-pane" role="tabpanel" aria-labelledby="business-tab" tabindex="0" v-if="isAdmin">
            <h5 class="fw-bold mb-3 text-primary-custom border-bottom border-color pb-2">Configuración del Restaurante (Tenant)</h5>
            <div class="alert alert-info bg-info-subtle border-0 text-info-emphasis d-flex align-items-center">
              <i class="bi bi-info-circle-fill me-2 fs-5"></i>
              Estos datos afectarán la facturación y la visibilidad dentro de los módulos.
            </div>

             <form @submit.prevent="saveBusiness">
              <div class="row g-3 mt-1">
                <div class="col-md-6">
                  <label class="form-label small fw-bold text-secondary-custom">Nombre del Restaurante</label>
                  <input type="text" class="form-control bg-transparent border-color text-primary-custom" v-model="businessForm.name" required>
                </div>
                <div class="col-md-6">
                  <label class="form-label small fw-bold text-secondary-custom">Identificación Fiscal (RIF/NIT)</label>
                  <input type="text" class="form-control bg-transparent border-color text-primary-custom" v-model="businessForm.taxId">
                </div>
                <div class="col-md-6">
                  <label class="form-label small fw-bold text-secondary-custom">Correo del Negocio</label>
                  <input type="email" class="form-control bg-transparent border-color text-primary-custom" v-model="businessForm.email">
                </div>
                <div class="col-md-6">
                  <label class="form-label small fw-bold text-secondary-custom">Teléfono de Contacto</label>
                  <input type="text" class="form-control bg-transparent border-color text-primary-custom" v-model="businessForm.phone">
                </div>
                <div class="col-md-6">
                  <label class="form-label small fw-bold text-secondary-custom">Dirección Principal</label>
                  <input type="text" class="form-control bg-transparent border-color text-primary-custom" v-model="businessForm.address">
                </div>
                <div class="col-md-6">
                  <label class="form-label small fw-bold text-secondary-custom">Impuesto Base (%)</label>
                  <input type="number" step="0.01" class="form-control bg-transparent border-color text-primary-custom" v-model="businessForm.impuesto_porcentaje">
                </div>
                <div class="col-12 text-end mt-4">
                  <button type="submit" class="btn btn-korange px-4 py-2 rounded-pill shadow-sm" style="color: white; font-weight: bold;">
                    Actualizar Datos del Negocio
                  </button>
                </div>
              </div>
             </form>
          </div>

          <!-- TAB: REGLAS OPERATIVAS (Solo Admin) -->
          <div class="tab-pane fade" id="rules-tab-pane" role="tabpanel" aria-labelledby="rules-tab" tabindex="0" v-if="isAdmin">
            <h5 class="fw-bold mb-3 text-primary-custom border-bottom border-color pb-2">Reglas de Sistema Maestro</h5>
            
            <div class="row g-4 mt-1">
              <!-- Moneda base -->
              <div class="col-md-6">
                <div class="card h-100 bg-transparent border-color shadow-none">
                  <div class="card-body">
                    <h6 class="fw-bold text-primary-custom"><i class="bi bi-cash-coin text-success me-2"></i> Moneda Base y Facturación</h6>
                    <p class="small text-secondary-custom mb-3">La moneda principal con la que el sistema calcula el CPP, utilidades y balance general.</p>
                    <select class="form-select bg-surface border-color text-primary-custom" v-model="rulesForm.currency">
                      <option value="VES">Bolívares (VES)</option>
                      <option value="USD">Dólares (USD)</option>
                    </select>
                  </div>
                </div>
              </div>

              <!-- Alerta Stock Crítico -->
              <div class="col-md-6">
                <div class="card h-100 bg-transparent border-color shadow-none">
                  <div class="card-body">
                    <h6 class="fw-bold text-primary-custom"><i class="bi bi-exclamation-triangle-fill text-warning me-2"></i> Umbral Global de Stock Crítico</h6>
                    <p class="small text-secondary-custom mb-3">Establecer si quieres notificaciones en el Dashboard cuando el stock cae bajo su punto de reorden.</p>
                    <div class="form-check form-switch mt-2">
                      <input class="form-check-input" type="checkbox" role="switch" id="stockAlertSwitch" v-model="rulesForm.enableStockAlerts">
                      <label class="form-check-label text-primary-custom small" for="stockAlertSwitch">Activar Alertas de Inventario Crítico</label>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Gastos Fijos (Solo Visualizacion, no editables según reglas maestras) -->
              <div class="col-12 mt-4">
                 <h6 class="fw-bold text-primary-custom"><i class="bi bi-lock-fill text-danger me-2"></i> Estructura de Gastos Fijos (OpEx)</h6>
                  <div class="alert alert-warning border border-warning bg-warning-subtle text-dark mb-0 py-2">
                    <small>Según las normativas del sistema SaaS y estándares de costos, el módulo contabilizará por defecto <strong>exclusivamente</strong> 5 conceptos (Agua, Gas, Electricidad, Internet, Alquiler). Otras métricas requieren autorización de SuperAdmin.</small>
                  </div>
              </div>

              <div class="col-12 text-end mt-4">
                 <button class="btn btn-korange px-4 py-2 rounded-pill shadow-sm" style="color: white; font-weight: bold;" @click="saveRules">
                   Guardar Políticas
                 </button>
              </div>

            </div>
          </div>

        </div>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import Sidebar from '../../../components/Sidebar.vue'
import { useAuth } from '../../../core/composables/useAuth'

const auth = useAuth()
const user = auth.user.value
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000/api/v1'

const userName = computed(() => profileForm.value.name || user?.nombre || 'Administrador')
const userRole = computed(() => user?.role || 'admin')
const isAdmin = computed(() => userRole.value === 'admin')

// Formularios locales (States)
const profileForm = ref({
  name: user?.nombre || '',
  email: user?.correo || '',
  newPassword: '',
  confirmPassword: ''
})

const businessForm = ref({
  name: '',
  taxId: '',
  phone: '',
  address: '',
  email: '',
  moneda: 'USD',
  impuesto_porcentaje: 0
})

const rulesForm = ref({
  currency: 'VES',
  enableStockAlerts: true
})

onMounted(async () => {
  if (isAdmin.value) {
    try {
      const token = localStorage.getItem('auth_token');
      const res = await fetch(`${API_URL}/settings/restaurant`, {
        headers: { 'Authorization': `Bearer ${token}` }
      });
      if (res.ok) {
        const body = await res.json();
        const data = body.data;
        businessForm.value.name = data.nombre || '';
        businessForm.value.phone = data.telefono || '';
        businessForm.value.address = data.direccion || '';
        businessForm.value.email = data.email || '';
        businessForm.value.moneda = data.moneda || 'USD';
        businessForm.value.impuesto_porcentaje = data.impuesto_porcentaje || 0;
        rulesForm.value.currency = data.moneda || 'VES'; // Synchronize visual map
      }
    } catch (e) {
      console.error(e);
    }
  }
})

// Acciones Reales
const saveProfile = async () => {
  if (profileForm.value.newPassword && profileForm.value.newPassword !== profileForm.value.confirmPassword) {
    alert("Las contraseñas no coinciden");
    return;
  }
  
  try {
    const token = localStorage.getItem('auth_token');
    const res = await fetch(`${API_URL}/settings/profile`, {
      method: 'PUT',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        nombre: profileForm.value.name,
        email: profileForm.value.email,
        password: profileForm.value.newPassword || ''
      })
    });
    
    if (res.ok) {
      alert("Los datos personales se han actualizado correctamente.");
      profileForm.value.newPassword = '';
      profileForm.value.confirmPassword = '';
    } else {
      const err = await res.json();
      alert("Error actualizando perfil: " + (err.message || 'Error desconocido'));
    }
  } catch (e) {
    console.error(e);
    alert("Hubo un problema de conexión.");
  }
}

const saveBusiness = async () => {
  try {
    const token = localStorage.getItem('auth_token');
    const res = await fetch(`${API_URL}/settings/restaurant`, {
      method: 'PUT',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        nombre: businessForm.value.name,
        direccion: businessForm.value.address,
        telefono: businessForm.value.phone,
        email: businessForm.value.email, // using tax id field input basically mapped back?
        moneda: businessForm.value.moneda,
        impuesto_porcentaje: Number(businessForm.value.impuesto_porcentaje) || 0
      })
    });
    
    if (res.ok) {
      alert("La configuración del restaurante se ha salvado en la red multi-tenant.");
    } else {
      const err = await res.json();
      alert("Error guardando negocio: " + (err.message || 'Revise los campos'));
    }
  } catch (e) {
    console.error(e);
    alert("Hubo un problema de red.");
  }
}

const saveRules = async () => {
  try {
    // Only update the monetary basis and save to the same endpoint
    businessForm.value.moneda = rulesForm.value.currency;
    await saveBusiness();
    alert("Las reglas operativas han sido aplicadas.");
  } catch (e) {
    console.error(e)
  }
}
</script>

<style scoped>
.settings-wrapper {
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

/* Custom Surface elements */
.bg-surface-custom {
  background-color: var(--bg-surface) !important;
}

.border-color {
  border-color: var(--border-color) !important;
}

/* Tabs UI overrides */
.custom-tabs {
  border-bottom: 1px solid var(--border-color);
}
.custom-tabs .nav-link {
  color: var(--text-muted);
  border: none;
  border-bottom: 3px solid transparent;
  padding: 0.8rem 1.5rem;
  transition: all 0.2s ease;
  background: transparent;
}
.custom-tabs .nav-link:hover {
  color: var(--KOrange);
  border-color: transparent;
}
.custom-tabs .nav-link.active {
  color: var(--KOrange) !important;
  background-color: transparent;
  border-color: var(--KOrange);
}

.avatar-lg {
  width: 90px;
  height: 90px;
  font-size: 2.5rem;
}

.bg-korange-subtle {
  background-color: rgba(253, 126, 20, 0.15) !important;
}

.text-korange {
  color: var(--KOrange) !important;
}

.btn-korange {
  background-color: var(--KOrange);
  border: none;
}
.btn-korange:hover {
  background-color: #e06d0e;
}
</style>
