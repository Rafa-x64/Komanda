# Komanda API — Documentacion Completa

> Guia de referencia para desarrolladores que integren, consuman o extiendan la API REST de Komanda — el sistema de gestion integral para restaurantes.

**Version:** 1.0  
**Base URL:** `http://localhost:3000/api/v1`  
**Protocolo:** HTTP/1.1 + WebSocket  
**Content-Type:** `application/json`  
**Autenticacion:** JWT (Bearer Token)

---

## Indice de Modulos

Cada modulo tiene su propia documentacion detallada con endpoints, request/response bodies, validaciones y ejemplos con `curl`.

| # | Modulo | Archivo | Endpoints | Descripcion |
|---|--------|---------|-----------|-------------|
| 1 | Auth (Signup + Signin) | [auth.md](./auth.md) | 2 | Registro de restaurante e inicio de sesion |
| 2 | POS (Punto de Venta) | [pos.md](./pos.md) | 7 | Catalogos, registro de ventas, cierre de caja |
| 3 | Menu | [menu.md](./menu.md) | 6 | CRUD de recetas y categorias del menu |
| 4 | Inventory | [inventory.md](./inventory.md) | 2 | Stock de insumos y registro de compras |
| 5 | Kitchen (KDS) | [kitchen.md](./kitchen.md) | 2 + WS | Pantalla de cocina y notificaciones en tiempo real |
| 6 | Employees | [employees.md](./employees.md) | 6 | Gestion de personal, roles y permisos |
| 7 | Dashboard | [dashboard.md](./dashboard.md) | 4 | KPIs, gráficas y resúmenes de operaciones |
| 8 | Reports | [reports.md](./reports.md) | 2 | Reportes contables, ventas y predicciones |

---

## Quickstart — Tu primera peticion en 3 pasos

### Paso 1: Registrar un restaurante

```bash
curl -X POST http://localhost:3000/api/v1/signup/register \
  -H "Content-Type: application/json" \
  -d '{
    "restaurant": {
      "name": "Mi Restaurante",
      "phone": "+58 424 0000000",
      "address": "Calle Principal 123",
      "email": "info@mirestaurant.com",
      "currency": "USD",
      "zone": "America/Caracas",
      "tax": "16",
      "tip": "10"
    },
    "admin": {
      "name": "Juan Perez",
      "userName": "juanp",
      "email": "juan@mirestaurant.com",
      "password": "secret123",
      "confirmPassword": "secret123"
    }
  }'
```

**Respuesta esperada (201):**
```json
{
  "status": "success",
  "data": {
    "restaurantId": 1,
    "restaurantName": "Mi Restaurante",
    "adminId": 1,
    "adminEmail": "juan@mirestaurant.com",
    "role": "admin"
  }
}
```

### Paso 2: Iniciar sesion (obtener token JWT)

```bash
curl -X POST http://localhost:3000/api/v1/signin/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "juanp",
    "password": "secret123",
    "restaurantName": "Mi Restaurante"
  }'
```

**Respuesta esperada (200):**
```json
{
  "status": "success",
  "message": "Inicio de sesion exitoso",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIs...",
    "user": { "id": 1, "nombre": "Juan Perez", "username": "juanp", "role": "admin" },
    "restaurant": { "id": 1, "nombre": "Mi Restaurante" }
  }
}
```

> IMPORTANTE: Guarda el token — lo necesitaras en todas las siguientes peticiones.

### Paso 3: Hacer una peticion autenticada

```bash
curl http://localhost:3000/api/v1/pos/categories \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..."
```

Listo! Ya estas consumiendo la API.

---

## Autenticacion y Autorizacion

### Token JWT (JSON Web Token)

Todas las rutas protegidas exigen el header:

```http
Authorization: Bearer <JWT_TOKEN>
```

El token se obtiene en `POST /api/v1/signin/login` y **expira en 8 horas** (un turno de trabajo). Al expirar, el usuario debe volver a iniciar sesion.

### Payload del token

| Campo | Tipo | Descripcion |
|-------|------|-------------|
| `userId` | `number` | ID del usuario autenticado |
| `restaurantId` | `number` | ID del restaurante al que pertenece |
| `role` | `string` | Rol asignado al usuario |

El backend **extrae automaticamente** el `restaurantId` del token, filtrando toda la data por restaurante. No necesitas enviar `restaurantId` en el body de ninguna peticion.

### Roles y permisos

| Rol | Permisos |
|-----|----------|
| `admin` | Acceso total: CRUD empleados, menu, inventario, POS, cocina, reportes |
| `cajero` | POS: ventas, catalogos, cierre de caja |
| `mesero` | POS: ventas, catalogos, lectura de menu |
| `cocina` | KDS: ver pedidos activos, cambiar estado de preparacion |

