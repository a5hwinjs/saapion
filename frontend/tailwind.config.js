/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./components/**/*.{js,vue,ts}",
    "./layouts/**/*.vue",
    "./pages/**/*.vue",
    "./plugins/**/*.{js,ts}",
    "./app.vue",
    "./error.vue"
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Nunito', 'sans-serif'], 
      },
      colors: {
        'pastel-lavender': '#C1C9FC',
        'pastel-mint': '#DDEFE9',
        'accent-yellow': '#FDD365',
        'accent-teal': '#48C3A6',
        'accent-midnight': '#232B4E',
        'alert-red': '#FF6B6B',
      },
      boxShadow: {
        'soft': '0 10px 40px -10px rgba(0,0,0,0.08)',
      },
      borderRadius: {
        '4xl': '32px',
      }
    },
  },
  plugins: [],
}