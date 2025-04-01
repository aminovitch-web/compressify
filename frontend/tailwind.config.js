/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",  // Analyse tous les fichiers JS/TS/JSX/TSX dans src
  ],
  theme: {
    extend: {
      // Ici vous pouvez étendre le thème par défaut
      colors: {
        // Exemple de personnalisation des couleurs
        'primary': '#3B82F6',
        'secondary': '#10B981',
      },
      fontFamily: {
        // Exemple de personnalisation des polices
        'sans': ['Inter', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [],
}

