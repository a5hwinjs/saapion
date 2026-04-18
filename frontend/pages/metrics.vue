<template>
  <div class="saapion-metrics">
    <!-- Hero: Daily Summary -->
    <section v-if="!loading" class="space-y-8 mb-16">
      <div class="flex justify-between items-end">
        <div>
          <h2 class="font-headline text-4xl md:text-5xl font-extrabold tracking-tight text-primary">Daily Alchemy</h2>
          <p class="text-on-surface-variant mt-2 text-lg">Your personalized fuel metrics for today.</p>
        </div>
        <div class="hidden sm:flex items-center gap-2 bg-secondary-container px-4 py-2 rounded-full shadow-sm">
          <span class="material-symbols-outlined text-on-secondary-container text-sm" style="font-variation-settings: 'FILL' 1;">eco</span>
          <span class="text-xs font-bold uppercase tracking-widest text-on-secondary-container">On Track</span>
        </div>
      </div>

      <!-- Bento Grid -->
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">
        <!-- Main Calorie Card -->
        <div class="lg:col-span-8 bg-surface-container-low rounded-[2.5rem] p-8 md:p-12 shadow-sm relative overflow-hidden flex flex-col md:flex-row items-center gap-12 group hover:bg-surface-container transition-all duration-500 border border-outline-variant/10">
          <!-- Decorative element -->
          <div class="absolute -right-20 -top-20 w-64 h-64 bg-primary-container/10 rounded-full blur-3xl group-hover:bg-primary-container/20 transition-colors"></div>
          
          <!-- Circular Progress -->
          <div class="relative w-48 h-48 flex-shrink-0 z-10">
            <svg class="w-full h-full transform -rotate-90" viewbox="0 0 100 100">
              <circle class="text-surface-variant stroke-current" cx="50" cy="50" fill="none" r="45" stroke-width="8"></circle>
              <circle class="text-primary stroke-current" cx="50" cy="50" fill="none" r="45" :stroke-dasharray="282.7" :stroke-dashoffset="282.7 - (282.7 * caloriePercentage / 100)" stroke-linecap="round" stroke-width="8"></circle>
            </svg>
            <div class="absolute inset-0 flex flex-col items-center justify-center">
              <span class="font-headline text-4xl font-extrabold text-on-surface">{{ Math.round(totalCaloriesConsumed) }}</span>
              <span class="text-[10px] font-bold text-on-surface-variant uppercase tracking-[0.2em] mt-1">Kcal</span>
            </div>
          </div>

          <div class="flex-grow text-center md:text-left space-y-4 z-10">
            <h3 class="font-headline text-2xl font-bold text-on-surface tracking-tight">Energy Balance</h3>
            <p class="text-on-surface-variant text-base leading-relaxed max-w-sm">You've consumed {{ caloriePercentage }}% of your daily target. A great pace to maintain steady energy levels through the evening.</p>
            <div class="pt-2 text-sm font-bold text-primary flex items-center gap-2">
              <span class="material-symbols-outlined text-sm">flag</span>
              Target: {{ Math.round(totalCaloriesGoal) }} kcal
            </div>
          </div>
        </div>

        <!-- Macros Stack -->
        <div class="lg:col-span-4 flex flex-col gap-4">
          <!-- Protein -->
          <div class="bg-surface-container-lowest rounded-3xl p-6 shadow-sm border border-outline-variant/5 hover:bg-surface-dim transition-colors group">
            <div class="flex justify-between items-center mb-4">
              <div class="flex items-center gap-3">
                <div class="w-8 h-8 rounded-full bg-tertiary-container/30 flex items-center justify-center text-tertiary group-hover:scale-110 transition-transform">
                  <span class="material-symbols-outlined text-sm" style="font-variation-settings: 'FILL' 1;">fitness_center</span>
                </div>
                <span class="font-bold text-sm text-on-surface uppercase tracking-widest">Protein</span>
              </div>
              <span class="text-xs font-extrabold text-tertiary">{{ Math.round(dailyConsumption.protein) }}g <span class="text-on-surface-variant/50 font-medium">/ {{ macroGoals.protein }}g</span></span>
            </div>
            <div class="w-full h-1.5 bg-surface-variant rounded-full overflow-hidden">
              <div class="h-full bg-tertiary rounded-full shadow-[0_0_8px_rgba(178,44,1,0.3)]" :style="{ width: getMacroPercentage('protein') + '%' }"></div>
            </div>
          </div>

          <!-- Carbs -->
          <div class="bg-surface-container-lowest rounded-3xl p-6 shadow-sm border border-outline-variant/5 hover:bg-surface-dim transition-colors group">
            <div class="flex justify-between items-center mb-4">
              <div class="flex items-center gap-3">
                <div class="w-8 h-8 rounded-full bg-secondary-container/30 flex items-center justify-center text-secondary group-hover:scale-110 transition-transform">
                  <span class="material-symbols-outlined text-sm" style="font-variation-settings: 'FILL' 1;">grain</span>
                </div>
                <span class="font-bold text-sm text-on-surface uppercase tracking-widest">Carbs</span>
              </div>
              <span class="text-xs font-extrabold text-secondary">{{ Math.round(dailyConsumption.carbs) }}g <span class="text-on-surface-variant/50 font-medium">/ {{ macroGoals.carbs }}g</span></span>
            </div>
            <div class="w-full h-1.5 bg-surface-variant rounded-full overflow-hidden">
              <div class="h-full bg-secondary rounded-full shadow-[0_0_8px_rgba(58,104,67,0.3)]" :style="{ width: getMacroPercentage('carbs') + '%' }"></div>
            </div>
          </div>

          <!-- Fats -->
          <div class="bg-surface-container-lowest rounded-3xl p-6 shadow-sm border border-outline-variant/5 hover:bg-surface-dim transition-colors group">
            <div class="flex justify-between items-center mb-4">
              <div class="flex items-center gap-3">
                <div class="w-8 h-8 rounded-full bg-primary-container/30 flex items-center justify-center text-primary group-hover:scale-110 transition-transform">
                  <span class="material-symbols-outlined text-sm" style="font-variation-settings: 'FILL' 1;">water_drop</span>
                </div>
                <span class="font-bold text-sm text-on-surface uppercase tracking-widest">Fats</span>
              </div>
              <span class="text-xs font-extrabold text-primary">{{ Math.round(dailyConsumption.fat) }}g <span class="text-on-surface-variant/50 font-medium">/ {{ macroGoals.fat }}g</span></span>
            </div>
            <div class="w-full h-1.5 bg-surface-variant rounded-full overflow-hidden">
              <div class="h-full bg-primary rounded-full shadow-[0_0_8px_rgba(126,87,0,0.3)]" :style="{ width: getMacroPercentage('fat') + '%' }"></div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Loading State -->
    <div v-else class="min-h-[60vh] flex flex-col items-center justify-center gap-4">
      <div class="w-12 h-12 border-4 border-primary/20 border-t-primary rounded-full animate-spin"></div>
      <p class="font-label text-sm font-bold text-on-surface-variant uppercase tracking-widest">Calculating Metrics...</p>
    </div>

    <!-- History Chart -->
    <section class="mt-16">
      <div class="flex items-center justify-between mb-8">
        <h2 class="font-headline text-2xl font-bold tracking-tight text-on-surface">Weekly Journey</h2>
        <div class="flex gap-2">
          <div class="flex items-center gap-2"><div class="w-2 h-2 rounded-full bg-tertiary"></div><span class="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant">P</span></div>
          <div class="flex items-center gap-2"><div class="w-2 h-2 rounded-full bg-secondary"></div><span class="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant">C</span></div>
          <div class="flex items-center gap-2"><div class="w-2 h-2 rounded-full bg-primary"></div><span class="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant">F</span></div>
        </div>
      </div>

      <div class="bg-surface-container-low rounded-[2rem] p-8 h-64 flex items-end justify-around gap-2 shadow-sm border border-outline-variant/5">
        <div v-for="(day, index) in ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']" :key="index" class="flex-1 flex flex-col items-center gap-4 h-full">
          <div class="w-full max-w-[40px] flex-1 flex flex-col justify-end gap-0.5 group cursor-help relative">
            <!-- Tooltip mock -->
            <div class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 hidden group-hover:block bg-on-surface text-surface text-[10px] px-2 py-1 rounded-lg z-20 whitespace-nowrap shadow-xl">
              Protein: 120g | Carbs: 210g
            </div>
            
            <div class="w-full bg-primary/20 rounded-t-full transition-all group-hover:bg-primary/40 shadow-diffuse" :style="{ height: (Math.random() * 20 + 10) + '%' }"></div>
            <div class="w-full bg-secondary/20 transition-all group-hover:bg-secondary/40 shadow-diffuse" :style="{ height: (Math.random() * 30 + 20) + '%' }"></div>
            <div class="w-full bg-tertiary/20 transition-all group-hover:bg-tertiary/40 shadow-diffuse" :style="{ height: (Math.random() * 20 + 10) + '%' }"></div>
          </div>
          <span class="font-label text-[10px] font-bold text-on-surface-variant">{{ day[0] }}</span>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

