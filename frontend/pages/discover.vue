<template>
  <div>
    <h1 class="text-3xl font-bold text-gray-900 mb-6">Discover Recipes</h1>
    
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
      <!-- Feature Cards -->
      <div class="bg-white rounded-lg shadow p-6 border-t-4 border-blue-500 hover:shadow-lg transition cursor-pointer" @click="activeTab = 'fridge'">
        <h3 class="text-xl font-semibold mb-2">Cook from Fridge</h3>
        <p class="text-gray-600 mb-4 text-sm">Find recipes using only the ingredients you currently have in your pantry.</p>
        <span class="text-blue-600 font-medium hover:underline">Explore &rarr;</span>
      </div>
      
      <div class="bg-white rounded-lg shadow p-6 border-t-4 border-purple-500 hover:shadow-lg transition cursor-pointer" @click="activeTab = 'exotic'">
        <h3 class="text-xl font-semibold mb-2">Random Exotic</h3>
        <p class="text-gray-600 mb-4 text-sm">Discover a unique regional recipe featuring a lesser-known ingredient.</p>
        <span class="text-purple-600 font-medium hover:underline">Surprise Me &rarr;</span>
      </div>
      
      <div class="bg-white rounded-lg shadow p-6 border-t-4 border-orange-500 hover:shadow-lg transition cursor-pointer" @click="activeTab = 'quickie'">
        <h3 class="text-xl font-semibold mb-2">15-Min Quickies</h3>
        <p class="text-gray-600 mb-4 text-sm">Short on time? Get instantly matched with fast, healthy Indian meals.</p>
        <span class="text-orange-600 font-medium hover:underline">Find Quickies &rarr;</span>
      </div>
    </div>
    
    <!-- Tab Content -->
    <div v-if="activeTab === 'fridge'" class="bg-blue-50 rounded-lg p-6 border border-blue-100">
      <h2 class="text-2xl font-bold text-blue-800 mb-4 flex items-center">
        <span class="mr-2">Recipes From Your Pantry</span>
        <span class="bg-blue-200 text-blue-800 text-xs px-2 py-1 rounded-full">Matches</span>
      </h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div v-for="r in ['Tomato Upma', 'Lemon Rice']" :key="r" class="bg-white p-4 rounded shadow-sm border border-blue-100 flex justify-between items-center">
          <div>
            <h4 class="font-semibold">{{ r }}</h4>
            <p class="text-xs text-green-600 mt-1 font-medium">✓ 100% Match with your pantry</p>
          </div>
          <NuxtLink :to="`/recipe/${r.toLowerCase().replace(/ /g, '-')}`" class="px-4 py-2 bg-blue-100 text-blue-700 rounded text-sm font-medium hover:bg-blue-200 transition">View</NuxtLink>
        </div>
      </div>
    </div>

    <div v-if="activeTab === 'exotic'" class="bg-purple-50 rounded-lg p-6 border border-purple-100">
      <h2 class="text-2xl font-bold text-purple-800 mb-4">Ingredient Spotlight: Kalpasi</h2>
      <div class="bg-white p-6 rounded shadow-sm border border-purple-100">
        <div class="flex justify-between items-start">
          <div>
            <h4 class="font-semibold text-xl text-gray-900">Chettinad Mushroom Masala</h4>
            <p class="text-sm text-gray-600 mt-2 max-w-2xl">Kalpasi (black stone flower) gives authentic Chettinad dishes their signature earthy aroma. Try this rare spice today!</p>
          </div>
          <span class="px-3 py-1 bg-purple-100 text-purple-800 text-xs font-bold rounded">Rare Spice</span>
        </div>
        <NuxtLink to="/recipe/chettinad-mushroom" class="mt-6 inline-block px-5 py-2 bg-purple-600 text-white font-medium rounded hover:bg-purple-700 transition">Get Recipe &rarr;</NuxtLink>
      </div>
    </div>

    <div v-if="activeTab === 'quickie'" class="bg-orange-50 rounded-lg p-6 border border-orange-100">
      <h2 class="text-2xl font-bold text-orange-800 mb-4 flex items-center">
        <span class="mr-2">Under 15 Minutes</span>
        <span class="bg-orange-200 text-orange-800 text-xs px-2 py-1 rounded-full">Fast</span>
      </h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div v-for="r in ['Lemon Rice', 'Egg Bhurji', 'Poha']" :key="r" class="bg-white p-4 rounded shadow-sm border border-orange-100 flex justify-between items-center">
          <div>
            <h4 class="font-semibold">{{ r }}</h4>
            <p class="text-xs text-gray-500 mt-1 flex items-center space-x-2">
              <span>⏱ Prep: 5m</span> 
              <span class="text-gray-300">|</span> 
              <span>🔥 Cook: 10m</span>
            </p>
          </div>
          <NuxtLink :to="`/recipe/${r.toLowerCase().replace(/ /g, '-')}`" class="px-4 py-2 bg-orange-100 text-orange-700 rounded text-sm font-medium hover:bg-orange-200 transition">Cook Now</NuxtLink>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref } from 'vue'

const activeTab = ref('fridge')
</script>