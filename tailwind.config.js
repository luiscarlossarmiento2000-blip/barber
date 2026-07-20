/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        'barber-dark': '#0f0f1a',
        'barber-card': '#16213e',
        'barber-accent': '#e94560',
        'barber-green': '#42b883',
        'barber-blue': '#3498db',
        'barber-gold': '#f39c12',
      },
      fontFamily: {
        'display': ['Playfair Display', 'serif'],
        'body': ['Inter', 'sans-serif'],
      },
    },
  },
  plugins: [],
}