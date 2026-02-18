<script setup lang='ts'>
import { ref } from 'vue';
import { Menu, X, Instagram, Linkedin, Twitter } from 'lucide-vue-next';

const isMenuOpen = ref(false);

const toggleMenu = () => {
    isMenuOpen.value = !isMenuOpen.value;
};
</script>

<template>
    <header class="app-header sticky-top">
        <nav class="navbar navbar-expand-lg">
            <div class="container">
                <!-- Brand / Logo -->
                <a class="navbar-brand fw-bold d-flex align-items-center gap-2" href="#">
                    <span class="text-korange">KOMANDA</span>
                </a>

                <!-- Mobile Toggle -->
                <button class="navbar-toggler border-0" type="button" @click="toggleMenu"
                    aria-label="Toggle navigation">
                    <component :is="isMenuOpen ? X : Menu" :size="28" class="text-korange" />
                </button>

                <!-- Navbar Links -->
                <div class="collapse navbar-collapse" :class="{ 'show': isMenuOpen }">
                    <ul class="navbar-nav mx-auto mb-2 mb-lg-0 gap-lg-4">
                        <li class="nav-item">
                            <a class="nav-link active" href="#">Inicio</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#features">Características</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#about">Nosotros</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#contact">Contacto</a>
                        </li>
                    </ul>

                    <!-- Social / Contact Actions -->
                    <div class="d-flex align-items-center gap-3 social-icons mt-3 mt-lg-0">
                        <a href="#" class="icon-link">
                            <Instagram :size="20" />
                        </a>
                        <a href="#" class="icon-link">
                            <Twitter :size="20" />
                        </a>
                        <a href="#" class="icon-link">
                            <Linkedin :size="20" />
                        </a>
<<<<<<< HEAD
                        <router-link to="/singin" class="btn btn-korange btn-sm rounded-pill px-4">Iniciar Sesion</router-link>
                        <router-link to="/singup" class="btn btn-korange btn-sm rounded-pill px-4">Registrarse</router-link>
=======
                        <router-link to="/kitchen" class="btn btn-korange btn-sm rounded-pill px-4">
                          Empezar
                        </router-link>
>>>>>>> c024acc31b7bb9fe4424a3fd0217fa94c546ba79
                    </div>
                </div>
            </div>
        </nav>
    </header>
</template>

<style scoped>
.app-header {
    background-color: var(--bg-body);
    transition: background-color var(--transition-speed);
    border-bottom: 1px solid var(--border-color);
}

.navbar-brand {
    font-size: 1.5rem;
    color: var(--text-primary);
}

.nav-link {
    color: var(--text-secondary);
    font-weight: 500;
    transition: color 0.2s ease;
}

.nav-link:hover,
.nav-link.active {
    color: var(--KOrange);
}

.icon-link {
    color: var(--text-secondary);
    transition: color 0.2s ease;
}

.icon-link:hover {
    color: var(--KOrange);
}

.btn-korange {
    color: var(--text-primary)
}

@media (max-width: 991.98px) {
    .navbar-collapse {
        background-color: var(--bg-body);
        padding: 1rem 0;
    }
}
</style>