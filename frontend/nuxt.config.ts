export default defineNuxtConfig({
  devtools: { enabled: true },
  modules: [
    '@nuxtjs/tailwindcss',
    '@vite-pwa/nuxt',
    '@nuxtjs/supabase'
  ],
  supabase: {
    url: process.env.SUPABASE_URL,
    key: process.env.SUPABASE_KEY,
    redirect: false
  },
  pwa: {
    manifest: {
      name: 'Saapion',
      short_name: 'Saapion',
      description: 'Personalized Indian Meal Planner',
      theme_color: '#ffffff',
      icons: []
    },
    workbox: {
      navigateFallback: '/'
    },
    devOptions: {
      enabled: true,
      type: 'module'
    }
  },
  compatibilityDate: '2024-04-03'
})