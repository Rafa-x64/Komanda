import { fetchWithAuth } from '../../core/api/auth.api';

export const inventoryApi = {
    // INGREDIENTES
    getIngredients: () => fetchWithAuth('/inventory'),
    createIngredient: (data: any) => fetchWithAuth('/inventory', {
        method: 'POST',
        body: JSON.stringify(data)
    }),
    updateIngredient: (id: number, data: any) => fetchWithAuth(`/inventory/${id}`, {
        method: 'PUT',
        body: JSON.stringify(data)
    }),

    // MERMAS
    getMermas: () => fetchWithAuth('/inventory/mermas'),
    createMerma: (data: any) => fetchWithAuth('/inventory/mermas', {
        method: 'POST',
        body: JSON.stringify(data)
    })
};
