<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const products = ref([])
const loading = ref(true)

const fetchFeaturedProducts = async () => {
  const { data } = await supabase
    .from('products')
    .select('*')
    .eq('is_active', true)
    .eq('is_featured', true)
    .order('name')
  products.value = data || []
  loading.value = false
}

onMounted(fetchFeaturedProducts)
</script>

<template>
  <div v-if="products.length > 0" class="mt-10">
    <div class="flex items-center gap-3 mb-6">
      <div class="h-px flex-1 bg-gradient-to-r from-transparent to-[#e94560]/30"/>
      <span class="text-[#e94560] font-semibold text-sm tracking-wider uppercase">⭐ Productos Recomendados</span>
      <div class="h-px flex-1 bg-gradient-to-l from-transparent to-[#e94560]/30"/>
    </div>

    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
      <div
        v-for="product in products"
        :key="product.id"
        class="bg-[#16213e] rounded-xl p-4 border border-white/5 hover:border-[#e94560]/30 transition-all group"
      >
        <div class="w-full h-32 bg-[#1a1a2e] rounded-lg flex items-center justify-center text-4xl mb-3 border border-white/5 group-hover:scale-105 transition-transform">
          {{ product.image_url ? '📷' : '📦' }}
        </div>
        <div class="font-semibold text-sm mb-1 line-clamp-1">{{ product.name }}</div>
        <div class="text-xs text-[#a0a0b8] mb-2 line-clamp-2">{{ product.description }}</div>
        <div class="flex items-center justify-between">
          <span class="text-[#e94560] font-bold">${{ product.price }}</span>
          <span class="text-xs text-[#6b6b8a]">{{ product.brand }}</span>
        </div>
      </div>
    </div>

    <p class="text-center text-xs text-[#6b6b8a] mt-4">
      💡 Pregunta por estos productos cuando vengas a tu cita
    </p>
  </div>
</template>
