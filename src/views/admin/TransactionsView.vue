<script setup>
import { ref, onMounted, computed } from 'vue'
import { supabase } from '@/lib/supabase'
import BaseButton from '@/components/ui/BaseButton.vue'
import BaseInput from '@/components/ui/BaseInput.vue'
import BaseModal from '@/components/ui/BaseModal.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import EmptyState from '@/components/ui/EmptyState.vue'

const transactions = ref([])
const loading = ref(false)
const showModal = ref(false)
const selectedDate = ref(new Date().toISOString().split('T')[0])

const transactionForm = ref({
  type: 'income',
  category: 'service',
  amount: '',
  description: '',
  transaction_date: new Date().toISOString().split('T')[0]
})

const categories = {
  income: [
    { value: 'service', label: 'Servicio' },
    { value: 'product_sale', label: 'Venta de producto' },
    { value: 'other', label: 'Otro ingreso' }
  ],
  expense: [
    { value: 'supplies', label: 'Insumos' },
    { value: 'rent', label: 'Alquiler' },
    { value: 'utilities', label: 'Servicios' },
    { value: 'salary', label: 'Salarios' },
    { value: 'other', label: 'Otro gasto' }
  ]
}

const fetchTransactions = async () => {
  loading.value = true
  const { data } = await supabase
    .from('transactions')
    .select('*')
    .eq('transaction_date', selectedDate.value)
    .order('created_at', { ascending: false })
  transactions.value = data || []
  loading.value = false
}

const saveTransaction = async () => {
  await supabase.from('transactions').insert([{
    ...transactionForm.value,
    amount: parseFloat(transactionForm.value.amount)
  }])
  showModal.value = false
  transactionForm.value = {
    type: 'income', category: 'service', amount: '', description: '',
    transaction_date: selectedDate.value
  }
  fetchTransactions()
}

const deleteTransaction = async (id) => {
  if (confirm('¿Eliminar esta transacción?')) {
    await supabase.from('transactions').delete().eq('id', id)
    fetchTransactions()
  }
}

const dailySummary = computed(() => {
  const income = transactions.value
    .filter(t => t.type === 'income')
    .reduce((sum, t) => sum + Number(t.amount), 0)
  const expense = transactions.value
    .filter(t => t.type === 'expense')
    .reduce((sum, t) => sum + Number(t.amount), 0)
  return { income, expense, balance: income - expense }
})

onMounted(fetchTransactions)
</script>

<template>
  <div>
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-bold mb-2">Transacciones</h1>
        <p class="text-[#a0a0b8]">Control diario de ingresos y gastos</p>
      </div>
      <BaseButton variant="primary" @click="showModal = true">+ Nueva Transacción</BaseButton>
    </div>

    <!-- Date Filter & Summary -->
    <div class="grid grid-cols-1 lg:grid-cols-4 gap-4 mb-6">
      <div class="lg:col-span-1">
        <label class="block text-sm text-[#a0a0b8] mb-2">Fecha</label>
        <input
          v-model="selectedDate"
          type="date"
          @change="fetchTransactions"
          class="w-full px-4 py-2.5 rounded-lg bg-[#16213e] border border-white/10 text-white outline-none"
        />
      </div>
      <div class="bg-[#16213e] rounded-xl p-4 border border-white/5">
        <div class="text-xs text-[#a0a0b8] mb-1">INGRESOS</div>
        <div class="text-2xl font-bold text-[#42b883]">${{ dailySummary.income.toFixed(2) }}</div>
      </div>
      <div class="bg-[#16213e] rounded-xl p-4 border border-white/5">
        <div class="text-xs text-[#a0a0b8] mb-1">GASTOS</div>
        <div class="text-2xl font-bold text-[#e94560]">${{ dailySummary.expense.toFixed(2) }}</div>
      </div>
      <div class="bg-[#16213e] rounded-xl p-4 border border-white/5">
        <div class="text-xs text-[#a0a0b8] mb-1">BALANCE</div>
        <div class="text-2xl font-bold" :class="dailySummary.balance >= 0 ? 'text-[#42b883]' : 'text-[#e94560]'">
          ${{ dailySummary.balance.toFixed(2) }}
        </div>
      </div>
    </div>

    <LoadingSpinner v-if="loading"/>

    <EmptyState
      v-else-if="transactions.length === 0"
      icon="💰"
      title="Sin transacciones"
      :description="`No hay movimientos registrados para ${selectedDate}`"
    />

    <div v-else class="space-y-2">
      <div
        v-for="t in transactions"
        :key="t.id"
        class="bg-[#16213e] rounded-xl p-4 border border-white/5 flex items-center justify-between"
      >
        <div class="flex items-center gap-4">
          <div
            class="w-10 h-10 rounded-full flex items-center justify-center text-lg"
            :class="t.type === 'income' ? 'bg-[#42b883]/20 text-[#42b883]' : 'bg-[#e94560]/20 text-[#e94560]'"
          >
            {{ t.type === 'income' ? '↓' : '↑' }}
          </div>
          <div>
            <div class="font-medium">{{ t.description || t.category }}</div>
            <div class="text-xs text-[#a0a0b8] capitalize">{{ categories[t.type]?.find(c => c.value === t.category)?.label || t.category }}</div>
          </div>
        </div>
        <div class="flex items-center gap-4">
          <span :class="t.type === 'income' ? 'text-[#42b883]' : 'text-[#e94560]'" class="font-bold text-lg">
            {{ t.type === 'income' ? '+' : '-' }}${{ Number(t.amount).toFixed(2) }}
          </span>
          <button @click="deleteTransaction(t.id)" class="text-[#6b6b8a] hover:text-[#e94560]">🗑</button>
        </div>
      </div>
    </div>

    <BaseModal :show="showModal" title="Nueva Transacción" @close="showModal = false">
      <form @submit.prevent="saveTransaction" class="space-y-4">
        <div>
          <label class="block text-sm text-[#a0a0b8] mb-2">Tipo</label>
          <div class="flex gap-2">
            <button
              type="button"
              @click="transactionForm.type = 'income'"
              class="flex-1 py-2.5 rounded-lg border transition-all"
              :class="transactionForm.type === 'income' ? 'bg-[#42b883] border-[#42b883] text-white' : 'bg-[#1a1a2e] border-white/10 text-[#a0a0b8]'"
            >Ingreso</button>
            <button
              type="button"
              @click="transactionForm.type = 'expense'"
              class="flex-1 py-2.5 rounded-lg border transition-all"
              :class="transactionForm.type === 'expense' ? 'bg-[#e94560] border-[#e94560] text-white' : 'bg-[#1a1a2e] border-white/10 text-[#a0a0b8]'"
            >Gasto</button>
          </div>
        </div>
        <div>
          <label class="block text-sm text-[#a0a0b8] mb-2">Categoría</label>
          <select v-model="transactionForm.category" class="w-full px-4 py-2.5 rounded-lg bg-[#1a1a2e] border border-white/10 text-white outline-none">
            <option v-for="cat in categories[transactionForm.type]" :key="cat.value" :value="cat.value">{{ cat.label }}</option>
          </select>
        </div>
        <BaseInput v-model="transactionForm.amount" label="Monto ($)" type="number" step="0.01" required />
        <BaseInput v-model="transactionForm.description" label="Descripción" />
        <BaseInput v-model="transactionForm.transaction_date" label="Fecha" type="date" required />
        <BaseButton type="submit" variant="primary" class="w-full">Guardar</BaseButton>
      </form>
    </BaseModal>
  </div>
</template>
