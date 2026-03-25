<template>
  <div>
    <button v-if="!isOpen" @click="isOpen = true" class="btn btn-korange toggle-btn d-md-none rounded-circle shadow">
      <i class="bi bi-list fs-4"></i>
    </button>
    <div v-if="isOpen" @click="isOpen = false" class="sidebar-overlay d-md-none"></div>
    <nav class="sidebar bg-surface-dark text-white d-flex flex-column p-4" :class="{ 'sidebar-open': isOpen }">
      <div class="sidebar-header d-flex justify-content-between align-items-center mb-5 mt-2">
        <h3 class="text-korange fw-bold mb-0 mx-auto">Komanda</h3>
        <button @click="isOpen = false" class="btn btn-sm btn-outline-light d-md-none border-0 px-2 py-1">
          <i class="bi bi-x-lg"></i>
        </button>
      </div>

      <ul class="nav nav-pills flex-column mb-auto gap-2">
        <!-- Inicio (Dashboard): Personalizado por rol -->
        <li class="nav-item">
          <router-link :to="dashboardRoute" class="nav-link text-white-50 d-flex align-items-center" active-class="active bg-korange text-white fw-bold">
            <i class="bi bi-house-door fs-5 me-3"></i> 
            <span>Inicio</span>
          </router-link>
        </li>
        <li class="nav-item" v-if="hasAccess(['admin', 'cajero'])">
          <router-link to="/operaciones" class="nav-link text-white-50 d-flex align-items-center" active-class="active bg-korange text-white fw-bold">
            <i class="bi bi-briefcase fs-5 me-3"></i>
            <span>Operaciones</span>
          </router-link>
        </li>
        <li class="nav-item" v-if="hasAccess(['mesero'])">
          <router-link to="/pedidos" class="nav-link text-white-50 d-flex align-items-center" active-class="active bg-korange text-white fw-bold">
            <i class="bi bi-cart3 fs-5 me-3"></i>
            <span>Pedidos</span>
          </router-link>
        </li>

        <!-- NUEVO MÓDULO MESERO: Mesas -->
        <li class="nav-item" v-if="hasAccess(['mesero'])">
          <router-link to="/mesas" class="nav-link text-white-50 d-flex align-items-center" active-class="active bg-korange text-white fw-bold">
            <i class="bi bi-grid-3x3-gap fs-5 me-3"></i>
            <span>Mesas</span>
          </router-link>
        </li>
        <li class="nav-item" v-if="hasAccess(['cocina'])">
          <router-link to="/kitchen" class="nav-link text-white-50 d-flex align-items-center" active-class="active bg-korange text-white fw-bold">
            <i class="bi bi-display fs-5 me-3"></i>
            <span>Cocina</span>
          </router-link>
        </li>
        <li class="nav-item" v-if="hasAccess(['admin', 'cocina'])">
          <router-link to="/almacen" class="nav-link text-white-50 d-flex align-items-center" active-class="active bg-korange text-white fw-bold">
            <i class="bi bi-boxes fs-5 me-3"></i>
            <span>Almacén</span>
          </router-link>
        </li>
        <li class="nav-item" v-if="hasAccess(['admin', 'cajero'])">
          <router-link to="/inventario" class="nav-link text-white-50 d-flex align-items-center" active-class="active bg-korange text-white fw-bold">
            <i class="bi bi-box-seam fs-5 me-3"></i>
            <span>Inventario</span>
          </router-link>
        </li>
        <li class="nav-item" v-if="hasAccess(['admin'])">
          <router-link to="/menu" class="nav-link text-white-50 d-flex align-items-center" active-class="active bg-korange text-white fw-bold">
            <i class="bi bi-book fs-5 me-3"></i>
            <span>Menú</span>
          </router-link>
        </li>
        <li class="nav-item" v-if="hasAccess(['admin', 'cajero'])">
          <router-link to="/finanzas" class="nav-link text-white-50 d-flex align-items-center" active-class="active bg-korange text-white fw-bold">
            <i class="bi bi-cash-coin fs-5 me-3"></i>
            <span>Finanzas</span>
          </router-link>
        </li>

        <!-- Configuración: Usuarios, Roles, Datos del Restaurante (Solo Admin) -->
        <li class="nav-item" v-if="hasAccess(['admin'])">
          <router-link to="/configuracion" class="nav-link text-white-50 d-flex align-items-center" active-class="active bg-korange text-white fw-bold">
            <i class="bi bi-gear fs-5 me-3"></i>
            <span>Configuración</span>
          </router-link>
        </li>
        </ul>

      <hr class="border-secondary my-3">
      
      <div class="user-profile mt-auto pb-2">
        <div class="dropdown">
          <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle px-2 py-2 rounded profile-btn" data-bs-toggle="dropdown" aria-expanded="false">
            <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px; font-weight: bold;">
              {{ role?.charAt(0)?.toUpperCase() || 'U' }}
            </div>
            <div class="d-flex flex-column text-start">
              <span class="fw-bold">{{ userName || 'Usuario' }}</span>
              <span class="text-white-50 small text-capitalize">{{ role }}</span>
            </div>
          </a>
          <ul class="dropdown-menu dropdown-menu-dark text-small shadow border-0 w-100">
            <li><a class="dropdown-item" href="#">Perfil</a></li>
            <li><a class="dropdown-item" href="#">Ajustes</a></li>
            <li><hr class="dropdown-divider border-secondary"></li>
            <li><a class="dropdown-item text-danger" href="#" @click.prevent="handleLogout">Cerrar sesión</a></li>
          </ul>
        </div>
      </div>
    </nav>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { useAuth } from '../core/composables/useAuth';

