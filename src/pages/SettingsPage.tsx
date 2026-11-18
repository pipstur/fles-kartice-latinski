import { useEffect, useState } from 'react'
import { Header } from '../components/Header'
import { useAuth } from '../auth'
import { loadSettings, saveSettings } from '../lib/api'
import { DEFAULT_SETTINGS } from '../lib/types'
import type { Settings } from '../lib/types'

const ALGORITHMS: { value: Settings['algorithm']; title: string; text: string }[] = [
  { value: 'spaced', title: 'Pametno ponavljanje', text: 'Kartice koje pogrešiš vraćaju se češće, a one koje znaš ređe.' },
  { value: 'random', title: 'Nasumično', text: 'Nasumičan izbor kartica iz deka, bez praćenja rokova.' },
  { value: 'sequential', title: 'Redom', text: 'Prolaziš dek redom, prvo kartice koje još nisi videla/video.' },
]

const DIRECTIONS: { value: Settings['direction']; title: string }[] = [
  { value: 'both', title: 'Oba smera' },
  { value: 'sr_lat', title: 'Srpski → Latinski' },
  { value: 'lat_sr', title: 'Latinski → Srpski' },
]

export function SettingsPage() {
  const { session } = useAuth()
  const userId = session!.user.id
  const [s, setS] = useState<Settings>(DEFAULT_SETTINGS)
  const [status, setStatus] = useState<'idle' | 'saving' | 'saved' | 'error'>('idle')

  useEffect(() => {
    loadSettings(userId).then(setS).catch(() => setStatus('error'))
  }, [userId])

  async function update(patch: Partial<Settings>) {
    const next = { ...s, ...patch }
    setS(next)
    setStatus('saving')
    try {
      await saveSettings(userId, next)
      setStatus('saved')
    } catch {
      setStatus('error')
    }
  }

  return (
    <>
      <Header />
      <main className="page narrow" data-theme="basic">
        <h2 className="page-title">Podešavanja</h2>

        <section>
          <h3>Algoritam učenja</h3>
          <div className="options">
            {ALGORITHMS.map((a) => (
              <button key={a.value} className={`option ${s.algorithm === a.value ? 'on' : ''}`} onClick={() => update({ algorithm: a.value })}>
                <b>{a.title}</b>
                <span>{a.text}</span>
              </button>
            ))}
          </div>
        </section>

        <section>
          <h3>Smer prevoda</h3>
          <div className="chips">
            {DIRECTIONS.map((d) => (
              <button key={d.value} className={`chip ${s.direction === d.value ? 'on' : ''}`} onClick={() => update({ direction: d.value })}>
                {d.title}
              </button>
            ))}
          </div>
        </section>

        <section>
          <h3>Kartica po sesiji: {s.daily_goal}</h3>
          <input
            type="range"
            min={5}
            max={100}
            step={5}
            value={s.daily_goal}
            onChange={(e) => setS({ ...s, daily_goal: Number(e.target.value) })}
            onPointerUp={() => update({})}
            onKeyUp={() => update({})}
          />
        </section>

        <section>
          <label className="toggle">
            <input type="checkbox" checked={s.sound} onChange={(e) => update({ sound: e.target.checked })} />
            <span>Zvuk</span>
          </label>
        </section>

        <p className={`muted status ${status}`}>
          {status === 'saving' && 'Čuvanje…'}
          {status === 'saved' && 'Sačuvano ✓'}
          {status === 'error' && 'Greška pri čuvanju.'}
        </p>
      </main>
    </>
  )
}
