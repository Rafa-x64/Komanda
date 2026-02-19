# 📜 ChangeLog

Todas las actualizaciones notables documentadas en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

## [v0.0.3] - 2026-02-18

### 🗄️ Base de Datos (Breaking Change v2.1)

- **Organización por Esquemas PostgreSQL:** Separación lógica en `core`, `inventario`, `menu`, `operaciones`, `finanzas`, `contabilidad`.

- **Robustez Operativa (v2.1):**
  - **Conversiones:** `compra_detalle` incluye `factor_conversion` y columna calculada `cantidad_inventario` para manejar unidades de compra vs consumo.
  - **Descuentos y Propinas:** Campos financieros agregados a `pedidos` y `facturas`. Configuración de `propina_porcentaje` en restaurante.
  - **Reservas:** Nueva tabla `operaciones.reservas` con estado y datos de cliente.
  - **Imágenes:** Campo `imagen_url` en recetas para KDS/POS.
  - **Mermas:** Tabla de registro de desperdicios y campo `merma_teorica_porcentaje` en ingredientes.
- **Tablas Nuevas Clave:** `menu.categorias`, `contabilidad.libro_diario`.
- **Correcciones de Dominio:** ENUMs alineados con `DOMAIN.md` (`estado_pedido`, `estado_cuenta`).
- **Seguridad:** `password_hash` en usuarios. Auditoría completa (`created_at`/`updated_at`) con triggers.

### 📚 Documentación

- **[CAMBIOS_BD_v2.txt](./CAMBIOS_BD_v2.txt):** Resumen detallado de la versión 2.1.

## [v0.0.1] - 2026-02-07

### 🗄️ Base de Datos (Breaking Change)

- **Organización por Esquemas PostgreSQL:** Todas las tablas migradas del schema `public` a 6 esquemas lógicos:
  - `core` — Restaurante, usuarios, roles, métodos de pago, unidades de medida.
  - `inventario` — Ingredientes, proveedores, compras, mermas, unidades de compra.
  - `menu` — Categorías, recetas, ingredientes de receta.
  - `operaciones` — Mesas, meseros, pedidos, facturas.
  - `finanzas` — Caja, banco, egresos y movimientos.
  - `contabilidad` — Libro diario (asientos contables).
- **Tablas Nuevas:**
  - `inventario.mermas` — Registro de desperdicios y pérdidas de inventario.
  - `menu.categorias` — Categorías del menú (Entradas, Bebidas, Postres, etc.).
  - `contabilidad.libro_diario` — Asientos contables simplificados para estados financieros.
- **Autenticación:** Campo `password_hash` agregado a `core.usuarios`.
- **ENUMs Corregidos:**
  - `estado_pedido` alineado con `DOMAIN.md`: `pendiente → enviado → preparando → listo → entregado → anulado`.
  - Nuevo `estado_cuenta`: `abierta → cuenta_pedida → pagada → cerrada`.
  - Nuevo `tipo_merma`: `desperdicio, vencimiento, rotura, otro`.
- **Columnas Nuevas:**
  - `operaciones.pedido_detalle.notas` — Instrucciones para cocina ("Sin piña", "Extra queso").
  - `operaciones.facturas` — `metodo_pago_id`, `usuario_id`, `cliente_nombre`, `cliente_identificacion`.
  - `core.restaurante` — `direccion`, `telefono`, `email`, `moneda`, `zona_horaria`, `impuesto_porcentaje`, `logo_url`, `activo`.
  - `menu.recetas.categoria_id` — FK a categorías de menú.
- **Auditoría:** `created_at` / `updated_at` en todas las tablas relevantes + 10 triggers de auto-update.
- **Precisión:** Campos financieros ampliados de `DECIMAL(10,2)` a `DECIMAL(12,2)`.

### 📚 Documentación

- **[CAMBIOS_BD_v2.txt](./CAMBIOS_BD_v2.txt):** Resumen detallado de todos los cambios de BD.

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

## [v0.0.2] - 2026-02-11

### 🚀 Novedades (Features)

- **Landing Page Responsiva:** Se ha implementado la página de aterrizaje completa en `src/modules/landing`.
  - **Componentes:** `HeroSection`, `FeaturesSection`, `AboutSection`, `ContactSection`, `AppHeader`, `AppFooter`.
  - **UI/UX:** Diseño moderno con animaciones de entrada, efectos hover y glassmorphism.
  - **Tema KOrange:** Integración de la identidad visual "KOrange" con soporte nativo para **Modo Oscuro** y **Claro**.
- **Sistema de Diseño Global:**
  - Variables CSS para colores semánticos (`--KOrange`, `--bg-body`, `--text-primary`) en `style.css`.
  - Configuración de tipografía `Inter` y utilidades de espaciado.
- **Navegación Móvil:** Menú hamburguesa funcional en `AppHeader`.

---

> "Gestionar un restaurante sin KOMANDA no es mala suerte, es una deficiencia operativa."
