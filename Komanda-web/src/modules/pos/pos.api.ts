import { fetchWithAuth } from '../../core/api/auth.api'

interface OrderItem {
  receta_id: number
  cantidad: number
  notas: string
}

interface OrderPayload {
  mesa_id: number
  items: OrderItem[]
}

export async function fetchCategories() {
  const res = await fetchWithAuth('/sales/categories')
  return res.data
}

export async function fetchProducts() {
  const res = await fetchWithAuth('/sales/products')
  return res.data
}

export async function fetchTables() {
  const res = await fetchWithAuth('/sales/tables')
  return res.data
}

export async function sendOrder(payload: OrderPayload) {
  const res = await fetchWithAuth('/sales/orders', {
    method: 'POST',
    body: JSON.stringify(payload),
  })
  return res.data
}
