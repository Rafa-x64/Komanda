# 🚀 KOMANDA: Checklist Maestra de Desarrollo
> Sistema Web Contable SaaS para Restaurantes — Versión post-correcciones académicas

> [!TIP]
> Mantén este documento actualizado marcando las casillas (`[x]`) a medida que avanzas en el desarrollo.

---

## 🎨 FRONTEND (Vue 3 + Bootstrap + CSS)

### 🏗️ Fase 1: Fundamentos y Sistema de Diseño

- [ ] **Definir y aprobar requisitos UX funcionales**
  - [ ] Documentar historias de usuario por rol: Admin, Cajero, Cocina.
  - [ ] Establecer criterios de aceptación claros para cada pantalla.
- [ ] **Prototipos y Diseño**
  - [ ] Mockups para Punto de Venta (Tablet/Escritorio).
  - [ ] Mockups para Almacén y Compras.
  - [ ] Mockups para Menú y Recetas.
  - [ ] Mockups para Contabilidad (Balance General, Estado de Resultados).
  - [ ] Mockups para KDS (Pantalla de Cocina).
- [ ] **Sistema de Diseño**
  - [x] **Landing Page:** Implementada con branding "Komanda".
  - [ ] Crear biblioteca de componentes reutilizables (Botones, Inputs, Cards, Tablas, Modales).
  - [ ] Confirmar paleta de colores KOrange y tipografía Inter en `style.css`.
- [ ] **Autenticación y RBAC en UI**
  - [ ] Login, Logout y manejo de Tokens JWT.
  - [ ] Protección de rutas según rol (Navigation Guards en Vue Router).

---

### 🏪 Fase 2: Módulo — Almacén y Compras (`modules/warehouse`)

- [ ] **Ingredientes**
  - [ ] Vista listado con búsqueda, stock actual y alerta visual de stock crítico.
  - [ ] Formulario CRUD de ingredientes (nombre, unidad de medida, stock mínimo).
- [ ] **Compras**
  - [ ] Formulario de registro de compra (ingrediente, cantidad, precio unitario, proveedor).
  - [ ] Vista de historial de compras por proveedor.
- [ ] **Proveedores**
  - [ ] CRUD de proveedores con datos de contacto.

---

### 🍽️ Fase 3: Módulo — Menú y Recetas (`modules/menu`)

- [ ] **Platos y Recetas**
  - [ ] Listado de platos del menú con costo y precio actual.
  - [ ] Formulario de creación/edición de receta (ingredientes + cantidades).
  - [ ] Visualización del costo calculado en tiempo real al modificar ingredientes.
  - [ ] Sugerencia de precio (costo + margen) con opción de ajuste manual.
- [ ] **Categorías**
  - [ ] CRUD de categorías de menú.

---

### 💳 Fase 4: Módulo — Punto de Venta (`modules/pos`)

- [ ] **Toma de Pedidos**
  - [ ] Pantalla de selección de platos por categoría.
  - [ ] Indicador visual de disponibilidad de stock (plato activo/inactivo).
  - [ ] Carrito de venta (agregar, quitar platos, ver subtotales).
- [x] **Cobro y Transacciones**
  - [x] Selección de método(s) de pago: Efectivo, Pago Móvil, Tarjeta, Divisa.
  - [x] Ingreso de monto por cada método seleccionado (soporte pago mixto).
  - [x] Generación de ticket/comprobante de venta con detalle de métodos.
- [x] **Cierre de Caja**
  - [x] Vista de cierre diario (arqueo) con resumen por método de pago.
  - [x] Registro de fondo inicial de caja.
- [x] **KDS — Cocina (opcional)**
  - [x] Tablero de comandas en tiempo real (Kanban o lista).
  - [x] Botón de cambio de estado: Pendiente → Preparando → Listo.

---

### 💰 Fase 5: Módulo — Contabilidad (`modules/accounting`)

- [ ] **Balance General**
  - [ ] Vista de Activos (Caja/Bancos + Inventario valorizado) y Pasivos (Cuentas por Pagar) y Patrimonio.
  - [ ] Filtro por período (mes, trimestre, año).
- [ ] **Estado de Resultados**
  - [ ] Vista con Ingresos, Costo de Ventas, Gastos Operativos y Utilidad Neta.
  - [ ] Filtro por período.
- [x] **Reporte de Rentabilidad**
  - [x] Tabla comparativa: plato, costo producción, precio venta, margen real.
- [x] **Libro Diario**
  - [x] Vista de asientos contables generados automáticamente.

---

### 🧾 Fase 6: Módulo — Gastos Operativos (`modules/expenses`)

- [ ] **Registro de Gastos**
  - [ ] Formulario: categoría (agua/gas/luz/internet/alquiler), monto, fecha, método de pago.
  - [ ] Historial y resumen mensual de gastos.

---

### 📊 Fase 7: Dashboard Gerencial

- [x] **KPIs del día:** Ventas totales, costo de ventas, utilidad bruta, alertas de stock crítico.
- [x] **Gráfica de ventas** por período.
- [x] **Resumen de gastos** del mes.

