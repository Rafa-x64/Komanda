import { createRouter, createWebHistory } from "vue-router";
import { useAuth } from "../core/composables/useAuth";

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
            component: () => import('../modules/kitchen/views/KitchenStatus.vue'),
            meta: { requiresAuth: true, roles: ['admin', 'cocina'] }
        },
        /* ----- Dashboards por Rol ----- */
        {
            path: '/dashboard',
            name: 'Admin-Dashboard',
            component: () => import('../modules/dashboard/AdminDashboard.vue'),
            meta: { requiresAuth: true, roles: ['admin'] }
        },
        {
            path: '/mesero-dashboard',
            name: 'Mesero-Dashboard',
            component: () => import('../modules/waiter/views/WaiterDashboardView.vue'),
            meta: { requiresAuth: true, roles: ['admin', 'mesero'] }
        },
        {
            path: '/caja-dashboard',
            name: 'Caja-Dashboard',
            component: () => import('../modules/dashboard/CajaDashboard.vue'),
            meta: { requiresAuth: true, roles: ['admin', 'cajero'] }
        },
        {
            path: '/cocina-dashboard',
            name: 'Cocina-Dashboard',
            component: () => import('../modules/dashboard/CocinaDashboard.vue'),
            meta: { requiresAuth: true, roles: ['admin', 'cocina'] }
        },
        /* ----- Empleados (Solo Admin) ----- */
        {
            path: '/empleados',
            name: 'empleados',
            component: () => import('../modules/employees/views/EmployeesView.vue'),
            meta: { requiresAuth: true, roles: ['admin'] }
        },
        {
            path: '/inventario',
            name: 'inventory',
            component: () => import('../modules/inventory/view/InventoryView.vue'),
            meta: { requiresAuth: false, roles: ['admin'] }
        },
        {
            path: '/almacen',
            name: 'almacen',
            component: () => import('../modules/warehouse/views/WarehouseView.vue'),
            meta: { requiresAuth: true, roles: ['admin'] }
        },
        /* ----- Auth ----- */
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
        /* ----- Módulos (Solo personal autorizado) ----- */
        {
            path: '/menu',
            name: 'menu',
            component: () => import('../modules/recipe-ingredient-entry/views/RecipeCrudView.vue'),
            meta: { requiresAuth: true, roles: ['admin'] }
        },
        {
            path: '/pos',
            name: 'pos',
            component: () => import('../modules/pos/views/POSView.vue'),
            meta: { requiresAuth: true, roles: ['admin', 'cajero'] }
        },
        {
            path: '/pedidos',
            name: 'pedidos',
            component: () => import('../modules/waiter/views/WaiterOrdersView.vue'),
            meta: { requiresAuth: true, roles: ['mesero', 'admin'] }
        },
        {
            path: '/mesas',
            name: 'mesas',
            component: () => import('../modules/tables/views/TablesView.vue'),
            meta: { requiresAuth: true, roles: ['admin', 'mesero', 'cajero', 'cocina'] }
        },
        {
            path: '/reportes',
            name: 'reportes',
            component: () => import('../modules/dashboard/views/ReportsDashboard.vue'),
            meta: { requiresAuth: true, roles: ['admin'] }
        },
        {
            path: '/operaciones',
            name: 'operaciones',
            component: () => import('../modules/operations/views/OperationsView.vue'),
            meta: { requiresAuth: true, roles: ['admin', 'cajero'] }
        },
        {
            path: '/contabilidad',
            name: 'contabilidad',
            component: () => import('../modules/accounting/views/BalanceSheetView.vue'),
            meta: { requiresAuth: true, roles: ['admin'] }
        },
        {
            path: '/configuracion',
            name: 'configuracion',
            component: () => import('../modules/settings/views/SettingsView.vue'),
            meta: { requiresAuth: true }
        }
    ]
});

router.beforeEach((to, _from, next) => {
    const auth = useAuth()
    
    if (to.meta.requiresAuth && !auth.isAuthenticated.value) {
        return next('/singin')
    }
    
    if (to.meta.roles && auth.user.value) {
        const allowedRoles = to.meta.roles as string[]
        if (!allowedRoles.includes(auth.user.value.role)) {
            return next('/')
        }
    }
    
    if (to.path === '/singin' && auth.isAuthenticated.value) {
        auth.navigateToDashboard()
        return
    }
    
    next()
})

export default router;