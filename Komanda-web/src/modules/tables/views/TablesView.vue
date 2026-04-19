<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { LayoutGrid, Plus, Users, Trash2, Edit2, AlertCircle } from 'lucide-vue-next';
import Sidebar from '../../../components/Sidebar.vue';
import { useAuth } from '../../../core/composables/useAuth';
import { tablesApi } from '../tables.api';
import TableModal from '../components/TableModal.vue';

const auth = useAuth();
const toast = ref<{ type: 'success' | 'error', message: string } | null>(null);
const showToast = (type: 'success' | 'error', message: string) => {
    toast.value = { type, message };
    setTimeout(() => toast.value = null, 3500);
};

const tables = ref<any[]>([]);
const loading = ref(false);
const saving = ref(false);

const selectedTable = ref<any>(null);
const tableModalRef = ref<any>(null);

const fetchTables = async () => {
    loading.value = true;
    try {
        const response = await tablesApi.getTables();
        tables.value = response.data || [];
    } catch (e: any) {
        showToast('error', 'Error al cargar las mesas: ' + e.message);
    } finally {
        loading.value = false;
    }
};

onMounted(() => {
    fetchTables();
});

const getStatusBadgeClass = (status: string) => {
    switch(status) {
        case 'libre': return 'bg-success-subtle text-success border border-success border-opacity-25';
        case 'ocupada': return 'bg-danger-subtle text-danger border border-danger border-opacity-25';
        case 'reservada': return 'bg-warning-subtle text-warning border border-warning border-opacity-50';
        case 'inactiva': return 'bg-secondary-subtle text-secondary border border-secondary border-opacity-25';
        default: return 'bg-light text-dark';
    }
};

const openCreateModal = () => {
    selectedTable.value = null;
    if (tableModalRef.value) tableModalRef.value.resetForm();
};

const openEditModal = (table: any) => {
    selectedTable.value = { ...table };
};

const saveTable = async (data: any) => {
    saving.value = true;
    try {
        if (selectedTable.value && selectedTable.value.id) {
            await tablesApi.updateTable(selectedTable.value.id, data);
            showToast('success', 'Mesa actualizada exitosamente');
        } else {
            await tablesApi.createTable(data);
            showToast('success', 'Mesa creada exitosamente');
        }
        
        // @ts-ignore
        const modal = window.bootstrap?.Modal?.getInstance(document.getElementById('tableModal'));
        modal?.hide();
        
        fetchTables();
    } catch (e: any) {
        showToast('error', e.message);
    } finally {
        saving.value = false;
    }
};

const deleteTable = async (table: any) => {
    if (!confirm(`¿Estás seguro de eliminar la Mesa ${table.numero}?`)) return;
    try {
        await tablesApi.deleteTable(table.id);
        showToast('success', 'Mesa procesada correctamente');
        fetchTables();
    } catch (e: any) {
        showToast('error', e.message);
    }
};

