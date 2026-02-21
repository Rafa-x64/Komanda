<script setup lang='ts'>
import { ref } from 'vue';
import { ChevronsRight, ChevronsRightIcon } from 'lucide-vue-next';

</script>
<template>
    <div class="col-12 col-md-6">
        <div class="card p-3 h-100">
            <div class="card-header">
                <h3 class="text-center text-korange">Formulario de restaurante</h3>
            </div>
            <div class="card-body p-0 p-md-3">
                <form class="form p-0">
                    <div class="row g-3">
                        <div class="col-12 col-lg-6">
                            <label for="nombreRestaurant" class="form-label text-primary-custom">Nombre del
                                Restaurant
                            </label>
                            <input type="text" name="nombreRestaurant" id="nombreRestaurant" class="form-control">
                        </div>
                        <div class="col-12 col-lg-6">
                            <label for="telefono" class="form-label text-primary-custom">
                                Telefono
                            </label>
                            <input type="tel" name="telefonoRestaurant" id="telefonoRestaurant" class="form-control">
                        </div>
                    </div>
                    <label for="direccionRestaurant" class="form-label text-primary-custom">Direccion</label>
                    <textarea name="direccionRestaurant" id="direccionRestaurant" class="form-control"></textarea>
                    <label for="correo" class="form-label text-primary-custom">Correo Contacto</label>
                    <input type="email" name="correoRestaurant" id="correoRestaurant" class="form-control">
                    <div class="row g-3">
                        <div class="col-12 col-lg-6">
                            <label for="monedaRestaurant" class="form-label text-primary-custom">Moneda</label>
                            <select name="monedaRestaurant" id="monedaRestaurant" class="form-select">
                                <option value="USD">Dolares</option>
                                <option value="EUR">Euros</option>
                                <option value="VES">Bolivarez</option>
                            </select>
                        </div>
                        <div class="col-12 col-lg-6">
                            <label for="zonaRestaurant" class="form-label text-primary-custom">Zona</label>
                            <select name="zonaRestaurant" id="zonaRestaurant" class="form-select">
                                <option value="America/Caracas">America/Caracas</option>
                                <option value="America/Bogota">America/Bogota</option>
                                <option value="America/Lima">America/Lima</option>
                            </select>
                        </div>
                    </div>
                    <div class="row g-3">
                        <div class="col-12 col-lg-6">
                            <label for="impuestoRestaurant" class="form-label text-primary-custom">Impuesto
                                Restaurant</label>
                            <input type="number" name="impuestoRestaurant" id="impuestoRestaurant" class="form-control">
                        </div>
                        <div class="col-12 col-lg-6">
                            <label for="propinaRestaurant" class="form-label text-primary-custom">Propina
                                Restaurant</label>
                            <input type="number" name="propinaRestaurant" id="propinaRestaurant" class="form-control">
                        </div>
                    </div>
                    <label for="logoRestaurant" class="form-label text-primary-custom">Logo Restaurant</label>
                    <input type="file" name="logoRestaurant" id="logoRestaurant" class="form-control">
                </form>
            </div>
            <div class="card-footer d-flex flex-row justify-content-center align-items-center">
                <div class="col-10 col-md-7">
                    <button type="submit"
                        class="btn-outline-korange border-2 rounded-pill p-2 text-uppercase w-100 d-flex flex-row justify-content-center align-items-center">
                        <p class="m-0">siguiente</p>
                        <ChevronsRightIcon size:20 />
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>
<style scoped></style>