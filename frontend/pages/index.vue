<template>
  <div class="bg-background text-on-background min-h-screen flex flex-col items-center justify-center p-6 relative overflow-hidden antialiased font-body">
    <!-- Editorial Decorative background -->
    <div class="absolute top-[-10%] left-[-10%] w-[500px] h-[500px] bg-primary-container/10 rounded-full blur-[120px] pointer-events-none opacity-60"></div>
    <div class="absolute bottom-[-10%] right-[-10%] w-[400px] h-[400px] bg-secondary-container/15 rounded-full blur-[100px] pointer-events-none opacity-50"></div>

    <div class="relative z-10 w-full max-w-2xl flex flex-col items-center text-center px-4">
      <!-- App Identity / Logo with Editorial feel -->
      <div class="mb-12 relative">
        <div class="w-32 h-32 bg-surface-container-low rounded-[2rem] shadow-diffuse flex items-center justify-center rotate-6 hover:rotate-0 transition-all duration-500 border border-outline-variant/10 overflow-hidden group">
          <div class="absolute inset-0 bg-gradient-to-br from-primary/10 to-primary-container/20 group-hover:scale-110 transition-transform duration-700"></div>
          <span class="text-6xl group-hover:scale-110 transition-transform duration-500 relative z-10">🍛</span>
        </div>
        <div class="absolute -bottom-2 -right-2 w-10 h-10 bg-tertiary rounded-full flex items-center justify-center text-on-tertiary shadow-lg animate-bounce">
          <span class="material-symbols-outlined text-lg" style="font-variation-settings: 'FILL' 1;">flare</span>
        </div>
      </div>

      <h1 class="text-6xl md:text-8xl font-headline font-extrabold text-on-background mb-6 tracking-tighter leading-tight">
        Saa<span class="text-primary italic font-serif font-medium tracking-normal">pion</span>
      </h1>
      
      <p class="text-xl md:text-2xl text-on-surface-variant mb-12 leading-relaxed max-w-xl font-medium">
        The digital inventory for your authentic <span class="text-secondary font-bold">South Indian</span> kitchen. Curated alchemy for your health.
      </p>
      
      <div v-if="user" class="w-full max-w-sm space-y-6">
        <div class="bg-surface-container-low p-4 rounded-2xl border border-outline-variant/10 shadow-sm">
          <p class="text-on-surface-variant font-medium text-sm">Welcome back, <span class="text-primary font-bold">{{ userEmail }}</span></p>
        </div>
        <NuxtLink to="/dashboard" class="w-full flex items-center justify-center gap-3 bg-gradient-to-br from-primary to-primary-container text-on-primary py-5 rounded-full font-headline font-bold text-xl shadow-diffuse hover:shadow-[0_12px_32px_rgba(126,87,0,0.3)] hover:-translate-y-1 transition-all group">
          <span>Go to Dashboard</span>
          <span class="material-symbols-outlined transition-transform group-hover:translate-x-1">arrow_forward</span>
        </NuxtLink>
      </div>
      
      <div v-else class="w-full max-w-sm flex flex-col space-y-6">
        <NuxtLink to="/login" class="w-full flex items-center justify-center gap-3 bg-gradient-to-br from-primary to-primary-container text-on-primary py-5 rounded-full font-headline font-bold text-xl shadow-diffuse hover:shadow-[0_12px_32px_rgba(126,87,0,0.3)] hover:-translate-y-1 transition-all group">
          <span>Get Started</span>
          <span class="material-symbols-outlined transition-transform group-hover:translate-x-1">arrow_forward</span>
        </NuxtLink>
        <p class="text-on-surface-variant text-sm font-medium">Experience the Culinary Alchemist</p>
      </div>

      <!-- High-end feature highlights -->
      <div class="mt-24 grid grid-cols-1 md:grid-cols-2 gap-8 w-full max-w-2xl">
        <div class="bg-surface-container-lowest/60 backdrop-blur-md p-8 rounded-[2rem] shadow-sm text-left border border-white/20 group hover:bg-surface-dim transition-colors">
          <div class="w-12 h-12 bg-secondary-container rounded-2xl flex items-center justify-center text-secondary mb-6 group-hover:scale-110 transition-transform">
            <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">inventory_2</span>
          </div>
          <h3 class="font-headline font-bold text-xl text-on-surface mb-2 tracking-tight">Pantry Smart</h3>
          <p class="text-on-surface-variant text-sm leading-relaxed">Alchemy starts with what you have. Optimize your existing ingredients.</p>
        </div>
        <div class="bg-surface-container-lowest/60 backdrop-blur-md p-8 rounded-[2rem] shadow-sm text-left border border-white/20 group hover:bg-surface-dim transition-colors">
          <div class="w-12 h-12 bg-tertiary-container rounded-2xl flex items-center justify-center text-tertiary mb-6 group-hover:scale-110 transition-transform">
            <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">analytics</span>
          </div>
          <h3 class="font-headline font-bold text-xl text-on-surface mb-2 tracking-tight">Macro Precision</h3>
          <p class="text-on-surface-variant text-sm leading-relaxed">Meet your vital goals with surgical nutritional accuracy.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const user = useSupabaseUser()
const userEmail = computed(() => user.value?.email || 'Chef')
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200');

.material-symbols-outlined {
  font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
}
</style>