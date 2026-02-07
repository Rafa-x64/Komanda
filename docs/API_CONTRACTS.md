# 📡 API Contracts & Real-Time Protocol

> "El contrato que firmas con el Frontend. Si lo rompes sin previo aviso, pagas las pizzas."

Este documento define la estructura de comunicación JSON para REST y WebSockets.

---

## 🌐 REST API (Standard Response)

Todas las respuestas deben seguir este formato `JSend` modificado.

### ✅ Éxito (200 OK, 201 Created)

```json
{
  "status": "success",
  "data": {
    "user": {
      "id": "uuid-v4",
      "name": "Juan Pérez",
      "role": "WAITER"
    }
  },
  "meta": {
    // Opcional, para paginación
    "page": 1,
    "total": 50
  }
}
```

### ❌ Error Controlado (400 Bad Request)

```json
{
  "status": "fail",
  "data": {
    "email": "Invalid email format", // Campo específico que falló
    "password": "Too short"
  }
}
```

### 💥 Error de Servidor (500 Internal Server Error)

```json
{
  "status": "error",
  "message": "Database Connection Failed",
  "code": "DB_CONN_ERR" // Código interno para debugging
}
```

---

## ⚡ Real-Time (WebSockets / Socket.io)

El Módulo de Cocina (KDS) depende 100% de esto.

### Eventos del Servidor -> Cliente (Frontend escucha)

| Evento          | Descripción                                      | Payload (Data)                                                                            |
| :-------------- | :----------------------------------------------- | :---------------------------------------------------------------------------------------- |
| `order:created` | Nueva comanda llega a cocina.                    | `{ id: "ord_123", items: [{ name: "Pizza", quantity: 1, notes: "Sin piña" }], table: 5 }` |
| `order:updated` | Cambio de estado (ej. de `PENDING` a `COOKING`). | `{ id: "ord_123", status: "COOKING", updated_at: "ISO_DATE" }`                            |
| `stock:alert`   | Inventario bajo mínimos.                         | `{ product_id: "prod_55", name: "Tomate", current_stock: 0.5, unit: "kg" }`               |

### Eventos del Cliente -> Servidor (Frontend emite)

| Evento            | Descripción                      | Payload                       |
| :---------------- | :------------------------------- | :---------------------------- |
| `kds:start_item`  | Chef empieza a cocinar un plato. | `{ order_item_id: "itm_99" }` |
| `kds:finish_item` | Chef termina un plato.           | `{ order_item_id: "itm_99" }` |
| `kds:bump_order`  | Chef termina toda la orden.      | `{ order_id: "ord_123" }`     |

---

## 🔍 Reglas de Versionado

1.  **URI Versioning:** `/api/v1/products`
2.  **Breaking Changes:** Si cambias la estructura de un JSON que rompe el frontend, debes crear `/api/v2/products` y marcar la v1 como `deprecated`.

---

> **Tip:** Usa Postman o Insomnia y exporta la colección en `docs/postman_collection.json` para que los demás puedan probar sin adivinar.
