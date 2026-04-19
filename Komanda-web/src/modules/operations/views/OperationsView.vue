<template>
  <div class="d-flex w-100">
    <Sidebar :role="auth.user.value?.role || 'admin'" :userName="auth.user.value?.nombre" />

    <div class="operations-wrapper main-content">
      <!-- Toast notification -->
      <Transition name="toast-slide">
        <div v-if="toast" class="ops-toast" :class="`ops-toast--${toast.type}`">
          <CheckCircle v-if="toast.type === 'success'" :size="18" />
          <AlertCircle v-else :size="18" />
          {{ toast.message }}
        </div>
      </Transition>

      <div class="p-4">
        <!-- Header -->
        <header class="d-flex justify-content-between align-items-start mb-4">
          <div>
            <h2 class="fw-bold mb-1 text-main">Gestión <span class="text-korange">Operativa</span></h2>
            <p class="text-secondary-custom small mb-0">Proveedores, Compras e Inventario, y Gastos Operativos</p>
          </div>
        </header>

        <!-- Tabs -->
        <ul class="nav nav-tabs nav-tabs-custom mb-4" id="opsTabs" role="tablist">
          <li class="nav-item" role="presentation">
            <button class="nav-link active d-flex align-items-center gap-2" data-bs-toggle="tab"
              data-bs-target="#tabProveedores" type="button" @click="fetchProveedores">
              <Truck :size="16" /> Proveedores
              <span v-if="proveedores.length" class="badge rounded-pill text-bg-secondary">{{ proveedores.length }}</span>
            </button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link d-flex align-items-center gap-2" data-bs-toggle="tab"
              data-bs-target="#tabCompras" type="button" @click="fetchCompras">
              <ShoppingBag :size="16" /> Compras e Inventario
              <span v-if="compras.length" class="badge rounded-pill text-bg-secondary">{{ compras.length }}</span>
            </button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link d-flex align-items-center gap-2" data-bs-toggle="tab"
              data-bs-target="#tabGastos" type="button" @click="fetchGastos">
              <Receipt :size="16" /> Gastos Operativos
              <span v-if="gastos.length" class="badge rounded-pill text-bg-secondary">{{ gastos.length }}</span>
            </button>
          </li>
        </ul>

        <!-- Tab Content -->
        <div class="tab-content" id="opsTabContent">
          <!-- ==================== PROVEEDORES ==================== -->
          <div class="tab-pane fade show active" id="tabProveedores" role="tabpanel">
            <div class="card border-0 shadow-sm rounded-4" style="background: var(--bg-surface);">
              <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center p-4 pb-3">
                <div>
                  <h5 class="fw-bold text-main mb-0">Listado de Proveedores</h5>
                  <p class="text-secondary-custom small mb-0 mt-1">Gestiona los proveedores de insumos del restaurante</p>
                </div>
                <button class="btn btn-korange btn-sm rounded-pill px-3 d-flex align-items-center gap-2"
                  data-bs-toggle="modal" data-bs-target="#supplierModal"
                  @click="selectedSupplier = null">
                  <Plus :size="16" /> Nuevo Proveedor
                </button>
              </div>
              <div class="card-body p-0">
                <div class="table-responsive">
                  <table class="table table-custom table-hover-custom mb-0">
                    <thead>
                      <tr>
                        <th class="ps-4">Identificación</th>
                        <th>Razón Social</th>
                        <th>Teléfono</th>
                        <th>Email</th>
                        <th>Banco</th>
                        <th>Estado</th>
                        <th class="text-center pe-4">Acciones</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr v-if="loading.proveedores">
                        <td colspan="7" class="text-center py-5">
                          <span class="spinner-border spinner-border-sm text-korange me-2"></span>Cargando...
                        </td>
                      </tr>
                      <tr v-else-if="proveedores.length === 0">
                        <td colspan="7" class="text-center py-5 text-secondary-custom">
                          <Truck :size="32" class="mb-2 opacity-50" /><br>No hay proveedores registrados
                        </td>
                      </tr>
                      <tr v-for="prov in proveedores" :key="prov.id">
                        <td class="ps-4 fw-semibold text-secondary-custom">{{ prov.identificacion }}</td>
                        <td class="fw-bold">{{ prov.nombre }}</td>
                        <td>{{ prov.telefono || '—' }}</td>
                        <td>{{ prov.email || '—' }}</td>
                        <td>{{ prov.banco_nombre || '—' }}</td>
                        <td>
                          <span class="badge rounded-pill px-3 fw-semibold"
                            :style="prov.activo
                              ? 'background: rgba(25,135,84,0.15); color: #198754;'
                              : 'background: rgba(220,53,69,0.15); color: #dc3545;'">
                            {{ prov.activo ? 'Activo' : 'Inactivo' }}
                          </span>
                        </td>
                        <td class="text-center pe-4">
                          <button class="btn btn-sm rounded-circle me-1 d-inline-flex align-items-center justify-content-center"
                            style="width:32px;height:32px;background:rgba(253,126,20,0.1);color:var(--KOrange);border:1px solid rgba(253,126,20,0.3);"
                            data-bs-toggle="modal" data-bs-target="#supplierModal"
                            @click="selectedSupplier = prov" title="Editar">
                            <Pencil :size="14" />
                          </button>
                          <button class="btn btn-sm rounded-circle d-inline-flex align-items-center justify-content-center"
                            style="width:32px;height:32px;"
                            :style="prov.activo
                              ? 'background:rgba(220,53,69,0.1);color:#dc3545;border:1px solid rgba(220,53,69,0.3);'
                              : 'background:rgba(25,135,84,0.1);color:#198754;border:1px solid rgba(25,135,84,0.3);'"
                            @click="toggleProveedor(prov)"
                            :title="prov.activo ? 'Desactivar' : 'Activar'">
                            <component :is="prov.activo ? UserX : UserCheck" :size="14" />
                          </button>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>

          <!-- ==================== COMPRAS ==================== -->
          <div class="tab-pane fade" id="tabCompras" role="tabpanel">
            <div class="card border-0 shadow-sm rounded-4" style="background: var(--bg-surface);">
              <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center p-4 pb-3">
                <div>
                  <h5 class="fw-bold text-main mb-0">Historial de Compras</h5>
                  <p class="text-secondary-custom small mb-0 mt-1">Cada compra actualiza el stock y el Costo Promedio Ponderado</p>
                </div>
                <button class="btn btn-korange btn-sm rounded-pill px-3 d-flex align-items-center gap-2"
                  data-bs-toggle="modal" data-bs-target="#purchaseModal"
                  @click="onOpenPurchaseModal">
                  <ShoppingCart :size="16" /> Registrar Compra
                </button>
              </div>
              <div class="card-body p-0">
                <div class="table-responsive">
                  <table class="table table-custom table-hover-custom mb-0">
                    <thead>
                      <tr>
                        <th class="ps-4">ID</th>
                        <th>Fecha</th>
                        <th>N° Factura</th>
                        <th>Proveedor</th>
                        <th>Estado</th>
                        <th class="text-end pe-4">Total ($)</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr v-if="loading.compras">
                        <td colspan="6" class="text-center py-5">
                          <span class="spinner-border spinner-border-sm text-korange me-2"></span>Cargando...
                        </td>
                      </tr>
                      <tr v-else-if="compras.length === 0">
                        <td colspan="6" class="text-center py-5 text-secondary-custom">
                          <ShoppingBag :size="32" class="mb-2 opacity-50" /><br>No hay compras registradas
                        </td>
                      </tr>
                      <tr v-for="compra in compras" :key="compra.id">
                        <td class="ps-4 text-secondary-custom">#{{ String(compra.id).padStart(4, '0') }}</td>
                        <td>{{ compra.fecha }}</td>
                        <td>{{ compra.numero_factura_proveedor || 'S/N' }}</td>
                        <td class="fw-semibold">{{ compra.proveedor_nombre || 'Contado General' }}</td>
                        <td>
                          <span class="badge rounded-pill px-3" :class="{
                            'bg-success bg-opacity-15 text-white': compra.estado_pago === 'pagada',
                            'bg-warning bg-opacity-15 text-white': compra.estado_pago === 'pendiente',
                            'bg-info bg-opacity-15 text-white': compra.estado_pago === 'abonada'
                          }">{{ compra.estado_pago.toUpperCase() }}</span>
                        </td>
                        <td class="text-end pe-4 fw-bold">${{ Number(compra.total).toFixed(2) }}</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>

          <!-- ==================== GASTOS ==================== -->
          <div class="tab-pane fade" id="tabGastos" role="tabpanel">
            <!-- Tarjetas resumen -->
            <div class="row g-3 mb-4">
              <div v-for="cat in gastosCategorias" :key="cat.value" class="col-6 col-md-4 col-xl-2">
                <div class="card border-0 shadow-sm rounded-4 p-3 text-center" style="background: var(--bg-surface);">
                  <div class="mb-2">
                    <component :is="cat.icon" :size="22" :class="cat.color" />
                  </div>
                  <div class="fw-bold text-main small">{{ cat.label }}</div>
                  <div class="text-korange fw-bold">${{ totalPorCategoria(cat.value) }}</div>
                </div>
              </div>
            </div>

            <div class="card border-0 shadow-sm rounded-4" style="background: var(--bg-surface);">
              <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center p-4 pb-3">
                <div>
                  <h5 class="fw-bold text-main mb-0">Gastos Registrados</h5>
                  <p class="text-secondary-custom small mb-0 mt-1">Se generan asientos contables automáticos</p>
                </div>
                <button class="btn btn-korange btn-sm rounded-pill px-3 d-flex align-items-center gap-2"
                  data-bs-toggle="modal" data-bs-target="#expenseModal">
                  <Plus :size="16" /> Registrar Gasto
                </button>
              </div>
              <div class="card-body p-0">
                <div class="table-responsive">
                  <table class="table table-custom table-hover-custom mb-0">
                    <thead>
                      <tr>
                        <th class="ps-4">Fecha</th>
                        <th>Categoría</th>
                        <th>Descripción</th>
                        <th>Método Pago</th>
                        <th>Referencia</th>
                        <th class="text-end pe-4">Monto ($)</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr v-if="loading.gastos">
                        <td colspan="6" class="text-center py-5">
                          <span class="spinner-border spinner-border-sm text-korange me-2"></span>Cargando...
                        </td>
                      </tr>
                      <tr v-else-if="gastos.length === 0">
                        <td colspan="6" class="text-center py-5 text-secondary-custom">
                          <Receipt :size="32" class="mb-2 opacity-50" /><br>No hay gastos registrados
                        </td>
                      </tr>
                      <tr v-for="gasto in gastos" :key="gasto.id">
                        <td class="ps-4">{{ gasto.fecha }}</td>
                        <td>
                          <span class="d-flex align-items-center gap-2 text-capitalize">
                            <component :is="getCatIcon(gasto.categoria)" :size="15"
                              :class="getCatColor(gasto.categoria)" />
                            {{ gasto.categoria }}
                          </span>
                        </td>
                        <td class="text-secondary-custom">{{ gasto.descripcion || '—' }}</td>
                        <td class="text-capitalize">{{ gasto.metodo_pago.replace('_', ' ') }}</td>
                        <td class="text-secondary-custom">{{ gasto.referencia || '—' }}</td>
                        <td class="text-end pe-4 fw-bold text-danger">-${{ Number(gasto.monto).toFixed(2) }}</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Modales -->
        <SupplierModal :supplier="selectedSupplier" :loading="saving.supplier" @save="saveSupplier" />
        <PurchaseModal ref="purchaseModalRef" :loading="saving.purchase"
          :suppliers="proveedoresActivos" :ingredients="ingredients" @save="savePurchase" />
        <ExpenseModal :loading="saving.expense" @save="saveExpense" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import Sidebar from '../../../components/Sidebar.vue';
