# Menu — Gestion de Recetas y Categorias

> Modulo CRUD para administrar la carta del restaurante. Permite crear, leer, actualizar y eliminar recetas (platos) y sus categorias.

**Base URL:** `http://localhost:3000/api/v1/menu`  
**Auth:** Todas las rutas requieren token JWT.

---

## Indice

1. [GET /recetas — Listar recetas](#get-recetas--listar-recetas)
2. [POST /recetas — Crear receta](#post-recetas--crear-receta)
3. [PUT /recetas/:id — Actualizar receta](#put-recetasid--actualizar-receta)
4. [DELETE /recetas/:id — Eliminar receta](#delete-recetasid--eliminar-receta)
5. [GET /categorias — Listar categorias](#get-categorias--listar-categorias)
6. [POST /categorias — Crear categoria](#post-categorias--crear-categoria)

---

## `GET /recetas` — Listar recetas

Retorna todas las recetas del restaurante, ordenadas alfabeticamente.

### URL

```
GET /api/v1/menu/recetas
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
      "nombre": "Hamburguesa Clasica",
      "descripcion": "200g de carne con lechuga, tomate y queso",
      "precio_venta": "9.00",
      "imagen_url": "",
      "activo": true,
      "categoria_id": 2,
      "restaurante_id": 1
    },
    {
      "id": 2,
      "nombre": "Pasta Carbonara",
      "descripcion": "Pasta con salsa cremosa de huevo y bacon",
      "precio_venta": "12.50",
      "imagen_url": "",
      "activo": true,
      "categoria_id": 3,
      "restaurante_id": 1
    }
  ]
}
```

### Campos de cada receta

| Campo | Tipo | Descripcion |
|-------|------|-------------|
| `id` | `number` | ID unico de la receta |
| `nombre` | `string` | Nombre del plato |
| `descripcion` | `string \| null` | Descripcion del plato |
| `precio_venta` | `string` | Precio de venta (decimal como string) |
| `imagen_url` | `string` | URL de la imagen del plato |
| `activo` | `boolean` | Si esta activo y visible en el POS |
| `categoria_id` | `number \| null` | ID de la categoria a la que pertenece |
| `restaurante_id` | `number` | ID del restaurante |

### Ejemplo con curl

```bash
curl http://localhost:3000/api/v1/menu/recetas \
  -H "Authorization: Bearer <TOKEN>"
```

---

## `POST /recetas` — Crear receta

Crea una nueva receta (plato del menu) para el restaurante.

### URL

```
POST /api/v1/menu/recetas
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
  "nombre": "Pasta Carbonara",
  "descripcion": "Pasta con salsa cremosa de huevo y bacon",
  "categoria_id": 2,
  "imagen_url": "",
  "precio_venta": 12.50,
  "activo": true
}
```

### Campos del body

| Campo | Tipo | Requerido | Default | Validacion |
|-------|------|-----------|---------|------------|
| `nombre` | `string` | SI | — | Minimo 2 caracteres |
| `descripcion` | `string` | NO | `null` | — |
| `categoria_id` | `number \| null` | NO | `null` | ID valido de categoria existente |
| `imagen_url` | `string` | NO | `""` | — |
| `precio_venta` | `number` | SI | — | >= 0 |
| `activo` | `boolean` | NO | `true` | — |

### Respuesta exitosa — 201 Created

```json
{
  "status": "success",
  "data": {
    "id": 5,
    "nombre": "Pasta Carbonara",
    "descripcion": "Pasta con salsa cremosa de huevo y bacon",
    "precio_venta": 12.50,
    "imagen_url": "",
    "activo": true,
    "categoria_id": 2,
    "restaurante_id": 1
  }
}
```

### Errores posibles

| HTTP | message | Causa |
|------|---------|-------|
| `400` | `Datos invalidos` | El body no cumple el schema (nombre muy corto, precio negativo) |

### Ejemplo con curl

```bash
curl -X POST http://localhost:3000/api/v1/menu/recetas \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{
    "nombre": "Ensalada Cesar",
    "descripcion": "Lechuga romana con aderezo cesar y crutones",
    "categoria_id": 1,
    "precio_venta": 8.50,
    "activo": true
  }'
```

---

## `PUT /recetas/:id` — Actualizar receta

Actualiza parcialmente una receta existente. Solo envia los campos que quieres cambiar.

### URL

```
PUT /api/v1/menu/recetas/:id
```

### Parametros de ruta

| Parametro | Tipo | Descripcion |
|-----------|------|-------------|
| `id` | `number` | ID de la receta a actualizar |

### Auth

Token JWT requerido.

### Headers requeridos

```http
Content-Type: application/json
Authorization: Bearer <TOKEN>
```

### Request Body (todos los campos opcionales)

```json
{
  "precio_venta": 14.00,
  "descripcion": "Pasta cremosa con panceta ahumada"
}
```

### Campos del body

Todos los campos son **opcionales**. Solo se actualizan los que envies:

| Campo | Tipo | Validacion |
|-------|------|------------|
| `nombre` | `string` | Minimo 2 caracteres (si se envia) |
| `descripcion` | `string` | — |
| `categoria_id` | `number \| null` | ID de categoria existente |
| `imagen_url` | `string` | — |
| `precio_venta` | `number` | >= 0 |
| `activo` | `boolean` | — |

### Respuesta exitosa — 200 OK

```json
{
  "status": "success",
  "data": {
    "id": 5,
    "nombre": "Pasta Carbonara",
    "descripcion": "Pasta cremosa con panceta ahumada",
    "precio_venta": "14.00",
    "imagen_url": "",
    "activo": true,
    "categoria_id": 2,
    "restaurante_id": 1
  }
}
```

### Errores posibles

| HTTP | message | Causa |
|------|---------|-------|
| `400` | `Datos invalidos` | Validacion Zod fallida |
| `400` | `Receta no encontrada` | El ID no existe o no pertenece al restaurante |

### Ejemplo con curl

```bash
curl -X PUT http://localhost:3000/api/v1/menu/recetas/5 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{ "precio_venta": 14.00, "activo": false }'
```

---

## `DELETE /recetas/:id` — Eliminar receta

Elimina permanentemente una receta del menu.

### URL

```
DELETE /api/v1/menu/recetas/:id
```

### Parametros de ruta

| Parametro | Tipo | Descripcion |
|-----------|------|-------------|
| `id` | `number` | ID de la receta a eliminar |

### Auth

Token JWT requerido.

### Respuesta exitosa — 200 OK

```json
{
  "status": "success",
  "data": null
}
```

### Errores posibles

| HTTP | message | Causa |
|------|---------|-------|
| `400` | `Receta no encontrada` | El ID no existe o no pertenece al restaurante |

### Ejemplo con curl

```bash
curl -X DELETE http://localhost:3000/api/v1/menu/recetas/5 \
  -H "Authorization: Bearer <TOKEN>"
```

> **Cuidado:** Esta operacion es irreversible. Si quieres ocultar una receta sin eliminarla, usa `PUT` con `{ "activo": false }`.

---

## `GET /categorias` — Listar categorias

Retorna todas las categorias del menu, ordenadas por su campo `orden`.

### URL

```
GET /api/v1/menu/categorias
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
    },
    {
      "id": 3,
      "nombre": "Bebidas",
      "orden": 3,
      "activo": true,
      "restaurante_id": 1
    }
  ]
}
```

### Ejemplo con curl

```bash
curl http://localhost:3000/api/v1/menu/categorias \
  -H "Authorization: Bearer <TOKEN>"
```

---

## `POST /categorias` — Crear categoria

Crea una nueva categoria para el menu. El campo `orden` se asigna automaticamente (max + 1).

### URL

```
POST /api/v1/menu/categorias
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
  "nombre": "Postres"
}
```

### Campos del body

| Campo | Tipo | Requerido | Validacion |
|-------|------|-----------|------------|
| `nombre` | `string` | SI | Minimo 2 caracteres |

### Respuesta exitosa — 201 Created

```json
{
  "status": "success",
  "data": {
    "id": 4,
    "nombre": "Postres",
    "orden": 4,
    "activo": true,
    "restaurante_id": 1
  }
}
```

### Errores posibles

| HTTP | message | Causa |
|------|---------|-------|
| `400` | `Datos invalidos` | Nombre vacio o con menos de 2 caracteres |

### Ejemplo con curl

```bash
curl -X POST http://localhost:3000/api/v1/menu/categorias \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{ "nombre": "Postres" }'
```

---

## Resumen de endpoints

| Metodo | Ruta | Descripcion | Auth |
|--------|------|-------------|------|
| `GET` | `/menu/recetas` | Listar todas las recetas | JWT |
| `POST` | `/menu/recetas` | Crear una receta nueva | JWT |
| `PUT` | `/menu/recetas/:id` | Actualizar una receta (parcial) | JWT |
| `DELETE`| `/menu/recetas/:id` | Eliminar una receta | JWT |
| `GET` | `/menu/categorias` | Listar categorias del menu | JWT |
| `POST` | `/menu/categorias` | Crear una categoria nueva | JWT |

---

> **Siguiente modulo:** [Inventory — Gestion de Inventario](./inventory.md)
