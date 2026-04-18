<template>
  <div class="saapion-dashboard">
    <!-- Header Section -->
    <div class="flex flex-col md:flex-row justify-between items-start md:items-end gap-6 mb-10">
      <div>
        <h1 class="text-4xl md:text-5xl font-headline font-extrabold text-on-background tracking-tight mb-2">Weekly Plan</h1>
        <p class="text-on-surface-variant font-medium text-lg">Personalized meals based on your pantry</p>
      </div>
      
      <!-- Controls -->
      <div class="flex items-center gap-3">
        <button @click="generateNewPlan" :disabled="loading" class="bg-gradient-to-br from-primary to-primary-container text-on-primary font-label font-bold tracking-wide px-6 py-3 rounded-full shadow-diffuse hover:shadow-[0_12px_32px_rgba(126,87,0,0.3)] active:scale-[0.98] transition-all duration-300 flex items-center gap-2 disabled:opacity-50">
          <span class="material-symbols-outlined text-[20px]">{{ loading ? 'sync' : 'magic_button' }}</span>
          <span>{{ loading ? 'Generating...' : 'Auto-Generate' }}</span>
        </button>
        <button @click="sharePlan" class="bg-surface-container-low text-on-surface-variant hover:text-primary p-3 rounded-full transition-colors border border-outline-variant/10">
          <span class="material-symbols-outlined">share</span>
        </button>
      </div>
    </div>

    <!-- Error/Alert Banner -->
    <div v-if="errorMsg" class="bg-error-container text-on-error-container p-6 rounded-2xl mb-10 flex items-start gap-4 shadow-diffuse animate-pulse">
      <span class="material-symbols-outlined text-error">warning</span>
      <div>
        <h3 class="font-bold">Plan Generation Issue</h3>
        <p class="text-sm opacity-90">{{ errorMsg }}</p>
        <NuxtLink to="/onboarding/pantry" class="text-xs font-bold uppercase tracking-widest mt-2 inline-block underline underline-offset-4">Update Pantry &rarr;</NuxtLink>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading && !mockPlan" class="min-h-[60vh] flex flex-col items-center justify-center gap-4">
      <div class="w-12 h-12 border-4 border-primary/20 border-t-primary rounded-full animate-spin"></div>
      <p class="font-label text-sm font-bold text-on-surface-variant uppercase tracking-widest">Consulting the Stars...</p>
    </div>

    <!-- Empty State -->
    <div v-if="!mockPlan && !loading && !errorMsg" class="bg-surface-container-low rounded-3xl p-12 text-center border-2 border-dashed border-outline-variant/20 mb-10">
      <div class="w-20 h-20 bg-primary-container/20 rounded-full flex items-center justify-center mx-auto mb-6">
        <span class="material-symbols-outlined text-primary text-4xl">calendar_today</span>
      </div>
      <h3 class="text-2xl font-headline font-bold text-on-surface mb-2">No plan generated yet</h3>
      <p class="text-on-surface-variant max-w-sm mx-auto mb-8">Ready to cook? Click the auto-generate button to create a custom meal plan using ingredients you already have.</p>
    </div>

    <!-- Week Grid View -->
    <div v-if="mockPlan && Object.keys(mockPlan).length > 0" class="overflow-x-auto no-scrollbar pb-8 -mx-4 px-4 md:mx-0 md:px-0">
      <div class="min-w-[1000px] flex flex-col gap-8">
        <!-- Day Headers Row -->
        <div class="grid grid-cols-7 gap-4">
          <div v-for="day in days" :key="day" class="text-center font-headline font-bold text-on-surface-variant tracking-tight py-2 rounded-lg transition-colors"
               :class="{ 'bg-primary-container/20 text-primary': isToday(day) }">
            {{ day.slice(0, 3) }}
          </div>
        </div>

        <!-- Meal Rows -->
        <div v-for="mealType in mealTypes" :key="mealType" class="flex items-center gap-4 group">
          <div class="w-12 shrink-0 font-headline font-bold text-[10px] text-on-surface-variant/40 uppercase tracking-[0.3em] rotate-180" style="writing-mode: vertical-rl;">
            {{ mealType }}
          </div>
          
          <div class="grid grid-cols-7 gap-4 flex-1">
            <div v-for="day in days" :key="day" 
                 class="group/card bg-surface-container-lowest rounded-2xl p-4 shadow-[0_4px_12px_rgba(27,28,23,0.02)] hover:scale-[0.97] hover:bg-surface-dim transition-all cursor-pointer h-40 flex flex-col justify-between border border-transparent hover:border-primary/10 relative overflow-hidden"
                 @click="viewRecipe(mockPlan[day]?.[mealType]?.id)">
              
              <!-- Card Content -->
              <div v-if="mockPlan[day]?.[mealType]" class="space-y-2 h-full flex flex-col">
                <div class="w-full h-16 rounded-xl bg-surface-container overflow-hidden mb-1">
                  <img :src="getRecipeImage(mockPlan[day][mealType])" :alt="mockPlan[day][mealType].title" class="w-full h-full object-cover transition-transform duration-500 group-hover/card:scale-110" />
                </div>
                <h4 class="font-headline font-bold text-xs text-on-background leading-tight line-clamp-3">
                  {{ mockPlan[day][mealType].title }}
                </h4>
                <div class="mt-auto flex items-center justify-between text-[10px] font-bold text-secondary uppercase tracking-widest opacity-0 group-hover/card:opacity-100 transition-opacity">
                  <span>Cook &rarr;</span>
                </div>
              </div>

              <!-- Placeholder / Add -->
              <div v-else class="h-full flex flex-col items-center justify-center opacity-30 group-hover/card:opacity-60 transition-opacity">
                <span class="material-symbols-outlined text-xl mb-1">add_circle</span>
                <span class="text-[9px] font-bold uppercase tracking-tighter">Plan</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const config = useRuntimeConfig()
