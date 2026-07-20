<script setup>
defineProps({
  data: { type: Array, default: () => [] }
})

const dayNames = ['Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab']

const getDayLabel = (dateStr) => {
  const date = new Date(dateStr)
  return dayNames[date.getDay()]
}

const maxRevenue = computed(() => {
  if (!props.data.length) return 1
  return Math.max(...props.data.map(d => d.revenue), 1)
})
</script>

<script>
import { computed } from 'vue'
</script>

<template>
  <div class="bg-[#16213e] rounded-xl p-6 border border-white/5">
    <h3 class="text-lg font-semibold mb-6">Ingresos Semanales</h3>
    <div class="flex items-end gap-3 h-48">
      <div
        v-for="(item, index) in data"
        :key="item.date"
        class="flex-1 flex flex-col items-center gap-2 group"
      >
        <div class="relative w-full">
          <div
            class="w-full rounded-t-lg transition-all duration-500 hover:opacity-80"
            :class="index === 5 ? 'bg-[#e94560]' : 'bg-[#42b883]'"
            :style="{ height: `${(item.revenue / maxRevenue) * 160}px`, opacity: index === 5 ? 1 : 0.7 }"
          />
          <div class="absolute -top-8 left-1/2 -translate-x-1/2 bg-[#1a1a2e] px-2 py-1 rounded text-xs opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap border border-white/10">
            ${{ item.revenue }}
          </div>
        </div>
        <span class="text-xs text-[#a0a0b8]">{{ getDayLabel(item.date) }}</span>
      </div>
    </div>
  </div>
</template>
