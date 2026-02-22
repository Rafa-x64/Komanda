<script setup lang='ts'>
import { ref, onMounted } from 'vue';
//1. estado reactivo (variables que cambian)
const phpStats = ref<any>(null);//datos de php
const nodeStatus = ref<any>(null);//datos de node
const loading = ref(true);

//2. funcion para pedir datos (conexion entre front y back)
const fetchData = async () => {
    try {
        //peticion a PHP en el puerto 8000
        const resPHP = await fetch('http://localhost:8000/api/stats.php');
        const jsonPHP = await resPHP.json();
        phpStats.value = jsonPHP.data

        //peticion a node con TS
        const resNode = await fetch('http://localhost:3000/api/v1/kitchen/status');
        const jsonNode = await resNode.json();
        nodeStatus.value = jsonNode.data;
    } catch (error) {
        console.error("Error conectando con el back: ", error)
    } finally {
        loading.value = false; //ya termino de cargar luego de la respuesta
    }
}

//3. ciclo de vida: Ejecutar al montar el componente
onMounted(() => {
    fetchData();
});
</script>

<template>
    <div class="container py-5">
        <h1 class="mb-4 text-primary fw-bold">Monitor de cocina</h1>
        <div v-if="loading" class="alert alert-info">
            Conectando con los servidores
        </div>
        <div v-else class="row g-4">
            <div class="col-md-6">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-body">
                        <h5 class="card-title text-muted">
                            Estado del Servicio (Node TS)
                        </h5>
                        <div v-if="nodeStatus?.is_open" class="d-flex align-items-center">
                            <span class="badge bg-success me-2">
                                ABIERTO
                            </span>
                            <p class="mb-0">{{ nodeStatus.message }}</p>
                        </div>
                        <div class="mt-3">
                            <strong>Chefs Activos:</strong>{{ nodeStatus.active_chefs }}
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card shadow-sm border-0 h-100 bg-light">
                    <div class="card-body">
                        <h5 class="card-title text-muted">Métricas de Rendimiento (PHP)</h5>
                        <ul class="list-group list-group-flush bg-transparent">
                            <li class="list-group-item bg-transparent d-flex justify-content-between">
                                <span>Total Pedidos:</span>
                                <strong>{{ phpStats?.total_orders }}</strong>
                            </li>
                            <li class="list-group-item bg-transparent d-flex justify-content-between">
                                <span>Tiempo Promedio:</span>
                                <strong>{{ phpStats?.avg_prep_time }}</strong>
                            </li>
                            <li class="list-group-item bg-transparent d-flex justify-content-between">
                                <span>Plato Estrella:</span>
                                <span class="text-primary">{{ phpStats?.top_dish }}</span>
                            </li>
                        </ul>
                        <!-- Barra de progreso con Bootstrap -->
                        <div class="mt-3">
                            <label class="small text-muted">Eficiencia</label>
                            <div class="progress" style="height: 10px;">
                                <div class="progress-bar bg-warning" role="progressbar"
                                    :style="{ width: phpStats?.efficiency_score + '%' }"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.card {
    transition: transform 0.2s;
}

.card:hover {
    transform: translateY(-5px);
}
</style>