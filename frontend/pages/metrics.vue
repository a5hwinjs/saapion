<template>
  <div class="bg-background text-on-background font-body min-h-screen pb-24 md:pb-0">
    <!-- TopAppBar -->
    <header class="bg-background/80 backdrop-blur-md sticky top-0 z-50 flex justify-between items-center px-6 py-4 w-full transition-colors duration-300 shadow-sm">
      <div class="flex items-center gap-4">
        <div class="w-10 h-10 rounded-full overflow-hidden bg-surface-variant flex-shrink-0">
          <img alt="User profile photo" class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDTDA2SdmdnAfTQ7EfxqaQytoSf8PFpnzQH2VBokTwD2TtAhCxOw_h6s_geWj9tnPKkpDy0630PNfTuL_TjUVnapJpNu3-LzE_0HiPky_J1QTy6wytf2EqISQ04g335INQfivtV1wxVAcKf_GdQ4jktg2gCsjorF7qKf_4v5sW4ZLfBDMiq_lAbFGFxU2-VnXezPG13GWVQgtdJJy378hA91c-2ya0wF76UtxfdGkmQlamLvzojYE3wjU05g11zMvJ7so-XJyaqE613" />
        </div>
        <h1 class="text-2xl font-extrabold text-primary tracking-tighter font-headline">Saapion</h1>
      </div>
      <div class="hidden md:flex gap-6">
        <NuxtLink to="/dashboard" class="font-bold text-stone-500 hover:text-primary">Dashboard</NuxtLink>
        <NuxtLink to="/pantry" class="font-bold text-stone-500 hover:text-primary">Pantry</NuxtLink>
        <NuxtLink to="/metrics" class="font-bold text-primary border-b-2 border-primary">Metrics</NuxtLink>
      </div>
    </header>

    <main class="flex-grow max-w-5xl mx-auto w-full px-4 sm:px-6 lg:px-8 py-8 space-y-10">
      <!-- Loading State -->
      <div v-if="loading" class="flex justify-center py-20">
        <div class="w-12 h-12 border-4 border-primary/20 border-t-primary rounded-full animate-spin"></div>
      </div>

      <div v-else>
        <!-- Hero: Daily Summary -->
        <section class="space-y-6">
          <div class="flex justify-between items-end">
            <div>
              <h2 class="font-headline text-3xl md:text-4xl font-bold tracking-tight text-primary">Daily Alchemy</h2>
              <p class="text-on-surface-variant mt-1 text-sm md:text-base">Your personalized fuel metrics for today.</p>
            </div>
            <div class="hidden sm:flex items-center gap-2 bg-surface-container-highest px-4 py-2 rounded-full">
              <span class="material-symbols-outlined text-secondary icon-fill text-sm">eco</span>
              <span class="text-xs font-bold uppercase tracking-widest text-secondary">On Track</span>
            </div>
          </div>

          <!-- Bento Grid -->
          <div class="grid grid-cols-1 md:grid-cols-12 gap-6">
            <!-- Main Calorie Card -->
            <div class="md:col-span-7 lg:col-span-8 bg-surface-container-lowest rounded-[1.5rem] p-6 sm:p-8 shadow-sm relative overflow-hidden flex flex-col sm:flex-row items-center gap-8 group hover:bg-surface-dim transition-colors duration-300">
              <div class="relative w-40 h-40 flex-shrink-0">
                <svg class="w-full h-full transform -rotate-90" viewBox="0 0 100 100">
                  <circle class="stroke-surface-variant" cx="50" cy="50" fill="none" r="45" stroke-linecap="round" stroke-width="6"></circle>
                  <circle class="stroke-primary transition-all duration-1000" cx="50" cy="50" fill="none" r="45" stroke-dasharray="282.7" :stroke-dashoffset="282.7 - (282.7 * Math.min(1, macros.calories / dailyGoal.calories))" stroke-linecap="round" stroke-width="6"></circle>
                </svg>
                <div class="absolute inset-0 flex flex-col items-center justify-center">
                  <span class="font-headline text-3xl font-extrabold text-on-surface">{{ Math.round(macros.calories) }}</span>
                  <span class="text-xs font-semibold text-on-surface-variant uppercase tracking-widest mt-1">Kcal</span>
                </div>
              </div>
              <div class="flex-grow text-center sm:text-left space-y-2 z-10">
                <h3 class="font-headline text-xl font-bold text-on-surface">Energy Balance</h3>
                <p class="text-on-surface-variant text-sm leading-relaxed">
                  You've consumed {{ Math.round((macros.calories / dailyGoal.calories) * 100) }}% of your daily target.
                </p>
                <div class="pt-2 text-xs font-medium text-primary">Target: {{ dailyGoal.calories }} kcal</div>
              </div>
            </div>

            <!-- Macros Stack -->
            <div class="md:col-span-5 lg:col-span-4 flex flex-col gap-4">
              <!-- Protein -->
              <div class="bg-surface-container-low rounded-xl p-5 hover:bg-surface-dim transition-colors">
                <div class="flex justify-between items-center mb-3">
                  <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined text-tertiary text-sm">fitness_center</span>
                    <span class="font-bold text-sm text-on-surface">Protein</span>
                  </div>
                  <span class="text-xs font-bold text-on-surface-variant">{{ Math.round(macros.protein) }}g / {{ dailyGoal.protein }}g</span>
                </div>
                <div class="w-full h-1 bg-surface-variant rounded-full overflow-hidden">
                  <div class="h-full bg-tertiary rounded-full transition-all duration-1000" :style="`width: ${Math.min(100, (macros.protein / dailyGoal.protein) * 100)}%`"></div>
                </div>
              </div>
              <!-- Carbs -->
              <div class="bg-surface-container-low rounded-xl p-5 hover:bg-surface-dim transition-colors">
                <div class="flex justify-between items-center mb-3">
                  <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined text-secondary text-sm">agriculture</span>
                    <span class="font-bold text-sm text-on-surface">Carbs</span>
                  </div>
                  <span class="text-xs font-bold text-on-surface-variant">{{ Math.round(macros.carbs) }}g / {{ dailyGoal.carbs }}g</span>
                </div>
                <div class="w-full h-1 bg-surface-variant rounded-full overflow-hidden">
                  <div class="h-full bg-secondary rounded-full transition-all duration-1000" :style="`width: ${Math.min(100, (macros.carbs / dailyGoal.carbs) * 100)}%`"></div>
                </div>
              </div>
              <!-- Fats -->
              <div class="bg-surface-container-low rounded-xl p-5 hover:bg-surface-dim transition-colors">
                <div class="flex justify-between items-center mb-3">
                  <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined text-primary-container text-sm">water_drop</span>
                    <span class="font-bold text-sm text-on-surface">Fats</span>
                  </div>
                  <span class="text-xs font-bold text-on-surface-variant">{{ Math.round(macros.fats) }}g / {{ dailyGoal.fats }}g</span>
                </div>
                <div class="w-full h-1 bg-surface-variant rounded-full overflow-hidden">
                  <div class="h-full bg-primary-container rounded-full transition-all duration-1000" :style="`width: ${Math.min(100, (macros.fats / dailyGoal.fats) * 100)}%`"></div>
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- Post-Meal Feedback Section -->
        <section class="mt-12" v-if="recentRating">
          <h2 class="font-headline text-2xl font-bold tracking-tight text-on-surface mb-6">Recent Experience</h2>
          <div class="bg-surface-container-lowest rounded-[1.5rem] shadow-sm overflow-hidden flex flex-col md:flex-row group">
            <div class="w-full md:w-2/5 h-48 md:h-auto relative">
              <img :src="recentRating.recipe?.image_url || 'https://lh3.googleusercontent.com/aida-public/AB6AXuBL5n1tjSNBrGc1C9S1X796my1m-GR8n6Ongr5_NJy4JQP8PhghOjaHn955tmIe8u3jCl_365jJ4xeUgDAqbAYLsyTFCF0LOa15A-k_0ieCusFAVkmrwIaUJZ0IBNw90YJ55ZfrnoUm8NP1dT1Va3830eqGvdzYP2Ofa8yQepc7_V3KZHD44XbDx_dwJpYdDmN2n15iKbqii1ak-8S5KNTI5DXBcxDs9w9h_Vu5kFy4uVi-EPkkrH5EHPeqY25tzlCKZdmU50_ljo_G'" alt="Recipe" class="w-full h-full object-cover" />
            </div>
            <div class="w-full md:w-3/5 p-6 sm:p-8 flex flex-col justify-between bg-surface-container-lowest transition-colors group-hover:bg-surface-dim">
              <div>
                <h3 class="font-headline text-2xl font-bold text-primary mb-2">{{ recentRating.recipe?.title }}</h3>
                <p class="text-sm text-on-surface-variant mb-6">You cooked this recently.</p>
                <div class="space-y-6">
                  <div class="grid grid-cols-2 gap-6 pt-4 border-t border-surface-variant/30">
                    <div>
                      <label class="block text-xs font-bold text-on-surface-variant uppercase tracking-wider mb-2">Taste Profile</label>
                      <div class="flex text-primary-container cursor-pointer">
                        <span v-for="i in 5" :key="'taste'+i" @click="updateRating('taste', i)" class="material-symbols-outlined hover:scale-110 transition-transform" :class="i <= recentRating.taste ? 'icon-fill' : 'text-surface-variant'">star</span>
                      </div>
                    </div>
                    <div>
                      <label class="block text-xs font-bold text-on-surface-variant uppercase tracking-wider mb-2">Prep Difficulty</label>
                      <div class="flex text-secondary cursor-pointer">
                        <span v-for="i in 5" :key="'diff'+i" @click="updateRating('difficulty', i)" class="material-symbols-outlined hover:scale-110 transition-transform" :class="i <= recentRating.difficulty ? 'icon-fill' : 'text-surface-variant'">local_fire_department</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>
      </div>
    </main>

    <!-- BottomNavBar (Mobile Only) -->
    <nav class="md:hidden bg-background/80 backdrop-blur-md fixed bottom-0 left-0 w-full flex justify-around items-center px-4 pb-6 pt-2 rounded-t-3xl z-50 shadow-[0_-8px_24px_rgba(0,0,0,0.06)] border-t border-outline-variant/20">
      <NuxtLink to="/dashboard" class="flex flex-col items-center justify-center text-stone-500 p-2 hover:text-primary">
        <span class="material-symbols-outlined mb-1">dashboard</span>
      </NuxtLink>
      <NuxtLink to="/pantry" class="flex flex-col items-center justify-center text-stone-500 p-2 hover:text-primary">
        <span class="material-symbols-outlined mb-1">inventory_2</span>
      </NuxtLink>
      <NuxtLink to="/metrics" class="flex flex-col items-center justify-center text-primary p-2">
        <span class="material-symbols-outlined mb-1 icon-fill">analytics</span>
      </NuxtLink>
    </nav>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const supabase = useSupabaseClient()
