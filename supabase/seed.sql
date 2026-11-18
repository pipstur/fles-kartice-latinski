-- GENERISANO iz seed/decks.json (npm run seed). Ne menjaj ručno.

insert into public.lat_decks (slug, title, description, theme, icon, has_symbols, sort_order)
values ('osnovni', 'Osnovni termini', 'Pozdravi i svakodnevne reči za početak.', 'basic', '🌱', false, 0)
on conflict (slug) do update set title = excluded.title, description = excluded.description,
  theme = excluded.theme, icon = excluded.icon, has_symbols = excluded.has_symbols, sort_order = excluded.sort_order;

insert into public.lat_cards (deck_id, latin, serbian, note, example, symbol, position)
select (select id from public.lat_decks where slug = 'osnovni'), v.*
from (values
  ('salve', 'zdravo, pozdrav', 'pozdrav jednoj osobi; mnoštvo: salvete', null, null, 0),
  ('vale', 'zbogom, ostaj zdravo', 'mnoštvo: valete', null, null, 1),
  ('gratias', 'hvala', 'gratias tibi ago = zahvaljujem ti', null, null, 2),
  ('aqua', 'voda', 'f., gen. aquae', null, null, 3),
  ('panis', 'hleb', 'm., gen. panis', null, null, 4),
  ('vinum', 'vino', 'n., gen. vini', null, null, 5),
  ('domus', 'kuća, dom', 'f., gen. domus', null, null, 6),
  ('amicus', 'prijatelj', 'm., gen. amici', null, null, 7),
  ('puella', 'devojčica, devojka', 'f., gen. puellae', null, null, 8),
  ('puer', 'dečak', 'm., gen. pueri', null, null, 9),
  ('terra', 'zemlja', 'f., gen. terrae', null, null, 10),
  ('homo', 'čovek', 'm., gen. hominis', null, null, 11),
  ('vita', 'život', 'f., gen. vitae', null, null, 12),
  ('amor', 'ljubav', 'm., gen. amoris', null, null, 13),
  ('lupus', 'vuk', 'm., gen. lupi', null, null, 14)
) as v(latin, serbian, note, example, symbol, position)
on conflict (deck_id, latin) do update set serbian = excluded.serbian, note = excluded.note,
  example = excluded.example, symbol = excluded.symbol, position = excluded.position;

insert into public.lat_decks (slug, title, description, theme, icon, has_symbols, sort_order)
values ('napredni', 'Napredni termini', 'Apstraktni pojmovi koji se stalno javljaju u tekstovima.', 'advanced', '🏛️', false, 1)
on conflict (slug) do update set title = excluded.title, description = excluded.description,
  theme = excluded.theme, icon = excluded.icon, has_symbols = excluded.has_symbols, sort_order = excluded.sort_order;

insert into public.lat_cards (deck_id, latin, serbian, note, example, symbol, position)
select (select id from public.lat_decks where slug = 'napredni'), v.*
from (values
  ('veritas', 'istina', 'f., gen. veritatis', null, null, 0),
  ('libertas', 'sloboda', 'f., gen. libertatis', null, null, 1),
  ('fortuna', 'sreća, sudbina', 'f., gen. fortunae', null, null, 2),
  ('sapientia', 'mudrost', 'f., gen. sapientiae', null, null, 3),
  ('memoria', 'sećanje', 'f., gen. memoriae', null, null, 4),
  ('iustitia', 'pravda', 'f., gen. iustitiae', null, null, 5),
  ('auctoritas', 'ugled, autoritet', 'f., gen. auctoritatis', null, null, 6),
  ('ratio', 'razum, razlog', 'f., gen. rationis', null, null, 7),
  ('virtus', 'vrlina, hrabrost', 'f., gen. virtutis', null, null, 8),
  ('voluntas', 'volja', 'f., gen. voluntatis', null, null, 9),
  ('natura', 'priroda', 'f., gen. naturae', null, null, 10),
  ('tempus', 'vreme', 'n., gen. temporis', null, null, 11)
) as v(latin, serbian, note, example, symbol, position)
on conflict (deck_id, latin) do update set serbian = excluded.serbian, note = excluded.note,
  example = excluded.example, symbol = excluded.symbol, position = excluded.position;

