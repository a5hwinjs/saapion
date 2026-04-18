<template>
  <div class="bg-background text-on-background font-body antialiased min-h-screen selection:bg-primary-container selection:text-on-primary-container">
    <!-- Main Canvas -->
    <main class="pt-12 pb-32 px-4 md:px-8 max-w-4xl mx-auto flex flex-col gap-12 relative z-10">
      <!-- Decorative background accent -->
      <div class="absolute top-0 right-0 w-96 h-96 bg-primary-container/20 rounded-full blur-3xl -z-10 pointer-events-none transform translate-x-1/3 -translate-y-1/3"></div>

      <!-- Header Section -->
      <section class="flex flex-col gap-2">
        <span class="font-label text-sm uppercase tracking-widest text-secondary font-bold">Step 1 of 2 • Profile Setup</span>
        <h1 class="font-headline text-4xl md:text-5xl tracking-tight text-on-surface font-extrabold leading-tight">
          Design Your <br/>
          <span class="text-primary italic font-serif font-medium tracking-normal">Culinary Profile</span>
        </h1>
        <p class="text-on-surface-variant font-body text-lg mt-2 max-w-xl">
          Define the boundaries of your kitchen. We'll curate the alchemy to match your vital goals.
        </p>
      </section>

      <!-- Dietary Blueprint Section -->
      <section class="bg-surface-container-low rounded-3xl p-6 md:p-8 flex flex-col gap-6 shadow-sm border border-outline-variant/10">
        <div class="flex items-center gap-3">
          <span class="material-symbols-outlined text-secondary text-2xl" style="font-variation-settings: 'FILL' 1;">eco</span>
          <h2 class="font-headline text-2xl tracking-tight font-bold text-on-surface">Dietary Blueprint</h2>
        </div>
        <p class="text-on-surface-variant text-sm font-body">Select the foundation for your recipes.</p>
        <div class="flex flex-wrap gap-3 mt-2">
          <button 
            v-for="option in dietaryOptions" 
            :key="option.value"
            type="button"
            @click="profile.dietary_preference = option.value"
            :class="[
              'rounded-full px-6 py-3 font-label text-[11px] font-bold tracking-[0.05em] uppercase flex items-center gap-2 transition-all duration-200 active:scale-95 shadow-sm border',
              profile.dietary_preference === option.value 
                ? 'bg-primary-container text-on-primary-container border-primary/20 scale-98' 
                : 'bg-surface-container-high text-on-surface-variant hover:bg-surface-dim border-transparent'
            ]"
          >
            <span v-if="profile.dietary_preference === option.value" class="material-symbols-outlined text-sm" style="font-variation-settings: 'FILL' 1;">check</span>
            {{ option.label }}
          </button>
        </div>
      </section>

      <!-- Household Size Section -->
      <section class="flex flex-col gap-6">
        <div class="flex items-center gap-3">
          <span class="material-symbols-outlined text-primary text-2xl" style="font-variation-settings: 'FILL' 1;">group</span>
          <h2 class="font-headline text-2xl tracking-tight font-bold text-on-surface">Household Size</h2>
        </div>
        <div class="flex items-center space-x-6 bg-surface-container-lowest p-4 rounded-2xl shadow-sm border border-outline-variant/10 w-full md:w-80">
          <button @click="profile.household_size > 1 ? profile.household_size-- : null" class="w-12 h-12 bg-surface-container hover:bg-surface-container-high rounded-xl flex items-center justify-center text-xl font-bold text-on-surface-variant transition-colors">-</button>
          <div class="flex-1 text-center">
            <span class="text-3xl font-headline font-extrabold text-primary">{{ profile.household_size }}</span>
            <p class="text-[10px] text-on-surface-variant/70 uppercase tracking-widest font-bold">People</p>
          </div>
          <button @click="profile.household_size++" class="w-12 h-12 bg-surface-container hover:bg-surface-container-high rounded-xl flex items-center justify-center text-xl font-bold text-on-surface-variant transition-colors">+</button>
        </div>
      </section>

      <!-- Macro Goals Section -->
      <section class="flex flex-col gap-6">
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-3">
            <span class="material-symbols-outlined text-tertiary text-2xl" style="font-variation-settings: 'FILL' 1;">local_fire_department</span>
            <h2 class="font-headline text-2xl tracking-tight font-bold text-on-surface">Daily Macro Targets</h2>
          </div>
          <span class="text-sm font-label font-bold text-on-surface-variant bg-surface-container-high px-3 py-1 rounded-full">{{ totalCalories }} kcal</span>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <!-- Protein Card -->
          <div class="bg-surface-container-lowest rounded-[1.5rem] p-6 flex flex-col gap-4 shadow-sm border border-outline-variant/10 group hover:bg-surface-dim transition-colors duration-300">
            <div class="flex justify-between items-center">
              <h3 class="font-headline text-lg font-bold text-on-surface">Protein</h3>
              <div class="flex items-baseline gap-1">
                <span class="font-body text-xl font-bold text-tertiary">{{ profile.macros.protein }}</span>
                <span class="text-sm font-label text-on-surface-variant">g</span>
              </div>
            </div>
            <div class="pt-4 pb-2">
              <input type="range" v-model="profile.macros.protein" min="0" max="300" 
                class="w-full h-1 bg-surface-container-high rounded-lg appearance-none cursor-pointer accent-tertiary" />
            </div>
          </div>

          <!-- Carbs Card -->
          <div class="bg-surface-container-lowest rounded-[1.5rem] p-6 flex flex-col gap-4 shadow-sm border border-outline-variant/10 group hover:bg-surface-dim transition-colors duration-300">
            <div class="flex justify-between items-center">
              <h3 class="font-headline text-lg font-bold text-on-surface">Carbs</h3>
              <div class="flex items-baseline gap-1">
                <span class="font-body text-xl font-bold text-secondary">{{ profile.macros.carbs }}</span>
                <span class="text-sm font-label text-on-surface-variant">g</span>
              </div>
            </div>
            <div class="pt-4 pb-2">
              <input type="range" v-model="profile.macros.carbs" min="0" max="500" 
                class="w-full h-1 bg-surface-container-high rounded-lg appearance-none cursor-pointer accent-secondary" />
            </div>
          </div>

          <!-- Fats Card -->
          <div class="bg-surface-container-lowest rounded-[1.5rem] p-6 flex flex-col gap-4 shadow-sm border border-outline-variant/10 group hover:bg-surface-dim transition-colors duration-300">
            <div class="flex justify-between items-center">
              <h3 class="font-headline text-lg font-bold text-on-surface">Fats</h3>
              <div class="flex items-baseline gap-1">
                <span class="font-body text-xl font-bold text-primary">{{ profile.macros.fat }}</span>
                <span class="text-sm font-label text-on-surface-variant">g</span>
              </div>
            </div>
            <div class="pt-4 pb-2">
              <input type="range" v-model="profile.macros.fat" min="0" max="150" 
                class="w-full h-1 bg-surface-container-high rounded-lg appearance-none cursor-pointer accent-primary" />
            </div>
          </div>
        </div>
      </section>

      <!-- Action Area -->
      <div class="mt-8">
        <button @click="saveProfile" :disabled="saving" class="bg-gradient-to-r from-primary to-primary-container text-on-primary rounded-full px-10 py-5 font-headline font-bold text-lg w-full md:w-auto shadow-diffuse scale-98 active:scale-95 transition-all duration-300 flex justify-center items-center gap-2 group disabled:opacity-50">
          <span class="material-symbols-outlined transition-transform group-hover:scale-110" :class="{ 'animate-spin': saving }">
            {{ saving ? 'sync' : 'done_all' }}
          </span>
          <span>{{ saving ? 'Saving Profile...' : 'Save & Continue' }}</span>
        </button>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

