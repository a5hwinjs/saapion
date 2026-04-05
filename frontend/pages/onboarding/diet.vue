<template>
  <div class="max-w-2xl mx-auto p-6 mt-10 bg-white rounded-lg shadow">
    <h1 class="text-2xl font-bold mb-6">Setup Your Profile</h1>
    <form @submit.prevent="saveProfile" class="space-y-6">
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">Dietary Preference</label>
        <select v-model="profile.dietary_preference" class="w-full border-gray-300 rounded-md shadow-sm focus:border-green-500 focus:ring-green-500 p-2 border">
          <option value="Pure Veg">Pure Veg</option>
          <option value="Eggetarian">Eggetarian</option>
          <option value="Non-Veg">Non-Veg</option>
          <option value="Vegan">Vegan</option>
          <option value="Jain">Jain (No Onion & Garlic)</option>
        </select>
      </div>
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">Household Size (Number of people)</label>
        <input type="number" v-model="profile.household_size" min="1" max="20" class="w-full border-gray-300 rounded-md shadow-sm focus:border-green-500 focus:ring-green-500 p-2 border" />
      </div>
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">Daily Macro Goals (Average per person)</label>
        <div class="grid grid-cols-3 gap-4">
          <div>
            <label class="block text-xs text-gray-500">Protein (g)</label>
            <input type="number" v-model="profile.macros.protein" class="w-full border-gray-300 rounded-md p-2 border" />
          </div>
          <div>
            <label class="block text-xs text-gray-500">Carbs (g)</label>
            <input type="number" v-model="profile.macros.carbs" class="w-full border-gray-300 rounded-md p-2 border" />
          </div>
          <div>
            <label class="block text-xs text-gray-500">Fats (g)</label>
            <input type="number" v-model="profile.macros.fats" class="w-full border-gray-300 rounded-md p-2 border" />
          </div>
        </div>
      </div>
      <div class="flex items-center">
        <input type="checkbox" v-model="profile.meal_prep_toggle" id="meal_prep" class="h-4 w-4 text-green-600 border-gray-300 rounded focus:ring-green-500" />
        <label for="meal_prep" class="ml-2 block text-sm text-gray-900">
          Enable Meal Prep Plan (e.g., batch-prepping dosa batter on weekends)
        </label>
      </div>
      <button type="submit" class="w-full bg-green-600 text-white py-2 px-4 rounded-md hover:bg-green-700">Next: Build Pantry</button>
    </form>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const supabase = useSupabaseClient()
const user = useSupabaseUser()

const profile = ref({
  dietary_preference: 'Pure Veg',
  household_size: 1,
  macros: { protein: 50, carbs: 250, fats: 60 },
  meal_prep_toggle: false
})

const saveProfile = async () => {
  if (!user.value) {
    console.warn("No authenticated user found. Mocking navigation.")
    navigateTo('/onboarding/pantry')
    return
  }
  
  const { error } = await supabase.from('profiles').upsert({
    id: user.value.id,
    dietary_preference: profile.value.dietary_preference,
    household_size: profile.value.household_size,
    macro_goals_json: profile.value.macros,
    meal_prep_toggle: profile.value.meal_prep_toggle
  })
  
  if (error) {
    alert("Error saving profile: " + error.message)
  } else {
    navigateTo('/onboarding/pantry')
  }
}
</script>