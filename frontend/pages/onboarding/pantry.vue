<template>
  <div class="saapion-app-container max-w-4xl mx-auto p-6 mt-10 bg-white rounded-lg shadow">
    <h1 class="text-2xl font-bold mb-2">Build Your Indian Pantry</h1>
    <p class="text-gray-600 mb-6">Select the ingredients you typically have in your kitchen.</p>
    
    <div v-if="loading" class="text-center py-10">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-accent-teal mx-auto"></div>
      <p class="mt-4 text-gray-500">Loading ingredients...</p>
    </div>

    <div v-else-if="allIngredients.length === 0" class="text-center py-10 text-gray-500">
      No ingredients found in the database. Please seed the database first!
    </div>

    <div v-else class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div v-for="(items, category) in groupedIngredients" :key="category">
        <h3 class="text-lg font-semibold capitalize mb-3 border-b pb-1">{{ category || 'Other' }}</h3>
        <div class="space-y-2">
          <label v-for="item in items" :key="item.id" class="flex items-center space-x-2 p-2 hover:bg-gray-50 rounded cursor-pointer border border-transparent hover:border-gray-200 transition-colors">
            <input type="checkbox" :value="item.id" v-model="selectedIngredients" class="rounded text-accent-teal focus:ring-accent-teal" />
            <span class="text-sm text-gray-800">{{ item.name }}</span>
          </label>
        </div>
      </div>
    </div>
    
    <div class="mt-8 flex justify-end">
      <button @click="savePantry" :disabled="saving" class="bg-accent-teal text-white py-2 px-6 rounded-xl font-bold shadow-diffuse hover:bg-teal-600 disabled:opacity-50 transition-all">
        {{ saving ? 'Saving...' : 'Finish Setup' }}
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
  'Poultry & Eggs',
  'Meat',
  'Seafood',
  'Pulses & Legumes',
  'Dairy',
  'Vegetables',
  'Leafy Greens',
  'Fruits',
  'Grains & Cereals',
  'Oils & Fats',
  'Nuts & Seeds',
  'Whole Spices',
  'Ground Spices',
  'Souring Agents',
  'Others'
]

onMounted(async () => {
  try {
    const { data, error } = await supabase.from('ingredients').select('*').order('name')
    if (error) throw error
    allIngredients.value = data || []
  } catch (error) {
    console.error("Error fetching ingredients:", error)
  } finally {
    loading.value = false
  }
})

const groupedIngredients = computed(() => {
  const groups = {}
  
  categoryOrder.forEach(cat => {
    groups[cat] = []
  })

  allIngredients.value.forEach(curr => {
    const cat = curr.category || 'Others'
    if (groups[cat]) {
      groups[cat].push(curr)
    } else {
      groups['Others'].push(curr)
    }
  })

  const activeGroups = {}
  for (const cat in groups) {
    if (groups[cat].length > 0) {
      activeGroups[cat] = groups[cat]
    }
  }
  return activeGroups
})

const savePantry = async () => {
  let userId = user.value?.id
  
  if (!userId) {
    const { data: { session } } = await supabase.auth.getSession()
    userId = session?.user?.id
  }

  if (!userId) {
    alert("User session not found. Please log in again.")
    return
  }

  saving.value = true
  const inserts = selectedIngredients.value.map(ingId => ({
    user_id: userId,
    ingredient_id: ingId
  }))

  try {
    // 1. Clear existing first
    const { error: deleteError } = await supabase.from('user_ingredients')
      .delete()
      .eq('user_id', userId)
    
    if (deleteError) throw deleteError
    
    // 2. Insert new selections
    if (inserts.length > 0) {
      const { error: insertError } = await supabase.from('user_ingredients').insert(inserts)
      if (insertError) throw insertError
    }
    
    navigateTo('/dashboard')
  } catch (error) {
    console.error("Pantry save error:", error)
    alert("Error saving pantry: " + error.message)
  } finally {
    saving.value = false
  }
}
</script>