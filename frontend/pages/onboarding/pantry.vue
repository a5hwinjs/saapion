<template>
  <div class="max-w-4xl mx-auto p-6 mt-10 bg-white rounded-lg shadow">
    <h1 class="text-2xl font-bold mb-2">Build Your Indian Pantry</h1>
    <p class="text-gray-600 mb-6">Select the ingredients you typically have in your kitchen.</p>
    
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div v-for="(items, category) in groupedIngredients" :key="category">
        <h3 class="text-lg font-semibold capitalize mb-3 border-b pb-1">{{ category }}</h3>
        <div class="space-y-2">
          <label v-for="item in items" :key="item.id" class="flex items-center space-x-2 p-2 hover:bg-gray-50 rounded cursor-pointer border border-transparent hover:border-gray-200 transition-colors">
            <input type="checkbox" :value="item.id" v-model="selectedIngredients" class="rounded text-green-600 focus:ring-green-500" />
            <span class="text-sm text-gray-800">{{ item.name }}</span>
          </label>
        </div>
      </div>
    </div>
    
    <div class="mt-8 flex justify-end">
      <button @click="savePantry" class="bg-green-600 text-white py-2 px-6 rounded-md hover:bg-green-700">Finish Setup</button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const supabase = useSupabaseClient()
const user = useSupabaseUser()

// Hardcoded initial list of common Indian ingredients for the prototype
const allIngredients = ref([
  { id: '1', name: 'Toor Dal', category: 'lentils' },
  { id: '2', name: 'Urad Dal', category: 'lentils' },
  { id: '3', name: 'Chana Dal', category: 'lentils' },
  { id: '4', name: 'Mustard Seeds', category: 'spices' },
  { id: '5', name: 'Cumin Seeds', category: 'spices' },
  { id: '6', name: 'Turmeric Powder', category: 'spices' },
  { id: '7', name: 'Red Chilli Powder', category: 'spices' },
  { id: '8', name: 'Curry Leaves', category: 'fresh' },
  { id: '9', name: 'Coriander Leaves', category: 'fresh' },
  { id: '10', name: 'Green Chillies', category: 'fresh' },
  { id: '11', name: 'Ginger', category: 'fresh' },
  { id: '12', name: 'Garlic', category: 'fresh' },
  { id: '13', name: 'Onions', category: 'vegetables' },
  { id: '14', name: 'Tomatoes', category: 'vegetables' },
  { id: '15', name: 'Paneer', category: 'dairy' },
  { id: '16', name: 'Tamarind', category: 'pantry' },
  { id: '17', name: 'Rice (Sona Masoori)', category: 'grains' },
  { id: '18', name: 'Basmati Rice', category: 'grains' },
  { id: '19', name: 'Atta (Wheat Flour)', category: 'grains' },
])

const selectedIngredients = ref([])

const groupedIngredients = computed(() => {
  return allIngredients.value.reduce((acc, curr) => {
    if (!acc[curr.category]) acc[curr.category] = []
    acc[curr.category].push(curr)
    return acc
  }, {})
})

const savePantry = async () => {
  if (!user.value) {
    console.warn("No authenticated user. Mocking success.")
    navigateTo('/dashboard')
    return
  }

  const inserts = selectedIngredients.value.map(ingId => ({
    user_id: user.value.id,
    ingredient_id: ingId
  }))

  // Clear existing first
  await supabase.from('user_ingredients').delete().eq('user_id', user.value.id)
  
  if (inserts.length > 0) {
    const { error } = await supabase.from('user_ingredients').insert(inserts)
    if (error) {
      alert("Error saving pantry: " + error.message)
      return
    }
  }
  
  navigateTo('/dashboard')
}
</script>