### Respuestas de error de autenticacion

| HTTP | message | Causa |
|------|---------|-------|
| `401` | `Token no proporcionado` | No se envio el header Authorization o no inicia con Bearer |
| `401` | `Token invalido o expirado` | El JWT esta corrupto, fue manipulado, o ya pasaron las 8 horas |
| `403` | `No tienes permisos para esta accion` | El rol del token no tiene acceso al endpoint solicitado |

---

## Formato de Respuestas (JSend)

Todas las respuestas de la API siguen el estandar JSend, lo que facilita el manejo uniforme en el frontend.

### Exito (200 o 201)

```json
{
  "status": "success",
  "data": { ... },
  "message": "Descripcion opcional de la operacion"
}
```

- `data` contiene el objeto o array resultado de la operacion.
- `message` es opcional (presente en login, registros, etc.).

### Error de validacion (400)

```json
{
  "status": "error",
  "message": "Datos invalidos",
  "errors": [
    "Nombre muy corto",
    "Correo no valido"
  ]
}
```

- `errors` es un array con los mensajes de cada campo que fallo la validacion (Zod).

### Error de validacion (variante fail)

Algunos endpoints usan la variante fail con detalles completos de Zod:

```json
{
  "status": "fail",
  "message": "Error de validacion",
  "details": [
    { "code": "too_small", "minimum": 1, "message": "Nombre muy corto", "path": ["nombre"] }
  ]
}
```

### Error de negocio (400)

```json
{
  "status": "error",
  "message": "Stock insuficiente para el ingrediente: Harina"
}
```

### Error de servidor (500)

```json
{
  "status": "error",
  "message": "Error interno del servidor"
}
```

---

## Codigos de Respuesta HTTP

| Codigo | Estado | Cuando se usa |
|--------|--------|---------------|
| `200` | OK | Lectura exitosa (GET) o actualizacion exitosa (PUT) |
| `201` | Created | Recurso creado exitosamente (POST de creacion) |
| `400` | Bad Request | La validacion Zod fallo o una regla de negocio fue violada |
| `401` | Unauthorized | Token JWT ausente, malformado o expirado |
| `403` | Forbidden | El rol del usuario no tiene permisos para ese endpoint |
| `404` | Not Found | El recurso solicitado no existe en la base de datos |
| `500` | Internal Server | Error inesperado del servidor (bug, BD caida, etc.) |

---

## Health Check

```http
GET /
```

**Auth:** No requerida  
**Uso:** Verificar que el servidor esta online antes de hacer cualquier otra peticion.

```bash
curl http://localhost:3000/
```

**Respuesta 200:**

```json
{
  "message": "API de KOMANDA funcionando",
  "system": "EndeavourOS",
  "status": "cooking"
}
```

---

## Base de Datos (PostgreSQL)

La base de datos utiliza schemas de PostgreSQL para separar contextos de dominio. Todas las tablas incluyen la columna `restaurante_id` para aislamiento multi-tenant.

| Schema | Tablas principales | Proposito |
|--------|-------------------|-----------|
| `core` | `usuarios`, `roles`, `restaurante`, `metodos_pago` | Identidad, autenticacion y configuracion |
| `operaciones` | `pedidos`, `pedido_detalle`, `mesas`, `transacciones_pago` | Operaciones transaccionales del POS |
| `menu` | `recetas`, `categorias`, `receta_ingredientes` | Carta del restaurante y composicion |
| `inventario` | `ingredientes` | Stock de materias primas |
| `contabilidad` | `libro_diario` | Asientos contables automaticos |
| `finanzas` | `caja` | Apertura y cierre de caja |

> **Multi-tenant:** Toda la data esta aislada por `restaurante_id`. Un restaurante nunca puede acceder a los datos de otro. El `restaurante_id` se extrae del JWT, nunca del body.

---

## Reglas de Negocio Implementadas

Estas reglas se aplican automaticamente en el backend. No requieren accion del frontend.

| Codigo | Regla | Modulo | Descripcion |
|--------|-------|--------|-------------|
| **R1** | CPP | Inventory | El Costo Promedio Ponderado se recalcula automaticamente en cada compra de insumo |
| **R2** | Back-flushing | POS | Al crear una venta, el stock de cada ingrediente se descuenta segun la composicion de las recetas vendidas |
| **R3** | Validacion de stock | POS | Si un ingrediente no tiene cantidad suficiente, la venta completa es rechazada (no hay venta parcial) |
| **R4** | Contabilidad automatica | POS + Inventory | Ventas y compras generan asientos dobles en `contabilidad.libro_diario` (DEBE/HABER) |
| **R5** | Notificacion en tiempo real | POS -> Kitchen | Cada venta genera un evento WebSocket que notifica a todas las pantallas KDS conectadas |
| **R6** | Multi-pago | POS | Una venta puede pagarse con multiples metodos (efectivo + tarjeta, etc.) |
| **R7** | Aislamiento de datos | Global | Toda la data se filtra por `restaurante_id` del JWT — nunca se mezclan restaurantes |

