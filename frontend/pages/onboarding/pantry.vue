<template>
  <div class="bg-background text-on-background min-h-screen pb-32">
    <!-- Main Content Canvas -->
    <main class="pt-12 px-6 md:px-12 max-w-7xl mx-auto flex flex-col gap-12">
      <!-- Hero / Context Area -->
      <section class="flex flex-col gap-4 max-w-2xl">
        <span class="font-label text-sm uppercase tracking-widest text-secondary font-bold">Step 1 of 2 • Pantry Setup</span>
        <h2 class="font-headline text-4xl md:text-5xl font-extrabold tracking-tight text-primary leading-tight">
          Stock Your Canvas
        </h2>
        <p class="font-body text-lg text-on-surface-variant leading-relaxed">
          A great South Indian kitchen starts with the essentials. Select the ingredients currently resting in your pantry. We'll use this pool to craft your personalized recipes.
        </p>
      </section>

      <!-- Loading State -->
      <div v-if="loading" class="flex flex-col items-center justify-center py-20 gap-4">
        <div class="w-12 h-12 border-4 border-primary/20 border-t-primary rounded-full animate-spin"></div>
        <p class="font-label text-sm font-bold text-on-surface-variant uppercase tracking-widest">Gathering Ingredients...</p>
      </div>

      <!-- Bento Grid Categories -->
      <div v-else class="flex flex-col gap-16">
        <section v-for="(items, category) in groupedIngredients" :key="category" class="flex flex-col gap-6">
          <div class="flex items-center gap-3">
            <span class="material-symbols-outlined text-primary text-3xl">{{ getCategoryIcon(category) }}</span>
            <h3 class="font-headline text-2xl font-bold tracking-tight text-on-surface capitalize">{{ category }}</h3>
          </div>
          
          <div class="flex flex-wrap gap-3 md:gap-4">
            <button v-for="item in items" :key="item.id" 
                    @click="toggleItem(item.id)"
                    class="flex items-center gap-2 px-5 py-2.5 rounded-full transition-all active:scale-95 shadow-sm border"
                    :class="[isSelected(item.id) 
                      ? 'bg-secondary-container text-on-secondary-container border-secondary/20 font-bold' 
                      : 'bg-surface-container hover:bg-surface-container-high text-on-surface-variant border-transparent font-semibold']">
              <span class="material-symbols-outlined text-[20px]" :data-weight="isSelected(item.id) ? 'fill' : ''">
                {{ isSelected(item.id) ? 'check_circle' : 'add_circle' }}
              </span>
              <span class="font-label text-sm md:text-base uppercase tracking-wider">{{ item.name }}</span>
            </button>
          </div>
        </section>

        <!-- Empty State -->
        <div v-if="Object.keys(groupedIngredients).length === 0" class="text-center py-10 text-on-surface-variant italic">
          No ingredients found. Please try again later.
        </div>
      </div>
    </main>

    <!-- Floating Action Button / Bottom Continue Bar -->
    <div class="fixed bottom-0 left-0 w-full p-6 pt-12 bg-gradient-to-t from-background via-background/90 to-transparent z-40 flex justify-center">
      <button @click="savePantry" :disabled="saving || selectedIngredients.length === 0" 
              class="bg-gradient-to-br from-primary to-primary-container text-on-primary font-headline text-lg font-bold px-10 py-4 rounded-full shadow-diffuse hover:shadow-[0_12px_32px_rgba(126,87,0,0.3)] hover:scale-105 active:scale-95 transition-all duration-300 flex items-center gap-3 group disabled:opacity-50 disabled:grayscale">
        <span>{{ saving ? 'Saving Pantry...' : 'Finish Setup' }}</span>
        <span v-if="!saving" class="material-symbols-outlined transition-transform group-hover:translate-x-1">arrow_forward</span>
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

const supabase = useSupabaseClient()
const user = useSupabaseUser()

const loading = ref(true)
const saving = ref(false)
const allIngredients = ref([])
const selectedIngredients = ref([])

