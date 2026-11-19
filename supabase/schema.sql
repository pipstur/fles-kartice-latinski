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

-- ------------------------------------------------ aktivnost po danima
-- Jedan red po korisniku i danu: koliko je odgovora dato i koliko je XP zarađeno (za statistiku).
create table if not exists public.lat_activity (
  user_id  uuid not null references auth.users(id) on delete cascade,
  day      date not null,
  answers  int  not null default 0,
  xp       int  not null default 0,
  primary key (user_id, day)
);

-- ------------------------------------------------------ rekordi u igrama
-- scope: 'all' (svi dekovi) ili slug deka. best = najbolji rezultat (veći je bolji).
create table if not exists public.lat_scores (
  user_id    uuid not null references auth.users(id) on delete cascade,
  game       text not null check (game in ('blitz','pairs')),
  scope      text not null default 'all',
  best       int  not null default 0,
  plays      int  not null default 0,
  updated_at timestamptz not null default now(),
  primary key (user_id, game, scope)
);

-- ------------------------------------------ alhemijska laboratorija (recepti)
-- steps: [{"prompt": "opis koraka na srpskom", "answer": "latinski pojam"}, ...]
-- colors: opciona lista boja tečnosti po koracima (inače podrazumevana paleta).
create table if not exists public.lat_recipes (
  id             uuid primary key default gen_random_uuid(),
  slug           text unique not null,
  title          text not null,
  intro          text not null default '',
  icon           text not null default '⚗️',
  product        text not null,
  product_symbol text not null default '⚗️',
  colors         jsonb,
  steps          jsonb not null,
  sort_order     int not null default 0,
  created_at     timestamptz not null default now()
);

create table if not exists public.lat_recipe_progress (
  user_id      uuid not null references auth.users(id) on delete cascade,
  recipe_slug  text not null,
  stars        int  not null default 0 check (stars between 0 and 3),
  plays        int  not null default 0,
  updated_at   timestamptz not null default now(),
  primary key (user_id, recipe_slug)
);

-- -------------------------------------------------- konjugacija (glagoli)
-- forms: {"praes":[6 oblika], "impf":[...], "fut":[...], "perf":[...]}, redom 1.-3. lice jednine pa množine.
create table if not exists public.lat_verbs (
  id          uuid primary key default gen_random_uuid(),
  lemma       text unique not null,     -- 1. lice jednine prezenta: "amo"
  gloss       text not null,            -- "volim"
  infinitive  text not null,            -- "amare"
  conj        text not null,            -- '1','2','3','3io','4','irreg'
  forms       jsonb not null,
  created_at  timestamptz not null default now()
);

-- Dodato kasnije: gloss (prevod osnovnog oblika) i forms (svi oblici reči, za ponuđene odgovore).
alter table public.lat_grammar_items add column if not exists gloss text;
alter table public.lat_grammar_items add column if not exists forms text[] not null default '{}';
alter table public.lat_grammar_items add column if not exists preposition text;  -- predlog ispred praznine (za vežbu predloga)
create unique index if not exists lat_grammar_sentence_uq on public.lat_grammar_items(sentence);

-- ------------------------------------------------------------------ admini
-- Samo admini mogu da dodaju/menjaju/brišu dekove, kartice i rečenice kroz aplikaciju.
create table if not exists public.lat_admins (
  user_id uuid primary key references auth.users(id) on delete cascade
);

create or replace function public.lat_is_admin() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.lat_admins where user_id = auth.uid())
$$;

-- =================================================== Row Level Security
alter table public.lat_admins enable row level security;
alter table public.lat_verbs  enable row level security;
alter table public.lat_activity enable row level security;
alter table public.lat_scores   enable row level security;
alter table public.lat_recipes  enable row level security;
alter table public.lat_recipe_progress enable row level security;
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

drop policy if exists "recipes read"  on public.lat_recipes;
drop policy if exists "recipes admin" on public.lat_recipes;
create policy "recipes read"  on public.lat_recipes for select to authenticated using (true);
create policy "recipes admin" on public.lat_recipes for all to authenticated using (public.lat_is_admin()) with check (public.lat_is_admin());

drop policy if exists "recipe progress own" on public.lat_recipe_progress;
create policy "recipe progress own" on public.lat_recipe_progress
  for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "verbs read"  on public.lat_verbs;
drop policy if exists "verbs admin" on public.lat_verbs;
create policy "verbs read"  on public.lat_verbs for select to authenticated using (true);
create policy "verbs admin" on public.lat_verbs for all to authenticated using (public.lat_is_admin()) with check (public.lat_is_admin());

drop policy if exists "admins read self" on public.lat_admins;
create policy "admins read self" on public.lat_admins for select to authenticated using (user_id = auth.uid());

drop policy if exists "decks admin"   on public.lat_decks;
drop policy if exists "cards admin"   on public.lat_cards;
drop policy if exists "grammar admin" on public.lat_grammar_items;
create policy "decks admin"   on public.lat_decks         for all to authenticated using (public.lat_is_admin()) with check (public.lat_is_admin());
create policy "cards admin"   on public.lat_cards         for all to authenticated using (public.lat_is_admin()) with check (public.lat_is_admin());
create policy "grammar admin" on public.lat_grammar_items for all to authenticated using (public.lat_is_admin()) with check (public.lat_is_admin());

-- Lični podaci: svako vidi i menja samo svoje.
drop policy if exists "progress own"  on public.lat_progress;
drop policy if exists "settings own"  on public.lat_user_settings;
drop policy if exists "stats own"     on public.lat_stats;
drop policy if exists "activity own"  on public.lat_activity;
drop policy if exists "scores own"    on public.lat_scores;
create policy "scores own" on public.lat_scores
  for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "activity own" on public.lat_activity
  for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "progress own" on public.lat_progress
  for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "settings own" on public.lat_user_settings
  for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "stats own" on public.lat_stats
  for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
