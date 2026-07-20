<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '@/lib/supabase'
import BaseButton from '@/components/ui/BaseButton.vue'

const router = useRouter()

const step = ref(1)
const services = ref([])
const employees = ref([])
const loading = ref(true)
const submitting = ref(false)
const error = ref(null)

const selectedService = ref(null)
const selectedEmployee = ref(null)
const selectedDate = ref('')
const selectedTime = ref('')
const clientData = ref({
  full_name: '',
  phone: '',
  email: ''
})

const timeSlots = ref([])

// Datos de respaldo con UUIDs válidos
const fallbackServices = [
  { id: '550e8400-e29b-41d4-a716-446655440001', name: 'Corte Clásico', description: 'Corte tradicional con tijera y máquina', price: 15.00, duration_minutes: 30 },
  { id: '550e8400-e29b-41d4-a716-446655440002', name: 'Corte Moderno', description: 'Corte con diseño y fade', price: 20.00, duration_minutes: 45 },
  { id: '550e8400-e29b-41d4-a716-446655440003', name: 'Afeitado Clásico', description: 'Afeitado con navaja y toalla caliente', price: 12.00, duration_minutes: 30 },
  { id: '550e8400-e29b-41d4-a716-446655440004', name: 'Arreglo de Barba', description: 'Delineado y mantenimiento de barba', price: 10.00, duration_minutes: 20 },
  { id: '550e8400-e29b-41d4-a716-446655440005', name: 'Manicure Hombre', description: 'Limpieza y arreglo de uñas', price: 8.00, duration_minutes: 25 },
  { id: '550e8400-e29b-41d4-a716-446655440006', name: 'Manicure Completo', description: 'Manicure con esmaltado', price: 15.00, duration_minutes: 45 },
  { id: '550e8400-e29b-41d4-a716-446655440007', name: 'Facial', description: 'Limpieza facial básica', price: 18.00, duration_minutes: 40 },
  { id: '550e8400-e29b-41d4-a716-446655440008', name: 'Corte + Barba', description: 'Paquete completo corte y barba', price: 25.00, duration_minutes: 60 }
]

const fallbackEmployees = [
  { id: '550e8400-e29b-41d4-a716-446655440010', full_name: 'Nico (Barbero Principal)' },
  { id: '550e8400-e29b-41d4-a716-446655440011', full_name: 'Carlos (Barbero)' }
]

const fetchServices = async () => {
  try {
    const { data, error: supaError } = await supabase
      .from('services')
      .select('id, name, description, price, duration_minutes')

    console.log('Services response:', { data, error: supaError })

    if (supaError) {
      console.warn('Error Supabase:', supaError)
      services.value = fallbackServices
    } else if (!data || data.length === 0) {
      console.warn('No hay datos, usando fallback')
      services.value = fallbackServices
    } else {
      services.value = data
    }
  } catch (err) {
    console.warn('Error catch:', err)
    services.value = fallbackServices
  }
}

const fetchEmployees = async () => {
  try {
    const { data, error: supaError } = await supabase
      .from('employees')
      .select('id, full_name')

    console.log('Employees response:', { data, error: supaError })

    if (supaError || !data || data.length === 0) {
      employees.value = fallbackEmployees
    } else {
      employees.value = data
    }
  } catch (err) {
    employees.value = fallbackEmployees
  }
}

const generateTimeSlots = () => {
  const slots = []
  for (let h = 9; h < 20; h++) {
    slots.push(`${h.toString().padStart(2, '0')}:00`)
    slots.push(`${h.toString().padStart(2, '0')}:30`)
  }
  timeSlots.value = slots
}

const selectService = (service) => {
  selectedService.value = service
  step.value = 2
}

const selectEmployee = (employee) => {
  selectedEmployee.value = employee
  step.value = 3
}

const selectDate = (date) => {
  selectedDate.value = date
  generateTimeSlots()
}

const selectTime = (time) => {
  selectedTime.value = time
  step.value = 4
}

const submitBooking = async () => {
  submitting.value = true
  error.value = null

  try {
    // Crear o buscar cliente
    let clientId
    const { data: existing } = await supabase
      .from('clients')
      .select('id')
      .eq('phone', clientData.value.phone)
      .single()

    if (existing) {
      clientId = existing.id
      await supabase.from('clients').update({
        full_name: clientData.value.full_name,
        email: clientData.value.email || null,
        last_visit: new Date().toISOString()
      }).eq('id', clientId)
    } else {
      const { data: newClient, error: clientErr } = await supabase
        .from('clients')
        .insert([{
          full_name: clientData.value.full_name,
          phone: clientData.value.phone,
          email: clientData.value.email || null
        }])
        .select()
        .single()

      if (clientErr) throw clientErr
      clientId = newClient.id
    }

    // Crear cita
    const { error: apptErr } = await supabase.from('appointments').insert([{
      client_id: clientId,
      employee_id: selectedEmployee.value?.id || null,
      service_id: selectedService.value.id,
      appointment_date: selectedDate.value,
      appointment_time: selectedTime.value,
      status: 'pending'
    }])

    if (apptErr) throw apptErr

    router.push('/exito')
  } catch (err) {
    error.value = err.message
    alert('Error al crear la cita: ' + err.message)
  } finally {
    submitting.value = false
  }
}

