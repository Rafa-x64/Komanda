<template>
  <template v-for="account in accounts" :key="account.id">
    <!-- Fila principal -->
    <tr class="account-row" :class="{ 'is-parent': account.children && account.children.length > 0 }">
      <td class="account-name-cell" :style="{ paddingLeft: `${depth * 1.5 + 1}rem` }">
        <div class="d-flex align-items-center">
          <!-- Botón de colapso -->
          <button 
            v-if="account.children && account.children.length > 0"
            class="btn btn-sm param-toggle-btn me-2"
            @click="toggleExpand(account.id)"
            aria-label="Expandir/Contraer"
          >
            <i class="bi" :class="isExpanded(account.id) ? 'bi-chevron-down' : 'bi-chevron-right'"></i>
          </button>
          <span v-else class="empty-toggle-space me-2"></span>
          
          <span class="fw-semibold" :class="{ 'text-primary-custom': depth === 0, 'text-secondary-custom': depth > 0 }">
            {{ account.name }}
          </span>
        </div>
      </td>
      <td class="text-end fw-medium" :class="getAmountClass(account.balance)">
        {{ formatCurrency(account.balance) }}
      </td>
    </tr>
    <!-- Recursividad para los hijos -->
    <template v-if="account.children && account.children.length > 0 && isExpanded(account.id)">
      <CollapsibleAccountRow
        :accounts="account.children"
        :depth="depth + 1"
      />
    </template>
  </template>
</template>

<script setup lang="ts">
import { ref } from 'vue'

interface AccountNode {
  id: string | number
  name: string
  balance: number
  type?: string
  children?: AccountNode[]
}

defineProps<{
  accounts: AccountNode[]
  depth: number
}>()

const expandedIds = ref<Set<string | number>>(new Set())

const toggleExpand = (id: string | number) => {
  if (expandedIds.value.has(id)) {
    expandedIds.value.delete(id)
  } else {
    expandedIds.value.add(id)
  }
}

const isExpanded = (id: string | number) => expandedIds.value.has(id)

const formatCurrency = (val: number) => {
  return new Intl.NumberFormat('es-US', {
    style: 'currency',
    currency: 'USD',
  }).format(val)
}

const getAmountClass = (amount: number) => {
  if (amount < 0) return 'text-danger'
  if (amount > 0) return 'text-success'
  return 'text-muted'
}
</script>

<style scoped>
.account-row {
  transition: background-color 0.2s ease;
  border-bottom: 1px solid var(--border-color);
}

.account-row:hover {
  background-color: var(--bg-surface-hover, rgba(0,0,0,0.02));
}

.param-toggle-btn {
  padding: 0;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  background: rgba(253, 126, 20, 0.1);
  color: var(--KOrange);
  border-radius: 4px;
  transition: all 0.2s;
}

.param-toggle-btn:hover {
  background: var(--KOrange);
  color: white;
}

.empty-toggle-space {
  display: inline-block;
  width: 24px;
  height: 24px;
}

.text-primary-custom { color: var(--text-main); }
.text-secondary-custom { color: var(--text-muted); }
</style>
