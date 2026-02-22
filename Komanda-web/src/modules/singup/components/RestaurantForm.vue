<script setup lang='ts'>
import { ChevronsRightIcon } from 'lucide-vue-next';
const props = defineProps(['formData']);
const emit = defineEmits(['next']);
const handleNext = () => {
    emit('next');
}
const handleFile = (event: Event) => {
    const file = (event.target as HTMLInputElement).files?.[0];
    if (file) {
        // Esto genera una URL temporal que vive en la memoria del navegador
        props.formData.restaurant.restaurantLogo = URL.createObjectURL(file);
    }
};

</script>
<template>
    <div class="card p-3 h-100 border-0 rounded-0 bg-transparent">
        <div class="card-header border-0 bg-transparent">
            <h3 class="text-center text-korange">Datos del Restaurante</h3>
        </div>
        <form @submit.prevent="handleNext" class="form p-0 bg-transparent">
            <div class="card-body p-0 p-md-3 bg-transparent">

                <div class="row g-3">
                    <div class="col-12 col-lg-6">
                        <label for="nombreRestaurant" class="form-label text-primary-custom">Nombre del
                            Restaurant
                        </label>
                        <input v-model="formData.restaurant.name" type="text" name="nombreRestaurant"
                            id="nombreRestaurant" class="form-control" required>
                    </div>
                    <div class="col-12 col-lg-6">
                        <label for="telefono" class="form-label text-primary-custom">
                            Telefono
                        </label>
                        <input v-model="formData.restaurant.phone" type="tel" name="telefonoRestaurant"
                            id="telefonoRestaurant" class="form-control" required>
                    </div>
                </div>
                <label for="direccionRestaurant" class="form-label text-primary-custom">Direccion</label>
                <textarea v-model="formData.restaurant.address" name="direccionRestaurant" id="direccionRestaurant"
                    class="form-control" required></textarea>
                <label for="correo" class="form-label text-primary-custom">Correo Contacto</label>
                <input v-model="formData.restaurant.email" type="email" name="correoRestaurant" id="correoRestaurant"
                    class="form-control" required>
                <div class="row g-3">
                    <div class="col-12 col-lg-6">
                        <label for="monedaRestaurant" class="form-label text-primary-custom">Moneda</label>
                        <select v-model="formData.restaurant.currency" name="monedaRestaurant" id="monedaRestaurant"
                            class="form-select">
                            <option value="USD">Dolares</option>
                            <option value="EUR">Euros</option>
                            <option value="VES">Bolivarez</option>
                        </select>
                    </div>
                    <div class="col-12 col-lg-6">
                        <label for="zonaRestaurant" class="form-label text-primary-custom">Zona</label>
                        <select v-model="formData.restaurant.zone" name="zonaRestaurant" id="zonaRestaurant"
                            class="form-select">
                            <option value="America/Caracas">America/Caracas</option>
                            <option value="America/Bogota">America/Bogota</option>
                            <option value="America/Lima">America/Lima</option>
                        </select>
                    </div>
                </div>
                <div class="row g-3">
                    <div class="col-12 col-lg-6">
                        <label for="impuestoRestaurant" class="form-label text-primary-custom">Porcentaje
                            Impuesto</label>
                        <input v-model="formData.restaurant.tax" type="number" name="impuestoRestaurant"
                            id="impuestoRestaurant" min="0" max="100" step="0.50" class="form-control">
                    </div>
                    <div class="col-12 col-lg-6">
                        <label for="propinaRestaurant" class="form-label text-primary-custom">Porcentaje
                            Propina</label>
                        <input v-model="formData.restaurant.tip" type="number" name="propinaRestaurant"
                            id="propinaRestaurant" min="0" max="100" step="0.50" class="form-control">
                    </div>
                </div>
                <label for="logoRestaurant" class="form-label text-primary-custom">Logo Restaurant</label>
                <input accept="image/*" @change="handleFile" type="file" name="logoRestaurant" id="logoRestaurant"
                    class="form-control">

            </div>
            <div class="card-footer bg-transparent border-0 d-flex flex-row justify-content-center align-items-center">
                <div class="d-flex justify-content-end mt-4">
                    <button type="submit"
                        class="btn-outline-korange border-2 rounded-pill p-2 text-uppercase w-100 d-flex flex-row justify-content-center align-items-center">
                        <p class="m-0">siguiente</p>
                        <ChevronsRightIcon :size="20" />
                    </button>
                </div>
            </div>
        </form>
    </div>
</template>
<style scoped></style>