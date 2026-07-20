import { defineStore } from 'pinia'
import { ref } from 'vue'
import { supabase } from '@/lib/supabase'

export const useAppointmentsStore = defineStore('appointments', () => {
  const appointments = ref([])
  const loading = ref(false)
  const error = ref(null)

  const fetchAppointments = async (filters = {}) => {
    loading.value = true
    error.value = null

    let query = supabase
      .from('appointments')
      .select(`
        *,
        clients(full_name, phone),
        employees(full_name),
        services(name, price, duration_minutes, color)
      `)
      .order('appointment_date', { ascending: false })
      .order('appointment_time', { ascending: true })

    if (filters.date) {
      query = query.eq('appointment_date', filters.date)
    }
    if (filters.status) {
      query = query.eq('status', filters.status)
    }
    if (filters.employee_id) {
      query = query.eq('employee_id', filters.employee_id)
    }

    const { data, error: err } = await query

    if (err) {
      error.value = err.message
    } else {
      appointments.value = data || []
    }
    loading.value = false
    return data
  }

  const createAppointment = async (appointmentData) => {
    const { data, error: err } = await supabase
      .from('appointments')
      .insert([appointmentData])
      .select(`
        *,
        clients(full_name, phone),
        employees(full_name),
        services(name, price, duration_minutes, color)
      `)
      .single()

    if (err) throw err
    appointments.value.unshift(data)
    return data
  }

  const updateStatus = async (id, status) => {
    const { data, error: err } = await supabase
      .from('appointments')
      .update({ status })
      .eq('id', id)
      .select()
      .single()

    if (err) throw err

    const idx = appointments.value.findIndex(a => a.id === id)
    if (idx !== -1) appointments.value[idx] = data
    return data
  }

  const deleteAppointment = async (id) => {
    const { error: err } = await supabase
      .from('appointments')
      .delete()
      .eq('id', id)

    if (err) throw err
    appointments.value = appointments.value.filter(a => a.id !== id)
  }

  return {
    appointments,
    loading,
    error,
    fetchAppointments,
    createAppointment,
    updateStatus,
    deleteAppointment
  }
})
