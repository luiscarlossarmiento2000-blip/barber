import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'

export const useDashboardStore = defineStore('dashboard', () => {
  const stats = ref({
    todayAppointments: 0,
    todayRevenue: 0,
    weekRevenue: 0,
    monthRevenue: 0,
    totalClients: 0,
    pendingAppointments: 0
  })
  const recentAppointments = ref([])
  const dailyRevenue = ref([])
  const loading = ref(false)

  const fetchStats = async () => {
    loading.value = true
    const today = new Date().toISOString().split('T')[0]

    // Citas de hoy
    const { data: todayAppts } = await supabase
      .from('appointments')
      .select('*, services(price)')
      .eq('appointment_date', today)
      .eq('status', 'completed')

    // Ingresos de hoy
    const { data: todayIncome } = await supabase
      .from('transactions')
      .select('amount')
      .eq('type', 'income')
      .eq('transaction_date', today)

    // Ingresos de la semana
    const weekAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString().split('T')[0]
    const { data: weekIncome } = await supabase
      .from('transactions')
      .select('amount')
      .eq('type', 'income')
      .gte('transaction_date', weekAgo)

    // Ingresos del mes
    const monthStart = new Date(new Date().getFullYear(), new Date().getMonth(), 1).toISOString().split('T')[0]
    const { data: monthIncome } = await supabase
      .from('transactions')
      .select('amount')
      .eq('type', 'income')
      .gte('transaction_date', monthStart)

    // Total clientes
    const { count: clientCount } = await supabase
      .from('clients')
      .select('*', { count: 'exact', head: true })

    // Citas pendientes
    const { count: pendingCount } = await supabase
      .from('appointments')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'pending')
      .gte('appointment_date', today)

    stats.value = {
      todayAppointments: todayAppts?.length || 0,
      todayRevenue: todayIncome?.reduce((sum, t) => sum + Number(t.amount), 0) || 0,
      weekRevenue: weekIncome?.reduce((sum, t) => sum + Number(t.amount), 0) || 0,
      monthRevenue: monthIncome?.reduce((sum, t) => sum + Number(t.amount), 0) || 0,
      totalClients: clientCount || 0,
      pendingAppointments: pendingCount || 0
    }

    loading.value = false
  }

  const fetchRecentActivity = async () => {
    const { data } = await supabase
      .from('appointments')
      .select(`
        *,
        clients(full_name),
        services(name, price)
      `)
      .order('created_at', { ascending: false })
      .limit(10)

    recentAppointments.value = data || []
  }

  const fetchDailyRevenue = async (days = 7) => {
    const dates = []
    const values = []

    for (let i = days - 1; i >= 0; i--) {
      const date = new Date(Date.now() - i * 24 * 60 * 60 * 1000).toISOString().split('T')[0]
      dates.push(date)

      const { data } = await supabase
        .from('transactions')
        .select('amount')
        .eq('type', 'income')
        .eq('transaction_date', date)

      values.push(data?.reduce((sum, t) => sum + Number(t.amount), 0) || 0)
    }

    dailyRevenue.value = dates.map((date, i) => ({
      date,
      revenue: values[i]
    }))
  }

  return {
    stats,
    recentAppointments,
    dailyRevenue,
    loading,
    fetchStats,
    fetchRecentActivity,
    fetchDailyRevenue
  }
})
