<script setup lang='ts'>
import { onMounted, ref } from 'vue';
import { ArrowRight, Zap, Shield, Globe } from 'lucide-vue-next';

const isVisible = ref(false);

onMounted(() => {
    setTimeout(() => {
        isVisible.value = true;
    }, 100);
});
</script>

<template>
    <section class="hero-section d-flex align-items-center position-relative overflow-hidden">
        <!-- Background Elements -->
        <div class="bg-blob blob-1"></div>
        <div class="bg-blob blob-2"></div>

        <div class="container position-relative z-1">
            <div class="row align-items-center gy-5">
                <!-- Text Content -->
                <div class="col-lg-6">
                    <div class="hero-content" :class="{ 'visible': isVisible }">
                        <span class="badge bg-korange-soft text-korange mb-3 px-3 py-2 rounded-pill fw-bold">
                            v2.0 Ya disponible
                        </span>
                        <h1 class="display-3 fw-bold mb-4 text-balance">
                            Gestiona tu cocina con <span class="text-gradient">Komanda</span>
                        </h1>
                        <p class="lead text-secondary mb-5">
                            La plataforma definitiva para restaurantes modernos. Optimiza pedidos, mejora tiempos y
                            deleita a tus clientes con una experiencia fluida.
                        </p>
                        <div class="d-flex gap-3 flex-wrap">
                            <router-link to="/kitchen"
                                class="btn-korange rounded-pill px-5 py-3 d-flex align-items-center gap-2 text-decoration-none fs-5 fw-bold shadow-sm"
                                style="background-color: var(--KOrange) !important; color: white !important;">
                                Comenzar
                                <ArrowRight :size="20" />
                            </router-link>
                        </div>

                        <div class="mt-5 d-flex gap-4 text-secondary small">
                            <div class="d-flex align-items-center gap-2">
                                <Zap :size="16" class="text-korange" /> Setup en 5 min
                            </div>
                            <div class="d-flex align-items-center gap-2">
                                <Shield :size="16" class="text-korange" /> Datos seguros
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Visual Content -->
                <div class="col-lg-6">
                    <div class="hero-visual" :class="{ 'visible': isVisible }">
                        <div class="visual-card main-card p-4 rounded-4 shadow-lg bg-surface">
                            <div class="d-flex align-items-center justify-content-between mb-4">
                                <div class="d-flex align-items-center gap-3">
                                    <div
                                        class="avatar bg-korange rounded-circle d-flex align-items-center justify-content-center text-white fw-bold">
                                        K</div>
                                    <div>
                                        <h6 class="m-0 fw-bold text-main">Orden #1234</h6>
                                        <small class="text-secondary-custom">Hace 2 min</small>
                                    </div>
                                </div>
                                <span class="badge bg-success bg-opacity-10 text-success">En Preparación</span>
                            </div>
                            <div class="border-bottom mb-3"></div>
                            <div class="mb-3">
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-main">2x Hamburguesa Clásica</span>
                                    <span class="fw-bold text-main">$24.00</span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span class="text-main">1x Papas Fritas Extra</span>
                                    <span class="fw-bold text-main">$5.00</span>
                                </div>
                            </div>
                        </div>

                        <!-- Floating Elements -->
                        <div class="visual-card float-card-1 p-3 rounded-3 shadow bg-surface">
                            <div class="d-flex align-items-center gap-2">
                                <Globe :size="20" class="text-primary" />
                                <span class="fw-bold text-main">Pedidos Online</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>

<style scoped>
.hero-section {
    min-height: 90vh;
    padding: 6rem 0;
    transition: background-color var(--transition-speed);
}

.text-gradient {
    background: linear-gradient(135deg, var(--KOrange) 0%, #ffbe76 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.bg-korange-soft {
    background-color: var(--KOrange-light);
}

.text-balance {
    text-wrap: balance;
}

.text-main {
    color: var(--text-main);
}

/* Animations */
.hero-content {
    opacity: 0;
    transform: translateY(30px);
    transition: all 0.8s ease-out;
}

.hero-content.visible {
    opacity: 1;
    transform: translateY(0);
}

.hero-visual {
    position: relative;
    opacity: 0;
    transform: translateX(30px);
    transition: all 0.8s ease-out 0.2s;
    /* delay */
}

.hero-visual.visible {
    opacity: 1;
    transform: translateX(0);
}

.bg-surface {
    background-color: var(--bg-surface);
}

.avatar {
    width: 40px;
    height: 40px;
}

/* Floating Cards */
.visual-card {
    border: 1px solid var(--border-color);
}

.main-card {
    transform: rotate(-2deg);
    transition: transform 0.5s ease;
}

.main-card:hover {
    transform: rotate(0deg) scale(1.02);
}

.float-card-1 {
    position: absolute;
    top: -20px;
    right: 20px;
    animation: float 6s ease-in-out infinite;
}

@keyframes float {
    0% {
        transform: translateY(0px);
    }

    50% {
        transform: translateY(-15px);
    }

    100% {
        transform: translateY(0px);
    }
}

/* Background Blobs */
.bg-blob {
    position: absolute;
    border-radius: 50%;
    filter: blur(80px);
    opacity: 0.15;
    z-index: 0;
}

.blob-1 {
    top: -10%;
    right: -5%;
    width: 600px;
    height: 600px;
    background-color: var(--KOrange);
}

.blob-2 {
    bottom: -10%;
    left: -10%;
    width: 500px;
    height: 500px;
    background-color: #6c5ce7;
    /* Secondary accent */
}

@media (max-width: 991.98px) {
    .hero-section {
        padding: 4rem 0;
        text-align: center;
    }

    .hero-visual {
        margin-top: 3rem;
    }

    .d-flex.gap-3 {
        justify-content: center;
    }

    .mt-5.d-flex {
        justify-content: center;
    }
}
</style>