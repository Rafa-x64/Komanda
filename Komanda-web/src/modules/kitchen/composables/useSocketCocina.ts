import { ref, onMounted, onUnmounted } from 'vue';

export function useSocketCocina(onNuevoPedido: () => void, onActualizarEstado: (payload: any) => void) {
  const ws = ref<WebSocket | null>(null);
  const isConnected = ref(false);

  // Intentamos inferir la base URL de donde estemos, o forzamos localhost:3000 para el entorno de desarrollo actual
  const wsUrl = import.meta.env.VITE_WS_URL || 'ws://localhost:3000';

  const connect = () => {
    ws.value = new WebSocket(wsUrl);

    ws.value.onopen = () => {
      console.log('[Kitchen Socket] Conectado al servidor KDS');
      isConnected.value = true;
    };

    ws.value.onmessage = (event) => {
      try {
        const data = JSON.parse(event.data);
        if (data.action === 'nuevo_pedido') {
          onNuevoPedido();
        } else if (data.action === 'actualizar_estado') {
          onActualizarEstado(data.payload);
        }
      } catch (e) {
        console.error('Error parseando mensaje WS:', e);
      }
    };

    ws.value.onclose = () => {
      console.log('[Kitchen Socket] Desconectado, reintentando en 3s...');
      isConnected.value = false;
      setTimeout(connect, 3000);
    };

    ws.value.onerror = (error) => {
      console.error('[Kitchen Socket] Error:', error);
      ws.value?.close();
    };
  };

  onMounted(() => {
    connect();
  });

  onUnmounted(() => {
    if (ws.value) {
      // Evitar que el onclose intente reconectar
      ws.value.onclose = null;
      ws.value.close();
    }
  });

  return { isConnected };
}
