<script setup>
import { RouterLink } from 'vue-router'
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const featuredProducts = ref([])

const fetchFeaturedProducts = async () => {
  const { data } = await supabase
    .from('products')
    .select('*')
    .eq('is_active', true)
    .eq('is_featured', true)
    .order('name')
  featuredProducts.value = data || []
}

onMounted(fetchFeaturedProducts)
</script>

<template>
  <div>
    <!-- Hero Section -->
    <section class="relative min-h-[90vh] flex items-center overflow-hidden">
      <!-- Background con overlay -->
      <div class="absolute inset-0 bg-gradient-to-br from-[#0f0f1a] via-[#1a1a2e] to-[#0f0f1a]">
        <div class="absolute inset-0 opacity-20" style="background-image: url('data:image/svg+xml,%3Csvg width=\'60\' height=\'60\' viewBox=\'0 0 60 60\' xmlns=\'http://www.w3.org/2000/svg\'%3E%3Cg fill=\'none\' fill-rule=\'evenodd\'%3E%3Cg fill=\'%23e94560\' fill-opacity=\'0.1\'%3E%3Cpath d=\'M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z\'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E');"></div>
      </div>

      <!-- Decorative elements -->
      <div class="absolute top-20 right-20 w-72 h-72 bg-[#e94560]/10 rounded-full blur-3xl"></div>
      <div class="absolute bottom-20 left-20 w-96 h-96 bg-[#42b883]/5 rounded-full blur-3xl"></div>

      <div class="relative z-10 max-w-6xl mx-auto px-6 py-20 grid lg:grid-cols-2 gap-12 items-center">
        <!-- Left: Content -->
        <div class="text-center lg:text-left">
          <!-- Logo placeholder -->
          <div class="mb-8 flex justify-center lg:justify-start">
            <div class="relative">
              <!-- Logo NicoBarber -->
              <div class="w-28 h-28 rounded-2xl bg-gradient-to-br from-[#e94560] to-[#ff6b6b] flex items-center justify-center shadow-2xl shadow-[#e94560]/30 mb-4 mx-auto lg:mx-0">
                <span class="text-5xl">✂️</span>
              </div>
              <h2 class="text-2xl font-[Playfair_Display] font-bold text-white tracking-wide">NicoBarber</h2>
              <p class="text-[#e94560] text-sm tracking-widest uppercase mt-1">Estilo & Tradición</p>
            </div>
          </div>

          <div class="inline-flex items-center gap-2 bg-[#e94560]/10 border border-[#e94560]/20 text-[#e94560] px-4 py-2 rounded-full text-sm font-medium mb-6 backdrop-blur-sm">
            <span class="w-2 h-2 bg-[#e94560] rounded-full animate-pulse"></span>
            Reserva tu cita en segundos
          </div>

          <h1 class="text-5xl lg:text-7xl font-bold mb-6 leading-tight">
            Tu estilo,<br>
            <span class="bg-gradient-to-r from-[#e94560] to-[#ff6b6b] bg-clip-text text-transparent">nuestra pasión</span>
          </h1>

          <p class="text-lg text-[#a0a0b8] mb-10 max-w-lg mx-auto lg:mx-0 leading-relaxed">
            En <strong class="text-white">NicoBarber</strong> transformamos tu look con cortes modernos, 
            barba impecable y servicios de manicure profesional. Agenda tu cita y descubre la diferencia.
          </p>

          <div class="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start">
            <RouterLink
              to="/reservar"
              class="group bg-gradient-to-r from-[#e94560] to-[#ff6b6b] text-white px-8 py-4 rounded-xl font-semibold text-lg transition-all hover:shadow-lg hover:shadow-[#e94560]/30 hover:scale-105 flex items-center justify-center gap-2"
            >
              <span>📅</span> Reservar Ahora
              <span class="group-hover:translate-x-1 transition-transform">→</span>
            </RouterLink>
            <a
              href="#servicios"
              class="bg-white/5 border border-white/10 text-white px-8 py-4 rounded-xl font-semibold text-lg transition-all hover:bg-white/10 hover:border-white/20 flex items-center justify-center gap-2"
            >
              <span>✂️</span> Ver Servicios
            </a>
          </div>

          <!-- Stats -->
          <div class="flex gap-8 mt-12 justify-center lg:justify-start">
            <div class="text-center">
              <div class="text-2xl font-bold text-[#e94560]">500+</div>
              <div class="text-xs text-[#a0a0b8] uppercase tracking-wider">Clientes</div>
            </div>
            <div class="w-px bg-white/10"></div>
            <div class="text-center">
              <div class="text-2xl font-bold text-[#42b883]">8</div>
              <div class="text-xs text-[#a0a0b8] uppercase tracking-wider">Servicios</div>
            </div>
            <div class="w-px bg-white/10"></div>
            <div class="text-center">
              <div class="text-2xl font-bold text-[#3498db]">5★</div>
              <div class="text-xs text-[#a0a0b8] uppercase tracking-wider">Rating</div>
            </div>
          </div>
        </div>

        <!-- Right: Visual -->
        <div class="hidden lg:block relative">
          <div class="relative w-full aspect-square max-w-md mx-auto">
            <!-- Decorative rings -->
            <div class="absolute inset-0 border-2 border-[#e94560]/20 rounded-full animate-spin" style="animation-duration: 20s;"></div>
            <div class="absolute inset-8 border border-[#42b883]/20 rounded-full animate-spin" style="animation-duration: 15s; animation-direction: reverse;"></div>

            <!-- Center image placeholder -->
            <div class="absolute inset-16 bg-gradient-to-br from-[#16213e] to-[#1a1a2e] rounded-full flex items-center justify-center border border-white/10 shadow-2xl">
              <div class="text-center">
                <div class="text-8xl mb-2">💈</div>
                <p class="text-[#a0a0b8] text-sm">Tu imagen aquí</p>
              </div>
            </div>

            <!-- Floating badges -->
            <div class="absolute top-0 right-0 bg-[#16213e] border border-white/10 rounded-xl px-4 py-3 shadow-xl">
              <div class="flex items-center gap-2">
                <span class="text-2xl">✂️</span>
                <div>
                  <div class="text-sm font-semibold">Corte Premium</div>
                  <div class="text-xs text-[#42b883]">Desde $15</div>
                </div>
              </div>
            </div>

            <div class="absolute bottom-10 left-0 bg-[#16213e] border border-white/10 rounded-xl px-4 py-3 shadow-xl">
              <div class="flex items-center gap-2">
                <span class="text-2xl">🧔</span>
                <div>
                  <div class="text-sm font-semibold">Barba Perfecta</div>
                  <div class="text-xs text-[#e94560]">Desde $10</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Services Section -->
    <section id="servicios" class="py-24 px-6 relative">
      <div class="absolute inset-0 bg-gradient-to-b from-transparent via-[#e94560]/3 to-transparent"></div>

      <div class="max-w-6xl mx-auto relative z-10">
        <div class="text-center mb-16">
          <span class="text-[#e94560] text-sm font-semibold tracking-widest uppercase">Nuestros Servicios</span>
          <h2 class="text-4xl lg:text-5xl font-bold mt-4 mb-4">Todo para tu look perfecto</h2>
          <p class="text-[#a0a0b8] max-w-2xl mx-auto">Ofrecemos una variedad de servicios profesionales para que luzcas increíble</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <!-- Service Card 1 -->
          <div class="group bg-gradient-to-b from-[#16213e] to-[#1a1a2e] rounded-2xl p-6 border border-white/5 hover:border-[#e94560]/30 transition-all duration-300 hover:-translate-y-2">
            <div class="w-16 h-16 bg-[#e94560]/10 rounded-2xl flex items-center justify-center text-3xl mb-5 group-hover:scale-110 transition-transform group-hover:bg-[#e94560]/20">
              ✂️
            </div>
            <h3 class="font-semibold text-xl mb-2">Corte de Cabello</h3>
            <p class="text-sm text-[#a0a0b8] mb-4 leading-relaxed">Clásico o moderno, fade, undercut o el estilo que prefieras con nuestros expertos.</p>
            <div class="flex items-center justify-between">
              <span class="text-[#e94560] font-bold text-lg">Desde $15</span>
              <span class="text-xs text-[#42b883] bg-[#42b883]/10 px-2 py-1 rounded-full">30 min</span>
            </div>
          </div>

          <!-- Service Card 2 -->
          <div class="group bg-gradient-to-b from-[#16213e] to-[#1a1a2e] rounded-2xl p-6 border border-white/5 hover:border-[#9b59b6]/30 transition-all duration-300 hover:-translate-y-2">
            <div class="w-16 h-16 bg-[#9b59b6]/10 rounded-2xl flex items-center justify-center text-3xl mb-5 group-hover:scale-110 transition-transform group-hover:bg-[#9b59b6]/20">
              🧔
            </div>
            <h3 class="font-semibold text-xl mb-2">Barba & Afeitado</h3>
            <p class="text-sm text-[#a0a0b8] mb-4 leading-relaxed">Afeitado clásico con navaja, arreglo de barba o diseño de perilla profesional.</p>
            <div class="flex items-center justify-between">
              <span class="text-[#e94560] font-bold text-lg">Desde $10</span>
              <span class="text-xs text-[#42b883] bg-[#42b883]/10 px-2 py-1 rounded-full">20 min</span>
            </div>
          </div>

          <!-- Service Card 3 -->
          <div class="group bg-gradient-to-b from-[#16213e] to-[#1a1a2e] rounded-2xl p-6 border border-white/5 hover:border-[#e91e63]/30 transition-all duration-300 hover:-translate-y-2">
            <div class="w-16 h-16 bg-[#e91e63]/10 rounded-2xl flex items-center justify-center text-3xl mb-5 group-hover:scale-110 transition-transform group-hover:bg-[#e91e63]/20">
              💅
            </div>
            <h3 class="font-semibold text-xl mb-2">Manicure</h3>
            <p class="text-sm text-[#a0a0b8] mb-4 leading-relaxed">Manos impecables con tratamiento profesional, limpieza y esmaltado.</p>
            <div class="flex items-center justify-between">
              <span class="text-[#e94560] font-bold text-lg">Desde $8</span>
              <span class="text-xs text-[#42b883] bg-[#42b883]/10 px-2 py-1 rounded-full">25 min</span>
            </div>
          </div>

          <!-- Service Card 4 -->
          <div class="group bg-gradient-to-b from-[#16213e] to-[#1a1a2e] rounded-2xl p-6 border border-white/5 hover:border-[#00bcd4]/30 transition-all duration-300 hover:-translate-y-2">
            <div class="w-16 h-16 bg-[#00bcd4]/10 rounded-2xl flex items-center justify-center text-3xl mb-5 group-hover:scale-110 transition-transform group-hover:bg-[#00bcd4]/20">
              ✨
            </div>
            <h3 class="font-semibold text-xl mb-2">Facial & Spa</h3>
            <p class="text-sm text-[#a0a0b8] mb-4 leading-relaxed">Limpieza facial profunda, hidratación y tratamientos para una piel radiante.</p>
            <div class="flex items-center justify-between">
              <span class="text-[#e94560] font-bold text-lg">Desde $18</span>
              <span class="text-xs text-[#42b883] bg-[#42b883]/10 px-2 py-1 rounded-full">40 min</span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Featured Products Section -->
    <section v-if="featuredProducts.length > 0" class="py-24 px-6 bg-[#0a0a14]">
      <div class="max-w-6xl mx-auto">
        <div class="text-center mb-16">
          <span class="text-[#f39c12] text-sm font-semibold tracking-widest uppercase">⭐ Recomendados</span>
          <h2 class="text-4xl font-bold mt-4 mb-4">Productos Destacados</h2>
          <p class="text-[#a0a0b8] max-w-2xl mx-auto">Lleva el cuidado profesional a casa con nuestra línea de productos</p>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
          <div
            v-for="product in featuredProducts"
            :key="product.id"
            class="bg-gradient-to-b from-[#16213e] to-[#1a1a2e] rounded-xl p-4 border border-white/5 hover:border-[#e94560]/20 transition-all group"
          >
            <div class="aspect-square bg-[#1a1a2e] rounded-lg flex items-center justify-center text-4xl mb-3 border border-white/5 group-hover:scale-105 transition-transform">
              {{ product.image_url ? '📷' : '📦' }}
            </div>
            <div class="font-medium text-sm mb-1 line-clamp-1">{{ product.name }}</div>
            <div class="text-xs text-[#a0a0b8] mb-2 line-clamp-1">{{ product.brand }}</div>
            <div class="flex items-center justify-between">
              <span class="text-[#e94560] font-bold">${{ product.price }}</span>
              <span class="text-[10px] text-[#42b883] bg-[#42b883]/10 px-2 py-0.5 rounded-full">En stock</span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Why Choose Us -->
    <section class="py-24 px-6">
      <div class="max-w-6xl mx-auto">
        <div class="grid lg:grid-cols-2 gap-16 items-center">
          <div>
            <span class="text-[#42b883] text-sm font-semibold tracking-widest uppercase">¿Por qué elegirnos?</span>
            <h2 class="text-4xl font-bold mt-4 mb-6">La experiencia NicoBarber</h2>

            <div class="space-y-6">
              <div class="flex gap-4">
                <div class="w-12 h-12 bg-[#e94560]/10 rounded-xl flex items-center justify-center text-xl flex-shrink-0">🏆</div>
                <div>
                  <h4 class="font-semibold text-lg mb-1">Barberos Expertos</h4>
                  <p class="text-sm text-[#a0a0b8]">Nuestro equipo cuenta con años de experiencia y formación continua en las últimas tendencias.</p>
                </div>
              </div>

              <div class="flex gap-4">
                <div class="w-12 h-12 bg-[#42b883]/10 rounded-xl flex items-center justify-center text-xl flex-shrink-0">⏱️</div>
                <div>
                  <h4 class="font-semibold text-lg mb-1">Reserva Rápida</h4>
                  <p class="text-sm text-[#a0a0b8]">Agenda tu cita en segundos sin necesidad de llamar. Elige fecha, hora y servicio.</p>
                </div>
              </div>

              <div class="flex gap-4">
                <div class="w-12 h-12 bg-[#3498db]/10 rounded-xl flex items-center justify-center text-xl flex-shrink-0">🎯</div>
                <div>
                  <h4 class="font-semibold text-lg mb-1">Atención Personalizada</h4>
                  <p class="text-sm text-[#a0a0b8]">Cada cliente es único. Escuchamos tus preferencias y te asesoramos para el mejor resultado.</p>
                </div>
              </div>

              <div class="flex gap-4">
                <div class="w-12 h-12 bg-[#f39c12]/10 rounded-xl flex items-center justify-center text-xl flex-shrink-0">🛡️</div>
                <div>
                  <h4 class="font-semibold text-lg mb-1">Higiene Garantizada</h4>
                  <p class="text-sm text-[#a0a0b8]">Estrictos protocolos de limpieza y esterilización en todas nuestras herramientas.</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Image placeholder -->
          <div class="relative">
            <div class="aspect-[4/5] bg-gradient-to-br from-[#16213e] to-[#1a1a2e] rounded-2xl border border-white/5 flex items-center justify-center">
              <div class="text-center">
                <div class="text-9xl mb-4 opacity-30">💈</div>
                <p class="text-[#a0a0b8]">Imagen de tu barbería</p>
                <p class="text-xs text-[#6b6b8a] mt-2">Reemplaza esto con una foto real</p>
              </div>
            </div>
            <!-- Decorative element -->
            <div class="absolute -bottom-6 -right-6 w-32 h-32 bg-[#e94560]/10 rounded-full blur-2xl"></div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="py-24 px-6 relative overflow-hidden">
      <div class="absolute inset-0 bg-gradient-to-r from-[#e94560]/10 via-transparent to-[#42b883]/10"></div>
      <div class="absolute top-0 left-1/2 -translate-x-1/2 w-[600px] h-[600px] bg-[#e94560]/5 rounded-full blur-3xl"></div>

      <div class="max-w-3xl mx-auto text-center relative z-10">
        <div class="w-20 h-20 bg-gradient-to-br from-[#e94560] to-[#ff6b6b] rounded-2xl flex items-center justify-center text-4xl mx-auto mb-8 shadow-2xl shadow-[#e94560]/20">
          ✂️
        </div>
        <h2 class="text-4xl lg:text-5xl font-bold mb-6">¿Listo para tu nuevo look?</h2>
        <p class="text-[#a0a0b8] text-lg mb-10 max-w-xl mx-auto">
          No necesitas registrarte. Solo deja tu nombre y teléfono, elige tu servicio y ¡listo! 
          Te esperamos en <strong class="text-white">NicoBarber</strong>.
        </p>
        <RouterLink
          to="/reservar"
          class="inline-flex items-center gap-3 bg-gradient-to-r from-[#e94560] to-[#ff6b6b] text-white px-10 py-5 rounded-xl font-semibold text-lg transition-all hover:shadow-xl hover:shadow-[#e94560]/30 hover:scale-105"
        >
          <span>📅</span> Agendar mi Cita
        </RouterLink>

        <div class="flex items-center justify-center gap-6 mt-10 text-sm text-[#a0a0b8]">
          <span class="flex items-center gap-2"><span class="text-[#42b883]">✓</span> Sin registro</span>
          <span class="w-1 h-1 bg-[#a0a0b8] rounded-full"></span>
          <span class="flex items-center gap-2"><span class="text-[#42b883]">✓</span> Confirmación inmediata</span>
          <span class="w-1 h-1 bg-[#a0a0b8] rounded-full"></span>
          <span class="flex items-center gap-2"><span class="text-[#42b883]">✓</span> Cancela cuando quieras</span>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <footer class="bg-[#0a0a14] border-t border-white/5 py-16 px-6">
      <div class="max-w-6xl mx-auto">
        <div class="grid md:grid-cols-4 gap-8 mb-12">
          <div class="md:col-span-2">
            <div class="flex items-center gap-3 mb-4">
              <div class="w-10 h-10 bg-gradient-to-br from-[#e94560] to-[#ff6b6b] rounded-xl flex items-center justify-center text-xl">✂️</div>
              <div>
                <h3 class="font-[Playfair_Display] text-xl font-bold">NicoBarber</h3>
                <p class="text-xs text-[#e94560] tracking-widest uppercase">Estilo & Tradición</p>
              </div>
            </div>
            <p class="text-sm text-[#a0a0b8] max-w-sm leading-relaxed">
              Tu barbería de confianza. Donde el estilo se encuentra con la tradición del buen servicio.
            </p>
          </div>

          <div>
            <h4 class="font-semibold mb-4 text-sm uppercase tracking-wider">Servicios</h4>
            <ul class="space-y-2 text-sm text-[#a0a0b8]">
              <li>Corte de Cabello</li>
              <li>Barba & Afeitado</li>
              <li>Manicure</li>
              <li>Facial & Spa</li>
            </ul>
          </div>

          <div>
            <h4 class="font-semibold mb-4 text-sm uppercase tracking-wider">Contacto</h4>
            <ul class="space-y-2 text-sm text-[#a0a0b8]">
              <li class="flex items-center gap-2">📍 Tu dirección aquí</li>
              <li class="flex items-center gap-2">📱 +51 999 999 999</li>
              <li class="flex items-center gap-2">✉️ info@nicobarber.com</li>
              <li class="flex items-center gap-2">🕐 Lun-Sab: 9am - 8pm</li>
            </ul>
          </div>
        </div>

        <div class="border-t border-white/5 pt-8 flex flex-col md:flex-row items-center justify-between gap-4">
          <p class="text-xs text-[#6b6b8a]">© 2026 NicoBarber. Todos los derechos reservados.</p>
          <div class="flex gap-4">
            <a href="#" class="w-10 h-10 bg-[#16213e] rounded-full flex items-center justify-center text-lg hover:bg-[#e94560]/20 transition-colors">📘</a>
            <a href="#" class="w-10 h-10 bg-[#16213e] rounded-full flex items-center justify-center text-lg hover:bg-[#e94560]/20 transition-colors">📸</a>
            <a href="#" class="w-10 h-10 bg-[#16213e] rounded-full flex items-center justify-center text-lg hover:bg-[#e94560]/20 transition-colors">🐦</a>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>
