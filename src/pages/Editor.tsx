import { useCallback, useEffect, useState } from 'react'
import type { FormEvent } from 'react'
import { Header } from '../components/Header'
import { useAuth } from '../auth'
import { createDeck, deleteCard, isAdmin, loadCards, loadDecks, updateCard, upsertCards } from '../lib/api'
import type { CardInput } from '../lib/api'
import type { Card, Deck } from '../lib/types'

const EMPTY = { latin: '', serbian: '', note: '', example: '', symbol: '' }
const THEMES = [
  { value: 'basic', label: 'Zelena' },
  { value: 'advanced', label: 'Ljubičasta' },
  { value: 'technical', label: 'Plava' },
  { value: 'alchemy', label: 'Alhemijska (tamna)' },
]

const toInput = (f: typeof EMPTY): CardInput => ({
  latin: f.latin.trim(),
  serbian: f.serbian.trim(),
  note: f.note.trim() || null,
  example: f.example.trim() || null,
  symbol: f.symbol.trim() || null,
})

const slugify = (s: string) =>
  s.toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '').replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '')

export function Editor() {
  const { session } = useAuth()
  const userId = session!.user.id

  const [admin, setAdmin] = useState<boolean | null>(null)
  const [decks, setDecks] = useState<Deck[]>([])
  const [deckId, setDeckId] = useState('')
  const [cards, setCards] = useState<Card[]>([])
  const [msg, setMsg] = useState<{ kind: 'error' | 'info'; text: string } | null>(null)

  const [form, setForm] = useState(EMPTY)
  const [bulk, setBulk] = useState('')
  const [editId, setEditId] = useState<string | null>(null)
  const [edit, setEdit] = useState(EMPTY)
  const [newDeck, setNewDeck] = useState({ title: '', icon: '📚', theme: 'basic' })

  const fail = (e: unknown) => setMsg({ kind: 'error', text: e instanceof Error ? e.message : String(e) })
  const ok = (text: string) => setMsg({ kind: 'info', text })

  const refreshCards = useCallback(async (id: string) => {
    if (!id) return setCards([])
    const c = await loadCards(id)
    setCards(c.sort((a, b) => a.position - b.position))
  }, [])

  const refreshDecks = useCallback(async (select?: string) => {
    const d = await loadDecks()
    setDecks(d)
    setDeckId((cur) => select ?? (cur || d[0]?.id || ''))
  }, [])

  useEffect(() => {
    isAdmin(userId).then(setAdmin).catch(() => setAdmin(false))
  }, [userId])

  useEffect(() => {
    if (admin) refreshDecks().catch(fail)
  }, [admin, refreshDecks])

  useEffect(() => {
    refreshCards(deckId).catch(fail)
  }, [deckId, refreshCards])

  const nextPosition = () => cards.reduce((m, c) => Math.max(m, c.position), -1) + 1

  async function addOne(e: FormEvent) {
    e.preventDefault()
    try {
      await upsertCards(deckId, nextPosition(), [toInput(form)])
      setForm(EMPTY)
      ok(`Dodato: ${form.latin}`)
      await refreshCards(deckId)
    } catch (err) {
      fail(err)
    }
  }

  async function importBulk() {
    // Jedan red = jedna kartica: latinski ; srpski ; napomena ; simbol (razdvajanje tačka-zarezom ili tabom)
    const rows = bulk
      .split('\n')
      .map((l) => l.trim())
      .filter(Boolean)
      .map((l) => l.split(/\t|;/).map((s) => s.trim()))
      .filter((p) => p[0] && p[1])
      .map((p) => toInput({ latin: p[0], serbian: p[1], note: p[2] ?? '', example: '', symbol: p[3] ?? '' }))
    if (rows.length === 0) return setMsg({ kind: 'error', text: 'Nema ispravnih redova (treba: latinski ; srpski).' })
    try {
      await upsertCards(deckId, nextPosition(), rows)
      setBulk('')
      ok(`Uvezeno kartica: ${rows.length}`)
      await refreshCards(deckId)
    } catch (err) {
      fail(err)
    }
  }

  async function saveEdit() {
    if (!editId) return
    try {
      await updateCard(editId, toInput(edit))
      setEditId(null)
      await refreshCards(deckId)
    } catch (err) {
      fail(err)
    }
  }

  async function remove(c: Card) {
    if (!confirm(`Obrisati „${c.latin}“? Briše se i napredak za tu karticu.`)) return
    try {
      await deleteCard(c.id)
      await refreshCards(deckId)
    } catch (err) {
      fail(err)
    }
  }

  async function makeDeck(e: FormEvent) {
    e.preventDefault()
    const slug = slugify(newDeck.title)
    if (!slug) return
    try {
      await createDeck({
        slug,
        title: newDeck.title.trim(),
        description: '',
        theme: newDeck.theme,
        icon: newDeck.icon || '📚',
        has_symbols: false,
        sort_order: decks.length,
      })
      setNewDeck({ title: '', icon: '📚', theme: 'basic' })
      ok('Dek napravljen.')
      const d = await loadDecks()
      setDecks(d)
      setDeckId(d.find((x) => x.slug === slug)?.id ?? deckId)
    } catch (err) {
      fail(err)
    }
  }

  if (admin === null) return <><Header /><main className="page"><p className="muted">Učitavanje…</p></main></>

  if (!admin) {
    return (
      <>
        <Header />
        <main className="page narrow" data-theme="basic">
          <h2>Nemaš pristup uređivanju</h2>
          <p>Da postaneš admin, pokreni u Supabase SQL editoru (sa svojim mejlom):</p>
          <pre className="code">{`insert into public.lat_admins (user_id)\nselect id from auth.users where email = 'tvoj@mejl.com';`}</pre>
        </main>
      </>
    )
  }

  return (
    <>
      <Header />
      <main className="page" data-theme="basic">
        <h2 className="page-title">Uređivanje kartica</h2>
        {msg && <p className={`msg ${msg.kind}`}>{msg.text}</p>}

        <section>
          <h3>Dek</h3>
          <select className="field" value={deckId} onChange={(e) => setDeckId(e.target.value)}>
            {decks.map((d) => <option key={d.id} value={d.id}>{d.icon} {d.title}</option>)}
          </select>
          <details className="box">
            <summary>Novi dek</summary>
            <form className="row" onSubmit={makeDeck}>
              <input className="field" placeholder="Naziv" required value={newDeck.title} onChange={(e) => setNewDeck({ ...newDeck, title: e.target.value })} />
              <input className="field short" placeholder="Ikona" value={newDeck.icon} onChange={(e) => setNewDeck({ ...newDeck, icon: e.target.value })} />
              <select className="field" value={newDeck.theme} onChange={(e) => setNewDeck({ ...newDeck, theme: e.target.value })}>
                {THEMES.map((t) => <option key={t.value} value={t.value}>{t.label}</option>)}
              </select>
              <button className="btn primary">Napravi</button>
            </form>
          </details>
        </section>

        <section>
          <h3>Nova kartica</h3>
          <form className="form-grid" onSubmit={addOne}>
            <input className="field" placeholder="Latinski *" required value={form.latin} onChange={(e) => setForm({ ...form, latin: e.target.value })} />
            <input className="field" placeholder="Srpski *" required value={form.serbian} onChange={(e) => setForm({ ...form, serbian: e.target.value })} />
            <input className="field" placeholder="Napomena (npr. f., gen. aquae)" value={form.note} onChange={(e) => setForm({ ...form, note: e.target.value })} />
            <input className="field" placeholder="Primer rečenice" value={form.example} onChange={(e) => setForm({ ...form, example: e.target.value })} />
            <input className="field" placeholder="Simbol (opciono)" value={form.symbol} onChange={(e) => setForm({ ...form, symbol: e.target.value })} />
            <button className="btn primary" disabled={!deckId}>Dodaj</button>
          </form>

          <details className="box">
            <summary>Uvoz više kartica odjednom</summary>
            <p className="muted">
              Jedan red po kartici: <code>latinski ; srpski ; napomena ; simbol</code> (napomena i simbol su opcioni).
              Može i direktno nalepljeno iz Excela/Sheets-a. Ako latinska reč već postoji u deku, ažurira se.
            </p>
            <textarea className="field" rows={8} placeholder={'aqua ; voda ; f., gen. aquae\nignis ; vatra'} value={bulk} onChange={(e) => setBulk(e.target.value)} />
            <button className="btn primary" onClick={importBulk} disabled={!bulk.trim() || !deckId}>Uvezi</button>
          </details>
        </section>

        <section>
          <h3>Kartice u deku ({cards.length})</h3>
          <ul className="card-list">
            {cards.map((c) =>
              editId === c.id ? (
                <li key={c.id} className="editing">
                  <div className="form-grid">
                    <input className="field" value={edit.latin} onChange={(e) => setEdit({ ...edit, latin: e.target.value })} />
                    <input className="field" value={edit.serbian} onChange={(e) => setEdit({ ...edit, serbian: e.target.value })} />
                    <input className="field" placeholder="Napomena" value={edit.note} onChange={(e) => setEdit({ ...edit, note: e.target.value })} />
                    <input className="field" placeholder="Primer" value={edit.example} onChange={(e) => setEdit({ ...edit, example: e.target.value })} />
                    <input className="field" placeholder="Simbol" value={edit.symbol} onChange={(e) => setEdit({ ...edit, symbol: e.target.value })} />
                  </div>
                  <div className="row">
                    <button className="btn primary" onClick={saveEdit}>Sačuvaj</button>
                    <button className="btn" onClick={() => setEditId(null)}>Otkaži</button>
                  </div>
                </li>
              ) : (
                <li key={c.id}>
                  <span className="sym">{c.symbol}</span>
                  <div>
                    <b>{c.latin}</b> — {c.serbian}
                    {c.note && <small>{c.note}</small>}
                  </div>
                  <button className="icon-btn" aria-label="Izmeni" onClick={() => { setEditId(c.id); setEdit({ latin: c.latin, serbian: c.serbian, note: c.note ?? '', example: c.example ?? '', symbol: c.symbol ?? '' }) }}>✏️</button>
                  <button className="icon-btn" aria-label="Obriši" onClick={() => remove(c)}>🗑️</button>
                </li>
              ),
            )}
          </ul>
        </section>
      </main>
    </>
  )
}
