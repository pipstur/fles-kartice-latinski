import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { motion } from 'framer-motion'
import { Header } from '../components/Header'
import { useAuth } from '../auth'
import { loadRecipeProgress, loadRecipes } from '../lib/api'
import type { Recipe, RecipeProgress } from '../lib/types'

const Stars = ({ n }: { n: number }) => (
  <span className="stars" aria-label={`${n} od 3 zvezdice`}>
    {[1, 2, 3].map((i) => (
      <span key={i} className={i <= n ? 'on' : ''}>★</span>
    ))}
  </span>
)

export function Lab() {
  const { session } = useAuth()
  const userId = session!.user.id
  const [recipes, setRecipes] = useState<Recipe[] | null>(null)
  const [progress, setProgress] = useState<RecipeProgress[]>([])
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    Promise.all([loadRecipes(), loadRecipeProgress(userId)])
      .then(([r, p]) => {
        setRecipes(r)
        setProgress(p)
      })
      .catch((e: Error) => setError(e.message))
  }, [userId])

  const stars = (slug: string) => progress.find((p) => p.recipe_slug === slug)?.stars ?? 0

  if (error) return <><Header /><main className="page"><p className="msg error">{error}</p></main></>
  if (!recipes) return <><Header /><main className="page"><p className="muted">Učitavanje…</p></main></>

  const collected = recipes.filter((r) => stars(r.slug) > 0)

  return (
    <>
      <Header />
      <main className="page" data-theme="alchemy">
        <div className="lab-bg">
          <h2 className="page-title">Alhemijska laboratorija</h2>
          <p className="muted">
            Svaki recept je niz koraka. Za svaki izaberi pravi latinski pojam, a lončić se puni. Što manje grešaka, to više zvezdica.
          </p>

          {recipes.length === 0 && (
            <p className="muted">Nema recepata. Pokreni ažurirani <code>supabase/schema.sql</code> i <code>seed.sql</code>.</p>
          )}

          <div className="deck-grid">
            {recipes.map((r, i) => {
              const s = stars(r.slug)
              return (
                <motion.div
                  key={r.slug}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: i * 0.05 }}
                  whileHover={{ y: -4 }}
                  whileTap={{ scale: 0.98 }}
                >
                  <Link to={`/laboratorija/${r.slug}`} className="deck" data-theme="alchemy">
                    <span className="deck-icon">{r.icon}</span>
                    <div className="deck-body">
                      <h3>{r.title}</h3>
                      <p>{r.steps.length} koraka → {r.product}</p>
                      <Stars n={s} />
                    </div>
                  </Link>
                </motion.div>
              )
            })}
          </div>

          <h2 className="page-title section-gap">Grimoar</h2>
          <p className="muted small">Proizvodi završenih recepata. Ostali čekaju da ih napraviš.</p>
          <div className="grimoire">
            {recipes.map((r) => {
              const got = stars(r.slug) > 0
              return (
                <div key={r.slug} className={`relic ${got ? 'got' : ''}`} title={got ? r.product : 'Još nije napravljeno'}>
                  <span className="relic-symbol">{got ? r.product_symbol : '?'}</span>
                  <span className="relic-name">{got ? r.product : '???'}</span>
                </div>
              )
            })}
          </div>
          <p className="muted small">{collected.length} od {recipes.length} u grimoaru</p>
        </div>
      </main>
    </>
  )
}
