const API_BASE = 'http://localhost:3000/api/v1'

interface OrderItem {
  receta_id: number
  cantidad: number
  notas: string
}

interface OrderPayload {
  mesa_id: number
  items: OrderItem[]
}

export async function sendOrder(payload: OrderPayload) {
  const res = await fetch(`${API_BASE}/sales/orders`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  })
  
  // Verificamos si la respuesta es JSON antes de parsearla
  const contentType = res.headers.get('content-type')
  if (!contentType || !contentType.includes('application/json')) {
    throw new Error('El backend no respondió con JSON. ¿Está corriendo el servidor y existe la ruta /api/v1/sales/orders?')
  }

  const json = await res.json()
  if (!res.ok) throw new Error(json.message || 'Error al enviar la orden')
  return json
}
