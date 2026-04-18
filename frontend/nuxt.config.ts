export default defineNuxtConfig({
  app: {
    head: {
      link: [
        { rel: 'preconnect', href: 'https://fonts.googleapis.com' },
        { rel: 'preconnect', href: 'https://fonts.gstatic.com', crossorigin: '' },
        { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&family=Plus+Jakarta+Sans:ital,wght@0,400;0,700;0,800;1,400&display=swap' }
      ]
    }
  },
  devtools: { enabled: true },
  css: ['~/assets/css/main.css'],
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
  runtimeConfig: {
    public: {
      supabaseUrl: process.env.SUPABASE_URL,
      supabaseKey: process.env.SUPABASE_KEY,
      apiBase: (process.env.NUXT_PUBLIC_API_BASE || 'http://localhost:8000').replace(/\/$/, '')
    }
  },
  nitro: {
    preset: 'node-server',
    serveStatic: true
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