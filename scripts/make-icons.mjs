// Pravi PNG ikonice za PWA iz public/favicon.svg. Pokretanje: npm run icons
import { fileURLToPath } from 'node:url'
import sharp from 'sharp'

const path = (name) => fileURLToPath(new URL(`../public/${name}`, import.meta.url))

for (const [name, size] of [
  ['pwa-192.png', 192],
  ['pwa-512.png', 512],
  ['apple-touch-icon.png', 180],
]) {
  await sharp(path('favicon.svg'), { density: 384 }).resize(size, size).png().toFile(path(name))
  console.log('napravljeno', name)
}
