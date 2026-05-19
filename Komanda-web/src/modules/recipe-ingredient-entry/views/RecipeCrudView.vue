<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import RecipeList from '../components/RecipeList.vue';
import RecipeForm from '../components/RecipeForm.vue';
import type { Recipe } from '../components/RecipeForm.vue';
import { PlusCircle, Search } from 'lucide-vue-next';
import { fetchWithAuth } from '../../../core/api/auth.api';
import Sidebar from '../../../components/Sidebar.vue';
import { useAuth } from '../../../core/composables/useAuth';

const auth = useAuth();

// State
const loading = ref(false);
const showForm = ref(false);
const editingRecipe = ref<Recipe | null>(null);
const searchQuery = ref('');

// Data
const recipes = ref<Recipe[]>([]);
const categorias = ref<{ id: number; nombre: string }[]>([]);
const ingredientesDisponibles = ref<{ id: number; nombre: string; unidad_id?: number }[]>([]);

const filteredRecipes = computed(() => {
  if (!searchQuery.value) return recipes.value;
  const q = searchQuery.value.toLowerCase();
  return recipes.value.filter(r => r.nombre.toLowerCase().includes(q));
});

// Mock fetch from Backend based on MANUAL_FRONTEND guidelines
const fetchData = async () => {
  loading.value = true;
  try {
    const resRecetas = await fetchWithAuth('/menu/recetas');
    recipes.value = resRecetas.data || [];

    const resCategorias = await fetchWithAuth('/menu/categorias');
    categorias.value = resCategorias.data || [];

    // Fetch ingredientes reales
    const resIngredientes = await fetchWithAuth('/inventory');
    ingredientesDisponibles.value = (resIngredientes.data || []).map((i: any) => ({
      id: i.id,
      nombre: i.nombre,
      unidad_id: i.unidad_id,
      // unidad_nombre is the reliable historical alias; unidad_abrev was added in the same query
      unidad_abrev: i.unidad_nombre || i.unidad_abrev || i.unidad || '',
      costo_promedio: Number(i.costo_promedio) || 0
    }));

    // Compute costo_produccion (qty is in ingredient's own unit, no conversion needed)
    recipes.value = (resRecetas.data || []).map((r: any) => {
      let costo = 0;
      if (r.ingredientes) {
        r.ingredientes.forEach((ing: any) => {
          const orig = ingredientesDisponibles.value.find(i => i.id === ing.ingrediente_id);
          if (orig && orig.costo_promedio) {
            costo += Number(ing.cantidad) * orig.costo_promedio;
          }
        });
      }
      r.costo_produccion = Number(costo.toFixed(2));
      r.margen_utilidad = (r.costo_produccion > 0 && r.precio_venta > 0)
        ? Number((((r.precio_venta - r.costo_produccion) / r.precio_venta) * 100).toFixed(2))
        : 0;
      return r;
    });
  } catch (error) {
    console.error('Error fetching data:', error);
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  fetchData();
});

// Handlers
const handleCreateNew = () => {
  editingRecipe.value = null;
  showForm.value = true;
};

const handleEdit = (recipe: Recipe) => {
  editingRecipe.value = recipe;
  showForm.value = true;
};

const handleDelete = async (recipe: Recipe) => {
  if (confirm(`¿Estás seguro de eliminar "${recipe.nombre}"?`)) {
    try {
      await fetchWithAuth(`/menu/recetas/${recipe.id}`, { method: 'DELETE' });
      await fetchData();
    } catch (error) {
      console.error('Error deleting recipe:', error);
      alert('Error eliminando la receta');
    }
  }
};

const handleToggleStatus = async (recipe: Recipe) => {
  try {
    const updatedRecipe = { ...recipe, activo: !recipe.activo };
    await fetchWithAuth(`/menu/recetas/${recipe.id}`, {
      method: 'PUT',
      body: JSON.stringify(updatedRecipe)
    });
    await fetchData();
  } catch (error) {
    console.error('Error toggling status:', error);
    alert('Error al cambiar el estado');
  }
};

