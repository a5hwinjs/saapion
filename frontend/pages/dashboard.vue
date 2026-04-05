<template>
  <div>
    <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6">
      <h1 class="text-3xl font-bold text-gray-900 mb-4 md:mb-0">Your Weekly Plan</h1>
      <div class="space-x-3">
        <button @click="generateNewPlan" class="bg-green-600 text-white px-4 py-2 rounded shadow hover:bg-green-700 transition">Auto-Generate Plan</button>
        <button @click="sharePlan" class="bg-white border border-gray-300 text-gray-700 px-4 py-2 rounded shadow hover:bg-gray-50 transition">Share to WhatsApp</button>
      </div>
    </div>
    
    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
      <div v-for="(meals, day) in mockPlan" :key="day" class="bg-white rounded-lg shadow p-4 border border-gray-200">
        <h2 class="text-xl font-semibold mb-4 border-b pb-2 text-green-700">{{ day }}</h2>
        <div class="space-y-4">
          <div v-for="(recipe, mealType) in meals" :key="mealType" class="bg-gray-50 p-3 rounded group hover:bg-gray-100 transition relative">
            <h3 class="text-xs uppercase tracking-wider text-gray-500 mb-1">{{ mealType }}</h3>
            <div class="flex justify-between items-start">
              <span class="font-medium text-gray-900 pr-2">{{ recipe || 'Not Planned' }}</span>
              <NuxtLink v-if="recipe" :to="`/recipe/${mockRecipeId(recipe)}`" class="text-sm text-green-600 hover:text-green-800 whitespace-nowrap">View &rarr;</NuxtLink>
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
import { ref } from 'vue'

const mockPlan = ref({
  Monday: { Breakfast: 'Idli with Sambar', Lunch: 'Lemon Rice', Dinner: 'Roti with Paneer Butter Masala', Snacks: 'Roasted Makhana' },
  Tuesday: { Breakfast: 'Poha', Lunch: 'Curd Rice', Dinner: 'Dosa with Coconut Chutney', Snacks: 'Masala Chai & Rusk' },
  Wednesday: { Breakfast: 'Upma', Lunch: 'Bisi Bele Bath', Dinner: 'Chapati with Dal Makhani', Snacks: 'Murukku' },
  Thursday: { Breakfast: 'Medu Vada', Lunch: 'Sambar Rice', Dinner: 'Aloo Gobi with Naan', Snacks: 'Pakora' },
  Friday: { Breakfast: 'Appam', Lunch: 'Tamarind Rice', Dinner: 'Palak Paneer with Roti', Snacks: 'Banana Chips' },
  Saturday: { Breakfast: 'Masala Dosa', Lunch: 'Veg Biryani', Dinner: 'Chana Masala with Puri', Snacks: 'Samosa' },
  Sunday: { Breakfast: 'Pongal', Lunch: 'Tomato Rice', Dinner: 'Malai Kofta with Paratha', Snacks: 'Bhel Puri' }
})

const mockRecipeId = (title) => {
  return title.toLowerCase().replace(/ /g, '-')
}

const generateNewPlan = async () => {
  alert("In production, the FastAPI Recommendation Engine will analyze your pantry and past ratings to generate this schedule.")
}

const sharePlan = () => {
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