insert into public.lat_decks (slug, title, description, theme, icon, has_symbols, sort_order)
values ('tehnicki', 'Tehnički termini', 'Pojmovi iz nauke i tehnike.', 'technical', '⚙️', false, 2)
on conflict (slug) do update set title = excluded.title, description = excluded.description,
  theme = excluded.theme, icon = excluded.icon, has_symbols = excluded.has_symbols, sort_order = excluded.sort_order;

insert into public.lat_cards (deck_id, latin, serbian, note, example, symbol, position)
select (select id from public.lat_decks where slug = 'tehnicki'), v.*
from (values
  ('machina', 'mašina', 'f., gen. machinae', null, null, 0),
  ('vis', 'sila, snaga', 'f., gen. vis; mnoštvo vires', null, null, 1),
  ('motus', 'kretanje', 'm., gen. motus', null, null, 2),
  ('velocitas', 'brzina', 'f., gen. velocitatis', null, null, 3),
  ('pondus', 'težina', 'n., gen. ponderis', null, null, 4),
  ('pressio', 'pritisak', 'f., gen. pressionis', null, null, 5),
  ('calor', 'toplota', 'm., gen. caloris', null, null, 6),
  ('lux', 'svetlost', 'f., gen. lucis', null, null, 7),
  ('sonus', 'zvuk', 'm., gen. soni', null, null, 8),
  ('numerus', 'broj', 'm., gen. numeri', null, null, 9),
  ('mensura', 'merenje, mera', 'f., gen. mensurae', null, null, 10),
  ('experimentum', 'opit, eksperiment', 'n., gen. experimenti', null, null, 11)
) as v(latin, serbian, note, example, symbol, position)
on conflict (deck_id, latin) do update set serbian = excluded.serbian, note = excluded.note,
  example = excluded.example, symbol = excluded.symbol, position = excluded.position;

insert into public.lat_decks (slug, title, description, theme, icon, has_symbols, sort_order)
values ('alhemija', 'Alhemija', 'Elementi, metali, procesi i pojmovi Velikog dela.', 'alchemy', '⚗️', true, 3)
on conflict (slug) do update set title = excluded.title, description = excluded.description,
  theme = excluded.theme, icon = excluded.icon, has_symbols = excluded.has_symbols, sort_order = excluded.sort_order;

