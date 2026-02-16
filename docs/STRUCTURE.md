# Estructura del Proyecto Komanda

Este documento define la estructura de directorios y archivos del proyecto `Komanda`, explicando el propósito de cada componente. El proyecto está organizado como un **Monorepo** usando `pnpm workspaces`.

```text
komanda-project/
├── 📂 .vscode/                 # Configuraciones del editor (VSCode)
├── 📂 docs/                    # Documentación técnica y de negocio
│   ├── 📂 instalation-guides/  # Guías de despliegue (Windows, Linux)
│   ├── ARCHITECTURE.md         # Documentación de la filosofía DDD-Lite
│   ├── STRUCTURE.md            # Este archivo
│   └── ...                     # Otros manuales y contratos
│
├── 📂 Komanda-api/             # Backend Híbrido (Node.js/TS + PHP)
│   ├── 📂 src/
│   │   ├── 📂 api/             # Endpoints específicos (Ej: stats.php)
│   │   ├── 📂 config/          # Variables de entorno y constantes
│   │   ├── 📂 modules/         # Lógica de negocio (DDD-Lite)
│   │   │   ├── 📂 inventory/   # Gestión de stock y productos
│   │   │   ├── 📂 kitchen/     # Gestión de comandas
│   │   │   └── ...
│   │   ├── 📂 shared/          # Base de datos y utilidades comunes
│   │   └── index.ts            # Punto de entrada Express
│   ├── package.json            # Scripts de Node
│   └── tsconfig.json           # Configuración TS
│
├── 📂 Komanda-web/             # Frontend (Vue 3 + Vite + Bootstrap 5)
│   ├── 📂 public/              # Assets estáticos directos
│   ├── 📂 src/
│   │   ├── 📂 assets/          # Imágenes y CSS global
│   │   ├── 📂 core/            # Configuración de API y hooks globales
│   │   ├── 📂 modules/         # Vistas y lógica por dominio
│   │   │   ├── 📂 kitchen/     # Pantalla de cocina
│   │   │   ├── 📂 landing/     # Landing Page principal
│   │   │   ├── 📂 singin/      # Autenticación (Login)
│   │   │   └── ...
│   │   ├── 📂 router/          # Configuración de Vue Router
│   │   ├── App.vue             # Componente raíz
│   │   ├── main.ts             # Inicialización de la App
│   │   └── style.css           # Estilos globales y variables (KOrange)
│   ├── index.html              # Entry point HTML
│   └── package.json            # Dependencias (Bootstrap, Lucide, etc.)
│
├── 📜 pnpm-workspace.yaml      # Configuración del Monorepo
├── 📜 package.json             # Scripts globales (pnpm run komanda)
└── 📜 README.md                # Presentación del proyecto
```

## Leyenda de Directorios Importantes

### 📂 Backend (Komanda-api)

Utilizamos un enfoque pragmático:

- **Node.js (Express)**: Gestiona el flujo principal, autenticación y tiempo real. Se sigue el patrón de nombres `*.controller.ts`, `*.service.ts` y `*.model.ts`.
- **PHP**: Se utiliza para tareas específicas, reportes complejos o lógica pesada de cálculo donde PHP destaca por su sencillez en el manejo de datos. Ubicado en `src/api/`.
- **Modules**: La lógica de negocio vive aquí, separada por dominios (Ventas, Inventario, Cocina).

### 📂 Frontend (Komanda-web)

Basado en **Vue 3 (Composition API)**:

- **Bootstrap 5**: Provee la base del diseño responsive y el sistema de grillas.
- **Custom CSS**: Ubicado en `style.css`, define nuestra identidad visual (**KOrange**).
- **Modules**: Es el espejo del backend en el frontend. Cada carpeta aquí contiene las interfaces de usuario (Vistas) y la lógica de estado correspondiente a un dominio específico. Esto facilita la navegación y el mantenimiento al agrupar todo lo relacionado con una funcionalidad.