const supabase = useSupabaseClient()
const user = useSupabaseUser()

const saving = ref(false)

const dietaryOptions = [
  { label: 'Veg', value: 'veg' },
  { label: 'Jain', value: 'jain' },
  { label: 'Eggetarian', value: 'eggetarian' },
  { label: 'Non-Veg', value: 'non-veg' },
  { label: 'Vegan', value: 'vegan' }
]

const profile = ref({
  dietary_preference: 'veg',
  household_size: 1,
  macros: { protein: 50, carbs: 250, fat: 60 },
  meal_prep_toggle: false
})

onMounted(async () => {
  let userId = user.value?.id
  if (!userId) {
    const { data: { session } } = await supabase.auth.getSession()
    userId = session?.user?.id
  }
  if (!userId) return

  const { data, error } = await supabase
    .from('profiles')
    .select('dietary_preference, household_size, macro_goals_json, meal_prep_toggle')
    .eq('id', userId)
    .single()

  if (data && !error) {
    if (data.dietary_preference) profile.value.dietary_preference = data.dietary_preference
    if (data.household_size) profile.value.household_size = data.household_size
    if (data.macro_goals_json) {
      profile.value.macros = { ...profile.value.macros, ...data.macro_goals_json }
    }
    if (data.meal_prep_toggle !== null) profile.value.meal_prep_toggle = data.meal_prep_toggle
  }
})

const totalCalories = computed(() => {
  return (profile.value.macros.protein * 4) + (profile.value.macros.carbs * 4) + (profile.value.macros.fat * 9)
})

const saveProfile = async () => {
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

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200');

.material-symbols-outlined {
  font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
}

/* Range input styling */
input[type=range] {
  -webkit-appearance: none;
  background: transparent;
}
input[type=range]::-webkit-slider-thumb {
  -webkit-appearance: none;
  height: 20px;
  width: 20px;
  border-radius: 50%;
  background: #ffffff;
  cursor: pointer;
  margin-top: -8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.15);
  border: 2px solid currentColor;
}
input[type=range]::-webkit-slider-runnable-track {
  width: 100%;
  height: 4px;
  cursor: pointer;
  border-radius: 9999px;
  background: currentColor;
  opacity: 0.2;
}
</style>