<template>
  <div class="bg-background text-on-surface font-body min-h-screen flex flex-col md:flex-row antialiased selection:bg-primary-container selection:text-on-primary-container">
    <!-- Left Side: Editorial Imagery -->
    <div class="hidden md:block md:w-[45%] lg:w-1/2 relative bg-surface-container-low overflow-hidden">
      <img alt="South Indian Spices" class="absolute inset-0 w-full h-full object-cover object-center" src="https://lh3.googleusercontent.com/aida-public/AB6AXuB30qK0lwYAz45xh4Ms5fzT3Y658ZbEyn_e5f_-RYzA-iKKmD240x_IW2TCnGaL5c6o898WnFi5CcEbaCE34v9y1SBmKA18gRp6N2GgalduvvuIzoPihQHDuWmpjhuVwS5dzTZTQP9Fl9lftCsmLlCP1BOswIb1gJePOe0gypGaoTmmUBvvCwuwDvSqdD2s39WBabZ9WXrR6ULU5Gjy6Cm010EJlElE_f8Zk9VizkoHoxWwPBQld4ql-97rhhQkz7BxqUsonsZIc1Hi"/>
      <div class="absolute inset-0 bg-gradient-to-r from-transparent to-background/20"></div>
    </div>

    <!-- Right Side: The Technical Interface (Form) -->
    <div class="w-full md:w-[55%] lg:w-1/2 min-h-screen flex items-center justify-center p-6 sm:p-12 lg:p-24 relative overflow-hidden">
      <div class="absolute top-[-10%] right-[-10%] w-96 h-96 bg-primary-container/10 rounded-full blur-3xl pointer-events-none"></div>
      
      <div class="w-full max-w-md relative z-10 space-y-10">
        <!-- Header Section -->
        <div class="space-y-3">
          <h1 class="font-headline text-4xl md:text-5xl font-extrabold tracking-tight text-primary">
            {{ isSignUp ? 'Join Saapion' : 'Welcome to Saapion' }}
          </h1>
          <p class="text-on-surface-variant font-body text-base">
            {{ isSignUp ? 'Start your culinary journey today.' : 'The digital inventory for your authentic South Indian kitchen.' }}
          </p>
        </div>

        <div class="space-y-8">
          <!-- Google Auth -->
          <button @click="handleGoogleLogin" class="w-full flex items-center justify-center gap-3 bg-surface-container-lowest text-on-surface py-3.5 px-6 rounded-full shadow-[0_4px_12px_rgba(27,28,23,0.03)] ring-1 ring-outline-variant/15 hover:bg-surface-container-low transition-all duration-200 active:scale-[0.98]">
            <svg class="w-5 h-5" fill="none" viewbox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
              <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"></path>
              <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"></path>
              <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"></path>
              <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"></path>
            </svg>
            <span class="font-label font-semibold tracking-wide">Continue with Google</span>
          </button>

          <div class="flex items-center justify-center">
            <span class="text-sm font-label text-on-surface-variant/70 uppercase tracking-[0.1em]">or use email</span>
          </div>

          <!-- Email Form -->
          <form class="space-y-5" @submit.prevent="handleAuth">
            <div class="space-y-4">
              <!-- Name (Only Sign Up) -->
              <div v-if="isSignUp" class="group">
                <div class="bg-surface-container-low group-focus-within:bg-surface-container transition-colors duration-300 rounded-xl px-5 py-3 relative">
                  <label class="font-label text-[10px] font-bold text-on-surface-variant uppercase tracking-widest block mb-1" for="name">
                    Full Name
                  </label>
                  <div class="flex items-center gap-3">
                    <span class="material-symbols-outlined text-on-surface-variant/60 text-[20px]">person</span>
                    <input v-model="name" class="w-full bg-transparent border-none p-0 focus:ring-0 text-on-surface placeholder-on-surface-variant/40 font-body outline-none" id="name" placeholder="Ashwin Kumar" required type="text"/>
                  </div>
                </div>
              </div>

              <!-- Email -->
              <div class="group">
                <div class="bg-surface-container-low group-focus-within:bg-surface-container transition-colors duration-300 rounded-xl px-5 py-3 relative">
                  <label class="font-label text-[10px] font-bold text-on-surface-variant uppercase tracking-widest block mb-1" for="email">
                    Email Address
                  </label>
                  <div class="flex items-center gap-3">
                    <span class="material-symbols-outlined text-on-surface-variant/60 text-[20px]">mail</span>
                    <input v-model="email" class="w-full bg-transparent border-none p-0 focus:ring-0 text-on-surface placeholder-on-surface-variant/40 font-body outline-none" id="email" placeholder="chef@saapion.com" required type="email"/>
                  </div>
                </div>
              </div>

              <!-- Password -->
              <div class="group">
                <div class="bg-surface-container-low group-focus-within:bg-surface-container transition-colors duration-300 rounded-xl px-5 py-3 relative">
                  <label class="font-label text-[10px] font-bold text-on-surface-variant uppercase tracking-widest block mb-1" for="password">
                    Password
                  </label>
                  <div class="flex items-center gap-3">
                    <span class="material-symbols-outlined text-on-surface-variant/60 text-[20px]">lock</span>
                    <input v-model="password" :type="showPassword ? 'text' : 'password'" class="w-full bg-transparent border-none p-0 focus:ring-0 text-on-surface placeholder-on-surface-variant/40 font-body outline-none" id="password" placeholder="••••••••" required/>
                    <button @click="showPassword = !showPassword" type="button" class="text-on-surface-variant/60 hover:text-primary transition-colors focus:outline-none">
                      <span class="material-symbols-outlined text-[20px]">{{ showPassword ? 'visibility' : 'visibility_off' }}</span>
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <div v-if="!isSignUp" class="flex items-center justify-end">
              <a class="text-sm font-label font-semibold text-secondary hover:text-primary transition-colors" href="#">
                Forgot recipe?
              </a>
            </div>

            <!-- Submit Button -->
            <button :disabled="loading" class="w-full bg-gradient-to-br from-primary to-primary-container text-on-primary font-label font-bold tracking-wide py-4 rounded-full shadow-[0_8px_24px_rgba(126,87,0,0.2)] hover:shadow-[0_12px_32px_rgba(126,87,0,0.3)] active:scale-[0.98] transition-all duration-300 flex items-center justify-center gap-2 mt-4" type="submit">
              <span>{{ loading ? 'Processing...' : (isSignUp ? 'Create Account' : 'Sign In') }}</span>
              <span v-if="!loading" class="material-symbols-outlined text-[18px]">arrow_forward</span>
            </button>
          </form>

          <!-- Feedback Messages -->
          <p v-if="errorMsg" class="text-sm text-error font-semibold text-center mt-4">{{ errorMsg }}</p>
          <p v-if="successMsg" class="text-sm text-secondary font-semibold text-center mt-4">{{ successMsg }}</p>
        </div>

        <!-- Footer Toggle -->
        <div class="text-center pt-8">
          <p class="text-on-surface-variant font-body text-sm">
            {{ isSignUp ? 'Already have an account?' : 'New to the kitchen?' }}
            <button @click="isSignUp = !isSignUp" class="font-label font-bold text-primary hover:text-primary-container transition-colors ml-1 underline decoration-primary/30 underline-offset-4">
              {{ isSignUp ? 'Sign in instead' : 'Start your journey' }}
            </button>
          </p>
        </div>
      </div>
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
const showPassword = ref(false)
const errorMsg = ref('')
const successMsg = ref('')
const loading = ref(false)

const handleAuth = async () => {
  errorMsg.value = ''
  successMsg.value = ''
  loading.value = true
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
      }, 1500)
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
  } finally {
    loading.value = false
  }
}

const handleGoogleLogin = async () => {
  errorMsg.value = ''
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

<style scoped>
/* Ensure Google Material Symbols are loaded */
@import url('https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200');
</style>