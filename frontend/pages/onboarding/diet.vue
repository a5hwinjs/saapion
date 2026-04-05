<template>
  <div class="saapion-app-container min-h-screen flex flex-col items-center justify-center p-6 bg-[var(--color-bg-light)]">
    <div class="w-full max-w-md bg-white rounded-3xl shadow-diffuse p-8 relative overflow-hidden">
      <!-- Decorative background accent -->
      <div class="absolute -top-10 -right-10 w-32 h-32 bg-pastel-mint rounded-full opacity-50 blur-2xl"></div>

      <h1 class="text-3xl font-extrabold text-gray-800 mb-2 relative z-10">Setup Your Profile</h1>
      <p class="text-gray-500 mb-8 relative z-10">Tailor Saapion to your unique lifestyle.</p>

      <form @submit.prevent="saveProfile" class="space-y-6 relative z-10">
        <!-- Dietary Preference -->
        <div>
          <label class="block text-sm font-bold text-gray-700 mb-3">Dietary Preference</label>
          <div class="grid grid-cols-1 gap-2">
            <button 
              v-for="option in dietaryOptions" 
              :key="option.value"
              type="button"
              @click="profile.dietary_preference = option.value"
              :class="[
                'flex items-center justify-between px-4 py-3 rounded-2xl border-2 transition-all duration-200 text-left',
                profile.dietary_preference === option.value 
                  ? 'border-accent-teal bg-pastel-mint/20 text-teal-900 shadow-sm' 
                  : 'border-gray-100 bg-gray-50 text-gray-600 hover:border-gray-200'
              ]"
            >
              <span class="font-semibold">{{ option.label }}</span>
              <span v-if="profile.dietary_preference === option.value" class="text-accent-teal">✔</span>
            </button>
          </div>
        </div>

        <!-- Household Size -->
        <div>
          <label class="block text-sm font-bold text-gray-700 mb-2">Household Size</label>
          <div class="flex items-center space-x-4 bg-gray-50 p-2 rounded-2xl border border-gray-100">
            <button type="button" @click="profile.household_size > 1 ? profile.household_size-- : null" class="w-10 h-10 bg-white rounded-xl shadow-sm flex items-center justify-center text-xl font-bold text-gray-600 hover:bg-gray-100">-</button>
            <input type="number" v-model="profile.household_size" min="1" max="20" class="flex-1 bg-transparent text-center font-bold text-gray-800 focus:outline-none" />
            <button type="button" @click="profile.household_size++" class="w-10 h-10 bg-white rounded-xl shadow-sm flex items-center justify-center text-xl font-bold text-gray-600 hover:bg-gray-100">+</button>
          </div>
          <p class="text-[10px] text-gray-400 mt-2 text-center uppercase tracking-widest font-bold">Number of people in your kitchen</p>
        </div>

        <!-- Macros -->
        <div>
          <label class="block text-sm font-bold text-gray-700 mb-3">Daily Macro Goals (Total)</label>
          <div class="grid grid-cols-3 gap-3">
            <div class="bg-gray-50 p-3 rounded-2xl border border-gray-100">
              <label class="block text-[10px] font-bold text-accent-teal uppercase mb-1">Protein</label>
              <input type="number" v-model="profile.macros.protein" class="w-full bg-transparent font-bold text-gray-800 focus:outline-none text-lg" />
              <span class="text-[10px] text-gray-400 font-bold uppercase">grams</span>
            </div>
            <div class="bg-gray-50 p-3 rounded-2xl border border-gray-100">
              <label class="block text-[10px] font-bold text-blue-500 uppercase mb-1">Carbs</label>
              <input type="number" v-model="profile.macros.carbs" class="w-full bg-transparent font-bold text-gray-800 focus:outline-none text-lg" />
              <span class="text-[10px] text-gray-400 font-bold uppercase">grams</span>
            </div>
            <div class="bg-gray-50 p-3 rounded-2xl border border-gray-100">
              <label class="block text-[10px] font-bold text-orange-500 uppercase mb-1">Fats</label>
              <input type="number" v-model="profile.macros.fat" class="w-full bg-transparent font-bold text-gray-800 focus:outline-none text-lg" />
              <span class="text-[10px] text-gray-400 font-bold uppercase">grams</span>
            </div>
          </div>
        </div>

        <button type="submit" :disabled="saving" class="w-full bg-accent-teal text-white py-4 rounded-2xl font-bold text-lg shadow-diffuse hover:bg-teal-600 hover:-translate-y-1 transition-all disabled:opacity-50">
          {{ saving ? 'Saving...' : 'Next: Build Pantry' }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const supabase = useSupabaseClient()
const user = useSupabaseUser()

const saving = ref(false)

const dietaryOptions = [
  { label: 'Jain (No Onion/Garlic)', value: 'jain' },
  { label: 'Pure Vegetarian', value: 'veg' },
  { label: 'Eggetarian (Egg allowed)', value: 'eggetarian' },
  { label: 'Pescatarian (Fish allowed)', value: 'pescatarian' },
  { label: 'Non-Vegetarian', value: 'non-veg' }
]

const profile = ref({
  dietary_preference: 'veg',
  household_size: 1,
  macros: { protein: 50, carbs: 250, fat: 60 },
  meal_prep_toggle: false
})

const saveProfile = async () => {
  // Try to get ID from reactive user first, fallback to checking session directly
  let userId = user.value?.id
  
  if (!userId) {
    const { data: { session } } = await supabase.auth.getSession()
    userId = session?.user?.id
  }
  
  if (!userId) {
    console.error("No valid user ID found after session check.")
    alert("User session not found. Please try logging in again.")
    return
  }

  saving.value = true
  
  const { error } = await supabase.from('profiles')
    .update({
      dietary_preference: profile.value.dietary_preference,
      household_size: profile.value.household_size,
      macro_goals_json: profile.value.macros,
      meal_prep_toggle: profile.value.meal_prep_toggle
    })
    .eq('id', userId)
  
  saving.value = false

  if (error) {
    alert("Error saving profile: " + error.message)
  } else {
    navigateTo('/onboarding/pantry')
  }
}
</script>