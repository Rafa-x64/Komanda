# 📜 ChangeLog

Todas las actualizaciones notables documentadas en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

## [v0.0.1] - 2026-02-07

### 🚀 Novedades (Features)

- **Hybrid Core Architecture:** Se ha implementado la arquitectura híbrida que permite ejecutar **Node.js (Puerto 3000)** y **PHP (Puerto 8000)** simultáneamente.
- **Kitchen Monitor (MVP):** Nueva vista en Vue 3 (`KitchenStatus.vue`) que consume datos en tiempo real de ambos backends.
  - **Node.js Endpoint:** `/api/v1/kitchen/status` para el estado operativo de la cocina.
  - **PHP Endpoint:** `/api/stats.php` para métricas pesadas y reportes.

### 📚 Documentación (Docs)

Se ha creado la "Constitución" del proyecto para estandarizar el desarrollo:

- **[ARCHITECTURE.md](./docs/ARCHITECTURE.md):** Definición del Monolito Modular y DDD-Lite.
- **[DOMAIN.md](./docs/DOMAIN.md):** Glosario de términos (Cliente vs Comensal) y Estados de Pedidos.
- **[API_CONTRACTS.md](./docs/API_CONTRACTS.md):** Estándares de respuesta JSON (JSend) y eventos de WebSockets.
- **[MANUAL_BACKEND.md](./docs/MANUAL_BACKEND.md):** Guía paso a paso para crear endpoints en Node y PHP (Hybrid).
- **[MANUAL_FRONTEND.md](./docs/MANUAL_FRONTEND.md):** Guía para consumir el Backend Híbrido desde Vue 3 usando `fetch`.
- **README.md:** Reescrito con un tono profesional "Dev-to-Dev", Tabla de Contenidos y links a guías de instalación.

### 🛠 Infraestructura & Fixes

- **Orquestación:** Nuevo comando `pnpm komanda` (alias `pnpm dev`) que levanta Frontend, Node API y PHP Server en paralelo.
- **CORS:** Habilitado `cors` en Express para permitir peticiones desde Vite (Puerto 5173).
- **PHP Fixes:** Corrección de headers `Content-Type` y `Access-Control-Allow-Origin` en scripts PHP.
- **Guías de Instalación:** Verificación y enlazado de guías para Debian, Ubuntu y Windows.

---

> "Gestionar un restaurante sin KOMANDA no es mala suerte, es una deficiencia operativa."
