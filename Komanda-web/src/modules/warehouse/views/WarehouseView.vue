<template>
<div class="d-flex w-100">
    <Sidebar :role="auth.user.value?.role || 'admin'" :userName="auth.user.value?.nombre" />

    <div class="view-container py-4 main-content">
        <div class="container-fluid max-w-7xl mx-auto">
            
            <!-- Header -->
            <div class="row mb-4 fade-in">
                <div class="col-12 d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                    <div>
                        <span class="text-korange fw-bold text-uppercase tracking-wider small">Gestión Administrativa</span>
                        <h2 class="display-6 fw-bold mt-2 mb-1 text-primary-custom">Almacén Central</h2>
                        <p class="text-secondary-custom mb-0">
                            Administra el catálogo de ingredientes, ajusta mínimos y controla el stock.
                        </p>
                    </div>
                    <div>
                        <button class="btn btn-korange rounded-pill fw-bold px-4 py-2 shadow-sm pulse-btn d-flex align-items-center gap-2" @click="openCreateModal">
                            <Plus :size="20" /> Nuevo Ingrediente
                        </button>
                    </div>
                </div>
            </div>

            <!-- Cards / Overview -->
            <div class="row mb-4 gx-3 fade-in">
                <div class="col-md-6 mb-3 mb-md-0">
                    <div class="card p-4 border-start border-4 border-korange rounded-4 shadow-sm d-flex justify-content-between h-100 bg-surface-custom transition-transform hover-translate-y">
                        <div>
                            <p class="small text-secondary-custom fw-bold text-uppercase tracking-wider mb-2 d-flex align-items-center gap-2">
                                <Package :size="16" /> Total Catálogo
                            </p>
                            <h2 class="display-6 fw-black text-primary-custom mb-0">{{ ingredientes.length }}</h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card p-4 border-start border-4 border-danger rounded-4 shadow-sm d-flex justify-content-between h-100 bg-surface-custom transition-transform hover-translate-y">
                        <div>
                            <p class="small text-danger fw-bold text-uppercase tracking-wider mb-2 d-flex align-items-center gap-2">
                                <AlertTriangle :size="16" /> Alertas de Stock
                            </p>
                            <h2 class="display-6 fw-black text-primary-custom mb-0">{{ stockCriticoCount }}
                                <span class="fs-6 fw-medium text-secondary-custom ms-1">ítems críticos</span>
                            </h2>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tabla de Stock -->
            <div class="bg-surface-custom rounded-4 shadow-sm border border-custom overflow-hidden fade-in">
                <div class="p-4 bg-white">
                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                        <div class="search-box position-relative shadow-sm rounded-pill w-100" style="max-width: 400px;">
                            <Search class="position-absolute top-50 start-0 translate-middle-y ms-3 text-secondary" :size="18" />
                            <input v-model="searchQuery" type="text" class="form-control ps-5 py-2 rounded-pill custom-input bg-light border-0"
                                placeholder="Buscar en el catálogo...">
                        </div>
                        
                        <div class="d-flex gap-2">
                            <button class="btn rounded-pill px-3 py-1 fw-medium border shadow-sm text-sm" 
                                    :class="filterStatus === 'all' ? 'btn-dark text-white' : 'btn-light'"
                                    @click="filterStatus = 'all'">Todos</button>
                            <button class="btn rounded-pill px-3 py-1 fw-medium border shadow-sm text-sm" 
                                    :class="filterStatus === 'critical' ? 'btn-danger text-white' : 'btn-light text-danger'"
                                    @click="filterStatus = 'critical'">Críticos</button>
                            <button class="btn rounded-pill px-3 py-1 fw-medium border shadow-sm text-sm" 
                                    :class="filterStatus === 'normal' ? 'btn-success text-white' : 'btn-light text-success'"
                                    @click="filterStatus = 'normal'">Normal</button>
                        </div>
                    </div>

                    <div class="table-responsive rounded-3 border">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light text-uppercase small text-secondary fw-bold">
                                <tr>
                                    <th class="px-4 py-3">Insumo</th>
                                    <th class="px-4 py-3 text-end">Stock Actual</th>
                                    <th class="px-4 py-3 text-end">Stock Mínimo</th>
                                    <th class="px-4 py-3 text-center">Estado</th>
                                    <th class="px-4 py-3 text-end">Costo (CPP)</th>
                                    <th class="px-4 py-3 text-center">Ajustes</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-if="loading">
                                    <td colspan="6" class="text-center py-5">
                                        <span class="spinner-border spinner-border-sm text-korange me-2"></span>Cargando catálogo...
                                    </td>
                                </tr>
                                <tr v-else-if="filteredIngredientes.length === 0">
                                    <td colspan="6" class="text-center py-5 text-secondary">
                                        No se encontraron resultados.
                                    </td>
                                </tr>
                                <IngredientRow 
                                    v-for="item in filteredIngredientes" 
                                    :key="item.id" 
                                    :item="item" 
                                    @edit="openEditModal" 
                                />
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <IngredientFormModal 
            :show="showModal"
            :ingrediente="selectedIngredient"
            :unidades="unidades"
            :loading="saving"
            @close="showModal = false"
            @save="handleSave"
        />

        <!-- Toast -->
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

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { Search, AlertTriangle, Plus, Package } from 'lucide-vue-next';
import Sidebar from '../../../components/Sidebar.vue';
import { useAuth } from '../../../core/composables/useAuth';
import { useWarehouse } from '../useWarehouse';
import IngredientRow from '../components/IngredientRow.vue';
import IngredientFormModal from '../components/IngredientFormModal.vue';

