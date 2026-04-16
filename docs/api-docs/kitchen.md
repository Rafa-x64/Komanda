# Kitchen — Pantalla de Cocina (KDS)

> Modulo de visualizacion y control de pedidos en back-of-house (cocina). Combina HTTP para el estado inicial y WebSockets para notificaciones y actualizaciones en tiempo real.

**Base URL:** `http://localhost:3000/api/v1/kitchen`  
**WebSocket URL:** `ws://localhost:3000`  
**Auth:** Todas las rutas requieren token JWT. Debes tener rol `admin` o `cocina`.

---

## Indice

1. [GET / — Obtener pedidos activos](#get---obtener-pedidos-activos)
2. [PUT /:id/status — Actualizar estado del pedido](#put-idstatus--actualizar-estado-del-pedido)
3. [Integracion WebSocket](#integracion-websocket)

---

## `GET /` — Obtener pedidos activos

Retorna todos los pedidos que estan actualmente dirigidos a la cocina (estados `pendiente` y `preparando`). Se omiten los pedidos que ya estan en estado `listo`.

### URL

```
GET /api/v1/kitchen/
```

### Auth

Token JWT requerido. Rol: `admin` o `cocina`.

### Parametros

Ninguno. El `restaurantId` se extrae del token.

### Respuesta exitosa — 200 OK

```json
{
  "status": "success",
  "data": [
    {
      "id": 42,
      "codigo": "PED-20260414-0001",
      "mesa_id": 1,
      "mesa": "Mesa 1",
      "mesero": "Carlos Admin",
      "cliente": "Pedro Lopez",
      "estado": "pendiente",
      "fecha_hora": "2026-04-14T21:00:00.000Z",
      "items": [
        {
          "receta_id": 3,
          "nombre": "Pasta Carbonara",
          "cantidad": 2,
          "notas": "Sin cebolla extra"
        }
      ]
    }
  ]
}
```

### Detalles de la respuesta

Cada elemento de la lista contiene la informacion consolidada (JOIN) para poder renderizar una _ticket card_.

| Campo | Descripcion |
|-------|-------------|
| `mesa` | Nombre de la mesa o "Para llevar" si no hay mesa asignada. |
| `items` | Array JSON generado desde PostgreSQL con los detalles que la cocina debe preparar. |
| `items[].notas` | Instrucciones especiales ingresadas por el cajero/mesero. |

### Ejemplo con curl

```bash
curl http://localhost:3000/api/v1/kitchen/ \
  -H "Authorization: Bearer <TOKEN>"
```

---

## `PUT /:id/status` — Actualizar estado del pedido

Cambia el estado de preparacion de un pedido existente.

Este endpoint hace un update en PostgreSQL y luego emite un evento WebSocket `actualizar_estado` para que el resto de las pantallas KDS actualicen el ticket automaticamente.

### URL

```
PUT /api/v1/kitchen/:id/status
```

### Parámetros de ruta

| Parámetro | Tipo | Descripcion |
|-----------|------|-------------|
| `id` | `number` | ID unico del pedido |

### Auth

Token JWT requerido. Rol: `admin` o `cocina`.

### Headers requeridos

```http
Content-Type: application/json
Authorization: Bearer <TOKEN>
```

### Request Body

```json
{
  "estado": "preparando"
}
```

### Validacion de estado

El campo `estado` debe ser estrictamente uno de los siguientes:
* `pendiente` (recien emitido por el POS)
* `preparando` (la cocina comenzo a hacerlo)
* `listo` (terminado, el mesero/cajero puede ir a buscarlo)

### Respuesta exitosa — 200 OK

```json
{
  "status": "success",
  "message": "Estado de orden actualizado a preparando"
}
```

### Errores posibles

| HTTP | message | Causa |
|------|---------|-------|
| `400` | `Validacion fallida` | El estado no es valido o el body esta vacio |
| `400` | `ID de orden invalido` | El parametro de ID no es un numero |
| `400` | `Pedido no encontrado o no pertenece al restaurante` | — |

### Ejemplo con curl

```bash
curl -X PUT http://localhost:3000/api/v1/kitchen/42/status \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{ "estado": "listo" }'
```

---

## Integracion WebSocket

Para brindar la mejor experiencia en la cocina sin referescar la pantalla manualmente, se implementa conexion via WebSockets. 

### Conexion

Debes utilizar un cliente WebSockets estandar apuntando a la direccion base:

```javascript
const ws = new WebSocket('ws://localhost:3000');
```

No requiere token actualmente via WS connection uri, pero se asume que esta implementado en la pagina protegida (Vue views/KitchenScreen.vue).

### Eventos que se Reciben

El backend emitira mensajes JSON que el cliente debe escuchar mediante el evento `onmessage`:

1. **Nuevo Pedido (`nuevo_pedido`)**
   
   Generado automaticamente cuando un pedido se completa por caja (`POST /api/v1/pos/sales`).
   
   ```json
   {
     "action": "nuevo_pedido",
     "payload": {
       "id": 43,
       "codigo": "PED-20260415-0002",
       "restaurante_id": 1
     }
   }
   ```
   *Accion recomendada:* Cuando se recibe `nuevo_pedido`, el frontend debe recargar las ordenes haciendo una peticion `GET /api/v1/kitchen` o solicitar especificamente el nuevo pedido.

2. **Actualizar Estado (`actualizar_estado`)**
   
   Generado cuando alguien llama al endpoint `PUT /:id/status` o una KDS manda un mensaje de sincronizacion.
   
   ```json
   {
     "action": "actualizar_estado",
     "payload": {
       "id": 42,
       "estado": "listo"
     }
   }
   ```
   *Accion recomendada:* Mover el ticket del pedido visualmente en las columnas Kanban de la cocina (Pendiente -> En progreso -> Terminado).

### Eventos que el Cliente puede Mandar

Para favorecer la inmediatez sin carga innecesaria de red, un frontend KDS puede emitir eventos via websockets ademas de la API REST para ayudar a otras instancias del KDS a cambiar de color, etc.

1. **Avisar Cambio de Estado (`cambiar_estado`)**

   ```json
   {
     "action": "cambiar_estado",
     "payload": {
       "id": 43,
       "estado": "preparando"
     }
   }
   ```
   Al enviar esto, el servidor retransmite `actualizar_estado` a **todos los demás sockets conectados** para que nadie repita el trabajo. NOTA: el websocket server de la API no persiste en Base de datos el status enviado por mensaje directo para proteger integridad de BD; debes usar la API `PUT` ademas, o bien la API se va a encargar de mandar el broadcast sola. La logica de Komanda emite el broadcast desde la API.

---

## Resumen de endpoints

| Metodo | Ruta | Descripcion | Auth |
|--------|------|-------------|------|
| `GET` | `/kitchen/` | Listar todos los pedidos para KDS | JWT (admin/cocina) |
| `PUT` | `/kitchen/:id/status` | Cambiar de estado la preparacion | JWT (admin/cocina) |
| `WS` | `ws://localhost:3000` | Sincronizacion de Kitchen en Tiempo Real | — |

---

> **Siguiente modulo:** [Employees — Gestion de Empleados](./employees.md)
