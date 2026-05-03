<template>
  <div class="chart-wrapper">
    <div class="chart-header">
      <div>
        <h6 class="chart-title">Ventas vs Costo de Ventas</h6>
        <p class="chart-subtitle">Últimos 7 días</p>
      </div>
      <div class="chart-legend">
        <span class="legend-dot legend-dot--sales"></span> Ventas
        <span class="legend-dot legend-dot--cost ms-3"></span> Costos
      </div>
    </div>

    <div class="chart-area">
      <svg :viewBox="`0 0 ${W} ${H}`" class="chart-svg" preserveAspectRatio="none">
        <!-- Grid lines -->
        <line v-for="i in 4" :key="`grid-${i}`"
          :x1="PAD_L" :y1="yPos(maxVal * (i / 4))"
          :x2="W - PAD_R" :y2="yPos(maxVal * (i / 4))"
          stroke="var(--border-color)" stroke-width="1" stroke-dasharray="4,4" />

        <!-- Cost Area -->
        <path :d="areaPath(costData, true)" fill="rgba(220,53,69,0.08)" />
        <path :d="linePath(costData)" fill="none" stroke="#dc3545" stroke-width="2.5" stroke-linejoin="round" stroke-linecap="round" />

        <!-- Sales Area -->
        <path :d="areaPath(salesData, false)" fill="rgba(253,126,20,0.12)" />
        <path :d="linePath(salesData)" fill="none" stroke="var(--KOrange)" stroke-width="2.5" stroke-linejoin="round" stroke-linecap="round" />

        <!-- Data points sales -->
        <circle v-for="(d, i) in salesData" :key="`sp-${i}`"
          :cx="xPos(i)" :cy="yPos(d)"
          r="4" fill="var(--KOrange)" stroke="var(--bg-surface)" stroke-width="2">
          <title>Venta: ${{ d.toLocaleString() }}</title>
        </circle>

        <!-- Data points cost -->
        <circle v-for="(d, i) in costData" :key="`cp-${i}`"
          :cx="xPos(i)" :cy="yPos(d)"
          r="4" fill="#dc3545" stroke="var(--bg-surface)" stroke-width="2">
          <title>Costo: ${{ d.toLocaleString() }}</title>
        </circle>
      </svg>

      <!-- X-axis labels -->
      <div class="x-labels">
        <span v-for="day in days" :key="day">{{ day }}</span>
      </div>
    </div>

    <!-- Y-axis values -->
    <div class="y-hint">
      <span>{{ formatK(maxVal) }}</span>
      <span>{{ formatK(maxVal / 2) }}</span>
      <span>$0</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const W = 600
const H = 200
const PAD_L = 10
const PAD_R = 10
const PAD_T = 16
const PAD_B = 10

const props = defineProps<{
  data: { date: string, revenue: number, cost: number }[]
}>()

const days = computed(() => props.data.length ? props.data.map(d => d.date) : ['-', '-', '-', '-', '-', '-', '-'])
const salesData = computed(() => props.data.length ? props.data.map(d => d.revenue) : [0,0,0,0,0,0,0])
const costData  = computed(() => props.data.length ? props.data.map(d => d.cost) : [0,0,0,0,0,0,0])

const maxVal = computed(() => {
  const max = Math.max(...salesData.value)
  return max === 0 ? 100 : max * 1.15
})

const xPos = (i: number) => PAD_L + (i / (Math.max(salesData.value.length - 1, 1))) * (W - PAD_L - PAD_R)
const yPos = (v: number) => PAD_T + (1 - v / maxVal.value) * (H - PAD_T - PAD_B)

const linePath = (data: number[]) =>
  data.map((d, i) => `${i === 0 ? 'M' : 'L'}${xPos(i)},${yPos(d)}`).join(' ')

const areaPath = (data: number[], above: boolean) => {
  const line = data.map((d, i) => `${i === 0 ? 'M' : 'L'}${xPos(i)},${yPos(d)}`).join(' ')
  const base = above ? H : yPos(0)
  return `${line} L${xPos(data.length - 1)},${base} L${xPos(0)},${base} Z`
}

const formatK = (v: number) => v >= 1000 ? `$${(v / 1000).toFixed(1)}k` : `$${Math.round(v)}`
</script>

<style scoped>
.chart-wrapper {
  background-color: var(--bg-surface);
  border: 1px solid var(--border-color);
  border-radius: 1rem;
  padding: 1.5rem;
  position: relative;
}

.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 1rem;
}

.chart-title {
  font-weight: 700;
  font-size: 1rem;
  color: var(--text-main);
  margin: 0;
}

.chart-subtitle {
  font-size: 0.75rem;
  color: var(--text-muted);
  margin: 0;
}

.chart-legend {
  font-size: 0.75rem;
  color: var(--text-muted);
  display: flex;
  align-items: center;
  gap: 4px;
}

.legend-dot {
  display: inline-block;
  width: 10px;
  height: 10px;
  border-radius: 50%;
}

.legend-dot--sales { background: var(--KOrange); }
.legend-dot--cost  { background: #dc3545; }

.chart-area {
  position: relative;
}

.chart-svg {
  width: 100%;
  height: 200px;
  display: block;
  overflow: visible;
}

.x-labels {
  display: flex;
  justify-content: space-between;
  padding: 0.25rem 0;
  font-size: 0.7rem;
  color: var(--text-muted);
}

.y-hint {
  position: absolute;
  top: 3.5rem;
  left: 0;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  height: 200px;
  font-size: 0.65rem;
  color: var(--text-muted);
  pointer-events: none;
}
</style>
