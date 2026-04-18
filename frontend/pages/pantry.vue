<template>
  <div class="bg-background text-on-background font-body min-h-screen">
    <!-- TopNavBar (Simplified for demo) -->
    <nav class="fixed top-0 w-full z-50 bg-background/80 backdrop-blur-lg shadow-[0_8px_24px_rgba(0,0,0,0.06)] flex justify-between items-center px-6 py-3">
      <div class="flex items-center gap-2">
        <span class="material-symbols-outlined text-primary text-2xl" style="font-variation-settings: 'FILL' 1;">restaurant</span>
        <span class="font-headline font-black text-xl text-primary tracking-tighter">The Culinary Alchemist</span>
      </div>
      <div class="hidden md:flex items-center gap-8">
        <NuxtLink to="/dashboard" class="font-headline font-bold tracking-tight text-stone-500 hover:bg-surface-container-low px-3 py-1 rounded transition-colors">Kitchen Dashboard</NuxtLink>
        <NuxtLink to="/pantry" class="font-headline font-bold tracking-tight text-primary border-b-2 border-primary px-3 py-1">Shared Pantry</NuxtLink>
        <NuxtLink to="/metrics" class="font-headline font-bold tracking-tight text-stone-500 hover:bg-surface-container-low px-3 py-1 rounded transition-colors">Macros</NuxtLink>
      </div>
      <div class="w-8 h-8 rounded-full bg-surface-container-highest overflow-hidden">
        <img alt="User profile" class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDEM5jNiV0ajvSaIsUUYniOxEr9FM7E-Mcn40DfBqBoA729ntywAKneDVDbMSEf5aZpWF82P_QpxqCYHHWhtKdgOZWftrX3W5Jw_jkx9kUpZlUR7uStsT19Oplt8QlzjQIBJCu_7eYhYoI1OT-uQyOMT8nCLpMbKDXT3tYbWexInt4Rt22Xm6yj6yff8ksYL9djQX8-5zZELjoeXEoo6mWzNIetFk5TRwLz4JIUDghfmnWsf9InZ1k6g9Ny6a8KV5LQmcsFoSR20nL_" />
      </div>
    </nav>

    <!-- SideNavBar (Hidden on smaller screens, standard layout) -->
    <aside class="fixed left-0 top-0 h-full w-72 bg-surface-container-low flex-col hidden lg:flex z-40">
      <div class="pt-24 pb-8 px-6">
        <nav class="space-y-2">
          <NuxtLink to="/dashboard" class="flex items-center gap-3 px-4 py-3 text-stone-600 hover:bg-background/50 hover:translate-x-1 transition-all rounded-lg font-medium text-sm">
            <span class="material-symbols-outlined">dashboard</span>Kitchen Dashboard
          </NuxtLink>
          <NuxtLink to="/pantry" class="flex items-center gap-3 px-4 py-3 bg-surface-container-lowest text-primary rounded-lg font-bold shadow-sm transition-all text-sm">
            <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">inventory_2</span>Shared Pantry
          </NuxtLink>
          <NuxtLink to="/metrics" class="flex items-center gap-3 px-4 py-3 text-stone-600 hover:bg-background/50 hover:translate-x-1 transition-all rounded-lg font-medium text-sm">
            <span class="material-symbols-outlined">analytics</span>Daily Alchemy
          </NuxtLink>
        </nav>
      </div>
    </aside>

    <main class="lg:pl-72 pt-20 min-h-screen pb-20">
      <div class="p-8 max-w-[1600px] mx-auto">
        <!-- Header -->
        <header class="flex flex-col md:flex-row md:items-end justify-between gap-6 mb-12">
          <div class="space-y-2">
            <div class="flex items-center gap-2 text-secondary font-bold text-sm tracking-widest uppercase">
              <span class="material-symbols-outlined text-lg">grocery</span>Inventory Master
            </div>
            <h2 class="font-headline text-5xl font-extrabold tracking-tight text-on-surface">Shared Pantry</h2>
            <p class="text-on-surface-variant max-w-md">Real-time tracking of shared household staples and specialized ingredients for the Alchemist's kitchen.</p>
          </div>
          <NuxtLink to="/onboarding/pantry" class="bg-primary text-on-primary px-6 py-3 rounded-full font-bold shadow-sm hover:bg-primary/90 transition-colors shrink-0">
            Update Pantry
          </NuxtLink>
        </header>

        <!-- Loading -->
        <div v-if="loading" class="flex flex-col items-center py-20 gap-4">
          <div class="w-12 h-12 border-4 border-primary/20 border-t-primary rounded-full animate-spin"></div>
          <p class="font-label text-sm font-bold text-on-surface-variant uppercase tracking-widest">Loading Pantry...</p>
        </div>

        <div v-else>
          <!-- Status Overview Bento -->
          <section class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
            <div class="md:col-span-2 bg-surface-container-lowest p-8 rounded-3xl relative overflow-hidden flex items-center shadow-sm">
              <div class="z-10 w-full">
                <h3 class="font-headline text-2xl font-bold mb-4">Urgent Replenishments</h3>
                <div class="flex flex-wrap gap-3">
                  <span v-for="ing in lowStockItems" :key="ing.id" class="bg-tertiary-container/30 text-on-tertiary-container px-4 py-2 rounded-full text-sm font-bold flex items-center gap-2">
                    <span class="w-2 h-2 rounded-full bg-tertiary"></span> {{ ing.name }} ({{ ing.amount }}{{ ing.unit }})
                  </span>
                  <span v-if="lowStockItems.length === 0" class="text-on-surface-variant font-medium">All items well stocked!</span>
                </div>
              </div>
            </div>
            <div class="bg-primary-container p-8 rounded-3xl flex flex-col justify-between shadow-sm">
              <div>
                <div class="text-on-primary-container font-black text-4xl mb-1">{{ pantryFillPercentage }}%</div>
                <div class="text-on-primary-container/80 font-bold uppercase tracking-wider text-xs">Pantry Optimization</div>
              </div>
              <div class="h-2 w-full bg-white/30 rounded-full mt-4">
                <div class="h-full bg-on-primary-container rounded-full" :style="`width: ${pantryFillPercentage}%`"></div>
              </div>
            </div>
          </section>

          <!-- Categories -->
          <section class="relative">
            <div class="flex items-center justify-between mb-6">
              <h3 class="font-headline text-2xl font-bold flex items-center gap-3">
                Category Inventory
                <span class="text-stone-400 font-normal text-base">{{ Object.keys(groupedPantry).length }} Categories</span>
              </h3>
            </div>

            <div class="flex gap-6 overflow-x-auto hide-scrollbar pb-8 -mx-8 px-8 snap-x snap-mandatory">
              <div v-for="(items, category) in groupedPantry" :key="category" class="min-w-[320px] bg-surface-container-lowest rounded-[2rem] p-6 shadow-sm snap-start flex flex-col h-[500px]">
                <div class="flex items-center justify-between mb-6">
                  <div class="w-14 h-14 bg-primary-container/20 rounded-2xl flex items-center justify-center text-primary">
                    <span class="material-symbols-outlined text-3xl">{{ getCategoryIcon(category) }}</span>
                  </div>
                  <span class="bg-surface-container px-3 py-1 rounded-full text-[10px] font-black tracking-widest uppercase truncate max-w-[120px]">{{ category }}</span>
                </div>
                <h4 class="font-headline text-xl font-extrabold mb-6 truncate">{{ category }}</h4>
                
                <div class="flex-1 overflow-y-auto space-y-6 pr-2 custom-scrollbar">
                  <div v-for="item in items" :key="item.id" class="space-y-2">
                    <div class="flex justify-between items-center text-sm font-bold">
                      <span class="truncate pr-2">{{ item.name }}</span>
                      <div class="flex items-center gap-2 bg-surface-container-low rounded-full px-2 py-1">
                        <button @click="updateAmount(item, -10)" :disabled="updating === item.id" class="text-on-surface-variant hover:text-primary active:scale-90 transition-transform">-</button>
                        <span class="text-primary w-12 text-center">{{ item.amount }}<span class="text-[10px]">{{ item.unit }}</span></span>
                        <button @click="updateAmount(item, 10)" :disabled="updating === item.id" class="text-on-surface-variant hover:text-primary active:scale-90 transition-transform">+</button>
                      </div>
                    </div>
                    <div class="h-1 w-full bg-surface-container rounded-full overflow-hidden">
                      <div class="h-full rounded-full transition-all duration-500" :class="getFillColor(item.amount)" :style="`width: ${Math.min(100, (item.amount/500)*100)}%;`"></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </section>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const config = useRuntimeConfig()

