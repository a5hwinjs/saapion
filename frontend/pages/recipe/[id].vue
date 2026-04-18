<template>
  <div class="saapion-recipe-detail min-h-screen bg-background text-on-background font-body antialiased">
    <!-- Top Hero Area: The Culinary Alchemy -->
    <div class="relative h-[45vh] md:h-[55vh] w-full overflow-hidden bg-surface-container-low">
      <!-- Back Button -->
      <button @click="$router.back()" class="absolute top-6 left-6 w-12 h-12 bg-background/80 backdrop-blur-md rounded-full flex items-center justify-center shadow-diffuse z-20 text-primary hover:bg-primary hover:text-on-primary transition-all duration-300">
        <span class="material-symbols-outlined">arrow_back</span>
      </button>

      <!-- Main Image with editorial overlay -->
      <img :src="recipeImage" :alt="formattedId" class="w-full h-full object-cover transition-transform duration-[2s] hover:scale-105" />
      <div class="absolute inset-0 bg-gradient-to-t from-background via-transparent to-transparent"></div>
      
      <!-- Floating Tag -->
      <div class="absolute bottom-10 left-6 md:left-12 z-10 flex gap-2">
        <span class="px-4 py-1.5 bg-primary-container/90 backdrop-blur-sm text-on-primary-container text-[10px] font-bold rounded-full uppercase tracking-widest shadow-sm">
          Plan Selection
        </span>
        <span class="px-4 py-1.5 bg-secondary-container/90 backdrop-blur-sm text-on-secondary-container text-[10px] font-bold rounded-full uppercase tracking-widest shadow-sm">
          100% Pantry Match
        </span>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="min-h-screen flex flex-col items-center justify-center gap-4 bg-background">
      <div class="w-12 h-12 border-4 border-primary/20 border-t-primary rounded-full animate-spin"></div>
      <p class="font-label text-sm font-bold text-on-surface-variant uppercase tracking-widest">Alchemy in progress...</p>
    </div>

    <!-- Content Area: The Blueprint -->
    <main v-else-if="recipe" class="max-w-4xl mx-auto px-6 md:px-12 -mt-16 relative z-10 pb-32">
      <div class="bg-surface-container-lowest rounded-[2.5rem] p-8 md:p-12 shadow-diffuse border border-outline-variant/10">
        <!-- Title & Meta -->
        <div class="mb-10">
          <h1 class="text-4xl md:text-6xl font-headline font-extrabold text-on-surface leading-tight tracking-tighter capitalize mb-4">
            {{ formattedId }}
          </h1>
          <div class="flex items-center gap-3">
            <div class="w-8 h-8 rounded-full bg-primary-container flex items-center justify-center text-xs font-bold text-on-primary-container">
              S
            </div>
            <span class="text-sm font-medium text-on-surface-variant">{{ recipe.category || 'Main Course' }} • Curated for your vital goals</span>
          </div>
        </div>

        <!-- Metric Pills -->
        <div class="flex flex-wrap gap-3 mb-12">
          <div class="bg-surface-container-low px-6 py-3 rounded-full flex items-center gap-2 border border-outline-variant/5">
            <span class="material-symbols-outlined text-secondary text-lg">timer</span>
            <span class="text-xs font-bold uppercase tracking-widest text-on-surface-variant">{{ recipe.prep_time_mins + recipe.cook_time_mins }} Min</span>
          </div>
          <div v-if="recipe.macros_json" class="bg-surface-container-low px-6 py-3 rounded-full flex items-center gap-2 border border-outline-variant/5">
            <span class="material-symbols-outlined text-tertiary text-lg">local_fire_department</span>
            <span class="text-xs font-bold uppercase tracking-widest text-on-surface-variant">{{ Math.round((recipe.macros_json.protein * 4) + (recipe.macros_json.carbs * 4) + (recipe.macros_json.fat * 9)) }} Kcal</span>
          </div>
          <div class="bg-surface-container-low px-6 py-3 rounded-full flex items-center gap-2 border border-outline-variant/5">
            <span class="material-symbols-outlined text-primary text-lg">restaurant</span>
            <span class="text-xs font-bold uppercase tracking-widest text-on-surface-variant">{{ recipe.is_quickie ? 'Easy' : 'Moderate' }}</span>
          </div>
        </div>

        <!-- Ingredient Pool -->
        <div class="mb-12">
          <div class="flex items-center gap-3 mb-8">
            <span class="material-symbols-outlined text-primary text-2xl" style="font-variation-settings: 'FILL' 1;">inventory_2</span>
            <h2 class="font-headline text-2xl font-bold text-on-surface tracking-tight">Ingredient Pool</h2>
          </div>
          
          <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
            <div v-for="ing in requiredIngredients" :key="ing.name" 
                 class="group bg-surface-container-low p-4 rounded-3xl border transition-all duration-300 relative overflow-hidden"
                 :class="ing.inPantry ? 'border-transparent hover:bg-surface-container' : 'border-error/20 bg-error-container/5'">
              
              <div v-if="!ing.inPantry" class="absolute top-2 right-2 w-5 h-5 bg-error text-on-error rounded-full flex items-center justify-center text-[10px] font-bold shadow-sm">!</div>
              
              <div class="w-12 h-12 bg-background rounded-2xl mb-4 flex items-center justify-center shadow-inner group-hover:scale-110 transition-transform">
                <span class="text-2xl">{{ ing.emoji || '🌿' }}</span>
              </div>
              
              <div class="space-y-1">
                <p class="text-[10px] font-bold uppercase tracking-widest text-primary">{{ ing.quantity }}</p>
                <p class="text-xs font-bold text-on-surface truncate">{{ ing.name }}</p>
                <p v-if="!ing.inPantry" class="text-[9px] font-extrabold text-error uppercase tracking-tighter">Missing</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Preparation Steps -->
        <div v-if="preparationSteps.length">
          <div class="flex items-center gap-3 mb-8">
            <span class="material-symbols-outlined text-primary text-2xl" style="font-variation-settings: 'FILL' 1;">cooking</span>
            <h2 class="font-headline text-2xl font-bold text-on-surface tracking-tight">The Process</h2>
          </div>
          <div class="space-y-6">
            <div v-for="(step, index) in preparationSteps" :key="index" class="flex gap-6 group">
              <div class="shrink-0 w-10 h-10 rounded-full bg-surface-container-low flex items-center justify-center font-headline font-extrabold text-primary border border-outline-variant/10 group-hover:bg-primary group-hover:text-on-primary transition-colors">
                {{ index + 1 }}
              </div>
              <p class="text-on-surface-variant leading-relaxed pt-2">
                {{ step }}
              </p>
            </div>
          </div>
        </div>
      </div>

      <!-- Action Footer -->
      <div class="mt-12 flex flex-col items-center gap-4">
        <button v-if="!isLogged" @click="logMeal" :disabled="logging" 
                class="bg-gradient-to-br from-primary to-primary-container text-on-primary font-headline text-xl font-bold px-12 py-5 rounded-full shadow-diffuse hover:shadow-[0_12px_32px_rgba(126,87,0,0.3)] hover:scale-105 active:scale-95 transition-all duration-300 flex items-center gap-3 group disabled:opacity-50">
          <span>{{ logging ? 'Logging Alchemy...' : 'Confirm Cooking' }}</span>
          <span class="material-symbols-outlined transition-transform group-hover:translate-x-1" :class="{'animate-spin': logging}">
            {{ logging ? 'sync' : 'bolt' }}
          </span>
        </button>
        <div v-else class="bg-secondary-container text-on-secondary-container px-8 py-4 rounded-full font-bold flex items-center gap-3 animate-in fade-in zoom-in duration-500">
          <span class="material-symbols-outlined">check_circle</span>
          Meal Logged Successfully
        </div>
        <p v-if="!isLogged" class="text-on-surface-variant text-xs font-bold uppercase tracking-widest opacity-60">Confirm to update your daily macros</p>
      </div>
    </main>
  </div>
