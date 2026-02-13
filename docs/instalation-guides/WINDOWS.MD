# Guía de Instalación: KOMANDA (Windows + PowerShell)

Este manual técnico explica cómo poner en marcha el ecosistema **KOMANDA** en Windows utilizando **PowerShell**. Mantendremos la eficiencia del monorepo con **pnpm** y la orquestación con **concurrently**, asegurando que el "Real Time" de la cocina vuele.

---

### 📋 Tabla de Contenidos

| Paso | Sección                                                       | Descripción                           |
| :--- | :------------------------------------------------------------ | :------------------------------------ |
| 1️⃣   | [Entorno y DB](#1-preparación-del-sistema-y-base-de-datos)    | Instalación de PostgreSQL, Git y PHP. |
| 2️⃣   | [Runtime Node & pnpm](#2-entorno-de-ejecución-nodejs--pnpm)   | Configuración de Node.js y pnpm.      |
| 3️⃣   | [Clonado](#3-clonado-del-proyecto-y-estructura)               | Descarga del código en Windows.       |
| 4️⃣   | [Dependencias](#4-instalación-de-dependencias-y-orquestación) | Instalación vía pnpm workspaces.      |
| 5️⃣   | [Validación](#5-verificación-de-los-motores)                  | Lanzamiento y pruebas de fuego.       |

---

### 1. Preparación del Sistema y Base de Datos

En Windows, lo más eficiente es usar un gestor de paquetes como **Winget** (que ya viene incluido en Windows 10/11).

```powershell
# Instalamos Git y PostgreSQL (Ejecutar como Administrador)
winget install -e --id Git.Git
winget install -e --id PostgreSQL.PostgreSQL.16
```

#### Configurar la base de datos

Después de instalar PostgreSQL, necesitas configurar la base de datos. Hay dos formas:

**Opción 1: Usando SQL Shell (psql)**

Busca "SQL Shell (psql)" en el menú de inicio de Windows y ábrelo. Te pedirá:

- Server [localhost]: _presiona Enter_
- Database [postgres]: _presiona Enter_
- Port [5432]: _presiona Enter_
- Username [postgres]: _presiona Enter_
- Password: _ingresa la contraseña que configuraste durante la instalación_

**Opción 2: Desde PowerShell** (requiere que PostgreSQL esté en el PATH)

```powershell
# Si psql no funciona, primero añade PostgreSQL al PATH de esta sesión:
$env:Path += ";C:\Program Files\PostgreSQL\16\bin"

# Luego conéctate:
psql -U postgres
```

Una vez dentro de psql, ejecuta:

```SQL
CREATE DATABASE komanda_db;
CREATE USER komanda_admin WITH PASSWORD 'tu_password_seguro';
GRANT ALL PRIVILEGES ON DATABASE komanda_db TO komanda_admin;
\q
```

> **Nota:** Reemplaza `'tu_password_seguro'` con una contraseña real. Guárdala, la necesitarás más adelante si conectas la app a la DB.

### 2. Entorno de Ejecución (Node.js & pnpm)

Instalamos la versión LTS de Node.js y nuestro gestor de paquetes favorito, **pnpm**, para mantener los `node_modules` bajo control.

```PowerShell
# Instalamos Node.js v20 y PHP 8.3
winget install -e --id OpenJS.NodeJS.LTS
winget install -e --id PHP.PHP.8.3

# Instalamos pnpm globalmente
npm install -g pnpm
```

### 3. Clonado del Proyecto y Estructura

Clonamos el repositorio. Recuerda que en Windows la ruta de la carpeta no debe ser demasiado larga para evitar problemas de sistema de archivos.

```PowerShell
# Clonamos el repo
git clone https://github.com/Rafa-x64/Komanda.git KOMANDA
cd KOMANDA
```

### 4. Instalación de Dependencias y Orquestación

Gracias a la magia del monorepo, instalamos todo desde la raíz con un solo comando.

```PowerShell
# Instalamos las dependencias de todo el proyecto
pnpm install
```

> **Nota:** `concurrently` ya está incluido en las dependencias del proyecto, por lo que `pnpm install` lo instalará automáticamente.

Para que el flujo sea igual que en Linux, el `package.json` de la raíz ya tiene configurado el script `komanda`. **PowerShell** lo ejecutará sin problemas.

```JSON
{
  "scripts": {
    "dev:web": "pnpm --filter komanda-web dev",
    "dev:api": "pnpm --filter komanda-api dev",
    "dev:php": "php -S localhost:8000 -t ./Komanda-api/src/",
    "komanda": "concurrently -n \"WEB,API,PHP\" -c \"cyan,green,magenta\" \"pnpm dev:web\" \"pnpm dev:api\" \"pnpm dev:php\""
  }
}
```

> **Nota:** No necesitas modificar este archivo, ya está configurado. Solo verifica que exista.

### 5. Verificación de los "Motores"

Es hora de arrancar la maquinaria de **KOMANDA**:

```PowerShell
pnpm komanda
```

#### Prueba de fuego:

- Frontend: Abre `http://localhost:5173` en tu navegador.

- Backend: Revisa que la terminal no escupa errores de conexión con Postgres.

- Políticas de Ejecución: Si PowerShell te bloquea los scripts, ejecuta: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`.

- PHP Server: Verifica que `http://localhost:8000` responda (aunque sea un 404 o la estructura de carpetas si no hay index) para asegurar que el servidor de PHP levantó.

---

### 🔧 Solución de Problemas Comunes

#### ❌ Error: "pnpm: no se reconoce como comando"

**Causa:** El PATH de Windows no incluye la ruta de pnpm.

**Solución:**

```powershell
# Cierra y vuelve a abrir PowerShell después de instalar pnpm
# Si persiste, verifica manualmente:
npm config get prefix
# Añade esa ruta + \node_modules\.bin al PATH de Windows
```

#### ❌ Error: "php: no se reconoce como comando"

**Causa:** PHP no está en el PATH del sistema.

**Solución:**

```powershell
# Encuentra la instalación de PHP
where.exe php

# Si no aparece, añade manualmente al PATH:
# 1. Busca la carpeta de instalación (usualmente C:\Program Files\PHP\v8.x)
# 2. Panel de Control > Sistema > Variables de entorno
# 3. Edita "Path" y añade la ruta de PHP
# 4. Reinicia PowerShell
```

#### ❌ Error: "psql: no se reconoce como comando"

**Causa:** PostgreSQL no está en el PATH.

**Solución:**

```powershell
# Añade al PATH: C:\Program Files\PostgreSQL\16\bin
# Reinicia PowerShell y prueba:
psql --version
```

#### ❌ Error: "Puerto 3000/5173/8000 ya en uso"

**Causa:** Otro proceso está usando el puerto.

**Solución:**

```powershell
# Encuentra qué proceso usa el puerto (ejemplo: 3000)
netstat -ano | findstr :3000

# Mata el proceso (reemplaza PID con el número que aparece)
taskkill /PID <PID> /F
```

#### ❌ Error: "ECONNREFUSED" al conectar a PostgreSQL

**Causa:** El servicio de PostgreSQL no está corriendo.

**Solución:**

```powershell
# Verifica el estado del servicio
Get-Service -Name postgresql*

# Si está detenido, inícialo:
Start-Service -Name postgresql-x64-16
```

#### ❌ Error: "concurrently not found"

**Causa:** Las dependencias no se instalaron correctamente.

**Solución:**

```powershell
# Desde la raíz del proyecto:
pnpm install --force

# Verifica que node_modules/concurrently exista
```

#### ❌ Error: Scripts bloqueados por PowerShell

**Causa:** Política de ejecución restrictiva.

**Solución:**

```powershell
# Ejecuta como Administrador:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Verifica:
Get-ExecutionPolicy
```

#### ❌ Error: "Cannot find module 'tsx'"

**Causa:** Las dependencias de `Komanda-api` no se instalaron.

**Solución:**

```powershell
# Instala dependencias específicas del workspace:
cd Komanda-api
pnpm install
cd ..
```

---

##### Notas de desarrollador a desarrollador

> - **Scripts en Windows:** A diferencia de Linux, a veces PowerShell se pone "especial" con los permisos de scripts. El comando RemoteSigned de arriba es tu mejor amigo.

> - **Rendimiento:** Aunque Windows no es EndeavourOS, con pnpm y Vite la experiencia de desarrollo seguirá siendo súper fluida.

> - **Modularidad:** No toques las carpetas internas a mano; deja que el monorepo gestione los enlaces simbólicos. Si lo haces bien, esto escalará hasta el infinito.

> **Chiste malo de IA:** ¿Por qué el programador de Windows se cayó de la cama? Porque no tenía instalado el controlador de "dormir.sys".

---

_Manual de KOMANDA para Windows - Edición 2026_
