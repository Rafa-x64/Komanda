<script setup>
import { ref, computed, onMounted } from 'vue';
import { PlusCircle, Search, ArrowLeft, Tags } from 'lucide-vue-next';
import { fetchWithAuth } from '../../../core/api/auth.api';

// Aquí definimos los datos que la tabla va a mostrar provenientes de la bd
const inventory = ref([]);

const fetchInventory = async () => {
    try {
        const response = await fetchWithAuth('/inventory');
        inventory.value = response.data.map(item => ({
            id: item.id,
            name: item.nombre,
            category: item.categoria || 'General',
            quantity: item.cantidad_disponible,
            minStock: item.cantidad_minima,
            unit: 'Kg', // fallback de UI
            expiryDate: item.fecha_caducidad
        }));
    } catch (error) {
        console.error('Error cargando inventario', error);
    }
};

onMounted(() => {
    fetchInventory();
});

const searchQuery = ref('');

// Vista actual: 'inventory' | 'purchaseForm'
const currentView = ref('inventory');

// Buscador
const filteredInventory = computed(() => {
    return inventory.value.filter(item => 
        item.name.toLowerCase().includes(searchQuery.value.toLowerCase()) || 
        item.category.toLowerCase().includes(searchQuery.value.toLowerCase())
    );
});

// Fechas — usamos la fecha real del sistema
const today = new Date();
const isExpiringSoon = (dateStr) => {
    if (!dateStr) return false;
    const expDate = new Date(dateStr);
    const diffTime = expDate.getTime() - today.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays <= 7; 
};

// Acciones
const editItem = (id) => alert('Editar item ' + id);
const deleteItem = (id) => {
if (confirm('¿Seguro de eliminar este insumo?')) {
    inventory.value = inventory.value.filter(item => item.id !== id);
}
};

// Categorías
const categorias = ref([
    { id: 1, name: 'Secos' },
    { id: 2, name: 'Lácteos' },
    { id: 3, name: 'Vegetales' },
    { id: 4, name: 'Carnes' },
    { id: 5, name: 'Bebidas' }
]);
const newCategoryName = ref('');

const addCategory = () => {
    if (!newCategoryName.value.trim()) return;
    categorias.value.push({
        id: Date.now(),
        name: newCategoryName.value.trim()
    });
    newCategoryName.value = '';
};

const deleteCategory = (id) => {
    if(confirm('¿Seguro de eliminar esta categoría?')) {
        categorias.value = categorias.value.filter(c => c.id !== id);
    }
};

const openCategories = () => {
    currentView.value = 'categories';
};

const backToPurchaseForm = () => {
    currentView.value = 'purchaseForm';
};

// Compras — price incluido para CPP (Regla 1 del enunciado)
const purchaseItems = ref([
    { name: '', quantity: null, price: null, unit: 'Kg', category: '', expiryDate: '' }
]);

const openPurchaseForm = () => {
    currentView.value = 'purchaseForm';
};

const goBack = () => {
    currentView.value = 'inventory';
    purchaseItems.value = [{ name: '', quantity: null, price: null, unit: 'Kg', category: '', expiryDate: '' }];
};

const addPurchaseRow = () => {
    purchaseItems.value.push({ name: '', quantity: null, price: null, unit: 'Kg', category: '', expiryDate: '' });
};

const removePurchaseRow = (index) => {
    if (purchaseItems.value.length > 1) {
        purchaseItems.value.splice(index, 1);
    }
};

const handleNameInput = (row) => {
    if (!row.name) return;
    const existing = inventory.value.find(item => item.name.toLowerCase() === row.name.toLowerCase());
    if (existing) {
        row.category = existing.category;
        row.unit = existing.unit;
    }
};