</template>

<script setup>
import { computed, ref, onMounted } from 'vue'

const route = useRoute()
const supabase = useSupabaseClient()
const config = useRuntimeConfig()
const id = route.params.id

const recipe = ref(null)
const requiredIngredients = ref([])
const loading = ref(true)
const logging = ref(false)
const isLogged = ref(false)

onMounted(async () => {
  try {
    // 1. Fetch recipe details
    const { data: recipeData, error: recipeError } = await supabase
      .from('recipes')
      .select('*')
      .eq('id', id)
      .single()
    
    if (recipeError) throw recipeError
    recipe.value = recipeData

    // 2. Fetch recipe ingredients
    const { data: ingData, error: ingError } = await supabase
      .from('recipe_ingredients')
      .select('*, ingredients(name, category)')
      .eq('recipe_id', id)
    
    if (ingError) throw ingError
    
    // 3. Check user pantry for match
    const { data: { session } } = await supabase.auth.getSession()
    const userId = session?.user?.id
    
    let userIngIds = []
    if (userId) {
      const { data: userIngs } = await supabase
        .from('user_ingredients')
        .select('ingredient_id')
        .eq('user_id', userId)
      userIngIds = userIngs?.map(i => i.ingredient_id) || []

      // Check if already logged today
      const today = new Date().toISOString().split('T')[0]
      const { data: rating } = await supabase
        .from('ratings')
        .select('id')
        .eq('user_id', userId)
        .eq('recipe_id', id)
        .gte('created_at', today)
        .limit(1)
      
      if (rating?.length) isLogged.value = true
    }

    requiredIngredients.value = ingData.map(ri => ({
      name: ri.ingredients.name,
      quantity: ri.quantity + ' ' + (ri.unit || ''),
      inPantry: userIngIds.includes(ri.ingredient_id),
      emoji: getCategoryEmoji(ri.ingredients.category)
    }))

  } catch (error) {
    console.error("Error fetching recipe:", error)
  } finally {
    loading.value = false
  }
})