import { useAuth } from '../../../core/composables/useAuth';
import { operationsApi } from '../operations.api';
import { fetchWithAuth } from '../../../core/api/auth.api';
import SupplierModal from '../components/SupplierModal.vue';
import PurchaseModal from '../components/PurchaseModal.vue';
import ExpenseModal from '../components/ExpenseModal.vue';
import {
  Truck, ShoppingBag, Receipt, Plus, Pencil, ShoppingCart,
  UserX, UserCheck, Droplets, Flame, Zap, Wifi, Home,
  CheckCircle, AlertCircle
} from 'lucide-vue-next';

const auth = useAuth();

// ─── State ──────────────────────────────────────────────
const proveedores = ref<any[]>([]);
const compras = ref<any[]>([]);
const gastos = ref<any[]>([]);
const ingredients = ref<any[]>([]);

const loading = ref({ proveedores: false, compras: false, gastos: false });
const saving = ref({ supplier: false, purchase: false, expense: false });

const selectedSupplier = ref<any>(null);
const purchaseModalRef = ref<any>(null);
const toast = ref<{ type: 'success' | 'error'; message: string } | null>(null);

// ─── Helpers ─────────────────────────────────────────────
const proveedoresActivos = computed(() => proveedores.value.filter(p => p.activo));

const gastosCategorias = [
  { value: 'agua', label: 'Agua', icon: Droplets, color: 'text-primary' },
  { value: 'gas', label: 'Gas', icon: Flame, color: 'text-danger' },
  { value: 'electricidad', label: 'Electricidad', icon: Zap, color: 'text-warning' },
  { value: 'internet', label: 'Internet', icon: Wifi, color: 'text-info' },
  { value: 'alquiler', label: 'Alquiler', icon: Home, color: 'text-success' },
  { value: 'otros', label: 'Otros', icon: Receipt, color: 'text-secondary-custom' },
];

