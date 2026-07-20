<script setup>
import { onMounted } from 'vue'
import { useDashboardStore } from '@/stores/dashboard'
import StatsCards from '@/components/dashboard/StatsCards.vue'
import RevenueChart from '@/components/dashboard/RevenueChart.vue'
import RecentActivity from '@/components/dashboard/RecentActivity.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'

const dashboardStore = useDashboardStore()

onMounted(() => {
  dashboardStore.fetchStats()
  dashboardStore.fetchRecentActivity()
  dashboardStore.fetchDailyRevenue()
})
</script>

<template>
  <div>
    <div class="mb-8">
      <h1 class="text-3xl font-bold mb-2">Dashboard</h1>
      <p class="text-[#a0a0b8]">Resumen de tu barbería hoy</p>
    </div>

    <LoadingSpinner v-if="dashboardStore.loading" />

    <template v-else>
      <StatsCards :stats="dashboardStore.stats" />

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mt-6">
        <RevenueChart :data="dashboardStore.dailyRevenue" />
        <RecentActivity :appointments="dashboardStore.recentAppointments" />
      </div>
    </template>
  </div>
</template>
