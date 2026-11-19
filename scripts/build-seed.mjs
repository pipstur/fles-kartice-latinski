// Pravi supabase/seed.sql iz seed/decks.json.
// Pokretanje: npm run seed
// SQL koristi "upsert", pa ga je bezbedno pokretati ponovo posle ispravki u JSON-u.
import { readFileSync, writeFileSync } from 'node:fs'

const decks = JSON.parse(readFileSync(new URL('../seed/decks.json', import.meta.url), 'utf8'))

const q = (v) => (v == null ? 'null' : `'${String(v).replaceAll("'", "''")}'`)

let sql = '-- GENERISANO iz seed/decks.json (npm run seed). Ne menjaj ručno.\n\n'

decks.forEach((d, i) => {
  sql +=
    `insert into public.lat_decks (slug, title, description, theme, icon, has_symbols, sort_order)\n` +
    `values (${q(d.slug)}, ${q(d.title)}, ${q(d.description)}, ${q(d.theme)}, ${q(d.icon)}, ${d.has_symbols}, ${i})\n` +
    `on conflict (slug) do update set title = excluded.title, description = excluded.description,\n` +
    `  theme = excluded.theme, icon = excluded.icon, has_symbols = excluded.has_symbols, sort_order = excluded.sort_order;\n\n`

  const rows = d.cards.map(
    (c, pos) =>
      `  (${q(c.latin)}, ${q(c.serbian)}, ${q(c.note)}, ${q(c.example)}, ${q(c.symbol)}, ${pos})`,
  )
  sql +=
    `insert into public.lat_cards (deck_id, latin, serbian, note, example, symbol, position)\n` +
    `select (select id from public.lat_decks where slug = ${q(d.slug)}), v.*\n` +
    `from (values\n${rows.join(',\n')}\n) as v(latin, serbian, note, example, symbol, position)\n` +
    `on conflict (deck_id, latin) do update set serbian = excluded.serbian, note = excluded.note,\n` +
    `  example = excluded.example, symbol = excluded.symbol, position = excluded.position;\n\n`
})

// ------------------------------------------------ vežba padeža (seed/grammar.json)
const grammar = JSON.parse(readFileSync(new URL('../seed/grammar.json', import.meta.url), 'utf8'))
const CASE_IDX = { nom: 0, gen: 1, dat: 2, acc: 3, abl: 4 }
const arr = (list) => `array[${list.map(q).join(', ')}]::text[]`
let sentenceCount = 0
const seenSentences = new Set()

for (const l of grammar.lemmas) {
  if (l.forms.length !== 10) throw new Error(`${l.lemma}: treba 10 oblika, ima ${l.forms.length}`)
  const forms = [...new Set(l.forms)]
  for (const s of l.sentences) {
    if (s.text.split('___').length !== 2) throw new Error(`"${s.text}": treba tačno jedno ___`)
    if (seenSentences.has(s.text)) throw new Error(`"${s.text}": rečenica se ponavlja (mora biti jedinstvena)`)
    seenSentences.add(s.text)
    const idx = CASE_IDX[s.case] + (s.number === 'pl' ? 5 : 0)
    if (CASE_IDX[s.case] === undefined) throw new Error(`"${s.text}": nepoznat padež ${s.case}`)
    sql +=
      `insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)\n` +
      `values (${q(s.text)}, ${q(l.forms[idx])}, ${q(l.lemma)}, ${q(l.gloss)}, ${q(s.case)}, ${q(s.number)}, ${q(s.tr)}, ${arr(forms)})\n` +
      `on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,\n` +
      `  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;\n\n`
    sentenceCount++
  }
}

// --------------------------------------------- konjugacija (seed/verbs.json)
// Nastavci za pravilne glagole, redom 1.-3. lice jednine pa množine.
const ENDINGS = {
  1: { praes: ['o', 'as', 'at', 'amus', 'atis', 'ant'], impf: ['abam', 'abas', 'abat', 'abamus', 'abatis', 'abant'], fut: ['abo', 'abis', 'abit', 'abimus', 'abitis', 'abunt'] },
  2: { praes: ['eo', 'es', 'et', 'emus', 'etis', 'ent'], impf: ['ebam', 'ebas', 'ebat', 'ebamus', 'ebatis', 'ebant'], fut: ['ebo', 'ebis', 'ebit', 'ebimus', 'ebitis', 'ebunt'] },
  3: { praes: ['o', 'is', 'it', 'imus', 'itis', 'unt'], impf: ['ebam', 'ebas', 'ebat', 'ebamus', 'ebatis', 'ebant'], fut: ['am', 'es', 'et', 'emus', 'etis', 'ent'] },
  '3io': { praes: ['io', 'is', 'it', 'imus', 'itis', 'iunt'], impf: ['iebam', 'iebas', 'iebat', 'iebamus', 'iebatis', 'iebant'], fut: ['iam', 'ies', 'iet', 'iemus', 'ietis', 'ient'] },
  4: { praes: ['io', 'is', 'it', 'imus', 'itis', 'iunt'], impf: ['iebam', 'iebas', 'iebat', 'iebamus', 'iebatis', 'iebant'], fut: ['iam', 'ies', 'iet', 'iemus', 'ietis', 'ient'] },
}
const PERF_ENDINGS = ['i', 'isti', 'it', 'imus', 'istis', 'erunt']

