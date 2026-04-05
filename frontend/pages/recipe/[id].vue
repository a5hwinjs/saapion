<template>
  <div class="max-w-4xl mx-auto p-6 mt-6 bg-white rounded-lg shadow">
    <button @click="$router.back()" class="text-green-600 mb-4 hover:underline">&larr; Back</button>
    
    <div class="flex flex-col md:flex-row justify-between items-start md:items-center border-b pb-4 mb-6">
      <div>
        <h1 class="text-3xl font-bold text-gray-900 capitalize">{{ formattedId }}</h1>
        <p class="text-gray-500 mt-2">⏱ Prep: 15m | 🔥 Cook: 20m | 🌿 Pure Veg</p>
      </div>
      <div class="mt-4 md:mt-0 flex space-x-2">
        <button class="px-4 py-2 border border-gray-300 rounded hover:bg-gray-50">Save</button>
        <button @click="cookNow" class="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700">Cook Now</button>
      </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
      <!-- Ingredients Sidebar -->
      <div class="md:col-span-1 bg-gray-50 p-4 rounded-lg self-start">
        <h3 class="text-lg font-semibold mb-4 text-gray-800">Ingredients</h3>
        <ul class="space-y-3">
          <li v-for="ing in requiredIngredients" :key="ing.name" class="flex items-start">
            <span v-if="ing.inPantry" class="text-green-500 mr-2 font-bold">✓</span>
            <span v-else class="text-red-500 mr-2 font-bold">✗</span>
            <div>
              <span class="text-gray-800 font-medium">{{ ing.quantity }}</span>
              <span class="text-gray-700 ml-1">{{ ing.name }}</span>
              <p v-if="!ing.inPantry" class="text-xs text-red-600 mt-0.5 font-semibold">Missing: Add to grocery list</p>
            </div>
          </li>
        </ul>
      </div>

      <!-- Instructions & Macros -->
      <div class="md:col-span-2">
        <h3 class="text-lg font-semibold mb-4 text-gray-800">Instructions</h3>
        <ol class="list-decimal list-inside space-y-4 text-gray-700 mb-8">
          <li>Heat oil in a pan, add mustard seeds and let them splutter.</li>
          <li>Add chopped onions, green chilies, and curry leaves. Sauté until onions are translucent.</li>
          <li>Add turmeric powder, salt, and the main ingredient. Mix well.</li>
          <li>Cook for 10-15 minutes on medium heat, stirring occasionally.</li>
          <li>Garnish with fresh coriander leaves and serve hot.</li>
        </ol>
        
        <div class="bg-blue-50 border border-blue-100 p-4 rounded-lg">
          <h4 class="font-semibold text-blue-900 mb-2">Estimated Macros (Per Serving)</h4>
          <div class="flex flex-wrap gap-4 text-sm">
            <div class="bg-white px-3 py-1 rounded shadow-sm"><span class="font-bold text-blue-800">Calories:</span> 320</div>
            <div class="bg-white px-3 py-1 rounded shadow-sm"><span class="font-bold text-blue-800">Protein:</span> 12g</div>
            <div class="bg-white px-3 py-1 rounded shadow-sm"><span class="font-bold text-blue-800">Carbs:</span> 45g</div>
            <div class="bg-white px-3 py-1 rounded shadow-sm"><span class="font-bold text-blue-800">Fats:</span> 10g</div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Post-Recipe Feedback Modal (Simplified) -->
    <div v-if="showFeedback" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div class="bg-white rounded-lg shadow-xl p-6 max-w-md w-full">
        <h2 class="text-xl font-bold mb-4">How did it go?</h2>
        <div class="space-y-6 mb-6">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Did you cook this today?</label>
            <div class="flex space-x-4">
              <label class="flex items-center cursor-pointer"><input type="radio" v-model="feedback.cooked" :value="true" class="mr-2 text-green-600 focus:ring-green-500 h-4 w-4" /> Yes</label>
              <label class="flex items-center cursor-pointer"><input type="radio" v-model="feedback.cooked" :value="false" class="mr-2 text-green-600 focus:ring-green-500 h-4 w-4" /> No</label>
            </div>
          </div>
          <div v-if="feedback.cooked" class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Difficulty: {{ feedback.difficulty }}/5</label>
              <input type="range" min="1" max="5" v-model="feedback.difficulty" class="w-full accent-green-600" />
              <div class="flex justify-between text-xs text-gray-500 mt-1"><span>Easy</span><span>Hard</span></div>
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Taste: {{ feedback.taste }}/5</label>
              <input type="range" min="1" max="5" v-model="feedback.taste" class="w-full accent-green-600" />
              <div class="flex justify-between text-xs text-gray-500 mt-1"><span>Needs Improvement</span><span>Delicious</span></div>
            </div>
          </div>
        </div>
        <div class="flex justify-end space-x-3">
          <button @click="showFeedback = false" class="px-4 py-2 border border-gray-300 rounded hover:bg-gray-50 font-medium">Cancel</button>
          <button @click="submitFeedback" class="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700 font-medium">Log Metrics</button>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup>
import { computed, ref } from 'vue'

const route = useRoute()
const id = route.params.id || ''
const formattedId = computed(() => id.toString().replace(/-/g, ' '))

// Mock logic comparing against user pantry
const requiredIngredients = ref([
  { name: 'Toor Dal', quantity: '1 cup', inPantry: true },
  { name: 'Mustard Seeds', quantity: '1 tsp', inPantry: true },
  { name: 'Curry Leaves', quantity: '1 sprig', inPantry: true },
  { name: 'Fresh Coconut', quantity: '1/2 cup', inPantry: false },
  { name: 'Tamarind', quantity: 'lemon sized', inPantry: true },
])

const showFeedback = ref(false)
const feedback = ref({
  cooked: true,
  difficulty: 3,
  taste: 4
})

const cookNow = () => {
  showFeedback.value = true
}

const submitFeedback = () => {
  alert("Metrics saved to database! The Recommendation Engine will learn from this to refine your future meal plans.")
  showFeedback.value = false
}
</script>