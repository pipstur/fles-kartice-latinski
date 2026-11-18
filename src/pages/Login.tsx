import { useState } from 'react'
import type { FormEvent } from 'react'
import { motion } from 'framer-motion'
import { supabase } from '../lib/supabase'

export function Login() {
  const [mode, setMode] = useState<'in' | 'up'>('in')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ kind: 'error' | 'info'; text: string } | null>(null)

  async function submit(e: FormEvent) {
    e.preventDefault()
    setBusy(true)
    setMessage(null)
    if (mode === 'in') {
      const { error } = await supabase.auth.signInWithPassword({ email, password })
      if (error) setMessage({ kind: 'error', text: 'Pogrešan email ili lozinka.' })
    } else {
      const { data, error } = await supabase.auth.signUp({ email, password })
      if (error) setMessage({ kind: 'error', text: error.message })
      else if (!data.session) setMessage({ kind: 'info', text: 'Proveri email i potvrdi nalog, pa se prijavi.' })
    }
    setBusy(false)
  }

  return (
    <main className="login" data-theme="basic">
      <motion.div className="login-card" initial={{ opacity: 0, y: 24 }} animate={{ opacity: 1, y: 0 }}>
        <img src={`${import.meta.env.BASE_URL}favicon.svg`} alt="" width={72} height={72} />
        <h1>Lapis</h1>
        <p className="muted">{mode === 'in' ? 'Prijavi se i nastavi da učiš.' : 'Napravi nalog da pratiš napredak.'}</p>
        <form onSubmit={submit}>
          <input type="email" placeholder="Email" autoComplete="email" required value={email} onChange={(e) => setEmail(e.target.value)} />
          <input
            type="password"
            placeholder="Lozinka (min. 6 znakova)"
            autoComplete={mode === 'in' ? 'current-password' : 'new-password'}
            minLength={6}
            required
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          {message && <p className={`msg ${message.kind}`}>{message.text}</p>}
          <button className="btn primary" disabled={busy}>
            {busy ? 'Sačekaj…' : mode === 'in' ? 'Prijavi se' : 'Napravi nalog'}
          </button>
        </form>
        <button className="link" onClick={() => { setMode(mode === 'in' ? 'up' : 'in'); setMessage(null) }}>
          {mode === 'in' ? 'Nemaš nalog? Registruj se' : 'Već imaš nalog? Prijavi se'}
        </button>
      </motion.div>
    </main>
  )
}
