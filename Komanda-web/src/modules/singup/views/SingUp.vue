<script setup lang='ts'>
import { ref, computed } from 'vue';
import AdminForm from '../components/AdminForm.vue';
import RestaurantForm from '../components/RestaurantForm.vue';

const formData = ref({
    restaurant: {
        name: '',
        phone: '',
        address: '',
        email: '',
        currency: '',
        zone: '',
        tax: '',
        tip: '',
        restaurantLogo: '',
    },
    admin: {
        name: '',
        userName: '',
        email: '',
        password: '',
        confirmPassword: '',
    }
});

const currentStepIndex = ref(0);

const steps = [RestaurantForm, AdminForm];

const CurrentStepComponent = computed(() => steps[currentStepIndex.value]);

const nextStep = () => {
    if (currentStepIndex.value < steps.length - 1) {
        currentStepIndex.value++;
    }
};

const prevStep = () => {
    if (currentStepIndex.value > 0) {
        currentStepIndex.value--;
    }
};

const submitWizard = () => {
    console.log("Enviando a la bd...", formData.value);
}
</script>
<template>
    <div class="container-fluid d-flex justify-content-center align-items-center min-vh-100 p-0 m-0">
        <!-- Wrapper principal de 75vh -->
        <div class="row w-100 w-md-75 m-2 shadow-lg"
            style="height: 75vh; border-radius: 0.5rem; overflow: hidden; max-width: 1200px; background-color: var(--bg-surface);">

            <!-- Izquierda: Imagen Estática -->
            <div class="col-6 d-none d-md-block p-0 m-0 h-100">
                <img src="../../../assets/ImagenSingUp.jpeg" alt="SingUp" class="img-fluid w-100 h-100"
                    style="object-fit: cover;">
            </div>

            <!-- Derecha: Area Escroleable de Formularios -->
            <div class="col-12 col-md-6 p-0 m-0 h-100 formularios">
                <transition name="fade" mode="out-in">
                    <div :key="currentStepIndex" class="h-100 w-100">
                        <component :is="CurrentStepComponent" :form-data="formData" @next="nextStep" @prev="prevStep"
                            @submit="submitWizard" />
                    </div>
                </transition>
            </div>

        </div>
    </div>
</template>
<style>
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.3s ease, transform 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
    opacity: 0;
    transform: translateX(10px);
}

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

.formularios {
    height: 100%;
    overflow-y: auto;
    overflow-x: hidden;
    scroll-behavior: smooth;
    -webkit-overflow-scrolling: touch;
}

.formularios::-webkit-scrollbar {
    width: 8px;
}

.formularios::-webkit-scrollbar-track {
    background: transparent;
}

.formularios::-webkit-scrollbar-thumb {
    background-color: var(--KOrange, #ff7a00);
    /* Fallback si var no disponible en global scope local, idealmente usa var(--KOrange) u opacity */
    border-radius: 20px;
    border: 3px solid transparent;
    background-clip: padding-box;
}

.formularios::-webkit-scrollbar-thumb:hover {
    background-color: var(--KOrange-hover, #e06900);
}

@media(prefers-color-scheme: light) {}
</style>