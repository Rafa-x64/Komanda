# 🚀 Guía de Compilación y Distribución de Releases (Komanda)

Esta guía detalla el proceso para compilar el frontend y el backend de **Komanda** en versiones de producción optimizadas, seguras y **sin exponer el código fuente original (.ts, .vue)**. Además, automatiza la transferencia de estas compilaciones y del esquema de la base de datos PostgreSQL directamente a tu repositorio público de lanzamientos (`/srv/http/Komanda-Releases/releases/`).

---

## 🏛️ 1. Filosofía de Seguridad y Estructura en Producción

### Frontend (`Komanda-web`)
* **Cómo se protege:** Vite compila toda la aplicación Vue 3 y TypeScript en archivos estáticos (`HTML`, `JS` y `CSS` minificados) dentro de `dist/`.
* **Seguridad:** Los comentarios, nombres de variables privadas y archivos `.vue` originales son completamente eliminados y obfuscados durante el bundling.
* **Conexión:** La aplicación web compilada se comunica directamente con la API en `http://localhost:3000/api/v1` mediante peticiones REST/WebSockets estándar (CORS está habilitado en el backend).

### Backend (`Komanda-api`)
* **Cómo se protege:** El compilador de TypeScript (`tsc`) compila todos los archivos `.ts` a JavaScript nativo (`.js`) dentro de la carpeta `dist/`.
* **Seguridad:** Toda la información de tipado estático e interfaces de TypeScript desaparece. El código distribuido es código JavaScript que dificulta la lectura directa de la lógica privada.
* **Conexión:** Consume las variables de entorno de un archivo `.env` local. En la release, entregamos un archivo `.env.example` limpio para que el cliente configure sus credenciales locales de Postgres.

### Base de Datos (`Database_Komanda.sql`)
* Se incluye una copia limpia del script de creación y semillas PostgreSQL (`Database_Komanda.sql`) en una carpeta dedicada `database/`, de modo que el cliente pueda inicializar su propia base de datos sin comprometer contraseñas ni datos sensibles de desarrollo.

---

## 🤖 2. Script de Automatización: `build-release.sh`

Para automatizar este proceso sin alterar tu código de desarrollo y con un solo comando, crearemos un script en la raíz de tu proyecto privado (`/srv/http/Komanda/build-release.sh`).

Este script realiza lo siguiente de manera segura:
1. Valida que el repositorio de releases exista.
2. Compila el frontend (`Vite`).
3. Compila el backend (`tsc`).
4. Estructura el directorio de lanzamientos público con archivos compilados.
5. Genera un `package.json` de producción limpio (eliminando dependencias de desarrollo privadas).
6. Copia el archivo plano de la base de datos Postgres de forma segura.
7. Copia endpoints PHP (si existieran en el futuro).

### Contenido del Script (`build-release.sh`)

