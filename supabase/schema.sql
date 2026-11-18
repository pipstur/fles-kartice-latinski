-- Šema za aplikaciju za učenje latinskog.
-- Sve tabele imaju prefiks lat_ da se ne sudare sa drugim tabelama u istom Supabase projektu.
-- Pokreni ceo fajl u Supabase -> SQL Editor. Bezbedno je pokrenuti ga više puta.

create extension if not exists "pgcrypto";

-- ---------------------------------------------------------------- dekovi
create table if not exists public.lat_decks (
  id           uuid primary key default gen_random_uuid(),
  slug         text unique not null,
  title        text not null,
  description  text not null default '',
  theme        text not null default 'default',   -- ključ teme u frontendu (npr. 'alchemy')
  icon         text not null default '📚',
  has_symbols  boolean not null default false,    -- da li kartice imaju simbol
  sort_order   int not null default 0,
  created_at   timestamptz not null default now()
);

-- --------------------------------------------------------------- kartice
create table if not exists public.lat_cards (
  id          uuid primary key default gen_random_uuid(),
  deck_id     uuid not null references public.lat_decks(id) on delete cascade,
  latin       text not null,
  serbian     text not null,
  note        text,             -- npr. "f., gen. aquae" ili kratko objašnjenje
  example     text,             -- primer rečenice / upotrebe
  symbol      text,             -- alhemijski simbol (Unicode) ili null
  symbol_svg  text,             -- opciono: putanja do SVG-a ako font ne prikazuje simbol
  position    int not null default 0,   -- redosled u deku (za režim "redom")
  created_at  timestamptz not null default now(),
  unique (deck_id, latin)
);
create index if not exists lat_cards_deck_idx on public.lat_cards(deck_id);

-- ------------------------------------------------------ napredak (po smeru)
-- direction: 'sr_lat' = srpski -> latinski, 'lat_sr' = latinski -> srpski
create table if not exists public.lat_progress (
  user_id      uuid not null references auth.users(id) on delete cascade,
  card_id      uuid not null references public.lat_cards(id) on delete cascade,
  direction    text not null check (direction in ('sr_lat','lat_sr')),
  ease         real not null default 2.5,
  interval_days int  not null default 0,
  repetitions  int  not null default 0,
  lapses       int  not null default 0,
  due_at       timestamptz not null default now(),
  last_seen_at timestamptz,
  primary key (user_id, card_id, direction)
);
create index if not exists lat_progress_due_idx on public.lat_progress(user_id, due_at);

-- ------------------------------------------------------ podešavanja korisnika
create table if not exists public.lat_user_settings (
  user_id      uuid primary key references auth.users(id) on delete cascade,
  algorithm    text not null default 'spaced' check (algorithm in ('spaced','random','sequential')),
  daily_goal   int  not null default 20 check (daily_goal between 1 and 500),
  direction    text not null default 'both' check (direction in ('sr_lat','lat_sr','both')),
  sound        boolean not null default true,
  updated_at   timestamptz not null default now()
);

-- ------------------------------------------------- statistika (XP i streak)
create table if not exists public.lat_stats (
  user_id        uuid primary key references auth.users(id) on delete cascade,
  xp             int  not null default 0,
  streak         int  not null default 0,
  best_streak    int  not null default 0,
  last_study_day date
);

-- ----------------------------------------------- vežba padeža (rečenice)
create table if not exists public.lat_grammar_items (
  id          uuid primary key default gen_random_uuid(),
  sentence    text not null,        -- "Puellam ___ video." ; praznina je ___
  answer      text not null,        -- tačan oblik
  lemma       text not null,        -- osnovni oblik: "aqua"
  grammar_case text not null,       -- nom, gen, dat, acc, abl, voc
  number      text not null default 'sg' check (number in ('sg','pl')),
  translation text,
  hint        text,
  created_at  timestamptz not null default now()
);

-- =================================================== Row Level Security
alter table public.lat_decks          enable row level security;
alter table public.lat_cards          enable row level security;
alter table public.lat_progress       enable row level security;
alter table public.lat_user_settings  enable row level security;
alter table public.lat_stats          enable row level security;
alter table public.lat_grammar_items  enable row level security;

-- Dekove, kartice i gramatiku čitaju svi prijavljeni; pišeš ih ti kroz SQL editor / dashboard
-- (service role zaobilazi RLS). Kasnije dodajemo admin ulogu za unos kroz interfejs.
drop policy if exists "decks read"   on public.lat_decks;
drop policy if exists "cards read"   on public.lat_cards;
drop policy if exists "grammar read" on public.lat_grammar_items;
create policy "decks read"   on public.lat_decks         for select to authenticated using (true);
create policy "cards read"   on public.lat_cards         for select to authenticated using (true);
create policy "grammar read" on public.lat_grammar_items for select to authenticated using (true);

-- Lični podaci: svako vidi i menja samo svoje.
drop policy if exists "progress own"  on public.lat_progress;
drop policy if exists "settings own"  on public.lat_user_settings;
drop policy if exists "stats own"     on public.lat_stats;
create policy "progress own" on public.lat_progress
  for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "settings own" on public.lat_user_settings
  for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "stats own" on public.lat_stats
  for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