const user = useSupabaseUser()
const mockPlan = ref(null)
const loading = ref(false)
const errorMsg = ref('')

const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
const mealTypes = ['Breakfast', 'Lunch', 'Dinner']

onMounted(() => {
  fetchActivePlan()
})

const fetchActivePlan = async () => {
  const supabase = useSupabaseClient()
  let userId = user.value?.id
  
  if (!userId) {
    const { data: { session } } = await supabase.auth.getSession()
    userId = session?.user?.id
  }

  if (!userId) return

  loading.value = true
  errorMsg.value = ''
  try {
    const apiBase = config.public.apiBase || 'http://localhost:8000'
    const res = await $fetch(`${apiBase}/api/get-plan/${userId}`)
    if (res.status === 'success' && res.plan && Object.keys(res.plan).length > 0) {
      mockPlan.value = res.plan
    } else {
      mockPlan.value = null
    }
  } catch (error) {
    console.error("Error fetching active plan:", error)
    errorMsg.value = "Unable to connect to the backend server. Alchemy paused."
  } finally {
    loading.value = false
  }
}

const generateNewPlan = async () => {
  const supabase = useSupabaseClient()
  let userId = user.value?.id
  
  if (!userId) {
    const { data: { session } } = await supabase.auth.getSession()
    userId = session?.user?.id
  }

  if (!userId) {
    alert("Please log in to generate a plan.")
    return
  }

  loading.value = true
  errorMsg.value = ''
  
  try {
    const apiBase = config.public.apiBase || 'http://localhost:8000'
    const res = await $fetch(`${apiBase}/api/generate-plan/${userId}`, {
      method: 'POST'
    })
    
    if (res.status === 'error') {
      errorMsg.value = res.message
    } else if (res.plan) {
      mockPlan.value = res.plan
    }
  } catch (error) {
    console.error(error)
    errorMsg.value = `Failed to connect to the Recommendation Engine. Please try again later.`
  } finally {
    loading.value = false
  }
}

const isToday = (day) => {
  const today = new Intl.DateTimeFormat('en-US', { weekday: 'long' }).format(new Date())
  return day === today
}

const getRecipeImage = (recipe) => {
  if (!recipe) return ''
  if (recipe.image_url) return recipe.image_url
  
  // High-quality static fallback for Indian food
  return `https://images.unsplash.com/photo-1585937421612-70a008356fbe?q=80&w=400&h=300&auto=format&fit=crop`
}

const viewRecipe = (id) => {
  if (!id) return
  navigateTo(`/recipe/${id}`)
}

const sharePlan = () => {
  if (!mockPlan.value) return
  
  let text = "My Saapion Weekly Plan:\n"
  days.forEach(day => {
    if (mockPlan.value[day]) {
      text += `\n*${day}*\n`
      mealTypes.forEach(m => {
        if (mockPlan.value[day][m]) {
          text += `- ${m}: ${mockPlan.value[day][m].title}\n`
        }
      })
    }
  })
  
  navigator.clipboard.writeText(text)
  alert("Plan copied to clipboard for sharing!")
}
</script>

<style scoped>
.no-scrollbar::-webkit-scrollbar {
    display: none;
}
.no-scrollbar {
    -ms-overflow-style: none;
    scrollbar-width: none;
}
</style>