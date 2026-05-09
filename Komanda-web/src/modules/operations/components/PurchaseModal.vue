<template>
  <div class="modal fade" id="purchaseModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
      <div class="modal-content border-0 shadow-lg" style="background-color: var(--bg-surface);">
        <div class="modal-header border-0 pb-0 px-4 pt-4">
          <div class="d-flex align-items-center gap-3">
            <div class="rounded-3 p-2 d-flex" style="background: rgba(253,126,20,0.12);">
              <ShoppingCart :size="22" class="text-korange" />
            </div>
            <div>
              <h5 class="modal-title fw-bold text-main mb-0">Registrar Compra</h5>
              <p class="text-secondary-custom small mb-0 mt-1">Actualiza el stock y recalcula el CPP automáticamente</p>
            </div>
          </div>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>

        <div class="modal-body px-4 py-3">
          <form @submit.prevent="handleSubmit" id="purchaseForm">
            <!-- Sección 1: Datos de la factura -->
            <div class="rounded-3 p-3 mb-3" style="background: var(--bg-body); border: 1px solid var(--border-color);">
              <p class="fw-bold text-korange small text-uppercase mb-3">
                <PackageSearch :size="15" class="me-1" /> 1. Datos de la Factura
              </p>
              <div class="row g-3">
                <div class="col-md-3">
                  <label class="form-label text-secondary-custom fw-semibold small">Fecha <span class="text-korange">*</span></label>
                  <input v-model="form.fecha" type="date" class="form-control" required :max="today">
                </div>
                <div class="col-md-4">
                  <label class="form-label text-secondary-custom fw-semibold small">Proveedor</label>
                  <select v-model="form.proveedor_id" class="form-select">
                    <option :value="null">Sin proveedor / Contado</option>
                    <option v-for="prov in suppliers" :key="prov.id" :value="prov.id">{{ prov.nombre }}</option>
                  </select>
                </div>
                <div class="col-md-3">
                  <label class="form-label text-secondary-custom fw-semibold small">Nro. Factura</label>
                  <input v-model="form.numero_factura_proveedor" type="text" class="form-control" placeholder="FAC-001">
                </div>
                <div class="col-md-2">
                  <label class="form-label text-secondary-custom fw-semibold small">Estado Pago <span class="text-korange">*</span></label>
                  <select v-model="form.estado_pago" class="form-select" required>
                    <option value="pagada">Pagada</option>
                    <option value="pendiente">Pendiente (CxP)</option>
                  </select>
                </div>
              </div>
            </div>

            <!-- Sección 2: Ingredientes -->
            <div class="rounded-3 mb-3" style="border: 1px solid var(--border-color); overflow: hidden;">
              <div class="p-3 d-flex justify-content-between align-items-center"
                style="background: var(--bg-body); border-bottom: 1px solid var(--border-color);">
                <p class="fw-bold text-korange small text-uppercase mb-0">
                  <Package :size="15" class="me-1" /> 2. Ingredientes / Insumos
                </p>
                <button type="button" class="btn btn-sm d-flex align-items-center gap-1"
                  style="background: rgba(253,126,20,0.1); color: var(--KOrange); border: 1px solid rgba(253,126,20,0.3);"
                  @click="addItem">
                  <Plus :size="15" /> Añadir Ítem
                </button>
              </div>

              <!-- Items -->
              <div v-for="(item, idx) in form.items" :key="idx"
                class="item-row p-3" style="border-bottom: 1px solid var(--border-color);">
                
                <!-- Fila 1: Ingrediente + toggle + eliminar en una sola línea -->
                <div class="d-flex gap-2 align-items-center mb-2">
                  <div class="flex-grow-1">
                    <div class="d-flex gap-1 align-items-center">
                      <select v-if="!item.useText" v-model="item.ingrediente_id"
                        class="form-select form-select-sm" required>
                        <option value="" disabled>Seleccione ingrediente...</option>
                        <option v-for="ing in ingredients" :key="ing.id" :value="ing.id">
                          {{ ing.nombre }} ({{ ing.cantidad_disponible }})
                        </option>
                      </select>
                      <input v-else v-model="item.ingrediente_nombre" type="text"
                        class="form-control form-control-sm" required
                        placeholder="Ej: Sardinas enlatadas">
                      <!-- Toggle: existente ↔ nuevo -->
                      <button type="button"
                        class="btn btn-sm flex-shrink-0 d-flex align-items-center justify-content-center"
                        style="width:30px;height:30px;border:1px solid var(--border-color);background:transparent;"
                        :title="item.useText ? 'Usar existente' : 'Crear nuevo'"
                        @click="toggleIngredientMode(item)">
                        <ToggleLeft v-if="!item.useText" :size="15" class="text-korange" />
                        <ToggleRight v-else :size="15" class="text-korange" />
                      </button>
                    </div>
                    <small class="text-secondary-custom" style="font-size:0.68rem;">
                      {{ item.useText ? '✏️ Nuevo (se creará al guardar)' : '📦 Existente (actualiza stock)' }}
                    </small>
                  </div>
                  <button type="button"
                    class="btn btn-sm d-inline-flex align-items-center justify-content-center rounded-circle flex-shrink-0"
                    style="width:28px;height:28px;background:rgba(220,53,69,0.1);color:#dc3545;border:1px solid rgba(220,53,69,0.3);"
                    @click="removeItem(idx)" :disabled="form.items.length === 1">
                    <Trash2 :size="13" />
                  </button>
                </div>

                <!-- Fila 2: Campos numéricos en una sola fila compacta -->
                <div class="row g-2">
                  <div class="col">
                    <label class="form-label text-secondary-custom fw-semibold" style="font-size:0.68rem;">CANTIDAD *</label>
                    <input v-model.number="item.cantidad_compra" type="number"
                      step="0.001" min="0.001" class="form-control form-control-sm"
                      required placeholder="1.000">
                  </div>
                  <div class="col">
                    <label class="form-label text-secondary-custom fw-semibold" style="font-size:0.68rem;">PRECIO UNIT. *</label>
                    <div class="input-group input-group-sm">
                      <span class="input-group-text bg-transparent border-end-0 px-2">$</span>
                      <input v-model.number="item.precio_unitario" type="number"
                        step="0.01" min="0" class="form-control border-start-0 ps-0"
                        required placeholder="0.00">
                    </div>
                  </div>
                  <div class="col">
                    <label class="form-label text-secondary-custom fw-semibold" style="font-size:0.68rem;">UNID/PAQUETE</label>
                    <div class="input-group input-group-sm">
                      <input v-model.number="item.factor_conversion" type="number"
                        step="0.001" min="0.001" class="form-control"
                        required placeholder="1">
                      <span class="input-group-text bg-transparent px-1 small">u/c</span>
                    </div>
                    <div style="font-size:0.62rem;" class="text-secondary-custom">
                      = {{ ((item.cantidad_compra || 0) * (item.factor_conversion || 0)).toFixed(2) }} uds stock
                    </div>
                  </div>
                  <div class="col">
                    <label class="form-label text-secondary-custom fw-semibold" style="font-size:0.68rem;">MERMA (%)</label>
                    <div class="input-group input-group-sm">
                      <input v-model.number="item.merma_teorica_porcentaje" type="number"
                        step="0.1" min="0" max="100" class="form-control" placeholder="0">
                      <span class="input-group-text bg-transparent px-2">%</span>
                    </div>
                  </div>
                  <div class="col-auto d-flex flex-column justify-content-end">
                    <span class="fw-bold text-main" style="font-size:1rem; line-height:2.2; white-space:nowrap;">
                      ${{ ((item.cantidad_compra || 0) * (item.precio_unitario || 0)).toFixed(2) }}
                    </span>
                  </div>
                </div>

                <!-- Fila 3: Solo para nuevos ingredientes -->
                <div v-if="item.useText" class="row g-2 pt-2 mt-1" style="border-top: 1px dashed var(--border-color);">
                  <div class="col-12">
                    <small class="text-korange fw-semibold" style="font-size:0.68rem;">⚙️ CONFIGURACIÓN DEL NUEVO INSUMO</small>
                  </div>
                  <div class="col-6">
                    <label class="form-label text-secondary-custom fw-semibold" style="font-size:0.68rem;">UNIDAD DE MEDIDA *</label>
                    <select v-model.number="item.unidad_id" class="form-select form-select-sm" required>
                      <option :value="1">Gramos (g)</option>
                      <option :value="3">Kilogramos (kg)</option>
                      <option :value="2">Litros (L)</option>
                      <option :value="5">Mililitros (ml)</option>
                      <option :value="4">Unidades (und)</option>
                    </select>
                  </div>
                  <div class="col-6">
                    <label class="form-label text-secondary-custom fw-semibold" style="font-size:0.68rem;">STOCK MÍNIMO</label>
                    <input v-model.number="item.cantidad_minima" type="number"
                      step="any" min="0" class="form-control form-control-sm" placeholder="0">
                  </div>
                </div>
              </div>

              <!-- Total footer -->
              <div class="p-3 d-flex justify-content-between align-items-center"
                style="background: var(--bg-body); border-top: 1px solid var(--border-color);">
                <span class="small text-secondary-custom d-flex align-items-center gap-1">
                  <Info :size="14" /> El CPP se recalcula automáticamente al registrar la compra
                </span>
                <div class="text-end">
                  <span class="text-secondary-custom small me-2">TOTAL FACTURA</span>
                  <span class="fs-4 fw-bold text-korange">${{ totalCompra.toFixed(2) }}</span>
                </div>
              </div>
            </div>
          </form>
        </div>

        <div class="modal-footer border-0 px-4 pb-4 pt-2 gap-2">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" form="purchaseForm" class="btn btn-korange d-flex align-items-center gap-2"
            :disabled="loading || !isFormValid">
            <span v-if="loading" class="spinner-border spinner-border-sm"></span>
            <ShoppingCart v-else :size="16" />
            Procesar Compra
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { ShoppingCart, Plus, Trash2, Info, ToggleLeft, ToggleRight, Package, PackageSearch } from 'lucide-vue-next';

