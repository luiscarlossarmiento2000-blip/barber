<script setup>
defineProps({
  variant: { type: String, default: 'primary' },
  size: { type: String, default: 'md' },
  loading: { type: Boolean, default: false },
  disabled: { type: Boolean, default: false },
  type: { type: String, default: 'button' }
})

defineEmits(['click'])

const variants = {
  primary: 'bg-[#e94560] hover:bg-[#d63d55] text-white',
  secondary: 'bg-[#16213e] hover:bg-[#1f2a4a] text-white border border-white/10',
  success: 'bg-[#42b883] hover:bg-[#369870] text-white',
  danger: 'bg-[#e74c3c] hover:bg-[#c0392b] text-white',
  ghost: 'bg-transparent hover:bg-white/5 text-[#a0a0b8]'
}

const sizes = {
  sm: 'px-3 py-1.5 text-sm',
  md: 'px-5 py-2.5 text-sm',
  lg: 'px-6 py-3 text-base'
}
</script>

<template>
  <button
    :type="type"
    :disabled="disabled || loading"
    :class="[
      'inline-flex items-center justify-center gap-2 rounded-lg font-semibold transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed',
      variants[variant],
      sizes[size]
    ]"
    @click="$emit('click')"
  >
    <svg v-if="loading" class="animate-spin h-4 w-4" viewBox="0 0 24 24">
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none"/>
      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"/>
    </svg>
    <slot />
  </button>
</template>