---

### ✅ Fase 8: Calidad y Entrega Frontend

- [ ] Validaciones en cliente con mensajes de error amigables.
- [ ] Diseño totalmente responsive (móvil, tablet, desktop).
- [ ] Pruebas del flujo crítico: Login → Compra → Receta → Venta → Contabilidad.
- [ ] Build de producción validado (Vite).

---

## ⚙️ BACKEND (Node.js + TypeScript + Express + TypeORM + Zod)

### 🧠 Fase 1: Arquitectura y Esquema de Base de Datos

- [ ] **Modelado de datos (ERD)**
  - [ ] Tablas: `ingredients`, `suppliers`, `purchases`, `purchase_details`
  - [ ] Tablas: `menu_items`, `recipe_details`, `categories`
  - [ ] Tablas: `sales`, `sale_details`, `payment_transactions`
  - [ ] Tablas: `expenses`
  - [ ] Tablas: `journal_entries` (asientos contables), `accounts` (plan de cuentas)
  - [ ] Tablas: `users`, `roles`, `restaurants` (multi-tenant)
- [ ] **Lógica de Costo Promedio Ponderado (CPP)**
  - [ ] Definir la fórmula: `CPP_nuevo = (Stock_actual * CPP_anterior + Cant_comprada * Precio_compra) / (Stock_actual + Cant_comprada)`
  - [ ] Implementar en `WarehouseService.registerPurchase()`.
- [ ] **Multi-tenant:** Todo query filtra por `restaurant_id`.

---

### 🏪 Fase 2: Módulo Almacén y Compras (`modules/warehouse`)

- [ ] CRUD de ingredientes con validación Zod.
- [ ] CRUD de proveedores.
- [ ] `POST /purchases`: Aumenta stock + recalcula CPP + genera asiento contable (Inventario vs. CxP).
- [ ] Endpoint de ingredientes con stock crítico.

---

### 🍽️ Fase 3: Módulo Menú y Recetas (`modules/menu`)

- [ ] CRUD de platos y recetas (con ingredientes asociados).
- [ ] CRUD de categorías de menú.
- [ ] Endpoint `GET /menu-items/:id/cost`: Calcula costo dinámico de un plato al CPP actual.
- [ ] Endpoint `GET /menu-items/:id/suggested-price`: Costo + margen configurado.
- [ ] Endpoint `GET /menu-items/:id/stock-check`: Verifica si hay stock suficiente para preparar N unidades.

---

### 💳 Fase 4: Módulo Punto de Venta (`modules/pos`)

- [x] `POST /sales`: Transacción atómica: valida stock → crea venta → registra métodos de pago → dispara back-flushing → genera asientos contables.
- [x] Soporte de múltiples `payment_transactions` por `sale_id`.
- [x] `GET /cash-report` y reporte en frontend.
- [x] Endpoint de envío de comanda a cocina (KDS).

---

### 💰 Fase 5: Módulo Contabilidad (`modules/accounting`)

- [ ] Generación automática de asientos contables en cada evento de negocio.
- [ ] `GET /balance-sheet?from=&to=`: Balance General.
- [ ] `GET /income-statement?from=&to=`: Estado de Resultados.
- [x] `GET /profitability-report`: Rentabilidad por plato.
- [x] `GET /journal?from=&to=`: Libro Diario (listado de asientos).

---

### 🧾 Fase 6: Módulo Gastos Operativos (`modules/expenses`)

- [ ] CRUD de gastos (categoría, monto, fecha, método de pago).
- [ ] Genera asiento contable automático en cada registro.
- [ ] `GET /expenses/summary?month=`: Resumen mensual por categoría.

---

### 🛡️ Fase 7: Seguridad y RBAC

- [ ] Autenticación JWT (login, refresh, logout).
- [ ] Middleware global de validación de roles por endpoint.
- [ ] Middleware de tenant (extrae `restaurant_id` del JWT y lo inyecta en los queries).
- [ ] Gestión de usuarios (CRUD) con asignación de roles.

---

### 🧪 Fase 8: Testing y Calidad Backend

- [ ] Tests unitarios: CPP, cálculo de costo de plato, generación de asientos.
- [ ] Tests de integración: Flujo completo venta (stock → costo → asiento).
- [ ] Validar que los asientos cuadren siempre (Debe = Haber).
- [ ] Validar que no es posible vender sin stock suficiente.

---

## 🔄 TRANSVERSAL Y DEVOPS

- [ ] Variables de entorno documentadas en `.env.example`.
- [ ] Seeds (datos iniciales): ingredientes de ejemplo, recetas, usuarios de prueba.
- [ ] Documentación de API (Swagger/OpenAPI).
- [ ] Diagrama ER de la base de datos actualizado.
- [ ] Manual de usuario por rol (Admin, Cajero).
- [ ] CI/CD básico (linting + build automático).
- [ ] Plan de migración para multi-tenant en producción.