insert into public.lat_cards (deck_id, latin, serbian, note, example, symbol, position)
select (select id from public.lat_decks where slug = 'alhemija'), v.*
from (values
  ('aqua', 'voda', 'jedan od četiri elementa', null, '🜄', 0),
  ('ignis', 'vatra', 'jedan od četiri elementa', null, '🜂', 1),
  ('aer', 'vazduh', 'jedan od četiri elementa', null, '🜁', 2),
  ('terra', 'zemlja', 'jedan od četiri elementa', null, '🜃', 3),
  ('quinta essentia', 'peti element, kvintesencija', 'pročišćena suština koja prožima sve', null, '🜀', 4),
  ('aurum', 'zlato', 'metal Sunca', null, '☉', 5),
  ('argentum', 'srebro', 'metal Meseca', null, '☽', 6),
  ('argentum vivum', 'živa', 'doslovno „živo srebro“; metal Merkura (mercurius)', null, '☿', 7),
  ('cuprum', 'bakar', 'metal Venere', null, '♀', 8),
  ('ferrum', 'gvožđe', 'metal Marsa', null, '♂', 9),
  ('stannum', 'kalaj', 'metal Jupitera', null, '♃', 10),
  ('plumbum', 'olovo', 'metal Saturna', null, '♄', 11),
  ('sulphur', 'sumpor', 'princip goriva i duše', null, '🜍', 12),
  ('sal', 'so', 'princip tela i postojanosti', null, '🜔', 13),
  ('aqua fortis', 'azotna kiselina', 'doslovno „jaka voda“', null, '🜅', 14),
  ('aqua regia', 'carska vodica', 'rastvara zlato, „kralj metala“', null, '🜆', 15),
  ('acetum', 'sirće', 'n., gen. aceti', null, '🜊', 16),
  ('lapis philosophorum', 'kamen mudraca', 'doslovno „kamen filozofa“; cilj Velikog dela', null, null, 17),
  ('elixir vitae', 'eliksir života', 'lek koji produžava život', null, null, 18),
  ('prima materia', 'prva materija', 'polazna supstanca svega', null, null, 19),
  ('nigredo', 'crnjenje', 'prva faza Velikog dela', null, null, 20),
  ('albedo', 'beljenje', 'druga faza Velikog dela', null, null, 21),
  ('citrinitas', 'žućenje', 'treća faza Velikog dela', null, null, 22),
  ('rubedo', 'crvenjenje', 'završna faza Velikog dela', null, null, 23),
  ('opus magnum', 'veliko delo', 'n., gen. operis magni', null, null, 24),
  ('athanor', 'alhemijska peć', 'arapskog porekla (at-tannur), uobičajen u latinskim spisima', null, null, 25),
  ('alembicus', 'alembik', 'sud za destilaciju; arapskog porekla (al-anbiq)', null, null, 26),
  ('retorta', 'retorta', 'f., gen. retortae', null, null, 27),
  ('crucibulum', 'lončić za topljenje', 'n., gen. crucibuli', null, null, 28),
  ('distillatio', 'destilacija', 'f., gen. distillationis', null, null, 29),
  ('sublimatio', 'sublimacija', 'f., gen. sublimationis', null, null, 30),
  ('calcinatio', 'kalcinacija', 'žarenje do belog praha; f., gen. calcinationis', null, null, 31),
  ('solutio', 'rastvaranje', 'f., gen. solutionis', null, null, 32),
  ('coagulatio', 'zgrušavanje, koagulacija', 'f., gen. coagulationis', null, null, 33),
  ('fermentatio', 'vrenje, fermentacija', 'f., gen. fermentationis', null, null, 34),
  ('putrefactio', 'truljenje', 'f., gen. putrefactionis', null, null, 35),
  ('coniunctio', 'spajanje', 'spajanje suprotnosti; f., gen. coniunctionis', null, null, 36),
  ('separatio', 'razdvajanje', 'f., gen. separationis', null, null, 37),
  ('transmutatio', 'pretvaranje, transmutacija', 'npr. olova u zlato; f., gen. transmutationis', null, null, 38),
  ('homunculus', 'čovečuljak', 'veštački stvoreno biće; m., gen. homunculi', null, null, 39),
  ('panacea', 'lek za sve bolesti', 'f., gen. panaceae', null, null, 40),
  ('alkahest', 'univerzalni rastvarač', 'pojam koji je uveo Paracelzus', null, null, 41),
  ('vitriolum', 'vitriol', 'sulfati metala, kasnije sumporna kiselina; n., gen. vitrioli', null, null, 42),
  ('antimonium', 'antimon', 'n., gen. antimonii', null, null, 43),
  ('arsenicum', 'arsen', 'n., gen. arsenici', null, null, 44),
  ('spiritus', 'duh, isparljiva suština', 'm., gen. spiritus', null, null, 45),
  ('tinctura', 'tinktura, bojenje', 'f., gen. tincturae', null, null, 46),
  ('sol', 'Sunce', 'm., gen. solis; alhemijski znak zlata', null, '☉', 47),
  ('luna', 'Mesec', 'f., gen. lunae; alhemijski znak srebra', null, '☽', 48),
  ('ouroboros', 'zmija koja jede svoj rep', 'grčki izraz; znak večnog kruženja', null, null, 49)
) as v(latin, serbian, note, example, symbol, position)
on conflict (deck_id, latin) do update set serbian = excluded.serbian, note = excluded.note,
  example = excluded.example, symbol = excluded.symbol, position = excluded.position;

