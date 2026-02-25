# 📜 ChangeLog

Todas las actualizaciones notables documentadas en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

---

## [v0.0.3] - 2026-02-18

### 🗄️ Base de Datos (Breaking Change v2.1)

> [!WARNING]
> Esta versión incluye cambios disruptivos (Breaking Changes) en la estructura de la base de datos PostgreSQL.

- **Organización por Esquemas PostgreSQL:** Separación lógica en `core`, `inventario`, `menu`, `operaciones`, `finanzas`, `contabilidad`.
- **Robustez Operativa (v2.1):**
  - **Conversiones:** `compra_detalle` ahora incluye `factor_conversion` y una columna calculada `cantidad_inventario` para manejar unidades de compra vs consumo.
  - **Descuentos y Propinas:** Campos financieros agregados a `pedidos` y `facturas`. Configuración de `propina_porcentaje` en restaurante.
  - **Reservas:** Nueva tabla `operaciones.reservas` con estado y datos de cliente.
  - **Imágenes:** Campo `imagen_url` en recetas para KDS/POS.
  - **Mermas:** Tabla de registro de desperdicios y campo `merma_teorica_porcentaje` en ingredientes.
- **Tablas Nuevas Clave:** `menu.categorias`, `contabilidad.libro_diario`.
- **Correcciones de Dominio:** ENUMs alineados con `DOMAIN.md` (`estado_pedido`, `estado_cuenta`).
- **Seguridad:** `password_hash` en usuarios. Auditoría completa (`created_at`/`updated_at`) con triggers automáticos.

### 📚 Documentación

- **[CAMBIOS_BD_v2.txt](./CAMBIOS_BD_v2.txt):** Resumen detallado de la versión 2.1.

---

## [v0.0.1] - 2026-02-07

### 🗄️ Base de Datos (Breaking Change)

> [!WARNING]
> Refactorización masiva inicial: Todas las tablas migradas del schema `public` a 6 esquemas lógicos.

- **Esquemas:**
  - `core` — Restaurante, usuarios, roles, métodos de pago, unidades de medida.
  - `inventario` — Ingredientes, proveedores, compras, mermas, unidades de compra.
  - `menu` — Categorías, recetas, ingredientes de receta.
  - `operaciones` — Mesas, meseros, pedidos, facturas.
  - `finanzas` — Caja, banco, egresos y movimientos.
  - `contabilidad` — Libro diario (asientos contables).
- **Nuevas Tablas:** `inventario.mermas`, `menu.categorias`, `contabilidad.libro_diario`.
- **Autenticación:** Campo `password_hash` en `core.usuarios`.
- **ENUMs Corregidos:** `estado_pedido`, `estado_cuenta`, `tipo_merma`.
- **Columnas Nuevas:** `notas` en `pedido_detalle`, datos de cliente y pago en `facturas`, datos de la empresa en `restaurante`, `categoria_id` en `recetas`.
- **Auditoría & Precisión:** `created_at`/`updated_at` + triggers; campos financieros a `DECIMAL(12,2)`.

### 📚 Documentación

- **[CAMBIOS_BD_v2.txt](./CAMBIOS_BD_v2.txt):** Resumen detallado de todos los cambios de la base de datos.

---

## [v0.0.1] - 2026-02-07

### 🚀 Novedades (Features)

- **Hybrid Core Architecture:** Se ha implementado la arquitectura híbrida que permite ejecutar **Node.js** (Puerto 3000) y **PHP** (Puerto 8000) simultáneamente.
- **Kitchen Monitor (MVP):** Nueva vista en Vue 3 (`KitchenStatus.vue`) que consume datos en tiempo real de ambos backends.
  - Endpoints: Node `/api/v1/kitchen/status` y PHP `/api/stats.php`.

### 📚 Documentación (Docs)

> [!NOTE]
> Se ha creado la "Constitución" del proyecto para estandarizar el desarrollo.

- **[ARCHITECTURE.md](./ARCHITECTURE.md):** Definición del Monolito Modular y DDD-Lite.
- **[DOMAIN.md](./DOMAIN.md):** Glosario de términos y Estados de Pedidos.
- **[API_CONTRACTS.md](./API_CONTRACTS.md):** Estándares de respuesta JSON.
- **[MANUAL_BACKEND.md](./MANUAL_BACKEND.md):** Guía de endpoints Node y PHP (Hybrid).
- **[MANUAL_FRONTEND.md](./MANUAL_FRONTEND.md):** Guía de Frontend Vue 3.
- **README.md:** Reescrito con formato profesional "Dev-to-Dev" e integraciones.

### 🛠 Infraestructura & Fixes

- **Orquestación:** Nuevo comando `pnpm komanda` (alias `pnpm dev`) para concurrencia.
- **CORS:** Habilitado para Express y PHP.
- **Instalación:** Verificación y creación de guías multiplataforma.

---

## [v0.0.2] - 2026-02-11

### 🚀 Novedades (Features)

- **Landing Page Responsiva:** Implementación en `src/modules/landing`.
  - Componentes principales desarrollados con Glassmorphism y animaciones.
  - **Tema KOrange:** Integración del modo oscuro/claro con CSS Variables.
- **Sistema de Diseño Global:** Definición en `style.css` de `--KOrange`, `--bg-body` e `Inter` font.
- **Navegación Móvil:** Menú hamburguesa implementado.

---

> _"Gestionar un restaurante sin KOMANDA no es mala suerte, es una deficiencia operativa."_
