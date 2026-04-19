import { fetchWithAuth } from '../../core/api/auth.api'

export const operationsApi = {
    // PROVEEDORES
    getProveedores: () => fetchWithAuth('/operations/proveedores'),
    createProveedor: (data: any) => fetchWithAuth('/operations/proveedores', {
        method: 'POST',
        body: JSON.stringify(data)
    }),
    updateProveedor: (id: number, data: any) => fetchWithAuth(`/operations/proveedores/${id}`, {
        method: 'PUT',
        body: JSON.stringify(data)
    }),

    // COMPRAS
    getCompras: () => fetchWithAuth('/operations/compras'),
    getUnidadesCompra: () => fetchWithAuth('/operations/unidades-compra'),
    createCompra: (data: any) => fetchWithAuth('/operations/compras', {
        method: 'POST',
        body: JSON.stringify(data)
    }),

    // GASTOS OPERATIVOS
    getGastos: () => fetchWithAuth('/operations/gastos'),
    createGasto: (data: any) => fetchWithAuth('/operations/gastos', {
        method: 'POST',
        body: JSON.stringify(data)
    }),

    // SEED
    seedOperations: () => fetchWithAuth('/operations/seed', {
        method: 'POST'
    })
}
