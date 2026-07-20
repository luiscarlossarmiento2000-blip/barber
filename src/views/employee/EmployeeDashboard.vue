<script setup>
import { ref, onMounted, computed } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { supabase } from '@/lib/supabase'
import BaseButton from '@/components/ui/BaseButton.vue'

const authStore = useAuthStore()
const appointments = ref([])
const loading = ref(false)
const selectedDate = ref(new Date().toISOString().split('T')[0])

const statusColors = {
  pending: 'bg-yellow-500/15 text-yellow-500',
  confirmed: 'bg-blue-500/15 text-blue-500',
  completed: 'bg-green-500/15 text-green-500',
  cancelled: 'bg-red-500/15 text-red-500'
}

const statusLabels = {
  pending: 'Pendiente',
  confirmed: 'Confirmada',
  completed: 'Completada',
  cancelled: 'Cancelada'
}

const fetchAppointments = async () => {
  loading.value = true
  try {
    // Consulta simple sin joins complejos
    const { data, error: err } = await supabase
      .from('appointments')
      .select('*')
      .eq('appointment_date', selectedDate.value)
      .order('appointment_time', { ascending: true })

    if (err) {
      console.warn('Error:', err)
      appointments.value = []
    } else {
      appointments.value = data || []
    }
  } catch (err) {
    console.warn('Catch error:', err)
    appointments.value = []
  }
  loading.value = false
}

const updateStatus = async (id, status) => {
  try {
    await supabase.from('appointments').update({ status }).eq('id', id)
    fetchAppointments()
  } catch (err) {
    alert('Error: ' + err.message)
  }
}

const todayAppointments = computed(() => appointments.value.filter(a => a.status !== 'cancelled'))
const completedToday = computed(() => appointments.value.filter(a => a.status === 'completed'))

onMounted(fetchAppointments)
</script>

<template>
  <div>
    <div class="mb-8">
      <h1 class="text-3xl font-bold mb-2">Mis Citas</h1>
      <p class="text-gray-400">Panel de empleado - {{ authStore.user?.full_name || 'Empleado' }}</p>
    </div>

    <!-- Stats -->
    <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-8">
      <div class="bg-barber-card rounded-xl p-5 border-l-4 border-blue-500">
        <div class="text-xs text-gray-400 mb-1">CITAS HOY</div>
        <div class="text-2xl font-bold">{{ todayAppointments.length }}</div>
      </div>
      <div class="bg-barber-card rounded-xl p-5 border-l-4 border-green-500">
        <div class="text-xs text-gray-400 mb-1">COMPLETADAS</div>
        <div class="text-2xl font-bold">{{ completedToday.length }}</div>
      </div>
      <div class="bg-barber-card rounded-xl p-5 border-l-4 border-barber-accent">
        <div class="text-xs text-gray-400 mb-1">PENDIENTES</div>
        <div class="text-2xl font-bold">{{ appointments.filter(a => a.status === 'pending').length }}</div>
      </div>
    </div>

    <!-- Date Filter -->
    <div class="mb-6">
      <input
        v-model="selectedDate"
        type="date"
        @change="fetchAppointments"
        class="px-4 py-2.5 rounded-lg bg-barber-card border border-white/10 text-white outline-none focus:border-barber-green"
      />
    </div>

    <!-- Loading -->
    <div v-if="loading" class="flex justify-center py-12">
      <div class="w-12 h-12 border-4 border-barber-accent/20 border-t-barber-accent rounded-full animate-spin"/>
    </div>

    <!-- Empty -->
    <div v-else-if="appointments.length === 0" class="text-center py-16">
      <div class="text-5xl mb-4">📅</div>
      <h3 class="text-lg font-semibold mb-2">Sin citas</h3>
      <p class="text-sm text-gray-400">No hay citas programadas para {{ selectedDate }}</p>
    </div>

    <!-- Appointments List -->
    <div v-else class="space-y-3">
      <div
        v-for="appt in appointments"
        :key="appt.id"
        class="bg-barber-card rounded-xl p-5 border border-white/5"
      >
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-5">
            <div class="text-center min-w-[70px]">
              <div class="text-lg font-bold text-barber-green">{{ appt.appointment_time?.slice(0, 5) }}</div>
            </div>
            <div class="w-px h-10 bg-white/10"/>
            <div>
              <div class="font-semibold">Cliente ID: {{ appt.client_id?.slice(0, 8) }}</div>
              <div class="text-sm text-gray-400">Servicio ID: {{ appt.service_id?.slice(0, 8) }}</div>
            </div>
            <div class="w-px h-10 bg-white/10"/>
            <div>
              <span class="inline-block px-3 py-1 rounded-full text-xs font-medium" :class="statusColors[appt.status]">
                {{ statusLabels[appt.status] }}
              </span>
            </div>
          </div>

          <div class="flex gap-2">
            <template v-if="appt.status === 'pending'">
              <BaseButton variant="success" size="sm" @click="updateStatus(appt.id, 'confirmed')">✓</BaseButton>
            </template>
            <template v-if="appt.status === 'confirmed'">
              <BaseButton variant="success" size="sm" @click="updateStatus(appt.id, 'completed')">✓ Completar</BaseButton>
            </template>
            <BaseButton variant="ghost" size="sm" @click="updateStatus(appt.id, 'cancelled')">✕</BaseButton>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