const isAdmin = computed(() => ['admin'].includes(auth.user.value?.role || ''));

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
                        <span class="text-korange fw-bold text-uppercase tracking-wider small">Distribución de Espacio</span>
                        <h2 class="display-6 fw-bold mt-2 mb-1 text-primary-custom">Mesas y Zonas</h2>
                        <p class="text-secondary-custom mb-0">
                            Administra la disponibilidad y capacidad de las mesas de tu restaurante.
                        </p>
                    </div>
                    <div v-if="isAdmin">
                        <button class="btn btn-korange rounded-pill fw-bold px-4 py-2 shadow-sm pulse-btn d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#tableModal" @click="openCreateModal">
                            <Plus :size="20" /> Nueva Mesa
                        </button>
                    </div>
                </div>
            </div>

            <!-- Loading State -->
            <div v-if="loading" class="text-center py-5">
                <div class="spinner-border text-korange" role="status"></div>
                <p class="mt-2 text-secondary-custom small">Cargando mesas...</p>
            </div>

            <!-- Empty State -->
            <div v-else-if="tables.length === 0" class="text-center py-5 bg-surface-custom rounded-4 border border-color shadow-sm fade-in">
                <LayoutGrid :size="48" class="text-secondary-custom mb-3 opacity-50" />
                <h5 class="fw-bold text-primary-custom">No hay mesas registradas</h5>
                <p class="text-secondary-custom small mb-4">Comienza agregando las mesas de tu local para empezar a tomar pedidos.</p>
                <button v-if="isAdmin" class="btn btn-outline-korange rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#tableModal" @click="openCreateModal">
                    Agregar Primera Mesa
                </button>
            </div>

            <!-- Grid de Mesas -->
            <div v-else class="row g-4 fade-in">
                <div class="col-12 col-sm-6 col-md-4 col-lg-3" v-for="table in tables" :key="table.id">
                    <div class="card h-100 bg-surface-custom rounded-4 border border-color shadow-sm table-card transition-transform hover-translate-y position-relative overflow-hidden">
                        
                        <!-- Header de Tarjeta (Estado) -->
                        <div class="card-header border-0 bg-transparent pt-3 pb-0 d-flex justify-content-between align-items-center">
                            <span class="badge rounded-pill text-capitalize px-3 py-1 fw-bold" :class="getStatusBadgeClass(table.estado)">
                                {{ table.estado }}
                            </span>
                            <div class="dropdown" v-if="isAdmin">
                                <button class="btn btn-sm btn-link text-secondary-custom p-0" type="button" data-bs-toggle="dropdown">
                                    <Edit2 :size="16" />
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0">
                                    <li><a class="dropdown-item fw-semibold" href="#" data-bs-toggle="modal" data-bs-target="#tableModal" @click="openEditModal(table)">Editar Mesa</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item text-danger fw-semibold" href="#" @click.prevent="deleteTable(table)">Eliminar Mesa</a></li>
                                </ul>
                            </div>
                        </div>

                        <div class="card-body text-center d-flex flex-column justify-content-center py-4">
                            <div class="table-icon-wrapper mx-auto mb-3 d-flex align-items-center justify-content-center rounded-circle" :class="'icon-bg-' + table.estado">
                                <h1 class="display-5 fw-black text-main mb-0">{{ table.numero }}</h1>
                            </div>
                            <h5 class="fw-bold text-primary-custom mb-1 text-truncate px-2">{{ table.nombre || `Mesa ${table.numero}` }}</h5>
                            <p class="text-secondary-custom small mb-0 d-flex align-items-center justify-content-center gap-1">
                                <Users :size="14" /> {{ table.capacidad }} Personas
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <TableModal ref="tableModalRef" :table="selectedTable" :loading="saving" @save="saveTable" />

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

.table-card {
    transition: all 0.2s ease-in-out;
}
.hover-translate-y:hover {
    transform: translateY(-5px);
    box-shadow: 0 .5rem 1rem rgba(0,0,0,.1) !important;
}

.table-icon-wrapper {
    width: 80px;
    height: 80px;
    border: 3px solid var(--border-color);
}
.icon-bg-libre { background-color: rgba(25, 135, 84, 0.05); border-color: rgba(25, 135, 84, 0.2); }
.icon-bg-ocupada { background-color: rgba(220, 53, 69, 0.05); border-color: rgba(220, 53, 69, 0.2); }
.icon-bg-reservada { background-color: rgba(255, 193, 7, 0.05); border-color: rgba(255, 193, 7, 0.2); }
.icon-bg-inactiva { background-color: rgba(108, 117, 125, 0.05); border-color: rgba(108, 117, 125, 0.2); }

.bg-surface-custom { background-color: var(--bg-surface, #ffffff); }
.text-primary-custom { color: var(--text-primary, #212529); }
.text-secondary-custom { color: var(--text-muted, #6c757d); }
.border-color { border-color: var(--border-color, #dee2e6) !important; }
.text-main { color: var(--text-primary); }

.btn-korange { background-color: var(--KOrange); border: none; color: white; }
.btn-korange:hover { background-color: #e06d0e; color: white; }
.btn-outline-korange { border-color: var(--KOrange); color: var(--KOrange); }
.btn-outline-korange:hover { background-color: var(--KOrange); color: white; }
.text-korange { color: var(--KOrange) !important; }
</style>
