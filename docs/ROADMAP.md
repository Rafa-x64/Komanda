# 🚀 Roadmap de Desarrollo - Komanda

Plan de distribución de trabajo sugerido para **3 equipos (2 desarrolladores por equipo)**, dividido en entregas funcionales por Sprints (semanas).

El enfoque está estructurado siguiendo la arquitectura modular y el patrón DDD-Lite actual, separando claramente el Backend (Node/PHP) y el Frontend (Vue 3).

---

## 🏁 Semana 1: Operativa Core del Restaurante

El objetivo de esta semana es lograr el **Flujo Principal Completo**: Un mesero puede tomar un pedido, la cocina lo ve en tiempo real, y el inventario se actualiza automáticamente basado en la receta.

### 🔴 Equipo 1: POS (Punto de Venta) y Sistema de Órdenes

- **Frontend (`Komanda-web/src/modules/pos`)**:
  - Diseñar/Implementar la pantalla táctil de toma de pedidos para meseros y caja.
  - Manejo del carrito de compras (productos, notas para cocina, selección de mesa/cliente).
- **Backend (`Komanda-api/src/modules/sales`)**:
  - Creación y persistencia de las órdenes (Orders, OrderItems).
  - Cálculos de subtotal, impuestos, y validación de mesas asignadas.

### 🟡 Equipo 2: Cocina en Tiempo Real (KDS y WebSockets)

- **Frontend (`Komanda-web/src/modules/kitchen` & `realtime`)**:
  - Conectar el `KitchenStatus.vue` ya diseñado a un Socket para recibir los tickets automáticamente sin recargar la página.
  - Lógica y botones para cambiar el estado del ticket: de "Recibido" ➡️ "Preparando" ➡️ "Listo para entregar".
- **Backend (`Komanda-api/src/modules/realtime` & `kitchen`)**:
  - Implementar el servidor de WebSocket (ej: Socket.io) para emitir eventos de "Nueva Orden" a las pantallas de la cocina.
  - Controladores para actualizar el estado del ticket y notificar al MeseroDashboard.

### 🟢 Equipo 3: Menús, Recetas e Inventario

- **Frontend (`Komanda-web/src/modules/inventory` & `recipe`)**:
  - Conectar el formulario de Recetas (`RecipeForm.vue`) y catálogo al Backend.
  - Interfaz de ingreso y gestión de stock del inventario bruto (llegada de proveedores, bajas).
- **Backend (`Komanda-api/src/modules/inventory`)**:
  - Endpoints CRUD de platos/recetas.
  - **Lógica vital**: Disparar el evento de "descuento de inventario bruto" cuando el Equipo 1 confirme una orden, basado en las recetas predefinidas.

---

## 📈 Semana 2: Administración, Caja y Reportes

El objetivo de la segunda semana es consolidar la **Toma de Decisiones y Finanzas**, habilitando la vista gerencial y el flujo de la caja.

### 🔴 Equipo 1: Control de Caja y Facturación

- **Frontend (`Komanda-web/src/modules/dashboard/CajaDashboard.vue`)**:
  - Integración con backend para abrir/cerrar caja con montos exactos.
  - Flujo de Cobro: Múltiples métodos de pago, facturas/tickets de venta, registro de egresos rápidos.
- **Backend (`Komanda-api/src/modules/sales` & Finanzas)**:
  - Modelos de Caja y Transacciones financieras recurrentes.
  - Generación de comprobantes, recibos (PDF) o integración con impresoras térmicas.

### 🟡 Equipo 2: Dashboard Administrativo y Reportes Avanzados

- **Frontend (`Komanda-web/src/modules/dashboard/AdminDashboard.vue` & `reports`)**:
  - Gráficas usando librerías (ej. Chart.js o ECharts) de Ventas del período, Horas Pico, Productos más vendidos.
  - Filtros de fechas y exportación en Excel/PDF.
- **Backend (`Komanda-api/src/modules/reports`)**:
  - Consultas a la BD de alto rendimiento.
  - Cálculos de rentabilidad por plato y cruce de datos con inventario.

### 🟢 Equipo 3: Roles, Perfíles y Meseros

- **Frontend (`Komanda-web/src/modules/dashboard/MeseroDashboard.vue` & Empleados)**:
  - Vista optimizada del Mesero (mis mesas activas, alertas de cocina "orden lista", propinas ganadas).
  - Panel de ABM (Alta, Baja, Modificación) para gestionar permisos de empleados del restaurante.
- **Backend (`Komanda-api/src/modules/users` & `auth`)**:
  - RBAC Avanzado (Role-Based Access Control) verificando en la API que solo personal autorizado haga descuentos o devuelva pagos.

---

## 🛠 Directrices para los Equipos

> **Normas de Desarrollo Komanda (Recordatorio):**
>
> 1. **Contratos API Primeros**: Antes de empezar a codear, los desarrolladores Backend y Frontend de su respectivo módulo deben acordar y firmar (por ej. en Swagger/Postman) la estructura del JSON que van a enviar y recibir.
> 2. **Composables en Vue**: Toda lógica de negocio del frontend (llamadas API, WebSockets) debe hacerse en `composables/useModulo.js`, nunca directo en la vista.
> 3. **Validaciones Entrantes Zod**: El backend debe seguir blindando todo ingreso usando Zod.
> 4. **No mezclar responsabilidades**: Respete siempre el DDD-Lite en la API. Consultas entre dominios indirectos deben pasar por servicios centralizados.
