<template>
  <div class="bg-background text-on-background min-h-screen flex flex-col md:flex-row antialiased font-body">
    <!-- TopAppBar (Mobile Only) -->
    <header v-if="user" class="fixed top-0 w-full z-50 bg-background/80 backdrop-blur-md flex justify-between items-center px-6 py-4 md:hidden border-b border-outline-variant/10">
      <div class="flex items-center gap-3">
        <div class="w-8 h-8 rounded-full bg-surface-variant overflow-hidden border border-outline-variant/20">
          <img v-if="userAvatar" :src="userAvatar" alt="User avatar" class="w-full h-full object-cover" />
          <div v-else class="w-full h-full flex items-center justify-center bg-primary-container text-on-primary-container text-xs font-bold">
            {{ userInitials }}
          </div>
        </div>
        <NuxtLink to="/dashboard" class="text-2xl font-extrabold text-primary tracking-tighter font-headline">Saapion</NuxtLink>
      </div>
      <button class="text-primary hover:bg-surface-container-low p-2 rounded-full transition-transform duration-200 active:scale-95">
        <span class="material-symbols-outlined">notifications</span>
      </button>
    </header>

    <!-- NavigationDrawer (Desktop Only Sidebar) -->
    <nav v-if="user" class="hidden md:flex w-72 h-full fixed left-0 top-0 flex-col p-6 bg-surface shadow-2xl z-40 border-r border-outline-variant/10">
      <div class="mb-10 flex items-center gap-4">
        <div class="w-12 h-12 rounded-full overflow-hidden bg-surface-variant border border-outline-variant/20">
          <img v-if="userAvatar" :src="userAvatar" alt="User avatar" class="w-full h-full object-cover" />
          <div v-else class="w-full h-full flex items-center justify-center bg-primary-container text-on-primary-container font-bold">
            {{ userInitials }}
          </div>
        </div>
        <div class="overflow-hidden">
          <h2 class="text-primary font-headline font-bold text-lg tracking-tight truncate">Saapion</h2>
          <p class="text-on-surface-variant text-sm font-medium truncate">{{ userName }}</p>
          <p class="text-xs text-on-surface-variant/70 truncate">{{ userEmail }}</p>
        </div>
      </div>

      <div class="flex-1 flex flex-col gap-1 overflow-y-auto no-scrollbar">
        <NuxtLink v-for="link in navLinks" :key="link.to" :to="link.to" 
          class="flex items-center gap-4 px-4 py-3 rounded-xl transition-all font-headline font-medium group"
          :class="[route.path === link.to ? 'bg-primary-container text-on-primary-container font-bold shadow-diffuse' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary']"
        >
          <span class="material-symbols-outlined group-hover:scale-110 transition-transform" :data-weight="route.path === link.to ? 'fill' : ''">{{ link.icon }}</span>
          {{ link.label }}
        </NuxtLink>

        <div class="mt-8 mb-4 border-t border-outline-variant/15"></div>
        
        <NuxtLink to="/onboarding/diet" class="flex items-center gap-4 px-4 py-3 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-primary transition-all font-headline font-medium group">
          <span class="material-symbols-outlined group-hover:scale-110 transition-transform">face_6</span>
          Dietary Profile
        </NuxtLink>
      </div>

      <div class="mt-auto pt-4">
        <button @click="handleLogout" class="w-full flex items-center gap-4 px-4 py-3 rounded-xl text-error hover:bg-error-container hover:text-on-error-container transition-all font-headline font-medium group">
          <span class="material-symbols-outlined group-hover:scale-110 transition-transform">logout</span>
          Logout
        </button>
      </div>
    </nav>

    <!-- Main Content Canvas -->
    <main class="flex-1 transition-all duration-300" :class="[user ? 'md:ml-72 pt-20 md:pt-8 px-4 md:px-12 pb-28 md:pb-8' : 'w-full']">
      <div class="max-w-7xl mx-auto w-full">
        <slot />
      </div>
    </main>

    <!-- BottomNavBar (Mobile Only) -->
    <nav v-if="user" class="md:hidden fixed bottom-0 w-full rounded-t-3xl z-50 bg-background/90 backdrop-blur-md shadow-[0_-8px_24px_rgba(27,28,23,0.08)] border-t border-outline-variant/10 flex justify-around items-center px-4 pb-8 pt-2">
      <NuxtLink v-for="link in navLinks" :key="link.to" :to="link.to" 
        class="flex flex-col items-center justify-center p-2 rounded-2xl transition-all group relative"
        :class="[route.path === link.to ? 'text-primary' : 'text-on-surface-variant']"
      >
        <div v-if="route.path === link.to" class="absolute -top-1 w-1 h-1 bg-primary rounded-full"></div>
        <span class="material-symbols-outlined mb-1 group-active:scale-90 transition-transform" :data-weight="route.path === link.to ? 'fill' : ''">{{ link.icon }}</span>
        <span class="font-label text-[10px] font-bold tracking-widest uppercase">{{ link.label }}</span>
      </NuxtLink>
    </nav>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const user = useSupabaseUser()
const supabase = useSupabaseClient()
const route = useRoute()

const navLinks = [
  { to: '/dashboard', label: 'Plan', icon: 'calendar_view_week' },
  { to: '/onboarding/pantry', label: 'Pantry', icon: 'inventory_2' },
  { to: '/discover', label: 'Discover', icon: 'menu_book' },
  { to: '/metrics', label: 'Macros', icon: 'analytics' },
]

const userName = computed(() => {
  if (!user.value) return ''
  return user.value.user_metadata?.full_name || user.value.user_metadata?.name || user.value.email?.split('@')[0] || 'Chef'
})

const userEmail = computed(() => user.value?.email || '')

const userAvatar = computed(() => user.value?.user_metadata?.avatar_url || '')

const userInitials = computed(() => {
  const name = userName.value
  if (!name) return 'S'
  return name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2)
})

const handleLogout = async () => {
  await supabase.auth.signOut()
  navigateTo('/login')
}
</script>

<style scoped>
/* Ensure Google Material Symbols are loaded */
@import url('https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200');

.material-symbols-outlined {
  font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
}
.material-symbols-outlined[data-weight="fill"] {
  font-variation-settings: 'FILL' 1;
}

/* Hide scrollbar for clean vertical scroll */
.no-scrollbar::-webkit-scrollbar {
    display: none;
}
.no-scrollbar {
    -ms-overflow-style: none;
    scrollbar-width: none;
}
</style>