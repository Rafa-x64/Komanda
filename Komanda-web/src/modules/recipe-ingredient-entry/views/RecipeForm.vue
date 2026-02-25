

<template>
<div class="modulo-ingredientes">
    <h2>Registro de Ingredientes</h2>
    <form @submit.prevent="validarRegistro" class="form-container">
        <input v-model="ingrediente.nombre" type="text" class="form-control mb-3" placeholder="Nombre (Ej: Harina)" required>
        <input v-model.number="ingrediente.cantidad" type="number" class="form-control mb-3" placeholder="Cantidad" required>
        <button type="submit" class="btn btn-korange w-100">Registrar</button>
    </form>
</div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

const ingrediente = ref({ nombre: '', cantidad: 0 });

const validarRegistro = () => {
  // Patrón Regex: Solo letras y espacios (3 a 30 caracteres)
const regex = /^[a-zA-ZÀ-ÿ\s]{3,30}$/;

if (!regex.test(ingrediente.value.nombre)) {
    alert("Error: El nombre debe tener solo letras y entre 3 y 30 caracteres.");
    return;
}

alert("¡Validación exitosa! Guardando ingrediente...");
  // Aquí iría el código para guardar en la base de datos
};
</script>

<style scoped>
/* Estos estilos usarán las clases de tu style.css automáticamente */
.modulo-container { padding: 2rem; }
</style>