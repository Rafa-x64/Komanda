import { fetchWithAuth } from '../../core/api/auth.api'

export interface ActiveOrder {
  id: number
  codigo: string
  cliente: string | null
  estado: string
  estado_cuenta: string
  subtotal: string
  total: string
  fecha_hora: string
  mesa_numero: number | null
  mesa_nombre: string | null
  mesa_estado: string | null
  items: {
    id: number
    receta_id: number
    nombre: string
    cantidad: number
    precio_unitario: string
    subtotal: string
    notas: string | null
  }[]
}

export const waiterApi = {
  getActiveOrders: async (): Promise<ActiveOrder[]> => {
    const res = await fetchWithAuth('/pos/orders')
    return res.data || []
  },

  updateOrderStatus: async (id: number, estado: string) => {
    const res = await fetchWithAuth(`/pos/orders/${id}/status`, {
      method: 'PATCH',
      body: JSON.stringify({ estado })
    })
    return res.data
  },

  getTables: async () => {
    const res = await fetchWithAuth('/pos/tables')
    return res.data || []
  },

  getProducts: async () => {
    const res = await fetchWithAuth('/pos/products')
    return res.data || []
  },

  getCategories: async () => {
    const res = await fetchWithAuth('/pos/categories')
    return res.data || []
  },

  sendOrder: async (payload: {
    mesa_id?: number | null
    cliente?: string | null
    items: { receta_id: number; cantidad: number; notas: string }[]
  }) => {
    const res = await fetchWithAuth('/pos/sales', {
      method: 'POST',
      body: JSON.stringify(payload)
    })
    return res.data
  }
}
