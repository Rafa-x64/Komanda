<script setup lang='ts'>
import { ref } from 'vue';
import AdminForm from '../components/AdminForm.vue';
import RestaurantForm from '../components/RestaurantForm.vue';

</script>
<template>
    <div class="container-fluid d-flex justify-content-center align-items-center min-vh-100 p-0 m-0">
        <div class="row w-100 w-md-75 g-3 p-2">
            <RestaurantForm />
            <AdminForm />
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

@media(prefers-color-scheme: light){
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
            border-color: var(--KOrange-hover)!important
        }
    
        .form-control:focus {
            background-color: var(--bg-body);
            box-shadow: 0 0 0 0.25rem var(--KOrange-hover);
            color: var(--text-primary);
        }
}

@media(prefers-color-scheme: dark){
    .container-fluid, .card, .form{
        background-color: var(--bg-body);
    }

    .form-control{
        background-color: var(--bg-surface);
        transition: background-color 0.1s ease-in, box-shadow 0.1s ease-in, border var(--transition-speed) ease-in;
        color: var(--text-primary);
    }

    .form-control:hover{
        border-color: var(--KOrange-hover)
    }

    .form-control:focus{
        background-color: var(--bg-body);
        box-shadow: 0 0 0 0.25rem var(--KOrange-hover);
        color: var(--text-primary);
    }
}

@media(prefers-color-scheme: light){

}
</style>