const logMeal = async () => {
  logging.value = true
  try {
    const { data: { session } } = await supabase.auth.getSession()
    if (!session?.user?.id) throw new Error("Please log in to log meals.")

    const payload = {
      user_id: session.user.id,
      recipe_id: id,
      action_check: true,
      macros_consumed_json: recipe.value.macros_json,
      taste: 5,
      difficulty: recipe.value.is_quickie ? 1 : 3
    }

    await $fetch(`${config.public.apiBase}/api/log-rating`, {
      method: 'POST',
      body: payload
    })

    isLogged.value = true
  } catch (error) {
    alert(error.message)
  } finally {
    logging.value = false
  }
}

const formattedId = computed(() => recipe.value?.title || 'Loading...')

const recipeImage = computed(() => {
  return recipe.value?.image_url || `https://images.unsplash.com/photo-1585937421612-70a008356fbe?q=80&w=1200&h=800&auto=format&fit=crop`
})

const preparationSteps = computed(() => {
  if (!recipe.value?.instructions) return []
  return recipe.value.instructions.split('\n').filter(s => s.trim())
})

const getCategoryEmoji = (category) => {
  const emojis = {
    'Poultry & Eggs': '🥚',
    'Meat': '🍗',
    'Seafood': '🐟',
    'Pulses & Legumes': '🫘',
    'Dairy': '🧀',
    'Vegetables': '🥦',
    'Leafy Greens': '🥬',
    'Fruits': '🍎',
    'Grains & Cereals': '🌾',
    'Oils & Fats': '🫗',
    'Nuts & Seeds': '🥜',
    'Whole Spices': '🌶',
    'Ground Spices': '🥣',
    'Souring Agents': '🍋',
    'Others': '📦'
  }
  return emojis[category] || '🌿'
}
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200');

.material-symbols-outlined {
  font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
}
</style>