const catIconMap: Record<string, any> = {
  agua: Droplets, gas: Flame, electricidad: Zap, internet: Wifi, alquiler: Home, otros: Receipt
};
const catColorMap: Record<string, string> = {
  agua: 'text-primary', gas: 'text-danger', electricidad: 'text-warning',
  internet: 'text-info', alquiler: 'text-success'
};
const getCatIcon = (cat: string) => catIconMap[cat] || Receipt;
const getCatColor = (cat: string) => catColorMap[cat] || '';

const totalPorCategoria = (cat: string) =>
  gastos.value.filter(g => g.categoria === cat)
    .reduce((s, g) => s + Number(g.monto), 0).toFixed(2);

const showToast = (type: 'success' | 'error', message: string) => {
  toast.value = { type, message };
  setTimeout(() => toast.value = null, 3500);
};

const closeModal = (id: string) => {
  // @ts-ignore
  const modal = window.bootstrap?.Modal?.getInstance(document.getElementById(id));
  modal?.hide();
};

// ─── Fetch ───────────────────────────────────────────────
const fetchProveedores = async () => {
  loading.value.proveedores = true;
  try { proveedores.value = (await operationsApi.getProveedores()).data; }
  catch (e: any) { showToast('error', e.message); }
  finally { loading.value.proveedores = false; }
};

