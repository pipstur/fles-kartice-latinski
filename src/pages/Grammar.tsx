import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import type { FormEvent } from 'react'
import { Link } from 'react-router-dom'
import { motion } from 'framer-motion'
import confetti from 'canvas-confetti'
import { useAuth } from '../auth'
import { addStudy, loadGrammar, loadSettings } from '../lib/api'
import { play } from '../lib/sound'
import { shuffle } from '../lib/srs'
import type { GrammarItem } from '../lib/types'

const SESSION_SIZE = 10
const CASES: Record<string, string> = {
  nom: 'nominativ',
  gen: 'genitiv',
  dat: 'dativ',
  acc: 'akuzativ',
  abl: 'ablativ',
  voc: 'vokativ',
}

// Poredi bez razlike u velikim slovima i makronima (ā = a).
const norm = (s: string) => s.trim().toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '')

type Status = 'answering' | 'right' | 'wrong'

export function Grammar() {
  const { session } = useAuth()
  const userId = session!.user.id

  const [items, setItems] = useState<GrammarItem[] | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [sound, setSound] = useState(true)

  const [queue, setQueue] = useState<GrammarItem[]>([])
  const [total, setTotal] = useState(0)
  const [correct, setCorrect] = useState(0)
  const [status, setStatus] = useState<Status>('answering')
  const [picked, setPicked] = useState<string | null>(null)
  const [typed, setTyped] = useState('')
  const [mode, setMode] = useState<'choice' | 'type'>('choice')
  const [streakStats, setStreakStats] = useState<number | null>(null)
  const missed = useRef(new Set<string>())
  const saved = useRef(false)

  const start = useCallback((all: GrammarItem[]) => {
    const q = shuffle(all).slice(0, SESSION_SIZE)
    setQueue(q)
    setTotal(q.length)
    setCorrect(0)
    setStatus('answering')
    setPicked(null)
    setTyped('')
    setStreakStats(null)
    missed.current = new Set()
    saved.current = false
  }, [])

  useEffect(() => {
    Promise.all([loadGrammar(), loadSettings(userId)])
      .then(([g, s]) => {
        setItems(g)
        setSound(s.sound)
        start(g)
      })
      .catch((e: Error) => setError(e.message))
  }, [userId, start])

  const current = queue[0]
  const finished = items !== null && queue.length === 0 && total > 0

  const options = useMemo(() => {
    if (!current) return []
    const wrong = shuffle(current.forms.filter((f) => f !== current.answer)).slice(0, 3)
    return shuffle([current.answer, ...wrong])
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [current?.id, queue.length])

  const check = useCallback(
    (answer: string) => {
      if (!current || status !== 'answering') return
      const ok = norm(answer) === norm(current.answer)
      setPicked(answer)
      setStatus(ok ? 'right' : 'wrong')
      play(ok ? 'good' : 'bad', sound)
      if (ok && !missed.current.has(current.id)) setCorrect((c) => c + 1)
      if (!ok) missed.current.add(current.id)
    },
    [current, status, sound],
  )

  const next = useCallback(() => {
    const wasWrong = status === 'wrong'
    setQueue((q) => {
      const [head, ...rest] = q
      if (!wasWrong) return rest
      // pogrešnu rečenicu vraćamo tek posle par drugih
      const at = Math.min(2, rest.length)
      return [...rest.slice(0, at), head, ...rest.slice(at)]
    })
    setStatus('answering')
    setPicked(null)
    setTyped('')
  }, [status])

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (status !== 'answering' && e.key === 'Enter') {
        e.preventDefault()
        next()
      }
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [status, next])

  useEffect(() => {
    if (!finished || saved.current) return
    saved.current = true
    play('done', sound)
    confetti({ particleCount: 140, spread: 80, origin: { y: 0.6 } })
    addStudy(userId, correct * 10)
      .then((s) => setStreakStats(s.streak))
      .catch((e: Error) => setError(e.message))
  }, [finished, correct, userId, sound])

  if (error) {
    return (
      <main className="page">
        <p className="msg error">{error}</p>
        <Link to="/" className="btn">Nazad</Link>
      </main>
    )
  }
  if (!items) return <main className="page"><p className="muted">Učitavanje…</p></main>

  if (items.length === 0) {
    return (
      <main className="page narrow" data-theme="advanced">
        <h2>Nema rečenica</h2>
        <p className="muted">Pokreni ažurirani <code>supabase/schema.sql</code> i <code>seed.sql</code> u Supabase SQL editoru.</p>
        <Link to="/" className="btn">Nazad</Link>
      </main>
    )
  }

  const done = total - queue.length
  const pct = total ? (done / total) * 100 : 0
  const [before, after] = (current?.sentence ?? '___').split('___')

  return (
    <div className="study" data-theme="advanced">
      <div className="study-top">
        <Link to="/" className="icon-btn" aria-label="Zatvori">✕</Link>
        <div className="progress"><motion.div animate={{ width: `${pct}%` }} /></div>
        <span className="pill">⭐ {correct * 10}</span>
      </div>

      {current ? (
        <>
          <div className="study-stage">
            <motion.div
              key={`${current.id}:${queue.length}`}
              className="grammar"
              initial={{ opacity: 0, x: 50 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.2 }}
            >
              <span className="dir-label static">Ubaci reč u tačnom padežu</span>
              <p className="sentence">
                {before}
                <span className={`blank ${status}`}>{status === 'answering' ? picked ?? '' : current.answer}</span>
                {after}
              </p>
              <p className="lemma-line">
                <b>{current.lemma}</b> · {current.gloss}
              </p>

              {status === 'answering' && mode === 'choice' && (
                <div className="opts">
                  {options.map((o) => (
                    <button key={o} className="btn opt" onClick={() => check(o)}>{o}</button>
                  ))}
                </div>
              )}

              {status === 'answering' && mode === 'type' && (
                <form
                  className="type-form"
                  onSubmit={(e: FormEvent) => {
                    e.preventDefault()
                    if (typed.trim()) check(typed)
                  }}
                >
                  <input
                    className="field"
                    autoFocus
                    autoCapitalize="none"
                    autoCorrect="off"
                    spellCheck={false}
                    placeholder="Upiši oblik…"
                    value={typed}
                    onChange={(e) => setTyped(e.target.value)}
                  />
                  <button className="btn primary" disabled={!typed.trim()}>Proveri</button>
                </form>
              )}

              {status === 'answering' && (
                <button className="link" onClick={() => setMode(mode === 'choice' ? 'type' : 'choice')}>
                  {mode === 'choice' ? 'Radije kucam odgovor' : 'Radije biram ponuđeno'}
                </button>
              )}
            </motion.div>
          </div>

          <div className="study-actions">
            {status !== 'answering' && (
              <motion.div
                className={`feedback ${status}`}
                initial={{ y: 40, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                transition={{ type: 'spring', stiffness: 300, damping: 26 }}
              >
                <div>
                  <b>{status === 'right' ? 'Tačno! 🎉' : `Tačan odgovor: ${current.answer}`}</b>
                  <span>
                    {CASES[current.grammar_case]} {current.number === 'sg' ? 'jednine' : 'množine'}
                    {current.translation && ` · ${current.translation}`}
                  </span>
                </div>
                <button className="btn primary" onClick={next}>Dalje</button>
              </motion.div>
            )}
          </div>
        </>
      ) : (
        <motion.div className="summary" initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }}>
          <div className="big">🏆</div>
          <h2>Vežba završena!</h2>
          <div className="summary-stats">
            <div><b>{correct}/{total}</b><span>iz prvog pokušaja</span></div>
            <div><b>+{correct * 10}</b><span>poena</span></div>
            <div><b>{streakStats !== null ? `🔥 ${streakStats}` : '…'}</b><span>dana zaredom</span></div>
          </div>
          <button className="btn primary wide" onClick={() => start(items)}>Još jedna runda</button>
          <Link to="/" className="btn wide">Nazad</Link>
        </motion.div>
      )}
    </div>
  )
}
