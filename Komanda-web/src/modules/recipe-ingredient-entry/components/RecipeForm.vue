<script setup lang="ts">
import { ref, computed, watch } from 'vue';
import { 
  ChevronRight, 
  ChevronLeft, 
  Save, 
  Plus, 
  X, 
  List, 
  ChefHat, 
  DollarSign, 
  ClipboardList 
} from 'lucide-vue-next';

// Interfaces for typing
export interface RecipeIngredient {
  id?: number;
  ingrediente_id: number;
  cantidad: number;
  unidad: string; // 'kg', 'litros', 'unidad'
  nombre_ingrediente?: string; // For display purposes
}

export interface Recipe {
  id?: number;
  nombre: string;
  descripcion: string;
  categoria_id: number | null;
  imagen_url: string;
  costo_produccion: number;
  precio_sugerido: number;
  precio_venta: number;
  margen_utilidad: number;
  activo: boolean;
  ingredientes: RecipeIngredient[];
}

const props = defineProps<{
  initialData?: Recipe | null;
  categorias: { id: number; nombre: string }[];
  ingredientesDisponibles: { id: number; nombre: string; unidad_id?: number }[];
}>();

const emit = defineEmits<{
  (e: 'submit', recipe: Recipe): void;
  (e: 'cancel'): void;
  (e: 'create-category', nombre: string): void;
}>();

// Form State
const currentStep = ref(1);
const form = ref<Recipe>({
  nombre: '',
  descripcion: '',
  categoria_id: null,
  imagen_url: '',
  costo_produccion: 0,
  precio_sugerido: 0,
  precio_venta: 0,
  margen_utilidad: 0,
  activo: true,
  ingredientes: [],
});

if (props.initialData) {
  form.value = { ...props.initialData };
  form.value.ingredientes = [...(props.initialData.ingredientes || [])];
}

// Category Creation State
const isCreatingCategory = ref(false);
const newCategoryName = ref('');
const lastCreatedCategoryName = ref('');

const toggleCategoryCreation = () => {
  isCreatingCategory.value = !isCreatingCategory.value;
  newCategoryName.value = '';
};

const saveNewCategory = () => {
  if (newCategoryName.value.trim()) {
    lastCreatedCategoryName.value = newCategoryName.value.trim();
    emit('create-category', newCategoryName.value.trim());
    isCreatingCategory.value = false;
    newCategoryName.value = '';
  }
};

watch(() => props.categorias, (newCats) => {
  if (lastCreatedCategoryName.value) {
    const found = newCats.find(c => c.nombre === lastCreatedCategoryName.value);
    if (found) {
      form.value.categoria_id = found.id;
      lastCreatedCategoryName.value = '';
    }
  }
}, { deep: true });

// Ingredient Entry State
const newIngredient = ref<RecipeIngredient>({
  ingrediente_id: 0,
  cantidad: 0,
  unidad: 'kg'
});

const ingredientSearchQuery = ref('');
const showIngredientDropdown = ref(false);

const filteredIngredientesDisponibles = computed(() => {
  if (!ingredientSearchQuery.value) return props.ingredientesDisponibles;
  const q = ingredientSearchQuery.value.toLowerCase();
  return props.ingredientesDisponibles.filter(i => i.nombre.toLowerCase().includes(q));
});

const selectIngredient = (ing: {id: number, nombre: string}) => {
  newIngredient.value.ingrediente_id = ing.id;
  ingredientSearchQuery.value = ing.nombre;
  showIngredientDropdown.value = false;
};

const calculateMargin = () => {
  if (form.value.costo_produccion > 0 && form.value.precio_venta > 0) {
    const profit = form.value.precio_venta - form.value.costo_produccion;
    form.value.margen_utilidad = Number(((profit / form.value.precio_venta) * 100).toFixed(2));
  } else {
    form.value.margen_utilidad = 0;
  }
};

const addIngredient = () => {
  if (newIngredient.value.ingrediente_id && newIngredient.value.cantidad > 0) {
    const selectedIng = props.ingredientesDisponibles.find(i => i.id === newIngredient.value.ingrediente_id);
    
    form.value.ingredientes.push({
      ...newIngredient.value,
      nombre_ingrediente: selectedIng?.nombre || 'Desconocido'
    });
    
    // Reset new ingredient form
    newIngredient.value = {
      ingrediente_id: 0,
      cantidad: 0,
      unidad: 'kg'
    };
    ingredientSearchQuery.value = '';
  }
};

