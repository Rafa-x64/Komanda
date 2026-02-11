<script setup lang='ts'>
import { ref } from 'vue';
import { Facebook, Instagram, Mail, Linkedin, Twitter, PhoneCall } from 'lucide-vue-next';
</script>
<template>
    <header class="d-flex flex-column py-4">
        <div class="row d-flex flex-row justify-content-center align-items-between">
            <div class="col-4 d-flex flex-row gap-4 justify-content-start align-items-center my-2">
                <Facebook :size="22" class="AppHeader-icon" />
                <Instagram :size="22" class="AppHeader-icon" />
                <Mail :size="22" class="AppHeader-icon" />
                <Linkedin :size="22" class="AppHeader-icon" />
                <Twitter :size="22" class="AppHeader-icon" />
            </div>
            <div class="col-7">
                <div class="row">
                    <div class="col-6 d-flex flex-row justify-content-center align-items-center gap-2">
                        <PhoneCall :size="18" class="text-muted" />
                        <p class="AppHeader-sm-text text-muted m-0 p-0">¿Tienes preguntas? Llama al 0412-555-55-55</p>
                    </div>
                    <div class="col-1 d-flex flex-row justify-content-center align-items-center">
                        <h2 class="AppHeader-lg-slash text-muted m-0 p-0">/</h2>
                    </div>
                    <div class="col-5 d-flex flex-row justify-content-center align-items-center gap-2">
                        <Mail :size="18" class="text-muted" />
                        <p class="AppHeader-sm-text text-muted m-0 p-0">¿Necesitas ayuda? Mandanos un correo</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="row d-flex flex-row justify-content-center align-items-center">
            <div class="col-10 my-3" style="border-top: 2px solid #595C5F"></div>
        </div>
        <div class="row px-5">
            <div class="col-3 justify-self-center">

            </div>
            <div class="col-9 d-flex flex-row justify-content-end align-items-center px-3 m-0">
                <ul class="d-flex flex-row list list-inline decoration-none gap-4">
                    <li class="list-inline-item">Inicio</li>
                    <li class="list-inline-item">Acerca de Nosotros</li>
                    <li class="list-inline-item">Contacto</li>
                </ul>
            </div>
        </div>
    </header>
</template>
<style scoped>
.AppHeader-sm-text{
    font-size: 14px;
}
.AppHeader-lg-slash{
    font-weight: 200;
}
.AppHeader-icon:hover{
    transition: all 0.3s ease-in-out;
    color: var(--KOrange);
    transform: scale(1.2);
}
</style>