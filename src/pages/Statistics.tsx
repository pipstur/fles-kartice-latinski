import { useEffect, useMemo, useState } from 'react'
import { motion } from 'framer-motion'
import { Header } from '../components/Header'
import { useAuth } from '../auth'
import { loadActivity, loadAllProgress, loadCards, loadDecks, loadSettings, loadStats } from '../lib/api'
import { hardest, KNOWN_DAYS, lastDays, MASTERED_DAYS, summarize } from '../lib/stats'
import { today } from '../lib/srs'
import { DEFAULT_SETTINGS } from '../lib/types'
import type { Activity, Card, Deck, Direction, Progress, Settings, Stats } from '../lib/types'

const DIRECTION_LABEL: Record<Direction, string> = { sr_lat: 'srpski → latinski', lat_sr: 'latinski → srpski' }

interface Data {
  decks: Deck[]
  cards: Card[]
  progress: Progress[]
  stats: Stats
  settings: Settings
  activity: Activity[]
}

export function Statistics() {
  const { session } = useAuth()
  const userId = session!.user.id
  const [data, setData] = useState<Data | null>(null)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    Promise.all([
      loadDecks(),
      loadCards(),
      loadAllProgress(),
      loadStats(userId),
      loadSettings(userId),
      loadActivity(userId).catch(() => [] as Activity[]), // tabela možda još ne postoji
    ])
      .then(([decks, cards, progress, stats, settings, activity]) =>
        setData({ decks, cards, progress, stats, settings, activity }),
      )
      .catch((e: Error) => setError(e.message))
  }, [userId])

  const dirs: Direction[] = useMemo(
    () => (!data || data.settings.direction === 'both' ? ['sr_lat', 'lat_sr'] : [data.settings.direction]),
    [data],
  )
  const days = useMemo(() => (data ? lastDays(data.activity, 14) : []), [data])
  const worst = useMemo(() => (data ? hardest(data.cards, data.progress, 10) : []), [data])

  if (error) return <><Header /><main className="page"><p className="msg error">{error}</p></main></>
  if (!data) return <><Header /><main className="page"><p className="muted">Učitavanje…</p></main></>

  const { stats, settings } = data
  const goal = settings.daily_goal || DEFAULT_SETTINGS.daily_goal
  const answersToday = data.activity.find((a) => a.day === today())?.answers ?? 0
  const totalAnswers = data.activity.reduce((n, a) => n + a.answers, 0)
  const maxBar = Math.max(1, ...days.map((d) => d.answers))
  const deckById = new Map(data.decks.map((d) => [d.id, d]))
  const empty = data.progress.length === 0

  return (
    <>
      <Header />
      <main className="page" data-theme="basic">
        <h2 className="page-title">Statistika</h2>

        <div className="tiles">
          <Tile icon="🔥" value={stats.streak} label="dana zaredom" sub={`rekord ${Math.max(stats.best_streak, stats.streak)}`} />
          <Tile icon="⭐" value={stats.xp} label="poena" />
          <Tile icon="📅" value={`${answersToday}/${goal}`} label="odgovora danas" sub="cilj po sesiji" />
          <Tile icon="✅" value={totalAnswers} label="odgovora ukupno" sub="od uključivanja statistike" />
        </div>

        <section>
          <h3>Poslednjih 14 dana</h3>
          <div className="bars" role="img" aria-label="Broj odgovora po danima">
            {days.map((d, i) => (
              <div key={d.day} className="bar-col" title={`${d.label}: ${d.answers}`}>
                <span className="bar-val">{d.answers || ''}</span>
                <div className="bar-track">
                  <motion.div
                    className={`bar ${d.day === today() ? 'today' : ''}`}
                    initial={{ height: 0 }}
                    animate={{ height: `${(d.answers / maxBar) * 100}%` }}
                    transition={{ delay: i * 0.03, type: 'spring', stiffness: 200, damping: 22 }}
                  />
                </div>
                <span className="bar-label">{i % 2 === 0 || days.length <= 7 ? d.label : ''}</span>
              </div>
            ))}
          </div>
          {data.activity.length === 0 && (
            <p className="muted">Aktivnost se beleži od sledeće sesije učenja.</p>
          )}
        </section>

        <section>
          <h3>Napredak po dekovima</h3>
          <p className="muted small">
            Računa se za smer koji trenutno učiš ({settings.direction === 'both' ? 'oba smera' : DIRECTION_LABEL[settings.direction]}).
            „Savladano“ znači da je sledeće ponavljanje za {MASTERED_DAYS}+ dana.
          </p>
          <div className="deck-stats">
            {data.decks.map((deck) => {
              const s = summarize(data.cards.filter((c) => c.deck_id === deck.id).map((c) => c.id), data.progress, dirs)
              const pct = (n: number) => (s.total ? (n / s.total) * 100 : 0)
              return (
                <div key={deck.id} className="deck-stat" data-theme={deck.theme}>
                  <div className="deck-stat-head">
                    <span className="deck-stat-icon">{deck.icon}</span>
                    <b>{deck.title}</b>
                    <span className="muted">{s.due > 0 ? `${s.due} za ponavljanje` : 'sve ponovljeno'}</span>
                  </div>
                  <div className="stack" role="img" aria-label={`Savladano ${s.mastered} od ${s.total}`}>
                    <div className="seg mature" style={{ width: `${pct(s.mastered)}%` }} />
                    <div className="seg known" style={{ width: `${pct(s.known)}%` }} />
                    <div className="seg learning" style={{ width: `${pct(s.learning)}%` }} />
                  </div>
                  <div className="legend">
                    <span><i className="dot mature" /> Savladano <b>{s.mastered}</b></span>
                    <span><i className="dot known" /> Poznato ({KNOWN_DAYS}–{MASTERED_DAYS - 1} d) <b>{s.known}</b></span>
                    <span><i className="dot learning" /> U učenju <b>{s.learning}</b></span>
                    <span><i className="dot fresh" /> Novo <b>{s.fresh}</b></span>
                  </div>
                </div>
              )
            })}
          </div>
        </section>

        <section>
          <h3>Najteže kartice</h3>
          {empty || worst.length === 0 ? (
            <p className="muted">{empty ? 'Počni da učiš pa će se ovde pojaviti.' : 'Za sada nema pogrešenih kartica.'}</p>
          ) : (
            <ul className="card-list">
              {worst.map((w) => {
                const deck = deckById.get(w.card.deck_id)
                return (
                  <li key={`${w.card.id}:${w.direction}`}>
                    <span className="sym">{w.card.symbol ?? deck?.icon}</span>
                    <div>
                      <b>{w.card.latin}</b> — {w.card.serbian}
                      <small>{deck?.title} · {DIRECTION_LABEL[w.direction]}</small>
                    </div>
                    <span className="pill" title="Koliko puta je pritisnuto „Ponovo“">❌ {w.lapses}</span>
                  </li>
                )
              })}
            </ul>
          )}
        </section>
      </main>
    </>
  )
}

function Tile({ icon, value, label, sub }: { icon: string; value: number | string; label: string; sub?: string }) {
  return (
    <motion.div className="tile" initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }}>
      <span className="tile-icon">{icon}</span>
      <b>{value}</b>
      <span>{label}</span>
      {sub && <small>{sub}</small>}
    </motion.div>
  )
}
