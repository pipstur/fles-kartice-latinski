import { useState } from 'react'
import { Link } from 'react-router-dom'
import { motion } from 'framer-motion'
import { poolFor, scopeOf } from '../lib/games'
import type { Card, Deck, GameKind, Score } from '../lib/types'

interface Props {
  game: GameKind
  icon: string
  title: string
  description: string
  minCards: number // koliko kartica izabrani dekovi moraju imati da bi igra imala smisla
  decks: Deck[]
  cards: Card[]
  scores: Score[]
  onStart: (scope: string) => void
}

const KEY = 'lapis.game-decks'

function loadSelected(slugs: string[]): string[] {
  try {
    const saved = JSON.parse(localStorage.getItem(KEY) ?? 'null') as string[] | null
    const valid = saved?.filter((s) => slugs.includes(s)) ?? []
    if (valid.length) return valid
  } catch {
    // nema sačuvanog izbora
  }
  return slugs
}

export function GameSetup({ game, icon, title, description, minCards, decks, cards, scores, onStart }: Props) {
  const slugs = decks.map((d) => d.slug)
  const [selected, setSelected] = useState<string[]>(() => loadSelected(slugs))

  const scope = scopeOf(selected, slugs)
  const total = poolFor(scope, decks, cards).length
  const best = scores.find((s) => s.game === game && s.scope === scope)?.best
  const perDeck = (id: string) => cards.filter((c) => c.deck_id === id).length

  function toggle(slug: string) {
    const next = selected.includes(slug) ? selected.filter((s) => s !== slug) : [...selected, slug]
    setSelected(next)
    try {
      localStorage.setItem(KEY, JSON.stringify(next))
    } catch {
      // izbor se samo ne pamti
    }
  }

  const allOn = selected.length === slugs.length

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
          {decks.map((d) => {
            const on = selected.includes(d.slug)
            return (
              <button key={d.slug} className={`option check ${on ? 'on' : ''}`} onClick={() => toggle(d.slug)} aria-pressed={on}>
                <b>
                  <span className="box">{on ? '✓' : ''}</span> {d.icon} {d.title}
                </b>
                <span>{perDeck(d.id)} kartica</span>
              </button>
            )
          })}
          <button className="btn" onClick={() => setSelected(allOn ? [] : slugs)}>
            {allOn ? 'Isključi sve' : 'Izaberi sve'}
          </button>
        </div>

        <p className="muted">
          {total >= minCards
            ? `${total} kartica u igri${best ? ` · rekord ${best}` : ''}`
            : `Izaberi dekove sa najmanje ${minCards} kartica (sada ${total})`}
        </p>
        <button className="btn primary wide" onClick={() => onStart(scope)} disabled={total < minCards}>
          Počni
        </button>
      </motion.div>
    </div>
  )
}
