<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'
import BaseButton from '@/components/ui/BaseButton.vue'
import BaseInput from '@/components/ui/BaseInput.vue'
import BaseModal from '@/components/ui/BaseModal.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import EmptyState from '@/components/ui/EmptyState.vue'

const products = ref([])
const loading = ref(false)
const showModal = ref(false)
const editingId = ref(null)

const productForm = ref({
  name: '',
  description: '',
  price: '',
  cost: '',
  stock: 0,
  category: 'haircare',
  brand: '',
  image_url: '',
  is_featured: false,
  is_active: true
})

const categories = [
  { value: 'haircare', label: 'Cuidado del Cabello' },
  { value: 'beard', label: 'Cuidado de Barba' },
  { value: 'skincare', label: 'Cuidado de la Piel' },
  { value: 'tools', label: 'Herramientas' },
  { value: 'other', label: 'Otros' }
]

const fetchProducts = async () => {
  loading.value = true
  const { data } = await supabase
    .from('products')
    .select('*')
    .order('is_featured', { ascending: false })
    .order('name')
  products.value = data || []
  loading.value = false
}

const saveProduct = async () => {
  const payload = {
    ...productForm.value,
    price: parseFloat(productForm.value.price),
    cost: parseFloat(productForm.value.cost) || 0,
    stock: parseInt(productForm.value.stock) || 0
  }

  if (editingId.value) {
    await supabase.from('products').update(payload).eq('id', editingId.value)
  } else {
    await supabase.from('products').insert([payload])
  }

  showModal.value = false
  resetForm()
  fetchProducts()
}

const editProduct = (product) => {
  editingId.value = product.id
  productForm.value = { ...product }
  showModal.value = true
}

const toggleActive = async (product) => {
  await supabase.from('products').update({ is_active: !product.is_active }).eq('id', product.id)
  fetchProducts()
}

const toggleFeatured = async (product) => {
  await supabase.from('products').update({ is_featured: !product.is_featured }).eq('id', product.id)
  fetchProducts()
}

const deleteProduct = async (id) => {
  if (confirm('¿Eliminar este producto?')) {
    await supabase.from('products').delete().eq('id', id)
    fetchProducts()
  }
}

const resetForm = () => {
  editingId.value = null
  productForm.value = {
    name: '', description: '', price: '', cost: '', stock: 0,
    category: 'haircare', brand: '', image_url: '', is_featured: false, is_active: true
  }
}

onMounted(fetchProducts)
</script>

<template>
  <div>
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-bold mb-2">Productos</h1>
        <p class="text-[#a0a0b8]">Gestiona tu inventario de productos de belleza</p>
      </div>
      <BaseButton variant="primary" @click="showModal = true; resetForm()">+ Nuevo Producto</BaseButton>
    </div>

    <LoadingSpinner v-if="loading"/>

    <EmptyState
      v-else-if="products.length === 0"
      icon="📦"
      title="Sin productos"
      description="Agrega productos para vender en tu barbería."
    />

    <div v-else class="grid gap-3">
      <div
        v-for="product in products"
        :key="product.id"
        class="bg-[#16213e] rounded-xl p-5 border border-white/5 flex items-center justify-between"
      >
        <div class="flex items-center gap-4">
          <div class="w-14 h-14 bg-[#1a1a2e] rounded-lg flex items-center justify-center text-2xl border border-white/5">
            {{ product.image_url ? '📷' : '📦' }}
          </div>
          <div>
            <div class="flex items-center gap-2">
              <span class="font-semibold text-lg">{{ product.name }}</span>
              <span v-if="product.is_featured" class="bg-[#f39c12]/15 text-[#f39c12] px-2 py-0.5 rounded text-xs font-medium">⭐ Destacado</span>
              <span v-if="!product.is_active" class="bg-[#e94560]/15 text-[#e94560] px-2 py-0.5 rounded text-xs font-medium">Inactivo</span>
            </div>
            <div class="text-sm text-[#a0a0b8]">
              ${{ product.price }} • Stock: {{ product.stock }} • {{ categories.find(c => c.value === product.category)?.label }}
              <span v-if="product.brand"> • {{ product.brand }}</span>
            </div>
          </div>
        </div>
        <div class="flex gap-2">
          <BaseButton variant="secondary" size="sm" @click="toggleFeatured(product)">
            {{ product.is_featured ? '⭐' : '☆' }}
          </BaseButton>
          <BaseButton variant="secondary" size="sm" @click="editProduct(product)">✏️</BaseButton>
          <BaseButton variant="ghost" size="sm" @click="toggleActive(product)">
            {{ product.is_active ? '⏸' : '▶' }}
          </BaseButton>
          <BaseButton variant="danger" size="sm" @click="deleteProduct(product.id)">🗑</BaseButton>
        </div>
      </div>
    </div>

    <BaseModal :show="showModal" :title="editingId ? 'Editar Producto' : 'Nuevo Producto'" @close="showModal = false">
      <form @submit.prevent="saveProduct" class="space-y-4">
        <BaseInput v-model="productForm.name" label="Nombre" required />
        <BaseInput v-model="productForm.description" label="Descripción" />
        <div class="grid grid-cols-3 gap-4">
          <BaseInput v-model="productForm.price" label="Precio venta ($)" type="number" step="0.01" required />
          <BaseInput v-model="productForm.cost" label="Costo ($)" type="number" step="0.01" />
          <BaseInput v-model="productForm.stock" label="Stock" type="number" required />
        </div>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm text-[#a0a0b8] mb-2">Categoría</label>
            <select v-model="productForm.category" class="w-full px-4 py-2.5 rounded-lg bg-[#1a1a2e] border border-white/10 text-white outline-none">
              <option v-for="cat in categories" :key="cat.value" :value="cat.value">{{ cat.label }}</option>
            </select>
          </div>
          <BaseInput v-model="productForm.brand" label="Marca" />
        </div>
        <BaseInput v-model="productForm.image_url" label="URL de imagen (opcional)" placeholder="https://..." />
        <div class="flex items-center gap-2">
          <input v-model="productForm.is_featured" type="checkbox" id="featured" class="w-4 h-4 rounded accent-[#e94560]"/>
          <label for="featured" class="text-sm">Destacar en página de reservas</label>
        </div>
        <BaseButton type="submit" variant="primary" class="w-full">Guardar Producto</BaseButton>
      </form>
    </BaseModal>
  </div>
</template>