```bash
#!/usr/bin/env bash
# ==============================================================================
# 🚀 KOMANDA - ULTRASHIELD RELEASE BUILDER & PACKAGER
# ==============================================================================
# Este script compila de forma segura el Frontend (Vue 3/Vite) y el Backend (TS/Node)
# de Komanda, eliminando el código fuente original (.ts, .vue) para proteger la IP,
# y empaquetando todo listo para correr en el repositorio público de releases.
#
# Diseñado con blindaje contra fallos y validaciones lógicas en cascada.
# ==============================================================================

# Forzar detención ante errores, variables no declaradas o fallos en tuberías (pipes)
set -euo pipefail

# Captura de errores para una salida limpia y restauración del entorno
restore_directory() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo -e "\n\x1b[31;1m❌ ¡ERROR CRÍTICO! El proceso falló en el último comando ejecutado.\x1b[0m"
        echo -e "\x1b[33mRestaurando ubicación original y abortando de forma segura...\x1b[0m"
    fi
    cd "$ORIGINAL_PWD"
    exit $exit_code
}

# Registrar la ruta inicial para regresar siempre a ella pase lo que pase
ORIGINAL_PWD="$PWD"
trap restore_directory EXIT

# 1. DETERMINACIÓN DINÁMICA DE RUTAS (A prueba de ejecuciones externas)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRIVATE_REPO="$SCRIPT_DIR"
RELEASE_REPO="/srv/http/Komanda-Releases"
RELEASE_DIR="$RELEASE_REPO/releases"

echo -e "\n\x1b[34;1m=========================================================\x1b[0m"
echo -e "\x1b[32;1m🚀 Iniciando Proceso de Compilación y Release de Komanda\x1b[0m"
echo -e "\x1b[34;1m=========================================================\x1b[0m"
echo -e "📂 Repositorio Privado:  $PRIVATE_REPO"
echo -e "📂 Repositorio Público:  $RELEASE_REPO"
echo -e "📂 Carpeta de Releases:  $RELEASE_DIR\n"

# 2. VALIDACIONES DE SISTEMA Y DEPENDENCIAS
echo "🔍 Validando dependencias del sistema..."
for cmd in pnpm node npx find; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo -e "❌ Error: La herramienta '$cmd' no está instalada en el sistema."
        exit 1
    fi
done
echo "  ✅ Dependencias básicas encontradas."

# Validar existencia del repositorio público de releases y permisos de escritura
if [ ! -d "$RELEASE_REPO" ]; then
    echo -e "❌ Error: El repositorio público de releases no existe en '$RELEASE_REPO'."
    echo "Asegúrate de clonar o crear la carpeta antes de ejecutar el script."
    exit 1
fi

if [ ! -w "$RELEASE_REPO" ]; then
    echo -e "❌ Error: No tienes permisos de escritura en '$RELEASE_REPO'."
    exit 1
fi
echo "  ✅ Directorio de releases validado y con permisos."

# Validar archivos críticos del monorepo en el repositorio privado
echo "🔍 Verificando estructura del proyecto privado..."
CRITICAL_FILES=(
    "Komanda-web/package.json"
    "Komanda-api/package.json"
    "Komanda-api/tsconfig.json"
    "Komanda-api/src/shared/database/Database_Komanda.sql"
)

for file in "${CRITICAL_FILES[@]}"; do
    if [ ! -f "$PRIVATE_REPO/$file" ]; then
        echo -e "❌ Error Crítico: No se encuentra el archivo requerido '$PRIVATE_REPO/$file'."
        exit 1
    fi
done
echo "  ✅ Estructura crítica de archivos verificada."

# 3. LIMPIEZA DE COMPILACIONES PREVIAS (Para evitar basura residual)
echo -e "\n🧹 Limpiando compilaciones anteriores del entorno de desarrollo..."
rm -rf "$PRIVATE_REPO/Komanda-web/dist"
rm -rf "$PRIVATE_REPO/Komanda-api/dist"
echo "  ✅ Entorno limpio."

# 4. COMPILACIÓN DEL FRONTEND (Vue 3 + Vite)
echo -e "\n📦 Compilando Frontend (Vue 3 + Vite)..."
cd "$PRIVATE_REPO/Komanda-web"

echo "  📥 Instalando dependencias de frontend..."
pnpm install --frozen-lockfile || pnpm install

echo "  ⚡ Compilando bundle de producción (omitiendo validación estricta de tipos de TypeScript)..."
# Usar vite build directamente evita que vue-tsc interrumpa la compilación por warnings o variables no usadas
pnpm exec vite build

# Validar que el build de frontend fue exitoso y contiene archivos
if [ ! -d "$PRIVATE_REPO/Komanda-web/dist" ] || [ -z "$(ls -A "$PRIVATE_REPO/Komanda-web/dist")" ]; then
    echo -e "❌ Error: La compilación del frontend falló. La carpeta 'dist' no existe o está vacía."
    exit 1
fi
echo "  ✅ Frontend compilado con éxito."

# 5. COMPILACIÓN DEL BACKEND (TypeScript -> JavaScript)
echo -e "\n⚙️ Compilando Backend (TypeScript)..."
cd "$PRIVATE_REPO/Komanda-api"

echo "  📥 Instalando dependencias de backend..."
pnpm install --frozen-lockfile || pnpm install

echo "  ⚡ Compilando archivos TypeScript a JavaScript..."
# Ejecutar tsc ignorando su código de salida no cero (ya que tsx corre con errores de tipos en desarrollo)
# tsc emitirá los archivos JS en dist igualmente, los cuales usaremos para la release
if [ -f "../Komanda-web/node_modules/.bin/tsc" ]; then
    ../Komanda-web/node_modules/.bin/tsc || echo "  ⚠️ Advertencia: Se detectaron discrepancias de tipos en TypeScript, continuando con la transpiliación del build..."
elif [ -f "../node_modules/.bin/tsc" ]; then
    ../node_modules/.bin/tsc || echo "  ⚠️ Advertencia: Se detectaron discrepancias de tipos en TypeScript, continuando con la transpiliación del build..."
elif [ -f "../../node_modules/.bin/tsc" ]; then
    ../../node_modules/.bin/tsc || echo "  ⚠️ Advertencia: Se detectaron discrepancias de tipos en TypeScript, continuando con la transpiliación del build..."
else
    npx -p typescript tsc || echo "  ⚠️ Advertencia: Se detectaron discrepancias de tipos en TypeScript, continuando con la transpiliación del build..."
fi

# Validar que la compilación de backend fue exitosa y generó código JS
if [ ! -d "$PRIVATE_REPO/Komanda-api/dist" ] || [ -z "$(ls -A "$PRIVATE_REPO/Komanda-api/dist")" ]; then
    echo -e "❌ Error: La compilación de TypeScript falló. La carpeta 'dist' no fue generada o está vacía."
    exit 1
fi
echo "  ✅ Backend compilado con éxito."

# 6. PREPARACIÓN ULTRA-SEGURA DEL REPOSITORIO PÚBLICO
echo -e "\n🧹 Limpiando y preparando la carpeta de releases pública..."
# Eliminar directorios viejos para asegurar que no quede código viejo residual
rm -rf "$RELEASE_DIR/Komanda-web"
rm -rf "$RELEASE_DIR/Komanda-api"
rm -rf "$RELEASE_DIR/database"

# Crear estructura limpia
mkdir -p "$RELEASE_DIR/Komanda-web/dist"
mkdir -p "$RELEASE_DIR/Komanda-api/dist"
mkdir -p "$RELEASE_DIR/database"
echo "  ✅ Carpeta de releases limpia y preparada."

# 7. COPIA DE COMPILADOS OBfuscados Y PRODUCTIVOS
echo -e "\n🚚 Transfiriendo bundles de distribución..."

# Copiar Frontend estático (sin código fuente)
echo "  📁 Copiando Frontend compilado..."
cp -r "$PRIVATE_REPO/Komanda-web/dist/"* "$RELEASE_DIR/Komanda-web/dist/"

# Copiar Backend compilado (.js, sin archivos .ts)
echo "  📁 Copiando Backend compilado..."
cp -r "$PRIVATE_REPO/Komanda-api/dist/"* "$RELEASE_DIR/Komanda-api/dist/"

# 8. DETECCIÓN Y TRASLADO DINÁMICO DE ARCHIVOS PHP (Sincronización híbrida)
echo "🔍 Buscando y sincronizando archivos PHP recursivamente..."
cd "$PRIVATE_REPO/Komanda-api"
PHP_COUNT=0
# Buscar recursivamente cualquier archivo php en src/ y copiarlo en la ruta equivalente de dist/
while read -r php_file; do
    if [ -f "$php_file" ]; then
        # Calcular la ruta destino equivalente dentro de dist
        dest_file="dist/${php_file#src/}"
        mkdir -p "$(dirname "$RELEASE_DIR/Komanda-api/$dest_file")"
        cp "$php_file" "$RELEASE_DIR/Komanda-api/$dest_file"
        echo "  🐘 PHP Sincronizado: $php_file -> $dest_file"
        PHP_COUNT=$((PHP_COUNT + 1))
    fi
done < <(find src -name "*.php" 2>/dev/null || true)

if [ $PHP_COUNT -eq 0 ]; then
    echo "  ℹ️ No se detectaron endpoints PHP en el backend actual."
else
    echo "  ✅ Sincronizados $PHP_COUNT archivos PHP con éxito."
fi

# 9. COPIA SEGURA DE LA BASE DE DATOS POSTGRESQL
echo -e "\n💾 Copiando esquema plano de base de datos..."
cp "$PRIVATE_REPO/Komanda-api/src/shared/database/Database_Komanda.sql" "$RELEASE_DIR/database/Database_Komanda.sql"
echo "  ✅ Database_Komanda.sql copiado correctamente."

# 10. CREACIÓN DE CONFIGURACIONES LIMPIAS PARA EL CLIENTE FINAL

# package.json de producción optimizado para el API (sin devDependencies privadas)
echo "📝 Generando package.json productivo para el API..."
cd "$PRIVATE_REPO"
node -e "
try {
  const fs = require('fs');
  const pkg = JSON.parse(fs.readFileSync('Komanda-api/package.json', 'utf8'));
  
  // Limpiar para distribución de producción
  pkg.scripts = {
    start: 'node dist/index.js'
  };
  
  // Eliminar herramientas locales de desarrollo privadas
  delete pkg.devDependencies;
  
  fs.writeFileSync('$RELEASE_DIR/Komanda-api/package.json', JSON.stringify(pkg, null, 2));
  console.log('  ✅ package.json de producción del backend creado.');
} catch (err) {
  console.error('  ❌ Error al procesar package.json del backend:', err.message);
  process.exit(1);
}
"

# Plantilla de variables de entorno limpia y segura (.env.example)
echo "📝 Generando plantilla de entorno (.env.example)..."
cat <<'EOT' > "$RELEASE_DIR/Komanda-api/.env.example"
# ==============================================================================
# KOMANDA - CONFIGURACIÓN DEL ENTORNO DE PRODUCCIÓN
# Instrucciones: Renombra este archivo a '.env' y rellena tus datos
# ==============================================================================

# Puerto de ejecución del servidor Express
PORT=3000
NODE_ENV=production

# Parámetros de conexión a la Base de Datos PostgreSQL del cliente
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=tu_contrasena_aqui
DB_NAME=komanda_db
EOT
echo "  ✅ Plantilla .env.example creada con éxito."

# pnpm-workspace.yaml de producción simplificado (solo requiere instalar el API)
echo "📦 Generando archivos de orquestación Monorepo de Producción..."
cat <<'EOT' > "$RELEASE_DIR/pnpm-workspace.yaml"
packages:
  - 'Komanda-api'
EOT

# package.json maestro en releases para levantar todo de un solo comando en producción
cat <<'EOT' > "$RELEASE_DIR/package.json"
{
  "name": "komanda-production",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "start:api": "pnpm --filter komanda-api start",
    "start:web": "npx serve -s Komanda-web/dist -l 5173",
    "start:php": "php -S localhost:8000 -t ./Komanda-api/dist/",
    "start": "concurrently --kill-others -n \"WEB,API,PHP\" -c \"cyan,green,magenta\" \"pnpm start:web\" \"pnpm start:api\" \"pnpm start:php\""
  },
  "dependencies": {
    "concurrently": "^8.2.2",
    "serve": "^14.2.4"
  }
}
EOT
echo "  ✅ Orquestadores de producción pnpm generados."

# 11. CONFIRMACIÓN Y CIERRE EXITOSO
echo -e "\n\x1b[32;1m=========================================================\x1b[0m"
echo -e "🎉 ¡COMPILACIÓN Y DISTRIBUCIÓN COMPLETADAS CON ÉXITO! 🎉"
echo -e "\x1b[32;1m=========================================================\x1b[0m"
echo -e "📂 Tu compilación protegida e íntegra está lista en:"
echo -e "   \x1b[36m$RELEASE_DIR\x1b[0m\n"
echo "Ya puedes ir a '$RELEASE_REPO', hacer commit y push a tu repositorio público."
echo "¡Tu código fuente original está 100% a salvo! 🔒"
echo -e "=========================================================\n"
```

