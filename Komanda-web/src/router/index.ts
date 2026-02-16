import { createRouter, createWebHistory } from "vue-router";

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: '/',
            name: 'home',
            component: () => import('../modules/landing/views/LandingView.vue')
        },
        {
            path: '/cocina',
            name: 'kitchen',
            component: () => import('../modules/kitchen/views/KitchenStatus.vue')
        },
        {
            path: '/crear-cuenta',
            name: 'sing-up',
            component: () => import('../modules/singup/views/SingUp.vue')
        }
    ]
});

export default router;