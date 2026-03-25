import { WebSocketServer, WebSocket } from 'ws';

// Set global para mantener todos los clientes (pantallas) de cocina conectados
const clients = new Set<WebSocket>();

export function setupKitchenSocket(wss: WebSocketServer) {
    wss.on('connection', (ws: WebSocket) => {
        console.log('[Kitchen Socket] Nuevo cliente conectado');
        clients.add(ws);

        // Cuando un cliente envía un mensaje
        ws.on('message', (message: string) => {
            try {
                const data = JSON.parse(message);

                if (data.action === 'cambiar_estado') {
                    console.log(`[Kitchen Socket] Orden ${data.payload.id} cambió a estado: ${data.payload.estado}`);

                    // Reenviamos el evento de cambio a todos los demás clientes (broadcasting)
                    // para que todas las pantallas de cocina se sincronicen
                    broadcast({
                        action: 'actualizar_estado',
                        payload: {
                            id: data.payload.id,
                            estado: data.payload.estado
                        }
                    });
                }
            } catch (error) {
                console.error('[Kitchen Socket] Error parseando mensaje', error);
            }
        });

        ws.on('close', () => {
            console.log('[Kitchen Socket] Cliente desconectado');
            clients.delete(ws);
        });
    });
}

// Función disponible de forma global en el módulo para que, por ejemplo,
// el Order.Controller nos llame para avisar que entró un nuevo pedido desde las mesas
export function broadcastNewOrderToKitchen(pedido: any) {
    broadcast({
        action: 'nuevo_pedido',
        payload: pedido
    });
}

function broadcast(message: any) {
    const data = JSON.stringify(message);
    for (const client of clients) {
        if (client.readyState === WebSocket.OPEN) {
            client.send(data);
        }
    }
}
