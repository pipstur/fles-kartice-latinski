export type Direction = 'sr_lat' | 'lat_sr'
export type Algorithm = 'spaced' | 'random' | 'sequential'
export type Grade = 0 | 1 | 2 | 3 // ponovo, teško, dobro, lako

export interface Deck {
  id: string
  slug: string
  title: string
  description: string
  theme: string
  icon: string
  has_symbols: boolean
  sort_order: number
}

export interface Card {
  id: string
  deck_id: string
  latin: string
  serbian: string
  note: string | null
  example: string | null
  symbol: string | null
  position: number
}

export interface GrammarItem {
  id: string
  sentence: string // "Puer ___ videt."
  answer: string
  lemma: string
  gloss: string | null
  grammar_case: 'nom' | 'gen' | 'dat' | 'acc' | 'abl' | 'voc'
  number: 'sg' | 'pl'
  translation: string | null
  forms: string[]
}

export type Tense = 'praes' | 'impf' | 'fut' | 'perf'

export interface Verb {
  id: string
  lemma: string
  gloss: string
  infinitive: string
  conj: string
  forms: Record<Tense, string[]> // 6 oblika po vremenu: 1.-3. lice jednine, pa množine
}

export interface Progress {
  card_id: string
  direction: Direction
  ease: number
  interval_days: number
  repetitions: number
  lapses: number
  due_at: string
}

export interface Settings {
  algorithm: Algorithm
  daily_goal: number
  direction: Direction | 'both'
  sound: boolean
}

export interface Stats {
  xp: number
  streak: number
  best_streak: number
  last_study_day: string | null
}

export const DEFAULT_SETTINGS: Settings = {
  algorithm: 'spaced',
  daily_goal: 20,
  direction: 'both',
  sound: true,
}

export const DEFAULT_STATS: Stats = { xp: 0, streak: 0, best_streak: 0, last_study_day: null }
