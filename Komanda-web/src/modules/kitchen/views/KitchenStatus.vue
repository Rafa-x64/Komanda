<template>
  <div class="kds-wrapper p-3">
    <div class="row mb-4 px-2">
      <div class="col-12">
        <div class="summary-card shadow-sm p-3">
          <div class="d-flex align-items-center gap-4 overflow-auto">
            <span class="fw-bold text-korange border-end pe-3">TOTAL A PREPARAR:</span>
            <div v-for="(cant, plato) in resumenProduccion" :key="plato" class="d-flex align-items-center">
              <span class="badge bg-korange text-white fs-6 me-2">{{ cant }}</span>
              <span class="text-uppercase small fw-bold text-secondary">{{ plato }}</span>
              <div class="vertical-divider mx-3"></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="row row-cols-1 row-cols-md-2 row-cols-xxl-3 g-3 m-0">
      <div v-for="pedido in pedidos" :key="pedido.id" class="col p-2">
        <div :class="['card ticket shadow-sm', { 'border-urgente': pedido.minutos >= 15 }]">
          
          <div class="card-header d-flex justify-content-between align-items-center p-3 border-0 bg-transparent">
            <div class="d-flex flex-column">
              <span class="badge bg-dark text-white mb-1 w-fit">MESA {{ pedido.mesa }}</span>
              <h4 class="fw-bold mb-0">Orden #{{ pedido.id }}</h4>
              <small class="text-korange fw-bold text-uppercase mt-1">
                <i class="bi bi-person-badge me-1"></i> Mesero: {{ pedido.mesero }}
              </small>
            </div>
            <div class="text-end">
              <span :class="['fs-2 fw-bold d-block lh-1', pedido.minutos >= 15 ? 'text-danger' : 'text-korange']">
                {{ pedido.minutos }}<small class="fs-6 text-secondary">m</small>
              </span>
              <small class="text-uppercase fw-bold text-secondary">Espera</small>
            </div>
          </div>

          <div class="card-body p-0">
            <ul class="list-group list-group-flush">
              <li v-for="(item, index) in pedido.items" :key="index" class="list-group-item border-color py-3 px-3 bg-transparent">
                <div class="d-flex align-items-start">
                  <span class="qty-badge me-3">{{ item.cantidad }}</span>
                  <div class="flex-grow-1">
                    <h4 class="fw-bold text-uppercase mb-1 item-name">{{ item.nombre }}</h4>
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
</template>

<script setup>
import { ref, computed } from 'vue';

const pedidos = ref([
  {
    id: 101,
    mesa: "05",
    mesero: "Carlos R.", // Nombre del mesero
    minutos: 8,
    items: [
      { cantidad: 2, nombre: "Hamb. Komanda", notas: "Sin cebolla" },
      { cantidad: 1, nombre: "Papas Fritas", notas: "Extra sal" }
    ]
  },
  {
    id: 102,
    mesa: "12",
    mesero: "Ana M.", // Nombre del mesero
    minutos: 18,
    items: [
      { cantidad: 1, nombre: "Pizza Margarita", notas: "Mucha salsa" },
      { cantidad: 1, nombre: "Ensalada César", notas: null }
    ]
  }
]);

const resumenProduccion = computed(() => {
  const totales = {};
  pedidos.value.forEach(p => {
    p.items.forEach(item => {
      totales[item.nombre] = (totales[item.nombre] || 0) + item.cantidad;
    });
  });
  return totales;
});

const marcarComoListo = (id) => {
  pedidos.value = pedidos.value.filter(p => p.id !== id);
};
</script>

<style scoped>
.kds-wrapper {
  background-color: var(--bg-surface);
  min-height: 100vh;
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
  color: var(--text-primary);
  border: 1px solid var(--border-color);
  border-radius: 15px;
  overflow: hidden;
  transition: all var(--transition-speed);
}

/* Solo color de borde para urgencia, sin animación de movimiento */
.border-urgente {
  border: 4px solid #dc3545 !important;
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
  background-color: var(--text-primary);
  color: var(--bg-body);
  padding: 5px 12px;
  border-radius: 8px;
  font-weight: bold;
  font-size: 1.4rem;
}

.border-color {
  border-color: var(--border-color) !important;
}

.w-fit { width: fit-content; }
</style>