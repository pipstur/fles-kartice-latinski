import type { Card } from './types'
import { shuffle } from './srs'

export type BlitzDir = 'sr_lat' | 'lat_sr'

export interface BlitzQuestion {
  card: Card
  dir: BlitzDir
  prompt: string
  options: string[] // 4 ponuđena odgovora, jedinstveni tekstovi
  answer: string
}

export const BLITZ_SECONDS = 60
export const POINTS_PER_ANSWER = 10
export const PAIRS = 6

// Množilac raste sa nizom tačnih odgovora: x1 (0-2), x2 (3-5), x3 (6-8), x4 (9-11), x5 (12+).
export function multiplier(combo: number): number {
  return Math.min(5, 1 + Math.floor(combo / 3))
}

export function makeQuestion(card: Card, pool: Card[]): BlitzQuestion {
  const dir: BlitzDir = Math.random() < 0.5 ? 'sr_lat' : 'lat_sr'
  const text = (c: Card) => (dir === 'sr_lat' ? c.latin : c.serbian)
  const answer = text(card)

  const options: string[] = []
  for (const c of shuffle(pool.filter((x) => x.id !== card.id))) {
    const t = text(c)
    if (t !== answer && !options.includes(t)) options.push(t)
    if (options.length === 3) break
  }
  return {
    card,
    dir,
    prompt: dir === 'sr_lat' ? card.serbian : card.latin,
    options: shuffle([answer, ...options]),
    answer,
  }
}

// Novi redosled kartica; prva ne sme biti ista kao poslednja iz prošlog kruga.
export function shuffledOrder(pool: Card[], avoidId?: string): Card[] {
  const order = shuffle(pool)
  if (avoidId && order.length > 1 && order[0].id === avoidId) order.push(order.shift()!)
  return order
}

// Bira kartice za tablu parova. Latinski i srpski tekstovi moraju biti jedinstveni, inače par nije jednoznačan.
export function pickPairs(pool: Card[], n = PAIRS): Card[] {
  const latin = new Set<string>()
  const serbian = new Set<string>()
  const out: Card[] = []
  for (const c of shuffle(pool)) {
    if (latin.has(c.latin) || serbian.has(c.serbian)) continue
    latin.add(c.latin)
    serbian.add(c.serbian)
    out.push(c)
    if (out.length === n) break
  }
  return out
}

// 100 po paru, bonus za brzinu (do 60 s), 50 kazne po grešci.
export function pairsScore(mistakes: number, seconds: number, n = PAIRS): number {
  return Math.max(0, n * 100 + Math.max(0, 60 - seconds) * 5 - mistakes * 50)
}

// Opseg igre: 'all' ili slugovi izabranih dekova spojeni zarezom (sortirani).
export function scopeOf(selected: string[], allSlugs: string[]): string {
  if (selected.length === allSlugs.length) return 'all'
  return [...selected].sort().join(',')
}

export function poolFor(scope: string, decks: { id: string; slug: string }[], cards: Card[]): Card[] {
  if (scope === 'all') return cards
  const ids = new Set(decks.filter((d) => scope.split(',').includes(d.slug)).map((d) => d.id))
  return cards.filter((c) => ids.has(c.deck_id))
}
