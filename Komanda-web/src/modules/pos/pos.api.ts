import { fetchWithAuth } from '../../core/api/auth.api'

export interface Pago {
  metodo_pago_id: number
  monto: number
  referencia?: string
}

export interface OrderItem {
  receta_id: number
  cantidad: number
  notas: string
}

export interface OrderPayload {
  mesa_id?: number | null
  cliente?: string | null
  items: OrderItem[]
  pagos?: Pago[]
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

export async function sendOrder(payload: OrderPayload) {
  const res = await fetchWithAuth('/pos/sales', {
    method: 'POST',
    body: JSON.stringify(payload),
  })
  return res.data
}

export async function fetchSales() {
  const res = await fetchWithAuth('/pos/sales')
  return res.data
}
