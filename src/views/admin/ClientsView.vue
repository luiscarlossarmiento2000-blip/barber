<script setup>
import { ref, onMounted, computed } from 'vue'
import { supabase } from '@/lib/supabase'
import BaseInput from '@/components/ui/BaseInput.vue'
import BaseButton from '@/components/ui/BaseButton.vue'
import BaseModal from '@/components/ui/BaseModal.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import EmptyState from '@/components/ui/EmptyState.vue'

const clients = ref([])
const loading = ref(false)
const showModal = ref(false)
const searchQuery = ref('')

const newClient = ref({
  full_name: '',
  phone: '',
  email: '',
  notes: ''
})

const fetchClients = async () => {
  loading.value = true
  const { data } = await supabase
    .from('clients')
    .select('*')
    .order('created_at', { ascending: false })
  clients.value = data || []
  loading.value = false
}

const createClient = async () => {
  const { data, error } = await supabase
    .from('clients')
    .insert([newClient.value])
    .select()
    .single()

  if (!error) {
    clients.value.unshift(data)
    showModal.value = false
    newClient.value = { full_name: '', phone: '', email: '', notes: '' }
  }
}

const filteredClients = computed(() => {
  if (!searchQuery.value) return clients.value
  const q = searchQuery.value.toLowerCase()
  return clients.value.filter(c => 
    c.full_name?.toLowerCase().includes(q) ||
    c.phone?.includes(q) ||
    c.email?.toLowerCase().includes(q)
  )
})

onMounted(fetchClients)
</script>

<template>
  <div>
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-bold mb-2">Clientes</h1>
        <p class="text-[#a0a0b8]">Base de datos de todos tus clientes</p>
      </div>
      <BaseButton variant="primary" @click="showModal = true">+ Nuevo Cliente</BaseButton>
    </div>

    <BaseInput
      v-model="searchQuery"
      placeholder="Buscar por nombre, teléfono o email..."
      class="mb-6"
    />

    <LoadingSpinner v-if="loading" />

    <EmptyState
      v-else-if="filteredClients.length === 0"
      icon="👥"
      title="No hay clientes"
      description="Aún no has registrado ningún cliente."
    />

    <div v-else class="grid gap-3">
      <div
        v-for="client in filteredClients"
        :key="client.id"
        class="bg-[#16213e] rounded-xl p-5 border border-white/5"
      >
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-4">
            <div class="w-12 h-12 bg-[#42b883]/20 rounded-full flex items-center justify-center text-xl">
              {{ client.full_name?.charAt(0).toUpperCase() }}
            </div>
            <div>
              <div class="font-semibold text-lg">{{ client.full_name }}</div>
              <div class="flex gap-4 text-sm text-[#a0a0b8] mt-1">
                <span>📱 {{ client.phone }}</span>
                <span v-if="client.email">✉️ {{ client.email }}</span>
                <span>🔄 {{ client.visit_count }} visitas</span>
              </div>
            </div>
          </div>
          <div class="text-right">
            <div class="text-sm text-[#a0a0b8]">Última visita</div>
            <div class="text-sm">{{ client.last_visit ? new Date(client.last_visit).toLocaleDateString() : 'Nunca' }}</div>
          </div>
        </div>
      </div>
    </div>

    <BaseModal :show="showModal" title="Nuevo Cliente" @close="showModal = false">
      <form @submit.prevent="createClient" class="space-y-4">
        <BaseInput v-model="newClient.full_name" label="Nombre completo" required />
        <BaseInput v-model="newClient.phone" label="Teléfono" required />
        <BaseInput v-model="newClient.email" label="Email (opcional)" type="email" />
        <BaseInput v-model="newClient.notes" label="Notas" placeholder="Alergias, preferencias..." />
        <BaseButton type="submit" variant="primary" class="w-full">Guardar Cliente</BaseButton>
      </form>
    </BaseModal>
  </div>
</template>
