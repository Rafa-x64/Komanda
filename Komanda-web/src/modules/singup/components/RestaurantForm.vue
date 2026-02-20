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
            <div class="card-body">
                <form class="form">
                    <label for="nombreNegocio" class="form-label text-primary-custom">Nombre del Negocio</label>
                    <input type="text" name="nombreNegocio" id="nombreNegocio" class="form-control">
                    <label for="" class="form-label"></label>
                    <input type="text" name="" id="" class="form-control">
                    <label for="" class="form-label"></label>
                    <input type="text" name="" id="" class="form-control">
                    <label for="" class="form-label"></label>
                    <input type="text" name="" id="" class="form-control">
                    <label for="" class="form-label"></label>
                    <input type="text" name="" id="" class="form-control">
                    <label for="" class="form-label"></label>
                    <input type="text" name="" id="" class="form-control">
                    <label for="" class="form-label"></label>
                    <input type="text" name="" id="" class="form-control">
                    <label for="" class="form-label"></label>
                    <input type="text" name="" id="" class="form-control">
                </form>
            </div>
            <div class="card-footer d-flex flex-row justify-content-center align-items-center">
                <div class="col-10 col-md-7">
                    <button type="submit" class="btn-outline-korange border-2 rounded-pill p-2 text-uppercase w-100 d-flex flex-row justify-content-center align-items-center">
                        <p class="m-0">siguiente</p>
                        <ChevronsRightIcon size:20/>
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>
<style scoped>

</style>