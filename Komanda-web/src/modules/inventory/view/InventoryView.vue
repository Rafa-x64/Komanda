<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { Search, AlertTriangle, Edit2, TrendingDown, ShoppingCart } from 'lucide-vue-next';
import Sidebar from '../../../components/Sidebar.vue';
import { useAuth } from '../../../core/composables/useAuth';
import { inventoryApi } from '../inventory.api';
import { operationsApi } from '../../operations/operations.api';
import EditIngredientModal from '../components/EditIngredientModal.vue';
import MermaModal from '../components/MermaModal.vue';
import PurchaseModal from '../../operations/components/PurchaseModal.vue';

const auth = useAuth();
const router = useRouter();
const toast = ref<{ type: 'success' | 'error', message: string } | null>(null);
const showToast = (type: 'success' | 'error', message: string) => {
    toast.value = { type, message };
    setTimeout(() => toast.value = null, 3500);
};

const activeTab = ref('stock');
const searchQuery = ref('');

// Datos
const ingredientes = ref<any[]>([]);
const mermas = ref<any[]>([]);
const proveedores = ref<any[]>([]);
const loading = ref({ stock: false, mermas: false });

// Modales
const showEditModal = ref(false);
const showMermaModal = ref(false);
const selectedIngredient = ref<any>(null);
const savingPurchase = ref(false);
const purchaseModalRef = ref<any>(null);

const fetchIngredientes = async () => {
    loading.value.stock = true;
    try {
        const response = await inventoryApi.getIngredients();
        ingredientes.value = response.data || [];
    } catch (e: any) {
        showToast('error', 'Error cargando stock: ' + e.message);
    } finally {
        loading.value.stock = false;
    }
};

const fetchMermas = async () => {
    loading.value.mermas = true;
    try {
        const response = await inventoryApi.getMermas();
        mermas.value = response.data || [];
    } catch (e: any) {
        showToast('error', 'Error cargando mermas: ' + e.message);
    } finally {
        loading.value.mermas = false;
    }
};

const fetchProveedores = async () => {
    try { proveedores.value = (await operationsApi.getProveedores()).data; }
    catch (e: any) { showToast('error', 'Error cargando proveedores: ' + e.message); }
};

onMounted(() => {
    fetchIngredientes();
    fetchMermas();
    fetchProveedores();
});

// Computed para Stock
const filteredIngredientes = computed(() => {
    if (!searchQuery.value) return ingredientes.value;
    return ingredientes.value.filter(i => i.nombre.toLowerCase().includes(searchQuery.value.toLowerCase()));
});

const criticalItemsCount = computed(() => {
    return ingredientes.value.filter(i => Number(i.cantidad_disponible) <= Number(i.cantidad_minima)).length;
});

const totalItems = computed(() => ingredientes.value.length);

const isStockBajo = (item: any) => Number(item.cantidad_disponible) <= Number(item.cantidad_minima);

// Acciones Modales
const openEditModal = (item: any) => {
    selectedIngredient.value = item;
    showEditModal.value = true;
};

const handleSaveIngredient = async (formData: any) => {
    try {
        await inventoryApi.updateIngredient(selectedIngredient.value.id, formData);
        showToast('success', 'Insumo actualizado exitosamente');
        showEditModal.value = false;
        fetchIngredientes();
    } catch (e: any) {
        showToast('error', e.message);
    }
};

const handleSaveMerma = async (formData: any) => {
    try {
        await inventoryApi.createMerma(formData);
        showToast('success', 'Merma registrada exitosamente. Stock actualizado.');
        showMermaModal.value = false;
        fetchIngredientes();
        fetchMermas();
    } catch (e: any) {
        showToast('error', e.message);
    }
};

const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleString('es-ES', { 
        year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit'
    });
};

const onOpenPurchaseModal = () => {
    if (purchaseModalRef.value) purchaseModalRef.value.resetForm();
};

const handleSavePurchase = async (data: any) => {
    savingPurchase.value = true;
    try {
        await operationsApi.createCompra(data);
        showToast('success', '¡Compra registrada! Redirigiendo a Operaciones...');
        
        // @ts-ignore
        const modal = window.bootstrap?.Modal?.getInstance(document.getElementById('purchaseModal'));
        modal?.hide();
        
        setTimeout(() => {
            router.push('/operaciones');
        }, 1500);
    } catch (e: any) {
        showToast('error', e.message);
    } finally {
        savingPurchase.value = false;
    }
};
</script>

