# 🎨 Manual de Frontend (Vue 3 + Vite)

> "Aquí convertimos JSONs fríos en experiencias calientes y deliciosas."

Este manual te guiará para crear interfaces en Vue 3 que consuman datos tanto del **Node Core** como del **PHP Core**.

---

## 📌 Tabla de Contenidos

1.  [Estructura de un Módulo](#1-estructura-de-un-módulo)
2.  [Creando una Vista (Kitchen Monitor)](#2-creando-una-vista-kitchen-monitor)
3.  [Consumiendo el Backend Híbrido](#3-consumiendo-el-backend-híbrido)
4.  [Estilos & UI Kit](#4-estilos--ui-kit)

---

## 1. Estructura de un Módulo

Igual que en el Backend, creamos una carpeta en `src/modules/` para mantener el orden.

```bash
/src/modules/kitchen/
├── components/          # Widgets (Tarjetas, Gráficos)
├── views/               # Vistas Completas (KitchenMonitor.vue)
└── routes.ts            # Rutas de este módulo
```

---

## 2. Creando una Vista (Kitchen Monitor)

Usamos **Composition API** (`<script setup>`) exclusivo. Es más limpio y fácil de tipar.

```vue
<!-- views/KitchenMonitor.vue -->
<script setup lang="ts">
import { ref, onMounted } from "vue";

// 1. Estado Reactivo
const status = ref(null);
const loading = ref(true);

// ... lógica de fetch aquí ...
</script>

<template>
  <div class="p-4">
    <h1 class="text-2xl font-bold">Monitor de Cocina 🍳</h1>
    <!-- Tu HTML con clases de Tailwind/Bootstrap -->
  </div>
</template>
```

---

## 3. Consumiendo el Backend Híbrido

Aquí está el truco. Tienes dos fuentes de verdad:

### A. Consumir Node.js (Puerto 3000)

Para lógica de negocio, usuarios, estados en tiempo real.

```typescript
// URL Base: http://localhost:3000/api/v1/...
const fetchNodeData = async () => {
  const res = await fetch("http://localhost:3000/api/v1/kitchen/status");
  const json = await res.json();
  return json.data;
};
```

### B. Consumir PHP (Puerto 8000)

Para reportes, estadísticas complejas, PDFs.

```typescript
// URL Base: http://localhost:8000/api/...
const fetchPhpData = async () => {
  // Apunta directo al archivo .php
  const res = await fetch("http://localhost:8000/api/stats.php");
  const json = await res.json();
  return json.data;
};
```

### C. Ejemplo de Integración Completa (`onMounted`)

```typescript
onMounted(async () => {
  try {
    const [nodeData, phpData] = await Promise.all([
      fetchNodeData(),
      fetchPhpData(),
    ]);

    console.log("Sistema:", nodeData);
    console.log("Reporte:", phpData);
  } catch (e) {
    console.error("Error conectando a los servidores", e);
  }
});
```

---

## 4. Estilos & UI Kit

No escribas CSS puro si no es necesario. Usa las clases de utilidad.

- ✅ `class="btn btn-primary"` (Bootstrap)
- ✅ `class="p-4 bg-white rounded shadow"` (Tailwind)
- ❌ `style="border: 1px solid red"` (CSS Inline - Evitar)

---

> **Tip:** Recuerda que para que esto funcione, los scripts de PHP deben tener el header `Access-Control-Allow-Origin: *`. Si ves un error de CORS en la consola, es culpa del Backend, no tuya.
