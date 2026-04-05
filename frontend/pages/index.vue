<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50 p-4">
    <div class="text-center">
      <h1 class="text-4xl font-bold text-green-600 mb-4">Saapion</h1>
      <p class="text-xl text-gray-600 mb-8">Personalized Indian Meal Planner & Macro Tracker</p>
      
      <div v-if="user" class="space-y-4">
        <p class="text-gray-800">Welcome back, <span class="font-semibold">{{ user.email }}</span></p>
        <NuxtLink to="/dashboard" class="inline-block bg-green-600 text-white px-8 py-3 rounded-lg font-bold hover:bg-green-700 transition">
          Go to Dashboard
        </NuxtLink>
      </div>
      
      <div v-else class="space-x-4">
        <NuxtLink to="/login" class="inline-block bg-green-600 text-white px-8 py-3 rounded-lg font-bold hover:bg-green-700 transition">
          Login / Sign Up
        </NuxtLink>
      </div>
    </div>
  </div>
</template>

<script setup>
const user = useSupabaseUser()

// Optional: Auto-redirect if not logged in
/*
onMounted(() => {
  if (!user.value) {
    navigateTo('/login')
  }
})
*/
</script>