const handleSubmit = async (recipe: Recipe) => {
  loading.value = true;
  try {
    if (recipe.id) {
      await fetchWithAuth(`/menu/recetas/${recipe.id}`, {
        method: 'PUT',
        body: JSON.stringify(recipe)
      });
    } else {
      await fetchWithAuth('/menu/recetas', {
        method: 'POST',
        body: JSON.stringify(recipe)
      });
    }

    showForm.value = false;
    editingRecipe.value = null;
    await fetchData(); // Refresh data and recalculate BOM
  } catch (error) {
    console.error('Error saving recipe:', error);
    alert('Error guardando la receta. Es posible que existan datos inválidos.');
  } finally {
    loading.value = false;
  }
};

const handleCancel = () => {
  showForm.value = false;
  editingRecipe.value = null;
};

// Handle category created from the form inline
const handleCreateCategory = async (nombre: string) => {
  try {
    const res = await fetchWithAuth('/menu/categorias', {
      method: 'POST',
      body: JSON.stringify({ nombre })
    });
    categorias.value.push(res.data);
    alert(`Categoría "${nombre}" creada exitosamente.`);
  } catch (e) {
    console.error('Error creating category', e);
    alert('Error creando categoría');
  }
};
</script>

<template>
<div class="d-flex w-100">
  <Sidebar :role="auth.user.value?.role || 'admin'" :userName="auth.user.value?.nombre" />
  <div class="view-container py-4 main-content">
    <div class="container-fluid max-w-7xl mx-auto">

      <!-- Headings mimicking Landing Page -->
      <div class="row justify-content-center mb-5 mt-3 fade-in">
        <div class="col-lg-10 text-center">
          <span class="text-korange fw-bold text-uppercase tracking-wider small">Komanda Gestión</span>
          <h2 class="display-5 fw-bold mt-2 mb-3 text-primary-custom">Ingeniería del Menú</h2>
          <p class="lead text-secondary-custom">
            Administra tus platillos, unifica la lista de ingredientes (BOM) y domina tus márgenes de ganancia.
          </p>
        </div>
      </div>

      <!-- Action Bar when NOT showing form -->
      <div v-if="!showForm" class="row mb-4 gx-3 justify-content-between align-items-center">
        <div class="col-md-5 order-2 order-md-1 mt-3 mt-md-0">
          <div class="search-box position-relative">
            <Search class="position-absolute top-50 start-0 translate-middle-y ms-3 text-secondary-custom" :size="20" />
            <input v-model="searchQuery" type="text" class="form-control ps-5 py-2 rounded-pill custom-input"
              placeholder="Buscar plato por nombre...">
          </div>
        </div>
        <div class="col-md-auto text-end order-1 order-md-2">
          <button
            class="btn-korange px-4 py-2 rounded-pill fw-bold d-inline-flex justify-content-center align-items-center gap-2 shadow-sm pulse-btn w-100"
            @click="handleCreateNew">
            <PlusCircle :size="20" /> Nuevo Plato
          </button>
        </div>
      </div>

      <!-- Main Content Area -->
      <div class="row justify-content-center">
        <div class="col-12 z-index-1">
          <!-- Render Form if showForm is true -->
          <transition name="slide-fade" mode="out-in">
            <RecipeForm v-if="showForm" key="form" :initial-data="editingRecipe" :categorias="categorias"
              :ingredientes-disponibles="ingredientesDisponibles" @submit="handleSubmit" @cancel="handleCancel"
              @create-category="handleCreateCategory" />

            <!-- Render List otherwise -->
            <RecipeList v-else key="list" :recipes="filteredRecipes" :categorias="categorias" :loading="loading"
              @edit="handleEdit" @delete="handleDelete" @toggle-status="handleToggleStatus" />
          </transition>
        </div>
      </div>
    </div>
  </div>
</div>
</template>

<style scoped>
.view-container {
  background-color: var(--bg-body);
  min-height: calc(100vh - 100px);
}

@media (min-width: 768px) {
  .main-content {
    margin-left: 260px;
    width: calc(100% - 260px);
  }
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
</style>
