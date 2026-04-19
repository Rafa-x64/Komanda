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

              <div class="table-responsive">
                <table class="table mb-0" style="--bs-table-bg: transparent;">
                  <thead style="background: var(--bg-body); border-bottom: 1px solid var(--border-color);">
                    <tr>
                      <th class="ps-3 text-secondary-custom fw-semibold small text-uppercase py-2" style="min-width:240px;">
                        Ingrediente
                      </th>
                      <th class="text-secondary-custom fw-semibold small text-uppercase py-2" style="min-width:110px;">Cantidad</th>
                      <th class="text-secondary-custom fw-semibold small text-uppercase py-2" style="min-width:110px;">Precio Unit.</th>
                      <th class="text-secondary-custom fw-semibold small text-uppercase py-2" style="min-width:130px;">
                        <span class="d-flex align-items-center gap-1">
                          Unid. p/ compra
                          <span tabindex="0" data-bs-toggle="tooltip"
                            title="¿Cuántas unidades de inventario (ej. gramos, litros) trae cada unidad que compras? Ej: si compras un saco de 50kg, el factor es 50000 gramos.">
                            <Info :size="13" class="text-secondary-custom" style="cursor:help;" />
                          </span>
                        </span>
                      </th>
                      <th class="text-secondary-custom fw-semibold small text-uppercase py-2">Subtotal</th>
                      <th class="pe-3"></th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(item, idx) in form.items" :key="idx"
                      style="border-bottom: 1px solid var(--border-color);">
                      <!-- Ingrediente: toggle entre select y texto libre -->
                      <td class="ps-3 py-2">
                        <div class="d-flex gap-1">
                          <div class="flex-grow-1">
                            <!-- SELECT: ingrediente existente -->
                            <select v-if="!item.useText" v-model="item.ingrediente_id"
                              class="form-select form-select-sm" required>
                              <option value="" disabled>Seleccione ingrediente...</option>
                              <option v-for="ing in ingredients" :key="ing.id" :value="ing.id">
                                {{ ing.nombre }} (stock: {{ ing.cantidad_disponible }})
                              </option>
                            </select>
                            <!-- TEXT: ingrediente nuevo -->
                            <input v-else v-model="item.ingrediente_nombre" type="text"
                              class="form-control form-control-sm" required
                              placeholder="Nombre del nuevo ingrediente">
                          </div>
                          <!-- Botón toggle -->
                          <button type="button"
                            class="btn btn-sm flex-shrink-0 d-flex align-items-center justify-content-center"
                            style="width:32px;height:31px;border:1px solid var(--border-color);background:transparent;"
                            :title="item.useText ? 'Seleccionar existente' : 'Escribir nuevo'"
                            @click="toggleIngredientMode(item)">
                            <ToggleLeft v-if="!item.useText" :size="16" class="text-korange" />
                            <ToggleRight v-else :size="16" class="text-korange" />
                          </button>
                        </div>
                        <div class="mt-1">
                          <small class="text-secondary-custom" style="font-size:0.72rem;">
                            {{ item.useText ? '✏️ Nuevo ingrediente (se creará al guardar)' : '📦 Ingrediente existente (actualiza stock)' }}
                          </small>
                        </div>
                      </td>

                      <td class="py-2">
                        <input v-model.number="item.cantidad_compra" type="number"
                          step="0.001" min="0.001" class="form-control form-control-sm"
                          required placeholder="1.000">
                      </td>

                      <td class="py-2">
                        <div class="input-group input-group-sm">
                          <span class="input-group-text bg-transparent border-end-0 small">$</span>
                          <input v-model.number="item.precio_unitario" type="number"
                            step="0.01" min="0" class="form-control border-start-0 ps-0"
                            required placeholder="0.00">
                        </div>
                      </td>

                      <td class="py-2">
                        <div class="input-group input-group-sm">
                          <input v-model.number="item.factor_conversion" type="number"
                            step="0.001" min="0.001" class="form-control"
                            required placeholder="1.000"
                            title="Cuántas unidades de stock equivale 1 unidad de compra">
                          <span class="input-group-text bg-transparent small text-secondary-custom">u/c</span>
                        </div>
                        <div style="font-size:0.7rem;" class="text-secondary-custom mt-1">
                          = {{ ((item.cantidad_compra || 0) * (item.factor_conversion || 0)).toFixed(2) }} en stock
                        </div>
                      </td>

                      <td class="py-2 fw-bold text-main">
                        ${{ ((item.cantidad_compra || 0) * (item.precio_unitario || 0)).toFixed(2) }}
                      </td>

                      <td class="py-2 pe-3">
                        <button type="button"
                          class="btn btn-sm d-inline-flex align-items-center justify-content-center rounded-circle"
                          style="width:30px;height:30px;background:rgba(220,53,69,0.1);color:#dc3545;border:1px solid rgba(220,53,69,0.3);"
                          @click="removeItem(idx)" :disabled="form.items.length === 1">
                          <Trash2 :size="14" />
                        </button>
                      </td>
                    </tr>
                  </tbody>
                </table>
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
  ingrediente_nombre: '', // para cuando useText = true (nuevo ingrediente)
  useText: false,
  cantidad_compra: null as number | null,
  unidad_compra_id: 10,
  precio_unitario: null as number | null,
  factor_conversion: 1
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
      ingrediente_nombre: i.useText ? i.ingrediente_nombre : null,
      cantidad_compra: Number(i.cantidad_compra),
      unidad_compra_id: Number(i.unidad_compra_id),
      precio_unitario: Number(i.precio_unitario),
      factor_conversion: Number(i.factor_conversion)
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