---

## WebSocket — Tiempo Real (Cocina)

El servidor expone un WebSocket nativo (`ws`) en el mismo puerto HTTP para notificaciones en tiempo real.

```
ws://localhost:3000
```

### Eventos emitidos por el servidor

#### nuevo_pedido

Se dispara automaticamente al registrar una venta exitosa en `POST /api/v1/pos/sales`.

```json
{
  "action": "nuevo_pedido",
  "payload": {
    "id": 42,
    "codigo": "PED-20260414-0001",
    "restaurante_id": 1
  }
}
```

#### actualizar_estado

Se dispara al cambiar el estado de un pedido via `PUT /api/v1/kitchen/:id/status` o por mensaje WebSocket.

```json
{
  "action": "actualizar_estado",
  "payload": {
    "id": 42,
    "estado": "preparando"
  }
}
```

### Mensajes que el cliente puede enviar

#### cambiar_estado

El frontend puede enviar este mensaje para sincronizar cambios de estado entre multiples pantallas KDS.

```json
{
  "action": "cambiar_estado",
  "payload": {
    "id": 42,
    "estado": "listo"
  }
}
```

El servidor reenviara un `actualizar_estado` a todos los demas clientes conectados.

### Ejemplo de conexion (JavaScript)

```javascript
const ws = new WebSocket('ws://localhost:3000');

ws.onopen = () => console.log('Conectado al WebSocket de Komanda');

ws.onmessage = (event) => {
  const msg = JSON.parse(event.data);
  
  switch (msg.action) {
    case 'nuevo_pedido':
      console.log('Nuevo pedido:', msg.payload.codigo);
      // Recargar lista de pedidos en el KDS
      break;
    case 'actualizar_estado':
      console.log('Estado actualizado:', msg.payload.id, '->', msg.payload.estado);
      // Actualizar el card del pedido en pantalla
      break;
  }
};

ws.onclose = () => {
  console.log('Desconectado — intentando reconectar en 3s...');
  setTimeout(() => { /* reconectar */ }, 3000);
};
```

---

## Stack Tecnologico

| Capa | Tecnologia | Version |
|------|------------|---------|
| Runtime | Node.js | 18+ |
| Lenguaje | TypeScript | 5.x |
| Framework HTTP | Express | 4.x |
| ORM | TypeORM | 0.3.x |
| Base de Datos | PostgreSQL | 15+ |
| Validacion de entrada | Zod | 3.x |
| Autenticacion | JWT (`jsonwebtoken`) | — |
| Hash de contraseñas | bcrypt | — |
| Tiempo Real | WebSocket (`ws`) | — |
| Reportes (legacy) | PHP | 8.x |

---

## Variables de Entorno

Archivo `.env` en la raiz de `Komanda-api/`:

```env
PORT=3000

DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=komanda_db

NODE_ENV=development
JWT_SECRET=tu_clave_secreta     # Default: komanda_secret_key_2026
```

> **Produccion:** Cambia siempre `JWT_SECRET` por una clave segura. El default es solo para desarrollo.

---

## Como arrancar la API

```bash
# Instalar dependencias
pnpm install

# Modo desarrollo (hot-reload con ts-node)
pnpm run dev

# Compilar para produccion
pnpm run build

# Ejecutar build compilado
pnpm start
```

El servidor arranca en `http://localhost:3000` y muestra:

```
Server ready at: http://localhost:3000
```

---

## Convenciones de la API

| Concepto | Convencion |
|----------|------------|
| Versionado | `/api/v1/` como prefijo de todas las rutas |
| Formato body | JSON (`Content-Type: application/json`) |
| Formato respuesta | JSend (`{ status, data?, message?, errors? }`) |
| IDs | Enteros auto-incrementales |
| Fechas | ISO 8601 (`2026-04-15T21:00:00Z`) |
| Codigos de pedido | `PED-YYYYMMDD-NNNN` (ej: `PED-20260415-0003`) |
| Nombres de campo | `snake_case` en JSON de respuesta (coincide con la BD) |

---

> **Siguiente paso:** Lee la documentacion de cada modulo para conocer los endpoints, bodies, respuestas y ejemplos detallados -> [auth.md](./auth.md) es un buen punto de partida.
