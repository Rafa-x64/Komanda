import { fetchWithAuth } from '../../core/api/auth.api'

export const tablesApi = {
    getTables: () => fetchWithAuth('/mesas'),
    getTableById: (id: number) => fetchWithAuth(`/mesas/${id}`),
    createTable: (data: any) => fetchWithAuth('/mesas', {
        method: 'POST',
        body: JSON.stringify(data)
    }),
    updateTable: (id: number, data: any) => fetchWithAuth(`/mesas/${id}`, {
        method: 'PUT',
        body: JSON.stringify(data)
    }),
    deleteTable: (id: number) => fetchWithAuth(`/mesas/${id}`, {
        method: 'DELETE'
    })
}