const removeIngredient = (index: number) => {
  form.value.ingredientes.splice(index, 1);
};

// Wizard Navigation
const getValidationMessage = () => {
  if (!form.value.nombre.trim()) return 'Por favor escribe el nombre del plato.';
  if (isCreatingCategory.value) {
    if (newCategoryName.value.trim()) return 'Debes confirmar la nueva categoría haciendo clic en el botón naranja de Guardar (el ícono del disquete).';
    else return 'Por favor escribe el nombre de la nueva categoría o presiona la "X" para cancelar y seleccionar de la lista.';
  }
  if (!form.value.categoria_id) return 'Por favor selecciona una categoría de la lista.';
  return '';
};

const canProceedToStep2 = computed(() => {
  return getValidationMessage() === '';
});

const nextStep = () => {
  if (currentStep.value === 1) {
    const msg = getValidationMessage();
    if (msg) {
      alert(msg);
      return;
    }
  }
  if (currentStep.value < 3) currentStep.value++;
};

const prevStep = () => {
  if (currentStep.value > 1) currentStep.value--;
};

const goToStep = (step: number) => {
  if (step > 1) {
    const msg = getValidationMessage();
    if (msg) {
      alert(msg);
      return;
    }
  }
  currentStep.value = step;
};

const handleSubmit = () => {
  emit('submit', form.value);
};
</script>