const processPurchase = async () => {
    const validItems = purchaseItems.value.filter(item => item.name && item.quantity);
    
    if (validItems.length === 0) {
        alert('Llena los campos obligatorios (Nombre y Cantidad) de al menos un insumo.');
        return;
    }

    try {
        await fetchWithAuth('/inventory/purchase', {
            method: 'POST',
            body: JSON.stringify({ items: validItems })
        });
        alert('Compra(s) agregada(s) al inventario exitosamente');
        await fetchInventory(); // Refrescar los datos del backend
        goBack();
    } catch (error) {
        alert('Error registrando compra: ' + error.message);
    }
};

// Estas funciones ayudan a que los colores funcionen
const statusText = (item) => (item.quantity <= item.minStock ? 'Stock Bajo' : 'Normal');
const statusClass = (item) => (item.quantity <= item.minStock ? 'text-red-500 font-bold' : 'text-green-500 font-medium');

const criticalItemsCount = computed(() => {
    return inventory.value.filter(item => item.quantity <= item.minStock).length;
});
</script>

<template>
<div class="view-container py-4">
    <div class="container-fluid max-w-7xl mx-auto">
        
        <!-- Headings mimicking Landing Page -->
        <div v-if="currentView === 'inventory'" class="row justify-content-center mb-5 mt-3 fade-in">
        <div class="col-lg-10 text-center">
            <span class="text-korange fw-bold text-uppercase tracking-wider small">Komanda Almacén</span>
            <h2 class="display-5 fw-bold mt-2 mb-3 text-primary-custom">Gestión de Inventario</h2>
            <p class="lead text-secondary-custom">
            Controla tu stock al instante, registra tus compras y recibe alertas de insumos críticos o próximos a caducar.
            </p>
        </div>
        </div>

        <transition name="slide-fade" mode="out-in">
        <!-- Vista de Inventario Principal -->
        <div v-if="currentView === 'inventory'" key="inventory">
        
        <!-- Action Bar -->
        <div class="row mb-5 gx-3 justify-content-between align-items-center">
            <div class="col-md-6 order-2 order-md-1 mt-3 mt-md-0">
                <div class="search-box position-relative shadow-sm rounded-pill transition-transform">
                    <Search class="position-absolute top-50 start-0 translate-middle-y ms-4 text-korange" :size="20" />
                    <input v-model="searchQuery" type="text" class="form-control ps-5 py-3 rounded-pill custom-input bg-surface-custom border-0"
                    placeholder="Buscar insumo por nombre o categoría...">
                </div>
            </div>
            <div class="col-md-auto text-end order-1 order-md-2 d-flex flex-column flex-md-row">
                <button
                    class="btn-korange px-4 py-2 rounded-pill fw-bold d-inline-flex justify-content-center align-items-center gap-2 shadow-sm pulse-btn w-100"
                    @click="openPurchaseForm">
                    <PlusCircle :size="20" /> Registrar Compra
                </button>
            </div>
        </div>

        <!-- Cards / Overview -->
        <div class="row mb-5">
            <div class="col-md-4">
                <div class="card p-4 border-start border-4 border-korange rounded-4 shadow-sm d-flex justify-content-between h-100 transition-transform hover-translate-y" style="background-color: var(--bg-surface)">
                    <div>
                        <p class="small text-secondary-custom fw-bold text-uppercase tracking-wider mb-2">Stock Crítico</p>
                        <h2 class="display-5 fw-black text-primary-custom mb-0">{{ criticalItemsCount }}
                            <span class="fs-5 fw-medium text-korange ms-1">ítems</span>
                        </h2>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tabla de Inventario -->
        <div class="row">
            <div class="col-12">
                <div class="shadow-sm rounded-4 overflow-hidden border border-custom bg-surface-custom p-2">
                <div class="table-responsive">
                    <table class="table table-custom table-hover-custom table-hover-orange mb-0 w-100 align-middle">
                        <thead class="text-uppercase small tracking-wider text-secondary-custom fw-bold">
                            <tr>
                                <th class="px-4 py-3 border-bottom text-korange">Insumo</th>
                                <th class="px-4 py-3 border-bottom">Categoría</th>
                                <th class="px-4 py-3 border-bottom">Cantidad</th>
                                <th class="px-4 py-3 border-bottom">Min. Stock</th>
                                <th class="px-4 py-3 border-bottom">Caducidad</th>
                                <th class="px-4 py-3 border-bottom">Estado</th>
                                <th class="px-4 py-3 border-bottom text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="item in filteredInventory" :key="item.id" 
                                :class="{'bg-danger-subtle': isExpiringSoon(item.expiryDate)}"
                                class="transition-colors hover-bg-light">
                                <td class="px-4 py-3 fw-bold text-primary-custom">{{ item.name }}</td>
                                <td class="px-4 py-3 fw-medium text-primary-custom">
                                    <span class="badge text-dark bg-light border text-secondary-custom">{{ item.category }}</span>
                                </td>
                                <td class="px-4 py-3 fw-bold text-primary-custom fs-5">{{ item.quantity }} <span class="fs-6 fw-medium text-secondary-custom">{{ item.unit }}</span></td>
                                <td class="px-4 py-3 fw-medium text-secondary-custom">{{ item.minStock }}</td>
                                <td class="px-4 py-3">
                                    <div v-if="item.expiryDate" :class="{'text-danger fw-bold bg-danger-subtle px-2 py-1 rounded small': isExpiringSoon(item.expiryDate), 'text-secondary-custom fw-medium': !isExpiringSoon(item.expiryDate)}">
                                        {{ item.expiryDate }} {{ isExpiringSoon(item.expiryDate) ? '(Pronto)' : '' }}
                                    </div>
                                    <span v-else class="text-muted small fst-italic">Sin fecha</span>
                                </td>
                                <td class="px-4 py-3">
                                    <span :class="statusClass(item)" class="badge bg-light border text-dark">{{ statusText(item) }}</span>
                                </td>
                                <td class="px-4 py-3 text-center text-nowrap">
                                    <button @click="editItem(item.id)" class="btn btn-sm text-korange fw-medium me-2 hover-bg-orange rounded-3">Editar</button>
                                    <button @click="deleteItem(item.id)" class="btn btn-sm text-danger fw-medium hover-bg-danger rounded-3">Borrar</button>
                                </td>
                            </tr>
                            <tr v-if="filteredInventory.length === 0">
                                <td colspan="7" class="px-4 py-5 text-center text-secondary-custom fw-medium">
                                    No se encontraron insumos que coincidan con la búsqueda.
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            </div>
        </div>
        </div>

        <!-- Vista de Formulario de Compra -->
        <div v-else-if="currentView === 'purchaseForm'" key="purchaseForm" class="row justify-content-center mt-4">
            
            <div class="col-lg-10 text-center mb-4">
                <span class="text-korange fw-bold text-uppercase tracking-wider small">Komanda Almacén</span>
                <h2 class="display-5 fw-bold mt-2 mb-3 text-primary-custom">Registro de Compras</h2>
                <p class="lead text-secondary-custom">
                    Captura rápidamente tus insumos. Ingresa varias filas a la vez. El autocompletado enlazará y calculará información existente de forma automática.
                </p>
            </div>

            <div class="col-lg-10">
                <div class="bg-surface-custom p-4 p-md-5 rounded-4 shadow-sm border border-custom position-relative">
                    <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3 mb-5">
                        <div class="d-flex align-items-center gap-3">
                            <button @click="goBack" class="btn btn-outline-korange rounded-circle d-flex align-items-center justify-content-center p-2 transition-transform hover-translate-x" title="Volver">
                                <ArrowLeft :size="24" />
                            </button>
                            <div>
                                <h2 class="fs-4 fw-bold text-primary-custom mb-1">Formulario de Ingreso</h2>
                                <p class="text-secondary-custom small fw-medium mb-0">Escribe nombres existentes para autocompletar.</p>
                            </div>
                        </div>

                        <button
                            class="btn btn-outline-korange px-4 py-2 rounded-pill fw-bold d-inline-flex justify-content-center align-items-center gap-2 shadow-sm"
                            @click="openCategories">
                            <Tags :size="18" /> Categorías
                        </button>
                    </div>
                    
                    <form @submit.prevent="processPurchase">
                        <datalist id="inventoryNames">
                            <option v-for="item in inventory" :key="item.id" :value="item.name"></option>
                        </datalist>

                        <div class="table-responsive mb-4">
                            <table class="table table-borderless align-middle w-100">
                                <thead>
                                    <tr class="small text-secondary-custom fw-bold">
                                        <th style="width: 22%">Insumo *</th>
                                        <th style="width: 13%">Cantidad *</th>
                                        <th style="width: 13%">Precio unit.</th>
                                        <th style="width: 12%">Ud.</th>
                                        <th style="width: 18%">Categoría</th>
                                        <th style="width: 17%">Caducidad</th>
                                        <th style="width: 5%"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(row, index) in purchaseItems" :key="index" class="align-top">
                                        <td>
                                            <input v-model="row.name" @input="handleNameInput(row)" list="inventoryNames" type="text" placeholder="Buscar / Escribir..." class="form-control py-2 rounded-3 custom-input form-control-sm" required />
                                        </td>
                                        <td>
                                            <input v-model.number="row.quantity" type="number" step="any" min="0.001" placeholder="Cant." class="form-control py-2 rounded-3 custom-input form-control-sm" required />
                                        </td>
                                        <td>
                                            <input v-model.number="row.price" type="number" step="any" min="0" placeholder="0.00" class="form-control py-2 rounded-3 custom-input form-control-sm" />
                                        </td>
                                        <td>
                                            <select v-model="row.unit" class="form-select py-2 rounded-3 custom-input form-control-sm" required>
                                                <option>Kg</option><option>L</option><option>Unid</option><option>Cajas</option><option>Gramos</option>
                                            </select>
                                        </td>
                                        <td>
                                            <select v-model="row.category" class="form-select py-2 rounded-3 custom-input form-control-sm" required>
                                                <option value="" disabled>Seleccione...</option>
                                                <option v-for="cat in categorias" :key="cat.id" :value="cat.name">{{ cat.name }}</option>
                                            </select>
                                        </td>
                                        <td>
                                            <input v-model="row.expiryDate" type="date" class="form-control py-2 rounded-3 custom-input form-control-sm" />
                                        </td>
                                        <td class="text-center">
                                            <button v-if="purchaseItems.length > 1" type="button" @click="removePurchaseRow(index)" class="btn btn-sm text-danger hover-bg-danger rounded-circle p-1" title="Eliminar fila">
                                                ✖
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="d-flex justify-content-center mb-5">
                            <button type="button" class="btn btn-outline-korange btn-sm rounded-pill py-2 px-4 fw-bold transition-transform hover-translate-y" @click="addPurchaseRow">
                                + Agregar otra fila
                            </button>
                        </div>

                        <div class="border-top border-custom pt-4 flex-row d-flex justify-content-end gap-3 mt-2">
                            <button type="button" @click="goBack" class="btn btn-outline-secondary px-4 py-2 fw-bold rounded-pill">Cancelar</button>
                            <button type="submit" class="btn btn-korange px-4 py-2 rounded-pill fw-bold shadow-sm d-inline-flex gap-2 align-items-center pulse-btn transition-transform hover-translate-y">
                                <PlusCircle :size="18" /> Guardar Compra
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Vista de Categorías -->
        <div v-else-if="currentView === 'categories'" key="categories" class="row justify-content-center mt-4">
            <div class="col-lg-8">
                <div class="bg-surface-custom p-4 p-md-5 rounded-4 shadow-sm border border-custom">
                    <div class="d-flex align-items-center mb-5 gap-3">
                        <button @click="backToPurchaseForm" class="btn btn-outline-secondary rounded-circle d-flex align-items-center justify-content-center p-2 transition-transform hover-translate-x" title="Volver al Registro">
                            <ArrowLeft :size="24" />
                        </button>
                        <div>
                            <h2 class="fs-3 fw-bold text-primary-custom mb-1">Gestión de Categorías</h2>
                            <p class="text-secondary-custom small fw-medium mb-0">Define y clasifica las familias de tus insumos.</p>
                        </div>
                    </div>
                    
                    <form @submit.prevent="addCategory" class="mb-5 d-flex gap-2">
                        <input v-model="newCategoryName" type="text" placeholder="Nueva Categoría (Ej: Congelados)" class="form-control py-2 rounded-pill custom-input flex-grow-1 ps-4" required />
                        <button type="submit" class="btn-korange px-4 py-2 rounded-pill fw-bold shadow-sm pulse-btn">Añadir</button>
                    </form>

                    <div class="table-responsive">
                        <table class="table table-custom table-hover-custom mb-0 w-100 align-middle border">
                            <thead class="bg-light-opacity text-uppercase small tracking-wider text-secondary-custom fw-bold">
                                <tr>
                                    <th class="px-4 py-3 border-bottom w-75">Nombre de la Categoría</th>
                                    <th class="px-4 py-3 border-bottom text-center">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="cat in categorias" :key="cat.id" class="hover-bg-light">
                                    <td class="px-4 py-4 fw-bold text-primary-custom fs-6">{{ cat.name }}</td>
                                    <td class="px-4 py-3 text-center">
                                        <button @click="deleteCategory(cat.id)" class="btn btn-sm text-danger fw-medium hover-bg-danger rounded-3">Eliminar</button>
                                    </td>
                                </tr>
                                <tr v-if="categorias.length === 0">
                                    <td colspan="2" class="px-4 py-4 text-center text-secondary-custom fst-italic">Sin categorías configuradas. Agrega una arriba.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </transition>
    </div>
