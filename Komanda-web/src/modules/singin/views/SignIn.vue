<script setup lang='ts'>
import { ref } from 'vue';
import { LogInIcon } from 'lucide-vue-next';

const formData = ref({
    identifier: '',
    password: '',
    restaurantName: '',
});

const handleSubmit = () => {
    console.log('Iniciando sesión...', formData.value);
};
</script>
<template>
    <div class="container-fluid d-flex justify-content-center align-items-center min-vh-100 p-0 m-0">
        <!-- Wrapper principal de 75vh -->
        <div class="row w-100 m-2 shadow-lg"
            style="height: 75vh; border-radius: 0.5rem; overflow: hidden; max-width: 1200px; background-color: var(--bg-surface);">

            <!-- Izquierda: Imagen Estática -->
            <div class="col-6 d-none d-md-block p-0 m-0 h-100">
                <img src="../../../assets/ImagenSingUp.jpeg" alt="SignIn" class="img-fluid w-100 h-100"
                    style="object-fit: cover;">
            </div>

            <!-- Derecha: Formulario -->
            <div class="col-12 col-md-6 m-0 h-100 d-flex align-items-center justify-content-center">
                <div class="card border-0 rounded-0 bg-transparent w-100 p-4">
                    <div class="card-header border-0 bg-transparent text-center mb-3">
                        <h3 class="text-korange mb-1">Bienvenido</h3>
                        <p class="text-secondary-custom small">Inicia sesión en tu cuenta</p>
                    </div>
                    <form @submit.prevent="handleSubmit" class="form p-0 bg-transparent px-2">
                        <div class="mb-3">
                            <label for="identifier" class="form-label text-primary-custom">
                                Usuario o Correo
                            </label>
                            <input v-model="formData.identifier" type="text" name="identifier" id="identifier"
                                class="form-control" placeholder="nombre_usuario o correo@ejemplo.com" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label text-primary-custom">
                                Contraseña
                            </label>
                            <input v-model="formData.password" type="password" name="password" id="password"
                                class="form-control" placeholder="••••••••" required>
                        </div>
                        <div class="mb-4">
                            <label for="restaurantName" class="form-label text-primary-custom">
                                Nombre del Restaurante
                            </label>
                            <input v-model="formData.restaurantName" type="text" name="restaurantName"
                                id="restaurantName" class="form-control" placeholder="Mi Restaurante" required>
                        </div>
                        <button type="submit"
                            class="btn btn-korange text-white rounded-pill w-100 d-flex justify-content-center align-items-center py-2">
                            Iniciar Sesión
                            <LogInIcon :size="18" class="ms-2" />
                        </button>
                    </form>
                    <div class="card-footer border-0 bg-transparent text-center mt-4">
                        <p class="text-secondary-custom small mb-0">
                            ¿No tienes cuenta?
                            <router-link to="/singup" class="text-korange text-decoration-none fw-semibold">
                                Regístrate aquí
                            </router-link>
                        </p>
                    </div>
                </div>
            </div>

        </div>
    </div>
</template>
<style>
@media(prefers-color-scheme: light) {

    .container-fluid,
    .card,
    .form {
        background-color: var(--bg-surface) !important;
    }
}

@media(prefers-color-scheme: dark) {

    .container-fluid,
    .card,
    .form {
        background-color: var(--bg-body) !important;
    }

    .card,
    .form {
        background-color: var(--bg-surface) !important;
    }
}
</style>
