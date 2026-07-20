<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import BaseInput from '@/components/ui/BaseInput.vue'
import BaseButton from '@/components/ui/BaseButton.vue'

const router = useRouter()
const authStore = useAuthStore()

const email = ref('')
const password = ref('')
const showReset = ref(false)
const resetEmail = ref('')
const resetSent = ref(false)

const handleLogin = async () => {
  const result = await authStore.signIn(email.value, password.value)
  if (result.success) {
    if (authStore.isAdmin) {
      router.push('/admin')
    } else {
      router.push('/empleado')
    }
  }
}

const handleReset = async () => {
  const result = await authStore.resetPassword(resetEmail.value)
  if (result.success) {
    resetSent.value = true
  }
}
</script>

<template>
  <div class="min-h-screen bg-[#0f0f1a] flex items-center justify-center p-4">
    <div class="w-full max-w-md">
      <div class="text-center mb-8">
        <div class="w-16 h-16 bg-[#e94560] rounded-2xl flex items-center justify-center text-3xl mx-auto mb-4">✂️</div>
        <h1 class="font-[Playfair_Display] text-3xl font-bold mb-2">Barbería Premium</h1>
        <p class="text-[#a0a0b8]">Panel de Administración</p>
      </div>

      <!-- Login Form -->
      <div v-if="!showReset" class="bg-[#16213e] rounded-2xl p-8 border border-white/5">
        <form @submit.prevent="handleLogin" class="space-y-4">
          <BaseInput
            v-model="email"
            label="Correo electrónico"
            type="email"
            placeholder="admin@barberia.com"
            required
          />
          <BaseInput
            v-model="password"
            label="Contraseña"
            type="password"
            placeholder="••••••••"
            required
          />

          <p v-if="authStore.error" class="text-sm text-[#e94560] text-center">
            {{ authStore.error }}
          </p>

          <BaseButton
            type="submit"
            variant="primary"
            size="lg"
            :loading="authStore.loading"
            class="w-full"
          >
            Iniciar Sesión
          </BaseButton>
        </form>

        <button
          @click="showReset = true"
          class="w-full text-center text-sm text-[#a0a0b8] hover:text-white mt-4 transition-colors"
        >
          ¿Olvidaste tu contraseña?
        </button>
      </div>

      <!-- Reset Password Form -->
      <div v-else class="bg-[#16213e] rounded-2xl p-8 border border-white/5">
        <button @click="showReset = false" class="text-sm text-[#a0a0b8] hover:text-white mb-4 flex items-center gap-1">
          ← Volver al login
        </button>

        <div v-if="!resetSent">
          <h3 class="text-lg font-semibold mb-2">Recuperar contraseña</h3>
          <p class="text-sm text-[#a0a0b8] mb-4">Te enviaremos un link para restablecer tu contraseña.</p>

          <form @submit.prevent="handleReset" class="space-y-4">
            <BaseInput
              v-model="resetEmail"
              label="Correo electrónico"
              type="email"
              placeholder="tu@email.com"
              required
            />
            <p v-if="authStore.error" class="text-sm text-[#e94560]">{{ authStore.error }}</p>
            <BaseButton
              type="submit"
              variant="primary"
              :loading="authStore.loading"
              class="w-full"
            >
              Enviar link de recuperación
            </BaseButton>
          </form>
        </div>

        <div v-else class="text-center py-4">
          <div class="text-4xl mb-4">📧</div>
          <h3 class="text-lg font-semibold mb-2">¡Revisa tu email!</h3>
          <p class="text-sm text-[#a0a0b8]">Hemos enviado un link para restablecer tu contraseña.</p>
        </div>
      </div>
    </div>
  </div>
</template>
