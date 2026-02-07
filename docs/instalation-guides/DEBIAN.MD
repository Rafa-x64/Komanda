# Guía de Instalación: KOMANDA (Debian Stable/Testing)

Este manual técnico detalla el despliegue del ecosistema **KOMANDA** en entornos Debian. Al ser una distro enfocada en la estabilidad, seguiremos pasos precisos para obtener versiones modernas de **Node.js** y **PostgreSQL**, manteniendo la limpieza y modularidad de nuestro Monorepo.

---

### 📋 Tabla de Contenidos

| Paso | Sección | Descripción |
| :-- | :--- | :--- |
| 1️⃣ | [Preparación y DB](#1-preparación-del-sistema-y-base-de-datos) | Dependencias base y setup de PostgreSQL. |
| 2️⃣ | [Runtime Moderno](#2-entorno-de-ejecución-nodejs--pnpm) | Instalación de Node.js v20 y pnpm vía Repo Externo. |
| 3️⃣ | [Despliegue](#3-clonado-del-proyecto-y-estructura) | Clonado y jerarquía de directorios. |
| 4️⃣ | [Dependencias](#4-instalación-de-dependencias-y-orquestación) | Gestión modular vía pnpm workspaces. |
| 5️⃣ | [Orquestación](#5-configuración-de-scripts-en-la-raíz) | Configuración de scripts en el root. |
| 6️⃣ | [Validación](#6-verificación-de-los-motores) | Pruebas de conectividad y despliegue. |

---

### 1. Preparación del Sistema y Base de Datos

En Debian, primero nos aseguramos de tener `sudo` configurado o ejecutamos como root. Instalamos las herramientas de compilación y **PostgreSQL**.

```bash
# Actualizamos el sistema
sudo apt update && sudo apt upgrade -y

# Instalamos dependencias esenciales
sudo apt install -y curl git build-essential postgresql postgresql-contrib
```

#### Configurar la base de datos
Debian maneja a ```postgres``` de forma muy estricta. Creamos el entorno para **KOMANDA**:

```
Bash
sudo -u postgres psql -c "CREATE DATABASE komanda_db;"
sudo -u postgres psql -c "CREATE USER komanda_admin WITH PASSWORD 'tu_password_seguro';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE komanda_db TO komanda_admin;"
```

### 2. Entorno de Ejecución (Node.js & pnpm)
Los repositorios oficiales de Debian suelen tener versiones antiguas. Usaremos **Nodesource** para obtener la v20 (LTS) y luego **pnpm** para gestionar el monorepo sin quemar el almacenamiento.

```Bash
# Importamos el repositorio de Node.js v20
curl -fsSL [https://deb.nodesource.com/setup_20.x](https://deb.nodesource.com/setup_20.x) | sudo -E bash -
sudo apt install -y nodejs

# Instalamos pnpm de forma global
sudo npm install -g pnpm
```

### 3. Clonado del Proyecto y Estructura
Traemos el código al directorio de trabajo. Mantener el nombre **KOMANDA** ayuda a identificar el proyecto rápidamente en ```/home``` o ```/var/www```.

```Bash
# Clonamos el repo
git clone [https://github.com/Rafa-x64/Komanda.git](https://github.com/Rafa-x64/Komanda.git) KOMANDA
cd KOMANDA
```
### 4. Instalación de Dependencias y Orquestación
Debian brilla con la eficiencia de ```pnpm```. Instalamos todo el árbol de dependencias definido en los workspaces.

```Bash
# Instalamos las dependencias de todo el monorepo (api y web)
pnpm install

# Instalamos 'concurrently' para no morir abriendo terminales
pnpm add -D concurrently -w
```
### 5. Configuración de Scripts en la Raíz
Modifica el ```package.json``` raíz para orquestar los motores de **KOMANDA**. Esto garantiza que cualquier desarrollador (o tú mismo en el futuro) use el mismo estándar.

```JSON
{
  "scripts": {
    "dev:api": "pnpm --filter komanda-api dev",
    "dev:web": "pnpm --filter komanda-web dev",
    "dev": "concurrently \"pnpm dev:api\" \"pnpm dev:web\""
  }
}
```
>⚡ Nota: El uso de ```--filter``` con pnpm es lo que hace que nuestro monorepo sea escalable. Si mañana añades un módulo ```komanda-mobile```, solo agregas un script nuevo aquí.

### 6. Verificación de los "Motores"

Es hora de levantar el sistema y verificar que todo el stack (Vue 3, Node/PHP, Postgres) hable el mismo idioma.

```Bash
pnpm dev
```

##### Check-list de éxito:

- Frontend: ```http://localhost:5173``` activo y renderizando.

- API: Logs limpios sin errores de conexión a la DB.

- Permisos: En Debian, si tienes problemas de escritura, recuerda: ```sudo chown -R $USER:$USER``` .

##### Notas de desarrollador a desarrollador

>- **Filosofía:** Debian es estabilidad. Si algo falla, suele ser un tema de permisos o de versiones de Node. No "inventes" instalando paquetes desde los repos oficiales si necesitas versiones modernas.

>- **Escalabilidad:** Al planear el monorepo así, si decides mover la API a un servidor independiente y dejar el Web en un CDN, ya tienes la lógica separada. No hay "espagueti" aquí.

>- **Tip Pro:** En Debian, asegúrate de que tu usuario esté en el grupo sudo. Si no, usa su -c "comando" para las instalaciones iniciales.

>**Chiste malo de IA:** ¿Qué le dice un contenedor de Docker a un servidor Debian? "Oye, relájate un poco, que siempre estás muy stable".
---
*Documentación optimizada para KOMANDA - Ecosistema Debian 2026*