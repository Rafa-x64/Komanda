# POS — Punto de Venta

> Modulo central de operaciones de Komanda. Gestiona catalogos (categorias, productos, mesas, metodos de pago), registro de ventas con transacciones atomicas y cierre de caja.

**Base URL:** `http://localhost:3000/api/v1/pos`  
**Auth:** Todas las rutas requieren token JWT.

---

## Indice

1. [GET /categories — Listar categorias](#get-categories--listar-categorias)
2. [GET /products — Listar productos (recetas)](#get-products--listar-productos-recetas)
3. [GET /tables — Listar mesas](#get-tables--listar-mesas)
4. [GET /payment-methods — Listar metodos de pago](#get-payment-methods--listar-metodos-de-pago)
5. [GET /sales — Historial de ventas](#get-sales--historial-de-ventas)
6. [POST /sales — Registrar venta](#post-sales--registrar-venta)
7. [POST /cash-closures — Cerrar caja](#post-cash-closures--cerrar-caja)

---

## `GET /categories` — Listar categorias

Retorna todas las categorias activas del menu del restaurante.

### URL

```
GET /api/v1/pos/categories
```

### Auth

Token JWT requerido.

### Parametros

Ninguno. El `restaurantId` se extrae automaticamente del token.

### Respuesta exitosa — 200 OK

```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "nombre": "Entradas",
      "orden": 1,
      "activo": true,
      "restaurante_id": 1
    },
    {
      "id": 2,
      "nombre": "Platos Fuertes",
      "orden": 2,
      "activo": true,
      "restaurante_id": 1
    }
  ]
}
```

### Ejemplo con curl

```bash
curl http://localhost:3000/api/v1/pos/categories \
  -H "Authorization: Bearer <TOKEN>"
```

---

## `GET /products` — Listar productos (recetas)

Retorna todas las recetas activas del restaurante. Cada receta es un plato que se puede vender en el POS.

### URL

```
GET /api/v1/pos/products
```

### Auth

Token JWT requerido.

### Respuesta exitosa — 200 OK

```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "nombre": "Pasta Carbonara",
      "descripcion": "Pasta con salsa cremosa de huevo y bacon",
      "precio_venta": "12.50",
      "imagen_url": "",
      "activo": true,
      "categoria_id": 2,
      "restaurante_id": 1
    },
    {
      "id": 2,
      "nombre": "Hamburguesa Clasica",
      "descripcion": "200g de carne con lechuga, tomate y queso",
      "precio_venta": "9.00",
      "imagen_url": "",
      "activo": true,
      "categoria_id": 2,
      "restaurante_id": 1
    }
  ]
}
```

### Ejemplo con curl

```bash
curl http://localhost:3000/api/v1/pos/products \
  -H "Authorization: Bearer <TOKEN>"
```

---

## `GET /tables` — Listar mesas

Retorna todas las mesas del restaurante con su estado actual.

### URL

```
GET /api/v1/pos/tables
```

### Auth

Token JWT requerido.

### Respuesta exitosa — 200 OK

```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "nombre": "Mesa 1",
      "capacidad": 4,
      "estado": "libre",
      "restaurante_id": 1
    },
    {
      "id": 2,
      "nombre": "Mesa 2",
      "capacidad": 6,
      "estado": "ocupada",
      "restaurante_id": 1
    }
  ]
}
```

### Estados posibles de una mesa

| Estado | Significado |
|--------|-------------|
| `libre` | Disponible para nuevos clientes |
| `ocupada` | Tiene un pedido abierto (cuenta sin pagar) |

### Ejemplo con curl

```bash
curl http://localhost:3000/api/v1/pos/tables \
  -H "Authorization: Bearer <TOKEN>"
```

---

## `GET /payment-methods` — Listar metodos de pago

Retorna los metodos de pago activos del restaurante.

### URL

```
GET /api/v1/pos/payment-methods
```

### Auth

Token JWT requerido.

### Respuesta exitosa — 200 OK

```json
{
  "status": "success",
  "data": [
    { "id": 1, "nombre": "Efectivo", "activo": true },
    { "id": 2, "nombre": "Tarjeta de Debito", "activo": true },
    { "id": 3, "nombre": "Pago Movil", "activo": true },
    { "id": 4, "nombre": "Zelle/Divisa", "activo": true }
  ]
}
```

### Ejemplo con curl

```bash
curl http://localhost:3000/api/v1/pos/payment-methods \
  -H "Authorization: Bearer <TOKEN>"
```

---

## `GET /sales` — Historial de ventas

Retorna los ultimos 50 pedidos del restaurante, ordenados por fecha descendente (mas reciente primero).

### URL

```
GET /api/v1/pos/sales
```

### Auth

Token JWT requerido.

### Respuesta exitosa — 200 OK

```json
{
  "status": "success",
  "data": [
    {
      "id": 42,
      "codigo": "PED-20260414-0001",
      "cliente": "Pedro Lopez",
      "estado": "listo",
      "estado_cuenta": "pagada",
      "subtotal": "22.00",
      "impuestos": "3.52",
      "total": "25.52",
      "fecha_hora": "2026-04-14T21:00:00Z"
    },
    {
      "id": 41,
      "codigo": "PED-20260414-0000",
      "cliente": null,
      "estado": "pendiente",
      "estado_cuenta": "abierta",
      "subtotal": "9.00",
      "impuestos": "1.44",
      "total": "10.44",
      "fecha_hora": "2026-04-14T20:30:00Z"
    }
  ]
}
```

### Campos de la respuesta

| Campo | Tipo | Descripcion |
|-------|------|-------------|
| `id` | `number` | ID unico del pedido |
| `codigo` | `string` | Codigo legible: `PED-YYYYMMDD-NNNN` |
| `cliente` | `string \| null` | Nombre del cliente (opcional) |
| `estado` | `string` | Estado de preparacion: `pendiente`, `preparando`, `listo` |
| `estado_cuenta` | `string` | Estado de pago: `abierta`, `pagada` |
| `subtotal` | `string` | Subtotal antes de impuestos |
| `impuestos` | `string` | Monto de impuestos aplicados |
| `total` | `string` | Total a pagar (subtotal + impuestos) |
| `fecha_hora` | `string` | Timestamp ISO 8601 de creacion |

### Ejemplo con curl

```bash
curl http://localhost:3000/api/v1/pos/sales \
  -H "Authorization: Bearer <TOKEN>"
```

---

## `POST /sales` — Registrar venta

Este es el endpoint mas importante del sistema. Registra una venta nueva ejecutando una transaccion atomica que involucra multiples operaciones.

### URL

```
POST /api/v1/pos/sales
```

### Auth

Token JWT requerido.

### Headers requeridos

```http
Content-Type: application/json
Authorization: Bearer <TOKEN>
```

### Request Body

```json
{
  "mesa_id": 1,
  "cliente": "Pedro Lopez",
  "items": [
    { "receta_id": 1, "cantidad": 2, "notas": "Sin cebolla" },
    { "receta_id": 3, "cantidad": 1, "notas": null }
  ],
  "pagos": [
    { "metodo_pago_id": 1, "monto": 15.00, "referencia": null },
    { "metodo_pago_id": 2, "monto": 20.52, "referencia": "TXN-456789" }
  ]
}
```

### Campos del body

| Campo | Tipo | Requerido | Descripcion |
|-------|------|-----------|-------------|
| `mesa_id` | `number \| null` | NO | ID de la mesa (null = para llevar) |
| `cliente` | `string \| null` | NO | Nombre del cliente |
| `items` | `array` | SI | Lista de productos a vender (minimo 1) |
| `items[].receta_id` | `number` | SI | ID de la receta/producto |
| `items[].cantidad` | `number` | SI | Cantidad (entero positivo) |
| `items[].notas` | `string \| null` | NO | Instrucciones especiales para cocina |
| `pagos` | `array` | NO | Metodos de pago (si no se envia, la cuenta queda `abierta`) |
| `pagos[].metodo_pago_id` | `number` | SI* | ID del metodo de pago |
| `pagos[].monto` | `number` | SI* | Monto pagado con este metodo |
| `pagos[].referencia` | `string \| null` | NO | Referencia de la transaccion (nro. de tarjeta, etc.) |

> *Requerido dentro de cada objeto de pago, pero el array `pagos` es opcional.

### Respuesta exitosa — 201 Created

```json
{
  "status": "success",
  "data": {
    "id": 42,
    "codigo": "PED-20260414-0001",
    "subtotal": 22.00,
    "impuestos": 3.52,
    "total": 25.52,
    "estado_cuenta": "pagada"
  }
}
```

### Campos de la respuesta

| Campo | Tipo | Descripcion |
|-------|------|-------------|
| `id` | `number` | ID del pedido creado |
| `codigo` | `string` | Codigo unico del pedido |
| `subtotal` | `number` | Suma de (precio x cantidad) de cada item |
| `impuestos` | `number` | Subtotal x porcentaje de impuesto del restaurante |
| `total` | `number` | Subtotal + impuestos |
| `estado_cuenta` | `string` | `"pagada"` si la suma de pagos >= total, `"abierta"` si no |

### Errores posibles

| HTTP | message | Causa |
|------|---------|-------|
| `400` | `Error de validacion` | El body no cumple el schema Zod |
| `400` | `La venta debe tener al menos un articulo` | El array `items` esta vacio |
| `500` | `La mesa seleccionada no existe o no pertenece al restaurante` | `mesa_id` invalido |
| `500` | `Una o mas recetas no estan disponibles` | Una `receta_id` no existe o no pertenece al restaurante |
| `500` | `Stock insuficiente para el ingrediente: <nombre>` | **Regla R3** — No hay stock suficiente de un insumo |

### Que sucede internamente (transaccion atomica)

La venta ejecuta 11 operaciones dentro de una sola transaccion. Si cualquiera falla, ninguna se aplica:

```
1. Validar mesa (si se envio mesa_id)
2. Obtener % de impuesto del restaurante
3. Buscar precios reales de cada receta en la BD
4. Calcular stock requerido de ingredientes (segun receta_ingredientes)
5. Validar stock suficiente (R3: si falta algo, RECHAZAR)
6. Back-flushing: descontar ingredientes del inventario (R2)
7. Calcular subtotal, impuestos y total
8. Crear el pedido en operaciones.pedidos
9. Crear los items en operaciones.pedido_detalle
10. Registrar pagos en operaciones.transacciones_pago
11. Generar asientos contables en contabilidad.libro_diario (R4):
    - DEBE: Caja/Bancos (total) + Costo de Ventas (CPP)
    - HABER: Ingresos por Ventas (total) + Inventario (CPP)
```

Despues del `COMMIT`, se emite un evento WebSocket `nuevo_pedido` a todas las pantallas de cocina conectadas (**R5**).

### Ejemplo con curl — Venta con pago completo

```bash
curl -X POST http://localhost:3000/api/v1/pos/sales \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{
    "mesa_id": 1,
    "cliente": "Maria Garcia",
    "items": [
      { "receta_id": 1, "cantidad": 2, "notas": "Extra queso" },
      { "receta_id": 3, "cantidad": 1, "notas": null }
    ],
    "pagos": [
      { "metodo_pago_id": 1, "monto": 35.52, "referencia": null }
    ]
  }'
```

### Ejemplo con curl — Venta sin pago (cuenta abierta)

```bash
curl -X POST http://localhost:3000/api/v1/pos/sales \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{
    "mesa_id": 2,
    "items": [
      { "receta_id": 5, "cantidad": 1, "notas": null }
    ]
  }'
```

Esto crea el pedido con `estado_cuenta: "abierta"` y la mesa pasa a estado `"ocupada"`.

### Ejemplo con curl — Multi-pago

```bash
curl -X POST http://localhost:3000/api/v1/pos/sales \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{
    "mesa_id": 1,
    "items": [
      { "receta_id": 1, "cantidad": 1, "notas": null }
    ],
    "pagos": [
      { "metodo_pago_id": 1, "monto": 5.00, "referencia": null },
      { "metodo_pago_id": 2, "monto": 9.80, "referencia": "TXN-789" }
    ]
  }'
```

---

## `POST /cash-closures` — Cerrar caja

Registra el cierre de caja del turno actual. Crea un registro en `finanzas.caja`.

### URL

```
POST /api/v1/pos/cash-closures
```

### Auth

Token JWT requerido.

### Headers requeridos

```http
Content-Type: application/json
Authorization: Bearer <TOKEN>
```

### Request Body

```json
{
  "monto_final": 1500.00,
  "observaciones": "Cierre turno noche. Sin novedades."
}
```

### Campos del body

| Campo | Tipo | Requerido | Validacion | Descripcion |
|-------|------|-----------|------------|-------------|
| `monto_final` | `number` | SI | >= 0 | Monto contado fisicamente en caja al cierre |
| `observaciones` | `string \| null` | NO | — | Notas del cajero sobre el turno |

### Respuesta exitosa — 200 OK

```json
{
  "status": "success",
  "data": {
    "caja_id": 5,
    "status": "Caja cerrada exitosamente"
  }
}
```

### Errores posibles

| HTTP | message | Causa |
|------|---------|-------|
| `400` | `Error de validacion` | `monto_final` negativo o no numerico |
| `500` | Error generico | Error interno al insertar en `finanzas.caja` |

### Ejemplo con curl

```bash
curl -X POST http://localhost:3000/api/v1/pos/cash-closures \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{
    "monto_final": 1500.00,
    "observaciones": "Cierre turno noche"
  }'
```

---

## Resumen de endpoints

| Metodo | Ruta | Descripcion | Auth |
|--------|------|-------------|------|
| `GET`  | `/pos/categories` | Listar categorias activas | JWT |
| `GET`  | `/pos/products` | Listar productos activos | JWT |
| `GET`  | `/pos/tables` | Listar mesas con estado | JWT |
| `GET`  | `/pos/payment-methods` | Listar metodos de pago activos | JWT |
| `GET`  | `/pos/sales` | Ultimos 50 pedidos | JWT |
| `POST` | `/pos/sales` | Registrar venta (atomica) | JWT |
| `POST` | `/pos/cash-closures` | Cerrar caja del turno | JWT |

---

> **Siguiente modulo:** [Menu — Gestion de Recetas](./menu.md)
