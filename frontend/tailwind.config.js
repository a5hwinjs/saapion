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
        sans: ['Manrope', 'sans-serif'],
        display: ['Plus Jakarta Sans', 'sans-serif'],
      },
      colors: {
        primary: '#7e5700',
        'on-primary': '#ffffff',
        'primary-container': '#ffb300',
        'on-primary-container': '#6b4900',
        secondary: '#3a6843',
        'on-secondary': '#ffffff',
        'secondary-container': '#b9ecbd',
        'on-secondary-container': '#3e6d47',
        tertiary: '#b22c01',
        'on-tertiary': '#ffffff',
        'tertiary-container': '#ffad97',
        'on-tertiary-container': '#972400',
        error: '#ba1a1a',
        'on-error': '#ffffff',
        'error-container': '#ffdad6',
        'on-error-container': '#93000a',
        background: '#fbfaf1',
        'on-background': '#1b1c17',
        surface: '#fbfaf1',
        'on-surface': '#1b1c17',
        'surface-variant': '#e4e3da',
        'on-surface-variant': '#514532',
        outline: '#847560',
        'outline-variant': '#d6c4ac',
        'surface-container-lowest': '#ffffff',
        'surface-container-low': '#f5f4eb',
        'surface-container': '#efeee5',
        'surface-container-high': '#e9e8e0',
        'surface-container-highest': '#e4e3da',
      },
      boxShadow: {
        'diffuse': '0 8px 24px rgba(27, 28, 23, 0.06)',
      },
      borderRadius: {
        'xl': '1rem',
        '2xl': '1.5rem',
      }
    },
  },
  plugins: [],
}