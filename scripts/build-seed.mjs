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

for (const l of grammar.lemmas) {
  if (l.forms.length !== 10) throw new Error(`${l.lemma}: treba 10 oblika, ima ${l.forms.length}`)
  const forms = [...new Set(l.forms)]
  for (const s of l.sentences) {
    if (s.text.split('___').length !== 2) throw new Error(`"${s.text}": treba tačno jedno ___`)
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

writeFileSync(new URL('../supabase/seed.sql', import.meta.url), sql)
console.log(
  `seed.sql: ${decks.length} dekova, ${decks.reduce((n, d) => n + d.cards.length, 0)} kartica, ${sentenceCount} rečenica za padeže`,
)
