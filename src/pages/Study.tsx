import { useCallback, useEffect, useRef, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { AnimatePresence, motion } from 'framer-motion'
import confetti from 'canvas-confetti'
import { Flashcard } from '../components/Flashcard'
import { useAuth } from '../auth'
import { addStudy, loadCards, loadDecks, loadProgress, loadSettings, saveProgress } from '../lib/api'
import { buildQueue, newProgress, requeue, schedule } from '../lib/srs'
import type { Item } from '../lib/srs'
import { play } from '../lib/sound'
import type { Card, Deck, Grade, Progress, Settings, Stats } from '../lib/types'

const XP: Record<Grade, number> = { 0: 0, 1: 5, 2: 10, 3: 15 }
const GRADES: { grade: Grade; label: string; cls: string }[] = [
  { grade: 0, label: 'Ponovo', cls: 'again' },
  { grade: 1, label: 'Teško', cls: 'hard' },
  { grade: 2, label: 'Dobro', cls: 'good' },
  { grade: 3, label: 'Lako', cls: 'easy' },
]

export function Study() {
  const { slug } = useParams()
  const { session } = useAuth()
  const userId = session!.user.id

  const [deck, setDeck] = useState<Deck | null>(null)
  const [cards, setCards] = useState<Card[]>([])
  const [progress, setProgress] = useState<Progress[]>([])
  const [settings, setSettings] = useState<Settings | null>(null)
  const [error, setError] = useState<string | null>(null)

  const [queue, setQueue] = useState<Item[]>([])
  const [total, setTotal] = useState(0)
  const [answered, setAnswered] = useState(0)
  const [xp, setXp] = useState(0)
  const [flipped, setFlipped] = useState(false) // koja strana je trenutno okrenuta
  const [revealed, setRevealed] = useState(false) // da li je odgovor bar jednom viđen
  const [stats, setStats] = useState<Stats | null>(null)
  const saved = useRef(false)

  const start = useCallback((c: Card[], p: Progress[], s: Settings) => {
    const q = buildQueue(c, p, s)
    setQueue(q)
    setTotal(q.length)
    setAnswered(0)
    setXp(0)
    setFlipped(false)
    setRevealed(false)
    setStats(null)
    saved.current = false
  }, [])

  useEffect(() => {
    loadDecks()
      .then(async (decks) => {
        const d = decks.find((x) => x.slug === slug)
        if (!d) throw new Error('Dek ne postoji.')
        const c = await loadCards(d.id)
        const [p, s] = await Promise.all([loadProgress(c.map((x) => x.id)), loadSettings(userId)])
        setDeck(d)
        setCards(c)
        setProgress(p)
        setSettings(s)
        start(c, p, s)
      })
      .catch((e: Error) => setError(e.message))
  }, [slug, userId, start])

  const current = queue[0]
  const finished = settings !== null && deck !== null && queue.length === 0

  const grade = useCallback(
    (g: Grade) => {
      if (!current || !settings) return
      const next = schedule(current.progress ?? newProgress(current.card, current.direction), g)
      saveProgress(userId, next).catch((e: Error) => setError(e.message))
      play(g === 0 ? 'bad' : 'good', settings.sound)
      setXp((x) => x + XP[g])
      setAnswered((n) => n + 1)
      setFlipped(false)
      setRevealed(false)
      setQueue((q) => {
        const [head, ...rest] = q
        return g === 0 ? requeue(rest, { ...head, progress: next }) : rest
      })
    },
    [current, settings, userId],
  )

  // Kartica se može okretati koliko god puta hoćeš.
  const flip = useCallback(() => {
    setFlipped((f) => !f)
    setRevealed(true)
  }, [])

  // Tastatura: razmak/Enter okreće, 1-4 ocenjuje (tek kad je odgovor viđen).
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (!current) return
      if (e.key === ' ' || e.key === 'Enter') {
        e.preventDefault()
        flip()
      } else if (revealed && ['1', '2', '3', '4'].includes(e.key)) grade((Number(e.key) - 1) as Grade)
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [current, revealed, grade, flip])

  // Kraj sesije: upiši XP i seriju, pa konfete.
  useEffect(() => {
    if (!finished || saved.current || answered === 0) return
    saved.current = true
    play('done', settings!.sound)
    confetti({ particleCount: 140, spread: 80, origin: { y: 0.6 } })
    addStudy(userId, xp, answered).then(setStats).catch((e: Error) => setError(e.message))
  }, [finished, answered, xp, userId, settings])

  if (error) {
    return (
      <main className="page">
        <p className="msg error">{error}</p>
        <Link to="/" className="btn">Nazad</Link>
      </main>
    )
  }
  if (!deck || !settings) return <main className="page"><p className="muted">Učitavanje…</p></main>

  const pct = total ? Math.min(100, (answered / (answered + queue.length || 1)) * 100) : 0

  return (
    <div className="study" data-theme={deck.theme}>
      <div className="study-top">
        <Link to="/" className="icon-btn" aria-label="Zatvori">✕</Link>
        <div className="progress"><motion.div animate={{ width: `${pct}%` }} /></div>
        <span className="pill">⭐ {xp}</span>
      </div>

      {current ? (
        <>
          <div className="study-stage">
            <AnimatePresence mode="wait">
              <motion.div
                key={`${current.card.id}:${current.direction}:${answered}`}
                initial={{ opacity: 0, x: 60 }}
                animate={{ opacity: 1, x: 0 }}
                exit={{ opacity: 0, x: -60 }}
                transition={{ duration: 0.18 }}
              >
                <Flashcard item={current} flipped={flipped} onFlip={flip} />
              </motion.div>
            </AnimatePresence>
          </div>

          <div className="study-actions">
            {revealed ? (
              <div className="grades">
                {GRADES.map((g) => (
                  <button key={g.grade} className={`btn grade ${g.cls}`} onClick={() => grade(g.grade)}>
                    {g.label}
                    <kbd>{g.grade + 1}</kbd>
                  </button>
                ))}
              </div>
            ) : (
              <button className="btn primary wide" onClick={flip}>Okreni</button>
            )}
          </div>
        </>
      ) : (
        <motion.div className="summary" initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }}>
          {answered === 0 ? (
            <>
              <div className="big">🎉</div>
              <h2>Sve je ponovljeno!</h2>
              <p className="muted">Za sada nema kartica za ovaj režim. Možeš da vežbaš nasumično.</p>
              <button className="btn primary wide" onClick={() => start(cards, progress, { ...settings, algorithm: 'random' })}>
                Vežbaj nasumično
              </button>
            </>
          ) : (
            <>
              <div className="big">🏆</div>
              <h2>Sesija završena!</h2>
              <div className="summary-stats">
                <div><b>{answered}</b><span>odgovora</span></div>
                <div><b>+{xp}</b><span>poena</span></div>
                <div><b>{stats ? `🔥 ${stats.streak}` : '…'}</b><span>dana zaredom</span></div>
              </div>
              <button className="btn primary wide" onClick={() => {
                loadProgress(cards.map((c) => c.id)).then((p) => { setProgress(p); start(cards, p, settings) })
              }}>
                Još jedna sesija
              </button>
            </>
          )}
          <Link to="/" className="btn wide">Nazad na dekove</Link>
        </motion.div>
      )}
    </div>
  )
}
