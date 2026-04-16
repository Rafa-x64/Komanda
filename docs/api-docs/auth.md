# Auth — Registro e Inicio de Sesion

> Modulo de autenticacion de Komanda. Incluye el registro de restaurantes nuevos (signup) y el inicio de sesion de usuarios existentes (signin).

**Base URL:** `http://localhost:3000/api/v1`  
**Auth:** Estos endpoints son publicos — no requieren token JWT.

---

## Indice

1. [POST /signup/register — Registrar restaurante](#post-signupregister--registrar-restaurante)
2. [POST /signin/login — Iniciar sesion](#post-signinlogin--iniciar-sesion)
3. [Flujo completo de autenticacion](#flujo-completo-de-autenticacion)

---

## `POST /signup/register` — Registrar restaurante

Crea un nuevo restaurante junto con su usuario administrador inicial. Este es el primer paso para empezar a usar Komanda.

### URL

```
POST /api/v1/signup/register
```

### Autenticacion

No requiere token — Endpoint publico.

### Headers requeridos

```http
Content-Type: application/json
```

### Request Body

```json
{
  "restaurant": {
    "name": "Mi Restaurante",
    "phone": "+58 424 0000000",
    "address": "Calle Principal 123, Caracas",
    "email": "info@mirestaurant.com",
    "currency": "USD",
    "zone": "America/Caracas",
    "tax": "16",
    "tip": "10",
    "restaurantLogo": ""
  },
  "admin": {
    "name": "Juan Perez",
    "userName": "juanp",
    "email": "juan@mirestaurant.com",
    "password": "secret123",
    "confirmPassword": "secret123"
  }
}
```

### Campos del objeto `restaurant`

| Campo | Tipo | Requerido | Default | Descripcion |
|-------|------|-----------|---------|-------------|
| `name` | `string` | SI | — | Nombre del restaurante (minimo 2 caracteres) |
| `phone` | `string` | NO | `null` | Telefono de contacto |
| `address` | `string` | NO | `null` | Direccion fisica |
| `email` | `string` | NO | `null` | Email del restaurante (debe ser email valido si se envia) |
| `currency` | `string` | NO | `"USD"` | Moneda para precios y reportes |
| `zone` | `string` | NO | `"America/Caracas"` | Zona horaria (formato IANA) |
| `tax` | `string \| number` | NO | `"0"` | Porcentaje de impuesto (ej: `"16"` = 16%) |
| `tip` | `string \| number` | NO | `"0"` | Porcentaje de propina sugerida |
| `restaurantLogo` | `string` | NO | `""` | URL del logo del restaurante |

### Campos del objeto `admin`

| Campo | Tipo | Requerido | Validacion |
|-------|------|-----------|------------|
| `name` | `string` | SI | Minimo 2 caracteres |
| `userName` | `string` | SI | Minimo 3 caracteres |
| `email` | `string` | SI | Formato email valido |
| `password` | `string` | SI | Minimo 6 caracteres |
| `confirmPassword` | `string` | SI | Debe coincidir con `password` |

### Respuesta exitosa — 201 Created

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

### Errores posibles

| HTTP | message | Causa |
|------|---------|-------|
| `400` | `Datos invalidos` | Uno o mas campos no pasan la validacion Zod |
| `400` | `El correo ya esta registrado.` | Ya existe un usuario con ese email |
| `400` | `Las contraseñas no coinciden` | `password` != `confirmPassword` |

### Ejemplo con curl

```bash
curl -X POST http://localhost:3000/api/v1/signup/register \
  -H "Content-Type: application/json" \
  -d '{
    "restaurant": {
      "name": "La Parrilla de Juan",
      "currency": "USD",
      "tax": "16"
    },
    "admin": {
      "name": "Juan Admin",
      "userName": "juanadmin",
      "email": "juan@parrilla.com",
      "password": "miClave123",
      "confirmPassword": "miClave123"
    }
  }'
```

### Que sucede internamente

1. Zod valida el body completo (incluyendo que las contraseñas coincidan)
2. Se verifica que el email no este registrado
3. Se inicia una transaccion atomica (todo o nada):
   - Se crea el registro del restaurante en `core.restaurante`
   - Se crea el rol `admin` asociado al restaurante
   - Se hashea la contraseña con `bcrypt` (10 rondas de salt)
   - Se crea el usuario administrador en `core.usuarios`
4. Se hace `COMMIT` de la transaccion
5. Se retorna la confirmacion con los IDs generados

> **Nota sobre transacciones:** Si cualquier paso falla (ej: email duplicado), se hace `ROLLBACK` automatico y no se crea nada en la base de datos.

---

## `POST /signin/login` — Iniciar sesion

Autentica un usuario existente y retorna un token JWT valido por 8 horas.

### URL

```
POST /api/v1/signin/login
```

### Autenticacion

No requiere token — Endpoint publico.

### Headers requeridos

```http
Content-Type: application/json
```

### Request Body

```json
{
  "username": "juanp",
  "password": "secret123",
  "restaurantName": "Mi Restaurante"
}
```

### Campos

| Campo | Tipo | Requerido | Validacion |
|-------|------|-----------|------------|
| `username` | `string` | SI | Minimo 3 caracteres |
| `password` | `string` | SI | Minimo 3 caracteres |
| `restaurantName` | `string` | SI | Minimo 3 caracteres — Debe coincidir con un restaurante existente |

> **¿Por que `restaurantName`?** Komanda es multi-tenant: un mismo username puede existir en diferentes restaurantes. El nombre del restaurante desambigua.

### Respuesta exitosa — 200 OK

```json
{
  "status": "success",
  "message": "Inicio de sesion exitoso",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 1,
      "nombre": "Juan Perez",
      "username": "juanp",
      "email": "juan@mirestaurant.com",
      "role": "admin"
    },
    "restaurant": {
      "id": 1,
      "nombre": "Mi Restaurante"
    }
  }
}
```

### Campos del objeto `data`

| Campo | Tipo | Descripcion |
|-------|------|-------------|
| `token` | `string` | JWT firmado, valido por 8 horas |
| `user.id` | `number` | ID unico del usuario |
| `user.nombre` | `string` | Nombre completo del usuario |
| `user.username` | `string` | Nombre de usuario |
| `user.email` | `string` | Correo electronico |
| `user.role` | `string` | Rol asignado (`admin`, `mesero`, `cocina`, `cajero`) |
| `restaurant.id` | `number` | ID del restaurante |
| `restaurant.nombre` | `string` | Nombre del restaurante |

### Errores posibles

| HTTP | message | Causa |
|------|---------|-------|
| `400` | `Datos invalidos` | Campos vacios o que no cumplen el minimo de caracteres |
| `401` | `Restaurante no encontrado` | No existe un restaurante con ese nombre |
| `401` | `Credenciales incorrectas` | El username no existe o la contraseña es incorrecta |
| `401` | `Usuario inactivo` | La cuenta del usuario fue desactivada |

### Ejemplo con curl

```bash
curl -X POST http://localhost:3000/api/v1/signin/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "juanp",
    "password": "secret123",
    "restaurantName": "Mi Restaurante"
  }'
```

### Contenido del JWT

El token contiene el siguiente payload (decodificable en jwt.io):

```json
{
  "userId": 1,
  "restaurantId": 1,
  "role": "admin",
  "iat": 1713225600,
  "exp": 1713254400
}
```

| Campo | Descripcion |
|-------|-------------|
| `userId` | ID del usuario autenticado |
| `restaurantId` | ID del restaurante (para filtrar toda la data) |
| `role` | Rol del usuario (para control de acceso) |
| `iat` | Timestamp de emision |
| `exp` | Timestamp de expiracion (iat + 8 horas) |

---

## Flujo completo de autenticacion

```
┌─────────────┐        ┌─────────────┐        ┌─────────────┐
│   Cliente    │        │   API       │        │   BD        │
│  (Frontend)  │        │  (Express)  │        │ (PostgreSQL)│
└──────┬──────┘        └──────┬──────┘        └──────┬──────┘
       │                      │                      │
       │  POST /signin/login  │                      │
       │  {username, password │                      │
       │   restaurantName}    │                      │
       │─────────────────────>│                      │
       │                      │  Buscar restaurante  │
       │                      │─────────────────────>│
       │                      │  Buscar usuario      │
       │                      │─────────────────────>│
       │                      │  bcrypt.compare()    │
       │                      │<─────────────────────│
       │                      │                      │
       │                      │  jwt.sign(payload)   │
       │   200 + JWT token    │                      │
       │<─────────────────────│                      │
       │                      │                      │
       │  GET /api/v1/pos/... │                      │
       │  Authorization:      │                      │
       │  Bearer <token>      │                      │
       │─────────────────────>│                      │
       │                      │  jwt.verify(token)   │
       │                      │  req.user = payload  │
       │                      │  consultar con       │
       │                      │  restaurantId        │
       │                      │─────────────────────>│
       │                      │<─────────────────────│
       │   200 + data         │                      │
       │<─────────────────────│                      │
```

### Como usar el token en el frontend (Vue 3)

```typescript
// Guardar el token tras login exitoso
const loginResponse = await fetch('http://localhost:3000/api/v1/signin/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ username, password, restaurantName })
});

const { data } = await loginResponse.json();
localStorage.setItem('token', data.token);

// Usar el token en cada peticion posterior
const token = localStorage.getItem('token');

const response = await fetch('http://localhost:3000/api/v1/pos/categories', {
  headers: { 'Authorization': `Bearer ${token}` }
});
```

---

> **Siguiente modulo:** [POS — Punto de Venta](./pos.md)
