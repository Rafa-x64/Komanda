# 🛠️ Manual de Backend (API)

> "Aquí forjamos la lógica que mueve los engranajes. Si el backend falla, el restaurante cierra."

Este manual describe cómo trabajar en el **Núcleo Híbrido** de KOMANDA: una fusión de **Node.js (TypeScript)** para velocidad y **PHP** para reportes/legacy.

---

## 📌 Tabla de Contenidos

1.  [Arquitectura Híbrida (Hybrid Core)](#1-arquitectura-híbrida-hybrid-core)
2.  [Estructura de Carpetas](#2-estructura-de-carpetas)
3.  [Endpoint Tipo A: Node.js (Real-Time/Logic)](#3-endpoint-tipo-a-nodejs-real-timelogic)
4.  [Endpoint Tipo B: PHP (Reports/Calculations)](#4-endpoint-tipo-b-php-reportscalculations)
5.  [Base de Datos & Migraciones](#5-base-de-datos--migraciones)

---

## 1. Arquitectura Híbrida (Hybrid Core)

KOMANDA corre dos servidores en paralelo dentro del mismo contenedor/máquina:

- **Node.js (Puerto 3000):** Maneja WebSockets, la lógica del POS, Kitchen Display System y todo lo que requiere alta concurrencia.
- **PHP (Puerto 8000):** Se usa como un "Script Runner" para generar PDFs, Excel, reportes contables complejos o lógica que es más fácil de mantener en PHP.

### ⚠️ Regla de Oro: CORS

Para que el Frontend (Puerto 5173) pueda hablar con ambos backends, SIEMPRE debes configurar los headers de CORS correctamente.

---

## 2. Estructura de Carpetas

```bash
/src
├── index.ts                # Entry Point de Node (Express)
├── api/                    # 📂 Scripts de PHP (Endpoints sueltos)
│   └── stats.php           # Ejemplo: http://localhost:8000/api/stats.php
│
└── modules/                # 📂 Módulos de Node (Estructura DDD)
    └── kitchen/
        ├── kitchen.controller.ts
        ├── kitchen.service.ts
        └── kitchen.routes.ts
```

---

## 3. Endpoint Tipo A: Node.js (Real-Time/Logic)

Usa esto para el día a día: Crear comandas, actualizar estados, login, etc.

### Paso 1: Crea el Controlador

Archivo: `src/modules/kitchen/kitchen.controller.ts`

```typescript
import { Request, Response } from "express";

export const getKitchenStatus = (req: Request, res: Response) => {
  // Lógica de negocio aquí (o llamar a un Service)
  res.status(200).json({
    status: "success",
    data: {
      is_open: true,
      pending_orders: 5,
    },
  });
};
```

### Paso 2: Registra la Ruta

Archivo: `src/index.ts`

```typescript
import { getKitchenStatus } from "./modules/kitchen/kitchen.controller";

// ... configuración de express ...

// Rutas versionadas
app.get("/api/v1/kitchen/status", getKitchenStatus);
```

---

## 4. Endpoint Tipo B: PHP (Reports/Calculations)

Usa esto para "Dirty Jobs": Scripts rápidos, cálculos matemáticos pesados, generación de archivos.

### Paso 1: Crea el Script

Archivo: `src/api/reporte_diario.php`

```php
<?php
// 1. Headers OBLIGATORIOS (CORS + JSON)
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// 2. Tu Lógica (Conexión a BD, Cálculos, etc)
$data = [
    "date" => date("Y-m-d"),
    "total_sales" => 1500.50,
    "generated_by" => "PHP Core"
];

// 3. Respuesta JSend
echo json_encode([
    "status" => "success",
    "data" => $data
]);
```

### Paso 2: Pruébalo

No necesitas registrar rutas. PHP sirve el archivo tal cual.
URL: `http://localhost:8000/api/reporte_diario.php`

---

## 5. Base de Datos & Migraciones

Aunque uses PHP para leer, **Node.js (TypeORM/Prisma)** es el dueño del esquema de la base de datos.

```bash
# Crear migración (Desde Node)
pnpm typeorm migration:create -n AddSalesTable

# Correr migraciones
pnpm typeorm migration:run
```

> **Nota:** PHP debe conectarse a la misma DB (Postgres) usando `PDO` o `pg_connect` con las credenciales del `.env`.
