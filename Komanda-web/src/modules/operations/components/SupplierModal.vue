<template>
  <div class="modal fade" id="supplierModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content border-0 shadow-lg" style="background-color: var(--bg-surface);">
        <div class="modal-header border-0 pb-0 px-4 pt-4">
          <div>
            <h5 class="modal-title fw-bold text-main mb-0">
              {{ isEditing ? 'Editar Proveedor' : 'Nuevo Proveedor' }}
            </h5>
            <p class="text-secondary-custom small mb-0 mt-1">
              {{ isEditing ? 'Actualiza los datos del proveedor seleccionado' : 'Registra un nuevo proveedor para el restaurante' }}
            </p>
          </div>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"
            style="filter: var(--bs-btn-close-white-filter, none);"></button>
        </div>
        <div class="modal-body px-4 py-3">
          <form @submit.prevent="handleSubmit" id="supplierForm">
            <div class="row g-3">
              <div class="col-md-6">
                <label class="form-label text-secondary-custom fw-semibold small text-uppercase letter-spacing">
                  Identificación (RIF/CI) <span class="text-korange">*</span>
                </label>
                <input v-model="form.identificacion" type="text" class="form-control" required
                  placeholder="J-12345678-9" maxlength="30">
              </div>
              <div class="col-md-6">
                <label class="form-label text-secondary-custom fw-semibold small text-uppercase">
                  Razón Social o Nombre <span class="text-korange">*</span>
                </label>
                <input v-model="form.nombre" type="text" class="form-control" required
                  placeholder="Empresa C.A." maxlength="100">
              </div>
              <div class="col-md-6">
                <label class="form-label text-secondary-custom fw-semibold small text-uppercase">Teléfono</label>
                <input v-model="form.telefono" type="text" class="form-control" placeholder="0414-1234567">
              </div>
              <div class="col-md-6">
                <label class="form-label text-secondary-custom fw-semibold small text-uppercase">Correo Electrónico</label>
                <input v-model="form.email" type="email" class="form-control" placeholder="ventas@empresa.com">
              </div>
              <div class="col-12">
                <label class="form-label text-secondary-custom fw-semibold small text-uppercase">Dirección</label>
                <textarea v-model="form.direccion" class="form-control" rows="2"
                  placeholder="Calle 5, Local 3, Caracas"></textarea>
              </div>
              <div class="col-md-6">
                <label class="form-label text-secondary-custom fw-semibold small text-uppercase">Banco</label>
                <input v-model="form.banco_nombre" type="text" class="form-control" placeholder="Banesco, Mercantil...">
              </div>
              <div class="col-md-6">
                <label class="form-label text-secondary-custom fw-semibold small text-uppercase">Nro. de Cuenta</label>
                <input v-model="form.banco_cuenta_numero" type="text" class="form-control" placeholder="0134-XXXX-XXXX-XXXX">
              </div>
              <div class="col-12">
                <label class="form-label text-secondary-custom fw-semibold small text-uppercase">Observaciones</label>
                <textarea v-model="form.observaciones" class="form-control" rows="2"
                  placeholder="Notas adicionales sobre este proveedor..."></textarea>
              </div>
              <div v-if="isEditing" class="col-12">
                <div class="form-check form-switch">
                  <input class="form-check-input" type="checkbox" id="proveedorActivo" v-model="form.activo" role="switch">
                  <label class="form-check-label text-main" for="proveedorActivo">
                    Proveedor Activo
                  </label>
                </div>
              </div>
            </div>
          </form>
        </div>
        <div class="modal-footer border-0 px-4 pb-4 pt-2 gap-2">
          <button type="button" class="btn btn-secondary"
            data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" form="supplierForm"
            class="btn btn-korange d-flex align-items-center gap-2"
            :disabled="loading">
            <span v-if="loading" class="spinner-border spinner-border-sm"></span>
            <Save v-else :size="16" />
            {{ isEditing ? 'Guardar Cambios' : 'Registrar Proveedor' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';
import { Save } from 'lucide-vue-next';

const props = defineProps({
  supplier: { type: Object as () => any | null, default: null },
  loading: { type: Boolean, default: false }
});
const emit = defineEmits(['save']);

const isEditing = ref(false);
const getBlank = () => ({
  identificacion: '', nombre: '', telefono: '', email: '',
  direccion: '', banco_nombre: '', banco_cuenta_numero: '', observaciones: '', activo: true
});
const form = ref(getBlank());

watch(() => props.supplier, (val) => {
  if (val) { isEditing.value = true; form.value = { ...val }; }
  else { isEditing.value = false; form.value = getBlank(); }
}, { immediate: true });

const handleSubmit = () => emit('save', { ...form.value });
</script>
