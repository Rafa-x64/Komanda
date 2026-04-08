import { ref, computed } from 'vue'

interface CartProduct {
  id: number
  nombre: string
  precio_venta: number
  categoria_id: number
  imagen_url?: string
}

interface CartItem {
  product: CartProduct
  quantity: number
  notes: string
}

const TAX_RATE = 0.12

const cartItems = ref<CartItem[]>([])
const selectedTable = ref<number | null | undefined>(undefined)

const addItem = (product: CartProduct) => {
  const existing = cartItems.value.find(i => i.product.id === product.id)
  if (existing) { existing.quantity++; return }
  cartItems.value.push({ product, quantity: 1, notes: '' })
}

const removeItem = (productId: number) => {
  cartItems.value = cartItems.value.filter(i => i.product.id !== productId)
}

const updateQuantity = (productId: number, amount: number) => {
  const item = cartItems.value.find(i => i.product.id === productId)
  if (!item) return
  item.quantity += amount
  if (item.quantity <= 0) removeItem(productId)
}

const addKitchenNote = (productId: number, note: string) => {
  const item = cartItems.value.find(i => i.product.id === productId)
  if (item) item.notes = note
}

const clearCart = () => {
  cartItems.value = []
  selectedTable.value = undefined
}

const subtotal = computed(() =>
  cartItems.value.reduce((sum, i) => sum + i.product.precio_venta * i.quantity, 0)
)

const taxes = computed(() => subtotal.value * TAX_RATE)
const total = computed(() => subtotal.value + taxes.value)

export function useCart() {
  return {
    cartItems,
    selectedTable,
    addItem,
    removeItem,
    updateQuantity,
    addKitchenNote,
    clearCart,
    subtotal,
    taxes,
    total,
  }
}
