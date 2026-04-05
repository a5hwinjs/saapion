<template>
  <div class="flex items-center justify-center min-h-screen bg-gray-50">
    <div class="w-full max-w-md p-8 space-y-6 bg-white rounded-xl shadow-md">
      <h2 class="text-2xl font-bold text-center text-gray-900">Welcome to Saapion</h2>
      <p class="text-center text-gray-600">
        {{ isSignUp ? 'Create your account' : 'Sign in to your account' }}
      </p>

      <form class="space-y-4" @submit.prevent="handleAuth">
        <div v-if="isSignUp">
          <label class="block text-sm font-medium text-gray-700">Name</label>
          <input v-model="name" type="text" required class="w-full px-3 py-2 mt-1 border border-gray-300 rounded-md focus:ring-green-500 focus:border-green-500" />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700">Email</label>
          <input v-model="email" type="email" required class="w-full px-3 py-2 mt-1 border border-gray-300 rounded-md focus:ring-green-500 focus:border-green-500" />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700">Password</label>
          <input v-model="password" type="password" required class="w-full px-3 py-2 mt-1 border border-gray-300 rounded-md focus:ring-green-500 focus:border-green-500" />
        </div>
        
        <button type="submit" class="w-full px-4 py-2 font-medium text-white bg-green-600 rounded-md hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
          {{ isSignUp ? 'Sign Up' : 'Sign In' }}
        </button>
      </form>

      <div class="relative">
        <div class="absolute inset-0 flex items-center"><div class="w-full border-t border-gray-300"></div></div>
        <div class="relative flex justify-center text-sm"><span class="px-2 bg-white text-gray-500">Or continue with</span></div>
      </div>

      <button @click="handleGoogleLogin" class="w-full px-4 py-2 font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50">
        Sign in with Google
      </button>

      <p class="text-center text-sm text-gray-600">
        {{ isSignUp ? 'Already have an account?' : "Don't have an account?" }}
        <button @click="isSignUp = !isSignUp" class="text-green-600 font-semibold hover:underline">
          {{ isSignUp ? 'Sign In' : 'Sign Up' }}
        </button>
      </p>
      
      <p v-if="errorMsg" class="text-sm text-red-600 text-center">{{ errorMsg }}</p>
      <p v-if="successMsg" class="text-sm text-green-600 text-center">{{ successMsg }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const supabase = useSupabaseClient()
const name = ref('')
const email = ref('')
const password = ref('')
const isSignUp = ref(false)
const errorMsg = ref('')
const successMsg = ref('')

const handleAuth = async () => {
  errorMsg.value = ''
  successMsg.value = ''
  try {
    if (isSignUp.value) {
      const { error } = await supabase.auth.signUp({
        email: email.value,
        password: password.value,
        options: {
          data: {
            full_name: name.value
          }
        }
      })
      if (error) throw error
      successMsg.value = 'Account created successfully! Redirecting...'
      setTimeout(() => {
        navigateTo('/onboarding/diet')
      }, 1000)
    } else {
      const { error } = await supabase.auth.signInWithPassword({
        email: email.value,
        password: password.value,
      })
      if (error) throw error
      navigateTo('/onboarding/diet')
    }
  } catch (error) {
    errorMsg.value = error.message
  }
}

const handleGoogleLogin = async () => {
  try {
    const { error } = await supabase.auth.signInWithOAuth({
      provider: 'google',
    })
    if (error) throw error
  } catch (error) {
    errorMsg.value = error.message
  }
}
</script>