const fetchCompras = async () => {
  loading.value.compras = true;
  try { compras.value = (await operationsApi.getCompras()).data; }
  catch (e: any) { showToast('error', e.message); }
  finally { loading.value.compras = false; }
};

const fetchGastos = async () => {
  loading.value.gastos = true;
  try { gastos.value = (await operationsApi.getGastos()).data; }
  catch (e: any) { showToast('error', e.message); }
  finally { loading.value.gastos = false; }
};

const fetchIngredients = async () => {
  try { ingredients.value = (await fetchWithAuth('/inventory')).data; }
  catch (e: any) { console.warn('No se cargaron ingredientes:', e.message); }
};

// ─── Actions ─────────────────────────────────────────────
const saveSupplier = async (data: any) => {
  saving.value.supplier = true;
  try {
    if (selectedSupplier.value?.id) {
      await operationsApi.updateProveedor(selectedSupplier.value.id, data);
      showToast('success', '¡Proveedor actualizado correctamente!');
    } else {
      await operationsApi.createProveedor(data);
      showToast('success', '¡Proveedor registrado correctamente!');
    }
    closeModal('supplierModal');
    await fetchProveedores();
  } catch (e: any) {
    showToast('error', e.message);
  } finally {
    saving.value.supplier = false;
  }
};

