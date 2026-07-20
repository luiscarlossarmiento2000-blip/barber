<script setup>
defineProps({
  appointments: { type: Array, default: () => [] }
})

const getStatusIcon = (status) => {
  const icons = {
    completed: '✅',
    pending: '📅',
    confirmed: '✓',
    cancelled: '❌',
    no_show: '⚠️'
  }
  return icons[status] || '📋'
}

const getStatusColor = (status) => {
  const colors = {
    completed: '#42b883',
    pending: '#f39c12',
    confirmed: '#3498db',
    cancelled: '#e94560',
    no_show: '#6b6b8a'
  }
  return colors[status] || '#a0a0b8'
}
</script>

<template>
  <div class="bg-[#16213e] rounded-xl p-6 border border-white/5">
    <h3 class="text-lg font-semibold mb-6">Actividad Reciente</h3>
    <div class="space-y-3">
      <div
        v-for="appt in appointments.slice(0, 6)"
        :key="appt.id"
        class="flex items-center gap-3 p-3 bg-[#1a1a2e] rounded-lg"
      >
        <div
          class="w-9 h-9 rounded-full flex items-center justify-center text-sm flex-shrink-0"
          :style="{ background: getStatusColor(appt.status) + '22', color: getStatusColor(appt.status) }"
        >
          {{ getStatusIcon(appt.status) }}
        </div>
        <div class="flex-1 min-w-0">
          <div class="font-medium text-sm truncate">
            {{ appt.services?.name }} - {{ appt.clients?.full_name }}
          </div>
          <div class="text-xs text-[#a0a0b8]">
            {{ new Date(appt.created_at).toLocaleTimeString() }} • ${{ appt.services?.price }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