const props = defineProps({
  loading: { type: Boolean, default: false },
  suppliers: { type: Array as () => any[], default: () => [] },
  ingredients: { type: Array as () => any[], default: () => [] }
});
const emit = defineEmits(['save']);

const today = new Date().toISOString().slice(0, 10);

const getBlankItem = () => ({
  ingrediente_id: '' as string | number,
  ingrediente_nombre: '',
  useText: false,
  cantidad_compra: null as number | null,
  precio_unitario: null as number | null,
  factor_conversion: 1,
  // Campos solo para nuevos ingredientes
  unidad_id: 4, // Unidades por defecto
  cantidad_minima: 0,
  merma_teorica_porcentaje: 0,
});

const form = ref({
  fecha: today,
  proveedor_id: null as number | null,
  numero_factura_proveedor: '',
  estado_pago: 'pagada',
  items: [getBlankItem()]
});

const totalCompra = computed(() =>
  form.value.items.reduce((s, i) => s + ((i.cantidad_compra || 0) * (i.precio_unitario || 0)), 0)
);

const isFormValid = computed(() =>
  form.value.items.every(i => {
    const hasIng = i.useText ? !!i.ingrediente_nombre?.trim() : !!i.ingrediente_id;
    return hasIng && i.cantidad_compra && i.precio_unitario && i.factor_conversion;
  })
);

