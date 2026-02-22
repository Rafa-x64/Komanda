<script setup lang='ts'>
import { ref, computed } from 'vue';
import { LogInIcon } from 'lucide-vue-next';
import { useRouter } from 'vue-router';

const router = useRouter();

const formData = ref({
    username: '',
    password: '',
    restaurantName: '',
});

const handleSubmit = async () => {
    try {
        const respuesta = await fetch("http://localhost:3000/api/v1/signin/login", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(formData.value)
        });

        const text = await respuesta.text();
        let data;
        try {
            data = JSON.parse(text);
        } catch (e) {
            alert(`Error del servidor: ${respuesta.status}`);
            return;
        }

        if (!respuesta.ok) {
            alert(`Error al iniciar sesión: ${data.message || 'Verifica los datos'}`);
            return;
        }

        alert("¡Inicio de sesión exitoso!");
        router.push('/dashboard');
    } catch (error) {
        console.error("Error de conexión:", error);
        alert("No se pudo conectar con el servidor, revisa si está encendido.");
    }
};
</script>
<template>
    <div class="signin-page">
        <div class="signin-wrapper">

            <!-- Izquierda: Imagen Estática (solo desktop/tablet) -->
            <div class="signin-image">
                <img src="../../../assets/ImagenSingUp.jpeg" alt="SignIn">
            </div>

            <!-- Derecha: Formulario -->
            <div class="signin-form-panel">
                <div class="signin-form-content">
                    <div class="text-center mb-3">
                        <h3 class="text-korange mb-1">Bienvenido</h3>
                        <p class="text-secondary-custom small">Inicia sesión en tu cuenta</p>
                    </div>
                    <form @submit.prevent="handleSubmit">
                        <div class="mb-3">
                            <label for="identifier" class="form-label text-primary-custom">
                                Usuario o Correo
                            </label>
                            <input v-model="formData.username" type="text" name="identifier" id="identifier"
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
                            class="btn-korange text-white rounded-pill w-100 d-flex justify-content-center align-items-center py-2">
                            Iniciar Sesión
                            <LogInIcon :size="18" class="ms-2" />
                        </button>
                    </form>
                    <div class="text-center mt-4">
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

<style scoped>
.signin-page {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    padding: 1rem;
    background-color: var(--bg-body);
}

.signin-wrapper {
    display: flex;
    width: 100%;
    max-width: 1100px;
    min-height: 520px;
    max-height: 90vh;
    border-radius: 0.75rem;
    overflow: hidden;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.25);
    background-color: var(--bg-surface);
}

/* Panel de imagen */
.signin-image {
    flex: 0 0 45%;
    display: none;
}

.signin-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

/* Panel del formulario */
.signin-form-panel {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 2.5rem 2rem;
    overflow-y: auto;
}

.signin-form-content {
    width: 100%;
    max-width: 400px;
}

/* ── Responsive: Tablet (≥768px) ── */
@media (min-width: 768px) {
    .signin-page {
        padding: 2rem;
    }

    .signin-image {
        display: block;
    }

    .signin-form-panel {
        padding: 3rem 2.5rem;
    }
}

/* ── Responsive: Phones (<768px) ── */
@media (max-width: 767.98px) {
    .signin-page {
        padding: 1rem;
        align-items: flex-start;
        padding-top: 3rem;
    }

    .signin-wrapper {
        flex-direction: column;
        max-height: none;
        min-height: auto;
        border-radius: 1rem;
    }

    .signin-form-panel {
        padding: 2rem 1.5rem;
    }
}

/* ── Phones muy pequeños (<400px) ── */
@media (max-width: 399.98px) {
    .signin-page {
        padding: 0.5rem;
        padding-top: 2rem;
    }

    .signin-form-panel {
        padding: 1.5rem 1rem;
    }
}
</style>