<template>
  <div class="recipe-wizard bg-surface p-4 p-md-5 rounded-4 shadow-sm border-0 position-relative overflow-hidden">
    <!-- Header / Stepper -->
    <div class="wizard-header text-center mb-5">
      <span class="text-korange fw-bold text-uppercase tracking-wider small">
        {{ initialData ? 'Edición' : 'Creación' }} de Menú
      </span>
      <h3 class="fw-bold mb-4 mt-2 text-primary">
        {{ initialData ? 'Edita tu plato maestro' : 'Diseña un nuevo plato' }}
      </h3>

      <div class="stepper d-flex flex-wrap justify-content-center align-items-center gap-2 gap-sm-4 px-2">
        <div class="step step-btn" :class="{ 'active': currentStep >= 1, 'current': currentStep === 1 }" @click="goToStep(1)">
          <div class="step-icon">
            <ChefHat :size="20" />
          </div>
          <span class="step-label d-none d-sm-block">Datos Básicos</span>
        </div>
        <div class="step-line" :class="{ 'active': currentStep >= 2 }"></div>
        <div class="step step-btn" :class="{ 'active': currentStep >= 2, 'current': currentStep === 2 }" @click="goToStep(2)">
          <div class="step-icon">
            <List :size="20" />
          </div>
          <span class="step-label d-none d-sm-block">Receta (Ingredientes)</span>
        </div>
        <div class="step-line" :class="{ 'active': currentStep >= 3 }"></div>
        <div class="step step-btn" :class="{ 'active': currentStep >= 3, 'current': currentStep === 3 }" @click="goToStep(3)">
          <div class="step-icon">
            <DollarSign :size="20" />
          </div>
          <span class="step-label d-none d-sm-block">Costos y Precios</span>
        </div>
      </div>
    </div>

    <form @submit.prevent="handleSubmit">
      
      <!-- STEP 1: Basic Info -->
      <transition name="fade" mode="out-in">
        <div v-if="currentStep === 1" class="step-content" key="step1">
          <div class="row g-4">
            <div class="col-md-6">
              <label class="form-label text-primary fw-bold">Nombre del Plato *</label>
              <input 
                v-model="form.nombre" 
                type="text" 
                class="form-control custom-input rounded-3 py-2" 
                placeholder="Ej: Komanda Burger" 
                required
                autofocus
              >
            </div>
            
            <div class="col-md-6">
              <label class="form-label text-primary fw-bold">Categoría *</label>
              <div v-if="!isCreatingCategory" class="d-flex gap-2">
                <select v-model="form.categoria_id" class="form-select custom-input rounded-3 py-2" required>
                  <option :value="null" disabled>Selecciona una categoría</option>
                  <option v-for="cat in categorias" :key="cat.id" :value="cat.id">
                    {{ cat.nombre }}
                  </option>
                </select>
                <button type="button" class="btn btn-outline-korange rounded-3 px-3" @click="toggleCategoryCreation" title="Nueva Categoría">
                  <Plus :size="18" />
                </button>
              </div>
              <div v-else class="d-flex gap-2">
                <input 
                  v-model="newCategoryName" 
                  type="text" 
                  class="form-control custom-input rounded-3 py-2" 
                  placeholder="Nombre categoría"
                  @keyup.enter.prevent="saveNewCategory"
                >
                <button type="button" class="btn rounded-3 px-3 shadow-sm" style="background-color: var(--KOrange); border: none;" @click="saveNewCategory" :disabled="!newCategoryName" title="Guardar y Seleccionar">
                  <Save :size="18" color="white" />
                </button>
                <button type="button" class="btn btn-outline-secondary rounded-3 px-3" @click="toggleCategoryCreation" title="Cancelar Módulo">
                  <X :size="18" />
                </button>
              </div>
            </div>

            <div class="col-12">
              <label class="form-label text-primary fw-bold">Descripción Corta</label>
              <textarea 
                v-model="form.descripcion" 
                class="form-control custom-input rounded-3" 
                rows="3" 
                placeholder="Apetitosa descripción que verán tus clientes..."
              ></textarea>
            </div>

            <div class="col-12">
              <label class="form-label text-primary fw-bold">URL Fotografía</label>
              <div class="input-group">
                <span class="input-group-text custom-input border-end-0 bg-transparent text-secondary">
                  🔗
                </span>
                <input 
                  v-model="form.imagen_url" 
                  type="url" 
                  class="form-control custom-input rounded-end-3 py-2 border-start-0" 
                  placeholder="https://tudominio.com/hamburguesa.jpg"
                >
              </div>
            </div>

            <div class="col-12 mt-4">
              <div class="form-check form-switch py-3 px-4 rounded-4" style="background-color: var(--bg-body); border: 1px solid var(--border-color);">
                <input v-model="form.activo" class="form-check-input ms-0 me-3 mt-1" type="checkbox" id="activoSwitch" style="transform: scale(1.2);">
                <label class="form-check-label text-primary fw-bold pt-0" for="activoSwitch">
                  Hacer visible en el menú inmediatamente
                </label>
              </div>
            </div>
          </div>
        </div>
      </transition>

      <!-- STEP 2: Recipes & BOM -->
      <transition name="fade" mode="out-in">
        <div v-if="currentStep === 2" class="step-content" key="step2">
          
          <div class="add-ingredient-box p-4 rounded-4 mb-4 shadow-sm" style="background-color: var(--bg-surface); border: 2px solid var(--border-color);">
            <h6 class="text-korange fw-bold mb-4 d-flex align-items-center gap-2">
              <ClipboardList :size="20"/>
              Buscador de Insumos
            </h6>
            
            <div class="row g-3 align-items-end">
              <div class="col-md-5">
                <label class="form-label text-primary fw-bold small">Ingrediente Base</label>
                <div class="position-relative">
                  <input 
                    type="text" 
                    v-model="ingredientSearchQuery" 
                    @focus="showIngredientDropdown = true" 
                    @blur="setTimeout(() => showIngredientDropdown = false, 200)" 
                    class="form-control custom-input py-2 rounded-3" 
                    placeholder="Escribe para buscar (Ej. Carne)..."
                  >
                  <ul v-if="showIngredientDropdown" class="list-group position-absolute w-100 z-3 shadow mt-1 custom-dropdown">
                    <li 
                      v-for="ing in filteredIngredientesDisponibles" 
                      :key="ing.id" 
                      class="list-group-item list-group-item-action cursor-pointer dropdown-item-custom" 
                      @click="selectIngredient(ing)"
                    >
                      {{ ing.nombre }}
                    </li>
                    <li v-if="filteredIngredientesDisponibles.length === 0" class="list-group-item text-secondary text-center">
                      No se encontraron ingredientes
                    </li>
                  </ul>
                </div>
              </div>
              <div class="col-md-2">
                <label class="form-label text-primary fw-bold small">Medida</label>
                <select v-model="newIngredient.unidad" class="form-select custom-input py-2 rounded-3">
                  <option value="kg">Kilos</option>
                  <option value="litros">Litros</option>
                  <option value="unidad">Unidades</option>
                  <option value="gramos">Gramos</option>
                </select>
              </div>
              <div class="col-md-3">
                <label class="form-label text-primary fw-bold small">Cantidad</label>
                <input v-model.number="newIngredient.cantidad" type="number" step="0.001" min="0" class="form-control custom-input py-2 rounded-3" placeholder="Ej. 1.5">
              </div>
              <div class="col-md-2 text-end">
                <button type="button" class="btn rounded-3 w-100 py-2 fw-bold text-white shadow-sm action-btn-add" style="background-color: var(--KOrange); border: none;" @click="addIngredient" :disabled="!newIngredient.ingrediente_id || newIngredient.cantidad <= 0">
                  <Plus :size="18" class="me-1"/> Añadir
                </button>
              </div>
            </div>
          </div>

          <div class="table-responsive bg-surface rounded-4 shadow-sm" style="border: 1px solid var(--border-color);">
            <table class="table table-hover custom-table align-middle mb-0">
              <thead style="background-color: transparent;">
                <tr>
                  <th class="ps-4 py-3 border-bottom border-0 text-secondary text-uppercase small tracking-wider">Ingrediente</th>
                  <th class="py-3 border-bottom border-0 text-center text-secondary text-uppercase small tracking-wider">Medida</th>
                  <th class="py-3 border-bottom border-0 text-center text-secondary text-uppercase small tracking-wider">Porción</th>
                  <th class="pe-4 py-3 border-bottom border-0 text-end text-secondary text-uppercase small tracking-wider">Quitar</th>
                </tr>
              </thead>
              <tbody>
                <tr v-if="form.ingredientes.length === 0">
                  <td colspan="4" class="text-center text-secondary py-5 border-0">
                    <div class="opacity-50 mb-2"><ClipboardList :size="32" /></div>
                    Ningún ingrediente ha sido asignado. <br>
                    <small>Este plato no descontará de inventario si se deja vacío.</small>
                  </td>
                </tr>
                <tr v-for="(ing, idx) in form.ingredientes" :key="idx" class="ingredient-row">
                  <td class="text-primary fw-bold ps-2 ps-sm-4 py-2 py-sm-3 border-0">
                    <div class="d-flex align-items-center gap-2 w-100" style="color: var(--text-primary) !important; opacity: 1;">
                       <span class="bullet-dot bg-korange flex-shrink-0"></span>
                       <span class="text-truncate" style="max-width: 150px;">{{ ing.nombre_ingrediente }}</span>
                    </div>
                  </td>
                  <td class="text-center small text-uppercase py-2 py-sm-3 border-0">
                    <span class="badge rounded-pill px-2 px-sm-3 py-1 py-sm-2 border shadow-sm" style="background-color: var(--bg-body); color: var(--text-primary); border-color: var(--border-color) !important;">{{ ing.unidad }}</span>
                  </td>
                  <td class="text-primary text-center fs-6 fs-sm-5 fw-bold py-2 py-sm-3 border-0" style="color: var(--text-primary) !important;">{{ ing.cantidad }}</td>
                  <td class="text-end pe-2 pe-sm-4 py-2 py-sm-3 border-0">
                    <button type="button" class="btn btn-sm btn-outline-danger custom-radius p-2 mx-1 rounded-circle flex-center" @click="removeIngredient(idx)" title="Eliminar Insumo">
                      <X :size="14" />
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </transition>

      <!-- STEP 3: Pricing & Costs -->
      <transition name="fade" mode="out-in">
        <div v-if="currentStep === 3" class="step-content" key="step3">
          <div class="row g-4 justify-content-center">
            <div class="col-md-4">
              <div class="price-card p-4 rounded-4 text-center">
                <label class="form-label text-secondary small fw-bold text-uppercase">Costo Producción</label>
                <div class="input-group mt-2">
                  <span class="input-group-text custom-input fw-bold bg-transparent border-end-0">$</span>
                  <input 
                    v-model.number="form.costo_produccion" 
                    type="number" step="0.01" min="0"
                    class="form-control custom-input border-start-0 fs-5 text-center py-2" 
                    @input="calculateMargin"
                  >
                </div>
              </div>
            </div>
            
            <div class="col-md-4">
              <div class="price-card p-4 rounded-4 text-center target-card position-relative overflow-hidden">
                <div class="hover-decoration"></div>
                <label class="form-label text-korange small fw-bold text-uppercase position-relative z-1">Precio Venta Público</label>
                <div class="input-group mt-2 position-relative z-1">
                  <span class="input-group-text custom-input fw-bold border-end-0" style="background-color: var(--bg-body)">$</span>
                  <input 
                    v-model.number="form.precio_venta" 
                    type="number" step="0.01" min="0"
                    class="form-control custom-input border-start-0 fs-4 fw-bold text-center py-2 form-venta text-korange" 
                    @input="calculateMargin"
                  >
                </div>
              </div>
            </div>

            <div class="col-md-4">
              <div class="price-card p-4 rounded-4 text-center">
                <label class="form-label text-secondary small fw-bold text-uppercase">Precio Sugerido (Opcional)</label>
                <div class="input-group mt-2">
                  <span class="input-group-text custom-input fw-bold bg-transparent border-end-0">$</span>
                  <input 
                    v-model.number="form.precio_sugerido" 
                    type="number" step="0.01" min="0"
                    class="form-control custom-input border-start-0 fs-5 text-center py-2"
                  >
                </div>
              </div>
            </div>

            <div class="col-12 text-center mt-5">
              <div class="d-inline-flex flex-column align-items-center p-4 rounded-4 mb-2 shadow-sm" style="background-color: var(--bg-surface); border: 2px solid var(--border-color); min-width: 300px;">
                <span class="text-secondary small fw-bold text-uppercase mb-2">Margen de Utilidad Proyectado</span>
                <div class="fs-1 fw-bold" :class="form.margen_utilidad >= 30 ? 'text-success' : (form.margen_utilidad > 0 ? 'text-warning' : 'text-danger')">
                  {{ form.margen_utilidad }}%
                </div>
                <small v-if="form.margen_utilidad < 30 && form.margen_utilidad > 0" class="text-secondary mt-2">Margen bajo. Sugerimos > 30%</small>
              </div>
            </div>
          </div>
        </div>
      </transition>

      <!-- Navigation Actions -->
      <div class="wizard-actions mt-5 pt-4 border-top d-flex flex-column flex-md-row justify-content-between align-items-center gap-3" style="border-color: var(--border-color) !important;">
        <div class="w-100 w-md-auto text-center text-md-start">
          <button type="button" class="btn btn-outline-secondary rounded-pill px-4 text-secondary w-100 w-md-auto" @click="emit('cancel')">
            Cancelar
          </button>
        </div>
        <div class="d-flex flex-column flex-md-row gap-2 w-100 w-md-auto">
          <button v-if="currentStep > 1" type="button" class="btn btn-surface rounded-pill nav-btn position-relative text-primary w-100 w-md-auto" style="background-color: var(--bg-body); border: 1px solid var(--border-color);" @click="prevStep">
            <ChevronLeft :size="18" class="position-absolute" style="left: 1.25rem; top: 50%; transform: translateY(-50%);" /> 
            <span>Atrás</span>
          </button>
          
          <button v-if="currentStep < 3" type="button" class="btn rounded-pill nav-btn fw-bold position-relative text-white w-100 w-md-auto" style="background-color: var(--KOrange); border: none;" @click="nextStep">
            <span>Siguiente</span> 
            <ChevronRight :size="18" color="white" class="position-absolute" style="right: 1.25rem; top: 50%; transform: translateY(-50%);" />
          </button>
          
          <button v-if="currentStep === 3" type="submit" class="btn rounded-pill nav-btn fw-bold position-relative shadow-sm pulse-btn text-white w-100 w-md-auto" style="background-color: var(--KOrange); border: none;" @click="handleSubmit">
            <span>Guardar Plato</span> 
            <Save :size="18" color="white" class="position-absolute" style="right: 1.25rem; top: 50%; transform: translateY(-50%);" />
          </button>
        </div>
      </div>
    </form>
  </div>