const loading = ref(true)
const updating = ref(null)
const pantryItems = ref([])

onMounted(async () => {
  try {
    let userId = user.value?.id
    if (!userId) {
      const { data: { session } } = await supabase.auth.getSession()
      userId = session?.user?.id
    }
    
    if (userId) {
      const { data, error } = await supabase
        .from('user_pantry')
        .select('*, ingredients(name, category)')
        .eq('user_id', userId)
        
      if (error) throw error
      pantryItems.value = data.map(item => ({
        id: item.ingredient_id,
        name: item.ingredients.name,
        category: item.ingredients.category || 'Others',
        amount: item.amount,
        unit: item.unit
      }))
    }
  } catch (error) {
    console.error('Error fetching pantry:', error)
  } finally {
    loading.value = false
  }
})

const groupedPantry = computed(() => {
  const groups = {}
  pantryItems.value.forEach(item => {
    if (!groups[item.category]) groups[item.category] = []
    groups[item.category].push(item)
  })
  return groups
})

const lowStockItems = computed(() => {
  return pantryItems.value.filter(i => i.amount < 50).slice(0, 3)
})

const pantryFillPercentage = computed(() => {
  if (pantryItems.value.length === 0) return 0
  const avg = pantryItems.value.reduce((acc, curr) => acc + Math.min(100, (curr.amount/500)*100), 0) / pantryItems.value.length
  return Math.round(avg)
})

