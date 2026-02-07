# Guía de Instalación: KOMANDA (Windows + PowerShell)

Este manual técnico explica cómo poner en marcha el ecosistema **KOMANDA** en Windows utilizando **PowerShell**. Mantendremos la eficiencia del monorepo con **pnpm** y la orquestación con **concurrently**, asegurando que el "Real Time" de la cocina vuele.

---

### 📋 Tabla de Contenidos

| Paso | Sección | Descripción |
| :-- | :--- | :--- |
| 1️⃣ | [Entorno y DB](#1-preparación-del-sistema-y-base-de-datos) | Instalación de PostgreSQL y herramientas. |
| 2️⃣ | [Runtime Node & pnpm](#2-entorno-de-ejecución-nodejs--pnpm) | Configuración de Node.js y pnpm. |
| 3️⃣ | [Clonado](#3-clonado-del-proyecto-y-estructura) | Descarga del código en Windows. |
| 4️⃣ | [Dependencias](#4-instalación-de-dependencias-y-orquestación) | Instalación vía pnpm workspaces. |
| 5️⃣ | [Orquestación](#5-configuración-de-scripts-en-la-raíz) | Configuración de scripts en el root. |
| 6️⃣ | [Validación](#6-verificación-de-los-motores) | Lanzamiento y pruebas de fuego. |

---

### 1. Preparación del Sistema y Base de Datos

En Windows, lo más eficiente es usar un gestor de paquetes como **Winget** (que ya viene incluido en Windows 10/11).

```powershell
# Instalamos Git y PostgreSQL (Ejecutar como Administrador)
winget install -e --id Git.Git
winget install -e --id PostgreSQL.PostgreSQL.16
```

#### Configurar la base de datos
Abre el **SQL Shell (psql)** que se instaló con Postgres o usa este comando en PowerShell (asegúrate de que bin de `Postgres` esté en tu PATH):

```SQL
-- Ejecuta esto dentro de psql
CREATE DATABASE komanda_db;
CREATE USER komanda_admin WITH PASSWORD 'tu_password_seguro';
GRANT ALL PRIVILEGES ON DATABASE komanda_db TO komanda_admin;
```

### 2. Entorno de Ejecución (Node.js & pnpm)
Instalamos la versión LTS de Node.js y nuestro gestor de paquetes favorito, **pnpm**, para mantener los `node_modules` bajo control.

```PowerShell
# Instalamos Node.js v20
winget install -e --id OpenJS.NodeJS.LTS

# Instalamos pnpm globalmente
npm install -g pnpm
```

### 3. Clonado del Proyecto y Estructura
Clonamos el repositorio. Recuerda que en Windows la ruta de la carpeta no debe ser demasiado larga para evitar problemas de sistema de archivos.

```PowerShell
# Clonamos el repo
git clone [https://github.com/Rafa-x64/Komanda.git](https://github.com/Rafa-x64/Komanda.git) KOMANDA
cd KOMANDA
```

### 4. Instalación de Dependencias y Orquestación
Gracias a la magia del monorepo, instalamos todo desde la raíz con un solo comando.

```PowerShell
# Instalamos las dependencias de todo el proyecto
pnpm install

# Instalamos 'concurrently' en la raíz
pnpm add -D concurrently -w
```

### 5. Configuración de Scripts en la Raíz
Para que el flujo sea igual que en Linux, asegúrate de que el `package.json` de la raíz tenga estos scripts. **PowerShell** los ejecutará sin problemas.

```JSON
{
  "scripts": {
    "dev:api": "pnpm --filter komanda-api dev",
    "dev:web": "pnpm --filter komanda-web dev",
    "dev": "concurrently \"pnpm dev:api\" \"pnpm dev:web\""
  }
}
```

### 6. Verificación de los "Motores"
Es hora de arrancar la maquinaria de **KOMANDA**:

```PowerShell
pnpm dev
```

#### Prueba de fuego:

- Frontend: Abre `http://localhost:5173` en tu navegador.

- Backend: Revisa que la terminal no escupa errores de conexión con Postgres.

- Políticas de Ejecución: Si PowerShell te bloquea los scripts, ejecuta: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`.

##### Notas de desarrollador a desarrollador

> - **Scripts en Windows:** A diferencia de Linux, a veces PowerShell se pone "especial" con los permisos de scripts. El comando RemoteSigned de arriba es tu mejor amigo.

> - **Rendimiento:** Aunque Windows no es EndeavourOS, con pnpm y Vite la experiencia de desarrollo seguirá siendo súper fluida.

> - **Modularidad:** No toques las carpetas internas a mano; deja que el monorepo gestione los enlaces simbólicos. Si lo haces bien, esto escalará hasta el infinito.

> **Chiste malo de IA:** ¿Por qué el programador de Windows se cayó de la cama? Porque no tenía instalado el controlador de "dormir.sys".
---
*Manual de KOMANDA para Windows - Edición 2026*