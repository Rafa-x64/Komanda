<script setup lang="ts">
import { ref } from 'vue'
import { Plus, Minus, Pencil, X } from 'lucide-vue-next'

interface CartItem {
  product: { id: number; nombre: string; precio_venta: number }
  quantity: number
  notes: string
}

defineProps<{ item: CartItem }>()
const emit = defineEmits<{
  increase: []
  decrease: []
  'add-note': [note: string]
  remove: []
}>()

const showNoteInput = ref(false)
const noteText = ref('')

const openNote = (currentNote: string) => {
  noteText.value = currentNote
  showNoteInput.value = true
}

const saveNote = () => {
  emit('add-note', noteText.value)
  showNoteInput.value = false
}
</script>

<template>
  <div class="cart-row">
    <div class="cart-row__info">
      <span class="cart-row__name">{{ item.product.nombre }}</span>
      <span class="cart-row__line-total">
        ${{ (item.product.precio_venta * item.quantity).toFixed(2) }}
      </span>
      <span v-if="item.notes" class="cart-row__note">📝 {{ item.notes }}</span>
    </div>

    <div class="cart-row__actions">
      <button class="cart-btn cart-btn--round" @click="emit('decrease')" aria-label="Disminuir">
        <Minus :size="16" />
      </button>
      <span class="cart-row__qty">{{ item.quantity }}</span>
      <button class="cart-btn cart-btn--round" @click="emit('increase')" aria-label="Aumentar">
        <Plus :size="16" />
      </button>
      <button class="cart-btn cart-btn--icon" @click="openNote(item.notes)" aria-label="Nota de cocina">
        <Pencil :size="14" />
      </button>
      <button class="cart-btn cart-btn--icon cart-btn--danger" @click="emit('remove')" aria-label="Eliminar">
        <X :size="14" />
      </button>
    </div>

    <!-- Inline note input -->
    <div v-if="showNoteInput" class="cart-row__note-input">
      <input
        v-model="noteText"
        type="text"
        class="form-control form-control-sm"
        placeholder="Nota para cocina..."
        @keyup.enter="saveNote"
      />
      <button class="btn btn-sm btn-korange" @click="saveNote">OK</button>
    </div>
  </div>
</template>

<style scoped>
.cart-row {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  padding: 0.65rem 0;
  border-bottom: 1px solid var(--border-color);
  gap: 0.5rem;
}

.cart-row__info {
  display: flex;
  flex-direction: column;
  flex: 1;
  min-width: 0;
}

.cart-row__name {
  font-weight: 600;
  font-size: 0.875rem;
  color: var(--text-main);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.cart-row__line-total {
  font-size: 0.8rem;
  color: var(--text-muted);
}

.cart-row__note {
  font-size: 0.75rem;
  color: var(--KOrange);
  margin-top: 0.15rem;
}

.cart-row__actions {
  display: flex;
  align-items: center;
  gap: 0.35rem;
  flex-shrink: 0;
}

.cart-row__qty {
  font-weight: 700;
  font-size: 0.95rem;
  min-width: 24px;
  text-align: center;
  color: var(--text-main);
}

.cart-btn {
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all var(--transition-speed);
}

.cart-btn--round {
  width: 34px;
  height: 34px;
  border-radius: 50%;
  background: var(--KOrange);
  color: #fff;
}

.cart-btn--round:active {
  transform: scale(0.9);
}

.cart-btn--icon {
  width: 28px;
  height: 28px;
  border-radius: 0.375rem;
  background: var(--bg-surface);
  color: var(--text-muted);
}

.cart-btn--icon:hover {
  color: var(--KOrange);
}

.cart-btn--danger:hover {
  color: #dc3545;
}

.cart-row__note-input {
  display: flex;
  gap: 0.5rem;
  width: 100%;
  margin-top: 0.4rem;
}

.cart-row__note-input .form-control-sm {
  flex: 1;
}
</style>
