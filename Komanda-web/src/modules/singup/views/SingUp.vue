<script setup lang='ts'>
import { ref, computed, shallowRef } from 'vue';
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
        <div class="row w-100 w-md-75 g-3 p-2 d-flex justify-content-center">
            <transition name="fade" mode="out-in">
                <component :is="CurrentStepComponent" :form-data="formData" @next="nextStep" @prev="prevStep" @submit="submitWizard"/>
            </transition>
        </div>
    </div>
</template>
<style>
[class^="container"] {
    border: 1px solid black;
}

[class^="col"] {
    border: 1px solid blue;
}

[class^="row"] {
    border: 1px solid red;
}

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
        background-color: var(--bg-body);
    }

    .form-control {
        background-color: var(--bg-surface);
        transition: background-color 0.1s ease-in, box-shadow 0.1s ease-in, border var(--transition-speed) ease-in;
        color: var(--text-primary);
    }

    .form-control:hover {
        border-color: var(--KOrange-hover) !important
    }

    .form-control:focus {
        background-color: var(--bg-body);
        box-shadow: 0 0 0 0.25rem var(--KOrange-hover);
        color: var(--text-primary);
    }
}

@media(prefers-color-scheme: dark) {

    .container-fluid,
    .card,
    .form {
        background-color: var(--bg-body);
    }

    .form-control {
        background-color: var(--bg-surface);
        transition: background-color 0.1s ease-in, box-shadow 0.1s ease-in, border var(--transition-speed) ease-in;
        color: var(--text-primary);
    }

    .form-control:hover {
        border-color: var(--KOrange-hover)
    }

    .form-control:focus {
        background-color: var(--bg-body);
        box-shadow: 0 0 0 0.25rem var(--KOrange-hover);
        color: var(--text-primary);
    }

    .form-control::file-selector-button {
        background-color: var(--KOrange);
        color: white;
        border: none;
        border-inline-end-width: 1px;
        border-inline-end-style: solid;
        border-color: inherit;
        padding: 0.375rem 0.75rem;
        margin-inline-start: -0.75rem;
        margin-inline-end: 0.75rem;
        transition: all 0.2s ease-in-out;
        cursor: pointer;
    }

    .form-control:hover::file-selector-button {
        background-color: var(--KOrange-hover) !important;
    }

    .form-select {
        background-color: var(--bg-surface);
        transition: background-color 0.1s ease-in, box-shadow 0.1s ease-in, border var(--transition-speed) ease-in;
        color: var(--text-primary);
    }

    .form-select:hover {
        border-color: var(--KOrange-hover)
    }

    .form-select:focus {
        background-color: var(--bg-body);
        box-shadow: 0 0 0 0.25rem var(--KOrange-hover);
        color: var(--text-primary);
    }

    label {
        margin-top: 0.65rem;
    }
}

@media(prefers-color-scheme: light) {}
</style>