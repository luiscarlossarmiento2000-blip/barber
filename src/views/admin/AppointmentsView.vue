<script setup>
import { ref, onMounted, computed } from 'vue'
import { useAppointmentsStore } from '@/stores/appointments'
import { useAuthStore } from '@/stores/auth'
import BaseButton from '@/components/ui/BaseButton.vue'
import BaseModal from '@/components/ui/BaseModal.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import EmptyState from '@/components/ui/EmptyState.vue'

const appointmentsStore = useAppointmentsStore()
const authStore = useAuthStore()

const showModal = ref(false)
const selectedDate = ref(new Date().toISOString().split('T')[0])
const selectedStatus = ref('')

const statusOptions = [
  { value: '', label: 'Todos' },
  { value: 'pending', label: 'Pendiente' },
  { value: 'confirmed', label: 'Confirmada' },
  { value: 'completed', label: 'Completada' },
  { value: 'cancelled', label: 'Cancelada' }
]

const filteredAppointments = computed(() => {
  let result = appointmentsStore.appointments
  if (selectedStatus.value) {
    result = result.filter(a => a.status === selectedStatus.value)
  }
  return result
})

const statusColors = {
  pending: 'bg-[#f39c12]/15 text-[#f39c12]',
  confirmed: 'bg-[#3498db]/15 text-[#3498db]',
  completed: 'bg-[#42b883]/15 text-[#42b883]',
  cancelled: 'bg-[#e94560]/15 text-[#e94560]',
  no_show: 'bg-[#6b6b8a]/15 text-[#6b6b8a]'
}

const statusLabels = {
  pending: 'Pendiente',
  confirmed: 'Confirmada',
  completed: 'Completada',
  cancelled: 'Cancelada',
  no_show: 'No asistió'
}

onMounted(() => {
  appointmentsStore.fetchAppointments()
})

const updateStatus = async (id, status) => {
  await appointmentsStore.updateStatus(id, status)
}

const deleteAppointment = async (id) => {
  if (confirm('¿Eliminar esta cita?')) {
    await appointmentsStore.deleteAppointment(id)
  }
}
</script>

<template>
  <div>
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-bold mb-2">Citas</h1>
        <p class="text-[#a0a0b8]">Gestiona todas las citas programadas</p>
      </div>
      <BaseButton variant="primary" @click="showModal = true">+ Nueva Cita</BaseButton>
    </div>

    <!-- Filtros -->
    <div class="flex gap-4 mb-6">
      <input
        v-model="selectedDate"
        type="date"
        class="px-4 py-2 rounded-lg bg-[#16213e] border border-white/10 text-white outline-none focus:border-[#42b883]"
      />
      <select
        v-model="selectedStatus"
        class="px-4 py-2 rounded-lg bg-[#16213e] border border-white/10 text-white outline-none focus:border-[#42b883]"
      >
        <option v-for="opt in statusOptions" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
      </select>
      <BaseButton variant="secondary" size="sm" @click="appointmentsStore.fetchAppointments({ date: selectedDate, status: selectedStatus })">
        🔄 Filtrar
      </BaseButton>
    </div>

    <LoadingSpinner v-if="appointmentsStore.loading" />

    <EmptyState
      v-else-if="filteredAppointments.length === 0"
      icon="📅"
      title="No hay citas"
      description="No se encontraron citas con los filtros seleccionados."
    />

    <div v-else class="space-y-3">
      <div
        v-for="appt in filteredAppointments"
        :key="appt.id"
        class="bg-[#16213e] rounded-xl p-5 border border-white/5 hover:border-white/10 transition-all"
      >
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-5">
            <div class="text-center min-w-[70px]">
              <div class="text-lg font-bold text-[#42b883]">{{ appt.appointment_time?.slice(0, 5) }}</div>
              <div class="text-xs text-[#a0a0b8]">{{ appt.appointment_date }}</div>
            </div>
            <div class="w-px h-12 bg-white/10"/>
            <div>
              <div class="font-semibold text-lg">{{ appt.clients?.full_name }}</div>
              <div class="text-sm text-[#a0a0b8]">📱 {{ appt.clients?.phone }}</div>
            </div>
            <div class="w-px h-12 bg-white/10"/>
            <div>
              <span
                class="inline-block px-3 py-1 rounded-full text-xs font-medium"
                :class="statusColors[appt.status]"
              >
                {{ statusLabels[appt.status] }}
              </span>
              <div class="text-sm text-[#a0a0b8] mt-1">{{ appt.services?.name }} - ${{ appt.services?.price }}</div>
            </div>
          </div>

          <div class="flex items-center gap-2">
            <template v-if="appt.status === 'pending' || appt.status === 'confirmed'">
              <BaseButton
                v-if="appt.status === 'pending'"
                variant="success"
                size="sm"
                @click="updateStatus(appt.id, 'confirmed')"
              >
                ✓ Confirmar
              </BaseButton>
              <BaseButton
                v-if="appt.status === 'confirmed'"
                variant="success"
                size="sm"
                @click="updateStatus(appt.id, 'completed')"
              >
                ✓ Completar
              </BaseButton>
              <BaseButton
                variant="ghost"
                size="sm"
                @click="updateStatus(appt.id, 'cancelled')"
              >
                Cancelar
              </BaseButton>
            </template>
            <BaseButton
              v-if="authStore.isAdmin"
              variant="danger"
              size="sm"
              @click="deleteAppointment(appt.id)"
            >
              🗑
            </BaseButton>
          </div>
        </div>
      </div>
    </div>

    <BaseModal :show="showModal" title="Nueva Cita" @close="showModal = false">
      <p class="text-[#a0a0b8] text-sm">Usa el formulario público en /reservar para crear citas.</p>
    </BaseModal>
  </div>
</template>
