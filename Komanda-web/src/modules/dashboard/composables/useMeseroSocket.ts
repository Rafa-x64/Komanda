import { ref, onMounted, onUnmounted } from 'vue';

// Estado global de las mesas para el Mesero Dashboard. 
// En producción, esto se llenará con un fetch a la API.
const mesas = ref([
    { id: 1, numero: "MESA 1", capacidad: 4, estado: 'libre', pedidoListo: false },
    { id: 2, numero: "MESA 2", capacidad: 2, estado: 'ocupada', pedidoListo: true },
    { id: 3, numero: "MESA 3", capacidad: 6, estado: 'reservada', pedidoListo: false },
    { id: 4, numero: "MESA 4", capacidad: 4, estado: 'ocupada', pedidoListo: false },
    { id: 5, numero: "MESA 5", capacidad: 4, estado: 'libre', pedidoListo: false },
    { id: 6, numero: "MESA 6", capacidad: 2, estado: 'libre', pedidoListo: false },
    { id: 7, numero: "MESA 7", capacidad: 8, estado: 'reservada', pedidoListo: false },
    { id: 8, numero: "MESA 8", capacidad: 4, estado: 'ocupada', pedidoListo: true },
]);

// Variables para estadísticas
const entregarPedidosCount = ref(2);

let socket: any = null;

export function useMeseroSocket() {

    const conectarSocket = () => {
        // En desarrollo local usamos ws://localhost:3000
        socket = new WebSocket('ws://localhost:3000');

        socket.onopen = () => {
            console.log('✅ Mesero conectado a WebSockets');
        };

        socket.onmessage = (event: MessageEvent) => {
            const data = JSON.parse(event.data);

            // Cuando un pedido pasa a estado "listo" desde la cocina
            if (data.action === 'actualizar_estado' && data.payload.estado === 'listo') {
                // Identificamos de qué mesa es el ticket (en la app real vendrá en data.payload.mesa_id)
                // Para el ejemplo interactivo haremos que la Mesa 1 alerte si el ticket 101 está listo
                if (data.payload.id === 101) {
                    const mesa = mesas.value.find(m => m.numero === "MESA 1");
                    if (mesa && !mesa.pedidoListo) {
                        mesa.pedidoListo = true;
                        entregarPedidosCount.value++;
                    }
                }
            }
        };

        socket.onclose = () => {
            console.log('❌ Mesero desconectado. Reconectando...');
            setTimeout(conectarSocket, 3000);
        };
    };

    onMounted(() => {
        if (!socket) {
            conectarSocket();
        }
    });

    onUnmounted(() => {
        // Opcional: desconectar o mantener vivo si navegamos a otra vista
    });

    return {
        mesas,
        entregarPedidosCount
    };
}