const user = useSupabaseUser()

const loading = ref(true)
const macros = ref({ calories: 0, protein: 0, carbs: 0, fats: 0 })
const dailyGoal = ref({ calories: 2400, protein: 150, carbs: 250, fats: 70 })
const recentRating = ref(null)

const updateRating = async (field, value) => {
  if (!recentRating.value) return;
  
  const previousValue = recentRating.value[field];
  recentRating.value[field] = value;

  try {
    const { error } = await supabase
      .from('ratings')
      .update({ [field]: value })
      .eq('id', recentRating.value.id);
      
    if (error) throw error;
  } catch (error) {
    console.error('Error updating rating:', error);
    recentRating.value[field] = previousValue;
    alert('Failed to update rating. Please try again.');
  }
}

onMounted(async () => {
  try {
    let userId = user.value?.id
    if (!userId) {
      const { data: { session } } = await supabase.auth.getSession()
      userId = session?.user?.id
    }
    
    if (userId) {
      // Get profile goals
      const { data: profile } = await supabase.from('profiles').select('macro_goals_json').eq('id', userId).single()
      if (profile?.macro_goals_json) {
        const p = profile.macro_goals_json
        const fats = p.fat !== undefined ? p.fat : (p.fats !== undefined ? p.fats : dailyGoal.value.fats)
        dailyGoal.value = { 
          ...dailyGoal.value, 
          ...p,
          fats: fats
        }
        dailyGoal.value.calories = Math.round((dailyGoal.value.protein * 4) + (dailyGoal.value.carbs * 4) + (dailyGoal.value.fats * 9))
      }

      // Get today's macros
      const today = new Date().toISOString().split('T')[0]
      const { data: macroData } = await supabase.from('user_macros').select('*').eq('user_id', userId).eq('date', today).single()
      if (macroData) {
        macros.value = {
          calories: macroData.calories || 0,
          protein: macroData.protein || 0,
          carbs: macroData.carbs || 0,
          fats: macroData.fats || 0
        }
      }

      // Get recent rating
      const { data: ratingData } = await supabase
        .from('ratings')
        .select('*, recipe:recipes(title, image_url)')
        .eq('user_id', userId)
        .order('created_at', { ascending: false })
        .limit(1)
        .single()
      
      if (ratingData) {
        recentRating.value = ratingData
      }
    }
  } catch (error) {
    console.error("Error fetching metrics:", error)
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200');

.material-symbols-outlined {
  font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
}
.icon-fill {
  font-variation-settings: 'FILL' 1;
}
</style>