<template>
<div class="d-flex w-100">
    <Sidebar :role="auth.user.value?.role || 'admin'" :userName="auth.user.value?.nombre" />

    <div class="view-container py-4 main-content">
        <div class="container-fluid max-w-7xl mx-auto">
            
            <!-- Header -->
        <div class="row mb-4 fade-in">
            <div class="col-12 d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                <div>
                    <span class="text-korange fw-bold text-uppercase tracking-wider small">Komanda Almacén</span>
                    <h2 class="display-6 fw-bold mt-2 mb-1 text-primary-custom">Control de Inventario</h2>
                    <p class="text-secondary-custom mb-0">
                        Monitorea el stock actual y registra ajustes por mermas o pérdidas.
                    </p>
                </div>
                <div>
                    <button class="btn btn-korange rounded-pill fw-bold px-4 py-2 shadow-sm pulse-btn d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#purchaseModal" @click="onOpenPurchaseModal">
                        <ShoppingCart :size="20" /> Registrar Compra
                    </button>
                </div>
            </div>
        </div>

        <!-- Cards / Overview -->
        <div class="row mb-4 gx-3 fade-in">
            <div class="col-md-6 mb-3 mb-md-0">
                <div class="card p-4 border-start border-4 border-korange rounded-4 shadow-sm d-flex justify-content-between h-100 bg-surface-custom transition-transform hover-translate-y">
                    <div>
                        <p class="small text-secondary-custom fw-bold text-uppercase tracking-wider mb-2">Total Insumos</p>
                        <h2 class="display-6 fw-black text-primary-custom mb-0">{{ totalItems }}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card p-4 border-start border-4 border-danger rounded-4 shadow-sm d-flex justify-content-between h-100 bg-surface-custom transition-transform hover-translate-y">
                    <div>
                        <p class="small text-danger fw-bold text-uppercase tracking-wider mb-2 d-flex align-items-center gap-2">
                            <AlertTriangle :size="16" /> Stock Crítico
                        </p>
                        <h2 class="display-6 fw-black text-primary-custom mb-0">{{ criticalItemsCount }}
                            <span class="fs-6 fw-medium text-secondary-custom ms-1">requieren atención</span>
                        </h2>
                    </div>
                </div>
            </div>
        </div>

        <!-- Navegación por pestañas -->
        <div class="bg-surface-custom rounded-4 shadow-sm border border-custom overflow-hidden fade-in">
            <ul class="nav nav-tabs px-4 pt-3 border-bottom-0 custom-tabs">
                <li class="nav-item">
                    <a class="nav-link fw-bold px-4 py-3 cursor-pointer" 
                       :class="{ 'active': activeTab === 'stock' }" 
                       @click="activeTab = 'stock'">
                       Stock Actual
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link fw-bold px-4 py-3 cursor-pointer" 
                       :class="{ 'active': activeTab === 'mermas' }" 
                       @click="activeTab = 'mermas'">
                       Registro de Mermas
                    </a>
                </li>
            </ul>

            <div class="p-4 bg-white">
                
                <!-- TAB STOCK -->
                <div v-if="activeTab === 'stock'">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="search-box position-relative shadow-sm rounded-pill w-100" style="max-width: 400px;">
                            <Search class="position-absolute top-50 start-0 translate-middle-y ms-3 text-secondary" :size="18" />
                            <input v-model="searchQuery" type="text" class="form-control ps-5 py-2 rounded-pill custom-input bg-light border-0"
                                placeholder="Buscar insumo...">
                        </div>
                    </div>

                    <div class="table-responsive rounded-3 border">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light text-uppercase small text-secondary fw-bold">
                                <tr>
                                    <th class="px-4 py-3">Insumo</th>
                                    <th class="px-4 py-3 text-end">Disponible</th>
                                    <th class="px-4 py-3 text-end">Mínimo</th>
                                    <th class="px-4 py-3 text-center">Estado</th>
                                    <th class="px-4 py-3 text-end">Costo Prom.</th>
                                    <th class="px-4 py-3 text-center">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-if="loading.stock">
                                    <td colspan="6" class="text-center py-5">
                                        <span class="spinner-border spinner-border-sm text-korange me-2"></span>Cargando...
                                    </td>
                                </tr>
                                <tr v-else-if="filteredIngredientes.length === 0">
                                    <td colspan="6" class="text-center py-5 text-secondary">
                                        No se encontraron insumos.
                                    </td>
                                </tr>
                                <tr v-for="item in filteredIngredientes" :key="item.id" :class="{'bg-danger bg-opacity-10': isStockBajo(item)}">
                                    <td class="px-4 fw-bold">{{ item.nombre }}</td>
                                    <td class="px-4 text-end fw-bold fs-6">
                                        {{ item.cantidad_disponible }} <span class="text-muted small">{{ item.unidad_nombre || 'Ud.' }}</span>
                                    </td>
                                    <td class="px-4 text-end text-muted">{{ item.cantidad_minima }}</td>
                                    <td class="px-4 text-center">
                                        <span class="badge rounded-pill px-3" :class="isStockBajo(item) ? 'bg-danger text-white' : 'bg-success bg-opacity-10 text-success'">
                                            {{ isStockBajo(item) ? 'Stock Bajo' : 'Normal' }}
                                        </span>
                                    </td>
                                    <td class="px-4 text-end fw-medium text-secondary">
                                        ${{ Number(item.costo_promedio).toFixed(2) }}
                                    </td>
                                    <td class="px-4 text-center">
                                        <button class="btn btn-sm text-primary hover-bg-light rounded-circle p-2" @click="openEditModal(item)" title="Editar">
                                            <Edit2 :size="16" />
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- TAB MERMAS -->
                <div v-if="activeTab === 'mermas'">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <p class="text-secondary mb-0">Historial de mermas y ajustes registrados.</p>
                        <button class="btn btn-danger rounded-pill fw-bold px-4 d-inline-flex gap-2 align-items-center shadow-sm pulse-btn" @click="showMermaModal = true">
                            <TrendingDown :size="18" /> Registrar Merma
                        </button>
                    </div>

                    <div class="table-responsive rounded-3 border">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light text-uppercase small text-secondary fw-bold">
                                <tr>
                                    <th class="px-4 py-3">Fecha</th>
                                    <th class="px-4 py-3">Insumo</th>
                                    <th class="px-4 py-3 text-center">Tipo</th>
                                    <th class="px-4 py-3">Motivo</th>
                                    <th class="px-4 py-3 text-end text-danger">Cantidad Descontada</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-if="loading.mermas">
                                    <td colspan="5" class="text-center py-5">
                                        <span class="spinner-border spinner-border-sm text-korange me-2"></span>Cargando...
                                    </td>
                                </tr>
                                <tr v-else-if="mermas.length === 0">
                                    <td colspan="5" class="text-center py-5 text-secondary">
                                        No hay mermas registradas.
                                    </td>
                                </tr>
                                <tr v-for="merma in mermas" :key="merma.id">
                                    <td class="px-4 text-muted small">{{ formatDate(merma.created_at) }}</td>
                                    <td class="px-4 fw-bold">{{ merma.ingrediente_nombre }}</td>
                                    <td class="px-4 text-center">
                                        <span class="badge bg-secondary bg-opacity-10 text-secondary text-uppercase">{{ merma.tipo }}</span>
                                    </td>
                                    <td class="px-4 text-muted">{{ merma.razon || 'N/A' }}</td>
                                    <td class="px-4 text-end fw-bold text-danger">
                                        -{{ merma.cantidad }}
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </div>

    </div>

    <!-- Modales -->
    <EditIngredientModal 
        :show="showEditModal" 
        :ingrediente="selectedIngredient" 
        @close="showEditModal = false" 
        @save="handleSaveIngredient" 
    />

    <MermaModal 
        :show="showMermaModal" 
        :ingredientes="ingredientes" 
        @close="showMermaModal = false" 
        @save="handleSaveMerma" 
    />

    <PurchaseModal 
        ref="purchaseModalRef" 
        :loading="savingPurchase" 
        :suppliers="proveedores" 
        :ingredients="ingredientes"
        @save="handleSavePurchase" 
    />

    <!-- Toast Notification -->
    <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1060">
        <div v-if="toast" class="toast show align-items-center text-white border-0" :class="toast.type === 'success' ? 'bg-success' : 'bg-danger'" role="alert">
            <div class="d-flex">
                <div class="toast-body fw-medium">
                    <span v-if="toast.type === 'success'">✅</span>
                    <span v-else>⚠️</span>
                    {{ toast.message }}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" @click="toast = null" aria-label="Close"></button>
            </div>
        </div>
        </div>
    </div>
