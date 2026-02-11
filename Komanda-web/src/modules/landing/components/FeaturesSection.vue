<script setup lang='ts'>
import { CheckCircle2, Cloud, Smartphone, TrendingUp, Users, Clock } from 'lucide-vue-next';

const features = [
    {
        icon: Smartphone,
        title: "Pedidos en Mesa",
        description: "Tus clientes ordenan desde su celular escaneando un QR. Sin esperas, sin errores."
    },
    {
        icon: Cloud,
        title: "Todo en la Nube",
        description: "Accede a tu restaurante desde cualquier lugar. Datos sincronizados en tiempo real."
    },
    {
        icon: Clock,
        title: "Tiempos Reales",
        description: "Monitorea el tiempo de preparación y entrega de cada plato. Optimiza tu cocina."
    },
    {
        icon: Users,
        title: "Gestión de Personal",
        description: "Asigna roles, controla turnos y mide el rendimiento de tus meseros y cocineros."
    },
    {
        icon: TrendingUp,
        title: "Reportes Detallados",
        description: "Toma decisiones basadas en datos. Ventas, platos más vendidos e inventario."
    },
    {
        icon: CheckCircle2,
        title: "Inventario Inteligente",
        description: "Descuento automático de ingredientes con cada venta. Alertas de stock bajo."
    }
];
</script>

<template>
    <section class="features-section py-5" id="features">
        <div class="container py-lg-5">
            <div class="row justify-content-center mb-5">
                <div class="col-lg-8 text-center">
                    <span class="text-korange fw-bold text-uppercase tracking-wider small">Potente y Flexible</span>
                    <h2 class="display-5 fw-bold mt-2 mb-3 texto-landing">Todo lo que necesitas para crecer</h2>
                    <p class="lead text-secondary">
                        Komanda te da las herramientas para operar como las grandes cadenas, pagando una fracción del
                        costo.
                    </p>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-md-6 col-lg-4" v-for="(feature, index) in features" :key="index">
                    <div
                        class="feature-card h-100 p-4 rounded-4 bg-surface border-0 shadow-sm position-relative overflow-hidden">
                        <div
                            class="icon-wrapper mb-4 d-inline-flex align-items-center justify-content-center rounded-circle text-korange bg-korange-soft">
                            <component :is="feature.icon" :size="32" />
                        </div>
                        <h4 class="fw-bold mb-3 text-primary-color">{{ feature.title }}</h4>
                        <p class="text-secondary mb-0">{{ feature.description }}</p>

                        <!-- Hover Effect Decoration -->
                        <div class="hover-decoration"></div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>

<style scoped>
.features-section {
    background-color: var(--bg-body);
}

.tracking-wider {
    letter-spacing: 2px;
}

.bg-surface {
    background-color: var(--bg-surface);
    border: 1px solid var(--border-color) !important;
    transition: transform var(--transition-speed), box-shadow var(--transition-speed), border-color var(--transition-speed);
}

.text-primary-color {
    color: var(--text-primary);
}

.text-korange{
    color: var(--KOrange) !important
}

.bg-korange-soft {
    background-color: var(--KOrange-light);
    width: 64px;
    height: 64px;
    transition: all var(--transition-speed);
}

/* Card Hover Effects */
.feature-card:hover {
    transform: translateY(-10px);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08) !important;
    border-color: var(--KOrange) !important;
}

.feature-card:hover .bg-korange-soft {
    background-color: var(--KOrange);
    color: white !important;
}

.hover-decoration {
    position: absolute;
    top: 0;
    right: 0;
    width: 100px;
    height: 100px;
    background: radial-gradient(circle at top right, var(--KOrange-light), transparent 70%);
    opacity: 0;
    transition: opacity var(--transition-speed);
}

.feature-card:hover .hover-decoration {
    opacity: 1;
}

/* Dark mode adjustments done via CSS vars, but specific overrides if needed */
@media (prefers-color-scheme: dark) {
    .bg-korange-soft {
        background-color: rgba(253, 126, 20, 0.15);
        /* Adjust opacity for dark mode */
    }

    .texto-landing {
        color: #ffffff;
    }
}
</style>
