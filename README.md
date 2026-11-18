# Lapis

Web aplikacija (React + Vite + Supabase, PWA) za učenje latinskog pomoću kartica.

## Pokretanje

1. **Baza:** u Supabase → SQL Editor pokreni redom `supabase/schema.sql`, pa `supabase/seed.sql`.
   Tabele imaju prefiks `lat_`, pa ne smetaju ostalim tabelama u projektu.
2. **Ključevi:** kopiraj `.env.example` u `.env.local` i upiši URL i anon ključ.
3. `npm install`, pa `npm run dev` (otvara se na `/fles-kartice-latinski/`).

## Sadržaj dekova

Dekovi i kartice su u `seed/decks.json`. Posle izmene pokreni `npm run seed`, pa ponovo nalepi
`supabase/seed.sql` u SQL Editor (koristi upsert, bezbedno je ponavljati).

## Deploy (GitHub Pages)

1. Repo → Settings → Pages → Source: **GitHub Actions**.
2. Repo → Settings → Secrets and variables → Actions → **Variables**: dodaj `VITE_SUPABASE_URL` i `VITE_SUPABASE_ANON_KEY`.
3. Svaki push na `main` pokreće build i deploy.
4. U Supabase → Authentication → URL Configuration dodaj `https://pipstur.github.io/fles-kartice-latinski/` kao Site URL.

## Prečice (računar)

Razmak/Enter okreće karticu, `1`–`4` ocenjuje (ponovo, teško, dobro, lako).
