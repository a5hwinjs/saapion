<template>
  <div class="saapion-app-container min-h-screen flex flex-col items-center justify-center p-6 relative overflow-hidden bg-[var(--color-bg-light)]">
    <!-- Decorative background blobs -->
    <div class="absolute top-[-10%] left-[-10%] w-64 h-64 bg-pastel-mint rounded-full mix-blend-multiply filter blur-3xl opacity-50 animate-blob"></div>
    <div class="absolute top-[20%] right-[-10%] w-72 h-72 bg-blue-200 rounded-full mix-blend-multiply filter blur-3xl opacity-50 animate-blob animation-delay-2000"></div>
    <div class="absolute bottom-[-10%] left-[20%] w-80 h-80 bg-pink-200 rounded-full mix-blend-multiply filter blur-3xl opacity-50 animate-blob animation-delay-4000"></div>

    <div class="relative z-10 w-full max-w-sm flex flex-col items-center text-center">
      <!-- App Logo / Icon Placeholder -->
      <div class="w-24 h-24 bg-white rounded-3xl shadow-diffuse flex items-center justify-center mb-8 rotate-3 hover:rotate-0 transition-transform duration-300">
        <span class="text-4xl">🍛</span>
      </div>

      <h1 class="text-5xl font-extrabold text-gray-800 mb-4 tracking-tight">Saapion</h1>
      <p class="text-lg text-gray-600 mb-10 leading-relaxed">
        Your playful, personalized Indian meal planner. Track macros, manage your pantry, and discover delicious recipes effortlessly!
      </p>
      
      <div v-if="user" class="w-full space-y-4">
        <p class="text-gray-800 font-medium">Welcome back, <span class="text-accent-teal">{{ user.email }}</span>!</p>
        <NuxtLink to="/dashboard" class="w-full block bg-accent-teal text-white py-4 rounded-2xl font-bold text-lg shadow-diffuse hover:bg-teal-600 hover:-translate-y-1 transition-all">
          Go to Dashboard
        </NuxtLink>
      </div>
      
      <div v-else class="w-full flex flex-col space-y-4">
        <NuxtLink to="/login" class="w-full block bg-accent-teal text-white py-4 rounded-2xl font-bold text-lg shadow-diffuse hover:bg-teal-600 hover:-translate-y-1 transition-all">
          Get Started
        </NuxtLink>
      </div>

      <!-- Feature highlights -->
      <div class="mt-16 grid grid-cols-2 gap-4 w-full">
        <div class="bg-white/60 backdrop-blur-sm p-4 rounded-2xl shadow-sm text-center border border-white/50">
          <div class="text-2xl mb-2">🛒</div>
          <h3 class="font-bold text-sm text-gray-800 mb-1">Pantry Smart</h3>
          <p class="text-xs text-gray-500">Cook with what you have.</p>
        </div>
        <div class="bg-white/60 backdrop-blur-sm p-4 rounded-2xl shadow-sm text-center border border-white/50">
          <div class="text-2xl mb-2">📊</div>
          <h3 class="font-bold text-sm text-gray-800 mb-1">Macro Tracking</h3>
          <p class="text-xs text-gray-500">Hit your health goals.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const user = useSupabaseUser()
</script>