const getCategoryIcon = (category) => {
  const icons = {
    'Poultry & Eggs': 'egg_alt',
    'Meat': 'kebab_dining',
    'Seafood': 'set_meal',
    'Pulses & Legumes': 'grass',
    'Dairy': 'water_drop',
    'Vegetables': 'nutrition',
    'Leafy Greens': 'eco',
    'Fruits': 'laundry_fruits',
    'Grains & Cereals': 'bakery_dining',
    'Oils & Fats': 'opacity',
    'Nuts & Seeds': 'spa',
    'Whole Spices': 'local_dining',
    'Ground Spices': 'soup_kitchen',
    'Souring Agents': 'restaurant',
    'Others': 'category'
  }
  return icons[category] || 'category'
}

const getFillColor = (amount) => {
  if (amount < 50) return 'bg-tertiary'
  if (amount < 200) return 'bg-primary'
  return 'bg-secondary'
}

const updateAmount = async (item, change) => {
  if (item.amount + change < 0) return
  
  updating.value = item.id
  let userId = user.value?.id
  if (!userId) {
    const { data: { session } } = await supabase.auth.getSession()
    userId = session?.user?.id
  }

  if (userId) {
    try {
      const apiBase = config.public.apiBase || 'http://localhost:8000'
      const response = await $fetch(`${apiBase}/api/pantry/update`, {
        method: 'POST',
        body: { user_id: userId, ingredient_id: item.id, amount_change: change }
      })
      if (response.status === 'success') {
        item.amount = response.new_amount
      }
    } catch (e) {
      console.error(e)
    } finally {
      updating.value = null
    }
  }
}
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200');

.material-symbols-outlined {
  font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
}
.hide-scrollbar::-webkit-scrollbar {
  display: none;
}
.hide-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: var(--color-surface-variant);
  border-radius: 4px;
}
</style>