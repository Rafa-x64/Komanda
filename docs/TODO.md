# 🚀 KOMANDA: Checklist Maestra de Desarrollo

> [!TIP]
> Mantén este documento actualizado marcando las casillas (`[x]`) a medida que avanzas en el desarrollo.

---

## 🎨 FRONTEND (Vue 3 + Tailwind)

### 🏗️ Fase 1: Fundamentos y UI/UX

- [ ] **Definir y aprobar requisitos UX funcionales**
  - [ ] Documentar historias de usuario (Mesero, Cocina, Cajero, Admin).
  - [ ] Establecer criterios de aceptación claros para cada pantalla.
- [ ] **Diseñar prototipos de alta fidelidad**
  - [ ] Mockups para POS (Tablet/Móvil).
  - [ ] Mockups para KDS (Pantalla Cocina).
  - [ ] Mockups para Inventario y Reportes Contables.
- [ ] **Definir sistema de diseño y componentes UI**
  - [x] **Landing Page:** Implementación de página de inicio con branding "Komanda".
  - [ ] Crear biblioteca de componentes (Botones, Inputs, Cards, Tablas).
  - [ ] Configurar tema de Tailwind (Colores, Tipografía).
- [ ] **Implementar autenticación y RBAC en UI**
  - [ ] Login, Logout y manejo de Tokens (JWT).
  - [ ] Protección de rutas según Rol (Guardias de navegación).

### 🍳 Fase 2: Módulos Operativos

- [ ] **Desarrollar pantalla de toma de pedidos (Mesero)**
  - [ ] Interfaz de selección de mesas y platos.
  - [ ] **Validación visual de stock:** Deshabilitar plato si backend reporta "0 stock".
- [ ] **Desarrollar KDS (Gestión de Cocina)**
  - [ ] Tablero (Kanban/Lista) para ver comandas entrantes.
  - [ ] WebSockets/Polling para recepción en tiempo real.
  - [ ] Botón "Orden Lista" (Dispara evento de back-flushing).
- [ ] **Desarrollar Caja y Facturación**
  - [ ] Interfaz de cobro (Efectivo, Tarjeta, Mixto).
  - [ ] Cierre de caja (Resumen del día).

### 📦 Fase 3: Calidad y Entrega Frontend

- [ ] **Implementar validaciones en cliente**
  - [ ] Bloqueos preventivos y mensajes de error amigables.
- [ ] **Pruebas E2E y usabilidad**
  - [ ] Testear flujo crítico: Login ➔ Comanda ➔ Cocina ➔ Cobro.
- [ ] **Preparar build y artefactos**
  - [ ] Configuración de Vite optimizada para producción.

---

## ⚙️ BACKEND (Node/TS o PHP + Postgres)

### 🧠 Fase 1: Arquitectura y Datos (Core Contable)

- [ ] **Formalizar requisitos funcionales y contables**
  - [ ] Definir reglas de negocio: "Cálculo de Costo Promedio".
- [ ] **Modelado de datos y diseño de esquema (ERD)**
  - [ ] Tablas: `Insumos`, `Recetas`, `Ventas`, `MovimientosInventario`, `AsientosContables`.
- [ ] **Diseñar lógica de valorización**
  - [ ] Algoritmo de Costo Promedio Ponderado (CPP).
- [ ] **Implementar capa de persistencia con transacciones**
  - [ ] Asegurar ACID: Si falla el descuento de inventario, falla la venta.

### 🔌 Fase 2: APIs y Lógica de Negocio

- [ ] **API de Gestión de Insumos y Compras**
  - [ ] CRUD de insumos.
  - [ ] Endpoint `POST /compra`: Aumenta stock y recalcula costo promedio.
- [ ] **API de Recetas y Costos**
  - [ ] Lógica para calcular costo dinámico de un plato (BOM).
- [ ] **API de Comandas (Transaccional)**
  - [ ] Endpoint `POST /order`: Verifica stock ➔ Crea Orden ➔ Reserva Stock.
- [ ] **Lógica de Back-flushing (Cocina)**
  - [ ] Evento "Entregado": Resta inventario real y registra costo de venta.
- [ ] **Módulo Contable Automático**
  - [ ] Generación automática de asientos: "Venta" vs "Costo de Venta".
  - [ ] Endpoints para Balance General y Estado de Resultados.

### 🛡️ Fase 3: Seguridad y Testing Backend

- [ ] **Seguridad y RBAC**
  - [ ] Middleware para validar roles y permisos en cada endpoint.
- [ ] **Pruebas unitarias e integración**
  - [ ] Testear casos borde: Inventario negativo, concurrencia de pedidos.
  - [ ] Validar que los asientos contables cuadren (Debe = Haber).

---

## 🔄 TRANSVERSAL Y DEVOPS

- [ ] **Configurar CI/CD**
  - [ ] Pipelines para linting, testing y build.
- [ ] **Plan de pruebas de aceptación**
  - [ ] Verificar trazabilidad financiera completa (Req. Profesora).
- [ ] **Plan de migración y datos maestros**
  - [ ] Scripts (Seeds) para cargar ingredientes iniciales y recetas.
- [ ] **Documentación final**
  - [ ] Manual de usuario, API Docs (Swagger/OpenAPI) y diagrama ER.