const supabase = useSupabaseClient()
const user = useSupabaseUser()

const loading = ref(true)
const macroGoals = ref({ protein: 150, carbs: 250, fat: 70 })
const dailyConsumption = ref({ protein: 0, carbs: 0, fat: 0 })

onMounted(async () => {
  try {
    let userId = user.value?.id
    if (!userId) {
      const { data: { session } } = await supabase.auth.getSession()
      userId = session?.user?.id
    }
    if (!userId) return

    // 1. Fetch Macro Goals from Profile
    const { data: profile } = await supabase
      .from('profiles')
      .select('macro_goals_json')
      .eq('id', userId)
      .single()
    
    if (profile?.macro_goals_json) {
      macroGoals.value = profile.macro_goals_json
    }

    // 2. Fetch Today's Meals and their macros
    const today = new Intl.DateTimeFormat('en-US', { weekday: 'long' }).format(new Date())
    
    // We need to find the active plan first
    const dateStr = new Date().toISOString().split('T')[0]
    const { data: plan } = await supabase
      .from('meal_plans')
      .select('id')
      .eq('user_id', userId)
      .lte('start_date', dateStr)
      .gte('end_date', dateStr)
      .order('created_at', { ascending: false })
      .limit(1)
      .single()

    if (plan) {
      const { data: items } = await supabase
        .from('meal_plan_items')
        .select('*, recipes(macros_json)')
        .eq('meal_plan_id', plan.id)
        .eq('day_of_week', today)
      
      if (items) {
        items.forEach(item => {
          const rm = item.recipes?.macros_json
          if (rm) {
            dailyConsumption.value.protein += Number(rm.protein || 0)
            dailyConsumption.value.carbs += Number(rm.carbs || 0)
            dailyConsumption.value.fat += Number(rm.fat || 0)
          }
        })
      }
    }

  } catch (error) {
    console.error("Error fetching metrics:", error)
  } finally {
    loading.value = false
  }
})

const totalCaloriesGoal = computed(() => {
  return (macroGoals.value.protein * 4) + (macroGoals.value.carbs * 4) + (macroGoals.value.fat * 9)
})

const totalCaloriesConsumed = computed(() => {
  return (dailyConsumption.value.protein * 4) + (dailyConsumption.value.carbs * 4) + (dailyConsumption.value.fat * 9)
})

const caloriePercentage = computed(() => {
  if (totalCaloriesGoal.value === 0) return 0
  return Math.min(Math.round((totalCaloriesConsumed.value / totalCaloriesGoal.value) * 100), 100)
})

const getMacroPercentage = (type) => {
  const goal = macroGoals.value[type]
  const consumed = dailyConsumption.value[type]
  if (!goal) return 0
  return Math.min(Math.round((consumed / goal) * 100), 100)
}
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200');

.material-symbols-outlined {
  font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
}
</style>