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
            path: '/registro-ingredientes',
            name: 'ingredientes',
            component: () => import('../modules/recipe-ingredient-entry/views/RecipeCrudView.vue')
        }
        //registrar singin
    ]
});

export default router;