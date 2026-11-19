import { useEffect, useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { motion } from 'framer-motion'
import { PracticeSession } from '../components/PracticeSession'
import type { Question } from '../components/PracticeSession'
import { useAuth } from '../auth'
import { loadGrammar, loadSettings } from '../lib/api'
import { shuffle } from '../lib/srs'
import type { GrammarItem } from '../lib/types'
import prepositions from '../../seed/prepositions.json'

const SESSION_SIZE = 10
const CASES: Record<string, string> = { nom: 'nominativ', gen: 'genitiv', dat: 'dativ', acc: 'akuzativ', abl: 'ablativ', voc: 'vokativ' }

interface Prep {
  forms: string[]
  cases: string[]
  meaning: string
}
const PREPS = prepositions as Prep[]
const GROUPS: { title: string; cases: string }[] = [
  { title: 'Traže akuzativ', cases: 'acc' },
  { title: 'Traže ablativ', cases: 'abl' },
  { title: 'Akuzativ ili ablativ', cases: 'acc,abl' },
]

function toQuestion(g: GrammarItem): Question {
  const [before, after] = g.sentence.split('___')
  return {
    id: g.id,
    before,
    after,
    answer: g.answer,
    forms: g.forms,
    lemmaLine: (
      <>
        <b>{g.lemma}</b> · {g.gloss}
      </>
    ),
    // Prevod je podsetnik pre odgovora: kod in i sub on kaže da li je kretanje (kuda?) ili mirovanje (gde?).
    cue: g.translation ?? undefined,
    label: `${g.preposition} + ${CASES[g.grammar_case]} ${g.number === 'sg' ? 'jednine' : 'množine'}`,
    translation: null,
  }
}

export function Prepositions() {
  const { session } = useAuth()
  const userId = session!.user.id

  const [items, setItems] = useState<GrammarItem[] | null>(null)
  const [sound, setSound] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [started, setStarted] = useState(false)
  const [round, setRound] = useState(0)

  useEffect(() => {
    Promise.all([loadGrammar(), loadSettings(userId)])
      .then(([g, s]) => {
        setItems(g.filter((x) => x.preposition))
        setSound(s.sound)
      })
      .catch((e: Error) => setError(e.message))
  }, [userId])

  // eslint-disable-next-line react-hooks/exhaustive-deps
  const questions = useMemo(() => (items && started ? shuffle(items).slice(0, SESSION_SIZE).map(toQuestion) : []), [items, started, round])

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
        <h2>Nema rečenica sa predlozima</h2>
        <p className="muted">Pokreni ažurirani <code>supabase/schema.sql</code> i <code>seed.sql</code> u Supabase SQL editoru.</p>
        <Link to="/" className="btn">Nazad</Link>
      </main>
    )
  }

  if (!started) {
    return (
      <div className="study" data-theme="advanced">
        <div className="study-top">
          <Link to="/" className="icon-btn" aria-label="Zatvori">✕</Link>
        </div>
        <motion.div className="setup prep-setup" initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}>
          <div className="big">📍</div>
          <h2>Predlozi i padeži</h2>
          <p className="muted">
            Svaki predlog traži određeni padež. Pregledaj spisak, pa ubaci pravi oblik reči iza predloga.
            Kod <b>in</b> i <b>sub</b> padež zavisi od toga da li se nešto kreće (kuda?) ili miruje (gde?).
          </p>

          {GROUPS.map((g) => (
            <section key={g.cases} className="prep-group">
              <h3>{g.title}</h3>
              <ul>
                {PREPS.filter((p) => p.cases.join(',') === g.cases).map((p) => (
                  <li key={p.forms.join('/')}>
                    <b>{p.forms.join(' / ')}</b>
                    <span>{p.meaning}</span>
                  </li>
                ))}
              </ul>
            </section>
          ))}

          <button className="btn primary wide" onClick={() => setStarted(true)}>Počni vežbu ({items.length} rečenica)</button>
        </motion.div>
      </div>
    )
  }

  return (
    <PracticeSession
      key={round}
      questions={questions}
      theme="advanced"
      sound={sound}
      title="Ubaci oblik iza predloga"
      onRestart={() => setRound((r) => r + 1)}
    />
  )
}