</div>
</template>

<style scoped>
.view-container {
    background-color: var(--bg-body);
    min-height: calc(100vh - 100px);
}

.max-w-7xl {
    max-width: 1200px;
}

.text-primary-custom {
    color: var(--text-main) !important;
}

.text-secondary-custom {
    color: var(--text-muted) !important;
}

.tracking-wider {
    letter-spacing: 2px;
}

.bg-surface-custom {
    background-color: var(--bg-surface);
}

.border-custom {
    border-color: var(--border-color) !important;
}

.bg-danger-subtle {
    background-color: rgba(220, 53, 69, 0.1) !important;
}

.bg-light-opacity {
    background-color: var(--bg-surface);
}

.border-korange {
    border-color: var(--KOrange) !important;
}

/* Hover effects */
.hover-translate-y:hover {
    transform: translateY(-3px);
    box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15) !important;
}

/* Custom Search Input */
.custom-input {
    background-color: var(--bg-surface);
    color: var(--text-main);
    border: 1px solid var(--border-color);
    transition: all var(--transition-speed);
}

.custom-input:focus {
    background-color: var(--bg-body);
    border-color: var(--KOrange);
    box-shadow: 0 0 0 0.25rem rgba(253, 126, 20, 0.15);
}

/* Animations */
.slide-fade-enter-active,
.slide-fade-leave-active {
    transition: all 0.4s ease;
}

.slide-fade-enter-from,
.slide-fade-leave-to {
    transform: translateY(20px);
    opacity: 0;
}

.fade-in {
    animation: fadeIn 0.4s ease-out;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}

.transition-transform {
    transition: transform 0.2s ease;
}

.hover-translate-x:hover {
    transform: translateX(-3px);
}

.hover-bg-light:hover {
    background-color: rgba(0,0,0,0.02);
}

.hover-bg-orange:hover {
    background-color: var(--KOrange);
    color: white !important;
}

.hover-bg-danger:hover {
    background-color: #dc3545;
    color: white !important;
}
</style>