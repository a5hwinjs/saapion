<template>
  <div class="min-h-screen bg-gray-50 flex flex-col">
    <header class="bg-green-600 text-white shadow relative z-20">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
        <NuxtLink to="/" class="font-bold text-xl">Saapion</NuxtLink>
        <div class="flex items-center space-x-4">
          <nav class="hidden md:flex space-x-4">
            <NuxtLink to="/dashboard" class="hover:bg-green-700 px-3 py-2 rounded">Plan</NuxtLink>
            <NuxtLink to="/discover" class="hover:bg-green-700 px-3 py-2 rounded">Discover</NuxtLink>
            <NuxtLink to="/onboarding/pantry" class="hover:bg-green-700 px-3 py-2 rounded">Pantry</NuxtLink>
          </nav>
          
          <!-- Hamburger menu wrapper -->
          <div class="relative" v-if="user">
            <button @click="menuOpen = !menuOpen" class="flex flex-col items-center justify-center p-2 rounded hover:bg-green-700 focus:outline-none">
              <span class="text-xs font-semibold mb-1" v-if="userName">{{ userName }}</span>
              <!-- Hamburger Icon -->
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
              </svg>
            </button>

            <!-- Dropdown -->
            <div v-if="menuOpen" class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 text-gray-700 ring-1 ring-black ring-opacity-5">
              <!-- Mobile-only links -->
              <NuxtLink to="/dashboard" class="block md:hidden px-4 py-2 text-sm hover:bg-gray-100" @click="menuOpen = false">Plan</NuxtLink>
              <NuxtLink to="/discover" class="block md:hidden px-4 py-2 text-sm hover:bg-gray-100" @click="menuOpen = false">Discover</NuxtLink>
              <NuxtLink to="/onboarding/pantry" class="block md:hidden px-4 py-2 text-sm hover:bg-gray-100" @click="menuOpen = false">Pantry</NuxtLink>
              <div class="border-t border-gray-100 md:hidden"></div>
              
              <!-- Requested menu items -->
              <button @click="handleAction('suggest')" class="w-full text-left px-4 py-2 text-sm hover:bg-gray-100">Suggest a recipe</button>
              <button @click="handleAction('feedback')" class="w-full text-left px-4 py-2 text-sm hover:bg-gray-100">Give feedback</button>
              <div class="border-t border-gray-100"></div>
              <button @click="handleLogout" class="w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-gray-100">Logout</button>
            </div>
          </div>
        </div>
      </div>
    </header>
    <main class="flex-grow max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full relative z-10">
      <slot />
    </main>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const user = useSupabaseUser()
const supabase = useSupabaseClient()
const menuOpen = ref(false)

const userName = computed(() => {
  if (!user.value) return ''
  // Supabase stores Google name and custom email signups in user_metadata
  return user.value.user_metadata?.full_name || 
         user.value.user_metadata?.name || 
         user.value.email?.split('@')[0] || 
         'User'
})

const handleLogout = async () => {
  menuOpen.value = false
  await supabase.auth.signOut()
  navigateTo('/')
}

const handleAction = (action) => {
  menuOpen.value = false
  if (action === 'suggest') {
    alert('Suggest a recipe clicked. (Mock implementation)')
  } else if (action === 'feedback') {
    alert('Give feedback clicked. (Mock implementation)')
  }
}
</script>