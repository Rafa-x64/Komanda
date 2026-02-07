# 🚀 KOMANDA | The Ultimate Restaurant OS

> "Gestionar un restaurante sin KOMANDA no es mala suerte, es un skill issue operativo."

**KOMANDA** es un sistema de información con visión de **SaaS** diseñado para aniquilar el caos en la gestión de inventarios, ventas, nóminas y pedidos. No estamos inventando la rueda, la estamos haciendo de fibra de carbono para que ruede sola.

## 🧠 La Filosofía (Arquitectura > Improvisación)

Este proyecto no es un "reguero" más. Está construido bajo una **Arquitectura Modular (Domain-Driven Design Lite)**. 

¿Qué significa esto? Que el sistema se divide en **unidades de negocio autónomas**. Si mañana quieres cambiar el módulo de Nómina, no tienes que rezar para que no explote el Inventario. Todo está separado, desacoplado y listo para escalar a mil sucursales si es necesario.

---

## ✨ Módulos Principales

### 📦 Inventario & Back-flushing (El Núcleo)
El inventario es el corazón logístico. Aquí aplicamos **Back-flushing**:
* **Descuento Atómico:** Al confirmar una comanda de 2 Sándwiches Italianos, el sistema consulta la **Receta** y descuenta exactamente la proporción (ej. 200g de tomate, 4 panes).
* **Trazabilidad:** Unidades de compra (Sacos/Kilos) vs Unidades de consumo (Gramos/Unidades).
* **Alertas de Re-orden:** Notificaciones automáticas cuando el stock llega al punto crítico. Evita el "se nos acabó la carne" en pleno servicio.

### 🧾 Ventas & POS (Point of Sale)
* Generación de facturas instantáneas.
* Afiliación de clientes para fidelización.
* Integración directa con el flujo de caja.

### 🍳 Cocina en Tiempo Real (KDS)
* **WebSockets al poder:** Los pedidos llegan de la Tablet del mesero a la pantalla del chef sin refrescar la página.
* **Cronómetro de Pedidos:** Visualización del tiempo de espera para evitar platos fríos y clientes enojados.

### 💰 Pagos & Nómina
* **Gestión de Gastos:** Registra luz, agua, gas y proveedores.
* **Comisiones por Desempeño:** Cálculo automático de pagos para empleados basado en su productividad. Literalmente, premiamos a los que más "carrean" el restaurante.

---

## 🛠 Tech Stack

| Capa | Tecnología | ¿Por qué? |
| :--- | :--- | :--- |
| **Frontend** | Vue.js 3 + Vite | Reactividad instantánea y DX superior. |
| **Styling** | Bootstrap/TailwindCSS | Diseño minimalista sin pelear con CSS global. |
| **Backend** | TS (Node) + PHP | TS para tiempo real (Sockets) y PHP para lógica financiera robusta. |
| **Database** | PostgreSQL | Integridad referencial y escalabilidad SaaS. |
| **Tooling** | Rust-based tools | Porque amamos la velocidad (pnpm/bun). |

---

## 📂 Estructura del Proyecto

Mantenemos una simetría entre Front y Back para que los devs no se pierdan en el limbo.

```text 
komanda-project/
├── 📂 .vscode/                 # Configuraciones del editor (Prettier, ESLint compartidos)
├── 📂 docs/                    # Documentación del proyecto (diagramas, requerimientos)
├── 📂 komanda-api/             # Backend (Node/TS o PHP)
│   ├── 📂 src/
│   │   ├── 📂 config/          # Variables de entorno, DB config
│   │   ├── 📂 shared/          # "Core": Loggers, Middlewares, Types genéricos
│   │   │   ├── 📂 database/    # Migraciones, Seeds
│   │   │   └── 📂 services/    # EmailService, PDFGenerator (cosas genéricas)
│   │   └── 📂 modules/         # <--- AQUÍ ESTÁ LA MAGIA 🪄
│   │       ├── 📂 inventory/   # Todo lo de Inventario vive aquí
│   │       │   ├── inventory.controller.ts
│   │       │   ├── inventory.service.ts
│   │       │   ├── inventory.model.ts
│   │       │   └── logic/      # Lógica compleja (ej. Back-flushing)
│   │       ├── 📂 sales/       # Módulo de Ventas/POS
│   │       ├── 📂 kitchen/     # Módulo de Cocina (Websockets aquí)
│   │       ├── 📂 recipes/     # Recetas y costos
│   │       └── 📂 auth/        # Login, Roles (Mesero, Admin, Cocina)
│   ├── index.ts                # Entry point minimalista
│   └── package.json
│
└── 📂 komanda-web/             # Frontend (Vue 3 + Vite + Tailwind)
    ├── 📂 public/
    ├── 📂 src/
    │   ├── 📂 assets/          # Imágenes, fuentes
    │   ├── 📂 core/            # Componentes UI base (Botones, Inputs, Layouts)
    │   │   ├── 📂 api/         # Axios/Fetch wrapper configurado
    │   │   └── 📂 hooks/       # Composables globales (useTheme, useAuth)
    │   ├── 📂 modules/         # <--- ESPEJO DEL BACKEND 🪞
    │   │   ├── 📂 inventory/
    │   │   │   ├── 📂 components/ # Tablas de stock, Alertas
    │   │   │   ├── 📂 views/      # Páginas completas (InventoryDashboard.vue)
    │   │   │   └── store.ts       # Pinia store solo para inventario
    │   │   ├── 📂 kitchen/        # Vista del cocinero (KDS)
    │   │   ├── 📂 pos/            # Punto de venta (Tablet UI)
    │   │   └── 📂 reports/        # Gráficos y tablas
    │   ├── App.vue
    │   └── main.ts
    ├── index.html
    └── vite.config.ts
```
## Guía de Inicio Rápido
1 Requisitos
- Runtime: Node.js (LTS) o Bun.

- DB: PostgreSQL corriendo (Recomendado vía Docker).

- OS: Preferiblemente Linux (Arch/EndeavourOS, Debian, Ubuntu, Windowzzz).

2 Instalación
```bash
# Clona el repo
git clone https://github.com/Rafa-x64/Komanda.git

# Instala dependencias con pnpm
pnpm install

# Configura tus variables de entorno (.env)
cp .env.example .env

# Levanta el entorno de desarrollo
pnpm dev
```
## Reglas de Oro (No las rompas o mal por todos)
- Código Minimalista: Si funciona en 3 líneas de forma legible, no escribas 10.

- Clean Code: Nada de comentarios obvios. El código debe leerse como una novela. Si es complejo, refactoriza en funciones pequeñas.

- Modularidad: Prohibido importar lógica de inventory dentro de payroll de forma directa. Usa servicios compartidos.

- Optimización: Cada query a la DB cuenta. No traigas el mundo entero si solo necesitas un ID.

---

> PD: Desarrollado con ❤️ (y mucha terminal) por un fanático del minimalismo extremo. ¿Dudas? Abre un issue o simplemente haz un buen PR.