const minDate = computed(() => new Date().toISOString().split('T')[0])

onMounted(async () => {
  console.log('=== MOUNTED ===')
  await Promise.all([fetchServices(), fetchEmployees()])
  loading.value = false
  console.log('Services loaded:', services.value.length)
})
</script>

<template>
  <div class="min-h-screen py-12 px-6">
    <div class="max-w-2xl mx-auto">
      <div class="text-center mb-10">
        <h1 class="text-4xl font-bold mb-3 font-display">Reservar Cita</h1>
        <p class="text-gray-400">Solo necesitamos unos datos para confirmar tu cita</p>
      </div>

      <!-- Progress Steps -->
      <div class="flex items-center justify-center gap-2 mb-10">
        <div v-for="i in 4" :key="i" class="flex items-center gap-2">
          <div
            class="w-10 h-10 rounded-full flex items-center justify-center font-bold text-sm transition-all duration-300"
            :class="step >= i 
              ? 'bg-barber-accent text-white shadow-lg shadow-barber-accent/30' 
              : 'bg-barber-card text-gray-500 border border-white/10'"
          >
            {{ i }}
          </div>
          <div v-if="i < 4" class="w-8 h-0.5 rounded-full transition-all duration-300" 
            :class="step > i ? 'bg-barber-accent' : 'bg-white/10'"/>
        </div>
      </div>

      <!-- Loading -->
      <div v-if="loading" class="flex justify-center py-12">
        <div class="w-12 h-12 border-4 border-barber-accent/20 border-t-barber-accent rounded-full animate-spin"/>
      </div>

      <!-- Error -->
      <div v-else-if="error" class="bg-red-500/10 border border-red-500/20 rounded-xl p-6 text-center">
        <div class="text-4xl mb-3">⚠️</div>
        <h3 class="font-semibold text-red-400 mb-2">Error de conexión</h3>
        <p class="text-sm text-gray-400 mb-4">{{ error }}</p>
        <button @click="fetchServices" class="text-barber-accent hover:underline">Reintentar</button>
      </div>

      <!-- Step 1: Select Service -->
      <div v-else-if="step === 1" class="bg-barber-card rounded-2xl p-8 border border-white/5">
        <h2 class="text-xl font-semibold mb-6">Selecciona un servicio</h2>

        <div v-if="services.length === 0" class="text-center py-8 text-gray-400">
          No hay servicios disponibles
        </div>

        <div v-else class="grid gap-3">
          <button
            v-for="service in services"
            :key="service.id"
            @click="selectService(service)"
            class="flex items-center gap-4 p-4 bg-[#1a1a2e] rounded-xl border border-white/5 hover:border-barber-accent/50 transition-all text-left group"
          >
            <div class="w-14 h-14 rounded-xl flex items-center justify-center text-2xl flex-shrink-0 bg-barber-accent/10 text-barber-accent group-hover:bg-barber-accent/20 transition-colors">
              ✂️
            </div>
            <div class="flex-1 min-w-0">
              <div class="font-semibold text-lg">{{ service.name }}</div>
              <div class="text-sm text-gray-400">{{ service.duration_minutes }} min • {{ service.description }}</div>
            </div>
            <div class="text-right flex-shrink-0">
              <div class="text-lg font-bold text-barber-accent">${{ service.price }}</div>
              <div class="text-xs text-barber-green opacity-0 group-hover:opacity-100 transition-opacity">Seleccionar →</div>
            </div>
          </button>
        </div>
      </div>

      <!-- Step 2: Select Employee -->
      <div v-else-if="step === 2" class="bg-barber-card rounded-2xl p-8 border border-white/5">
        <div class="flex items-center justify-between mb-6">
          <h2 class="text-xl font-semibold">Selecciona un barbero</h2>
          <button @click="step = 1" class="text-sm text-gray-400 hover:text-white transition-colors flex items-center gap-1">
            ← Volver
          </button>
        </div>

        <div class="grid gap-3">
          <button
            v-for="emp in employees"
            :key="emp.id"
            @click="selectEmployee(emp)"
            class="flex items-center gap-4 p-4 bg-[#1a1a2e] rounded-xl border border-white/5 hover:border-barber-accent/50 transition-all text-left group"
          >
            <div class="w-14 h-14 bg-barber-green/20 rounded-full flex items-center justify-center text-2xl flex-shrink-0">
              👤
            </div>
            <div class="flex-1">
              <div class="font-semibold text-lg">{{ emp.full_name }}</div>
              <div class="text-sm text-gray-400">Barbero profesional</div>
            </div>
            <span class="text-barber-green flex-shrink-0">→</span>
          </button>

          <button
            @click="selectEmployee({ id: null, full_name: 'Cualquiera disponible' })"
            class="flex items-center gap-4 p-4 bg-[#1a1a2e] rounded-xl border border-white/5 hover:border-barber-accent/50 transition-all text-left group"
          >
            <div class="w-14 h-14 bg-barber-gold/20 rounded-full flex items-center justify-center text-2xl flex-shrink-0">
              🎲
            </div>
            <div class="flex-1">
              <div class="font-semibold text-lg">Cualquiera disponible</div>
              <div class="text-sm text-gray-400">Te asignaremos el primer barbero libre</div>
            </div>
            <span class="text-barber-green flex-shrink-0">→</span>
          </button>
        </div>
      </div>

      <!-- Step 3: Select Date & Time -->
      <div v-else-if="step === 3" class="bg-barber-card rounded-2xl p-8 border border-white/5">
        <div class="flex items-center justify-between mb-6">
          <h2 class="text-xl font-semibold">Fecha y hora</h2>
          <button @click="step = 2" class="text-sm text-gray-400 hover:text-white transition-colors flex items-center gap-1">
            ← Volver
          </button>
        </div>

        <div class="mb-6">
          <label class="block text-sm text-gray-400 mb-2">Fecha</label>
          <input
            v-model="selectedDate"
            type="date"
            :min="minDate"
            @change="selectDate(selectedDate)"
            class="w-full px-4 py-3 rounded-lg bg-[#1a1a2e] border border-white/10 text-white outline-none focus:border-barber-green focus:ring-1 focus:ring-barber-green/30"
          />
        </div>

        <div v-if="selectedDate">
          <label class="block text-sm text-gray-400 mb-3">Hora</label>
          <div class="grid grid-cols-4 sm:grid-cols-5 gap-2">
            <button
              v-for="time in timeSlots"
              :key="time"
              @click="selectTime(time)"
              class="py-3 rounded-lg border transition-all text-sm font-medium"
              :class="selectedTime === time 
                ? 'bg-barber-accent border-barber-accent text-white shadow-lg shadow-barber-accent/20' 
                : 'bg-[#1a1a2e] border-white/10 text-gray-400 hover:border-barber-accent/50 hover:text-white'"
            >
              {{ time }}
            </button>
          </div>
        </div>

        <div v-else class="text-center py-8 text-gray-500">
          Selecciona una fecha primero
        </div>
      </div>

      <!-- Step 4: Client Data -->
      <div v-else-if="step === 4" class="bg-barber-card rounded-2xl p-8 border border-white/5">
        <div class="flex items-center justify-between mb-6">
          <h2 class="text-xl font-semibold">Tus datos</h2>
          <button @click="step = 3" class="text-sm text-gray-400 hover:text-white transition-colors flex items-center gap-1">
            ← Volver
          </button>
        </div>

        <!-- Summary -->
        <div class="bg-[#1a1a2e] rounded-lg p-4 mb-6 space-y-2 text-sm">
          <div class="flex justify-between"><span class="text-gray-400">Servicio:</span> <span>{{ selectedService?.name }} - ${{ selectedService?.price }}</span></div>
          <div class="flex justify-between"><span class="text-gray-400">Barbero:</span> <span>{{ selectedEmployee?.full_name }}</span></div>
          <div class="flex justify-between"><span class="text-gray-400">Fecha:</span> <span>{{ selectedDate }}</span></div>
          <div class="flex justify-between"><span class="text-gray-400">Hora:</span> <span>{{ selectedTime }}</span></div>
        </div>

        <form @submit.prevent="submitBooking" class="space-y-4">
          <div>
            <label class="block text-sm text-gray-400 mb-2">Nombre completo <span class="text-barber-accent">*</span></label>
            <input
              v-model="clientData.full_name"
              required
              placeholder="Tu nombre"
              class="w-full px-4 py-3 rounded-lg bg-[#1a1a2e] border border-white/10 text-white outline-none focus:border-barber-green focus:ring-1 focus:ring-barber-green/30"
            />
          </div>
          <div>
            <label class="block text-sm text-gray-400 mb-2">Teléfono <span class="text-barber-accent">*</span></label>
            <input
              v-model="clientData.phone"
              required
              type="tel"
              placeholder="555-000-0000"
              class="w-full px-4 py-3 rounded-lg bg-[#1a1a2e] border border-white/10 text-white outline-none focus:border-barber-green focus:ring-1 focus:ring-barber-green/30"
            />
          </div>
          <div>
            <label class="block text-sm text-gray-400 mb-2">Email (opcional)</label>
            <input
              v-model="clientData.email"
              type="email"
              placeholder="tu@email.com"
              class="w-full px-4 py-3 rounded-lg bg-[#1a1a2e] border border-white/10 text-white outline-none focus:border-barber-green focus:ring-1 focus:ring-barber-green/30"
            />
          </div>

          <BaseButton
            type="submit"
            variant="primary"
            size="lg"
            :loading="submitting"
            class="w-full mt-6"
          >
            Confirmar Cita
          </BaseButton>
        </form>
      </div>
    </div>
  </div>
</template>
