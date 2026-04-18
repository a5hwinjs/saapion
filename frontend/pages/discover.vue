<template>
  <div class="saapion-discover">
    <!-- Header Section -->
    <div class="mb-12">
      <h1 class="text-4xl md:text-5xl font-headline font-extrabold text-on-background tracking-tight mb-2">Discover Recipes</h1>
      <p class="text-on-surface-variant font-medium text-lg">Curated recipes for every kitchen scenario.</p>
    </div>
    
    <!-- Bento Grid Navigation -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-16">
      <!-- Fridge Matcher -->
      <div class="bg-surface-container-low rounded-3xl p-8 shadow-sm hover:shadow-diffuse hover:bg-surface-container transition-all cursor-pointer group relative overflow-hidden flex flex-col justify-between h-64 border border-outline-variant/10"
           @click="activeTab = 'fridge'">
        <div class="absolute -top-10 -right-10 w-32 h-32 bg-secondary-container/20 rounded-full group-hover:bg-secondary-container/40 transition-colors"></div>
        <div class="relative z-10">
          <span class="material-symbols-outlined text-secondary text-3xl mb-4 group-hover:scale-110 transition-transform">inventory_2</span>
          <h3 class="font-headline text-2xl font-bold mb-2 text-on-surface">Fridge Matcher</h3>
          <p class="text-on-surface-variant text-sm max-w-[200px]">Cook with ingredients already in your pantry.</p>
        </div>
        <div class="font-label text-xs font-bold text-secondary uppercase tracking-widest mt-auto group-hover:translate-x-1 transition-transform">
          Explore Matches &rarr;
        </div>
      </div>
      
      <!-- Exotic Ingredients -->
      <div class="bg-surface-container-low rounded-3xl p-8 shadow-sm hover:shadow-diffuse hover:bg-surface-container transition-all cursor-pointer group relative overflow-hidden flex flex-col justify-between h-64 border border-outline-variant/10"
           @click="activeTab = 'exotic'">
        <div class="absolute -top-10 -right-10 w-32 h-32 bg-tertiary-container/20 rounded-full group-hover:bg-tertiary-container/40 transition-colors"></div>
        <div class="relative z-10">
          <span class="material-symbols-outlined text-tertiary text-3xl mb-4 group-hover:scale-110 transition-transform">star</span>
          <h3 class="font-headline text-2xl font-bold mb-2 text-on-surface">Rare Spotlight</h3>
          <p class="text-on-surface-variant text-sm max-w-[200px]">Discover unique regional recipes featuring rare spices.</p>
        </div>
        <div class="font-label text-xs font-bold text-tertiary uppercase tracking-widest mt-auto group-hover:translate-x-1 transition-transform">
          Surprise Me &rarr;
        </div>
      </div>
      
      <!-- Quick Recipes -->
      <div class="bg-surface-container-low rounded-3xl p-8 shadow-sm hover:shadow-diffuse hover:bg-surface-container transition-all cursor-pointer group relative overflow-hidden flex flex-col justify-between h-64 border border-outline-variant/10"
           @click="activeTab = 'quickie'">
        <div class="absolute -top-10 -right-10 w-32 h-32 bg-primary-container/20 rounded-full group-hover:bg-primary-container/40 transition-colors"></div>
        <div class="relative z-10">
          <span class="material-symbols-outlined text-primary text-3xl mb-4 group-hover:scale-110 transition-transform">timer</span>
          <h3 class="font-headline text-2xl font-bold mb-2 text-on-surface">15-Min Quickies</h3>
          <p class="text-on-surface-variant text-sm max-w-[200px]">Fast, healthy Indian meals for busy days.</p>
        </div>
        <div class="font-label text-xs font-bold text-primary uppercase tracking-widest mt-auto group-hover:translate-x-1 transition-transform">
          Find Fast Meals &rarr;
        </div>
      </div>
    </div>
    
    <!-- Tab Content -->
    <div v-if="loading" class="min-h-[40vh] flex flex-col items-center justify-center gap-4">
      <div class="w-10 h-10 border-4 border-primary/20 border-t-primary rounded-full animate-spin"></div>
      <p class="text-xs font-bold text-on-surface-variant uppercase tracking-widest">Scouring the Cookbook...</p>
    </div>

    <div v-else-if="activeTab === 'fridge'" class="animate-in fade-in slide-in-from-bottom-4 duration-500">
      <div class="flex items-center justify-between mb-8">
        <div class="flex items-center gap-3">
          <span class="material-symbols-outlined text-secondary">check_circle</span>
          <h2 class="font-headline text-2xl font-bold text-on-background tracking-tight">Pantry Matches</h2>
        </div>
        <span class="font-label text-[10px] font-bold text-secondary uppercase bg-secondary-container px-3 py-1 rounded-full tracking-widest">Found {{ fridgeMatches.length }}</span>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div v-for="r in fridgeMatches" :key="r.id" 
             class="bg-surface-container-lowest p-6 rounded-3xl shadow-sm border border-outline-variant/10 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-6 group hover:bg-surface-dim transition-colors">
          <div class="flex items-center gap-4">
            <div class="w-16 h-16 rounded-2xl bg-surface-container overflow-hidden">
              <img :src="r.image_url || `https://source.unsplash.com/featured/200x200?indian,food,${r.id}`" :alt="r.title" class="w-full h-full object-cover transition-transform group-hover:scale-110" />
            </div>
            <div>
              <h4 class="font-headline font-bold text-lg text-on-surface leading-tight">{{ r.title }}</h4>
              <p class="text-[10px] text-secondary mt-1 font-bold uppercase tracking-wider flex items-center gap-1">
                <span class="material-symbols-outlined text-[14px]">done_all</span>
                High Match with your pantry
              </p>
            </div>
          </div>
          <NuxtLink :to="`/recipe/${r.id}`" 
                    class="w-full sm:w-auto px-6 py-2.5 bg-surface-container text-secondary rounded-full text-xs font-bold uppercase tracking-widest hover:bg-secondary hover:text-on-secondary transition-all text-center">
            View
          </NuxtLink>
        </div>
      </div>
    </div>

    <div v-else-if="activeTab === 'exotic' && exoticRecipe" class="animate-in fade-in slide-in-from-bottom-4 duration-500">
      <div class="flex items-center gap-3 mb-8">
        <span class="material-symbols-outlined text-tertiary">flare</span>
        <h2 class="font-headline text-2xl font-bold text-on-background tracking-tight">Ingredient Spotlight: <span class="text-tertiary italic">Exotic Selection</span></h2>
      </div>

      <div class="bg-surface-container-lowest p-8 rounded-[2rem] shadow-sm border border-outline-variant/10 relative overflow-hidden group">
        <div class="absolute -right-20 -bottom-20 w-64 h-64 bg-tertiary-container/10 rounded-full group-hover:scale-110 transition-transform duration-700"></div>
        <div class="relative z-10">
          <div class="flex justify-between items-start mb-6">
            <h4 class="font-headline font-extrabold text-3xl text-on-surface max-w-md">{{ exoticRecipe.title }}</h4>
            <span class="px-4 py-1.5 bg-tertiary-container text-on-tertiary-container text-[10px] font-bold rounded-full uppercase tracking-widest">Rare Discovery</span>
          </div>
          <p class="text-on-surface-variant text-lg leading-relaxed max-w-2xl mb-8">
            {{ exoticRecipe.description || 'Discover regional flavors and unique ingredients that make this dish a rare culinary experience.' }}
          </p>
          <NuxtLink :to="`/recipe/${exoticRecipe.id}`" 
                    class="inline-flex items-center gap-2 px-8 py-4 bg-tertiary text-on-tertiary rounded-full font-headline font-bold hover:bg-tertiary-container hover:text-on-tertiary-container transition-all shadow-diffuse active:scale-95 group/btn">
            Get Recipe
            <span class="material-symbols-outlined transition-transform group-hover/btn:translate-x-1">arrow_forward</span>
          </NuxtLink>
        </div>
      </div>
    </div>

    <div v-else-if="activeTab === 'quickie'" class="animate-in fade-in slide-in-from-bottom-4 duration-500">
      <div class="flex items-center justify-between mb-8">
        <div class="flex items-center gap-3">
          <span class="material-symbols-outlined text-primary">speed</span>
          <h2 class="font-headline text-2xl font-bold text-on-background tracking-tight">Under 15 Minutes</h2>
        </div>
        <span class="font-label text-[10px] font-bold text-primary uppercase bg-primary-container px-3 py-1 rounded-full tracking-widest">Fast Meals</span>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div v-for="r in quickies" :key="r.id" 
             class="bg-surface-container-lowest p-6 rounded-3xl shadow-sm border border-outline-variant/10 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-6 group hover:bg-surface-dim transition-colors">
          <div class="flex items-center gap-4">
            <div class="w-16 h-16 rounded-2xl bg-surface-container overflow-hidden">
              <img :src="r.image_url || `https://source.unsplash.com/featured/200x200?indian,food,${r.id}`" :alt="r.title" class="w-full h-full object-cover transition-transform group-hover:scale-110" />
            </div>
            <div>
              <h4 class="font-headline font-bold text-lg text-on-surface leading-tight">{{ r.title }}</h4>
              <p class="text-[10px] text-on-surface-variant/70 mt-1 font-bold uppercase tracking-widest flex items-center gap-3">
                <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">timer</span> {{ r.prep_time_mins + r.cook_time_mins }}m</span>
                <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">bolt</span> Very Easy</span>
              </p>
            </div>
          </div>
          <NuxtLink :to="`/recipe/${r.id}`" 
                    class="w-full sm:w-auto px-6 py-2.5 bg-primary-container text-on-primary-container rounded-full text-xs font-bold uppercase tracking-widest hover:bg-primary hover:text-on-primary transition-all text-center">
            Cook Now
          </NuxtLink>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const supabase = useSupabaseClient()
const activeTab = ref('fridge')
const loading = ref(true)

const fridgeMatches = ref([])
const exoticRecipe = ref(null)
const quickies = ref([])

onMounted(async () => {
  try {
    // 1. Fetch Quickies
    const { data: qData } = await supabase
      .from('recipes')
      .select('*')
      .eq('is_quickie', true)
      .limit(4)
    quickies.value = qData || []

    // 2. Fetch Exotic Spotlight
    const { data: eData } = await supabase
      .from('recipes')
      .select('*')
      .eq('is_exotic', true)
      .limit(1)
    if (eData?.length) exoticRecipe.value = eData[0]

    // 3. Fetch Fridge Matches (Mocking the matching logic for now, or fetching all for display)
    const { data: fData } = await supabase
      .from('recipes')
      .select('*')
      .limit(4)
    fridgeMatches.value = fData || []

  } catch (error) {
    console.error("Error fetching discover data:", error)
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200');

.material-symbols-outlined {
  font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
}

@keyframes fade-in {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slide-in-from-bottom-4 {
  from { transform: translateY(1rem); }
  to { transform: translateY(0); }
}

.animate-in {
  animation-duration: 500ms;
}
</style>