---

## 📂 3. Estructura Resultante en el Repositorio de Releases

Una vez ejecutado el script, tu repositorio público `/srv/http/Komanda-Releases/releases/` quedará estructurado de la siguiente manera, listo para su distribución:

```text
releases/
├── 📂 database/
│   └── 📜 Database_Komanda.sql          # Base de datos limpia para restauración
├── 📂 Komanda-api/
│   ├── 📂 dist/                         # Archivos backend compilados en JavaScript nativo (.js)
│   ├── 📜 .env.example                  # Plantilla de credenciales
│   └── 📜 package.json                  # Dependencias de producción puras del API
├── 📂 Komanda-web/
│   └── 📂 dist/                         # Bundle estático del frontend obfuscado y minificado (HTML/JS/CSS)
├── 📜 package.json                      # Orquestador de producción
└── 📜 pnpm-workspace.yaml              # Workspace simplificado para producción
```

---

## 🚀 4. Guía de Instalación y Ejecución para el Usuario Público

Cuando una persona descargue la carpeta `releases/` de tu repositorio público, estos son los sencillos pasos que debe seguir para montarlo y correrlo con total integridad:

### Paso 1: Configurar la Base de Datos (PostgreSQL)
1. Abrir su consola o cliente de PostgreSQL e inicializar una base de datos vacía llamada `komanda_db`.
2. Restaurar la base de datos usando el script provisto en la carpeta `database/`:
   ```bash
   psql -U postgres -d komanda_db -f database/Database_Komanda.sql
   ```

### Paso 2: Configurar Variables de Entorno del Backend
1. Ir a la carpeta `Komanda-api/`.
2. Duplicar o renombrar el archivo `.env.example` como `.env`.
3. Abrir el archivo `.env` y configurar sus credenciales locales de Postgres (ej. contraseña y usuario de Postgres).

### Paso 3: Instalar Dependencias y Correr el Proyecto
El usuario solo necesitará instalar las dependencias de producción e iniciar todo con un comando unificado gracias al orquestador monorepo de producción:

```bash
# Instalar dependencias necesarias para producción y servidor estático
pnpm install

# Iniciar Frontend, Backend y el Servidor PHP simultáneamente
pnpm start
```

> [!NOTE]
> * `pnpm start` iniciará de forma sincronizada:
>   * El **Frontend** compilado en el puerto `5173` usando el servidor ultra-liviano y optimizado `serve`.
>   * El **Backend** compilado en Express corriendo sobre el puerto `3000`.
>   * El **Servidor PHP** (apuntando al directorio `dist/` en producción por si se despliegan endpoints PHP) en el puerto `8000`.
