import { HashRouter, Navigate, Route, Routes } from 'react-router-dom'
import { AuthProvider, useAuth } from './auth'
import { configured } from './lib/supabase'
import { Home } from './pages/Home'
import { Login } from './pages/Login'
import { SettingsPage } from './pages/SettingsPage'
import { Study } from './pages/Study'

function Gate() {
  const { session, loading } = useAuth()
  if (loading) return <main className="page"><p className="muted">Učitavanje…</p></main>
  if (!session) return <Login />
  return (
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/dek/:slug" element={<Study />} />
      <Route path="/podesavanja" element={<SettingsPage />} />
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  )
}

export default function App() {
  if (!configured) {
    return (
      <main className="page narrow">
        <h2>Supabase nije podešen</h2>
        <p>
          Kopiraj <code>.env.example</code> u <code>.env.local</code> i upiši <code>VITE_SUPABASE_URL</code> i{' '}
          <code>VITE_SUPABASE_ANON_KEY</code>, pa ponovo pokreni aplikaciju.
        </p>
      </main>
    )
  }
  return (
    <AuthProvider>
      <HashRouter>
        <Gate />
      </HashRouter>
    </AuthProvider>
  )
}
