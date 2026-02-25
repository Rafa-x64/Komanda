<script setup lang="ts">
import type { Recipe } from './RecipeForm.vue';
import { Edit2, Trash2 } from 'lucide-vue-next';

const props = defineProps<{
  recipes: Recipe[];
  categorias: { id: number; nombre: string }[];
  loading?: boolean;
}>();

const emit = defineEmits<{
  (e: 'edit', recipe: Recipe): void;
  (e: 'delete', recipe: Recipe): void;
}>();

const getCategoriaNombre = (id: number | null) => {
  if (!id) return '-';
  const cat = props.categorias.find(c => c.id === id);
  return cat ? cat.nombre : `Cat #${id}`;
};

const formatCurrency = (value: number) => {
  return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(value);
};
</script>

<template>
  <div class="recipe-list bg-surface p-4 p-md-5 rounded-4 shadow-sm border-0">
    <!-- Loading State -->
    <div v-if="loading" class="text-center py-5 text-secondary-custom">
      <div class="spinner-border text-korange mb-3" role="status">
        <span class="visually-hidden">Cargando...</span>
      </div>
      <p class="mb-0 fw-bold">Actualizando catálogo...</p>
    </div>

    <!-- Empty State -->
    <div v-else-if="recipes.length === 0" class="text-center py-5 text-secondary-custom rounded-4 my-3" style="border: 2px dashed var(--border-color)">
      <div class="mb-3 opacity-50 fs-1">🍽️</div>
      <h5 class="fw-bold">Menú Vacío</h5>
      <p class="mb-0">Aún no se han configurado platillos. ¡Añade el primero!</p>
    </div>

    <!-- Data Table -->
    <div v-else class="table-responsive rounded-4 border" style="border-color: var(--border-color) !important;">
      <table class="table custom-table align-middle mb-0">
        <thead class="bg-body text-uppercase small tracking-wider" style="background-color: var(--bg-body)">
          <tr>
            <th class="ps-4 py-3 border-bottom border-0">Plato</th>
            <th class="py-3 border-bottom border-0">Categoría</th>
            <th class="py-3 border-bottom border-0">Costo / P. Venta</th>
            <th class="py-3 border-bottom border-0 text-center">Rentabilidad</th>
            <th class="py-3 border-bottom border-0 text-center">Estado</th>
            <th class="pe-4 py-3 text-end border-bottom border-0">Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="recipe in recipes" :key="recipe.id" class="recipe-row">
            <td class="ps-4 py-3">
              <div class="d-flex align-items-center">
                <div 
                  class="recipe-img-thumb me-3 rounded-circle d-flex align-items-center justify-content-center overflow-hidden position-relative shadow-sm"
                  style="width: 48px; height: 48px; background-color: var(--bg-body)"
                >
                  <img v-if="recipe.imagen_url" :src="recipe.imagen_url" alt="Img" class="w-100 h-100 object-fit-cover">
                  <span v-else class="text-secondary-custom fw-bold">{{ recipe.nombre.substring(0,2).toUpperCase() }}</span>
                </div>
                <div>
                  <h6 class="mb-0 text-primary-custom fw-bold">{{ recipe.nombre }}</h6>
                  <small class="text-secondary-custom d-flex align-items-center gap-1 mt-1">
                    <span class="badge rounded-pill bg-light text-dark border shadow-sm">
                      {{ recipe.ingredientes?.length || 0 }} hrs
                    </span>
                    ingredientes
                  </small>
                </div>
              </div>
            </td>
            <td class="text-secondary-custom fw-medium">{{ getCategoriaNombre(recipe.categoria_id) }}</td>
            <td>
              <div class="d-flex flex-column">
                <small class="text-secondary-custom line-through opacity-75">{{ formatCurrency(recipe.costo_produccion) }}</small>
                <strong class="text-korange fs-6">{{ formatCurrency(recipe.precio_venta) }}</strong>
              </div>
            </td>
            <td class="text-center">
              <span class="badge rounded-pill px-3 py-2 fw-bold" :class="recipe.margen_utilidad >= 30 ? 'bg-success-soft text-success' : 'bg-danger-soft text-danger'">
                {{ recipe.margen_utilidad }}%
              </span>
            </td>
            <td class="text-center">
              <div class="d-inline-flex align-items-center gap-2">
                <span class="status-dot" :class="recipe.activo ? 'bg-success' : 'bg-secondary'"></span>
                <span class="small fw-bold text-secondary-custom text-uppercase">{{ recipe.activo ? 'Activo' : 'Inactivo' }}</span>
              </div>
            </td>
            <td class="text-end pe-4">
              <div class="action-buttons d-flex gap-2 justify-content-end opacity-75">
                <button 
                  class="btn btn-sm btn-action text-primary-custom rounded-circle" 
                  @click="emit('edit', recipe)"
                  title="Editar Plato"
                >
                  <Edit2 :size="16" />
                </button>
                <button 
                  class="btn btn-sm btn-action text-danger rounded-circle" 
                  @click="emit('delete', recipe)"
                  title="Eliminar Plato"
                >
                  <Trash2 :size="16" />
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<style scoped>
.tracking-wider { letter-spacing: 1px; }

.bg-surface { background-color: var(--bg-surface); }
.text-primary-custom { color: var(--text-main) !important; }
.text-secondary-custom { color: var(--text-muted) !important; }
.text-korange { color: var(--KOrange) !important; }

/* Custom table for dark/light mode */
.custom-table {
  color: var(--text-main);
  border-collapse: separate;
  border-spacing: 0;
}
.custom-table th {
  color: var(--text-muted);
  font-weight: 700;
  border-bottom: 2px solid var(--border-color) !important;
}
.custom-table td {
  border-bottom: 1px solid var(--border-color);
  background-color: var(--bg-surface);
  transition: background-color var(--transition-speed);
}
.recipe-row:last-child td {
  border-bottom: none;
}
.recipe-row:hover td {
  background-color: var(--bg-body);
}

/* Row Action Buttons hover state */
.action-buttons {
  transition: opacity 0.2s ease;
}
.recipe-row:hover .action-buttons {
  opacity: 1;
}

.btn-action {
  background-color: transparent;
  border: 1px solid transparent;
  width: 35px;
  height: 35px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
}
.btn-action:hover {
  background-color: var(--bg-body);
  border-color: var(--border-color);
  transform: translateY(-2px);
  box-shadow: 0 4px 6px rgba(0,0,0,0.05);
}

/* Badges and tags */
.status-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  display: inline-block;
}

.bg-success-soft {
  background-color: rgba(64, 192, 87, 0.15);
}
.text-success { color: #40c057 !important; }

.bg-danger-soft {
  background-color: rgba(250, 82, 82, 0.15);
}
.text-danger { color: #fa5252 !important; }

.bg-light { background-color: var(--bg-body) !important; }
.text-dark { color: var(--text-main) !important; }

/* In dark mode, outline buttons need slightly different hover colors to look good */
@media (prefers-color-scheme: dark) {
  .btn-outline-primary.border-secondary {
    border-color: var(--border-color) !important;
  }
}
</style>
