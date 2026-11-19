import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { motion } from 'framer-motion'
import { Header } from '../components/Header'
import { loadAllProgress, loadCards, loadDecks } from '../lib/api'
import { dueCount } from '../lib/srs'
import type { Card, Deck, Progress } from '../lib/types'

export function Home() {
  const [decks, setDecks] = useState<Deck[] | null>(null)
  const [cards, setCards] = useState<Card[]>([])
  const [progress, setProgress] = useState<Progress[]>([])
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    Promise.all([loadDecks(), loadCards(), loadAllProgress()])
      .then(([d, c, p]) => {
        setDecks(d)
        setCards(c)
        setProgress(p)
      })
      .catch((e: Error) => setError(e.message))
  }, [])

  return (
    <>
      <Header />
      <main className="page">
        <h2 className="page-title">Izaberi dek</h2>
        {error && <p className="msg error">Greška pri učitavanju: {error}</p>}
        {!decks && !error && <p className="muted">Učitavanje…</p>}
        {decks?.length === 0 && <p className="muted">Nema dekova. Pokreni supabase/seed.sql u Supabase SQL editoru.</p>}

        <div className="deck-grid">
          {decks?.map((deck, i) => {
            const ids = new Set(cards.filter((c) => c.deck_id === deck.id).map((c) => c.id))
            const mine = progress.filter((p) => ids.has(p.card_id))
            const seen = new Set(mine.map((p) => p.card_id)).size
            const pct = ids.size ? Math.round((seen / ids.size) * 100) : 0
            const due = dueCount(mine)
            return (
              <motion.div
                key={deck.id}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: i * 0.07, type: 'spring', stiffness: 260, damping: 24 }}
                whileHover={{ y: -4 }}
                whileTap={{ scale: 0.98 }}
              >
                <Link to={`/dek/${deck.slug}`} className="deck" data-theme={deck.theme}>
                  <span className="deck-icon">{deck.icon}</span>
                  <div className="deck-body">
                    <h3>{deck.title}</h3>
                    <p>{deck.description}</p>
                    <div className="meter" aria-label={`Viđeno ${pct}%`}>
                      <div style={{ width: `${pct}%` }} />
                    </div>
                    <small>
                      {ids.size} kartica{due > 0 && ` · ${due} za ponavljanje`}
                    </small>
                  </div>
                </Link>
              </motion.div>
            )
          })}
        </div>

        <h2 className="page-title section-gap">Vežbe</h2>
        <div className="deck-grid">
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} whileHover={{ y: -4 }} whileTap={{ scale: 0.98 }}>
            <Link to="/padezi" className="deck" data-theme="advanced">
              <span className="deck-icon">✍️</span>
              <div className="deck-body">
                <h3>Padeži</h3>
                <p>Ubaci reč u rečenicu u tačnom padežu.</p>
              </div>
            </Link>
          </motion.div>
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.07 }} whileHover={{ y: -4 }} whileTap={{ scale: 0.98 }}>
            <Link to="/konjugacija" className="deck" data-theme="technical">
              <span className="deck-icon">🔤</span>
              <div className="deck-body">
                <h3>Konjugacija</h3>
                <p>Ubaci tačan oblik glagola: lice i vreme.</p>
              </div>
            </Link>
          </motion.div>
        </div>

        <h2 className="page-title section-gap">Igre</h2>
        <div className="deck-grid">
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} whileHover={{ y: -4 }} whileTap={{ scale: 0.98 }}>
            <Link to="/blic" className="deck" data-theme="game">
              <span className="deck-icon">⚡</span>
              <div className="deck-body">
                <h3>Blic runda</h3>
                <p>60 sekundi, niz tačnih odgovora i množilac do x5.</p>
              </div>
            </Link>
          </motion.div>
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.07 }} whileHover={{ y: -4 }} whileTap={{ scale: 0.98 }}>
            <Link to="/parovi" className="deck" data-theme="game">
              <span className="deck-icon">🧩</span>
              <div className="deck-body">
                <h3>Spajanje parova</h3>
                <p>Spoji latinske reči sa prevodima što brže možeš.</p>
              </div>
            </Link>
          </motion.div>
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.14 }} whileHover={{ y: -4 }} whileTap={{ scale: 0.98 }}>
            <Link to="/laboratorija" className="deck" data-theme="alchemy">
              <span className="deck-icon">⚗️</span>
              <div className="deck-body">
                <h3>Alhemijska laboratorija</h3>
                <p>Kuvaj recepte, sakupljaj proizvode u grimoar.</p>
              </div>
            </Link>
          </motion.div>
        </div>
      </main>
    </>
  )
}
