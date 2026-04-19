<template>
  <div class="modal fade" id="tableModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content border-0 shadow-lg" style="background-color: var(--bg-surface);">
        <div class="modal-header border-0 pb-0 px-4 pt-4">
          <div class="d-flex align-items-center gap-3">
            <div class="rounded-3 p-2 d-flex" style="background: rgba(253,126,20,0.12);">
              <LayoutGrid :size="22" class="text-korange" />
            </div>
            <div>
              <h5 class="modal-title fw-bold text-main mb-0">{{ isEditing ? 'Editar Mesa' : 'Nueva Mesa' }}</h5>
              <p class="text-secondary-custom small mb-0 mt-1">Configura las propiedades de la mesa</p>
            </div>
          </div>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" :disabled="loading"></button>
        </div>

        <div class="modal-body px-4 py-3">
          <form @submit.prevent="handleSubmit" id="tableForm">
            <div class="row g-3">
              <div class="col-md-6">
                <label class="form-label text-secondary-custom fw-semibold small">Número de Mesa <span class="text-korange">*</span></label>
                <input v-model.number="form.numero" type="number" class="form-control bg-transparent border-color text-primary-custom" required min="1">
              </div>
              <div class="col-md-6">
                <label class="form-label text-secondary-custom fw-semibold small">Capacidad (Personas) <span class="text-korange">*</span></label>
                <input v-model.number="form.capacidad" type="number" class="form-control bg-transparent border-color text-primary-custom" required min="1">
              </div>
              <div class="col-md-12">
                <label class="form-label text-secondary-custom fw-semibold small">Nombre o Descripción <span class="text-secondary-custom">(Opcional)</span></label>
                <input v-model="form.nombre" type="text" class="form-control bg-transparent border-color text-primary-custom" placeholder="Ej: Terraza 1, Mesa VIP, etc.">
              </div>
              <div class="col-md-12" v-if="isEditing">
                <label class="form-label text-secondary-custom fw-semibold small">Estado Operativo</label>
                <select class="form-select bg-transparent border-color text-primary-custom" v-model="form.estado">
                  <option value="libre">Libre</option>
                  <option value="ocupada">Ocupada</option>
                  <option value="reservada">Reservada</option>
                  <option value="inactiva">Inactiva (Mantenimiento)</option>
                </select>
              </div>
            </div>
          </form>
        </div>

        <div class="modal-footer border-0 px-4 pb-4 pt-2 gap-2">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" :disabled="loading">Cancelar</button>
          <button type="submit" form="tableForm" class="btn btn-korange d-flex align-items-center gap-2" :disabled="loading">
            <span v-if="loading" class="spinner-border spinner-border-sm"></span>
            <Save v-else :size="16" />
            {{ isEditing ? 'Guardar Cambios' : 'Crear Mesa' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';
import { LayoutGrid, Save } from 'lucide-vue-next';

const props = defineProps({
  table: { type: Object as () => any, default: null },
  loading: { type: Boolean, default: false }
});

const emit = defineEmits(['save']);

const form = ref({
  numero: 1,
  nombre: '',
  capacidad: 4,
  estado: 'libre'
});

const isEditing = ref(false);

watch(() => props.table, (newVal) => {
  if (newVal && newVal.id) {
    isEditing.value = true;
    form.value = { ...newVal };
  } else {
    isEditing.value = false;
    form.value = {
      numero: 1,
      nombre: '',
      capacidad: 4,
      estado: 'libre'
    };
  }
}, { deep: true, immediate: true });

const handleSubmit = () => {
  emit('save', { ...form.value });
};

const resetForm = () => {
  isEditing.value = false;
  form.value = {
    numero: 1,
    nombre: '',
    capacidad: 4,
    estado: 'libre'
  };
};

defineExpose({ resetForm });
</script>

<style scoped>
.text-main { color: var(--text-primary); }
.border-color { border-color: var(--border-color) !important; }
</style>
