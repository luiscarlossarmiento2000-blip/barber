<script setup>
import { RouterView } from 'vue-router'
</script>

<template>
  <div class="min-h-screen bg-[#0f0f1a]">
    <nav class="fixed top-0 left-0 right-0 z-40 bg-[#1a1a2e]/90 backdrop-blur-md border-b border-white/5">
      <div class="max-w-6xl mx-auto px-6 h-16 flex items-center justify-between">
        <router-link to="/" class="flex items-center gap-3">
          <div class="w-9 h-9 bg-[#e94560] rounded-lg flex items-center justify-center text-lg">✂️</div>
          <span class="font-[Playfair_Display] text-xl font-bold">Barbería Premium</span>
        </router-link>
        <div class="flex items-center gap-6">
          <router-link to="/" class="text-[#a0a0b8] hover:text-white transition-colors text-sm font-medium">Inicio</router-link>
          <router-link to="/reservar" class="bg-[#e94560] hover:bg-[#d63d55] text-white px-5 py-2 rounded-lg text-sm font-semibold transition-colors">
            Reservar Cita
          </router-link>
        </div>
      </div>
    </nav>
    <main class="pt-16">
      <RouterView />
    </main>
    <footer class="bg-[#1a1a2e] border-t border-white/5 py-8 mt-20">
      <div class="max-w-6xl mx-auto px-6 text-center text-[#6b6b8a] text-sm">
        <p>© 2026 Barbería Premium. Todos los derechos reservados.</p>
      </div>
    </footer>
  </div>
</template>
