import { useEffect, useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { PracticeSession } from '../components/PracticeSession'
import type { Question } from '../components/PracticeSession'
import { useAuth } from '../auth'
import { loadGrammar, loadSettings } from '../lib/api'
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
    label: `${CASES[g.grammar_case]} ${g.number === 'sg' ? 'jednine' : 'množine'}`,
    translation: g.translation,
  }
}

export function Grammar() {
  const { session } = useAuth()
  const userId = session!.user.id

  const [items, setItems] = useState<GrammarItem[] | null>(null)
  const [sound, setSound] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [round, setRound] = useState(0)

  useEffect(() => {
    Promise.all([loadGrammar(), loadSettings(userId)])
      .then(([g, s]) => {
        setItems(g)
        setSound(s.sound)
      })
      .catch((e: Error) => setError(e.message))
  }, [userId])

  // eslint-disable-next-line react-hooks/exhaustive-deps
  const questions = useMemo(() => (items ? shuffle(items).slice(0, SESSION_SIZE).map(toQuestion) : []), [items, round])

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

  return (
    <PracticeSession
      key={round}
      questions={questions}
      theme="advanced"
      sound={sound}
      title="Ubaci reč u tačnom padežu"
      onRestart={() => setRound((r) => r + 1)}
    />
  )
}
