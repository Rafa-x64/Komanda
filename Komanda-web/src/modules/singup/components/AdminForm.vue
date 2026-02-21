<script setup lang='ts'>
import { ref } from 'vue';
import { ChevronsLeftIcon, ChevronsRightIcon } from 'lucide-vue-next';

const props = defineProps(['formData']);

const emit = defineEmits(['prev', 'submit']);

const handleSubmit = () => {
    emit('submit');
}
const handleBack = () => {
    emit('prev');
}
</script>
<template>
    <div class="col-12 col-md-6">
        <div class="card p-3 h-100">
            <div class="card-header">
                <h3 class="text-center text-korange">Datos de Administrador</h3>
            </div>
            <div class="card-body p-0 p-md-3">
                <form @submit.prevent="handleSubmit" class="form p-0">
                    <div class="row g-3">
                        <div class="col-12 col-lg-7">
                            <label for="nombre" class="form-label text-primary-custom">
                                Nombre Completo
                            </label>
                            <input v-model="formData.admin.name" type="text" name="nombre" id="nombre" class="form-control">
                        </div>
                        <div class="col-12 col-lg-5">
                            <label for="nombreUsuario" class="form-label text-primary-custom">
                                Nombre de usuario
                            </label>
                            <input v-model="formData.admin.userName" type="text" name="nombreUsuario" id="nombreUsuario" class="form-control">
                        </div>
                    </div>
                    <div class="row g-3">
                        <div class="col-12">
                            <label for="correoUsuario" class="form-label text-primary-custom">Correo Personal</label>
                            <input v-model="formData.admin.email" type="email" name="correoUsuario" id="correoUsuario" class="form-control">
                        </div>
                    </div>
                    <div class="row g-3">
                        <div class="col-12 col-lg-6">
                            <label for="contraseña" class="form-label text-primary-custom">
                                Contraseña
                            </label>
                            <input v-model="formData.admin.password" type="password" name="contraseña" id="contraseña" class="form-control">
                        </div>
                        <div class="col-12 col-lg-6">
                            <label for="confirmarContraseña" class="form-label text-primary-custom">
                                Confirmar Contraseña
                            </label>
                            <input v-model="formData.admin.confirmPassword" type="password" name="confirmarContraseña" id="confirmarContraseña" class="form-control">
                        </div>
                    </div>
                </form>
            </div>
            <div class="card-footer d-flex flex-row justify-content-center align-items-center">
                <div class="d-flex justify-content-between mt-4">
                    <button type="button" @click="emit('prev')"
                        class="btn btn-secondary rounded-pill px-4 d-flex align-items-center">
                        <ChevronLeftIcon size="20" class="me-2" /> Atrás
                    </button>

                    <button type="submit"
                        class="btn btn-korange text-white rounded-pill px-4 d-flex align-items-center">
                        Finalizar
                        <CheckIcon size="20" class="ms-2" />
                    </button>
                </div>
            </div>
    </div>
    </div>
</template>
<style scoped>

</style>