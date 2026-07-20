<script setup>
defineProps({
  stats: { type: Object, required: true }
})

const cards = [
  { key: 'todayAppointments', label: 'CITAS HOY', icon: '📅', color: '#42b883', suffix: '' },
  { key: 'todayRevenue', label: 'INGRESOS HOY', icon: '💰', color: '#e94560', prefix: '$', suffix: '' },
  { key: 'weekRevenue', label: 'INGRESOS SEMANA', icon: '📈', color: '#3498db', prefix: '$', suffix: '' },
  { key: 'monthRevenue', label: 'INGRESOS MES', icon: '💵', color: '#f39c12', prefix: '$', suffix: '' },
  { key: 'totalClients', label: 'CLIENTES TOTALES', icon: '👥', color: '#9b59b6', suffix: '' },
  { key: 'pendingAppointments', label: 'PENDIENTES', icon: '⏳', color: '#e74c3c', suffix: '' }
]
</script>

<template>
  <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-4">
    <div
      v-for="card in cards"
      :key="card.key"
      class="bg-[#16213e] rounded-xl p-5 border-l-4 transition-all hover:translate-y-[-2px]"
      :style="{ borderLeftColor: card.color }"
    >
      <div class="flex items-center justify-between mb-3">
        <span class="text-xs font-semibold tracking-wider text-[#a0a0b8]">{{ card.label }}</span>
        <span class="text-xl">{{ card.icon }}</span>
      </div>
      <div class="text-2xl font-bold">
        {{ card.prefix || '' }}{{ stats[card.key]?.toLocaleString() || 0 }}{{ card.suffix }}
      </div>
    </div>
  </div>
</template>
