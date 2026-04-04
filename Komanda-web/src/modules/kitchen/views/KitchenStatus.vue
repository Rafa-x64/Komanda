<template>
  <div class="d-flex w-100">
    <Sidebar role="cocina" userName="Chef" />
    <div class="kds-wrapper p-3 main-content">
      <div class="row mb-4 px-2">
        <div class="col-12">
          <div class="summary-card shadow-sm p-3">
            <div class="d-flex align-items-center gap-4 overflow-auto">
              <span class="fw-bold text-korange border-end pe-3">TOTAL A PREPARAR:</span>
              <div v-for="(cant, plato) in resumenProduccion" :key="plato" class="d-flex align-items-center">
                <span class="badge bg-korange text-white fs-6 me-2">{{ cant }}</span>
                <span class="text-uppercase small fw-bold text-secondary-custom">{{ plato }}</span>
                <div class="vertical-divider mx-3"></div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="row row-cols-1 row-cols-md-2 row-cols-xxl-3 g-3 m-0">
        <div v-for="pedido in pedidos" :key="pedido.id" class="col p-2">
          <div :class="['card ticket shadow-sm', { 'border border-4 border-danger': pedido.minutos >= 15 }]">

            <div class="card-header d-flex justify-content-between align-items-center p-3 border-0 bg-transparent">
              <div class="d-flex flex-column">
                <span class="badge bg-dark text-white mb-1 w-fit">MESA {{ pedido.mesa }}</span>
                <h4 class="fw-bold mb-0 text-primary-custom">Orden #{{ pedido.id }}</h4>
                <small class="text-korange fw-bold text-uppercase mt-1">
                  <i class="bi bi-person-badge me-1"></i> Mesero: {{ pedido.mesero }}
                </small>
              </div>
              <div class="text-end">
                <span :class="['fs-2 fw-bold d-block lh-1', pedido.minutos >= 15 ? 'text-danger' : 'text-korange']">
                  {{ pedido.minutos }}<small class="fs-6 text-secondary-custom">m</small>
                </span>
                <small class="text-uppercase fw-bold text-secondary-custom">Espera</small>
              </div>
            </div>

            <div class="card-body p-0">
              <ul class="list-group list-group-flush">
                <li v-for="(item, index) in pedido.items" :key="index"
                  class="list-group-item border-color py-3 px-3 bg-transparent">
                  <div class="d-flex align-items-start">
                    <span class="qty-badge me-3">{{ item.cantidad }}</span>
                    <div class="flex-grow-1">
                      <h4 class="fw-bold text-uppercase mb-1 item-name text-primary-custom">{{ item.nombre }}</h4>
                      <div v-if="item.notas" class="nota-alerta">
                        <i class="bi bi-exclamation-triangle-fill me-1"></i>
                        <strong>{{ item.notas.toUpperCase() }}</strong>
                      </div>
                    </div>
                  </div>
                </li>
              </ul>
            </div>

            <div class="card-footer border-0 p-0">
              <button @click="marcarComoListo(pedido.id)" class="btn btn-korange w-100 py-4 rounded-0 fw-bold fs-4">
                MARCAR COMO LISTO
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import Sidebar from '../../../components/Sidebar.vue';
import { useSocketCocina } from '../composables/useSocketCocina';

const pedidos = ref([]);
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000/api/v1';

const getMinutosTranscurridos = (fechaIso) => {
  if (!fechaIso) return 0;
  const fecha = new Date(fechaIso);
  const ahora = new Date();
  const diffMs = ahora - fecha;
  return Math.floor(diffMs / 60000);
};

const fetchPedidos = async () => {
  try {
    const token = localStorage.getItem('token');
    if (!token) return;

    const response = await fetch(`${API_URL}/kitchen`, {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });

    if (response.ok) {
      const resp = await response.json();
      pedidos.value = resp.data.map(p => ({
        ...p,
        minutos: getMinutosTranscurridos(p.fecha_hora)
      }));
    }
  } catch (error) {
    console.error('Error fetching kitchen orders:', error);
  }
};

const { isConnected } = useSocketCocina(
  () => fetchPedidos(), 
  (payload) => fetchPedidos()
);

onMounted(() => {
  fetchPedidos();
  // Refrescar los minutos cada minuto
  setInterval(() => {
    pedidos.value = pedidos.value.map(p => ({ ...p, minutos: getMinutosTranscurridos(p.fecha_hora) }));
  }, 60000);
});

const resumenProduccion = computed(() => {
  const totales = {};
  pedidos.value.forEach(p => {
    if (p.items) {
      p.items.forEach(item => {
        totales[item.nombre] = (totales[item.nombre] || 0) + item.cantidad;
      });
    }
  });
  return totales;
});

const marcarComoListo = async (id) => {
  try {
    const token = localStorage.getItem('token');
    const response = await fetch(`${API_URL}/kitchen/${id}/status`, {
      method: 'PUT',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ estado: 'listo' })
    });
    
    if (response.ok) {
      pedidos.value = pedidos.value.filter(p => p.id !== id);
    } else {
      console.error('Error updating order status', await response.text());
    }
  } catch (error) {
    console.error('Error in request:', error);
  }
};
</script>

<style scoped>
.kds-wrapper {
  background-color: var(--bg-surface);
  min-height: 100vh;
  width: 100%;
}

@media (min-width: 768px) {
  .main-content {
    margin-left: 260px;
    width: calc(100% - 260px);
  }
}

.summary-card {
  background-color: var(--bg-body);
  border: 1px solid var(--border-color);
  border-radius: 12px;
}

.vertical-divider {
  height: 20px;
  width: 1px;
  background-color: var(--border-color);
}

.ticket {
  background-color: var(--bg-body);
  color: var(--text-main);
  border: 1px solid var(--border-color);
  border-radius: 15px;
  overflow: hidden;
  transition: all var(--transition-speed);
}


.nota-alerta {
  background-color: #fff3cd;
  color: #856404;
  padding: 4px 8px;
  border-radius: 4px;
  display: inline-block;
  font-size: 0.95rem;
}

.qty-badge {
  background-color: var(--text-main);
  color: var(--bg-body);
  padding: 5px 12px;
  border-radius: 8px;
  font-weight: bold;
  font-size: 1.4rem;
}

.border-color {
  border-color: var(--border-color) !important;
}

.text-secondary-custom {
  color: var(--text-muted) !important;
}

.w-fit {
  width: fit-content;
}
</style>