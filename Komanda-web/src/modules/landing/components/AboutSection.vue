<script setup lang='ts'>
import { ShieldCheck, Target, Award } from 'lucide-vue-next';

const statistics = [
    { number: '500+', label: 'Restaurantes' },
    { number: '99.9%', label: 'Uptime' },
    { number: '24/7', label: 'Soporte' },
];
</script>

<template>
    <section class="about-section py-5" id="about">
        <div class="container py-lg-5">
            <div class="row align-items-center gy-5">
                <!-- Visual Content -->
                <div class="col-lg-6 order-2 order-lg-1">
                    <div class="about-visual position-relative pe-lg-5">
                        <div class="image-wrapper rounded-4 overflow-hidden shadow-lg">
                            <!-- Placeholder for a real image, using a gradient/pattern for now -->
                            <div
                                class="placeholder-image bg-surface d-flex align-items-center justify-content-center text-secondary">
                                <span class="fs-1 fw-bold opacity-25">Equipo Komanda</span>
                            </div>
                        </div>

                        <!-- Floating Badge -->
                        <div class="floating-badge bg-korange text-white p-4 rounded-4 shadow-lg position-absolute">
                            <Award :size="32" class="mb-2" />
                            <h5 class="fw-bold m-0">#1 en Latam</h5>
                            <small class="opacity-75">Solución Gastronómica</small>
                        </div>
                    </div>
                </div>

                <!-- Text Content -->
                <div class="col-lg-6 order-1 order-lg-2">
                    <span class="text-korange fw-bold text-uppercase tracking-wider small">Sobre Nosotros</span>
                    <h2 class="display-5 fw-bold mt-2 mb-4 texto-About">Empoderando a la gastronomía moderna</h2>
                    <p class="lead text-secondary mb-4">
                        Nuestra misión es democratizar la tecnología para restaurantes de todos los tamaños,
                        permitiéndoles competir y crecer en un mundo digital.
                    </p>
                    <p class="text-secondary mb-5">
                        Nacimos en una cocina real, entendiendo los dolores de cabeza diarios de chefs y gerentes. Por
                        eso, cada función de Komanda está diseñada para resolver un problema real, no para adornar.
                    </p>

                    <div class="row g-4 mb-5">
                        <div class="col-6">
                            <div class="d-flex gap-3">
                                <div class="icon-box flex-shrink-0 text-korange">
                                    <Target :size="24" />
                                </div>
                                <div>
                                    <h6 class="fw-bold text-primary-color mb-1">Misión</h6>
                                    <p class="small text-secondary m-0">Simplificar operaciones complejas.</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="d-flex gap-3">
                                <div class="icon-box flex-shrink-0 text-korange">
                                    <ShieldCheck :size="24" />
                                </div>
                                <div>
                                    <h6 class="fw-bold text-primary-color mb-1">Visión</h6>
                                    <p class="small text-secondary m-0">Ser el estándar global de gestión.</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Statistics -->
                    <div class="d-flex gap-5 border-top pt-4">
                        <div v-for="(stat, index) in statistics" :key="index">
                            <h3 class="fw-bold text-primary-color m-0">{{ stat.number }}</h3>
                            <small class="text-secondary">{{ stat.label }}</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>

<style scoped>
.about-section {
    background-color: var(--bg-surface);
}

.text-primary-color {
    color: var(--text-primary);
}

.tracking-wider {
    letter-spacing: 2px;
}

.placeholder-image {
    height: 500px;
    background: linear-gradient(45deg, var(--bg-body), var(--bg-surface));
    border: 1px solid var(--border-color);
}

.floating-badge {
    bottom: 30px;
    right: 20px;
    /* Adjusted for mobile/desktop overlap logic */
    z-index: 2;
    background: linear-gradient(135deg, var(--KOrange), #ffbe76);
}

@media (min-width: 992px) {
    .floating-badge {
        right: 0;
        bottom: 50px;
    }
}

@media (prefers-color-scheme: dark) {
    .texto-About {
        color: #ffffff;
    }
}

.border-top {
    border-color: var(--border-color) !important;
}
</style>
