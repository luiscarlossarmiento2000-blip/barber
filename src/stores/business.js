import { defineStore } from 'pinia'
import { ref } from 'vue'
import { supabase } from '@/lib/supabase'

export const useBusinessStore = defineStore('business', () => {
  const settings = ref(null)
  const loading = ref(false)

  const fetchSettings = async () => {
    const { data } = await supabase
      .from('business_settings')
      .select('*')
      .single()

    settings.value = data
    return data
  }

  const updateSettings = async (updates) => {
    const { data, error } = await supabase
      .from('business_settings')
      .update(updates)
      .eq('id', settings.value.id)
      .select()
      .single()

    if (error) throw error
    settings.value = data
    return data
  }

  return {
    settings,
    loading,
    fetchSettings,
    updateSettings
  }
})
