<script setup>
import { ref, onMounted } from 'vue'
import { useBusinessStore } from '@/stores/business'
import BaseButton from '@/components/ui/BaseButton.vue'
import BaseInput from '@/components/ui/BaseInput.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'

const businessStore = useBusinessStore()
const saving = ref(false)
const saved = ref(false)

const form = ref({
  business_name: '',
  phone: '',
  address: '',
  opening_time: '09:00',
  closing_time: '20:00',
  primary_color: '#1a1a2e',
  secondary_color: '#e94560',
  accent_color: '#42b883'
})

onMounted(async () => {
  await businessStore.fetchSettings()
  if (businessStore.settings) {
    form.value = { ...businessStore.settings }
  }
})

const saveSettings = async () => {
  saving.value = true
  await businessStore.updateSettings(form.value)
  saving.value = false
  saved.value = true
  setTimeout(() => saved.value = false, 3000)
}
</script>

<template>
  <div>
    <div class="mb-8">
      <h1 class="text-3xl font-bold mb-2">Configuración</h1>
      <p class="text-[#a0a0b8]">Personaliza tu barbería</p>
    </div>

    <LoadingSpinner v-if="businessStore.loading"/>

    <div v-else class="max-w-2xl bg-[#16213e] rounded-xl p-8 border border-white/5">
      <form @submit.prevent="saveSettings" class="space-y-6">
        <div>
          <h3 class="font-semibold mb-4 text-[#e94560]">Información General</h3>
          <div class="space-y-4">
            <BaseInput v-model="form.business_name" label="Nombre de la barbería" required />
            <BaseInput v-model="form.phone" label="Teléfono" />
            <BaseInput v-model="form.address" label="Dirección" />
          </div>
        </div>

        <div class="border-t border-white/5 pt-6">
          <h3 class="font-semibold mb-4 text-[#e94560]">Horario</h3>
          <div class="grid grid-cols-2 gap-4">
            <BaseInput v-model="form.opening_time" label="Hora de apertura" type="time" />
            <BaseInput v-model="form.closing_time" label="Hora de cierre" type="time" />
          </div>
        </div>

        <div class="border-t border-white/5 pt-6">
          <h3 class="font-semibold mb-4 text-[#e94560]">Colores de marca</h3>
          <div class="grid grid-cols-3 gap-4">
            <div>
              <label class="block text-sm text-[#a0a0b8] mb-2">Primario</label>
              <input v-model="form.primary_color" type="color" class="w-full h-12 rounded-lg bg-[#1a1a2e] border border-white/10"/>
            </div>
            <div>
              <label class="block text-sm text-[#a0a0b8] mb-2">Secundario</label>
              <input v-model="form.secondary_color" type="color" class="w-full h-12 rounded-lg bg-[#1a1a2e] border border-white/10"/>
            </div>
            <div>
              <label class="block text-sm text-[#a0a0b8] mb-2">Acento</label>
              <input v-model="form.accent_color" type="color" class="w-full h-12 rounded-lg bg-[#1a1a2e] border border-white/10"/>
            </div>
          </div>
        </div>

        <div class="flex items-center gap-4 pt-4">
          <BaseButton type="submit" variant="primary" :loading="saving">Guardar Cambios</BaseButton>
          <span v-if="saved" class="text-[#42b883] text-sm">✓ Guardado correctamente</span>
        </div>
      </form>
    </div>
  </div>
</template>
