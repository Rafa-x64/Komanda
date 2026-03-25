<template>
  <div class="modal fade" id="employeeModal" tabindex="-1" aria-labelledby="employeeModalLabel" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content shadow-lg border-secondary" style="background-color: #1a1b1e; border-radius: 1rem; overflow: hidden;">
        <div class="modal-header border-bottom border-dark px-4 py-3" style="background-color: #212529;">
          <h4 class="modal-title text-white fw-bold d-flex align-items-center" id="employeeModalLabel">
            <UserPlus v-if="!isEdit" class="me-2" style="color: var(--KOrange);" :size="24" />
            <UserCog v-else class="me-2" style="color: var(--KOrange);" :size="24" />
            {{ isEdit ? 'Editar Empleado' : 'Nuevo Empleado' }}
          </h4>
          <button type="button" class="btn-close btn-close-white opacity-75" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body px-4 py-4" style="background-color: #1a1b1e;">
          <form @submit.prevent="submit" id="employeeForm" class="needs-validation">
            
            <div class="mb-4">
              <label class="form-label text-white fw-bold mb-1">Nombre Completo</label>
              <input v-model="form.nombre" type="text" class="form-control form-control-lg bg-dark text-white border-secondary shadow-sm" placeholder="Ej: Juan Perez" required />
            </div>
            
            <div class="mb-4">
              <label class="form-label text-white fw-bold mb-1">Correo Electrónico</label>
              <input v-model="form.email" type="email" class="form-control form-control-lg bg-dark text-white border-secondary shadow-sm" placeholder="Ej: juan@komanda.com" required />
            </div>
            
            <div class="mb-4">
              <label class="form-label text-white fw-bold mb-1">Nombre de Usuario</label>
              <input v-model="form.username" type="text" class="form-control form-control-lg bg-dark text-white border-secondary shadow-sm" placeholder="Ej: juan123" required autocomplete="username" />
            </div>
            
            <div class="mb-4">
              <label class="form-label text-white fw-bold mb-1">
                Contraseña
                <small class="text-white-50 ms-2 fw-normal" v-if="isEdit">(Dejar vacío para mantener actual)</small>
              </label>
              <input v-model="form.password" type="password" class="form-control form-control-lg bg-dark text-white border-secondary shadow-sm" placeholder="Mínimo 6 caracteres" :required="!isEdit" autocomplete="new-password" />
            </div>
            
            <div class="mb-4">
              <label class="form-label text-white fw-bold mb-1">Rol del empleado</label>
              <select v-model="form.rol_id" class="form-select form-select-lg bg-dark text-white border-secondary shadow-sm" required>
                <option :value="null" disabled>Selecciona un rol</option>
                <option v-for="r in roles" :key="r.id" :value="r.id" class="text-white">{{ r.nombre }}</option>
              </select>
            </div>

            <div class="form-check form-switch fs-5 mb-0 mt-2" v-if="isEdit">
              <input v-model="form.activo" class="form-check-input bg-dark border-secondary shadow-sm" type="checkbox" role="switch" id="activoCheck" />
              <label class="form-check-label text-white ms-2 fw-bold" for="activoCheck" style="font-size: 1.1rem; align-self: center;">Usuario Activo</label>
              <div class="text-white-50 small ms-2 fs-6">Permite al usuario acceder al sistema.</div>
            </div>
          </form>
        </div>
        <div class="modal-footer border-top border-dark px-4 py-3" style="background-color: #212529;">
          <button type="button" class="btn btn-outline-light rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" form="employeeForm" class="btn btn-korange rounded-pill px-4 shadow-sm fw-bold border-0 d-flex align-items-center">
            <CheckCircle :size="18" class="me-2" /> {{ isEdit ? 'Guardar Cambios' : 'Registrar Empleado' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { UserPlus, UserCog, CheckCircle } from 'lucide-vue-next'

const props = defineProps<{
  roles: any[]
  employeeToEdit: any | null
}>()

const emit = defineEmits(['save'])

const isEdit = ref(false)
const form = ref({
  nombre: '',
  email: '',
  username: '',
  password: '',
  rol_id: null as number | null,
  activo: true
})

watch(() => props.employeeToEdit, (emp) => {
  if (emp) {
    isEdit.value = true
    form.value = {
      nombre: emp.nombre,
      email: emp.email,
      username: emp.username,
      password: '',
      rol_id: emp.rol_id,
      activo: emp.activo
    }
  } else {
    isEdit.value = false
    form.value = { nombre: '', email: '', username: '', password: '', rol_id: null, activo: true }
  }
})

const submit = () => {
  const payload: any = { ...form.value }
  if (isEdit.value && !payload.password) {
    delete payload.password // No enviar contraseña si está vacía en edición
  }
  emit('save', payload)
}
</script>

<style scoped>
.bg-surface {
  background-color: var(--bg-surface);
}
.border-color {
  border-color: var(--border-color) !important;
}
.btn-korange {
  background-color: var(--KOrange);
  color: white;
  border: none;
}
.btn-korange:hover {
  background-color: var(--KOrange-hover);
}
</style>