const verbData = JSON.parse(readFileSync(new URL('../seed/verbs.json', import.meta.url), 'utf8'))
const verbs = [
  ...verbData.regular.map((v) => {
    const e = ENDINGS[v.conj]
    if (!e) throw new Error(`${v.lemma}: nepoznata konjugacija ${v.conj}`)
    const make = (list) => list.map((end) => v.stem + end)
    return {
      lemma: v.lemma, gloss: v.gloss, inf: v.inf, conj: v.conj,
      forms: { praes: make(e.praes), impf: make(e.impf), fut: make(e.fut), perf: PERF_ENDINGS.map((end) => v.perf + end) },
    }
  }),
  ...verbData.irregular.map((v) => ({ lemma: v.lemma, gloss: v.gloss, inf: v.inf, conj: 'irreg', forms: v.forms })),
]

for (const v of verbs) {
  for (const t of ['praes', 'impf', 'fut', 'perf']) {
    if (!Array.isArray(v.forms[t]) || v.forms[t].length !== 6) throw new Error(`${v.lemma}: ${t} treba 6 oblika`)
  }
  if (v.forms.praes[0] !== v.lemma) throw new Error(`${v.lemma}: 1. lice prezenta je "${v.forms.praes[0]}", ne poklapa se sa lemom`)
  sql +=
    `insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)\n` +
    `values (${q(v.lemma)}, ${q(v.gloss)}, ${q(v.inf)}, ${q(v.conj)}, ${q(JSON.stringify(v.forms))}::jsonb)\n` +
    `on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,\n` +
    `  conj = excluded.conj, forms = excluded.forms;\n\n`
}

// ----------------------------------- alhemijska laboratorija (seed/recipes.json)
// Svaki traženi pojam mora postojati u dekovima: ili u seed/decks.json (Alhemija) ili u import/alhemija-2.txt.
const known = new Set(decks.find((d) => d.slug === 'alhemija').cards.map((c) => c.latin))
for (const line of readFileSync(new URL('../import/alhemija-2.txt', import.meta.url), 'utf8').split('\n')) {
  const word = line.split(';')[0].trim()
  if (word) known.add(word)
}

const recipeData = JSON.parse(readFileSync(new URL('../seed/recipes.json', import.meta.url), 'utf8'))
const slugs = new Set()
recipeData.recipes.forEach((r, i) => {
  if (slugs.has(r.slug)) throw new Error(`recept ${r.slug}: ponavlja se slug`)
  slugs.add(r.slug)
  if (!r.steps?.length) throw new Error(`recept ${r.slug}: nema koraka`)
  for (const s of r.steps) {
    if (!s.prompt || !s.answer) throw new Error(`recept ${r.slug}: korak bez prompt/answer`)
    if (!known.has(s.answer)) throw new Error(`recept ${r.slug}: "${s.answer}" ne postoji u dekovima (proveri pravopis ili dodaj karticu)`)
  }
  const answers = r.steps.map((s) => s.answer)
  if (new Set(answers).size !== answers.length) throw new Error(`recept ${r.slug}: isti odgovor se ponavlja`)
  sql +=
    `insert into public.lat_recipes (slug, title, intro, icon, product, product_symbol, colors, steps, sort_order)\n` +
    `values (${q(r.slug)}, ${q(r.title)}, ${q(r.intro)}, ${q(r.icon)}, ${q(r.product)}, ${q(r.product_symbol)}, ` +
    `${r.colors ? q(JSON.stringify(r.colors)) + '::jsonb' : 'null'}, ${q(JSON.stringify(r.steps))}::jsonb, ${i})\n` +
    `on conflict (slug) do update set title = excluded.title, intro = excluded.intro, icon = excluded.icon,\n` +
    `  product = excluded.product, product_symbol = excluded.product_symbol, colors = excluded.colors,\n` +
    `  steps = excluded.steps, sort_order = excluded.sort_order;\n\n`
})

writeFileSync(new URL('../supabase/seed.sql', import.meta.url), sql)
console.log(`recepata: ${recipeData.recipes.length}, koraka: ${recipeData.recipes.reduce((n, r) => n + r.steps.length, 0)}`)
if (process.argv.includes('--show')) for (const v of verbs) console.log(v.lemma.padEnd(8), JSON.stringify(v.forms))
console.log(
  `seed.sql: ${decks.length} dekova, ${decks.reduce((n, d) => n + d.cards.length, 0)} kartica, ${sentenceCount} rečenica za padeže, ${verbs.length} glagola`,
)
