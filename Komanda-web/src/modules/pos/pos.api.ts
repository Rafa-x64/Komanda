import { fetchWithAuth } from '../../core/api/auth.api'

export interface Pago {
  metodo_pago_id: number
  monto: number
  referencia?: string
}

export interface OrderItem {
  id?: number
  nombre: string
  cantidad: number
  precio_unitario: number
  subtotal: number
  notas?: string | null
}

export interface ReadyOrder {
  id: number
  codigo: string
  cliente: string | null
  estado: string
  estado_cuenta: string
  subtotal: string
  impuestos: string
  total: string
  fecha_hora: string
  mesa_numero: number | null
  mesa_nombre: string | null
  items: OrderItem[]
}

export async function fetchCategories() {
  const res = await fetchWithAuth('/pos/categories')
  return res.data
}

export async function fetchProducts() {
  const res = await fetchWithAuth('/pos/products')
  return res.data
}

export async function fetchTables() {
  const res = await fetchWithAuth('/pos/tables')
  return res.data
}

export async function fetchMetodosPago() {
  const res = await fetchWithAuth('/pos/payment-methods')
  return res.data
}

/** Cola del cajero: pedidos con cuenta abierta */
export async function fetchReadyOrders(): Promise<ReadyOrder[]> {
  const res = await fetchWithAuth('/pos/ready-orders')
  return res.data
}

/** Cobrar una orden existente */
export async function checkoutOrder(pedidoId: number, pagos: Pago[]) {
  const res = await fetchWithAuth(`/pos/orders/${pedidoId}/checkout`, {
    method: 'POST',
    body: JSON.stringify({ pagos }),
  })
  return res.data
}

/** Historial de ventas */
export async function fetchSales() {
  const res = await fetchWithAuth('/pos/sales')
  return res.data
}
