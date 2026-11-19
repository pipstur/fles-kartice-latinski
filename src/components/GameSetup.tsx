import { useState } from 'react'
import { Link } from 'react-router-dom'
import { motion } from 'framer-motion'
import type { Card, Deck, GameKind, Score } from '../lib/types'

interface Props {
  game: GameKind
  icon: string
  title: string
  description: string
  minCards: number // koliko kartica dek mora imati da bi igra imala smisla
  decks: Deck[]
  cards: Card[]
  scores: Score[]
  onStart: (scope: string) => void
}

export function GameSetup({ game, icon, title, description, minCards, decks, cards, scores, onStart }: Props) {
  const [scope, setScope] = useState('all')

  const count = (slug: string) =>
    slug === 'all' ? cards.length : cards.filter((c) => c.deck_id === decks.find((d) => d.slug === slug)?.id).length
  const best = (slug: string) => scores.find((s) => s.game === game && s.scope === slug)?.best

  const entries = [
    { slug: 'all', icon: '🎲', title: 'Svi dekovi' },
    ...decks.map((d) => ({ slug: d.slug, icon: d.icon, title: d.title })),
  ]

  return (
    <div className="study" data-theme="game">
      <div className="study-top">
        <Link to="/" className="icon-btn" aria-label="Zatvori">✕</Link>
      </div>
      <motion.div className="setup" initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}>
        <div className="big">{icon}</div>
        <h2>{title}</h2>
        <p className="muted">{description}</p>

        <div className="options game-options">
          {entries.map((e) => {
            const n = count(e.slug)
            const enough = n >= minCards
            const b = best(e.slug)
            return (
              <button
                key={e.slug}
                className={`option ${scope === e.slug ? 'on' : ''}`}
                disabled={!enough}
                onClick={() => setScope(e.slug)}
              >
                <b>{e.icon} {e.title}</b>
                <span>
                  {enough ? `${n} kartica` : `premalo kartica (treba ${minCards})`}
                  {b ? ` · rekord ${b}` : ''}
                </span>
              </button>
            )
          })}
        </div>

        <button className="btn primary wide" onClick={() => onStart(scope)} disabled={count(scope) < minCards}>
          Počni
        </button>
      </motion.div>
    </div>
  )
}
