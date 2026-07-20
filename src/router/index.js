import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

// Public views
import PublicLayout from '@/components/layout/PublicLayout.vue'
import HomeView from '@/views/public/HomeView.vue'
import BookAppointmentView from '@/views/public/BookAppointmentView.vue'
import BookingSuccessView from '@/views/public/BookingSuccessView.vue'

// Admin views
import AdminLayout from '@/components/layout/AdminLayout.vue'
import LoginView from '@/views/admin/LoginView.vue'
import DashboardView from '@/views/admin/DashboardView.vue'
import AppointmentsView from '@/views/admin/AppointmentsView.vue'
import ClientsView from '@/views/admin/ClientsView.vue'
import ServicesView from '@/views/admin/ServicesView.vue'
import ProductsView from '@/views/admin/ProductsView.vue'
import TransactionsView from '@/views/admin/TransactionsView.vue'
import EmployeesView from '@/views/admin/EmployeesView.vue'
import SettingsView from '@/views/admin/SettingsView.vue'

// Employee views
import EmployeeLayout from '@/components/layout/EmployeeLayout.vue'
import EmployeeDashboard from '@/views/employee/EmployeeDashboard.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      component: PublicLayout,
      children: [
        { path: '', name: 'home', component: HomeView },
        { path: 'reservar', name: 'book', component: BookAppointmentView },
        { path: 'exito', name: 'success', component: BookingSuccessView }
      ]
    },
    {
      path: '/admin/login',
      name: 'login',
      component: LoginView,
      meta: { guestOnly: true }
    },
    {
      path: '/admin',
      component: AdminLayout,
      meta: { requiresAuth: true, requiresAdmin: true },
      children: [
        { path: '', name: 'admin-dashboard', component: DashboardView },
        { path: 'citas', name: 'admin-appointments', component: AppointmentsView },
        { path: 'clientes', name: 'admin-clients', component: ClientsView },
        { path: 'servicios', name: 'admin-services', component: ServicesView },
        { path: 'productos', name: 'admin-products', component: ProductsView },
        { path: 'transacciones', name: 'admin-transactions', component: TransactionsView },
        { path: 'empleados', name: 'admin-employees', component: EmployeesView },
        { path: 'configuracion', name: 'admin-settings', component: SettingsView }
      ]
    },
    {
      path: '/empleado',
      component: EmployeeLayout,
      meta: { requiresAuth: true },
      children: [
        { path: '', name: 'employee-dashboard', component: EmployeeDashboard }
      ]
    }
  ]
})

router.beforeEach(async (to, from, next) => {
  const authStore = useAuthStore()

  if (!authStore.isAuthenticated) {
    await authStore.checkSession()
  }

  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    return next('/admin/login')
  }

  if (to.meta.requiresAdmin && !authStore.isAdmin) {
    return next('/empleado')
  }

  if (to.meta.guestOnly && authStore.isAuthenticated) {
    return next(authStore.isAdmin ? '/admin' : '/empleado')
  }

  next()
})

export default router