const toggleProveedor = async (prov: any) => {
  const accion = prov.activo ? 'desactivar' : 'activar';
  if (!confirm(`¿Deseas ${accion} al proveedor "${prov.nombre}"?`)) return;
  try {
    await operationsApi.updateProveedor(prov.id, { activo: !prov.activo });
    showToast('success', `Proveedor ${accion === 'activar' ? 'activado' : 'desactivado'}`);
    await fetchProveedores();
  } catch (e: any) {
    showToast('error', e.message);
  }
};

const onOpenPurchaseModal = () => {
  if (purchaseModalRef.value) purchaseModalRef.value.resetForm();
};

const savePurchase = async (data: any) => {
  saving.value.purchase = true;
  try {
    await operationsApi.createCompra(data);
    showToast('success', '¡Compra registrada! El stock e inventario han sido actualizados.');
    closeModal('purchaseModal');
    await fetchCompras();
    await fetchIngredients();
  } catch (e: any) {
    showToast('error', e.message);
  } finally {
    saving.value.purchase = false;
  }
};

const saveExpense = async (data: any) => {
  saving.value.expense = true;
  try {
    await operationsApi.createGasto(data);
    showToast('success', '¡Gasto registrado con asiento contable automático!');
    closeModal('expenseModal');
    await fetchGastos();
  } catch (e: any) {
    showToast('error', e.message);
  } finally {
    saving.value.expense = false;
  }
};

// ─── Init ────────────────────────────────────────────────
onMounted(() => {
  fetchProveedores();
  fetchCompras();
  fetchGastos();
  fetchIngredients();
});
</script>

<style scoped>
.operations-wrapper {
  background-color: var(--bg-body);
  min-height: 100vh;
  width: 100%;
}

@media (min-width: 768px) {
  .main-content {
    margin-left: 260px;
    width: calc(100% - 260px);
  }
}

/* Tabs */
.nav-tabs-custom {
  border-bottom: 2px solid var(--border-color);
  gap: 0.25rem;
}
.nav-tabs-custom .nav-link {
  color: var(--text-muted);
  border: none;
  font-weight: 500;
  padding: 0.65rem 1.25rem;
  border-radius: 0.5rem 0.5rem 0 0;
  transition: all 0.2s;
  background: transparent;
}
.nav-tabs-custom .nav-link:hover { color: var(--KOrange); }
.nav-tabs-custom .nav-link.active {
  color: var(--KOrange);
  background: transparent;
  border-bottom: 2px solid var(--KOrange);
  margin-bottom: -2px;
}

/* Toast */
.ops-toast {
  position: fixed;
  top: 1.5rem;
  left: 50%;
  transform: translateX(-50%);
  z-index: 9999;
  display: flex;
  align-items: center;
  gap: 0.6rem;
  padding: 0.85rem 1.5rem;
  border-radius: 0.75rem;
  font-weight: 600;
  font-size: 0.9rem;
  box-shadow: 0 8px 30px rgba(0,0,0,0.15);
  white-space: nowrap;
}
.ops-toast--success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
.ops-toast--error   { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
.toast-slide-enter-active, .toast-slide-leave-active { transition: all 0.3s ease; }
.toast-slide-enter-from, .toast-slide-leave-to { opacity: 0; transform: translateX(-50%) translateY(-20px); }
</style>
