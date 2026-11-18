import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'
import { VitePWA } from 'vite-plugin-pwa'

// Repo je na https://pipstur.github.io/fles-kartice-latinski/ pa je base ime repoa.
export default defineConfig({
  base: '/fles-kartice-latinski/',
  plugins: [
    react(),
    VitePWA({
      registerType: 'autoUpdate',
      includeAssets: ['favicon.svg', 'apple-touch-icon.png'],
      manifest: {
        name: 'Lapis',
        short_name: 'Lapis',
        description: 'Učenje latinskog pomoću kartica',
        lang: 'sr-Latn',
        theme_color: '#58a700',
        background_color: '#f7f7f2',
        display: 'standalone',
        start_url: '/fles-kartice-latinski/',
        scope: '/fles-kartice-latinski/',
        icons: [
          { src: 'pwa-192.png', sizes: '192x192', type: 'image/png' },
          { src: 'pwa-512.png', sizes: '512x512', type: 'image/png' },
          { src: 'pwa-512.png', sizes: '512x512', type: 'image/png', purpose: 'maskable' },
        ],
      },
    }),
  ],
})
