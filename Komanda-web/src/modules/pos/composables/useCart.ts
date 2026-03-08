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