const props = defineProps<{
  role: string;
  userName?: string;
}>();

const auth = useAuth();
const isOpen = ref(false);

const hasAccess = (allowedRoles: string[]) => {
  return allowedRoles.includes(props.role);
};

const dashboardRoute = computed(() => {
  switch (props.role) {
    case 'admin': return '/dashboard';
    case 'mesero': return '/mesero-dashboard';
    case 'cajero': return '/caja-dashboard';
    case 'cocina': return '/kitchen';
    default: return '/';
  }
});

const handleLogout = () => {
    auth.logout();
};
</script>

<style scoped>
.sidebar {
  width: 260px;
  position: fixed;
  top: 0;
  left: 0;
  height: 100vh;
  z-index: 1040;
  transition: transform 0.3s ease-in-out;
  box-shadow: 4px 0 10px rgba(0, 0, 0, 0.1);
}

.bg-surface-dark {
  background-color: #1a1c23;
}

.bg-korange {
  background-color: var(--KOrange) !important;
  color: white !important;
}

.text-korange {
  color: var(--KOrange) !important;
}

.nav-link {
  border-radius: 0.5rem;
  transition: all 0.2s;
}

.nav-link:hover {
  background-color: rgba(255, 255, 255, 0.05);
  color: white !important;
  transform: translateX(4px);
}

.nav-link.active {
  box-shadow: 0 4px 10px rgba(var(--KOrange-rgb, 255, 136, 0), 0.3);
}

.profile-btn {
  transition: background-color 0.2s;
}
.profile-btn:hover {
  background-color: rgba(255, 255, 255, 0.05);
}

.toggle-btn {
  position: fixed;
  top: 1rem;
  left: 1rem;
  z-index: 1050;
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  background-color: var(--KOrange);
  color: white;
  transition: transform 0.2s;
}

.toggle-btn:active {
  transform: scale(0.95);
}

.sidebar-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(0,0,0,0.5);
  backdrop-filter: blur(2px);
  z-index: 1030;
}

@media (max-width: 767.98px) {
  .sidebar {
    transform: translateX(-100%);
  }
  .sidebar.sidebar-open {
    transform: translateX(0);
  }
}

/* Custom Scrollbar for Sidebar */
.sidebar-scroll::-webkit-scrollbar {
  width: 5px;
}
.sidebar-scroll::-webkit-scrollbar-track {
  background: transparent;
}
.sidebar-scroll::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 10px;
}
.sidebar-scroll::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.2);
}
</style>
