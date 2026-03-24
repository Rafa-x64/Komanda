const API_BASE = 'http://localhost:3000/api/v1/sales'

interface OrderItem {
  receta_id: number
  cantidad: number
  notas: string
}

interface OrderPayload {
  mesa_id: number
  items: OrderItem[]
}

async function handleResponse(res: Response) {
  const contentType = res.headers.get('content-type')
  if (!contentType || !contentType.includes('application/json')) {
    throw new Error('El backend no respondió con JSON. ¿Está corriendo el servidor?')
  }
  const json = await res.json()
  if (!res.ok) throw new Error(json.message || 'Error en la petición')
  return json.data
}

export async function fetchCategories() {
  const res = await fetch(`${API_BASE}/categories`)
  return handleResponse(res)
}

export async function fetchProducts() {
  const res = await fetch(`${API_BASE}/products`)
  return handleResponse(res)
}

export async function fetchTables() {
  const res = await fetch(`${API_BASE}/tables`)
  return handleResponse(res)
}

export async function sendOrder(payload: OrderPayload) {
  const res = await fetch(`${API_BASE}/orders`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  })
  return handleResponse(res)
}