</template>

<style scoped>
.tracking-wider { letter-spacing: 2px; }

.bg-surface {
  background-color: var(--bg-surface);
}

.text-primary { color: var(--text-primary) !important; }
.text-secondary { color: var(--text-secondary) !important; }
.text-success { color: #40c057 !important; }
.text-warning { color: #fcc419 !important; }
.text-danger { color: #fa5252 !important; }

/* Custom Inputs matching Landing aesthetic */
.custom-input {
  background-color: var(--bg-body);
  color: var(--text-primary);
  border: 1px solid var(--border-color);
  transition: all var(--transition-speed);
}

.custom-input:focus {
  background-color: var(--bg-body);
  color: var(--text-primary);
  border-color: var(--KOrange);
  box-shadow: 0 0 0 0.25rem rgba(253, 126, 20, 0.15);
}

.custom-input::placeholder {
  color: var(--text-secondary);
  opacity: 0.5;
}

/* Stepper styles */
.stepper {
  margin-top: 1rem;
}
.step {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  color: var(--text-secondary);
  transition: color var(--transition-speed);
}
.step.active {
  color: var(--KOrange);
}
.step-icon {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background-color: var(--bg-body);
  border: 2px solid var(--border-color);
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all var(--transition-speed);
}
.step-btn {
  cursor: pointer;
}
.step-btn:hover .step-icon {
  border-color: var(--KOrange);
  color: var(--KOrange);
}
.step.active .step-icon {
  border-color: var(--KOrange);
  color: var(--KOrange);
}
.step.current .step-icon {
  background-color: var(--KOrange);
  border-color: var(--KOrange);
  color: white;
  box-shadow: 0 4px 12px rgba(253, 126, 20, 0.3);
}
.step-line {
  height: 2px;
  width: 20px;
  background-color: var(--border-color);
  transition: background-color var(--transition-speed);
}
@media (min-width: 576px) {
  .step-line {
    width: 40px;
  }
}
.step-line.active {
  background-color: var(--KOrange);
}
.step-label {
  font-size: 0.85rem;
  font-weight: 600;
}

/* Forms Content Transitions */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}
.fade-enter-from {
  opacity: 0;
  transform: translateX(20px);
}
.fade-leave-to {
  opacity: 0;
  transform: translateX(-20px);
}

/* Price Cards */
.price-card {
  background-color: var(--bg-body);
  border: 1px solid var(--border-color);
  transition: border-color var(--transition-speed), transform var(--transition-speed);
}
.target-card {
  border-color: var(--KOrange);
  background-color: var(--KOrange-light);
  transform: scale(1.02);
  box-shadow: 0 10px 30px rgba(0,0,0,0.05);
}

/* For Dark mode - override target card background to keep it dark but colored */
@media (prefers-color-scheme: dark) {
  .target-card {
    background-color: rgba(253, 126, 20, 0.1);
    box-shadow: 0 10px 30px rgba(0,0,0,0.3);
  }
}

.hover-decoration {
  position: absolute;
  top: 0;
  right: 0;
  width: 150px;
  height: 150px;
  background: radial-gradient(circle at top right, var(--KOrange), transparent 70%);
  opacity: 0.1;
  pointer-events: none;
}

/* Buttons */
.btn-surface {
  background-color: var(--bg-body);
  color: var(--text-primary);
  border: 1px solid var(--border-color);
  transition: all var(--transition-speed);
}
.btn-surface:hover {
  background-color: var(--border-color);
}
.btn-outline-korange {
  color: var(--KOrange);
  border-color: var(--KOrange);
  background-color: transparent;
}
.btn-outline-korange:hover {
  background-color: var(--KOrange);
  color: white;
}
.pulse-btn {
  animation: gentle-pulse 2s infinite;
}
@keyframes gentle-pulse {
  0% { box-shadow: 0 0 0 0 rgba(253, 126, 20, 0.4); }
  70% { box-shadow: 0 0 0 10px rgba(253, 126, 20, 0); }
  100% { box-shadow: 0 0 0 0 rgba(253, 126, 20, 0); }
}

/* Tables */
.custom-table {
  color: var(--text-primary);
}
.custom-table tr:hover {
  background-color: var(--bg-surface);
}
/* Dropdown custom */
.custom-dropdown {
  max-height: 200px;
  overflow-y: auto;
  border: 1px solid var(--border-color);
  background-color: var(--bg-surface);
  border-radius: 0.5rem;
}
.dropdown-item-custom {
  background-color: var(--bg-surface);
  color: var(--text-primary);
  border-bottom: 1px solid var(--border-color);
  transition: background-color 0.2s;
}
.dropdown-item-custom:hover {
  background-color: var(--bg-body);
  color: var(--KOrange);
}
.dropdown-item-custom:last-child {
  border-bottom: none;
}
.cursor-pointer {
  cursor: pointer;
}

.bullet-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  display: inline-block;
}
.bg-korange {
  background-color: var(--KOrange);
}
.flex-center {
  display: inline-flex;
  align-items: center;
  justify-content: center;
}
.action-btn-add {
  transition: all 0.2s;
}
.action-btn-add:hover:not(:disabled) {
  background-color: #e36d0d !important;
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(253, 126, 20, 0.3) !important;
}
.ingredient-row {
  border-bottom: 1px solid var(--border-color);
}
.ingredient-row:last-child {
  border-bottom: none;
}
.nav-btn {
  padding-left: 1.5rem;
  padding-right: 1.5rem;
}
@media (min-width: 768px) {
  .nav-btn {
    width: 170px;
  }
}
@media (max-width: 575px) {
  .text-truncate {
    max-width: 100px !important;
  }
}
</style>
