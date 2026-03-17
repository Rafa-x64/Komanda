export const sendOrder = async (orderPayload: any) => { 

    const URL = "/api/v1/sales/orders";

    try {
        const response = await fetch(URL, {
            method: "POST",
            headers: {
                "ContentType": "application/json",
                "Accept": "aplication/json"
            },
            body: JSON.stringify(orderPayload)
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.message || 'Error desconocido al enviar la orden')
        }

        return data;

    } catch (error: any) {
        console.error("Error al enviar la orden:", error.message);
        throw error;
    };
}