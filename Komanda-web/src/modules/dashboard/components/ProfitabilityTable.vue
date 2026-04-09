<template>
  <div class="profit-table-wrapper">
    <div class="profit-table-header">
      <div>
        <h6 class="profit-table-title">Ranking de Rentabilidad por Plato</h6>
        <p class="profit-table-subtitle">Margen real: Precio venta − Costo ponderado de ingredientes</p>
      </div>
      <div class="btn-group" role="group">
        <button
          v-for="tab in tabs" :key="tab.key"
          class="btn btn-sm"
          :class="activeTab === tab.key ? 'btn-korange' : 'btn-outline-secondary'"
          @click="activeTab = tab.key">
          {{ tab.label }}
        </button>
      </div>
    </div>

    <div class="table-responsive">
      <table class="table table-custom table-hover-custom table-hover-orange align-middle mb-0">
        <thead>
          <tr>
            <th>#</th>
            <th>Plato</th>
            <th>Precio</th>
            <th>Costo CPP</th>
            <th>Margen $</th>
            <th>Margen %</th>
            <th>Uds. Vendidas</th>
            <th>Ganancia Total</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, idx) in displayedItems" :key="item.name"
              class="profit-row">
            <td>
              <span class="rank-badge" :class="rankClass(idx, activeTab)">
                {{ idx + 1 }}
              </span>
            </td>
            <td>
              <div class="d-flex align-items-center gap-2">
                <span class="item-emoji">{{ item.emoji }}</span>
                <span class="fw-semibold">{{ item.name }}</span>
              </div>
            </td>
            <td>${{ item.price.toFixed(2) }}</td>
            <td>${{ item.cost.toFixed(2) }}</td>
            <td>
              <span :class="item.margin >= 0 ? 'text-success fw-bold' : 'text-danger fw-bold'">
                {{ item.margin >= 0 ? '+' : '' }}${{ item.margin.toFixed(2) }}
              </span>
            </td>
            <td>
              <div class="margin-bar-wrapper">
                <div class="margin-bar" :class="item.marginPct >= 0 ? 'margin-bar--profit' : 'margin-bar--loss'"
                  :style="{ width: Math.min(Math.abs(item.marginPct), 100) + '%' }">
                </div>
                <span class="margin-pct-label">{{ item.marginPct.toFixed(1) }}%</span>
              </div>
            </td>
            <td>{{ item.units }}</td>
            <td>
              <span :class="item.totalGain >= 0 ? 'text-success fw-bold' : 'text-danger fw-bold'">
                {{ item.totalGain >= 0 ? '+' : '' }}${{ item.totalGain.toFixed(2) }}
              </span>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

interface DishProfit {
  name: string
  emoji: string
  price: number
  cost: number
  units: number
  margin: number
  marginPct: number
  totalGain: number
}

const tabs: { key: 'top' | 'bottom', label: string }[] = [
  { key: 'top', label: '🏆 Top 5' },
  { key: 'bottom', label: '📉 Pérdidas' }
]

const activeTab = ref<'top' | 'bottom'>('top')

// Datos mock simulando el JOIN de sale_details + ingredients (Costo Promedio Ponderado)
const allItems: DishProfit[] = [
  { name: 'Lomito a la Parrilla', emoji: '🥩', price: 28.00, cost: 9.80, units: 87, margin: 18.20, marginPct: 65.0, totalGain: 1583.40 },
  { name: 'Pasta Carbonara',      emoji: '🍝', price: 18.50, cost: 5.20, units: 112, margin: 13.30, marginPct: 71.9, totalGain: 1489.60 },
  { name: 'Ceviche Clásico',      emoji: '🐟', price: 22.00, cost: 8.40, units: 64,  margin: 13.60, marginPct: 61.8, totalGain: 870.40 },
  { name: 'Ensalada César',       emoji: '🥗', price: 14.00, cost: 4.10, units: 93,  margin: 9.90,  marginPct: 70.7, totalGain: 920.70 },
  { name: 'Tacos al Pastor',      emoji: '🌮', price: 16.00, cost: 5.80, units: 120, margin: 10.20, marginPct: 63.8, totalGain: 1224.00 },
  { name: 'Piña Colada',          emoji: '🍹', price: 9.00,  cost: 8.90, units: 45,  margin: 0.10,  marginPct: 1.1,  totalGain: 4.50 },
  { name: 'Agua fresca 500ml',    emoji: '🥤', price: 3.50,  cost: 3.80, units: 210, margin: -0.30, marginPct: -8.6, totalGain: -63.00 },
  { name: 'Pan de Ajo',           emoji: '🧄', price: 5.00,  cost: 5.50, units: 88,  margin: -0.50, marginPct: -10.0, totalGain: -44.00 },
  { name: 'Café Especial',        emoji: '☕', price: 4.00,  cost: 5.20, units: 67,  margin: -1.20, marginPct: -30.0, totalGain: -80.40 },
  { name: 'Sopa del Día',         emoji: '🍲', price: 8.00,  cost: 11.00, units: 39, margin: -3.00, marginPct: -37.5, totalGain: -117.00 },
]

const topItems    = computed(() => [...allItems].sort((a, b) => b.totalGain - a.totalGain).slice(0, 5))
const bottomItems = computed(() => [...allItems].sort((a, b) => a.totalGain - b.totalGain).slice(0, 5))
const displayedItems = computed(() => activeTab.value === 'top' ? topItems.value : bottomItems.value)

const rankClass = (idx: number, tab: string) => {
  if (tab === 'top') {
    return idx === 0 ? 'rank--gold' : idx === 1 ? 'rank--silver' : idx === 2 ? 'rank--bronze' : 'rank--default'
  }
  return 'rank--loss'
}
</script>

<style scoped>
.profit-table-wrapper {
  background-color: var(--bg-surface);
  border: 1px solid var(--border-color);
  border-radius: 1rem;
  padding: 1.5rem;
}

.profit-table-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 1.25rem;
  gap: 1rem;
  flex-wrap: wrap;
}

.profit-table-title {
  font-weight: 700;
  font-size: 1rem;
  color: var(--text-main);
  margin: 0;
}

.profit-table-subtitle {
  font-size: 0.72rem;
  color: var(--text-muted);
  margin: 0.2rem 0 0;
}

.rank-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  font-weight: 700;
  font-size: 0.8rem;
}

.rank--gold    { background: rgba(255,193,7,0.2);  color: #ffc107; }
.rank--silver  { background: rgba(173,181,189,0.2); color: #adb5bd; }
.rank--bronze  { background: rgba(205,127,50,0.2);  color: #cd7f32; }
.rank--default { background: rgba(108,117,125,0.15); color: var(--text-muted); }
.rank--loss    { background: rgba(220,53,69,0.15);  color: #dc3545; }

.item-emoji { font-size: 1.2rem; }

.margin-bar-wrapper {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  min-width: 100px;
}

.margin-bar {
  height: 6px;
  border-radius: 3px;
  transition: width 0.4s ease;
  flex-shrink: 0;
}

.margin-bar--profit { background: #20c997; }
.margin-bar--loss   { background: #dc3545; }

.margin-pct-label {
  font-size: 0.75rem;
  font-weight: 600;
  white-space: nowrap;
  color: var(--text-muted);
}

.btn-korange {
  background-color: var(--KOrange);
  color: white;
  border-color: var(--KOrange);
}

.profit-row {
  transition: background-color 0.15s ease;
}
</style>
