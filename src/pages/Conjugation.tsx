import { useEffect, useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { motion } from 'framer-motion'
import { PracticeSession } from '../components/PracticeSession'
import type { Question } from '../components/PracticeSession'
import { useAuth } from '../auth'
import { loadSettings, loadVerbs } from '../lib/api'
import { shuffle } from '../lib/srs'
import type { Tense, Verb } from '../lib/types'

const SESSION_SIZE = 10
const TENSES: { key: Tense; label: string; hint: string }[] = [
  { key: 'praes', label: 'Prezent', hint: 'amo, amas…' },
  { key: 'impf', label: 'Imperfekt', hint: 'amabam…' },
  { key: 'fut', label: 'Futur', hint: 'amabo…' },
  { key: 'perf', label: 'Perfekat', hint: 'amavi…' },
  { key: 'plupf', label: 'Pluskvamperfekat', hint: 'amaveram…' },
  { key: 'futperf', label: 'Futur II', hint: 'amavero…' },
]
const PRONOUNS = ['Ego', 'Tu', 'Is', 'Nos', 'Vos', 'Ei']
const PERSON_SR = ['ja', 'ti', 'on/ona/ono', 'mi', 'vi', 'oni']
const STORAGE_KEY = 'lapis.tenses'

const tenseLabel = (t: Tense) => TENSES.find((x) => x.key === t)!.label.toLowerCase()
const personLabel = (p: number) => `${p < 3 ? p + 1 : p - 2}. lice ${p < 3 ? 'jednine' : 'množine'} (${PERSON_SR[p]})`

function loadTenses(): Tense[] {
  try {
    const saved = JSON.parse(localStorage.getItem(STORAGE_KEY) ?? 'null') as Tense[] | null
    if (saved?.length) return saved.filter((t) => TENSES.some((x) => x.key === t))
  } catch {
    // localStorage nije obavezan
  }
  return ['praes']
}

function makeQuestions(verbs: Verb[], tenses: Tense[]): Question[] {
  // Glagol bez oblika za izabrano vreme (stara baza pre novog seed-a) se preskače.
  const all = verbs.flatMap((v) =>
    tenses.flatMap((t) => (v.forms[t]?.length === 6 ? PRONOUNS.map((_, p) => ({ v, t, p })) : [])),
  )
  return shuffle(all)
    .slice(0, SESSION_SIZE)
    .map(({ v, t, p }) => ({
      id: `${v.id}:${t}:${p}`,
      before: `${PRONOUNS[p]} `,
      after: '.',
      answer: v.forms[t]![p],
      forms: [...new Set(v.forms[t]!)],
      lemmaLine: (
        <>
          <b>{v.infinitive}</b> · {v.gloss}
        </>
      ),
      cue: tenseLabel(t),
      label: `${tenseLabel(t)}, ${personLabel(p)}`,
    }))
}

export function Conjugation() {
  const { session } = useAuth()
  const userId = session!.user.id

  const [verbs, setVerbs] = useState<Verb[] | null>(null)
  const [sound, setSound] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [tenses, setTenses] = useState<Tense[]>(loadTenses)
  const [started, setStarted] = useState(false)
  const [round, setRound] = useState(0)

  useEffect(() => {
    Promise.all([loadVerbs(), loadSettings(userId)])
      .then(([v, s]) => {
        setVerbs(v)
        setSound(s.sound)
      })
      .catch((e: Error) => setError(e.message))
  }, [userId])

  function toggle(t: Tense) {
    const next = tenses.includes(t) ? tenses.filter((x) => x !== t) : [...tenses, t]
    if (next.length === 0) return // bar jedno vreme mora ostati
    setTenses(next)
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(next))
    } catch {
      // nije kritično
    }
  }

  // eslint-disable-next-line react-hooks/exhaustive-deps
  const questions = useMemo(() => (verbs && started ? makeQuestions(verbs, tenses) : []), [verbs, started, round])

  if (error) {
    return (
      <main className="page">
        <p className="msg error">{error}</p>
        <Link to="/" className="btn">Nazad</Link>
      </main>
    )
  }
  if (!verbs) return <main className="page"><p className="muted">Učitavanje…</p></main>

  if (verbs.length === 0) {
    return (
      <main className="page narrow" data-theme="technical">
        <h2>Nema glagola</h2>
        <p className="muted">Pokreni ažurirani <code>supabase/schema.sql</code> i <code>seed.sql</code> u Supabase SQL editoru.</p>
        <Link to="/" className="btn">Nazad</Link>
      </main>
    )
  }

  if (!started) {
    return (
      <div className="study" data-theme="technical">
        <div className="study-top">
          <Link to="/" className="icon-btn" aria-label="Zatvori">✕</Link>
        </div>
        <motion.div className="setup" initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}>
          <div className="big">🔤</div>
          <h2>Konjugacija</h2>
          <p className="muted">
            Dobiješ lice (Ego, Tu, Is…), infinitiv glagola i vreme, a ti birješ ili ukucavaš tačan oblik.
            {' '}Ukupno {verbs.length} glagola.
          </p>
          <h3>Koja vremena vežbaš?</h3>
          <div className="chips">
            {TENSES.map((t) => (
              <button key={t.key} className={`chip ${tenses.includes(t.key) ? 'on' : ''}`} onClick={() => toggle(t.key)}>
                {t.label} <small>{t.hint}</small>
              </button>
            ))}
          </div>
          <button className="btn primary wide" onClick={() => setStarted(true)}>Počni</button>
        </motion.div>
      </div>
    )
  }

  return (
    <PracticeSession
      key={round}
      questions={questions}
      theme="technical"
      sound={sound}
      title="Ubaci tačan oblik glagola"
      onRestart={() => setRound((r) => r + 1)}
    />
  )
}
