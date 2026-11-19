import type { Card } from './types'
import { shuffle } from './srs'

// 3 zvezdice bez greške, 2 do dve greške, inače 1.
export function starsFor(mistakes: number): number {
  return mistakes === 0 ? 3 : mistakes <= 2 ? 2 : 1
}

const tokens = (s: string) => s.toLowerCase().split(/[^\p{L}]+/u).filter((t) => t.length >= 3)

// 4 ponuđena odgovora: tačan i tri pogrešna. Pogrešni ne smeju biti sinonimi tačnog
// (kartice koje dele reč u prevodu, npr. „živa“, ne dolaze zajedno).
export function pickOptions(answer: string, pool: Card[]): string[] {
  const known = pool.find((c) => c.latin === answer)
  const answerTokens = new Set(known ? tokens(known.serbian) : [])
  const candidates = shuffle(
    pool.filter((c) => c.latin !== answer && !tokens(c.serbian).some((t) => answerTokens.has(t))),
  )
  const wrong: string[] = []
  for (const c of candidates) {
    if (!wrong.includes(c.latin)) wrong.push(c.latin)
    if (wrong.length === 3) break
  }
  return shuffle([answer, ...wrong])
}

export const DEFAULT_COLORS = ['#3b82c4', '#5bc0be', '#9ccc65', '#e8c547', '#f08a24', '#c0392b', '#8e44ad']

// Boja tečnosti posle `completed` tačnih koraka od `total` (0 = tek ugašeno).
export function liquidColor(colors: string[], completed: number, total: number): string {
  if (completed <= 0) return '#555555'
  const palette = colors.length ? colors : DEFAULT_COLORS
  if (total <= 1 || palette.length === 1) return palette[0]
  const pos = ((completed - 1) / (total - 1)) * (palette.length - 1)
  return palette[Math.min(palette.length - 1, Math.round(pos))]
}
