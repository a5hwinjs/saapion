<template>
  <!-- Main layout restricted to mobile bounds -->
  <div class="saapion-app-container bg-pastel-lavender flex flex-col">
    
    <!-- Top 40%: The Isolated Food Image Area -->
    <div class="relative h-[40vh] w-full flex items-center justify-center p-6">
      <button @click="$router.back()" class="absolute top-6 left-6 w-12 h-12 bg-white rounded-full flex items-center justify-center shadow-soft z-20 text-slate-900 hover:bg-gray-50">
        <span class="font-extrabold text-xl">&larr;</span>
      </button>
      
      <!-- Floating food image (requires background-removed PNGs) -->
      <img src="https://via.placeholder.com/300" alt="Recipe Image" class="w-64 h-64 object-contain drop-shadow-2xl z-10" />
    </div>

    <!-- Bottom 60%: The White Bottom Sheet -->
    <div class="bg-white rounded-t-[40px] shadow-soft z-10 -mt-10 flex-1 p-8 relative flex flex-col">
      
      <!-- Recipe Title & Profile Snippet -->
      <div class="flex justify-between items-start mb-6">
        <div>
          <h1 class="text-4xl font-extrabold text-slate-900 capitalize leading-tight">{{ formattedId }}</h1>
          <div class="flex items-center gap-2 mt-3">
            <div class="w-6 h-6 rounded-full bg-accent-yellow flex items-center justify-center text-xs font-extrabold text-slate-900">A</div>
            <span class="text-sm font-medium text-slate-500">From Ashwin's Plan</span>
          </div>
        </div>
      </div>

      <!-- Quick Metrics (Pill Shaped) -->
      <div class="flex gap-3 mb-8 overflow-x-auto pb-2 hide-scrollbar">
        <div class="bg-pastel-mint px-5 py-2.5 rounded-full flex items-center justify-center whitespace-nowrap">
          <span class="text-sm font-bold text-accent-midnight">⏱ 30 Min</span>
        </div>
        <div class="bg-accent-yellow/20 px-5 py-2.5 rounded-full flex items-center justify-center whitespace-nowrap">
          <span class="text-sm font-bold text-yellow-700">🔥 10 Steps</span>
        </div>
        <div class="bg-accent-teal/20 px-5 py-2.5 rounded-full flex items-center justify-center whitespace-nowrap">
          <span class="text-sm font-bold text-teal-800">🌿 Pure Veg</span>
        </div>
      </div>

      <!-- Ingredient Pool Vertical Flex -->
      <div class="mb-10">
        <h2 class="text-xl font-bold text-slate-900 mb-5">Ingredient Pool</h2>
        <div class="flex gap-4 overflow-x-auto pb-4 hide-scrollbar">
          
          <div 
            v-for="ing in requiredIngredients" 
            :key="ing.name" 
            class="flex flex-col items-center justify-center bg-slate-50 rounded-[32px] p-4 min-w-[100px] shadow-sm relative border-2"
            :class="ing.inPantry ? 'border-transparent' : 'border-alert-red bg-alert-red/5'"
          >
            <!-- Missing Indicator Badge -->
            <div v-if="!ing.inPantry" class="absolute -top-2 -right-2 w-6 h-6 bg-alert-red rounded-full flex items-center justify-center text-white text-xs font-bold shadow-sm">!</div>
            
            <!-- Ingredient Image (or Emoji placeholder) -->
            <div class="w-14 h-14 bg-white rounded-full mb-3 shadow-inner flex items-center justify-center text-2xl">
              🥥
            </div>
            
            <span class="text-sm font-extrabold text-slate-900 text-center">{{ ing.quantity }}</span>
            <span class="text-xs font-medium text-slate-500 text-center mt-1">{{ ing.name }}</span>
            
            <!-- Actionable alert text -->
            <span v-if="!ing.inPantry" class="text-[10px] font-bold text-alert-red mt-2 text-center tracking-wider uppercase">MISSING</span>
          </div>

        </div>
      </div>

      <!-- Primary Sticky Action -->
      <div class="mt-auto pt-4">
        <button class="w-full bg-accent-teal text-white text-xl font-extrabold py-5 rounded-full shadow-soft hover:bg-teal-500 transition-transform active:scale-95">
          Start Cooking
        </button>
      </div>

    </div>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'

const route = useRoute()
const id = route.params.id || 'lemon-rice'
const formattedId = computed(() => id.toString().replace(/-/g, ' '))

// Mock logic
const requiredIngredients = ref([
  { name: 'Toor Dal', quantity: '1 cup', inPantry: true },
  { name: 'Mustard', quantity: '1 tsp', inPantry: true },
  { name: 'Fresh Coconut', quantity: '1/2 cup', inPantry: false },
])
</script>