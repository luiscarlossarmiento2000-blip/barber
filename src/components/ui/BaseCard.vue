<script setup>
defineProps({
  title: { type: String, default: '' },
  padding: { type: String, default: '6' }
})
</script>

<template>
  <div class="bg-[#16213e] rounded-xl border border-white/5 overflow-hidden">
    <div v-if="title" class="px-6 py-4 border-b border-white/10">
      <h3 class="text-lg font-semibold">{{ title }}</h3>
    </div>
    <div :class="`p-${padding}`">
      <slot />
    </div>
  </div>
</template>
