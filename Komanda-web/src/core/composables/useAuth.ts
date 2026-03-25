import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'

interface User {
  id: number
  nombre: string
  username: string
  email: string
  role: string
}

interface Restaurant {
  id: number
  nombre: string
}

// Global state to share across components
const user = ref<User | null>(null)
const restaurant = ref<Restaurant | null>(null)
const token = ref<string | null>(null)
let initialized = false

export function useAuth() {
  const router = useRouter()

  const initAuth = () => {
    if (initialized) return
    const storedToken = localStorage.getItem('auth_token')
    const storedUser = localStorage.getItem('auth_user')
    const storedRest = localStorage.getItem('auth_restaurant')

    if (storedToken && storedUser && storedRest) {
      token.value = storedToken
      user.value = JSON.parse(storedUser)
      restaurant.value = JSON.parse(storedRest)
    }
    initialized = true
  }

  // Call immediately when composable is explicitly imported
  initAuth()

  const setAuthData = (newToken: string, newUser: User, newRestaurant: Restaurant) => {
    token.value = newToken
    user.value = newUser
    restaurant.value = newRestaurant

    localStorage.setItem('auth_token', newToken)
    localStorage.setItem('auth_user', JSON.stringify(newUser))
    localStorage.setItem('auth_restaurant', JSON.stringify(newRestaurant))
  }

  const logout = () => {
    token.value = null
    user.value = null
    restaurant.value = null
    localStorage.removeItem('auth_token')
    localStorage.removeItem('auth_user')
    localStorage.removeItem('auth_restaurant')
    router.push('/singin')
  }

  const navigateToDashboard = () => {
    if (!user.value) return router.push('/singin')
    switch (user.value.role) {
      case 'admin':
        router.push('/dashboard')
        break
      case 'cajero':
        router.push('/caja-dashboard')
        break
      case 'mesero':
        router.push('/mesero-dashboard')
        break
      case 'cocina':
        router.push('/kitchen')
        break
      default:
        router.push('/singin')
    }
  }

  return {
    user: computed(() => user.value),
    restaurant: computed(() => restaurant.value),
    token: computed(() => token.value),
    isAuthenticated: computed(() => !!token.value),
    setAuthData,
    logout,
    navigateToDashboard,
  }
}
