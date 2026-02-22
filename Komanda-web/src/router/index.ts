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
            path: '/kitchen',
            name: 'kitchen',
            component: () => import('../modules/kitchen/views/KitchenStatus.vue')
        },
        {
            path: '/singup',
            name: 'singup',
            component: () => import('../modules/singup/views/SingUp.vue')
        },
        {
            path: '/singin',
            name: 'singin',
            component: () => import('../modules/singin/views/SignIn.vue')
        }
    ]
});

export default router;