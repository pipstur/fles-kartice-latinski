import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../auth'
import { isAdmin, loadStats } from '../lib/api'
import { supabase } from '../lib/supabase'
import { DEFAULT_STATS } from '../lib/types'
import type { Stats } from '../lib/types'

export function Header() {
  const { session } = useAuth()
  const [stats, setStats] = useState<Stats>(DEFAULT_STATS)
  const [admin, setAdmin] = useState(false)

  useEffect(() => {
    if (!session) return
    loadStats(session.user.id).then(setStats).catch(() => {})
    isAdmin(session.user.id).then(setAdmin).catch(() => {})
  }, [session])

  return (
    <header className="topbar">
      <Link to="/" className="logo">
        <img src={`${import.meta.env.BASE_URL}favicon.svg`} alt="" width={32} height={32} />
        <span>Lapis</span>
      </Link>
      <div className="topbar-right">
        <span className="pill" title="Dnevna serija">🔥 {stats.streak}</span>
        <span className="pill" title="Poeni">⭐ {stats.xp}</span>
        <Link to="/statistika" className="icon-btn" aria-label="Statistika">📊</Link>
        {admin && <Link to="/uredi" className="icon-btn" aria-label="Uredi kartice">✏️</Link>}
        <Link to="/podesavanja" className="icon-btn" aria-label="Podešavanja">⚙️</Link>
        <button className="icon-btn" aria-label="Odjava" onClick={() => supabase.auth.signOut()}>⎋</button>
      </div>
    </header>
  )
}
