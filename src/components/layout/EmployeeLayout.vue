<script setup>
import Sidebar from './Sidebar.vue'
</script>

<template>
  <div class="min-h-screen bg-[#0f0f1a] flex">
    <Sidebar />
    <main class="flex-1 ml-[260px] p-8">
      <RouterView />
    </main>
  </div>
</template>
