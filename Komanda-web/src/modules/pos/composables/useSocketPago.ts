import { ref, onMounted, onUnmounted } from 'vue';

export function useSocketPago(onPagoCompletado: (pedidoId: number) => void) {
  const ws = ref<WebSocket | null>(null);
  const isConnected = ref(false);

  const connect = () => {
    ws.value = new WebSocket('ws://localhost:3000?type=pos');

    ws.value.onopen = () => {
      console.log('[POS Socket] Conectado para pagos');
      isConnected.value = true;
    };

    ws.value.onmessage = (event) => {
      try {
        const data = JSON.parse(event.data);
        if (data.action === 'pedido_listo_pago') {
          console.log('[POS Socket] Pedido listo para pago:', data.payload.pedidoId);
        }
      } catch (e) {
        console.error('Error parseando mensaje POS:', e);
      }
    };

    ws.value.onclose = () => {
      isConnected.value = false;
    };

    ws.value.onerror = (error) => {
      console.error('[POS Socket] Error:', error);
      ws.value?.close();
    };
  };

  onMounted(() => {
    connect();
  });

  onUnmounted(() => {
    if (ws.value) {
      ws.value.onclose = null;
      ws.value.close();
    }
  });

  return { isConnected };
}