const categoryOrder = [
  'Poultry & Eggs', 'Meat', 'Seafood', 'Pulses & Legumes', 'Dairy', 'Vegetables', 
  'Leafy Greens', 'Fruits', 'Grains & Cereals', 'Oils & Fats', 'Nuts & Seeds', 
  'Whole Spices', 'Ground Spices', 'Souring Agents', 'Others'
]

onMounted(async () => {
  try {
    const { data, error } = await supabase.from('ingredients').select('*').order('name')
    if (error) throw error
    allIngredients.value = data || []
    
    // Fetch user's current pantry
    let userId = user.value?.id
    if (!userId) {
      const { data: { session } } = await supabase.auth.getSession()
      userId = session?.user?.id
    }
    
    if (userId) {
      const { data: userIngs, error: userError } = await supabase
        .from('user_pantry')
        .select('ingredient_id')
        .eq('user_id', userId)
      
      if (!userError && userIngs) {
        selectedIngredients.value = userIngs.map(i => i.ingredient_id)
      }
    }
  } catch (error) {
    console.error("Error fetching data:", error)
  } finally {
    loading.value = false
  }
})

const groupedIngredients = computed(() => {
  const groups = {}
  categoryOrder.forEach(cat => groups[cat] = [])
  
  allIngredients.value.forEach(curr => {
    const cat = curr.category || 'Others'
    if (groups[cat]) {
      groups[cat].push(curr)
    } else {
      if (!groups['Others']) groups['Others'] = []
      groups['Others'].push(curr)
    }
  })

  const activeGroups = {}
  categoryOrder.forEach(cat => {
    if (groups[cat] && groups[cat].length > 0) {
      activeGroups[cat] = groups[cat]
    }
  })
  return activeGroups
})

const isSelected = (id) => selectedIngredients.value.includes(id)

const toggleItem = (id) => {
  const index = selectedIngredients.value.indexOf(id)
  if (index === -1) {
    selectedIngredients.value.push(id)
  } else {
    selectedIngredients.value.splice(index, 1)
  }
}

const getCategoryIcon = (category) => {
  const icons = {
    'Poultry & Eggs': 'egg',
    'Meat': 'kebab_dining',
    'Seafood': 'set_meal',
    'Pulses & Legumes': 'potted_plant',
    'Dairy': 'bakery_dining',
    'Vegetables': 'nutrition',
    'Leafy Greens': 'eco',
    'Fruits': 'laundry_fruits',
    'Grains & Cereals': 'grain',
    'Oils & Fats': 'oil_barrel',
    'Nuts & Seeds': 'psychiatry',
    'Whole Spices': 'local_dining',
    'Ground Spices': 'soup_kitchen',
    'Souring Agents': 'restaurant',
    'Others': 'category'
  }
  return icons[category] || 'category'
}

const savePantry = async () => {
  let userId = user.value?.id
  if (!userId) {
    const { data: { session } } = await supabase.auth.getSession()
    userId = session?.user?.id
  }

  if (!userId) return

  saving.value = true
  try {
    await supabase.from('user_pantry').delete().eq('user_id', userId)
    
    const inserts = selectedIngredients.value.map(ingId => ({
      user_id: userId,
      ingredient_id: ingId
    }))

    if (inserts.length > 0) {
      const { error } = await supabase.from('user_pantry').insert(inserts)
      if (error) throw error
      
      const config = useRuntimeConfig()
      const apiBase = config.public.apiBase || 'http://localhost:8000'
      await $fetch(`${apiBase}/api/pantry/init`, {
        method: 'POST',
        body: { user_id: userId, ingredients: selectedIngredients.value }
      })
    }
    
    navigateTo('/dashboard')
  } catch (error) {
    alert("Error saving pantry: " + error.message)
  } finally {
    saving.value = false
  }
}
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200');

.material-symbols-outlined {
  font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
}
.material-symbols-outlined[data-weight="fill"] {
  font-variation-settings: 'FILL' 1;
}
</style>