const addItem = () => form.value.items.push(getBlankItem());
const removeItem = (idx: number) => {
  if (form.value.items.length > 1) form.value.items.splice(idx, 1);
};
const toggleIngredientMode = (item: any) => {
  item.useText = !item.useText;
  item.ingrediente_id = '';
  item.ingrediente_nombre = '';
};

const handleSubmit = () => {
  if (!isFormValid.value) return;
  emit('save', {
    ...form.value,
    items: form.value.items.map(i => ({
      ingrediente_id: i.useText ? null : Number(i.ingrediente_id),
      ingrediente_nombre: i.useText ? i.ingrediente_nombre.trim() : null,
      unidad_id: i.useText ? Number(i.unidad_id) : null,
      cantidad_minima: i.useText ? Number(i.cantidad_minima) : null,
      merma_teorica_porcentaje: i.useText ? Number(i.merma_teorica_porcentaje) : null,
      cantidad_compra: Number(i.cantidad_compra),
      unidad_compra_id: null, // campo legado, no usado en UI
      precio_unitario: Number(i.precio_unitario),
      factor_conversion: Number(i.factor_conversion),
    }))
  });
};

const resetForm = () => {
  form.value = {
    fecha: today, proveedor_id: null,
    numero_factura_proveedor: '', estado_pago: 'pagada',
    items: [getBlankItem()]
  };
};
defineExpose({ resetForm });
</script>
