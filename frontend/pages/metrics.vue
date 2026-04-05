<template>
  <div>
    <h1 class="text-3xl font-bold text-gray-900 mb-6">Macro Tracking Dashboard</h1>
    
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
      <div class="bg-white p-6 rounded-lg shadow border-t-4 border-green-500">
        <h3 class="text-gray-500 text-sm font-semibold uppercase tracking-wider mb-1">Average Daily Protein</h3>
        <p class="text-3xl font-bold text-gray-900">58g <span class="text-sm font-normal text-gray-500">/ 60g goal</span></p>
        <div class="w-full bg-gray-200 rounded-full h-2 mt-4">
          <div class="bg-green-500 h-2 rounded-full" style="width: 96%"></div>
        </div>
      </div>
      
      <div class="bg-white p-6 rounded-lg shadow border-t-4 border-blue-500">
        <h3 class="text-gray-500 text-sm font-semibold uppercase tracking-wider mb-1">Average Daily Carbs</h3>
        <p class="text-3xl font-bold text-gray-900">220g <span class="text-sm font-normal text-gray-500">/ 250g goal</span></p>
        <div class="w-full bg-gray-200 rounded-full h-2 mt-4">
          <div class="bg-blue-500 h-2 rounded-full" style="width: 88%"></div>
        </div>
      </div>
      
      <div class="bg-white p-6 rounded-lg shadow border-t-4 border-yellow-500">
        <h3 class="text-gray-500 text-sm font-semibold uppercase tracking-wider mb-1">Average Daily Fats</h3>
        <p class="text-3xl font-bold text-gray-900">55g <span class="text-sm font-normal text-gray-500">/ 60g goal</span></p>
        <div class="w-full bg-gray-200 rounded-full h-2 mt-4">
          <div class="bg-yellow-500 h-2 rounded-full" style="width: 91%"></div>
        </div>
      </div>
    </div>
    
    <div class="bg-white p-6 rounded-lg shadow">
      <h2 class="text-xl font-bold text-gray-900 mb-4">7-Day Macro History</h2>
      <div class="h-64 flex items-end space-x-2">
        <!-- Mock Bar Chart -->
        <div v-for="day in 7" :key="day" class="flex-1 flex flex-col justify-end items-center group">
          <div class="w-full bg-blue-100 flex flex-col justify-end rounded-t relative">
            <!-- Tooltip -->
            <div class="absolute bottom-full mb-2 hidden group-hover:block bg-gray-800 text-white text-xs px-2 py-1 rounded whitespace-nowrap z-10">
              P: {{ 40 + day * 3 }}g | C: {{ 200 + day * 5 }}g | F: {{ 40 + day * 2 }}g
            </div>
            
            <div class="w-full bg-yellow-400" :style="`height: ${20 + Math.random() * 10}%`" title="Fats"></div>
            <div class="w-full bg-blue-400" :style="`height: ${40 + Math.random() * 20}%`" title="Carbs"></div>
            <div class="w-full bg-green-400" :style="`height: ${20 + Math.random() * 10}%`" title="Protein"></div>
          </div>
          <span class="text-xs text-gray-500 mt-2">Day {{ day }}</span>
        </div>
      </div>
      <div class="flex justify-center space-x-6 mt-6 border-t pt-4">
        <div class="flex items-center"><span class="w-3 h-3 bg-green-400 rounded-full mr-2"></span><span class="text-sm text-gray-600">Protein</span></div>
        <div class="flex items-center"><span class="w-3 h-3 bg-blue-400 rounded-full mr-2"></span><span class="text-sm text-gray-600">Carbs</span></div>
        <div class="flex items-center"><span class="w-3 h-3 bg-yellow-400 rounded-full mr-2"></span><span class="text-sm text-gray-600">Fats</span></div>
      </div>
    </div>
  </div>
</template>