<script setup>
defineProps({
  icon: { type: String, default: '📭' },
  title: { type: String, default: 'No hay datos' },
  description: { type: String, default: 'Aún no hay registros para mostrar.' }
})
</script>

<template>
  <div class="flex flex-col items-center justify-center py-16 text-center">
    <div class="text-5xl mb-4">{{ icon }}</div>
    <h3 class="text-lg font-semibold text-white mb-2">{{ title }}</h3>
    <p class="text-[#a0a0b8] text-sm max-w-sm">{{ description }}</p>
    <slot name="action" />
  </div>
</template>
