# 🎨 Manual de Frontend (Vue 3 + Vite)

> "Aquí convertimos JSONs fríos en experiencias calientes y deliciosas."

## 1. Estructura de un Módulo Nuevo

Igual que en el Backend, creamos una carpeta en `src/modules/` para mantener el orden.

```bash
/src/modules/promotions/
├── components/          # Botones, Tarjetas, Modales específicos de Promociones
│   ├── PromotionCard.vue
│   └── ApplyDiscountModal.vue
├── views/               # Páginas completas (Rutas)
│   ├── PromotionsList.vue
│   └── CreatePromotion.vue
├── store.ts             # Pinia Store (Estado global del módulo)
└── routes.ts            # Defines las rutas de Vue Router
```

## 2. Creando una Vista (Paso a Paso)

### A. Define la Ruta

En `router/index.ts` (o `modules/promotions/routes.ts`), registra tu vista.

```typescript
{
  path: '/promotions',
  name: 'PromotionsList',
  component: () => import('@/modules/promotions/views/PromotionsList.vue')
}
```

### B. Crea el Store (Pinia)

Maneja el estado y las llamadas a la API.

```typescript
// store.ts
import { defineStore } from "pinia";
import api from "@/core/api"; // Axios instance pre-configurada

export const usePromotionsStore = defineStore("promotions", {
  state: () => ({
    list: [],
    loading: false,
  }),
  actions: {
    async fetchPromotions() {
      this.loading = true;
      try {
        const { data } = await api.get("/promotions");
        this.list = data;
      } finally {
        this.loading = false;
      }
    },
  },
});
```

### C. Crea la Vista (Vue SFC)

Usa **Composition API** (`<script setup>`) siempre.

```vue
<!-- views/PromotionsList.vue -->
<script setup lang="ts">
import { onMounted } from "vue";
import { usePromotionsStore } from "../store";
import PromotionCard from "../components/PromotionCard.vue";

const store = usePromotionsStore();

onMounted(() => {
  store.fetchPromotions();
});
</script>

<template>
  <div class="promotions-layout">
    <h1>Promociones Activas</h1>
    <div v-if="store.loading">Cargando...</div>
    <div v-else class="grid">
      <PromotionCard
        v-for="promo in store.list"
        :key="promo.id"
        :data="promo"
      />
    </div>
  </div>
</template>
```

## 3. Estilos (Tailwind CSS)

Usa clases utilitarias para la estructura (`flex`, `grid`, `p-4`) y componentes base para la consistencia.

```html
<!-- ✅ BIEN -->
<button class="btn-primary">Guardar</button>

<!-- ❌ MAL (No reinventes la rueda) -->
<button style="background: blue; padding: 10px;">Guardar</button>
```

## 4. Conexión con Backend

Usa siempre la instancia de `api` configurada en `core/api`. Ya maneja:

- Tokens de autenticación (Headers).
- Manejo de errores global (Toasts).
- Base URL variable según entorno.

---

> **Tip:** Usa `pnpm dev:web` si solo vas a tocar CSS o componentes, para que Vite vuele.
