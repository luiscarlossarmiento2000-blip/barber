<script setup>
defineProps({
  show: { type: Boolean, default: false },
  title: { type: String, default: '' },
  size: { type: String, default: 'md' }
})

defineEmits(['close'])

const sizes = {
  sm: 'max-w-md',
  md: 'max-w-lg',
  lg: 'max-w-2xl',
  xl: 'max-w-4xl'
}
</script>

<template>
  <Transition name="modal">
    <div v-if="show" class="fixed inset-0 z-50 flex items-center justify-center p-4">
      <div class="absolute inset-0 bg-black/70 backdrop-blur-sm" @click="$emit('close')"/>
      <div :class="['relative w-full bg-[#16213e] rounded-2xl shadow-2xl overflow-hidden', sizes[size]]">
        <div v-if="title" class="flex items-center justify-between px-6 py-4 border-b border-white/10">
          <h3 class="text-lg font-semibold">{{ title }}</h3>
          <button @click="$emit('close')" class="text-[#a0a0b8] hover:text-white transition-colors text-xl">&times;</button>
        </div>
        <div class="p-6">
          <slot />
        </div>
      </div>
    </div>
  </Transition>
</template>

<style scoped>
.modal-enter-active, .modal-leave-active {
  transition: opacity 0.3s ease;
}
.modal-enter-from, .modal-leave-to {
  opacity: 0;
}
</style>
