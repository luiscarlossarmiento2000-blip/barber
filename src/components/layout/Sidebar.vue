<script setup>
import { useAuthStore } from '@/stores/auth'
import { useRouter } from 'vue-router'

const authStore = useAuthStore()
const router = useRouter()

const adminMenu = [
  { name: 'Dashboard', icon: '📊', path: '/admin' },
  { name: 'Citas', icon: '📅', path: '/admin/citas' },
  { name: 'Clientes', icon: '👥', path: '/admin/clientes' },
  { name: 'Servicios', icon: '✂️', path: '/admin/servicios' },
  { name: 'Productos', icon: '📦', path: '/admin/productos' },
  { name: 'Transacciones', icon: '💰', path: '/admin/transacciones' },
  { name: 'Empleados', icon: '👤', path: '/admin/empleados' },
  { name: 'Configuración', icon: '⚙️', path: '/admin/configuracion' }
]

const employeeMenu = [
  { name: 'Mis Citas', icon: '📅', path: '/empleado' }
]

const menuItems = authStore.isAdmin ? adminMenu : employeeMenu

const logout = async () => {
  await authStore.signOut()
  router.push('/admin/login')
}
</script>

<template>
  <aside class="w-[260px] bg-[#1a1a2e] border-r border-white/5 flex flex-col h-screen fixed left-0 top-0">
    <div class="p-6 border-b border-white/5">
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 bg-[#e94560] rounded-xl flex items-center justify-center text-xl">✂️</div>
        <div>
          <h1 class="font-[Playfair_Display] text-lg font-bold leading-tight">Barbería</h1>
          <p class="text-xs text-[#a0a0b8]">Panel de Control</p>
        </div>
      </div>
    </div>

    <nav class="flex-1 p-4 space-y-1 overflow-y-auto">
      <router-link
        v-for="item in menuItems"
        :key="item.path"
        :to="item.path"
        :class="[
          'flex items-center gap-3 px-4 py-3 rounded-lg text-sm font-medium transition-all duration-200',
          $route.path === item.path 
            ? 'bg-[#e94560]/15 text-[#e94560]' 
            : 'text-[#a0a0b8] hover:bg-white/5 hover:text-white'
        ]"
      >
        <span class="text-lg">{{ item.icon }}</span>
        {{ item.name }}
      </router-link>
    </nav>

    <div class="p-4 border-t border-white/5">
      <div class="flex items-center gap-3 px-4 py-3 mb-3">
        <div class="w-9 h-9 bg-[#42b883] rounded-full flex items-center justify-center text-sm">👤</div>
        <div class="flex-1 min-w-0">
          <p class="text-sm font-medium truncate">{{ authStore.user?.full_name }}</p>
          <p class="text-xs text-[#a0a0b8] capitalize">{{ authStore.userRole }}</p>
        </div>
      </div>
      <button 
        @click="logout"
        class="w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm text-[#a0a0b8] hover:bg-[#e94560]/10 hover:text-[#e94560] transition-all"
      >
        <span>🚪</span> Cerrar Sesión
      </button>
    </div>
  </aside>
</template>
