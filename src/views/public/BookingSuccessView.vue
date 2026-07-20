<script setup>
import { RouterLink } from 'vue-router'
</script>

<template>
  <div class="min-h-screen flex items-center justify-center px-6">
    <div class="text-center max-w-md">
      <div class="w-24 h-24 bg-[#42b883]/20 rounded-full flex items-center justify-center text-5xl mx-auto mb-6 animate-bounce">
        ✅
      </div>
      <h1 class="text-3xl font-bold mb-4">¡Cita confirmada!</h1>
      <p class="text-[#a0a0b8] mb-8">
        Tu cita ha sido registrada exitosamente. Te esperamos en la barbería a la hora indicada.
      </p>
      <div class="flex gap-4 justify-center">
        <RouterLink
          to="/"
          class="bg-[#16213e] hover:bg-[#1f2a4a] text-white px-6 py-3 rounded-xl font-semibold transition-colors border border-white/10"
        >
          Volver al inicio
        </RouterLink>
        <RouterLink
          to="/reservar"
          class="bg-[#e94560] hover:bg-[#d63d55] text-white px-6 py-3 rounded-xl font-semibold transition-colors"
        >
          Nueva cita
        </RouterLink>
      </div>
    </div>
  </div>
</template>
