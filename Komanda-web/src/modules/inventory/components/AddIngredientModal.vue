<script setup lang="ts">
import { ref, watch, onMounted, onUnmounted } from 'vue';
import { Save, X } from 'lucide-vue-next';

const props = defineProps({
  show: Boolean,
  ingrediente: Object
});

const emit = defineEmits(['close', 'save', 'go-to-purchase']);

const formData = ref({
  nombre: '',
  cantidad_minima: 5,
  unidad_id: 1,
  merma_teorica_porcentaje: 0,
  unidades_por_paquete: 1,   // cuántas unidades de stock trae 1 unidad de compra
});

watch(() => props.show, (newVal) => {
  if (newVal) {
    formData.value = {
      nombre: '',
      cantidad_minima: 5,
      unidad_id: 1,
      merma_teorica_porcentaje: 0,
      unidades_por_paquete: 1,
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
            <h5 class="modal-title fw-bold text-dark mb-0">Agregar Nuevo Insumo</h5>
            <p class="text-muted small mb-0 mt-1">Registra un nuevo ingrediente en el inventario</p>
          </div>
          <button type="button" class="btn-close" @click="$emit('close')" aria-label="Close"></button>
        </div>
        
        <form @submit.prevent="$emit('save', { ...formData })">
          <div class="modal-body py-4 px-4">
            
            <div class="mb-3">
              <label class="form-label fw-semibold text-secondary small text-uppercase">Nombre del Insumo</label>
              <input v-model="formData.nombre" type="text" class="form-control form-control-lg rounded-3" required />
            </div>

            <div class="row mb-3">
              <div class="col-md-6">
                <label class="form-label fw-semibold text-secondary small text-uppercase">Unidad de Medida <span class="text-korange">*</span></label>
                <select v-model.number="formData.unidad_id" class="form-select form-select-lg rounded-3" required>
                  <option disabled value="">Seleccione una unidad...</option>
                  <option :value="1">Gramos (g)</option>
                  <option :value="3">Kilogramos (kg)</option>
                  <option :value="2">Litros (L)</option>
                  <option :value="5">Mililitros (ml)</option>
                  <option :value="4">Unidades (und)</option>
                </select>
              </div>
              <div class="col-md-6">
                <label class="form-label fw-semibold text-secondary small text-uppercase">Stock Mínimo (Alerta) <span class="text-korange">*</span></label>
                <input v-model.number="formData.cantidad_minima" type="number" step="any" min="0" class="form-control form-control-lg rounded-3" required />
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label fw-semibold text-secondary small text-uppercase d-flex align-items-center gap-1">
                Unidades por Paquete
              </label>
              <div class="input-group input-group-lg">
                <input v-model.number="formData.unidades_por_paquete" type="number" step="any" min="1" class="form-control rounded-start-3" />
                <span class="input-group-text rounded-end-3 bg-light">u/c</span>
              </div>
              <div class="form-text small mt-1">¿Cuántas unidades de stock trae 1 unidad de compra? Ej: 1 saco = 50 kg → 50000 g.</div>
            </div>

            <div class="mb-3">
              <label class="form-label fw-semibold text-secondary small text-uppercase">Merma Teórica (%)</label>
              <div class="input-group input-group-lg">
                <input v-model.number="formData.merma_teorica_porcentaje" type="number" step="any" min="0" max="100" class="form-control rounded-start-3" />
                <span class="input-group-text rounded-end-3 bg-light">%</span>
              </div>
              <div class="form-text mt-2 small">Porcentaje estimado de pérdida natural (ej. descongelamiento).</div>
            </div>

            <div class="alert alert-warning border-0 rounded-3 small d-flex align-items-start gap-2 mb-0" style="background-color: rgba(253,126,20,0.1); color: #d9534f;">
              <span style="font-size: 1.1rem; line-height: 1;">💡</span>
              <div>
                <strong>Nota:</strong> Los insumos nuevos se crean con <strong>stock inicial 0</strong>.
                Para añadir stock a este ingrediente, debes 
                <a href="#" class="fw-bold text-decoration-underline" style="color: var(--KOrange);" @click.prevent="$emit('go-to-purchase')">Registrar una Compra</a>.
              </div>
            </div>

          </div>
          
          <div class="modal-footer border-top-0 bg-light rounded-bottom-4">
            <button type="button" class="btn btn-light fw-bold px-4 rounded-pill" @click="$emit('close')">
              <X :size="18" class="me-1"/> Cancelar
            </button>
            <button type="submit" class="btn btn-korange fw-bold px-4 rounded-pill shadow-sm">
              <Save :size="18" class="me-1"/> Crear Insumo
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
