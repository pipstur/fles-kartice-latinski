import { useCallback, useEffect, useMemo, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { AnimatePresence, motion } from 'framer-motion'
import confetti from 'canvas-confetti'
import { Cauldron } from '../components/Cauldron'
import { useAuth } from '../auth'
import { addStudy, loadCards, loadDecks, loadRecipes, loadSettings, saveRecipeResult } from '../lib/api'
import { DEFAULT_COLORS, liquidColor, pickOptions, starsFor } from '../lib/lab'
import { play } from '../lib/sound'
import type { Card, Recipe } from '../lib/types'

const ADVANCE_MS = 850

export function Brew() {
  const { slug } = useParams()
  const { session } = useAuth()
  const userId = session!.user.id

  const [recipes, setRecipes] = useState<Recipe[] | null>(null)
  const [pool, setPool] = useState<Card[]>([])
  const [sound, setSound] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const [step, setStep] = useState(0)
  const [correct, setCorrect] = useState<string | null>(null) // tačno izabran odgovor, dok se čeka prelazak
  const [wrong, setWrong] = useState<string[]>([]) // isključeni (pogrešni) izbori u ovom koraku
  const [mistakes, setMistakes] = useState(0)
  const [smoke, setSmoke] = useState(0)
  const [done, setDone] = useState(false)
  const [outcome, setOutcome] = useState<{ stars: number; best: number; streak: number | null } | null>(null)
  const [round, setRound] = useState(0)

  useEffect(() => {
    Promise.all([loadRecipes(), loadDecks(), loadSettings(userId)])
      .then(async ([r, decks, s]) => {
        setRecipes(r)
        setSound(s.sound)
        const alchemy = decks.find((d) => d.slug === 'alhemija')
        setPool(alchemy ? await loadCards(alchemy.id) : [])
      })
      .catch((e: Error) => setError(e.message))
  }, [userId])

  const recipe = recipes?.find((r) => r.slug === slug) ?? null
  const total = recipe?.steps.length ?? 0
  const current = recipe && step < total ? recipe.steps[step] : null

  // Ponuđeni odgovori se biraju jednom po koraku, da se ne mešaju posle greške.
  const options = useMemo(
    () => (current ? pickOptions(current.answer, pool) : []),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [recipe?.slug, step, pool, round],
  )

  const finish = useCallback(
    async (finalMistakes: number) => {
      if (!recipe) return
      const stars = starsFor(finalMistakes)
      setDone(true)
      play('done', sound)
      confetti({ particleCount: 150, spread: 80, origin: { y: 0.55 }, colors: ['#ffd966', '#c9a227', '#ffffff'] })
      const [saved, st] = await Promise.all([
        saveRecipeResult(userId, recipe.slug, stars),
        addStudy(userId, recipe.steps.length * 5 + stars * 5, recipe.steps.length + finalMistakes).catch(() => null),
      ])
      setOutcome({ stars, best: saved.best, streak: st ? st.streak : null })
    },
    [recipe, sound, userId],
  )

  const choose = useCallback(
    (opt: string) => {
      if (!recipe || !current || done || correct !== null || wrong.includes(opt)) return
      if (opt === current.answer) {
        setCorrect(opt)
        play('good', sound)
        window.setTimeout(() => {
          setCorrect(null)
          setWrong([])
          if (step + 1 >= total) void finish(mistakes)
          else setStep(step + 1)
        }, ADVANCE_MS)
      } else {
        setWrong((w) => [...w, opt])
        setMistakes((m) => m + 1)
        setSmoke((s) => s + 1)
        play('bad', sound)
      }
    },
    [recipe, current, done, correct, wrong, sound, step, total, mistakes, finish],
  )

  // Tastatura: 1-4.
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      const i = ['1', '2', '3', '4'].indexOf(e.key)
      if (i !== -1 && options[i]) choose(options[i])
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [options, choose])

  function restart() {
    setStep(0)
    setCorrect(null)
    setWrong([])
    setMistakes(0)
    setSmoke(0)
    setDone(false)
    setOutcome(null)
    setRound((r) => r + 1)
  }

  if (error) {
    return (
      <main className="page">
        <p className="msg error">{error}</p>
        <Link to="/laboratorija" className="btn">Nazad</Link>
      </main>
    )
  }
  if (!recipes) return <main className="page"><p className="muted">Učitavanje…</p></main>
  if (!recipe) {
    return (
      <main className="page narrow">
        <h2>Recept ne postoji</h2>
        <Link to="/laboratorija" className="btn">Nazad u laboratoriju</Link>
      </main>
    )
  }

  const completed = step + (correct !== null ? 1 : 0)
  const level = done ? 1 : completed / total
  const color = liquidColor(recipe.colors ?? DEFAULT_COLORS, done ? total : completed, total)
  const next = recipes[recipes.findIndex((r) => r.slug === recipe.slug) + 1]

  return (
    <div className="study brew" data-theme="alchemy">
      <div className="study-top">
        <Link to="/laboratorija" className="icon-btn" aria-label="Zatvori">✕</Link>
        <div className="progress"><motion.div animate={{ width: `${done ? 100 : (completed / total) * 100}%` }} /></div>
        <span className="pill" title="Greške">💨 {mistakes}</span>
      </div>

      <h2 className="brew-title">{recipe.icon} {recipe.title}</h2>

      <div className="cauldron-wrap">
        <Cauldron level={level} color={color} smokeKey={smoke} done={done} />
        <AnimatePresence>
          {done && (
            <motion.div
              className="product"
              initial={{ y: 30, opacity: 0, scale: 0.6 }}
              animate={{ y: -10, opacity: 1, scale: 1 }}
              transition={{ type: 'spring', stiffness: 120, damping: 12, delay: 0.3 }}
            >
              {recipe.product_symbol}
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      {!done && current ? (
        <>
          <motion.div
            key={`${recipe.slug}:${step}:${round}`}
            className="brew-prompt"
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.2 }}
          >
            <span className="dir-label static">Korak {step + 1} od {total}</span>
            <p>{current.prompt}</p>
          </motion.div>
          <div className="blitz-opts brew-opts">
            {options.map((o, i) => {
              const state = correct === o ? 'right' : wrong.includes(o) ? 'wrong' : correct !== null ? 'dim' : ''
              return (
                <button key={o} className={`btn opt-btn ${state}`} disabled={correct !== null || wrong.includes(o)} onClick={() => choose(o)}>
                  <kbd>{i + 1}</kbd> {o}
                </button>
              )
            })}
          </div>
        </>
      ) : (
        <motion.div className="brew-done" initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.5 }}>
          <h2>{recipe.product}</h2>
          <p className="muted">{recipe.intro}</p>
          <div className="big-stars">
            {[1, 2, 3].map((i) => (
              <motion.span
                key={i}
                className={outcome && i <= outcome.stars ? 'on' : ''}
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                transition={{ delay: 0.7 + i * 0.2, type: 'spring', stiffness: 300, damping: 12 }}
              >
                ★
              </motion.span>
            ))}
          </div>
          <p className="muted">
            {mistakes === 0 ? 'Bez ijedne greške!' : `Grešaka: ${mistakes}`}
            {outcome?.streak != null && ` · 🔥 ${outcome.streak} dana zaredom`}
          </p>
          <button className="btn primary wide" onClick={restart}>
            {mistakes > 0 ? 'Pokušaj ponovo za više zvezdica' : 'Napravi ponovo'}
          </button>
          {next && <Link to={`/laboratorija/${next.slug}`} onClick={restart} className="btn wide">Sledeći recept</Link>}
          <Link to="/laboratorija" className="btn wide">Laboratorija i grimoar</Link>
        </motion.div>
      )}
    </div>
  )
}
