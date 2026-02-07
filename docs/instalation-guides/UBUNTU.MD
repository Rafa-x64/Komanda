# Guía de Instalación: KOMANDA (Ubuntu Server)

Este manual técnico detalla el despliegue del ecosistema **KOMANDA** en entornos Ubuntu. La arquitectura se basa en un **Monorepo** gestionado por **pnpm**, utilizando **concurrently** para la orquestación de procesos y **PostgreSQL** como motor de persistencia para nuestro SaaS de restaurantes.

---

### Tabla de Contenidos

| Paso | Sección                                                        | Descripción                              |
| :--- | :------------------------------------------------------------- | :--------------------------------------- |
| 1️⃣   | [Preparación y DB](#1-preparación-del-sistema-y-base-de-datos) | Dependencias base y setup de PostgreSQL. |
| 2️⃣   | [Runtime](#2-entorno-de-ejecución-nodejs--pnpm)                | Instalación de Node.js v20 y pnpm.       |
| 3️⃣   | [Despliegue](#3-clonado-del-proyecto-y-estructura)             | Clonado y jerarquía de directorios.      |
| 4️⃣   | [Dependencias](#4-instalación-de-dependencias-y-orquestación)  | Gestión modular vía workspaces.          |
| 5️⃣   | [Orquestación](#5-configuración-de-scripts-en-la-raíz)         | Configuración de scripts en el root.     |
| 6️⃣   | [Validación](#6-verificación-de-los-motores)                   | Pruebas de conectividad y despliegue.    |

---

### 1. Preparación del Sistema y Base de Datos

Actualizamos los repositorios e instalamos las herramientas esenciales y el motor de base de datos. Nada de interfaces, _pure terminal vibes_.

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git build-essential postgresql postgresql-contrib
```

#### Configurar la base de datos

Ejecuta los siguientes comandos para preparar el entorno de datos:

```Bash
sudo -u postgres psql -c "CREATE DATABASE komanda_db;"
sudo -u postgres psql -c "CREATE USER komanda_admin WITH PASSWORD 'tu_password_seguro';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE komanda_db TO komanda_admin;"
```

### 2. Entorno de Ejecución (Node.js & pnpm)

Instalamos **Node.js** (LTS) y **pnpm**. Elegimos pnpm por su gestión eficiente de paquetes, lo que optimiza drásticamente el uso de disco en el monorepo y evita los `node_modules` gigantescos.

```Bash
# Node.js v20 (LTS)
curl -fsSL [https://deb.nodesource.com/setup_20.x](https://deb.nodesource.com/setup_20.x) | sudo -E bash -
sudo apt install -y nodejs

#Instalamos pnpm de forma global
sudo npm install -g pnpm
```

### 3. Clonado del Proyecto y Estructura

Clonamos el repositorio respetando la estructura de carpetas definida para el proyecto **KOMANDA**.

```Bash
# Clonamos el repo en el directorio KOMANDA
git clone [https://github.com/Rafa-x64/Komanda.git](https://github.com/Rafa-x64/Komanda.git) KOMANDA
cd KOMANDA
```

### 4. Instalación de Dependencias y Orquestación

Hacemos uso de `pnpm-workspace.yaml` para instalar todas las dependencias de los módulos `api` y `web` de forma centralizada y rápida.

```Bash
# Instalamos las dependencias de todo el monorepo
pnpm install

# Instalamos 'concurrently' en la raíz para manejar procesos paralelos
pnpm add -D concurrently -w
```

### 5. Configuración de Scripts en la Raíz

Para que todo el equipo trabaje bajo el mismo flujo, el `package.json` en la raíz debe tener estos scripts. Esto permite levantar el **Frontend (Vue 3)** y el **Backend (API)** en simultáneo.

Edita tu `package.json` raíz:

```JSON
{
  "scripts": {
    "dev:api": "pnpm --filter komanda-api dev",
    "dev:web": "pnpm --filter komanda-web dev",
    "dev": "concurrently \"pnpm dev:api\" \"pnpm dev:web\""
  }
}
```

> ⚠️ Nota: Asegúrate de que los nombres tras el flag `--filter` coincidan exactamente con el campo `"name"` dentro de los `package.json` de cada subcarpeta (`api` y `web`).

### 6. Verificación de los "Motores"

Es momento de comprobar que el servidor, el cliente y la base de datos están sincronizados.

```Bash
pnpm dev
```

#### Prueba de fuego:

**Frontend:** Abre http://localhost:5173 (Vite) para ver la interfaz.

**API:** Revisa la consola para confirmar que el API conectó con PostgreSQL.

**PHP:** Si usas PHP para lógica específica, asegúrate de que el servicio php-fpm esté corriendo.

---

##### Notas de desarrollador a desarrollador

> - **Sobre la estructura:** Respeta el esquema de komanda-api y komanda-web. Es una arquitectura modular limpia; no la rompas moviendo archivos a mano fuera de su dominio.

> - **Observación:** Instalar concurrently en la raíz con el flag -w (workspace) es la diferencia entre ser un desarrollador organizado y uno que tiene 5 pestañas de terminal abiertas intentando recordar dónde dejó el backend.

> - **Consejito:** Si al clonar los permisos te dan guerra en Ubuntu, usa sudo chown -R $USER:$USER . en la carpeta del proyecto. A veces Ubuntu se pone más protector que firewall de banco.

> **Chiste malo de IA**: ¿Sabes por qué los programadores odian la naturaleza? Porque tiene demasiados bugs y no hay un botón de "Inspeccionar" para arreglar el clima.

---

> _Documentación generada para el ecosistema KOMANDA - 2026_
