# Employees — Gestion de Empleados

> Modulo para listar, crear, actualizar y desactivar a los usuarios del sistema por cada restaurante, asi como listar los roles de permisos disponibles.

**Base URL:** `http://localhost:3000/api/v1/employees`  
**Auth:** Todas las rutas requieren token JWT y estrictamente rol `admin`.

---

## Indice

1. [GET / — Listar empleados](#get---listar-empleados)
2. [POST / — Crear empleado](#post---crear-empleado)
3. [PUT /:id — Actualizar empleado](#put-id--actualizar-empleado)
4. [DELETE /:id — Desactivar empleado](#delete-id--desactivar-empleado)
5. [GET /roles — Listar roles](#get-roles--listar-roles)
6. [GET /seed-roles — Generador base](#get-seed-roles--generador-base)

---

## `GET /` — Listar empleados

Obtiene el listado completo de usuarios vinculados al restaurante especificado en el token.

### URL

```
GET /api/v1/employees/
```

### Auth

Token JWT requerido. Rol: `admin`.

### Respuesta exitosa — 200 OK

```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "nombre": "Juan Administrador",
      "email": "juan@komanda.com",
      "username": "juanadmin",
      "activo": true,
      "rol_id": 1,
      "rol_nombre": "admin",
      "created_at": "2026-04-14T20:10:00Z"
    },
    {
      "id": 2,
      "nombre": "Carlos Mesero",
      "email": "carlos@komanda.com",
      "username": "carlos",
      "activo": true,
      "rol_id": 3,
      "rol_nombre": "mesero",
      "created_at": "2026-04-15T09:00:00Z"
    }
  ]
}
```

---

## `POST /` — Crear empleado

Añade un nuevo empleado/usuario al restaurante.

### URL

```
POST /api/v1/employees/
```

### Auth

Token JWT requerido. Rol: `admin`.

### Request Body

```json
{
  "nombre": "Maria Cajera",
  "email": "maria@komanda.com",
  "username": "mariac",
  "password": "securepassword",
  "rol_id": 2
}
```

### Campos del body

| Campo | Tipo | Requerido | Validacion |
|-------|------|-----------|------------|
| `nombre` | `string` | SI | 2 a 100 caracteres |
| `email` | `string` | SI | Email valido |
| `username` | `string` | SI | 3 a 50 caracteres (Debe ser unico globalmente o saltara error de duplicado por BD) |
| `password` | `string` | SI | Minimo 6 caracteres |
| `rol_id` | `number` | SI | ID valido de rol |

### Respuesta exitosa — 201 Created

```json
{
  "status": "success",
  "data": {
    "id": 4,
    "nombre": "Maria Cajera",
    "username": "mariac",
    "email": "maria@komanda.com",
    "rol": "cajero"
  }
}
```

### Errores posibles

| HTTP | message | Causa |
|------|---------|-------|
| `400` | `El nombre de usuario ya esta en uso` | El username ya existe para algun usuario general en base de datos. |
| `400` | `Rol no valido` | `rol_id` proporcionado no existe en `core.roles`. |

---

## `PUT /:id` — Actualizar empleado

Actualiza atributos de un usuario. Puedes enviar la contraseña vacia u omitirla si no deseas cambiarla.

### URL

```
PUT /api/v1/employees/:id
```

### Auth

Token JWT requerido. Rol: `admin`.

### Request Body (Puede ser parcial o envio total)

```json
{
  "activo": false,
  "nombre": "Maria G. Cajera"
}
```

### Respuesta exitosa — 200 OK

```json
{
  "status": "success",
  "data": {
    "message": "Empleado actualizado"
  }
}
```

---

## `DELETE /:id` — Desactivar empleado

Aplica baja logica. Modificará `activo: false`. No hace `DELETE CASCADE` directo de base de datos debido a que los registros de auditoria dependen del usuario historico.

### URL

```
DELETE /api/v1/employees/:id
```

### Auth

Token JWT requerido. Rol: `admin`.

### Respuesta exitosa — 200 OK

```json
{
  "status": "success",
  "data": {
    "message": "Empleado desactivado"
  }
}
```

### Errores posibles

| HTTP | message | Causa |
|------|---------|-------|
| `400` | `Empleado no encontrado` | ID de empleado no es valido o no concuerda para el `restaurante_id` solicitante. |

---

## `GET /roles` — Listar roles

Retorna el listado base global de `core.roles` de forma acotada a ser utlizado en los select frontales.

### URL

```
GET /api/v1/employees/roles
```

### Auth

Token JWT requerido. Rol: `admin`.

### Respuesta exitosa — 200 OK

```json
{
  "status": "success",
  "data": [
    { "id": 1, "nombre": "admin" },
    { "id": 2, "nombre": "cajero" },
    { "id": 3, "nombre": "mesero" },
    { "id": 4, "nombre": "cocina" }
  ]
}
```

---

## `GET /seed-roles` — Generador base

Especial: Rellena la tabla `core.roles` con sus valores natos. Usese unicamente en momento de `setup` luego de vaciar y sincronizar las tablas de forma inicial. Es abierto/publico para ayudar a los desarrolladores a construir su DB.

```bash
curl http://localhost:3000/api/v1/employees/seed-roles
```

```json
{
  "status": "success",
  "message": "Roles seeded globally"
}
```

---

## Resumen de endpoints

| Metodo | Ruta | Descripcion | Auth |
|--------|------|-------------|------|
| `GET` | `/employees/` | Listar empleados | JWT (admin) |
| `POST` | `/employees/` | Crear empleado | JWT (admin) |
| `PUT` | `/employees/:id` | Editar un empleado o suspender | JWT (admin) |
| `DELETE` | `/employees/:id` | Soft-delete a un empleado | JWT (admin) |
| `GET` | `/employees/roles` | Devuelve `admin`, `cocina`, etc. | JWT (admin) |
| `GET` | `/employees/seed-roles` | Poblador dev/inicial de `core.roles` | public |
