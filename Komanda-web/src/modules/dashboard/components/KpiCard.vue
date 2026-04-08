<template>
  <div class="kpi-card h-100" :class="`kpi-card--${variant}`">
    <div class="kpi-card__icon">
      <i :class="`bi ${icon}`"></i>
    </div>
    <div class="kpi-card__body">
      <p class="kpi-card__label">{{ label }}</p>
      <h2 class="kpi-card__value">{{ value }}</h2>
      <div v-if="trend !== undefined" class="kpi-card__trend" :class="trend >= 0 ? 'trend--up' : 'trend--down'">
        <i :class="trend >= 0 ? 'bi bi-arrow-up-short' : 'bi bi-arrow-down-short'"></i>
        <span>{{ Math.abs(trend) }}% vs ayer</span>
      </div>
      <p v-if="subtitle" class="kpi-card__subtitle">{{ subtitle }}</p>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  label: string
  value: string
  icon: string
  variant?: 'revenue' | 'cost' | 'profit' | 'tickets' | 'danger'
  trend?: number
  subtitle?: string
}>()
</script>

<style scoped>
.kpi-card {
  border-radius: 1rem;
  padding: 1.5rem;
  display: flex;
  align-items: flex-start;
  gap: 1rem;
  border: 1px solid var(--border-color);
  background-color: var(--bg-surface);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  position: relative;
  overflow: hidden;
}

.kpi-card::before {
  content: '';
  position: absolute;
  top: 0; left: 0;
  width: 4px;
  height: 100%;
  border-radius: 1rem 0 0 1rem;
}

.kpi-card--revenue::before { background: #20c997; }
.kpi-card--cost::before    { background: #dc3545; }
.kpi-card--profit::before  { background: var(--KOrange); }
.kpi-card--tickets::before { background: #0d6efd; }
.kpi-card--danger::before  { background: #dc3545; }

.kpi-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 32px rgba(0,0,0,0.12);
}

.kpi-card__icon {
  width: 48px;
  height: 48px;
  border-radius: 0.75rem;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.4rem;
  flex-shrink: 0;
}

.kpi-card--revenue .kpi-card__icon { background: rgba(32,201,151,0.15); color: #20c997; }
.kpi-card--cost    .kpi-card__icon { background: rgba(220,53,69,0.15);   color: #dc3545; }
.kpi-card--profit  .kpi-card__icon { background: rgba(253,126,20,0.15);  color: var(--KOrange); }
.kpi-card--tickets .kpi-card__icon { background: rgba(13,110,253,0.15);  color: #0d6efd; }
.kpi-card--danger  .kpi-card__icon { background: rgba(220,53,69,0.15);   color: #dc3545; }

.kpi-card__body { flex: 1; min-width: 0; }

.kpi-card__label {
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.6px;
  color: var(--text-muted);
  margin-bottom: 0.25rem;
}

.kpi-card__value {
  font-size: 1.75rem;
  font-weight: 700;
  color: var(--text-main);
  margin-bottom: 0.25rem;
  line-height: 1;
}

.kpi-card__trend {
  font-size: 0.8rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 2px;
}

.trend--up   { color: #20c997; }
.trend--down { color: #dc3545; }

.kpi-card__subtitle {
  font-size: 0.75rem;
  color: var(--text-muted);
  margin-top: 0.25rem;
  margin-bottom: 0;
}
</style>
