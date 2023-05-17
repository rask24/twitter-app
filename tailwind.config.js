/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./app/views/**/*.{html,erb}'],
  theme: {
    extend: {
      colors: {
        twitter: {
          primary: '#08a0e9',
          light: '#E8F5FD',
          dark: '#0084B4',
        },
      },
    },
  },
  plugins: [],
}
