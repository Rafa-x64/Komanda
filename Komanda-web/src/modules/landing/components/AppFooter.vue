<script setup lang='ts'>
import { Facebook, Instagram, Linkedin, Twitter, Heart } from 'lucide-vue-next';
</script>

<template>
    <footer class="app-footer py-5 border-top">
        <div class="container">
            <div class="row gy-4">
                <div class="col-lg-4">
                    <div class="d-flex align-items-center gap-2 mb-3">
                        <span class="fs-4 fw-bold text-korange">KOMANDA</span>
                    </div>
                    <p class="text-secondary-custom mb-4">
                        Revolucionando la gestión gastronómica en Venezuela y el mundo.
                    </p>
                    <div class="d-flex gap-3">
                        <a href="#" class="social-btn">
                            <Facebook :size="20" />
                        </a>
                        <a href="#" class="social-btn">
                            <Instagram :size="20" />
                        </a>
                        <a href="#" class="social-btn">
                            <Twitter :size="20" />
                        </a>
                        <a href="#" class="social-btn">
                            <Linkedin :size="20" />
                        </a>
                    </div>
                </div>

                <div class="col-6 col-lg-2">
                    <h6 class="fw-bold mb-3 text-main">Producto</h6>
                    <ul class="list-unstyled d-flex flex-column gap-2">
                        <li><a href="#" class="footer-link">Características</a></li>
                        <li><a href="#" class="footer-link">Precios</a></li>
                        <li><a href="#" class="footer-link">Integraciones</a></li>
                        <li><a href="#" class="footer-link">Actualizaciones</a></li>
                    </ul>
                </div>

                <div class="col-6 col-lg-2">
                    <h6 class="fw-bold mb-3 text-main">Compañía</h6>
                    <ul class="list-unstyled d-flex flex-column gap-2">
                        <li><a href="#" class="footer-link">Nosotros</a></li>
                        <li><a href="#" class="footer-link">Carreras</a></li>
                        <li><a href="#" class="footer-link">Blog</a></li>
                        <li><a href="#" class="footer-link">Contacto</a></li>
                    </ul>
                </div>

                <div class="col-lg-4">
                    <h6 class="fw-bold mb-3 text-main">Suscríbete</h6>
                    <p class="text-secondary-custom small mb-3">Recibe las últimas noticias y consejos para tu restaurante.</p>
                    <div class="input-group mb-3">
                        <input type="email" class="form-control" placeholder="Tu correo electrónico">
                        <button class="btn btn-korange" type="button">Enviar</button>
                    </div>
                </div>
            </div>

            <div class="row mt-5 pt-4 border-top">
                <div class="col-md-6 text-center text-md-start">
                    <p class="small text-secondary-custom mb-0">
                        &copy; 2024 Komanda. Todos los derechos reservados.
                    </p>
                </div>
                <div class="col-md-6 text-center text-md-end">

                </div>
            </div>
        </div>
    </footer>
</template>

<style scoped>
.app-footer {
    background-color: var(--bg-surface);
    color: var(--text-secondary-custom);
}

.text-main {
    color: var(--text-main);
}

.border-top {
    border-color: var(--border-color) !important;
}

.social-btn {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    background-color: var(--bg-body);
    color: var(--text-secondary-custom);
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all var(--transition-speed);
    border: 1px solid var(--border-color);
}

.social-btn:hover {
    background-color: var(--KOrange);
    color: white;
    border-color: var(--KOrange);
    transform: translateY(-2px);
}

.footer-link {
    color: var(--text-muted);
    text-decoration: none;
    transition: color 0.2s ease;
    font-size: 0.95rem;
}

.footer-link:hover {
    color: var(--KOrange);
}

.form-control {
    background-color: var(--bg-body);
    border-color: var(--border-color);
    color: var(--text-main);
}

.form-control:focus {
    border-color: var(--KOrange);
    box-shadow: 0 0 0 0.25rem rgba(253, 126, 20, 0.25);
}
</style>
