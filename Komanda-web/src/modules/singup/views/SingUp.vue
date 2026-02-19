<script setup lang='ts'>
import { ref } from 'vue';

</script>
<template>
    <div class="background-wrapper">
        <div class="container-fluid content-layer d-flex flex-column justify-content-center align-items-center">
            <div class="row w-75 p-1 d-md-none">
                <!--para movil-->
                <div class="col-12">Col 1</div>
                <div class="col-12">Col 2</div>
            </div>
            <div class="row w-75 p-1 d-none d-md-flex">
                <!--para pc y tablet-->
                <div class="col-6">Col 1</div>
                <div class="col-6">Col 2</div>
            </div>
        </div>
    </div>
</template>
<style scoped>
.background-wrapper {
    position: relative;
    min-height: 100vh;
    overflow: hidden;
}

.background-wrapper::before {
    content: '';
    position: absolute;
    inset: 0;
    background-image: url(../../../assets/singin-singup-image.jpeg);
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    filter: blur(5px);
    transform: scale(1.1);
    z-index: 0;
}

.content-layer {
    position: relative;
    z-index: 1;
}

[class^="col"] {
    border: 1px solid blue;
    background: rgba(255, 255, 255, 0.7);
}

[class^="row"] {
    border: 1px solid red;
}
</style>