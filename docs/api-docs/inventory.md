# Inventory — Gestion de Inventario

> Modulo para administrar el stock de materias primas (ingredientes) del restaurante. Incluye consulta de inventario y registro de compras con calculo automatico de Costo Promedio Ponderado (CPP) y asientos contables.

**Base URL:** `http://localhost:3000/api/v1/inventory`  
**Auth:** Todas las rutas requieren token JWT.

---

## Indice

1. [GET / — Listar inventario](#get---listar-inventario)
2. [POST /purchase — Registrar compra de insumos](#post-purchase--registrar-compra-de-insumos)
3. [Reglas de negocio](#reglas-de-negocio)

---

## `GET /` — Listar inventario

Retorna todos los ingredientes del restaurante, ordenados alfabeticamente por nombre.

### URL

```
GET /api/v1/inventory/
```

### Auth

Token JWT requerido.

### Parametros

Ninguno. El `restaurantId` se extrae del token JWT.

### Respuesta exitosa — 200 OK

```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "nombre": "Harina",
      "cantidad_disponible": 15,
      "cantidad_minima": 5,
      "unidad_id": 1,
      "costo_promedio": "2.75",
      "categoria": "Secos",
      "fecha_caducidad": "2026-12-31",
      "restaurante_id": 1
    },
    {
      "id": 2,
      "nombre": "Queso Mozzarella",
      "cantidad_disponible": 8,
      "cantidad_minima": 5,
      "unidad_id": 1,
      "costo_promedio": "5.20",
      "categoria": "Lacteos",
      "fecha_caducidad": "2026-06-15",
      "restaurante_id": 1
    }
  ]
}
```

### Campos de cada ingrediente

| Campo | Tipo | Descripcion |
|-------|------|-------------|
| `id` | `number` | ID unico del ingrediente |
| `nombre` | `string` | Nombre del insumo |
| `cantidad_disponible` | `number` | Stock actual disponible |
| `cantidad_minima` | `number` | Stock minimo antes de alerta |
| `unidad_id` | `number` | ID de la unidad de medida |
| `costo_promedio` | `string` | Costo Promedio Ponderado actual (decimal como string) |
| `categoria` | `string` | Categoria del insumo (Secos, Lacteos, etc.) |
| `fecha_caducidad` | `string \| null` | Fecha de vencimiento (ISO date) |
| `restaurante_id` | `number` | ID del restaurante |

### Ejemplo con curl

```bash
curl http://localhost:3000/api/v1/inventory/ \
  -H "Authorization: Bearer <TOKEN>"
```

---

## `POST /purchase` — Registrar compra de insumos

Registra una compra de ingredientes para el inventario. Ejecuta una transaccion atomica que:

1. Crea ingredientes nuevos o actualiza el stock de los existentes
2. Recalcula el **Costo Promedio Ponderado (CPP)** automaticamente
3. Genera **asientos contables** en `contabilidad.libro_diario`

### URL

```
POST /api/v1/inventory/purchase
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
  "items": [
    {
      "name": "Harina",
      "quantity": 10,
      "price": 2.50,
      "unit": "Kg",
      "category": "Secos",
      "expiryDate": "2026-12-31"
    },
    {
      "name": "Queso Mozzarella",
      "quantity": 5,
      "price": 5.20,
      "unit": "Kg",
      "category": "Lacteos",
      "expiryDate": "2026-06-15"
    }
  ]
}
```

### Campos del body

| Campo | Tipo | Requerido | Descripcion |
|-------|------|-----------|-------------|
| `items` | `array` | SI | Lista de insumos a comprar (minimo 1 item) |

### Campos de cada item

| Campo | Tipo | Requerido | Default | Validacion | Descripcion |
|-------|------|-----------|---------|------------|-------------|
| `name` | `string` | SI | — | Minimo 1 caracter | Nombre del ingrediente |
| `quantity` | `number` | SI | — | > 0 | Cantidad comprada |
| `price` | `number` | NO | `0` | >= 0 | Precio unitario de compra |
| `unit` | `string` | NO | `"Kg"` | — | Unidad de medida |
| `category` | `string` | NO | `"General"` | — | Categoria del insumo |
| `expiryDate` | `string` | NO | `null` | Formato `YYYY-MM-DD` | Fecha de caducidad |

### Respuesta exitosa — 201 Created

```json
{
  "status": "success",
  "data": {
    "success": true,
    "message": "Compras registradas correctamente",
    "data": [
      {
        "id": 1,
        "nombre": "Harina",
        "cantidad_disponible": 25,
        "cantidad_minima": 5,
        "unidad_id": 1,
        "costo_promedio": "2.6250",
        "categoria": "Secos",
        "fecha_caducidad": "2026-12-31",
        "restaurante_id": 1
      },
      {
        "id": 2,
        "nombre": "Queso Mozzarella",
        "cantidad_disponible": 13,
        "cantidad_minima": 5,
        "unidad_id": 1,
        "costo_promedio": "5.2000",
        "categoria": "Lacteos",
        "fecha_caducidad": "2026-06-15",
        "restaurante_id": 1
      }
    ]
  }
}
```

### Errores posibles

| HTTP | message | Causa |
|------|---------|-------|
| `400` | `Error de validacion` + `details` | El body no cumple el schema Zod |
| `400` | `Debe enviar al menos un item para registrar compra` | Array `items` vacio |
| `500` | `Error al registrar la compra en el inventario` | Error interno en la transaccion |

### Ejemplo con curl — Compra de un solo insumo

```bash
curl -X POST http://localhost:3000/api/v1/inventory/purchase \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{
    "items": [
      {
        "name": "Tomate",
        "quantity": 20,
        "price": 1.50,
        "unit": "Kg",
        "category": "Verduras",
        "expiryDate": "2026-05-01"
      }
    ]
  }'
```

### Ejemplo con curl — Compra multiple

```bash
curl -X POST http://localhost:3000/api/v1/inventory/purchase \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{
    "items": [
      { "name": "Harina", "quantity": 10, "price": 2.50, "category": "Secos" },
      { "name": "Aceite", "quantity": 5, "price": 3.00, "unit": "Lt", "category": "Liquidos" },
      { "name": "Sal", "quantity": 2, "price": 0.80, "category": "Secos" }
    ]
  }'
```

---

## Reglas de negocio

### R1 — Costo Promedio Ponderado (CPP)

Cuando se registra una compra de un ingrediente que **ya existe** en el inventario, el costo promedio se recalcula automaticamente con la formula:

```
CPP_nuevo = (stock_actual x CPP_anterior + cantidad_comprada x precio_compra)
            / (stock_actual + cantidad_comprada)
```

**Ejemplo practico:**

| Estado | Stock | CPP | Operacion |
|--------|-------|------|-----------|
| Antes de compra | 10 unidades | $2.00 | — |
| Compra | +5 unidades | $3.00 c/u | `(10x2 + 5x3) / 15` |
| Despues de compra | 15 unidades | **$2.3333** | CPP recalculado |

Si el ingrediente **no existe**, se crea con el precio de compra como CPP inicial.

### R4 — Contabilidad automatica

Cada compra con `price > 0` genera **dos asientos contables** en `contabilidad.libro_diario`:

| Asiento | Tipo | Debe | Haber |
|---------|------|------|-------|
| Compra de insumo (inventario) | `compra_insumo` | `monto` | `0` |
| Pago compra (caja/banco) | `compra_insumo` | `0` | `monto` |

Donde `monto = quantity x price`.

### Busqueda de ingredientes

La busqueda de ingredientes existentes es **case-insensitive**. Si envias `"name": "harina"` y ya existe `"Harina"`, se actualizara el ingrediente existente en lugar de crear uno nuevo.

---

## Resumen de endpoints

| Metodo | Ruta | Descripcion | Auth |
|--------|------|-------------|------|
| `GET` | `/inventory/` | Listar todos los ingredientes | JWT |
| `POST` | `/inventory/purchase` | Registrar compra de insumos (CPP + contabilidad) | JWT |

---

> **Siguiente modulo:** [Kitchen — Pantalla de Cocina](./kitchen.md)
