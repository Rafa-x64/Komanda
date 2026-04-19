<script setup lang="ts">
import { ref, watch, onMounted, onUnmounted } from 'vue';
import { Save, X } from 'lucide-vue-next';

const props = defineProps({
  show: Boolean,
  ingrediente: Object
});

const emit = defineEmits(['close', 'save']);

const formData = ref({
  nombre: '',
  cantidad_minima: 5
});

watch(() => props.show, (newVal) => {
  if (newVal && props.ingrediente) {
    formData.value = {
      nombre: props.ingrediente.nombre || '',
      cantidad_minima: Number(props.ingrediente.cantidad_minima) || 0
    };
  }
});

// ESC to close
const handleKeydown = (e: KeyboardEvent) => {
  if (e.key === 'Escape' && props.show) {
    emit('close');
  }
};

onMounted(() => window.addEventListener('keydown', handleKeydown));
onUnmounted(() => window.removeEventListener('keydown', handleKeydown));
</script>

<template>
  <div v-if="show" class="modal-backdrop fade show" style="background-color: rgba(0,0,0,0.5);"></div>
  <div v-if="show" class="modal fade show d-block" tabindex="-1" role="dialog" @click.self="$emit('close')">
    <div class="modal-dialog modal-dialog-centered" role="document">
      <div class="modal-content border-0 rounded-4 shadow-lg overflow-hidden">
        
        <div class="modal-header border-bottom-0 bg-light pb-2">
          <div>
            <h5 class="modal-title fw-bold text-dark mb-0">Ajustar Insumo</h5>
            <p class="text-muted small mb-0 mt-1">Modifica el nombre o las alertas de stock</p>
          </div>
          <button type="button" class="btn-close" @click="$emit('close')" aria-label="Close"></button>
        </div>
        
        <form @submit.prevent="$emit('save', formData)">
          <div class="modal-body py-4 px-4">
            
            <div class="mb-3">
              <label class="form-label fw-semibold text-secondary small text-uppercase">Nombre del Insumo</label>
              <input v-model="formData.nombre" type="text" class="form-control form-control-lg rounded-3" required />
            </div>

            <div class="mb-3">
              <label class="form-label fw-semibold text-secondary small text-uppercase">Stock Mínimo (Alerta)</label>
              <div class="input-group">
                <input v-model.number="formData.cantidad_minima" type="number" step="any" min="0" class="form-control form-control-lg rounded-start-3" required />
                <span class="input-group-text bg-light text-muted">{{ ingrediente?.unidad_nombre || 'Ud.' }}</span>
              </div>
              <div class="form-text mt-2">El sistema mostrará una alerta cuando el stock baje de este número.</div>
            </div>

          </div>
          
          <div class="modal-footer border-top-0 bg-light rounded-bottom-4">
            <button type="button" class="btn btn-light fw-bold px-4 rounded-pill" @click="$emit('close')">
              <X :size="18" class="me-1"/> Cancelar
            </button>
            <button type="submit" class="btn btn-korange fw-bold px-4 rounded-pill shadow-sm">
              <Save :size="18" class="me-1"/> Guardar Cambios
            </button>
          </div>
        </form>

      </div>
    </div>
  </div>
</template>

<style scoped>
.btn-korange {
  background-color: var(--KOrange);
  color: white;
  border: none;
}
.btn-korange:hover {
  background-color: #e65c00;
  color: white;
}
.form-control:focus {
  border-color: var(--KOrange);
  box-shadow: 0 0 0 0.25rem rgba(255, 102, 0, 0.25);
}
</style>
