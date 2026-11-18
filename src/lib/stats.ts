import type { Card, Direction, Progress } from './types'

// Prag zrelosti kartice: koliko dana je trenutni razmak do sledećeg ponavljanja.
export const KNOWN_DAYS = 7
export const MASTERED_DAYS = 21

export interface DeckSummary {
  total: number // kartica × smerova koji se uče
  fresh: number // još nevidene
  learning: number // razmak < 7 dana
  known: number // 7 do 20 dana
  mastered: number // 21+ dana
  due: number // za ponavljanje sada
}

// Računa po (kartica, smer), ali samo za smerove koje trenutno učiš.
export function summarize(cardIds: string[], progress: Progress[], dirs: Direction[]): DeckSummary {
  const ids = new Set(cardIds)
  const rows = progress.filter((p) => ids.has(p.card_id) && dirs.includes(p.direction))
  const now = Date.now()
  const s: DeckSummary = { total: cardIds.length * dirs.length, fresh: 0, learning: 0, known: 0, mastered: 0, due: 0 }
  for (const p of rows) {
    if (p.interval_days >= MASTERED_DAYS) s.mastered++
    else if (p.interval_days >= KNOWN_DAYS) s.known++
    else s.learning++
    if (new Date(p.due_at).getTime() <= now) s.due++
  }
  s.fresh = Math.max(0, s.total - rows.length)
  return s
}

export interface HardCard {
  card: Card
  direction: Direction
  lapses: number
}

// Kartice koje najčešće pogrešiš (po broju "Ponovo").
export function hardest(cards: Card[], progress: Progress[], limit = 10): HardCard[] {
  const byId = new Map(cards.map((c) => [c.id, c]))
  return progress
    .filter((p) => p.lapses > 0 && byId.has(p.card_id))
    .sort((a, b) => b.lapses - a.lapses)
    .slice(0, limit)
    .map((p) => ({ card: byId.get(p.card_id)!, direction: p.direction, lapses: p.lapses }))
}

const pad = (n: number) => String(n).padStart(2, '0')
const ymd = (d: Date) => `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`

export interface DayBar {
  day: string // YYYY-MM-DD
  label: string // d.m.
  answers: number
}

// Poslednjih `n` dana (najstariji prvi), dani bez aktivnosti imaju 0.
export function lastDays(activity: { day: string; answers: number }[], n = 14): DayBar[] {
  const byDay = new Map(activity.map((a) => [a.day, a.answers]))
  const out: DayBar[] = []
  for (let i = n - 1; i >= 0; i--) {
    const d = new Date()
    d.setDate(d.getDate() - i)
    const day = ymd(d)
    out.push({ day, label: `${d.getDate()}.${d.getMonth() + 1}.`, answers: byDay.get(day) ?? 0 })
  }
  return out
}
