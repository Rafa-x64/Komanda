# Estructura del Proyecto Komanda

Este documento define la estructura de directorios y archivos del proyecto `komanda-project`, explicando el propósito de cada componente.

```text
komanda-project/
├── 📂 .vscode/                 # Configuraciones del editor (VSCode)
│   └── extensions.json         # Extensiones recomendadas para el proyecto
│
├── 📂 docs/                    # Documentación del proyecto
│   ├── 📂 instalation-guides/  # Guías de instalación y configuración
│   ├── API_CONTRACTS.md        # Definición de contratos de API
│   ├── ARCHITECTURE.md         # Documentación de arquitectura del sistema
│   ├── DOMAIN.md               # Definición del lenguaje de dominio
│   ├── KOMANDA.md              # Visión general del producto Komanda
│   ├── MANUAL_BACKEND.md       # Guía de desarrollo para el Backend
│   ├── MANUAL_FRONTEND.md      # Guía de desarrollo para el Frontend
│   └── ...                     # Otros archivos de documentación y licencias
│
├── 📂 Komanda-api/             # Backend API (Node.js + Express + TypeScript)
│   ├── 📂 src/
│   │   ├── 📂 api/             # Definición de rutas y endpoints HTTP base
│   │   ├── 📂 config/          # Configuraciones globales (Variables de entorno, constantes)
│   │   ├── 📂 modules/         # Módulos de dominio de negocio (Business Logic)
│   │   │   ├── 📂 inventory/   # Gestión de inventario (Productos, Stock)
│   │   │   │   ├── *.controller.ts # Controladores de entrada
│   │   │   │   ├── *.service.ts    # Lógica de negocio
│   │   │   │   ├── *.model.ts      # Modelos de datos
│   │   │   │   └── ...
│   │   │   ├── 📂 kitchen/     # Gestión de cocina y comandas
│   │   │   └── 📂 sales/       # Gestión de ventas y transacciones
│   │   ├── 📂 shared/          # Código compartido y utilidades transversales
│   │   │   ├── 📂 database/    # Configuración de base de datos y migraciones
│   │   │   └── 📂 services/    # Servicios compartidos (Email, Storage, etc.)
│   │   └── index.ts            # Punto de entrada de la aplicación API
│   ├── package.json            # Dependencias y scripts del Backend
│   └── tsconfig.json           # Configuración de TypeScript
│
├── 📂 Komanda-web/             # Frontend Web App (Vue 3 + Vite + Tailwind)
│   ├── 📂 public/              # Archivos estáticos públicos (favicon, robots.txt)
│   ├── 📂 src/
│   │   ├── 📂 assets/          # Recursos estáticos procesados (Imágenes, CSS global)
│   │   ├── 📂 components/      # Componentes UI reutilizables globlales (Botones, Inputs)
│   │   ├── 📂 core/            # Núcleo de la aplicación frontend
│   │   │   ├── 📂 api/         # Clientes HTTP y configuración de Axios/Fetch
│   │   │   └── 📂 hooks/       # Composables (Hooks) globales de Vue
│   │   ├── 📂 modules/         # Módulos de Frontend (Vistas y lógica por dominio)
│   │   │   ├── 📂 inventory/   # Interfaz de gestión de inventario
│   │   │   ├── 📂 kitchen/     # Interfaz de cocina (Pantalla de comandas)
│   │   │   ├── 📂 pos/         # Punto de Venta (Terminal de cobro)
│   │   │   └── 📂 reports/     # Dashboards y visualización de datos
│   │   ├── App.vue             # Componente raíz de la aplicación
│   │   ├── main.ts             # Punto de entrada, montaje de Vue y plugins
│   │   └── style.css           # Estilos globales (Tailwind imports)
│   ├── index.html              # Plantilla HTML principal
│   ├── package.json            # Dependencias y scripts del Frontend
│   ├── vite.config.ts          # Configuración de Vite (Build, Server, Plugins)
│   └── ...                     # Configs de TS y herramientas
│
├── .gitignore                  # Archivos ignorados por Git
├── package.json                # Configuración del workspace (si aplica) o raíz
└── README.md                   # Documentación general y "Landing page" del repo
```

## Leyenda de Directorios Importantes

### 📂 Komanda-api/src/modules

Este directorio contiene la lógica de negocio dividida por dominios. Cada carpeta aquí representa una funcionalidad vertical del sistema (Inventory, Sales, Kitchen, etc.). Dentro de cada módulo encontrarás:

- **Controllers**: Manejan las peticiones HTTP.
- **Services**: Contienen la lógica de negocio pura.
- **Models**: Definen la estructura de los datos.

### 📂 Komanda-web/src/modules

Es el espejo del backend en el frontend. Cada carpeta aquí contiene las interfaces de usuario (Vistas) y la lógica de estado correspondiente a un dominio específico. Esto facilita la navegación y el mantenimiento del código al agrupar todo lo relacionado con una funcionalidad en un solo lugar.
