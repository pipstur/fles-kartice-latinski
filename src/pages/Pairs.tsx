import { useEffect, useRef, useState } from 'react'
import { Link } from 'react-router-dom'
import { motion } from 'framer-motion'
import confetti from 'canvas-confetti'
import { GameSetup } from '../components/GameSetup'
import { useAuth } from '../auth'
import { addStudy, loadCards, loadDecks, loadScores, loadSettings, saveScore } from '../lib/api'
import { pairsScore, pickPairs } from '../lib/games'
import { shuffle } from '../lib/srs'
import { play } from '../lib/sound'
import type { Card, Deck, Score } from '../lib/types'

type Phase = 'setup' | 'playing' | 'done'

interface Result {
  score: number
  seconds: number
  mistakes: number
  best: number
  record: boolean
  streak: number | null
}

export function Pairs() {
  const { session } = useAuth()
  const userId = session!.user.id

  const [decks, setDecks] = useState<Deck[] | null>(null)
  const [cards, setCards] = useState<Card[]>([])
  const [scores, setScores] = useState<Score[]>([])
  const [sound, setSound] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const [phase, setPhase] = useState<Phase>('setup')
  const [scope, setScope] = useState('all')
  const [board, setBoard] = useState<Card[]>([])
  const [left, setLeft] = useState<Card[]>([]) // latinske pločice
  const [right, setRight] = useState<Card[]>([]) // srpske pločice
  const [matched, setMatched] = useState<Set<string>>(new Set())
  const [selL, setSelL] = useState<string | null>(null)
  const [selR, setSelR] = useState<string | null>(null)
  const [bad, setBad] = useState<{ l: string; r: string } | null>(null)
  const [mistakes, setMistakes] = useState(0)
  const [elapsed, setElapsed] = useState(0)
  const [result, setResult] = useState<Result | null>(null)

  const startedAt = useRef(0)
  const mistakesRef = useRef(0)
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

  // Štoperica
  useEffect(() => {
    if (phase !== 'playing') return
    const id = window.setInterval(() => setElapsed((Date.now() - startedAt.current) / 1000), 250)
    return () => window.clearInterval(id)
  }, [phase])

  function start(chosen: string) {
    const deckId = decks?.find((d) => d.slug === chosen)?.id
    const pool = chosen === 'all' ? cards : cards.filter((c) => c.deck_id === deckId)
    const picked = pickPairs(pool)
    setScope(chosen)
    setBoard(picked)
    setLeft(shuffle(picked))
    setRight(shuffle(picked))
    setMatched(new Set())
    setSelL(null)
    setSelR(null)
    setBad(null)
    setMistakes(0)
    mistakesRef.current = 0
    setElapsed(0)
    setResult(null)
    startedAt.current = Date.now()
    setPhase('playing')
  }

  async function finish(finalMistakes: number) {
    const seconds = (Date.now() - startedAt.current) / 1000
    const score = pairsScore(finalMistakes, seconds, board.length)
    setElapsed(seconds)
    setPhase('done')
    play('done', sound)

    const [saved, st] = await Promise.all([
      saveScore(userId, 'pairs', scope, score),
      addStudy(userId, board.length * 5, board.length + finalMistakes).catch(() => null),
    ])
    const record = saved.record && score > 0
    if (record) confetti({ particleCount: 160, spread: 90, origin: { y: 0.6 } })
    setResult({ score, seconds, mistakes: finalMistakes, best: saved.best, record, streak: st ? st.streak : null })
    setScores((prev) => [
      ...prev.filter((x) => !(x.game === 'pairs' && x.scope === scope)),
      { game: 'pairs', scope, best: saved.best, plays: 0 },
    ])
  }

  function pick(side: 'l' | 'r', id: string) {
    if (phase !== 'playing' || bad || matched.has(id)) return
    const nl = side === 'l' ? (selL === id ? null : id) : selL
    const nr = side === 'r' ? (selR === id ? null : id) : selR
    setSelL(nl)
    setSelR(nr)
    if (!nl || !nr) return

    if (nl === nr) {
      const next = new Set(matched).add(nl)
      setMatched(next)
      setSelL(null)
      setSelR(null)
      play('good', sound)
      if (next.size === board.length) void finish(mistakesRef.current)
    } else {
      mistakesRef.current += 1
      setMistakes(mistakesRef.current)
      setBad({ l: nl, r: nr })
      play('bad', sound)
      const t = window.setTimeout(() => {
        setBad(null)
        setSelL(null)
        setSelR(null)
      }, 600)
      timeouts.current.push(t)
    }
  }

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
        game="pairs"
        icon="🧩"
        title="Spajanje parova"
        description="Spoji svaku latinsku reč sa njenim prevodom. Što brže i sa manje grešaka, to više poena."
        minCards={6}
        decks={decks}
        cards={cards}
        scores={scores}
        onStart={start}
      />
    )
  }

  const pct = board.length ? (matched.size / board.length) * 100 : 0

  return (
    <div className="study" data-theme="game">
      <div className="study-top">
        <button className="icon-btn" aria-label="Prekini" onClick={() => setPhase('setup')}>✕</button>
        <div className="progress"><motion.div animate={{ width: `${pct}%` }} /></div>
        <span className="pill">⏱ {Math.floor(elapsed)}s</span>
      </div>

      {phase === 'playing' ? (
        <div className="study-stage pairs-stage">
          <p className="muted pairs-info">Greške: {mistakes} · Spojeno {matched.size}/{board.length}</p>
          <div className="pairs">
            <div className="pairs-col">
              {left.map((c) => (
                <motion.button
                  key={c.id}
                  layout
                  className={`tile ${matched.has(c.id) ? 'done' : ''} ${selL === c.id ? 'sel' : ''} ${bad?.l === c.id ? 'bad' : ''}`}
                  disabled={matched.has(c.id)}
                  onClick={() => pick('l', c.id)}
                  whileTap={{ scale: 0.96 }}
                >
                  {c.latin}
                </motion.button>
              ))}
            </div>
            <div className="pairs-col">
              {right.map((c) => (
                <motion.button
                  key={c.id}
                  layout
                  className={`tile ${matched.has(c.id) ? 'done' : ''} ${selR === c.id ? 'sel' : ''} ${bad?.r === c.id ? 'bad' : ''}`}
                  disabled={matched.has(c.id)}
                  onClick={() => pick('r', c.id)}
                  whileTap={{ scale: 0.96 }}
                >
                  {c.serbian}
                </motion.button>
              ))}
            </div>
          </div>
        </div>
      ) : (
        <motion.div className="summary" initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }}>
          <div className="big">{result?.record ? '🏆' : '🧩'}</div>
          <h2>{result?.record ? 'Novi rekord!' : 'Sve spojeno!'}</h2>
          <div className="summary-stats">
            <div><b>{result ? result.score : '…'}</b><span>poena</span></div>
            <div><b>{Math.round(elapsed)}s</b><span>vreme</span></div>
            <div><b>{mistakes}</b><span>greške</span></div>
          </div>
          {result && <p className="muted">Rekord: {result.best}{result.streak != null && ` · 🔥 ${result.streak} dana zaredom`}</p>}
          <button className="btn primary wide" onClick={() => start(scope)}>Nova tabla</button>
          <button className="btn wide" onClick={() => setPhase('setup')}>Promeni dek</button>
          <Link to="/" className="btn wide">Nazad</Link>
        </motion.div>
      )}
    </div>
  )
}
