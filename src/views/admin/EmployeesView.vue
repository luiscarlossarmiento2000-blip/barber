<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'
import BaseButton from '@/components/ui/BaseButton.vue'
import BaseInput from '@/components/ui/BaseInput.vue'
import BaseModal from '@/components/ui/BaseModal.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import EmptyState from '@/components/ui/EmptyState.vue'

const employees = ref([])
const loading = ref(false)
const showModal = ref(false)
const editingId = ref(null)

const employeeForm = ref({
  full_name: '',
  phone: '',
  email: '',
  role: 'barber'
})

const fetchEmployees = async () => {
  loading.value = true
  const { data } = await supabase
    .from('employees')
    .select('*')
    .order('created_at', { ascending: false })
  employees.value = data || []
  loading.value = false
}

const saveEmployee = async () => {
  if (editingId.value) {
    await supabase.from('employees').update(employeeForm.value).eq('id', editingId.value)
  } else {
    await supabase.from('employees').insert([employeeForm.value])
  }
  showModal.value = false
  resetForm()
  fetchEmployees()
}

const editEmployee = (emp) => {
  editingId.value = emp.id
  employeeForm.value = { ...emp }
  showModal.value = true
}

const toggleActive = async (emp) => {
  await supabase.from('employees').update({ is_active: !emp.is_active }).eq('id', emp.id)
  fetchEmployees()
}

const resetForm = () => {
  editingId.value = null
  employeeForm.value = { full_name: '', phone: '', email: '', role: 'barber' }
}

onMounted(fetchEmployees)
</script>

<template>
  <div>
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-bold mb-2">Empleados</h1>
        <p class="text-[#a0a0b8]">Gestiona tu equipo de trabajo</p>
      </div>
      <BaseButton variant="primary" @click="showModal = true; resetForm()">+ Nuevo Empleado</BaseButton>
    </div>

    <LoadingSpinner v-if="loading"/>

    <EmptyState
      v-else-if="employees.length === 0"
      icon="👤"
      title="Sin empleados"
      description="Agrega barberos y administradores."
    />

    <div v-else class="grid gap-3">
      <div
        v-for="emp in employees"
        :key="emp.id"
        class="bg-[#16213e] rounded-xl p-5 border border-white/5 flex items-center justify-between"
      >
        <div class="flex items-center gap-4">
          <div class="w-12 h-12 rounded-full flex items-center justify-center text-xl"
            :class="emp.role === 'admin' ? 'bg-[#e94560]/20 text-[#e94560]' : 'bg-[#42b883]/20 text-[#42b883]'"
          >
            {{ emp.role === 'admin' ? '👑' : '✂️' }}
          </div>
          <div>
            <div class="font-semibold text-lg">{{ emp.full_name }}</div>
            <div class="text-sm text-[#a0a0b8]">
              📱 {{ emp.phone }}
              <span v-if="emp.email"> • ✉️ {{ emp.email }}</span>
              • <span class="capitalize" :class="emp.role === 'admin' ? 'text-[#e94560]' : 'text-[#42b883]'">{{ emp.role }}</span>
            </div>
          </div>
        </div>
        <div class="flex items-center gap-3">
          <span
            class="px-3 py-1 rounded-full text-xs font-medium"
            :class="emp.is_active ? 'bg-[#42b883]/15 text-[#42b883]' : 'bg-[#e94560]/15 text-[#e94560]'"
          >
            {{ emp.is_active ? 'Activo' : 'Inactivo' }}
          </span>
          <BaseButton variant="secondary" size="sm" @click="editEmployee(emp)">✏️</BaseButton>
          <BaseButton variant="ghost" size="sm" @click="toggleActive(emp)">
            {{ emp.is_active ? '⏸' : '▶' }}
          </BaseButton>
        </div>
      </div>
    </div>

    <BaseModal :show="showModal" :title="editingId ? 'Editar Empleado' : 'Nuevo Empleado'" @close="showModal = false">
      <form @submit.prevent="saveEmployee" class="space-y-4">
        <BaseInput v-model="employeeForm.full_name" label="Nombre completo" required />
        <BaseInput v-model="employeeForm.phone" label="Teléfono" required />
        <BaseInput v-model="employeeForm.email" label="Email" type="email" />
        <div>
          <label class="block text-sm text-[#a0a0b8] mb-2">Rol</label>
          <select v-model="employeeForm.role" class="w-full px-4 py-2.5 rounded-lg bg-[#1a1a2e] border border-white/10 text-white outline-none">
            <option value="barber">Barbero</option>
            <option value="admin">Administrador</option>
            <option value="assistant">Asistente</option>
          </select>
        </div>
        <BaseButton type="submit" variant="primary" class="w-full">Guardar</BaseButton>
      </form>
    </BaseModal>
  </div>
</template>
