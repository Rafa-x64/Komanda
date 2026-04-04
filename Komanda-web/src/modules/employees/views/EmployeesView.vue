<template>
  <div class="d-flex w-100">
    <!-- Toast Notification -->
    <Transition name="toast-slide">
      <div v-if="toast" class="pos-toast" :class="`pos-toast--${toast.type}`">
        <CheckCircle v-if="toast.type === 'success'" :size="20" />
        <AlertCircle v-else :size="20" />
        <span>{{ toast.message }}</span>
      </div>
    </Transition>

    <Sidebar :role="auth.user.value?.role || 'admin'" :userName="auth.user.value?.nombre" />
    <div class="employees-wrapper p-4 main-content">
      <header class="row mb-4 align-items-center">
        <div class="col-12 col-md-6">
          <h2 class="fw-bold mb-1 text-primary-custom">Gestión de <span class="text-korange">Empleados</span></h2>
          <p class="text-secondary-custom small">Administra los usuarios y roles del restaurante</p>
        </div>
        <div class="col-12 col-md-6 text-md-end">
          <button @click="openCreateModal" class="btn btn-korange rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#employeeModal">
            <UserPlus :size="18" class="me-2" />Nuevo Empleado
          </button>
        </div>
      </header>

      <!-- Tabla de empleados -->
      <div class="card shadow rounded-4 overflow-hidden border-0" style="background-color: var(--bg-surface);">
        <div class="table-responsive">
          <table class="table table-custom table-hover-custom align-middle mb-0">
            <thead>
              <tr>
                <th class="ps-4 py-3">Nombre Completo</th>
                <th class="py-3">Usuario</th>
                <th class="py-3">Rol</th>
                <th class="py-3">Estado</th>
                <th class="text-end pe-4 py-3">Acciones</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="loading">
                <td colspan="5" class="text-center py-5 text-secondary-custom">Cargando empleados...</td>
              </tr>
              <tr v-else-if="employees.length === 0">
                <td colspan="5" class="text-center py-5 text-secondary-custom">No hay empleados registrados.</td>
              </tr>
              <tr v-else v-for="emp in employees" :key="emp.id">
                <td class="ps-4 py-3 fw-bold">
                  <div class="d-flex align-items-center">
                    <div class="avatar bg-korange text-white rounded-circle d-flex align-items-center justify-content-center me-3 shadow-sm" style="width: 40px; height: 40px; font-size: 1.2rem;">
                      {{ emp.nombre.charAt(0).toUpperCase() }}
                    </div>
                    <div>
                      <span class="text-primary-custom fw-bold fs-6">{{ emp.nombre }}</span>
                      <div class="small fw-normal text-secondary-custom">{{ emp.email }}</div>
                    </div>
                  </div>
                </td>
                <td class="text-secondary-custom py-3">@{{ emp.username }}</td>
                <td class="py-3"><span class="badge" style="background-color: rgba(255,107,0,0.15); color: var(--KOrange); padding: 0.5em 1em;">{{ emp.rol_nombre.toUpperCase() }}</span></td>
                <td class="py-3">
                  <span v-if="emp.activo" class="badge bg-success bg-opacity-25 text-success px-3 py-2 rounded-pill">Activo</span>
                  <span v-else class="badge bg-danger bg-opacity-25 text-danger px-3 py-2 rounded-pill">Inactivo</span>
                </td>
                <td class="text-end pe-4 py-3">
                  <button @click="openEditModal(emp)" class="btn btn-sm btn-primary rounded-circle me-2 d-inline-flex align-items-center justify-content-center" style="width: 35px; height: 35px;" data-bs-toggle="modal" data-bs-target="#employeeModal" title="Editar">
                    <Pencil :size="16" class="text-white" />
                  </button>
                  <button v-if="emp.activo && emp.id !== auth.user.value?.id" @click="confirmDelete(emp)" class="btn btn-sm btn-danger rounded-circle d-inline-flex align-items-center justify-content-center" style="width: 35px; height: 35px;" title="Desactivar">
                    <Trash2 :size="16" class="text-white" />
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Modal components -->
      <EmployeeFormModal :roles="roles" :employeeToEdit="selectedEmployee" @save="handleSave" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import Sidebar from '../../../components/Sidebar.vue'
