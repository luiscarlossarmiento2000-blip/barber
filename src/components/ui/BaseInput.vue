<script setup>
const props = defineProps({
  modelValue: { type: [String, Number], default: '' },
  label: { type: String, default: '' },
  type: { type: String, default: 'text' },
  placeholder: { type: String, default: '' },
  required: { type: Boolean, default: false },
  error: { type: String, default: '' },
  disabled: { type: Boolean, default: false }
})

defineEmits(['update:modelValue'])
</script>

<template>
  <div class="w-full">
    <label v-if="label" class="block text-sm font-medium text-[#a0a0b8] mb-1.5">
      {{ label }}
      <span v-if="required" class="text-[#e94560]">*</span>
    </label>
    <input
      :type="type"
      :value="modelValue"
      :placeholder="placeholder"
      :required="required"
      :disabled="disabled"
      :class="[
        'w-full px-4 py-2.5 rounded-lg bg-[#1a1a2e] border transition-all duration-200 outline-none',
        error 
          ? 'border-[#e94560] focus:border-[#e94560] focus:ring-1 focus:ring-[#e94560]/30'
          : 'border-white/10 focus:border-[#42b883] focus:ring-1 focus:ring-[#42b883]/30',
        'text-white placeholder-[#6b6b8a]'
      ]"
      @input="$emit('update:modelValue', $event.target.value)"
    />
    <p v-if="error" class="mt-1 text-xs text-[#e94560]">{{ error }}</p>
  </div>
</template>
