# 📖 Domain Language (Ubiquitous Language)

> "En este restaurante todos hablamos el mismo idioma. Si el chef dice 'Comanda', la base de datos dice 'Comanda'."

Este documento define el **Lenguaje Ubicuo**. Úsalo para nombrar variables, tablas, clases y rutas.

---

## 👥 Actores y Roles

| Término           | Definición Técnica                          | Notas                                              |
| :---------------- | :------------------------------------------ | :------------------------------------------------- |
| **Comensal**      | La persona que se sienta a comer.           | No tiene login. Es una entidad pasiva en la Venta. |
| **Cliente**       | Persona registrada en el sistema (Loyalty). | Tiene ID, historial y puntos.                      |
| **Mesero/Server** | Usuario con rol `WAITER`.                   | Puede abrir mesas y tomar pedidos.                 |
| **Cocinero/Chef** | Usuario con rol `KITCHEN`.                  | Solo ve la pantalla KDS (Kitchen Display System).  |
| **Admin**         | Usuario con rol `MANAGER`.                  | Ve reportes, cierra caja y gestiona usuarios.      |

---

## 🍽️ La Orden (The Core)

### Estados de un Pedido (`OrderItemStatus`)

El ciclo de vida de un plato desde que se pide hasta que se entrega.

1.  `PENDING`: El mesero lo anotó, pero no ha dado "Enviar a Cocina". (Borrador).
2.  `SENT`: Enviado a cocina. Aparece en el KDS. El cliente ya no puede cancelar sin permiso.
3.  `COOKING`: El chef le dio "Start" en el KDS. Se está preparando.
4.  `READY`: El plato está en la ventana de pase. El mesero recibe alerta.
5.  `DELIVERED`: El plato está en la mesa.
6.  `VOID`: Cancelado por error o devolución. (Requiere motivo).

### Estados de una Mesa/Cuenta (`OrderTableStatus`)

1.  `OPEN`: Mesa ocupada, pidiendo cosas.
2.  `BILL_REQUESTED`: Pidieron la cuenta. Se imprime la pre-cuenta.
3.  `PAID`: Pagada totalmente.
4.  `CLOSED`: Mesa libre para nuevos clientes.

---

## 📦 Inventario

| Término                        | Definición                     | Ejemplo                             |
| :----------------------------- | :----------------------------- | :---------------------------------- |
| **Ingrediente / Raw Material** | Lo que compras.                | `Harina (Saco 50kg)`                |
| **Insumo / Supply**            | Lo que usas en una receta.     | `Harina (Gramos)`                   |
| **Producto / MenuItem**        | Lo que vendes.                 | `Pizza Margarita`                   |
| **Receta / Recipe**            | Fórmula de conversión.         | `1 Pizza = 200g Harina + 50g Salsa` |
| **Merma / Waste**              | Pérdida de material reportada. | "Se cayó el tomate al piso".        |

---

## 💰 Finanzas

- **Corte de Caja (Z-Cut):** Cierre fiscal del día. Resetea los contadores diarios.
- **Fondo de Caja:** Dinero en efectivo con el que inicia el turno.
- **Arqueo:** Conteo físico del dinero vs lo que dice el sistema.

---

> **Regla de Oro:** Si en el código encuentras una variable llamada `user_type` en lugar de `role`, o `food_status` en lugar de `order_item_status`, tienes permiso de rechazar el PR.
