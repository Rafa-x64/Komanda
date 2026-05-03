import { fetchWithAuth } from '../../core/api/auth.api'

export interface AdminStats {
  ventas: {
    total_hoy: number
    total_ayer: number
    pedidos_hoy: number
    variacion_porcentaje: string | null
  }
  top_productos: { nombre: string; cantidad: number }[]
  stock_critico: number
  margen_utilidad: number
  mermas_recientes: {
    ingrediente: string
    cantidad: string
    razon: string
    reportado_por: string
    fecha: string
  }[]
  ventas_por_categoria: { nombre: string; total: number; porcentaje: number }[]
  ingresos_egresos_semana: { dia: string; ingresos: number; egresos: number }[]
}

export interface KitchenOrder {
  id: number
  codigo: string
  estado: 'pendiente' | 'preparando' | 'listo'
  fecha_hora: string
  mesa_numero: number | null
  mesa_nombre: string | null
  items: { nombre: string; cantidad: number; notas: string | null }[]
}

export interface WaiterTable {
  id: number
  numero: number
  nombre: string | null
  capacidad: number
  estado: 'libre' | 'ocupada' | 'reservada'
  pedido_listo: boolean
}

export interface WaiterStats {
  pedidos_activos: number
  listos_entregar: number
  ventas_turno: number
  mesas_libres: number
}

export async function fetchAdminStats(): Promise<AdminStats> {
  const res = await fetchWithAuth('/dashboard/admin/stats')
  return res.data
}

export async function fetchKitchenOrders(): Promise<KitchenOrder[]> {
  const res = await fetchWithAuth('/dashboard/kitchen/orders')
  return res.data
}

export async function fetchWaiterTables(): Promise<WaiterTable[]> {
  const res = await fetchWithAuth('/dashboard/waiter/tables')
  return res.data
}

export async function fetchWaiterStats(): Promise<WaiterStats> {
  const res = await fetchWithAuth('/dashboard/waiter/stats')
  return res.data
}
