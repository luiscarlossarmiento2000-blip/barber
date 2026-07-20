<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'
import BaseButton from '@/components/ui/BaseButton.vue'
import BaseInput from '@/components/ui/BaseInput.vue'
import BaseModal from '@/components/ui/BaseModal.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import EmptyState from '@/components/ui/EmptyState.vue'

const services = ref([])
const loading = ref(false)
const showModal = ref(false)
const editingId = ref(null)

const serviceForm = ref({
  name: '',
  description: '',
  price: '',
  duration_minutes: 30,
  category: 'hair',
  color: '#42b883',
  icon: 'scissors'
})

const categories = [
  { value: 'hair', label: 'Cabello' },
  { value: 'beard', label: 'Barba' },
  { value: 'nails', label: 'Uñas' },
  { value: 'facial', label: 'Facial' },
  { value: 'other', label: 'Otro' }
]

const fetchServices = async () => {
  loading.value = true
  const { data } = await supabase
    .from('services')
    .select('*')
    .order('category')
  services.value = data || []
  loading.value = false
}

const saveService = async () => {
  const payload = {
    ...serviceForm.value,
    price: parseFloat(serviceForm.value.price)
  }

  if (editingId.value) {
    await supabase.from('services').update(payload).eq('id', editingId.value)
  } else {
    await supabase.from('services').insert([payload])
  }

  showModal.value = false
  resetForm()
  fetchServices()
}

const editService = (service) => {
  editingId.value = service.id
  serviceForm.value = { ...service }
  showModal.value = true
}

const deleteService = async (id) => {
  if (confirm('¿Eliminar este servicio?')) {
    await supabase.from('services').delete().eq('id', id)
    fetchServices()
  }
}

const resetForm = () => {
  editingId.value = null
  serviceForm.value = {
    name: '', description: '', price: '', duration_minutes: 30,
    category: 'hair', color: '#42b883', icon: 'scissors'
  }
}

onMounted(fetchServices)
</script>

<template>
  <div>
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-bold mb-2">Servicios</h1>
        <p class="text-[#a0a0b8]">Gestiona los servicios que ofreces</p>
      </div>
      <BaseButton variant="primary" @click="showModal = true; resetForm()">+ Nuevo Servicio</BaseButton>
    </div>

    <LoadingSpinner v-if="loading"/>

    <EmptyState
      v-else-if="services.length === 0"
      icon="✂️"
      title="No hay servicios"
      description="Agrega tu primer servicio para empezar."
    />

    <div v-else class="grid gap-3">
      <div
        v-for="service in services"
        :key="service.id"
        class="bg-[#16213e] rounded-xl p-5 border border-white/5 flex items-center justify-between"
      >
        <div class="flex items-center gap-4">
          <div
            class="w-12 h-12 rounded-lg flex items-center justify-center text-2xl"
            :style="{ background: service.color + '22', color: service.color }"
          >
            {{ service.icon === 'scissors' ? '✂️' : service.icon === 'razor' ? '🪒' : service.icon === 'hand' ? '💅' : '✨' }}
          </div>
          <div>
            <div class="font-semibold text-lg">{{ service.name }}</div>
            <div class="text-sm text-[#a0a0b8]">
              {{ service.duration_minutes }} min • ${{ service.price }} • 
              <span class="capitalize">{{ categories.find(c => c.value === service.category)?.label }}</span>
            </div>
          </div>
        </div>
        <div class="flex gap-2">
          <BaseButton variant="secondary" size="sm" @click="editService(service)">✏️</BaseButton>
          <BaseButton variant="danger" size="sm" @click="deleteService(service.id)">🗑</BaseButton>
        </div>
      </div>
    </div>

    <BaseModal :show="showModal" :title="editingId ? 'Editar Servicio' : 'Nuevo Servicio'" @close="showModal = false">
      <form @submit.prevent="saveService" class="space-y-4">
        <BaseInput v-model="serviceForm.name" label="Nombre" required />
        <BaseInput v-model="serviceForm.description" label="Descripción" />
        <div class="grid grid-cols-2 gap-4">
          <BaseInput v-model="serviceForm.price" label="Precio ($)" type="number" step="0.01" required />
          <BaseInput v-model="serviceForm.duration_minutes" label="Duración (min)" type="number" required />
        </div>
        <div>
          <label class="block text-sm text-[#a0a0b8] mb-2">Categoría</label>
          <select v-model="serviceForm.category" class="w-full px-4 py-2.5 rounded-lg bg-[#1a1a2e] border border-white/10 text-white outline-none">
            <option v-for="cat in categories" :key="cat.value" :value="cat.value">{{ cat.label }}</option>
          </select>
        </div>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm text-[#a0a0b8] mb-2">Color</label>
            <input v-model="serviceForm.color" type="color" class="w-full h-10 rounded-lg bg-[#1a1a2e] border border-white/10"/>
          </div>
          <div>
            <label class="block text-sm text-[#a0a0b8] mb-2">Icono</label>
            <select v-model="serviceForm.icon" class="w-full px-4 py-2.5 rounded-lg bg-[#1a1a2e] border border-white/10 text-white outline-none">
              <option value="scissors">✂️ Tijeras</option>
              <option value="razor">🪒 Navaja</option>
              <option value="hand">💅 Manos</option>
              <option value="face">✨ Facial</option>
            </select>
          </div>
        </div>
        <BaseButton type="submit" variant="primary" class="w-full">Guardar</BaseButton>
      </form>
    </BaseModal>
  </div>
</template>
