import { supabase } from './supabase'
import { today, yesterday } from './srs'
import { DEFAULT_SETTINGS, DEFAULT_STATS } from './types'
import type {
  Activity,
  Card,
  Deck,
  GameKind,
  GrammarItem,
  Progress,
  Recipe,
  RecipeProgress,
  Score,
  Settings,
  Stats,
  Verb,
} from './types'

function check<T>(res: { data: T | null; error: { message: string } | null }): T | null {
  if (res.error) throw new Error(res.error.message)
  return res.data
}

export async function loadDecks(): Promise<Deck[]> {
  return check(await supabase.from('lat_decks').select('*').order('sort_order')) ?? []
}

export async function loadCards(deckId?: string): Promise<Card[]> {
  let q = supabase.from('lat_cards').select('*')
  if (deckId) q = q.eq('deck_id', deckId)
  return check(await q) ?? []
}

export async function loadProgress(cardIds: string[]): Promise<Progress[]> {
  if (cardIds.length === 0) return []
  return check(await supabase.from('lat_progress').select('*').in('card_id', cardIds)) ?? []
}

export async function loadGrammar(): Promise<GrammarItem[]> {
  return check(await supabase.from('lat_grammar_items').select('*')) ?? []
}

export async function loadVerbs(): Promise<Verb[]> {
  return check(await supabase.from('lat_verbs').select('*')) ?? []
}

export async function isAdmin(userId: string): Promise<boolean> {
  const row = check(await supabase.from('lat_admins').select('user_id').eq('user_id', userId).maybeSingle())
  return Boolean(row)
}

export type CardInput = Pick<Card, 'latin' | 'serbian' | 'note' | 'example' | 'symbol'>

export async function upsertCards(deckId: string, startPosition: number, cards: CardInput[]) {
  const rows = cards.map((c, i) => ({ ...c, deck_id: deckId, position: startPosition + i }))
  check(await supabase.from('lat_cards').upsert(rows, { onConflict: 'deck_id,latin' }))
}

export async function updateCard(id: string, patch: CardInput) {
  check(await supabase.from('lat_cards').update(patch).eq('id', id))
}

export async function deleteCard(id: string) {
  check(await supabase.from('lat_cards').delete().eq('id', id))
}

export async function createDeck(deck: Omit<Deck, 'id'>) {
  check(await supabase.from('lat_decks').insert(deck))
}

export async function loadAllProgress(): Promise<Progress[]> {
  return check(await supabase.from('lat_progress').select('*')) ?? []
}

export async function saveProgress(userId: string, p: Progress) {
  check(await supabase.from('lat_progress').upsert({ ...p, user_id: userId, last_seen_at: new Date().toISOString() }))
}

export async function loadSettings(userId: string): Promise<Settings> {
  const row = check(await supabase.from('lat_user_settings').select('*').eq('user_id', userId).maybeSingle())
  return row ? { ...DEFAULT_SETTINGS, ...(row as Partial<Settings>) } : DEFAULT_SETTINGS
}

export async function saveSettings(userId: string, s: Settings) {
  check(await supabase.from('lat_user_settings').upsert({ user_id: userId, ...s, updated_at: new Date().toISOString() }))
}

export async function loadStats(userId: string): Promise<Stats> {
  const row = check(await supabase.from('lat_stats').select('*').eq('user_id', userId).maybeSingle())
  return row ?? DEFAULT_STATS
}

export async function loadRecipes(): Promise<Recipe[]> {
  const rows = check(await supabase.from('lat_recipes').select('*').order('sort_order')) ?? []
  return rows as Recipe[]
}

// Napredak u laboratoriji je dodatak: bez tabele laboratorija radi, samo bez pamćenja zvezdica.
export async function loadRecipeProgress(userId: string): Promise<RecipeProgress[]> {
  try {
    return check(await supabase.from('lat_recipe_progress').select('recipe_slug,stars,plays').eq('user_id', userId)) ?? []
  } catch {
    return []
  }
}

export async function saveRecipeResult(userId: string, slug: string, stars: number): Promise<{ best: number; improved: boolean }> {
  try {
    const row = check(
      await supabase.from('lat_recipe_progress').select('stars,plays').eq('user_id', userId).eq('recipe_slug', slug).maybeSingle(),
    ) as { stars: number; plays: number } | null
    const prev = row?.stars ?? 0
    const best = Math.max(prev, stars)
    check(
      await supabase.from('lat_recipe_progress').upsert({
        user_id: userId,
        recipe_slug: slug,
        stars: best,
        plays: (row?.plays ?? 0) + 1,
        updated_at: new Date().toISOString(),
      }),
    )
    return { best, improved: stars > prev }
  } catch {
    return { best: stars, improved: false }
  }
}

// Rekordi su dodatak: ako tabela još ne postoji, igre rade, samo bez čuvanja rezultata.
export async function loadScores(userId: string): Promise<Score[]> {
  try {
    return check(await supabase.from('lat_scores').select('game,scope,best,plays').eq('user_id', userId)) ?? []
  } catch {
    return []
  }
}

export async function saveScore(
  userId: string,
  game: GameKind,
  scope: string,
  score: number,
): Promise<{ best: number; record: boolean }> {
  try {
    const row = check(
      await supabase.from('lat_scores').select('best,plays').eq('user_id', userId).eq('game', game).eq('scope', scope).maybeSingle(),
    ) as { best: number; plays: number } | null
    const prev = row?.best ?? 0
    const best = Math.max(prev, score)
    check(
      await supabase.from('lat_scores').upsert({
        user_id: userId,
        game,
        scope,
        best,
        plays: (row?.plays ?? 0) + 1,
        updated_at: new Date().toISOString(),
      }),
    )
    return { best, record: score > prev }
  } catch {
    return { best: score, record: false }
  }
}

export async function loadActivity(userId: string): Promise<Activity[]> {
  return check(await supabase.from('lat_activity').select('day,answers,xp').eq('user_id', userId).order('day')) ?? []
}

// Dodaje XP i računa seriju (streak) po lokalnom datumu; beleži i broj odgovora za statistiku.
export async function addStudy(userId: string, xp: number, answers = 0): Promise<Stats> {
  const cur = await loadStats(userId)
  const day = today()
  let streak = cur.streak
  if (cur.last_study_day !== day) streak = cur.last_study_day === yesterday() ? streak + 1 : 1
  const next: Stats = {
    xp: cur.xp + xp,
    streak,
    best_streak: Math.max(cur.best_streak, streak),
    last_study_day: day,
  }
  check(await supabase.from('lat_stats').upsert({ user_id: userId, ...next }))

  // Aktivnost je samo za statistiku: ako tabela još ne postoji, učenje ne sme da pukne.
  try {
    const row = check(await supabase.from('lat_activity').select('answers,xp').eq('user_id', userId).eq('day', day).maybeSingle()) as
      | { answers: number; xp: number }
      | null
    check(
      await supabase.from('lat_activity').upsert({
        user_id: userId,
        day,
        answers: (row?.answers ?? 0) + answers,
        xp: (row?.xp ?? 0) + xp,
      }),
    )
  } catch {
    // ignorisano
  }
  return next
}
