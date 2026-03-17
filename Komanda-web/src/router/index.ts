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
            path: '/dashboard',
            name: 'Admin-Dashboard',
            component: () => import('../modules/dashboard/AdminDashboard.vue')
        },

        {
            path: '/mesero-dashboard',
            name: 'Mesero-Dashboard',
            component: () => import('../modules/dashboard/MeseroDashboard.vue')
        },
        {
            path: '/caja-dashboard',
            name: 'Caja-Dashboard',
            component: () => import('../modules/dashboard/CajaDashboard.vue')
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
        },
        {
            path: '/menu',
            name: 'menu',
            component: () => import('../modules/recipe-ingredient-entry/views/RecipeCrudView.vue')
        },
        {
            path: '/pos',
            name: 'pos',
            component: () => import('../modules/pos/views/PosView.vue')
        }
    ]
});

export default router;