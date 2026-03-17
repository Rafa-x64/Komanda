<<<<<<< HEAD
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
const selectedTable = ref<number | null>(null)

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
  selectedTable.value = null
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
=======
import { ref, computed } from "vue";

interface CartItems {
    product: any,
    quantity: number,
    notes?: string,
}

const cartItems = ref<CartItems[]>([]);
const selectedTable = ref<null | 0>(null);

const addItem = (product: any) => {
    const existingItem = cartItems.value.find(item => item.product.id === product.id);

    if (existingItem) {
        existingItem.quantity++;
    } else {
        cartItems.value.push({
            product,
            quantity: 1,
            notes: ''
        });
    }
};

const updateQuantity = (productId: string, amount: number) => {
    const existingItem = cartItems.value.find(item => item.product.id === productId);

    if (existingItem) {
        existingItem.quantity += amount;

        if (existingItem.quantity <= 0) {
            removeItem(productId);
        }
    }
}

const removeItem = (productId: string) => {
    cartItems.value = cartItems.value.filter(item => item.product.id !== productId)
}

const addKitechenNote = (productId: string, note: string) => { 
    const existingItem = cartItems.value.find(item => item.product.id === productId);

    if (existingItem) { 
        existingItem.notes = note;
    }
}

const clearCart = () => {
    cartItems.value = []
    selectedTable.value = null;
}

const subtotal = computed(() => {
    return cartItems.value.reduce((acc, item) => {
        return acc + (item.product.price * item.quantity);
    }, 0);
});

const taxes = computed(() => {
    return subtotal.value * 0.16;
});

const total = computed(() => {
    return subtotal.value + taxes.value;
});

export { 
    cartItems,
    selectedTable,
    addItem,
    updateQuantity,
    removeItem,
    addKitechenNote,
    clearCart,
    subtotal,
    taxes,
    total
}
>>>>>>> 39ceec68e5e9e06da700d490dcef3eacc9fea992
