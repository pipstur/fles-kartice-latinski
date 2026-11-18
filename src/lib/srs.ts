import type { Card, Direction, Grade, Progress, Settings } from './types'

const DAY = 24 * 60 * 60 * 1000

export interface Item {
  card: Card
  direction: Direction
  progress: Progress | null // null = nova kartica
}

export function newProgress(card: Card, direction: Direction): Progress {
  return {
    card_id: card.id,
    direction,
    ease: 2.5,
    interval_days: 0,
    repetitions: 0,
    lapses: 0,
    due_at: new Date().toISOString(),
  }
}

// Pojednostavljen SM-2: ocene 0 ponovo, 1 teško, 2 dobro, 3 lako.
export function schedule(prev: Progress, grade: Grade): Progress {
  let { ease, interval_days: interval, repetitions, lapses } = prev
  let due: number

  if (grade === 0) {
    repetitions = 0
    lapses += 1
    interval = 0
    ease = Math.max(1.3, ease - 0.2)
    due = Date.now() + 10 * 60 * 1000 // ponovo za 10 minuta
  } else {
    repetitions += 1
    if (repetitions === 1) interval = grade === 3 ? 4 : 1
    else if (repetitions === 2) interval = grade === 3 ? 7 : grade === 1 ? 3 : 6
    else interval = Math.max(1, Math.round(interval * ease * (grade === 1 ? 0.8 : grade === 3 ? 1.3 : 1)))
    ease = Math.max(1.3, ease + (grade === 1 ? -0.15 : grade === 3 ? 0.15 : 0))
    due = Date.now() + interval * DAY
  }

  return { ...prev, ease, interval_days: interval, repetitions, lapses, due_at: new Date(due).toISOString() }
}

export function shuffle<T>(arr: T[]): T[] {
  const a = [...arr]
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1))
    ;[a[i], a[j]] = [a[j], a[i]]
  }
  return a
}

// Da li se preostali pojmovi mogu poređati bez ponavljanja zaredom, ako prvi ne sme biti `notFirst`.
function canArrange(items: Item[], notFirst: string): boolean {
  const n = items.length
  if (n === 0) return true
  const counts = new Map<string, number>()
  for (const it of items) counts.set(it.card.id, (counts.get(it.card.id) ?? 0) + 1)
  let maxId = ''
  let max = 0
  for (const [id, c] of counts) if (c > max) [maxId, max] = [id, c]
  if (max > Math.ceil(n / 2)) return false
  // kad je n neparno i jedan pojam zauzima svako drugo mesto, on mora biti prvi
  return !(n % 2 === 1 && max === (n + 1) / 2 && maxId === notFirst)
}

// Preuređuje red tako da isti pojam (u bilo kom smeru) ne dođe dva puta zaredom, gde god je to moguće.
// Zadržava prvobitni redosled koliko god može: uvek uzima najraniju stavku koja ne kvari ostatak.
function spread(items: Item[]): Item[] {
  const rest = [...items]
  const out: Item[] = []
  while (rest.length > 0) {
    const last = out[out.length - 1]?.card.id
    let pick = rest.findIndex(
      (x, i) => x.card.id !== last && canArrange([...rest.slice(0, i), ...rest.slice(i + 1)], x.card.id),
    )
    if (pick === -1) pick = rest.findIndex((x) => x.card.id !== last)
    if (pick === -1) pick = 0
    out.push(rest.splice(pick, 1)[0])
  }
  return out
}

// Vraća pogrešno odgovorenu karticu u red tek posle nekoliko drugih, a ne odmah,
// i nikad pored istog pojma u drugom smeru (osim kad nema druge mogućnosti).
export function requeue(rest: Item[], item: Item, gap = 3): Item[] {
  const start = Math.min(gap, rest.length)
  const order = [
    ...Array.from({ length: rest.length - start + 1 }, (_, k) => start + k), // prvo dalje od `gap`
    ...Array.from({ length: start }, (_, k) => start - 1 - k), // pa bliže
  ]
  const fits = (i: number) => rest[i - 1]?.card.id !== item.card.id && rest[i]?.card.id !== item.card.id
  const at = order.find(fits) ?? rest.length
  return [...rest.slice(0, at), item, ...rest.slice(at)]
}

// Pravi red za jednu sesiju prema podešenom algoritmu.
export function buildQueue(cards: Card[], progress: Progress[], settings: Settings): Item[] {
  return spread(pickQueue(cards, progress, settings))
}

function pickQueue(cards: Card[], progress: Progress[], settings: Settings): Item[] {
  const dirs: Direction[] = settings.direction === 'both' ? ['sr_lat', 'lat_sr'] : [settings.direction]
  const byKey = new Map(progress.map((p) => [`${p.card_id}:${p.direction}`, p]))
  const ordered = [...cards].sort((a, b) => a.position - b.position)

  const all: Item[] = ordered.flatMap((card) =>
    dirs.map((direction) => ({ card, direction, progress: byKey.get(`${card.id}:${direction}`) ?? null })),
  )
  const limit = settings.daily_goal

  if (settings.algorithm === 'random') return shuffle(all).slice(0, limit)

  if (settings.algorithm === 'sequential') {
    const unseen = all.filter((i) => !i.progress)
    const seen = all.filter((i) => i.progress)
    return [...unseen, ...seen].slice(0, limit)
  }

  const now = Date.now()
  const due = all
    .filter((i) => i.progress && new Date(i.progress.due_at).getTime() <= now)
    .sort((a, b) => a.progress!.due_at.localeCompare(b.progress!.due_at))
  const fresh = all.filter((i) => !i.progress)
  return shuffle([...due, ...fresh].slice(0, limit))
}

export function dueCount(progress: Progress[]): number {
  const now = Date.now()
  return progress.filter((p) => new Date(p.due_at).getTime() <= now).length
}

export function today(): string {
  const d = new Date()
  const pad = (n: number) => String(n).padStart(2, '0')
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`
}

export function yesterday(): string {
  const d = new Date(Date.now() - DAY)
  const pad = (n: number) => String(n).padStart(2, '0')
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`
}