import EmployeeFormModal from '../components/EmployeeFormModal.vue'
import { fetchEmployees, fetchRoles, createEmployee, updateEmployee, deleteEmployee } from '../employees.api'
import { useAuth } from '../../../core/composables/useAuth'
import { Pencil, Trash2, UserPlus, AlertCircle, CheckCircle } from 'lucide-vue-next'
// @ts-ignore
import { Modal } from 'bootstrap'

const auth = useAuth()
const loading = ref(true)
const employees = ref<any[]>([])
const roles = ref<any[]>([])
const selectedEmployee = ref<any | null>(null)
const toast = ref<{ type: 'success' | 'error'; message: string } | null>(null)

const showToast = (type: 'success' | 'error', message: string) => {
  toast.value = { type, message }
  setTimeout(() => { toast.value = null }, 3500)
}

const loadData = async () => {
  loading.value = true
  try {
    const [emps, rols] = await Promise.all([fetchEmployees(), fetchRoles()])
    employees.value = emps
    roles.value = rols
  } catch (error: any) {
    showToast('error', error.message)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadData()
})

const openCreateModal = () => {
  selectedEmployee.value = null
}

const openEditModal = (emp: any) => {
  selectedEmployee.value = { ...emp }
}

const handleSave = async (payload: any) => {
  try {
    if (selectedEmployee.value) {
      await updateEmployee(selectedEmployee.value.id, payload)
      closeModal()
      showToast('success', '¡Empleado actualizado de manera exitosa! 🎉')
      loadData()
    } else {
      await createEmployee(payload)
      closeModal()
      showToast('success', '¡Empleado registrado con éxito! 🎉')
      loadData()
    }
  } catch (error: any) {
    showToast('error', error.message)
  }
}

const confirmDelete = async (emp: any) => {
  if (confirm(`¿Estás seguro de que deseas desactivar al empleado "${emp.nombre}"?`)) {
    try {
      await deleteEmployee(emp.id)
      showToast('success', 'Empleado desactivado correctamente.')
      loadData()
    } catch (error: any) {
      showToast('error', error.message)
    }
  }
}

const closeModal = () => {
  const modalEl = document.getElementById('employeeModal')
  if (modalEl) {
    const modalInstance = Modal.getInstance(modalEl)
    if (modalInstance) {
      modalInstance.hide()
    } else {
      // Intento de fallback cerrando via data-bs-dismiss
      const closeBtn = document.querySelector('#employeeModal .btn-close') as HTMLElement
      if (closeBtn) closeBtn.click()
    }
  }
}
</script>

<style scoped>
/* ========== TOAST ========== */
.pos-toast {
  position: fixed;
  top: 1.5rem;
  left: 50%;
  transform: translateX(-50%);
  z-index: 9999;
  display: flex;
  align-items: center;
  gap: 0.6rem;
  padding: 0.85rem 1.5rem;
  border-radius: 0.75rem;
  font-weight: 600;
  font-size: 0.9rem;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
}

.pos-toast--success {
  background: #d4edda;
  color: #155724;
  border: 1px solid #c3e6cb;
}

.pos-toast--error {
  background: #f8d7da;
  color: #721c24;
  border: 1px solid #f5c6cb;
}

.toast-slide-enter-active,
.toast-slide-leave-active {
  transition: all 0.35s ease;
}

.toast-slide-enter-from,
.toast-slide-leave-to {
  opacity: 0;
  transform: translateX(-50%) translateY(-20px);
}
</style>

<style scoped>
.employees-wrapper {
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

.text-korange { color: var(--KOrange) !important; }
.btn-korange { background-color: var(--KOrange); color: white; border: none; }
.btn-korange:hover { background-color: var(--KOrange-hover); }
.text-primary-custom { color: var(--text-main) !important; }
.text-secondary-custom { color: var(--text-muted) !important; }
.border-color { border-color: var(--border-color) !important; }
.card-bg { background-color: var(--bg-body) !important; }
.bg-surface { background-color: var(--bg-surface) !important; border-bottom: 2px solid var(--border-color); }
.text-main { color: var(--text-main) !important; }
.header-color th { color: var(--text-muted) !important; font-size: 0.85rem; text-transform: uppercase; font-weight: bold; }
</style>
