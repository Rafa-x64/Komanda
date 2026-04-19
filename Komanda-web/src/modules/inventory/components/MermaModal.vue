<script setup lang="ts">
import { ref, watch, onMounted, onUnmounted } from 'vue';
import { Save, X, AlertTriangle } from 'lucide-vue-next';

const props = defineProps({
  show: Boolean,
  ingredientes: Array as () => any[]
});

const emit = defineEmits(['close', 'save']);

const formData = ref({
  ingrediente_id: '',
  cantidad: null as number | null,
  tipo: '',
  razon: ''
});

const maxStock = ref(0);
const unitSelected = ref('Ud.');

watch(() => props.show, (newVal) => {
  if (newVal) {
    formData.value = {
      ingrediente_id: '',
      cantidad: null,
      tipo: '',
      razon: ''
    };
    maxStock.value = 0;
    unitSelected.value = 'Ud.';
  }
});

const onIngredientChange = () => {
  const selected = props.ingredientes?.find(i => i.id === Number(formData.value.ingrediente_id));
  if (selected) {
    maxStock.value = Number(selected.cantidad_disponible);
    unitSelected.value = selected.unidad_nombre || 'Ud.';
  } else {
    maxStock.value = 0;
    unitSelected.value = 'Ud.';
  }
};

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
          <div class="d-flex align-items-center gap-2">
            <div class="bg-danger bg-opacity-10 text-danger p-2 rounded-circle d-flex">
              <AlertTriangle :size="20"/>
            </div>
            <div>
              <h5 class="modal-title fw-bold text-dark mb-0">Registrar Merma</h5>
              <p class="text-muted small mb-0 mt-1">Descarta insumos por pérdida o daño</p>
            </div>
          </div>
          <button type="button" class="btn-close" @click="$emit('close')" aria-label="Close"></button>
        </div>
        
        <form @submit.prevent="$emit('save', formData)">
          <div class="modal-body py-4 px-4">
            
            <div class="mb-3">
              <label class="form-label fw-semibold text-secondary small text-uppercase">Insumo</label>
              <select v-model="formData.ingrediente_id" class="form-select form-select-lg rounded-3" @change="onIngredientChange" required>
                <option value="" disabled>Seleccione un insumo...</option>
                <option v-for="ing in ingredientes" :key="ing.id" :value="ing.id">
                  {{ ing.nombre }} (Disponible: {{ ing.cantidad_disponible }} {{ ing.unidad_nombre }})
                </option>
              </select>
            </div>

            <div class="row">
              <div class="col-md-6 mb-3">
                <label class="form-label fw-semibold text-secondary small text-uppercase">Cantidad a Descartar</label>
                <div class="input-group">
                  <input v-model.number="formData.cantidad" type="number" step="any" min="0.001" :max="maxStock" class="form-control form-control-lg rounded-start-3" required :disabled="!formData.ingrediente_id" />
                  <span class="input-group-text bg-light text-muted">{{ unitSelected }}</span>
                </div>
                <div class="form-text text-danger" v-if="formData.cantidad && formData.cantidad > maxStock">
                  Supera el stock actual.
                </div>
              </div>
              
              <div class="col-md-6 mb-3">
                <label class="form-label fw-semibold text-secondary small text-uppercase">Motivo Principal</label>
                <select v-model="formData.tipo" class="form-select form-select-lg rounded-3" required>
                  <option value="" disabled>Seleccione...</option>
                  <option value="vencimiento">Vencimiento</option>
                  <option value="desperdicio">Desperdicio (Cocina)</option>
                  <option value="rotura">Rotura / Daño</option>
                  <option value="otro">Otro Ajuste</option>
                </select>
              </div>
            </div>

            <div class="mb-2">
              <label class="form-label fw-semibold text-secondary small text-uppercase">Detalle Adicional (Opcional)</label>
              <textarea v-model="formData.razon" class="form-control rounded-3" rows="2" placeholder="Ej: Plato devuelto, botella rota en almacén..." maxlength="255"></textarea>
            </div>

          </div>
          
          <div class="modal-footer border-top-0 bg-light rounded-bottom-4">
            <button type="button" class="btn btn-light fw-bold px-4 rounded-pill" @click="$emit('close')">
              <X :size="18" class="me-1"/> Cancelar
            </button>
            <button type="submit" class="btn btn-danger fw-bold px-4 rounded-pill shadow-sm" :disabled="!formData.ingrediente_id || (formData.cantidad && formData.cantidad > maxStock)">
              <Save :size="18" class="me-1"/> Registrar Merma
            </button>
          </div>
        </form>

      </div>
    </div>
  </div>
</template>

<style scoped>
.form-control:focus, .form-select:focus {
  border-color: #dc3545;
  box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25);
}
</style>
