# Komanda API

REST API principal del sistema de gestion para restaurantes **Komanda**. Construida con **Node.js + TypeScript + Express + TypeORM + PostgreSQL**.

---

## Stack Tecnologico

| Capa | Tecnologia |
|---|---|
| Runtime | Node.js |
| Lenguaje | TypeScript |
| Framework | Express |
| ORM | TypeORM |
| Base de Datos | PostgreSQL |
| Validacion | Zod |
| Auth | JWT (jsonwebtoken) |
| Tiempo Real | WebSocket (ws) |

---

## Variables de Entorno

Crea un archivo `.env` en la raiz de `Komanda-api/`:

```env
PORT=3000

DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=komanda_db

NODE_ENV=development
```

> La clave JWT por defecto es `komanda_secret_key_2026`. Sobreescribela en produccion con `JWT_SECRET=<tu_clave>`.

---

## Arranque

```bash
pnpm install
pnpm run dev      # Desarrollo (ts-node)
pnpm run build    # Compilar
pnpm start        # Produccion
```

El servidor arranca en `http://localhost:3000`.

---

## Autenticacion

Todas las rutas protegidas requieren el header:

```
Authorization: Bearer <JWT_TOKEN>
```

El token se obtiene en `POST /api/v1/signin/login` y contiene `userId`, `restaurantId` y `role`.

### Roles disponibles

| Rol | Descripcion |
|---|---|
| `admin` | Acceso total |
| `mesero` | POS y visualizacion |
| `cocina` | Pantalla KDS (Kitchen Display) |

---

## Endpoints (Resumen corto)

Para ver la documentacion completa, de cuerpos de request (body) o schemas dirigete a la carpeta `docs/api-docs/`.  

> Base URL: `http://localhost:3000/api/v1`

| Modulo     | Metodo   | Endpoint                   | Proposito                            | Auth       |
|------------|----------|----------------------------|--------------------------------------|------------|
| Index      | `GET`    | `/`                        | Health Check de la api               | Public     |
| Auth       | `POST`   | `/signup/register`         | Registro de restaurante y admin      | Public     |
| Auth       | `POST`   | `/signin/login`            | Autenticacion y generacion de Token  | Public     |
| POS        | `GET`    | `/pos/categories`          | Retorna categorias habilitadas       | JWT        |
| POS        | `GET`    | `/pos/products`            | Retorna recetas del menu de POS      | JWT        |
| POS        | `GET`    | `/pos/tables`              | Retorna lista de mesas               | JWT        |
| POS        | `GET`    | `/pos/payment-methods`     | Metodos de pagos activos             | JWT        |
| POS        | `POST`   | `/pos/sales`               | Crea transaccion de venta completa   | JWT        |
| POS        | `POST`   | `/pos/cash-closures`       | Gestiona cierres de caja en reportes | JWT        |
| POS        | `GET`    | `/pos/sales`               | Lista ventas historicas              | JWT        |
| Menu       | `GET`    | `/menu/recetas`            | Lista completa de la carta de items  | JWT        |
| Menu       | `POST`   | `/menu/recetas`            | Añadir plato de menu                 | JWT        |
| Menu       | `GET`    | `/menu/categorias`         | Categorias de Platos                 | JWT        |
| Menu       | `POST`   | `/menu/categorias`         | Añadir categoria                     | JWT        |
| Inventory  | `GET`    | `/inventory/`              | Inventario e insumos                 | JWT        |
| Inventory  | `POST`   | `/inventory/purchase`      | Carga existencias / compras insumos  | JWT        |
| Kitchen    | `GET`    | `/kitchen/`                | Pedidos de KDS Pantalla de preparacion| JWT(Cocina)|
| Kitchen    | `PUT`    | `/kitchen/:id/status`      | Transmutacion de preparando/listo    | JWT(Cocina)|
| Employees  | `GET`    | `/employees/`              | Listado de Empleados                 | JWT(Admin) |
| Employees  | `POST`   | `/employees/`              | Nuevo Empleado                       | JWT(Admin) |
| Employees  | `GET`    | `/employees/roles`         | Roles Disponibles                    | JWT(Admin) |

---

## WebSocket — Cocina en Tiempo Real

El servidor expone un **WebSocket** en la misma URL y puerto que el HTTP server.

```
ws://localhost:3000
```

### Eventos emitidos por el servidor al frontend

| Evento | Cuando | Payload |
|---|---|---|
| `new_order` | Al crear una venta en POS (`/pos/sales`) | `{ type: "new_order", order: { id, codigo, restaurante_id } }` |
| `actualizar_estado` | Al modificar un comanda a Listo | `{ type: "actualizar_estado", order: { id, estado } }` |

Las pantallas KDS escuchan esos eventos para sincronizarse en vivo evitando el F5 (Reloading).

---

## Estructura de Modulos de codigo

```
src/
├── config/
│   └── database.ts          # Conexion TypeORM
├── modules/
│   ├── signup/              # Registro de restaurante + admin
│   ├── signin/              # Autenticacion JWT
│   ├── pos/                 # Punto de venta
│   │   └── domain/          # Entidades: Pedido, PedidoDetalle, Mesa, Receta, Categoria
│   ├── menu/                # CRUD recetas y categorias
│   ├── inventory/           # Inventario e insumos
│   ├── kitchen/             # KDS + WebSocket
│   └── employees/           # Gestion de empleados
└── shared/
    └── middleware/
        └── auth.middleware.ts  # JWT + control de roles
```

---

## Esquemas de Base de Datos

| Schema | Tablas principales |
|---|---|
| `core` | `usuarios`, `roles`, `metodos_pago` |
| `operaciones` | `pedidos`, `pedido_detalle`, `mesas`, `transacciones_pago` |
| `menu` | `recetas`, `categorias`, `receta_ingredientes` |
| `inventario` | `ingredientes` |
| `contabilidad` | `libro_diario` |
| `finanzas` | `caja` |

---

## Codigos de Respuesta

| Codigo | Significado |
|---|---|
| `200` | OK |
| `201` | Creado |
| `400` | Validacion fallida (Zod) o error en body |
| `401` | Token no enviado o invalido |
| `403` | Sin permisos para el rol |
| `404` | Recurso no encontrado |
| `500` | Error interno del servidor |

---

## Reglas de Negocio Implementadas

1. **R1 — CPP**: Al comprar ingredientes a traves de `/inventory/purchase`, el costo promedio ponderado de inventario se recalcula automaticamente.
2. **R2 — Back-flushing**: Al enviar un pedido `/pos/sales`, el stock de cada ingrediente del menu se descuenta segun las _receta_ingredientes_.
3. **R3 — Validacion de stock**: Si algun ingrediente no tiene stock suficiente, la venta arrojara error 500 y se revertira (rollback transaccional).
4. **R4 — Contabilidad automatica**: Ventas y compras envian asientos debito y credito compensado hacia `contabilidad.libro_diario`.
5. **R5 — Real-time cocina**: Cada venta notifica a la cocina via ws instantaneamente.
6. **R6 — Multi-pago**: Una venta puede cerrarse mezclando pago movil, divisa u otros segun un array de `pagos`.
7. **R7 — Pedidos por restaurante**: Los token JWT garantizan que ninguna data se desborde al aislar por `restaurante_id`.
