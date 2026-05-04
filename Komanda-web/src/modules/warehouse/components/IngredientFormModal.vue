<template>
  <div class="modal fade" :class="{ show: show }" :style="{ display: show ? 'block' : 'none' }" tabindex="-1" aria-hidden="true" style="background: rgba(0,0,0,0.5);">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content border-0 shadow-lg" style="background-color: var(--bg-surface);">
        <div class="modal-header border-0 pb-0 px-4 pt-4">
          <div class="d-flex align-items-center gap-3">
            <div class="rounded-3 p-2 d-flex" style="background: rgba(253,126,20,0.12);">
              <Package class="text-korange" :size="22" />
            </div>
            <div>
              <h5 class="modal-title fw-bold text-main mb-0">
                {{ isEdit ? 'Editar Ingrediente' : 'Nuevo Ingrediente' }}
              </h5>
              <p class="text-secondary-custom small mb-0 mt-1">Configura parámetros de stock y unidad de medida</p>
            </div>
          </div>
          <button type="button" class="btn-close" @click="$emit('close')" aria-label="Close"></button>
        </div>

        <div class="modal-body px-4 py-3">
          <form @submit.prevent="submitForm" id="ingredientForm">
            <div class="mb-3">
              <label class="form-label text-secondary-custom fw-semibold small">Nombre del Ingrediente <span class="text-korange">*</span></label>
              <input v-model="form.nombre" type="text" class="form-control" placeholder="Ej. Harina de Trigo" required :disabled="isEdit">
              <small v-if="isEdit" class="text-muted" style="font-size: 0.75rem;">El nombre no se puede modificar una vez creado.</small>
            </div>

            <div class="row mb-3">
              <div class="col-6">
                <label class="form-label text-secondary-custom fw-semibold small">Unidad de Medida <span class="text-korange">*</span></label>
                <UnitSelector v-model="form.unidad_id" :unidades="unidades" />
              </div>
              <div class="col-6">
                <label class="form-label text-secondary-custom fw-semibold small">Stock Mínimo (Alerta) <span class="text-korange">*</span></label>
                <input v-model.number="form.cantidad_minima" type="number" step="0.001" min="0" class="form-control" required placeholder="0.000">
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label text-secondary-custom fw-semibold small">Merma Teórica (%)</label>
              <div class="input-group">
                <input v-model.number="form.merma_teorica_porcentaje" type="number" step="0.1" min="0" max="100" class="form-control" placeholder="0">
                <span class="input-group-text">%</span>
              </div>
              <div class="form-text" style="font-size: 0.75rem;">Porcentaje estimado de pérdida natural (ej. descongelamiento).</div>
            </div>
          </form>
        </div>

        <div class="modal-footer border-0 px-4 pb-4 pt-2 gap-2">
          <button type="button" class="btn btn-secondary" @click="$emit('close')">Cancelar</button>
          <button type="submit" form="ingredientForm" class="btn btn-korange d-flex align-items-center gap-2" :disabled="loading">
            <span v-if="loading" class="spinner-border spinner-border-sm"></span>
            <Save v-else :size="16" />
            {{ isEdit ? 'Guardar Cambios' : 'Crear Ingrediente' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue';
import { Package, Save } from 'lucide-vue-next';
import UnitSelector from './UnitSelector.vue';

const props = defineProps<{
  show: boolean;
  ingrediente: any | null;
  unidades: any[];
  loading: boolean;
}>();

const emit = defineEmits(['close', 'save']);

const isEdit = computed(() => !!props.ingrediente);

const form = ref({
  nombre: '',
  unidad_id: '' as string | number,
  cantidad_minima: 0,
  merma_teorica_porcentaje: 0
});

watch(() => props.show, (newVal) => {
  if (newVal) {
    if (props.ingrediente) {
      form.value = {
        nombre: props.ingrediente.nombre,
        unidad_id: props.ingrediente.unidad_id,
        cantidad_minima: props.ingrediente.cantidad_minima || 0,
        merma_teorica_porcentaje: props.ingrediente.merma_teorica_porcentaje || 0
      };
    } else {
      form.value = {
        nombre: '',
        unidad_id: '',
        cantidad_minima: 0,
        merma_teorica_porcentaje: 0
      };
    }
  }
});

const submitForm = () => {
  emit('save', form.value);
};
</script>

<style scoped>
.text-korange { color: var(--KOrange) !important; }
.btn-korange {
  background-color: var(--KOrange);
  color: white;
  border: none;
}
.btn-korange:hover {
  background-color: #e65c00;
  color: white;
}
.bg-surface { background-color: #fff; }
</style>
