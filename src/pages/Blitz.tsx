import { useCallback, useEffect, useRef, useState } from 'react'
import { Link } from 'react-router-dom'
import { AnimatePresence, motion } from 'framer-motion'
import confetti from 'canvas-confetti'
import { GameSetup } from '../components/GameSetup'
import { useAuth } from '../auth'
import { addStudy, loadCards, loadDecks, loadScores, loadSettings, saveScore } from '../lib/api'
import { BLITZ_SECONDS, makeQuestion, multiplier, POINTS_PER_ANSWER, shuffledOrder } from '../lib/games'
import type { BlitzQuestion } from '../lib/games'
import { play } from '../lib/sound'
import type { Card, Deck, Score } from '../lib/types'

type Phase = 'setup' | 'playing' | 'done'

interface Result {
  best: number
  record: boolean
  streak: number | null
}

export function Blitz() {
  const { session } = useAuth()
  const userId = session!.user.id

  const [decks, setDecks] = useState<Deck[] | null>(null)
  const [cards, setCards] = useState<Card[]>([])
  const [scores, setScores] = useState<Score[]>([])
  const [sound, setSound] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const [phase, setPhase] = useState<Phase>('setup')
  const [scope, setScope] = useState('all')
  const [left, setLeft] = useState(BLITZ_SECONDS)
  const [q, setQ] = useState<BlitzQuestion | null>(null)
  const [picked, setPicked] = useState<string | null>(null)
  const [score, setScore] = useState(0)
  const [combo, setCombo] = useState(0)
  const [gain, setGain] = useState<{ id: number; text: string } | null>(null)
  const [result, setResult] = useState<Result | null>(null)
  const [final, setFinal] = useState({ score: 0, correct: 0, wrong: 0, bestCombo: 0 })

  // Brojači u ref-u da završetak runde uvek vidi tačne vrednosti.
  const stats = useRef({ score: 0, combo: 0, bestCombo: 0, correct: 0, wrong: 0 })
  const finished = useRef(false)
  const pool = useRef<Card[]>([])
  const order = useRef<Card[]>([])
  const idx = useRef(0)
  const lastId = useRef<string | undefined>(undefined)
  const endAt = useRef(0)
  const timeouts = useRef<number[]>([])

  useEffect(() => {
    Promise.all([loadDecks(), loadCards(), loadScores(userId), loadSettings(userId)])
      .then(([d, c, s, set]) => {
        setDecks(d)
        setCards(c)
        setScores(s)
        setSound(set.sound)
      })
      .catch((e: Error) => setError(e.message))
    const pending = timeouts.current
    return () => pending.forEach(clearTimeout)
  }, [userId])

  const nextQuestion = useCallback(() => {
    if (idx.current >= order.current.length) {
      order.current = shuffledOrder(pool.current, lastId.current)
      idx.current = 0
    }
    const card = order.current[idx.current++]
    lastId.current = card.id
    setQ(makeQuestion(card, pool.current))
    setPicked(null)
  }, [])

  const finish = useCallback(async () => {
    if (finished.current) return
    finished.current = true
    timeouts.current.forEach(clearTimeout)
    setPhase('done')
    setLeft(0)
    const s = stats.current
    setFinal({ score: s.score, correct: s.correct, wrong: s.wrong, bestCombo: s.bestCombo })
    play('done', sound)

    const answered = s.correct + s.wrong
    const [saved, st] = await Promise.all([
      saveScore(userId, 'blitz', scope, s.score),
      answered > 0 ? addStudy(userId, s.correct * 5, answered).catch(() => null) : Promise.resolve(null),
    ])
    if (saved.record && s.score > 0) confetti({ particleCount: 160, spread: 90, origin: { y: 0.6 } })
    setResult({ best: saved.best, record: saved.record && s.score > 0, streak: st ? st.streak : null })
    setScores((prev) => [
      ...prev.filter((x) => !(x.game === 'blitz' && x.scope === scope)),
      { game: 'blitz', scope, best: saved.best, plays: 0 },
    ])
  }, [sound, userId, scope])

  function start(chosen: string) {
    const deckId = decks?.find((d) => d.slug === chosen)?.id
    pool.current = chosen === 'all' ? cards : cards.filter((c) => c.deck_id === deckId)
    order.current = []
    idx.current = 0
    lastId.current = undefined
    stats.current = { score: 0, combo: 0, bestCombo: 0, correct: 0, wrong: 0 }
    finished.current = false
    setScope(chosen)
    setScore(0)
    setCombo(0)
    setGain(null)
    setResult(null)
    setLeft(BLITZ_SECONDS)
    endAt.current = Date.now() + BLITZ_SECONDS * 1000
    nextQuestion()
    setPhase('playing')
  }

  // Odbrojavanje
  useEffect(() => {
    if (phase !== 'playing') return
    const id = window.setInterval(() => {
      const l = Math.max(0, (endAt.current - Date.now()) / 1000)
      setLeft(l)
      if (l <= 0) {
        window.clearInterval(id)
        void finish()
      }
    }, 100)
    return () => window.clearInterval(id)
  }, [phase, finish])

  const choose = useCallback(
    (opt: string) => {
      if (phase !== 'playing' || !q || picked !== null || finished.current) return
      setPicked(opt)
      const s = stats.current
      const ok = opt === q.answer
      if (ok) {
        const mult = multiplier(s.combo)
        const points = POINTS_PER_ANSWER * mult
        s.combo += 1
        s.correct += 1
        s.score += points
        s.bestCombo = Math.max(s.bestCombo, s.combo)
        setScore(s.score)
        setCombo(s.combo)
        setGain({ id: Date.now(), text: `+${points}` })
        play('good', sound)
      } else {
        s.combo = 0
        s.wrong += 1
        setCombo(0)
        play('bad', sound)
      }
      const t = window.setTimeout(() => {
        if (!finished.current) nextQuestion()
      }, ok ? 350 : 900)
      timeouts.current.push(t)
    },
    [phase, q, picked, sound, nextQuestion],
  )

  // Tastatura: 1-4 bira odgovor.
  useEffect(() => {
    if (phase !== 'playing') return
    const onKey = (e: KeyboardEvent) => {
      const i = ['1', '2', '3', '4'].indexOf(e.key)
      if (i !== -1 && q?.options[i]) choose(q.options[i])
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [phase, q, choose])

  if (error) {
    return (
      <main className="page">
        <p className="msg error">{error}</p>
        <Link to="/" className="btn">Nazad</Link>
      </main>
    )
  }
  if (!decks) return <main className="page"><p className="muted">Učitavanje…</p></main>

  if (phase === 'setup') {
    return (
      <GameSetup
        game="blitz"
        icon="⚡"
        title="Blic runda"
        description="60 sekundi, što više tačnih odgovora. Niz tačnih odgovora povećava množilac do x5, a greška ga vraća na x1."
        minCards={4}
        decks={decks}
        cards={cards}
        scores={scores}
        onStart={start}
      />
    )
  }

  const mult = multiplier(combo)
  const pct = (left / BLITZ_SECONDS) * 100

  return (
    <div className="study" data-theme="game">
      <div className="study-top">
        <button className="icon-btn" aria-label="Prekini" onClick={() => setPhase('setup')}>✕</button>
        <div className={`progress timer ${left <= 10 && phase === 'playing' ? 'low' : ''}`}>
          <div style={{ width: `${pct}%` }} />
        </div>
        <span className="pill">⭐ {score}</span>
      </div>

      {phase === 'playing' && q ? (
        <>
          <div className="combo-row">
            <AnimatePresence mode="wait">
              <motion.span
                key={mult}
                className={`combo ${mult > 1 ? 'hot' : ''}`}
                initial={{ scale: 0.6, opacity: 0 }}
                animate={{ scale: 1, opacity: 1 }}
                transition={{ type: 'spring', stiffness: 400, damping: 15 }}
              >
                {mult > 1 ? `🔥 x${mult}` : 'x1'}
              </motion.span>
            </AnimatePresence>
            <span className="muted">niz {combo}</span>
            <AnimatePresence>
              {gain && (
                <motion.span
                  key={gain.id}
                  className="gain"
                  initial={{ y: 0, opacity: 1 }}
                  animate={{ y: -18, opacity: 0 }}
                  transition={{ duration: 0.7 }}
                >
                  {gain.text}
                </motion.span>
              )}
            </AnimatePresence>
          </div>

          <div className="study-stage">
            <motion.div
              key={q.card.id + q.dir}
              className="grammar"
              initial={{ opacity: 0, y: 16 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.15 }}
            >
              <span className="dir-label static">{q.dir === 'sr_lat' ? 'Srpski → Latinski' : 'Latinski → Srpski'}</span>
              {q.dir === 'lat_sr' && q.card.symbol && <span className="symbol">{q.card.symbol}</span>}
              <p className="blitz-prompt">{q.prompt}</p>
              <div className="blitz-opts">
                {q.options.map((o, i) => {
                  const state = picked === null ? '' : o === q.answer ? 'right' : o === picked ? 'wrong' : 'dim'
                  return (
                    <button key={o} className={`btn opt-btn ${state}`} disabled={picked !== null} onClick={() => choose(o)}>
                      <kbd>{i + 1}</kbd> {o}
                    </button>
                  )
                })}
              </div>
            </motion.div>
          </div>
        </>
      ) : (
        <motion.div className="summary" initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }}>
          <div className="big">{result?.record ? '🏆' : '⏱️'}</div>
          <h2>{result?.record ? 'Novi rekord!' : 'Vreme je isteklo'}</h2>
          <div className="summary-stats">
            <div><b>{final.score}</b><span>poena</span></div>
            <div><b>{final.correct}</b><span>tačno</span></div>
            <div><b>{final.wrong}</b><span>greške</span></div>
          </div>
          <div className="summary-stats">
            <div><b>{final.bestCombo}</b><span>najduži niz</span></div>
            <div>
              <b>
                {final.correct + final.wrong ? Math.round((final.correct / (final.correct + final.wrong)) * 100) : 0}%
              </b>
              <span>preciznost</span>
            </div>
            <div><b>{result ? result.best : '…'}</b><span>rekord</span></div>
          </div>
          {result?.streak != null && <p className="muted">🔥 {result.streak} dana zaredom</p>}
          <button className="btn primary wide" onClick={() => start(scope)}>Još jedna runda</button>
          <button className="btn wide" onClick={() => setPhase('setup')}>Promeni dek</button>
          <Link to="/" className="btn wide">Nazad</Link>
        </motion.div>
      )}
    </div>
  )
}
