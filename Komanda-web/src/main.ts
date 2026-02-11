import { createApp } from 'vue'
import router from './router'
import './style.css'
import './assets/main.css' // Tus estilos aquí
import 'bootstrap' // Esto importa el JS de Bootstrap
import App from './App.vue'

createApp(App).use(router).mount('#app')
