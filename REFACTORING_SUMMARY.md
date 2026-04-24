# POS Refactoring Summary - Restaurant Flow Implementation

## Overview
Implemented proper restaurant workflow following DDD principles: 
**Cashier (POS) → Kitchen → Ready → Payment → Complete**

## Backend Changes (Komanda-api)

### 1. Enhanced Domain Model (`pos/domain/pedido.entity.ts`)
- Added `estado` values: `pagado`, `completado`
- Added `estado_cuenta` values: `pagada`, `cerrada`
- Added `total_pagado` field (decimal)
- Added `pagado_completo` boolean field

### 2. Enhanced POS Service (`pos/pos.service.ts`)
Added new business methods:
- `getPedidosParaPago()` - Fetch orders ready for payment (estado='listo' or 'pagado', not fully paid)
- `procesarPago(pedidoId, restaurantId, monto)` - Process payment with validation
- `completarPedido(pedidoId, restaurantId)` - Mark as completed after payment
- `notifyPForPayment(pedidoId, restaurantId)` - Update order and trigger POS notification

### 3. Enhanced Kitchen Service (`kitchen/kitchen.service.ts`)
Added `notifyPForPayment()` method to update order state and trigger POS notification

### 4. Enhanced Kitchen Socket (`kitchen/kitchen.socket.ts`)
- Separated clients: `kitchenClients` vs `posClients`
- Added `notifyPForPayment()` to broadcast to POS clients
- Updated `broadcast()` to support target parameter ('kitchen' or 'pos')
- Added `broadcastNewOrderToKitchen()` unchanged

### 5. Updated Routes (`pos/pos.routes.ts`)
Added new endpoints:
- `GET /orders/pending-payment` - Get orders for payment
- `PATCH /orders/:id/pay` - Process payment
- `PATCH /orders/:id/complete` - Complete order

## Frontend Changes (Komanda-web)

### 1. Enhanced POS View (`pos/views/POSView.vue`)
- Added payment completion UI section
- Added `useKitchenSocket` for order notifications
- Modified `handleConfirm()` to notify kitchen and show order ID
- Added `completarPago()` method for processing payments
- Added `completarPedidoFinal()` for order completion
- Added computed `pedidoPagadoCompleto`

### 2. Enhanced Kitchen Socket Consumer (`kitchen/composables/useSocketCocina.ts`)
- Added `useSocketPago` import for POS notifications
- Updated `onmessage` handler for `pedido_listo_pago` action
- Added POS socket connection in `connectPOS()`

### 3. New POS Socket Composable (`pos/composables/useSocketPago.ts`)
Created new file for POS websocket connection:
- Connects to `?type=pos` endpoint
- Handles `pedido_listo_pago` actions
- Manages connection lifecycle

### 4. Enhanced POS API (`pos/pos.api.ts`)
Added new functions:
- `getPedidosParaPago()` - Fetch pending payment orders
- `procesarPago(pedidoId, data)` - Process payment via API
- `completarPedido(pedidoId)` - Complete order via API

### 5. Updated Cart Composable (`pos/composables/useCart.ts`)
No changes needed - existing functionality works correctly

## Flow Explanation

1. **Cashier creates order**: POST to `/pos/sales` → order created with `estado='pendiente'`
2. **Order to kitchen**: WebSocket `broadcastNewOrderToKitchen()` → kitchen receives and processes
3. **Kitchen marks ready**: PATCH `/kitchen/orders/:id/status` → `estado='listo'`
4. **Kitchen notifies POS**: `notifyPForPayment()` → WebSocket `pedido_listo_pago` → POS shows payment UI
5. **Customer pays**: Frontend processes payment via `/pos/orders/:id/pay`
6. **Order marked paid**: Backend updates `estado='pagado'`, `pagado_completo=true`
7. **Order completed**: PATCH `/orders/:id/complete` → `estado='completado'`

## Validation & Error Handling
- Payment amount validation (must be > 0)
- Order state validation (can't complete unpaid orders)
- Duplicate payment prevention
- WebSocket reconnection handling
- Graceful error messages via toast notifications
