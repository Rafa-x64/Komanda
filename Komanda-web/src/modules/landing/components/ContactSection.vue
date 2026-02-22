<script setup lang='ts'>
import { Mail, MapPin, Phone, Send } from 'lucide-vue-next';
</script>

<template>
    <section class="contact-section py-5" id="contact">
        <div class="container py-lg-5">
            <div class="row align-items-center gy-5">
                <!-- Text / Info -->
                <div class="col-lg-5">
                    <span class="text-korange fw-bold text-uppercase tracking-wider small">Contáctanos</span>
                    <h2 class="display-5 fw-bold mt-2 mb-4 text-main">Hablemos de tu proyecto</h2>
                    <p class="lead text-secondary-custom mb-5">
                        ¿Listo para llevar tu restaurante al siguiente nivel? Nuestro equipo está listo para ayudarte a
                        empezar.
                    </p>

                    <div class="d-flex flex-column gap-4">
                        <div class="d-flex gap-3 align-items-start">
                            <div
                                class="icon-circle bg-korange-soft text-korange d-flex align-items-center justify-content-center rounded-circle flex-shrink-0">
                                <Mail :size="20" />
                            </div>
                            <div>
                                <h6 class="fw-bold text-main mb-1">Email</h6>
                                <p class="text-secondary-custom m-0">hola@komanda.com</p>
                                <p class="text-secondary-custom m-0">soporte@komanda.com</p>
                            </div>
                        </div>

                        <div class="d-flex gap-3 align-items-start">
                            <div
                                class="icon-circle bg-korange-soft text-korange d-flex align-items-center justify-content-center rounded-circle flex-shrink-0">
                                <Phone :size="20" />
                            </div>
                            <div>
                                <h6 class="fw-bold text-main mb-1">Teléfono</h6>
                                <p class="text-secondary-custom m-0">+58 412 555 5555</p>
                            </div>
                        </div>

                        <div class="d-flex gap-3 align-items-start">
                            <div
                                class="icon-circle bg-korange-soft text-korange d-flex align-items-center justify-content-center rounded-circle flex-shrink-0">
                                <MapPin :size="20" />
                            </div>
                            <div>
                                <h6 class="fw-bold text-main mb-1">Oficina</h6>
                                <p class="text-secondary-custom m-0">Av. Principal de Las Mercedes, Caracas, Venezuela.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Contact Form -->
                <div class="col-lg-6 offset-lg-1">
                    <div class="contact-card p-4 p-md-5 rounded-4 bg-surface shadow-lg border">
                        <h4 class="fw-bold mb-4 text-main">Envíanos un mensaje</h4>
                        <form @submit.prevent>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="form-floating">
                                        <input type="text" class="form-control" id="name" placeholder="Tu Nombre">
                                        <label for="name">Nombre</label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-floating">
                                        <input type="email" class="form-control" id="email"
                                            placeholder="nombre@ejemplo.com">
                                        <label for="email">Email</label>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="form-floating">
                                        <textarea class="form-control" placeholder="Deja tu mensaje aquí" id="message"
                                            style="height: 150px"></textarea>
                                        <label for="message">Mensaje</label>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <button
                                        class="btn btn-korange w-100 py-3 fw-bold d-flex align-items-center justify-content-center gap-2">
                                        Enviar Mensaje
                                        <Send :size="18" />
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>

<style scoped>
.contact-section {
    background-color: var(--bg-body);
}

.text-main {
    color: var(--text-main);
}

.tracking-wider {
    letter-spacing: 2px;
}

.icon-circle {
    width: 48px;
    height: 48px;
}

.bg-korange-soft {
    background-color: var(--KOrange-light);
}

/* Form Styles */
.bg-surface {
    background-color: var(--bg-surface);
    border-color: var(--border-color) !important;
}

.form-control {
    background-color: var(--bg-body);
    border-color: var(--border-color);
    color: var(--text-main);
}

.form-control:focus {
    color: var(--text-muted);
    border-color: var(--KOrange);
    box-shadow: 0 0 0 0.25rem rgba(253, 126, 20, 0.25);
}

.form-floating label {
    color: var(--text-secondary-custom);
}

/* Dark mode specific tweak not fully covered by vars */
@media (prefers-color-scheme: dark) {
    .bg-korange-soft {
        background-color: rgba(253, 126, 20, 0.15);
    }
}
</style>