</div>
</template>

<style scoped>
.view-container {
    background-color: var(--bg-body, #f8f9fa);
    min-height: calc(100vh - 100px);
    width: 100%;
}
@media (min-width: 768px) {
  .main-content {
    margin-left: 260px;
    width: calc(100% - 260px);
  }
}
.max-w-7xl { max-width: 1200px; }
.bg-surface-custom { background-color: #ffffff; }
.text-primary-custom { color: #212529; }
.text-secondary-custom { color: #6c757d; }
.tracking-wider { letter-spacing: 1px; }

.custom-tabs .nav-link {
    color: #6c757d;
    border: none;
    border-bottom: 3px solid transparent;
    transition: all 0.2s;
}
.custom-tabs .nav-link:hover {
    color: var(--KOrange);
    background-color: rgba(255, 102, 0, 0.05);
}
.custom-tabs .nav-link.active {
    color: var(--KOrange);
    border-bottom: 3px solid var(--KOrange);
    background-color: transparent;
}

.border-korange { border-color: var(--KOrange) !important; }
.text-korange { color: var(--KOrange) !important; }

.hover-translate-y:hover {
    transform: translateY(-3px);
    box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1) !important;
}
.cursor-pointer { cursor: pointer; }
.hover-bg-light:hover { background-color: #f8f9fa; }

.fade-in { animation: fadeIn 0.4s ease-out; }
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}

.pulse-btn {
    transition: transform 0.2s;
}
.pulse-btn:active {
    transform: scale(0.95);
}
</style>