const auth = useAuth();
const { ingredientes, unidades, loading, stockCriticoCount, fetchAll, fetchUnidades, createIngredient, updateIngredient } = useWarehouse();

const searchQuery = ref('');
const filterStatus = ref<'all' | 'critical' | 'normal'>('all');

const showModal = ref(false);
const selectedIngredient = ref<any>(null);
const saving = ref(false);

const toast = ref<{ type: 'success' | 'error', message: string } | null>(null);
const showToast = (type: 'success' | 'error', message: string) => {
    toast.value = { type, message };
    setTimeout(() => toast.value = null, 3500);
};

onMounted(() => {
    fetchAll();
    fetchUnidades();
});

const filteredIngredientes = computed(() => {
    let result = ingredientes.value;

    if (filterStatus.value === 'critical') {
        result = result.filter(i => i.alerta_critica);
    } else if (filterStatus.value === 'normal') {
        result = result.filter(i => !i.alerta_critica);
    }

    if (searchQuery.value) {
        const q = searchQuery.value.toLowerCase();
        result = result.filter(i => i.nombre.toLowerCase().includes(q));
    }

    return result;
});

const openCreateModal = () => {
    selectedIngredient.value = null;
    showModal.value = true;
};

const openEditModal = (item: any) => {
    selectedIngredient.value = item;
    showModal.value = true;
};

const handleSave = async (formData: any) => {
    saving.value = true;
    try {
        if (selectedIngredient.value) {
            await updateIngredient(selectedIngredient.value.id, {
                unidad_id: formData.unidad_id,
                cantidad_minima: formData.cantidad_minima,
                merma_teorica_porcentaje: formData.merma_teorica_porcentaje
            });
            showToast('success', 'Ingrediente actualizado correctamente');
        } else {
            await createIngredient(formData);
            showToast('success', 'Ingrediente creado correctamente');
        }
        showModal.value = false;
    } catch (e: any) {
        showToast('error', e.message);
    } finally {
        saving.value = false;
    }
};
</script>

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

.border-korange { border-color: var(--KOrange) !important; }
.text-korange { color: var(--KOrange) !important; }

.hover-translate-y:hover {
    transform: translateY(-3px);
    box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1) !important;
    transition: transform 0.2s, box-shadow 0.2s;
}

.fade-in { animation: fadeIn 0.4s ease-out; }
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}

.pulse-btn { transition: transform 0.2s; }
.pulse-btn:active { transform: scale(0.95); }
</style>
