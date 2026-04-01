# 🚀 Roadmap de Desarrollo - Komanda
> Sistema Web Contable SaaS para Restaurantes

Plan de distribución de trabajo sugerido para **3 equipos (2 desarrolladores por equipo)**, dividido en entregas funcionales por Sprints (semanas).

El enfoque está estructurado siguiendo la arquitectura modular y el patrón DDD-Lite actual, con los **5 módulos consolidados** según los requerimientos del enunciado académico.

---

## 🏁 Semana 1: Core Operativo — Almacén, Recetas y Punto de Venta

El objetivo de esta semana es lograr el **Flujo Principal Completo**: un ingrediente entra por compra → se define una receta → se vende un plato → el inventario se descuenta automáticamente.

### 🔴 Equipo 1: Almacén y Compras

- **Backend (`Komanda-api/src/modules/warehouse`)**:
  - CRUD de ingredientes (nombre, unidad de medida, stock actual, stock mínimo).
  - Endpoint `POST /purchases`: Registra entrada de mercancía, aumenta stock y **recalcula el Costo Promedio Ponderado (CPP)** del ingrediente.
  - Gestión de proveedores y cuentas por pagar generadas en cada compra.
- **Frontend (`Komanda-web/src/modules/warehouse`)**:
  - Vista de listado de ingredientes con alerta visual de stock crítico.
  - Formulario de registro de compra con selección de ingrediente, cantidad, precio unitario y proveedor.

### 🟡 Equipo 2: Menú y Recetas

- **Backend (`Komanda-api/src/modules/menu`)**:
  - CRUD de platos/recetas (Bill of Materials).
  - Lógica de cálculo del costo dinámico de un plato (suma de `CPP * cantidad` de cada ingrediente).
  - Endpoint de sugerencia de precio (costo + margen configurado).
  - Endpoint de validación de stock disponible para un plato.
- **Frontend (`Komanda-web/src/modules/menu`)**:
  - Formulario de creación/edición de receta con ingredientes y cantidades.
  - Visualización del costo calculado y precio sugerido en tiempo real.
  - Ajuste manual de precio de venta por parte del Admin.

### 🟢 Equipo 3: Punto de Venta (POS + Caja)

- **Backend (`Komanda-api/src/modules/pos`)**:
  - Endpoint `POST /sales`: Verifica stock → Crea Venta → Registra método(s) de pago → Dispara back-flushing de inventario.
  - Soporte para múltiples métodos de pago por transacción (efectivo, pago móvil, tarjeta, divisa).
  - Endpoint de cierre de caja con resumen por método de pago.
- **Frontend (`Komanda-web/src/modules/pos`)**:
  - Pantalla de selección de platos (deshabilita los que no tienen stock).
  - Registro de pago con selección de método(s) y montos.
  - Generación de ticket/comprobante de venta.
  - Cierre de caja diario (arqueo).

---

## 📈 Semana 2: Contabilidad, Gastos y Reportes

El objetivo de la segunda semana es completar la **capa contable y los reportes financieros**, habilitando la vista gerencial completa.

### 🔴 Equipo 1: Módulo Contable Automatizado

- **Backend (`Komanda-api/src/modules/accounting`)**:
  - Generación automática de asientos contables para cada evento del sistema:
    - Compra de ingredientes → Asiento de Inventario vs. Cuentas por Pagar.
    - Venta → Asiento de Ingreso + Asiento de Costo de Venta.
    - Gasto operativo → Asiento de Gasto vs. Caja/Banco.
  - Endpoints para Balance General y Estado de Resultados (con filtros de período).
  - Reporte de Rentabilidad por plato (costo producción vs. precio venta).
- **Frontend (`Komanda-web/src/modules/accounting`)**:
  - Vista de Balance General con Activos, Pasivos y Patrimonio.
  - Vista de Estado de Resultados (Ingresos, Costo de Ventas, Gastos, Utilidad Neta).
  - Reporte de rentabilidad por plato (tabla comparativa).

### 🟡 Equipo 2: Gastos Operativos y Dashboard Gerencial

- **Backend (`Komanda-api/src/modules/expenses`)**:
  - CRUD de gastos operativos fijos: agua, gas, electricidad, internet, alquiler.
  - Asociación de cada gasto a su asiento contable automático.
- **Frontend (`Komanda-web/src/modules/expenses`)**:
  - Formulario de registro de gasto operativo.
  - Historial y resumen mensual de gastos por categoría.
- **Frontend (`Komanda-web/src/modules/dashboard`)**:
  - Dashboard gerencial con KPIs: ventas del día, costo de ventas, utilidad neta, alertas de stock crítico.

### 🟢 Equipo 3: Autenticación, RBAC y Gestión SaaS

- **Backend (`Komanda-api/src/modules/auth` & `users`)**:
  - Autenticación JWT (Login/Logout).
  - RBAC: Middleware de validación de roles por endpoint.
  - Gestión multi-tenant: cada usuario pertenece a un restaurante específico.
  - Super-admin para gestión de todos los restaurantes.
- **Frontend (`Komanda-web/src/modules/auth`)**:
  - Pantalla de Login y protección de rutas por rol.
  - Panel de gestión de usuarios y roles (solo Admin/Gerente).

---

## 🗺️ Módulos del Sistema (Resumen)

| Módulo              | Backend Path                        | Frontend Path                       | Rol Mínimo |
| :------------------ | :---------------------------------- | :---------------------------------- | :--------- |
| Almacén y Compras   | `modules/warehouse`                 | `modules/warehouse`                 | Admin      |
| Menú y Recetas      | `modules/menu`                      | `modules/menu`                      | Admin      |
| Punto de Venta      | `modules/pos`                       | `modules/pos`                       | Cajero     |
| Contabilidad        | `modules/accounting`                | `modules/accounting`                | Admin      |
| Gastos Operativos   | `modules/expenses`                  | `modules/expenses`                  | Admin      |
| Autenticación       | `modules/auth`                      | `modules/auth`                      | Todos      |
| Usuarios/RBAC       | `modules/users`                     | `modules/users`                     | Admin      |

---

## 🛠 Directrices para los Equipos

> **Normas de Desarrollo Komanda (Recordatorio):**
>
> 1. **Contratos API Primeros**: Antes de codear, backend y frontend deben acordar la estructura del JSON que van a intercambiar.
> 2. **Composables en Vue**: Toda lógica de negocio del frontend (llamadas API, estado) debe ir en `composables/useModulo.ts`, nunca directo en la vista.
> 3. **Validaciones Zod**: El backend blinda toda entrada con Zod. Si el JSON está mal, explota en la puerta.
> 4. **No mezclar responsabilidades**: DDD-Lite en la API. El controlador solo recibe y responde. La lógica va en el servicio.
> 5. **Integridad ACID**: Las operaciones transaccionales (venta + descuento inventario + asiento contable) deben ser atómicas: todo o nada.
> 6. **Multi-tenant siempre**: Todo endpoint debe filtrar por `restaurant_id` del token JWT. Nunca retornar datos de otro restaurante.
