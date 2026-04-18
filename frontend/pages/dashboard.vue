<template>
  <div class="saapion-app-container p-4">
    <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6">
      <h1 class="text-3xl font-bold text-gray-900 mb-4 md:mb-0">Your Weekly Plan</h1>
      <div class="space-x-3 flex">
        <button @click="generateNewPlan" :disabled="loading" class="bg-accent-teal text-white px-4 py-2 rounded-xl shadow-diffuse hover:bg-teal-600 transition disabled:opacity-50 font-bold">
          {{ loading ? 'Generating...' : 'Auto-Generate Plan' }}
        </button>
        <button @click="sharePlan" class="bg-white border border-gray-200 text-gray-700 px-4 py-2 rounded-xl shadow-sm hover:bg-gray-50 transition font-bold">Share</button>
      </div>
    </div>
    
    <div v-if="errorMsg" class="bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded shadow-sm">
      <p class="text-red-700 font-medium">{{ errorMsg }}</p>
      <NuxtLink to="/onboarding/pantry" class="mt-2 inline-block text-red-600 underline text-sm">Update Pantry</NuxtLink>
    </div>

    <div v-if="!mockPlan || Object.keys(mockPlan).length === 0 && !loading && !errorMsg" class="text-center py-10">
      <p class="text-gray-500">No plan generated yet. Click the button above to create one based on your pantry!</p>
    </div>
    
    <div v-if="mockPlan && Object.keys(mockPlan).length > 0" class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
      <div v-for="(meals, day) in mockPlan" :key="day" class="bg-white rounded-2xl shadow-diffuse p-5 border border-white">
        <h2 class="text-xl font-extrabold mb-4 border-b pb-2 text-accent-teal">{{ day }}</h2>
        <div class="space-y-4">
          <div v-for="(recipe, mealType) in meals" :key="mealType" class="bg-[var(--color-bg-light)] p-3 rounded-xl group hover:bg-pastel-mint/30 transition relative border border-transparent hover:border-pastel-mint">
            <h3 class="text-xs uppercase tracking-wider text-gray-500 mb-1 font-bold">{{ mealType }}</h3>
            <div class="flex justify-between items-start">
              <span class="font-medium text-gray-900 pr-2">{{ recipe || 'Not Planned' }}</span>
              <NuxtLink v-if="recipe" :to="`/recipe/${mockRecipeId(recipe)}`" class="text-sm text-accent-teal hover:text-teal-800 whitespace-nowrap font-semibold">View &rarr;</NuxtLink>
            </div>
            
            <!-- Post-Recipe Feedback UI (Mocked trigger) -->
            <button v-if="recipe" @click="openFeedbackModal(recipe, day)" class="absolute top-3 right-16 text-xs text-blue-500 underline opacity-0 group-hover:opacity-100 transition">Log Metrics</button>
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

onMounted(() => {
  // Fetch existing plan on load
  setTimeout(() => {
    fetchActivePlan()
  }, 500)
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
  try {
    const res = await $fetch(`${config.public.apiBase}/api/get-plan/${userId}`)
    if (res.status === 'success') {
      mockPlan.value = res.plan
    } else {
      // If no plan exists, generate one automatically
      generateNewPlan()
    }
  } catch (error) {
    console.error("Error fetching active plan:", error)
  } finally {
    loading.value = false
  }
}

const mockRecipeId = (title) => {
  return title.toLowerCase().replace(/ /g, '-')
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
  mockPlan.value = null

  try {
    const res = await $fetch(`${config.public.apiBase}/api/generate-plan/${userId}`, {
      method: 'POST'
    })
    
    if (res.status === 'error') {
      errorMsg.value = res.message
    } else if (res.plan) {
      mockPlan.value = res.plan
    }
  } catch (error) {
    console.error(error)
    errorMsg.value = `Failed to connect to the Recommendation Engine at ${config.public.apiBase}. Is the FastAPI backend running?`
  } finally {
    loading.value = false
  }
}

const sharePlan = () => {
  if (!mockPlan.value) return alert("No plan to share!")
  
  let planText = "*Saapion Weekly Meal Plan* 🍛\n\n"
  for (const [day, meals] of Object.entries(mockPlan.value)) {
    planText += `*${day}*\n`
    for (const [meal, recipe] of Object.entries(meals)) {
      planText += `  • ${meal}: ${recipe}\n`
    }
    planText += "\n"
  }
  
  if (navigator.share) {
    navigator.share({
      title: 'My Saapion Weekly Meal Plan',
      text: planText
    }).catch(console.error)
  } else {
    navigator.clipboard.writeText(planText)
    alert("Plan copied to clipboard for easy sharing!")
  }
}

const openFeedbackModal = (recipe, day) => {
  alert(`Opening Post-Recipe Metrics modal for ${recipe} (${day}). Did you cook it? Rate the taste and difficulty.`)
}
</script>