import { ref, onMounted, onUnmounted } from 'vue';

// Variables globales para compartir el estado entre Sidebar y KitchenStatus
const pedidos = ref([
    {
        id: 101,
        mesa: "05",
        mesero: "Carlos R.",
        minutos: 8,
        estado: "recibido",
        items: [
            { cantidad: 2, nombre: "Hamb. Komanda", notas: "Sin cebolla" },
            { cantidad: 1, nombre: "Papas Fritas", notas: "Extra sal" }
        ]
    },
    {
        id: 102,
        mesa: "12",
        mesero: "Ana M.",
        minutos: 18,
        estado: "preparando",
        items: [
            { cantidad: 1, nombre: "Pizza Margarita", notas: "Mucha salsa" },
            { cantidad: 1, nombre: "Ensalada César", notas: null }
        ]
    }
]);

let socket: any = null;

export function useKitchenSocket() {

    const cambiarEstado = (pedidoId: number, nuevoEstado: string) => {
        if (socket && socket.readyState === WebSocket.OPEN) {
            socket.send(JSON.stringify({
                action: 'cambiar_estado',
                payload: { id: pedidoId, estado: nuevoEstado }
            }));
        }

        const pedido = pedidos.value.find(p => p.id === pedidoId);
        if (pedido) {
            pedido.estado = nuevoEstado;

            if (nuevoEstado === 'listo') {
                setTimeout(() => {
                    pedidos.value = pedidos.value.filter(p => p.id !== pedidoId);
                }, 3000);
            }
        }
    };

    const conectarSocket = () => {
        socket = new WebSocket('ws://localhost:5173');
        socket.onopen = () => {
            console.log('Conectado a la cocina');
        };

        socket.onmessage = (event: MessageEvent) => {
            const data = JSON.parse(event.data);

            switch (data.action) {
                case 'pedidos_iniciales':
                    pedidos.value = data.payload;
                    break;
                case 'nuevo_pedido':
                    pedidos.value.push({ ...data.payload, estado: 'recibido' });
                    break;
                case 'actualizar_estado':
                    const p = pedidos.value.find(x => x.id === data.payload.id);
                    if (p) p.estado = data.payload.estado;
                    break;
            }
        };

        socket.onclose = () => {
            console.log('Desconectado. Intentando reconectar en 3s...');
            setTimeout(conectarSocket, 3000);
        };
    };

    onMounted(() => {
        conectarSocket();
    });

    onUnmounted(() => {
        if (socket) {
            socket.close();
        }
    });

    return {
        pedidos,
        cambiarEstado
    };
}
