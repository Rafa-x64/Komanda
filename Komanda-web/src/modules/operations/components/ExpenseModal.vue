<template>
  <div class="modal fade" id="expenseModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content border-0 shadow-lg" style="background-color: var(--bg-surface);">
        <div class="modal-header border-0 pb-0 px-4 pt-4">
          <div>
            <h5 class="modal-title fw-bold text-main mb-0">Registrar Gasto Operativo</h5>
            <p class="text-secondary-custom small mb-0 mt-1">Genera asiento contable automático</p>
          </div>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body px-4 py-3">
          <!-- Info banner -->
          <div class="rounded-3 p-3 mb-3 d-flex align-items-center gap-2"
            style="background: rgba(253,126,20,0.08); border: 1px solid rgba(253,126,20,0.2);">
            <Info :size="16" class="text-korange flex-shrink-0" />
            <span class="small text-main">Se generará un asiento automático en el <strong>Libro Diario</strong></span>
          </div>

          <form @submit.prevent="handleSubmit" id="expenseForm">
            <div class="row g-3">
              <!-- Categorías como cards clickables -->
              <div class="col-12">
                <label class="form-label text-secondary-custom fw-semibold small text-uppercase">
                  Categoría <span class="text-korange">*</span>
                </label>
                <div class="d-flex flex-wrap gap-2">
                  <button v-for="cat in categorias" :key="cat.value" type="button"
                    class="btn btn-sm categoria-btn d-flex align-items-center gap-1"
                    :style="form.categoria === cat.value
                      ? 'background: var(--KOrange); color: white; border: 1px solid var(--KOrange);'
                      : 'background: transparent; color: var(--text-muted); border: 1px solid var(--border-color);'"
                    @click="form.categoria = cat.value">
                    <component :is="cat.icon" :size="14" />{{ cat.label }}
                  </button>
                </div>
                <!-- hidden required field para validación nativa -->
                <input type="text" :value="form.categoria" required class="visually-hidden">
              </div>

              <div class="col-md-6">
                <label class="form-label text-secondary-custom fw-semibold small text-uppercase">
                  Monto ($) <span class="text-korange">*</span>
                </label>
                <div class="input-group">
                  <span class="input-group-text bg-transparent small">$</span>
                  <input v-model.number="form.monto" type="number" step="0.01" min="0.01"
                    class="form-control" required placeholder="0.00">
                </div>
              </div>

              <div class="col-md-6">
                <label class="form-label text-secondary-custom fw-semibold small text-uppercase">
                  Fecha <span class="text-korange">*</span>
                </label>
                <input v-model="form.fecha" type="date" class="form-control" required :max="today">
              </div>

              <div class="col-md-6">
                <label class="form-label text-secondary-custom fw-semibold small text-uppercase">
                  Método de Pago <span class="text-korange">*</span>
                </label>
                <select v-model="form.metodo_pago" class="form-select" required>
                  <option value="efectivo">Efectivo</option>
                  <option value="pago_movil">Pago Móvil</option>
                  <option value="tarjeta">Tarjeta (Punto)</option>
                  <option value="divisa">Divisa en Efectivo</option>
                </select>
              </div>

              <div class="col-md-6" v-if="form.metodo_pago !== 'efectivo'">
                <label class="form-label text-secondary-custom fw-semibold small text-uppercase">Referencia</label>
                <input v-model="form.referencia" type="text" class="form-control" placeholder="Nro de referencia">
              </div>

              <div class="col-12">
                <label class="form-label text-secondary-custom fw-semibold small text-uppercase">
                  Descripción {{ form.categoria === 'otros' ? '(Requerida)' : '(Opcional)' }}
                  <span v-if="form.categoria === 'otros'" class="text-korange">*</span>
                </label>
                <input v-model="form.descripcion" type="text" class="form-control"
                  :required="form.categoria === 'otros'"
                  placeholder="Ej: Factura Corpoelec Mayo 2026">
              </div>
            </div>
          </form>
        </div>
        <div class="modal-footer border-0 px-4 pb-4 pt-2 gap-2">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" form="expenseForm" class="btn btn-korange d-flex align-items-center gap-2"
            :disabled="loading || !form.categoria || !form.monto">
            <span v-if="loading" class="spinner-border spinner-border-sm"></span>
            <Save v-else :size="16" />
            Registrar Gasto
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { Save, Info, Droplets, Flame, Zap, Wifi, Home, MoreHorizontal } from 'lucide-vue-next';

const props = defineProps({ loading: { type: Boolean, default: false } });
const emit = defineEmits(['save']);

const today = new Date().toISOString().slice(0, 10);

const categorias = [
  { value: 'agua', label: 'Agua', icon: Droplets },
  { value: 'gas', label: 'Gas', icon: Flame },
  { value: 'electricidad', label: 'Electricidad', icon: Zap },
  { value: 'internet', label: 'Internet', icon: Wifi },
  { value: 'alquiler', label: 'Alquiler', icon: Home },
  { value: 'otros', label: 'Otros', icon: MoreHorizontal },
];

const getBlank = () => ({
  categoria: '', monto: null as number | null, fecha: today,
  metodo_pago: 'efectivo', referencia: '', descripcion: ''
});
const form = ref(getBlank());

const handleSubmit = () => {
  emit('save', { ...form.value });
  form.value = getBlank();
};
</script>

<style scoped>
.categoria-btn {
  transition: all 0.18s;
  font-size: 0.82rem;
  border-radius: 0.5rem;
  padding: 0.4rem 0.75rem;
}
.categoria-btn:hover {
  background: rgba(253,126,20,0.15) !important;
  color: var(--KOrange) !important;
  border-color: var(--KOrange) !important;
}
</style>
