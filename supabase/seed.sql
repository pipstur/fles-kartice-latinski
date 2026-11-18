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
  ('lupus', 'vuk', 'm., gen. lupi', null, null, 14),
  ('rosa', 'ruža', 'f., gen. rosae', null, null, 15),
  ('via', 'put, ulica', 'f., gen. viae', null, null, 16),
  ('silva', 'šuma', 'f., gen. silvae', null, null, 17),
  ('insula', 'ostrvo', 'f., gen. insulae', null, null, 18),
  ('familia', 'porodica', 'f., gen. familiae', null, null, 19),
  ('pater', 'otac', 'm., gen. patris', null, null, 20),
  ('mater', 'majka', 'f., gen. matris', null, null, 21),
  ('frater', 'brat', 'm., gen. fratris', null, null, 22),
  ('soror', 'sestra', 'f., gen. sororis', null, null, 23),
  ('filius', 'sin', 'm., gen. filii', null, null, 24),
  ('filia', 'ćerka', 'f., gen. filiae', null, null, 25),
  ('rex', 'kralj', 'm., gen. regis', null, null, 26),
  ('miles', 'vojnik', 'm., gen. militis', null, null, 27),
  ('urbs', 'grad', 'f., gen. urbis', null, null, 28),
  ('civis', 'građanin, građanka', 'm./f., gen. civis', null, null, 29),
  ('nomen', 'ime', 'n., gen. nominis', null, null, 30),
  ('manus', 'ruka', 'f., gen. manus', null, null, 31),
  ('oculus', 'oko', 'm., gen. oculi', null, null, 32),
  ('caput', 'glava', 'n., gen. capitis', null, null, 33),
  ('cor', 'srce', 'n., gen. cordis', null, null, 34),
  ('pes', 'stopalo, noga', 'm., gen. pedis', null, null, 35),
  ('dies', 'dan', 'm., gen. diei', null, null, 36),
  ('nox', 'noć', 'f., gen. noctis', null, null, 37),
  ('annus', 'godina', 'm., gen. anni', null, null, 38),
  ('mare', 'more', 'n., gen. maris', null, null, 39),
  ('flumen', 'reka', 'n., gen. fluminis', null, null, 40),
  ('mons', 'planina, brdo', 'm., gen. montis', null, null, 41),
  ('equus', 'konj', 'm., gen. equi', null, null, 42),
  ('canis', 'pas', 'm./f., gen. canis', null, null, 43),
  ('avis', 'ptica', 'f., gen. avis', null, null, 44),
  ('liber', 'knjiga', 'm., gen. libri', null, null, 45),
  ('bonus', 'dobar', 'bonus, bona, bonum', null, null, 46),
  ('malus', 'loš', 'malus, mala, malum', null, null, 47),
  ('magnus', 'velik', 'magnus, magna, magnum', null, null, 48),
  ('parvus', 'mali', 'parvus, parva, parvum', null, null, 49),
  ('novus', 'nov', 'novus, nova, novum', null, null, 50),
  ('antiquus', 'star, drevan', 'antiquus, antiqua, antiquum', null, null, 51),
  ('altus', 'visok, dubok', 'altus, alta, altum', null, null, 52),
  ('longus', 'dug', 'longus, longa, longum', null, null, 53),
  ('pulcher', 'lep', 'pulcher, pulchra, pulchrum', null, null, 54),
  ('amo', 'volim', 'inf. amare', null, null, 55),
  ('video', 'vidim', 'inf. videre', null, null, 56),
  ('audio', 'čujem, slušam', 'inf. audire', null, null, 57),
  ('scribo', 'pišem', 'inf. scribere', null, null, 58),
  ('lego', 'čitam', 'inf. legere', null, null, 59),
  ('sum', 'jesam, postojim', 'inf. esse', null, null, 60),
  ('habeo', 'imam', 'inf. habere', null, null, 61),
  ('do', 'dajem', 'inf. dare', null, null, 62),
  ('venio', 'dolazim', 'inf. venire', null, null, 63),
  ('vivo', 'živim', 'inf. vivere', null, null, 64),
  ('dico', 'kažem', 'inf. dicere', null, null, 65),
  ('facio', 'pravim, činim', 'inf. facere', null, null, 66)
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
  ('tempus', 'vreme', 'n., gen. temporis', null, null, 11),
  ('amicitia', 'prijateljstvo', 'f., gen. amicitiae', null, null, 12),
  ('pax', 'mir', 'f., gen. pacis', null, null, 13),
  ('bellum', 'rat', 'n., gen. belli', null, null, 14),
  ('lex', 'zakon', 'f., gen. legis', null, null, 15),
  ('ius', 'pravo', 'n., gen. iuris', null, null, 16),
  ('res publica', 'država', 'doslovno „javna stvar“; f., gen. rei publicae', null, null, 17),
  ('populus', 'narod', 'm., gen. populi', null, null, 18),
  ('civitas', 'građanska zajednica, država', 'f., gen. civitatis', null, null, 19),
  ('senatus', 'senat', 'm., gen. senatus', null, null, 20),
  ('imperium', 'vlast, carstvo', 'n., gen. imperii', null, null, 21),
  ('potestas', 'moć, vlast', 'f., gen. potestatis', null, null, 22),
  ('gloria', 'slava', 'f., gen. gloriae', null, null, 23),
  ('honor', 'čast', 'm., gen. honoris', null, null, 24),
  ('dignitas', 'dostojanstvo', 'f., gen. dignitatis', null, null, 25),
  ('spes', 'nada', 'f., gen. spei', null, null, 26),
  ('fides', 'vera, poverenje', 'f., gen. fidei', null, null, 27),
  ('mors', 'smrt', 'f., gen. mortis', null, null, 28),
  ('animus', 'duh, razum, hrabrost', 'm., gen. animi', null, null, 29),
  ('anima', 'duša, dah', 'f., gen. animae', null, null, 30),
  ('mens', 'um', 'f., gen. mentis', null, null, 31),
  ('corpus', 'telo', 'n., gen. corporis', null, null, 32),
  ('scientia', 'znanje', 'f., gen. scientiae', null, null, 33),
  ('doctrina', 'učenje, nauka', 'f., gen. doctrinae', null, null, 34),
  ('philosophia', 'filozofija', 'f., gen. philosophiae', null, null, 35),
  ('deus', 'bog', 'm., gen. dei', null, null, 36),
  ('mundus', 'svet, vasiona', 'm., gen. mundi', null, null, 37),
  ('causa', 'uzrok, razlog', 'f., gen. causae', null, null, 38),
  ('exemplum', 'primer', 'n., gen. exempli', null, null, 39),
  ('cogito', 'mislim, razmišljam', 'inf. cogitare', null, null, 40),
  ('intellego', 'razumem', 'inf. intellegere', null, null, 41),
  ('sentio', 'osećam, mislim', 'inf. sentire', null, null, 42),
  ('credo', 'verujem', 'inf. credere', null, null, 43)
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
  ('experimentum', 'opit, eksperiment', 'n., gen. experimenti', null, null, 11),
  ('ars', 'umetnost, veština', 'f., gen. artis', null, null, 12),
  ('instrumentum', 'alat, sprava', 'n., gen. instrumenti', null, null, 13),
  ('structura', 'građenje, sklop', 'f., gen. structurae', null, null, 14),
  ('forma', 'oblik', 'f., gen. formae', null, null, 15),
  ('figura', 'lik, oblik', 'f., gen. figurae', null, null, 16),
  ('linea', 'linija', 'f., gen. lineae', null, null, 17),
  ('punctum', 'tačka', 'n., gen. puncti', null, null, 18),
  ('circulus', 'krug', 'm., gen. circuli', null, null, 19),
  ('angulus', 'ugao', 'm., gen. anguli', null, null, 20),
  ('spatium', 'prostor, razmak', 'n., gen. spatii', null, null, 21),
  ('locus', 'mesto', 'm., gen. loci', null, null, 22),
  ('ventus', 'vetar', 'm., gen. venti', null, null, 23),
  ('liquor', 'tečnost', 'm., gen. liquoris', null, null, 24),
  ('materia', 'materija, građa', 'f., gen. materiae', null, null, 25),
  ('metallum', 'metal, rudnik', 'n., gen. metalli', null, null, 26),
  ('lignum', 'drvo (građa)', 'n., gen. ligni', null, null, 27),
  ('vitrum', 'staklo', 'n., gen. vitri', null, null, 28),
  ('magnes', 'magnet', 'm., gen. magnetis', null, null, 29),
  ('vacuum', 'praznina, vakuum', 'n., gen. vacui; u ovom značenju novolatinski', null, null, 30),
  ('gradus', 'stepen, korak', 'm., gen. gradus', null, null, 31),
  ('summa', 'zbir, ukupno', 'f., gen. summae', null, null, 32),
  ('additio', 'sabiranje', 'f., gen. additionis', null, null, 33),
  ('subtractio', 'oduzimanje', 'f., gen. subtractionis', null, null, 34),
  ('multiplicatio', 'množenje', 'f., gen. multiplicationis', null, null, 35),
  ('divisio', 'deljenje', 'f., gen. divisionis', null, null, 36),
  ('rota', 'točak', 'f., gen. rotae', null, null, 37),
  ('axis', 'osovina, osa', 'm., gen. axis', null, null, 38),
  ('calculus', 'kamenčić, račun', 'm., gen. calculi; kamenčići su se koristili za računanje', null, null, 39)
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

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ in horto ambulat.', 'puella', 'puella', 'devojčica', 'nom', 'sg', 'Devojčica šeta u vrtu.', array['puella', 'puellae', 'puellam', 'puellarum', 'puellis', 'puellas']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Pater ___ donum dat.', 'puellae', 'puella', 'devojčica', 'dat', 'sg', 'Otac daje dar devojčici.', array['puella', 'puellae', 'puellam', 'puellarum', 'puellis', 'puellas']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Puer ___ videt.', 'puellam', 'puella', 'devojčica', 'acc', 'sg', 'Dečak vidi devojčicu.', array['puella', 'puellae', 'puellam', 'puellarum', 'puellis', 'puellas']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ pulchra est.', 'rosa', 'rosa', 'ruža', 'nom', 'sg', 'Ruža je lepa.', array['rosa', 'rosae', 'rosam', 'rosarum', 'rosis', 'rosas']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Puella ___ amat.', 'rosas', 'rosa', 'ruža', 'acc', 'pl', 'Devojčica voli ruže.', array['rosa', 'rosae', 'rosam', 'rosarum', 'rosis', 'rosas']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Pulchritudo ___ magna est.', 'rosae', 'rosa', 'ruža', 'gen', 'sg', 'Lepota ruže je velika.', array['rosa', 'rosae', 'rosam', 'rosarum', 'rosis', 'rosas']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Puella ___ aquam dat.', 'rosae', 'rosa', 'ruža', 'dat', 'sg', 'Devojčica daje vodu ruži.', array['rosa', 'rosae', 'rosam', 'rosarum', 'rosis', 'rosas']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Puella cum ___ in horto sedet.', 'rosa', 'rosa', 'ruža', 'abl', 'sg', 'Devojčica sedi u vrtu sa ružom.', array['rosa', 'rosae', 'rosam', 'rosarum', 'rosis', 'rosas']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ in horto sunt.', 'rosae', 'rosa', 'ruža', 'nom', 'pl', 'Ruže su u vrtu.', array['rosa', 'rosae', 'rosam', 'rosarum', 'rosis', 'rosas']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Piscis in ___ natat.', 'aqua', 'aqua', 'voda', 'abl', 'sg', 'Riba pliva u vodi.', array['aqua', 'aquae', 'aquam', 'aquarum', 'aquis', 'aquas']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Copia ___ magna est.', 'aquae', 'aqua', 'voda', 'gen', 'sg', 'Ima mnogo vode (obilje vode je veliko).', array['aqua', 'aquae', 'aquam', 'aquarum', 'aquis', 'aquas']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ in flumine est.', 'aqua', 'aqua', 'voda', 'nom', 'sg', 'Voda je u reci.', array['aqua', 'aquae', 'aquam', 'aquarum', 'aquis', 'aquas']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Puer ___ bibit.', 'aquam', 'aqua', 'voda', 'acc', 'sg', 'Dečak pije vodu.', array['aqua', 'aquae', 'aquam', 'aquarum', 'aquis', 'aquas']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('In ___ ambulo.', 'via', 'via', 'put, ulica', 'abl', 'sg', 'Hodam putem (po putu).', array['via', 'viae', 'viam', 'viarum', 'viis', 'vias']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ longa est.', 'via', 'via', 'put, ulica', 'nom', 'sg', 'Put je dug.', array['via', 'viae', 'viam', 'viarum', 'viis', 'vias']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Milites ___ muniunt.', 'viam', 'via', 'put, ulica', 'acc', 'sg', 'Vojnici grade (utvrđuju) put.', array['via', 'viae', 'viam', 'viarum', 'viis', 'vias']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Longitudo ___ magna est.', 'viae', 'via', 'put, ulica', 'gen', 'sg', 'Dužina puta je velika.', array['via', 'viae', 'viam', 'viarum', 'viis', 'vias']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Nautae ___ vident.', 'terram', 'terra', 'zemlja', 'acc', 'sg', 'Mornari vide zemlju.', array['terra', 'terrae', 'terram', 'terrarum', 'terris', 'terras']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Incolae ___ laborant.', 'terrae', 'terra', 'zemlja', 'gen', 'sg', 'Stanovnici zemlje rade.', array['terra', 'terrae', 'terram', 'terrarum', 'terris', 'terras']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ multae sunt.', 'terrae', 'terra', 'zemlja', 'nom', 'pl', 'Ima mnogo zemalja.', array['terra', 'terrae', 'terram', 'terrarum', 'terris', 'terras']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Domus ___ magna est.', 'amici', 'amicus', 'prijatelj', 'gen', 'sg', 'Prijateljeva kuća je velika.', array['amicus', 'amici', 'amico', 'amicum', 'amicorum', 'amicis', 'amicos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Puella rosam ___ dat.', 'amico', 'amicus', 'prijatelj', 'dat', 'sg', 'Devojčica daje ružu prijatelju.', array['amicus', 'amici', 'amico', 'amicum', 'amicorum', 'amicis', 'amicos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Puella cum ___ ambulat.', 'amico', 'amicus', 'prijatelj', 'abl', 'sg', 'Devojčica šeta sa prijateljem.', array['amicus', 'amici', 'amico', 'amicum', 'amicorum', 'amicis', 'amicos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Cum ___ in silva ambulo.', 'amicis', 'amicus', 'prijatelj', 'abl', 'pl', 'Sa prijateljima šetam u šumi.', array['amicus', 'amici', 'amico', 'amicum', 'amicorum', 'amicis', 'amicos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Nomina ___ scio.', 'amicorum', 'amicus', 'prijatelj', 'gen', 'pl', 'Znam imena prijatelja.', array['amicus', 'amici', 'amico', 'amicum', 'amicorum', 'amicis', 'amicos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ me amat.', 'amicus', 'amicus', 'prijatelj', 'nom', 'sg', 'Prijatelj me voli.', array['amicus', 'amici', 'amico', 'amicum', 'amicorum', 'amicis', 'amicos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Pueri ___ amant.', 'amicos', 'amicus', 'prijatelj', 'acc', 'pl', 'Dečaci vole prijatelje.', array['amicus', 'amici', 'amico', 'amicum', 'amicorum', 'amicis', 'amicos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ in villa sunt.', 'amici', 'amicus', 'prijatelj', 'nom', 'pl', 'Prijatelji su u vili.', array['amicus', 'amici', 'amico', 'amicum', 'amicorum', 'amicis', 'amicos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Dominus ___ vinum dat.', 'amicis', 'amicus', 'prijatelj', 'dat', 'pl', 'Gospodar daje vino prijateljima.', array['amicus', 'amici', 'amico', 'amicum', 'amicorum', 'amicis', 'amicos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ in agro laborant.', 'servi', 'servus', 'rob, sluga', 'nom', 'pl', 'Robovi rade na polju.', array['servus', 'servi', 'servo', 'servum', 'servorum', 'servis', 'servos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Dominus ___ vocat.', 'servos', 'servus', 'rob, sluga', 'acc', 'pl', 'Gospodar zove robove.', array['servus', 'servi', 'servo', 'servum', 'servorum', 'servis', 'servos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ in horto laborat.', 'servus', 'servus', 'rob, sluga', 'nom', 'sg', 'Rob radi u vrtu.', array['servus', 'servi', 'servo', 'servum', 'servorum', 'servis', 'servos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Dominus ___ librum dat.', 'servo', 'servus', 'rob, sluga', 'dat', 'sg', 'Gospodar daje knjigu robu.', array['servus', 'servi', 'servo', 'servum', 'servorum', 'servis', 'servos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Dominus cum ___ in agrum it.', 'servo', 'servus', 'rob, sluga', 'abl', 'sg', 'Gospodar ide u polje sa robom.', array['servus', 'servi', 'servo', 'servum', 'servorum', 'servis', 'servos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Vita ___ dura est.', 'servorum', 'servus', 'rob, sluga', 'gen', 'pl', 'Život robova je težak.', array['servus', 'servi', 'servo', 'servum', 'servorum', 'servis', 'servos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Agricola ___ videt.', 'lupum', 'lupus', 'vuk', 'acc', 'sg', 'Zemljoradnik vidi vuka.', array['lupus', 'lupi', 'lupo', 'lupum', 'luporum', 'lupis', 'lupos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ in silva habitat.', 'lupus', 'lupus', 'vuk', 'nom', 'sg', 'Vuk živi u šumi.', array['lupus', 'lupi', 'lupo', 'lupum', 'luporum', 'lupis', 'lupos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Vox ___ terribilis est.', 'lupi', 'lupus', 'vuk', 'gen', 'sg', 'Glas vuka je strašan.', array['lupus', 'lupi', 'lupo', 'lupum', 'luporum', 'lupis', 'lupos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Pastor cum ___ pugnat.', 'lupis', 'lupus', 'vuk', 'abl', 'pl', 'Pastir se bori sa vukovima.', array['lupus', 'lupi', 'lupo', 'lupum', 'luporum', 'lupis', 'lupos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Agricola in ___ laborat.', 'agro', 'ager', 'njiva, polje', 'abl', 'sg', 'Zemljoradnik radi na njivi.', array['ager', 'agri', 'agro', 'agrum', 'agrorum', 'agris', 'agros']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ magnus est.', 'ager', 'ager', 'njiva, polje', 'nom', 'sg', 'Njiva je velika.', array['ager', 'agri', 'agro', 'agrum', 'agrorum', 'agris', 'agros']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Agricola ___ colit.', 'agrum', 'ager', 'njiva, polje', 'acc', 'sg', 'Zemljoradnik obrađuje njivu.', array['ager', 'agri', 'agro', 'agrum', 'agrorum', 'agris', 'agros']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Fructus ___ bonus est.', 'agri', 'ager', 'njiva, polje', 'gen', 'sg', 'Plod njive je dobar.', array['ager', 'agri', 'agro', 'agrum', 'agrorum', 'agris', 'agros']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Liber ___ novus est.', 'pueri', 'puer', 'dečak', 'gen', 'sg', 'Dečakova knjiga je nova.', array['puer', 'pueri', 'puero', 'puerum', 'puerorum', 'pueris', 'pueros']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Magister librum ___ dat.', 'pueris', 'puer', 'dečak', 'dat', 'pl', 'Učitelj daje knjigu dečacima.', array['puer', 'pueri', 'puero', 'puerum', 'puerorum', 'pueris', 'pueros']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ librum legit.', 'puer', 'puer', 'dečak', 'nom', 'sg', 'Dečak čita knjigu.', array['puer', 'pueri', 'puero', 'puerum', 'puerorum', 'pueris', 'pueros']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Magister ___ laudat.', 'puerum', 'puer', 'dečak', 'acc', 'sg', 'Učitelj hvali dečaka.', array['puer', 'pueri', 'puero', 'puerum', 'puerorum', 'pueris', 'pueros']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Cum ___ ambulo.', 'puero', 'puer', 'dečak', 'abl', 'sg', 'Šetam sa dečakom.', array['puer', 'pueri', 'puero', 'puerum', 'puerorum', 'pueris', 'pueros']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ in schola sunt.', 'pueri', 'puer', 'dečak', 'nom', 'pl', 'Dečaci su u školi.', array['puer', 'pueri', 'puero', 'puerum', 'puerorum', 'pueris', 'pueros']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Puer matri ___ dat.', 'donum', 'donum', 'dar, poklon', 'acc', 'sg', 'Dečak daje majci dar.', array['donum', 'doni', 'dono', 'dona', 'donorum', 'donis']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ pulchrum est.', 'donum', 'donum', 'dar, poklon', 'nom', 'sg', 'Dar je lep.', array['donum', 'doni', 'dono', 'dona', 'donorum', 'donis']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Nomen ___ est Marcus.', 'regis', 'rex', 'kralj', 'gen', 'sg', 'Kraljevo ime je Marcus.', array['rex', 'regis', 'regi', 'regem', 'rege', 'reges', 'regum', 'regibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Cives ___ laudant.', 'regem', 'rex', 'kralj', 'acc', 'sg', 'Građani hvale kralja.', array['rex', 'regis', 'regi', 'regem', 'rege', 'reges', 'regum', 'regibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ in urbe habitat.', 'rex', 'rex', 'kralj', 'nom', 'sg', 'Kralj živi u gradu.', array['rex', 'regis', 'regi', 'regem', 'rege', 'reges', 'regum', 'regibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Cives ___ donum dant.', 'regi', 'rex', 'kralj', 'dat', 'sg', 'Građani daju dar kralju.', array['rex', 'regis', 'regi', 'regem', 'rege', 'reges', 'regum', 'regibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Miles cum ___ ambulat.', 'rege', 'rex', 'kralj', 'abl', 'sg', 'Vojnik šeta sa kraljem.', array['rex', 'regis', 'regi', 'regem', 'rege', 'reges', 'regum', 'regibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Historia ___ longa est.', 'regum', 'rex', 'kralj', 'gen', 'pl', 'Istorija kraljeva je duga.', array['rex', 'regis', 'regi', 'regem', 'rege', 'reges', 'regum', 'regibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ patriam amat.', 'miles', 'miles', 'vojnik', 'nom', 'sg', 'Vojnik voli domovinu.', array['miles', 'militis', 'militi', 'militem', 'milite', 'milites', 'militum', 'militibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ urbem defendunt.', 'milites', 'miles', 'vojnik', 'nom', 'pl', 'Vojnici brane grad.', array['miles', 'militis', 'militi', 'militem', 'milite', 'milites', 'militum', 'militibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Gloria ___ magna est.', 'militum', 'miles', 'vojnik', 'gen', 'pl', 'Slava vojnika je velika.', array['miles', 'militis', 'militi', 'militem', 'milite', 'milites', 'militum', 'militibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Rex cum ___ in urbem venit.', 'militibus', 'miles', 'vojnik', 'abl', 'pl', 'Kralj dolazi u grad sa vojnicima.', array['miles', 'militis', 'militi', 'militem', 'milite', 'milites', 'militum', 'militibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Rex ___ gladium dat.', 'militi', 'miles', 'vojnik', 'dat', 'sg', 'Kralj daje vojniku mač.', array['miles', 'militis', 'militi', 'militem', 'milite', 'milites', 'militum', 'militibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Rex ___ laudat.', 'militem', 'miles', 'vojnik', 'acc', 'sg', 'Kralj hvali vojnika.', array['miles', 'militis', 'militi', 'militem', 'milite', 'milites', 'militum', 'militibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Rex ___ in urbem mittit.', 'milites', 'miles', 'vojnik', 'acc', 'pl', 'Kralj šalje vojnike u grad.', array['miles', 'militis', 'militi', 'militem', 'milite', 'milites', 'militum', 'militibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Rex ___ pacem dat.', 'civibus', 'civis', 'građanin', 'dat', 'pl', 'Kralj daje građanima mir.', array['civis', 'civi', 'civem', 'cive', 'cives', 'civium', 'civibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ urbem amant.', 'cives', 'civis', 'građanin', 'nom', 'pl', 'Građani vole grad.', array['civis', 'civi', 'civem', 'cive', 'cives', 'civium', 'civibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Vox ___ magna est.', 'civium', 'civis', 'građanin', 'gen', 'pl', 'Glas građana je jak.', array['civis', 'civi', 'civem', 'cive', 'cives', 'civium', 'civibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Rex ___ videt.', 'civem', 'civis', 'građanin', 'acc', 'sg', 'Kralj vidi građanina.', array['civis', 'civi', 'civem', 'cive', 'cives', 'civium', 'civibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Rex cum ___ loquitur.', 'cive', 'civis', 'građanin', 'abl', 'sg', 'Kralj razgovara sa građaninom.', array['civis', 'civi', 'civem', 'cive', 'cives', 'civium', 'civibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Omnes ___ mortales sunt.', 'homines', 'homo', 'čovek', 'nom', 'pl', 'Svi ljudi su smrtni.', array['homo', 'hominis', 'homini', 'hominem', 'homine', 'homines', 'hominum', 'hominibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Deus ___ vitam dat.', 'hominibus', 'homo', 'čovek', 'dat', 'pl', 'Bog daje ljudima život.', array['homo', 'hominis', 'homini', 'hominem', 'homine', 'homines', 'hominum', 'hominibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ mortalis est.', 'homo', 'homo', 'čovek', 'nom', 'sg', 'Čovek je smrtan.', array['homo', 'hominis', 'homini', 'hominem', 'homine', 'homines', 'hominum', 'hominibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Vita ___ brevis est.', 'hominis', 'homo', 'čovek', 'gen', 'sg', 'Život čoveka je kratak.', array['homo', 'hominis', 'homini', 'hominem', 'homine', 'homines', 'hominum', 'hominibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Deus ___ creat.', 'hominem', 'homo', 'čovek', 'acc', 'sg', 'Bog stvara čoveka.', array['homo', 'hominis', 'homini', 'hominem', 'homine', 'homines', 'hominum', 'hominibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Cum ___ loquor.', 'homine', 'homo', 'čovek', 'abl', 'sg', 'Razgovaram sa čovekom.', array['homo', 'hominis', 'homini', 'hominem', 'homine', 'homines', 'hominum', 'hominibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Quod ___ tibi est?', 'nomen', 'nomen', 'ime', 'nom', 'sg', 'Kako ti je ime?', array['nomen', 'nominis', 'nomini', 'nomine', 'nomina', 'nominum', 'nominibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Ego ___ tuum scio.', 'nomen', 'nomen', 'ime', 'acc', 'sg', 'Znam tvoje ime.', array['nomen', 'nominis', 'nomini', 'nomine', 'nomina', 'nominum', 'nominibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Puer ___ Marcus vocatur.', 'nomine', 'nomen', 'ime', 'abl', 'sg', 'Dečak se zove Marcus.', array['nomen', 'nominis', 'nomini', 'nomine', 'nomina', 'nominum', 'nominibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Liber ___ bonus est.', 'patris', 'pater', 'otac', 'gen', 'sg', 'Očeva knjiga je dobra.', array['pater', 'patris', 'patri', 'patrem', 'patre', 'patres', 'patrum', 'patribus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ in domo est.', 'pater', 'pater', 'otac', 'nom', 'sg', 'Otac je u kući.', array['pater', 'patris', 'patri', 'patrem', 'patre', 'patres', 'patrum', 'patribus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Filius ___ librum dat.', 'patri', 'pater', 'otac', 'dat', 'sg', 'Sin daje knjigu ocu.', array['pater', 'patris', 'patri', 'patrem', 'patre', 'patres', 'patrum', 'patribus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Filia ___ videt.', 'patrem', 'pater', 'otac', 'acc', 'sg', 'Ćerka vidi oca.', array['pater', 'patris', 'patri', 'patrem', 'patre', 'patres', 'patrum', 'patribus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Filius cum ___ ambulat.', 'patre', 'pater', 'otac', 'abl', 'sg', 'Sin šeta sa ocem.', array['pater', 'patris', 'patri', 'patrem', 'patre', 'patres', 'patrum', 'patribus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ filios amant.', 'patres', 'pater', 'otac', 'nom', 'pl', 'Očevi vole sinove.', array['pater', 'patris', 'patri', 'patrem', 'patre', 'patres', 'patrum', 'patribus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Filius ___ amat.', 'matrem', 'mater', 'majka', 'acc', 'sg', 'Sin voli majku.', array['mater', 'matris', 'matri', 'matrem', 'matre', 'matres', 'matrum', 'matribus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ in horto sedet.', 'mater', 'mater', 'majka', 'nom', 'sg', 'Majka sedi u vrtu.', array['mater', 'matris', 'matri', 'matrem', 'matre', 'matres', 'matrum', 'matribus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Puella ___ rosam dat.', 'matri', 'mater', 'majka', 'dat', 'sg', 'Devojčica daje ružu majci.', array['mater', 'matris', 'matri', 'matrem', 'matre', 'matres', 'matrum', 'matribus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Amor ___ magnus est.', 'matris', 'mater', 'majka', 'gen', 'sg', 'Majčina ljubav je velika.', array['mater', 'matris', 'matri', 'matrem', 'matre', 'matres', 'matrum', 'matribus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Milites ___ capiunt.', 'urbem', 'urbs', 'grad', 'acc', 'sg', 'Vojnici zauzimaju grad.', array['urbs', 'urbis', 'urbi', 'urbem', 'urbe', 'urbes', 'urbium', 'urbibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Puer ex ___ venit.', 'urbe', 'urbs', 'grad', 'abl', 'sg', 'Dečak dolazi iz grada.', array['urbs', 'urbis', 'urbi', 'urbem', 'urbe', 'urbes', 'urbium', 'urbibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Nomen ___ est Roma.', 'urbis', 'urbs', 'grad', 'gen', 'sg', 'Ime grada je Roma.', array['urbs', 'urbis', 'urbi', 'urbem', 'urbe', 'urbes', 'urbium', 'urbibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ magna est.', 'urbs', 'urbs', 'grad', 'nom', 'sg', 'Grad je velik.', array['urbs', 'urbis', 'urbi', 'urbem', 'urbe', 'urbes', 'urbium', 'urbibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Muri ___ alti sunt.', 'urbium', 'urbs', 'grad', 'gen', 'pl', 'Zidovi gradova su visoki.', array['urbs', 'urbis', 'urbi', 'urbem', 'urbe', 'urbes', 'urbium', 'urbibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Rex multas ___ capit.', 'urbes', 'urbs', 'grad', 'acc', 'pl', 'Kralj zauzima mnoge gradove.', array['urbs', 'urbis', 'urbi', 'urbem', 'urbe', 'urbes', 'urbium', 'urbibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Naves in ___ navigant.', 'flumine', 'flumen', 'reka', 'abl', 'sg', 'Brodovi plove rekom.', array['flumen', 'fluminis', 'flumini', 'flumine', 'flumina', 'fluminum', 'fluminibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ latum est.', 'flumen', 'flumen', 'reka', 'nom', 'sg', 'Reka je široka.', array['flumen', 'fluminis', 'flumini', 'flumine', 'flumina', 'fluminum', 'fluminibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Milites ___ transeunt.', 'flumen', 'flumen', 'reka', 'acc', 'sg', 'Vojnici prelaze reku.', array['flumen', 'fluminis', 'flumini', 'flumine', 'flumina', 'fluminum', 'fluminibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Ripa ___ alta est.', 'fluminis', 'flumen', 'reka', 'gen', 'sg', 'Obala reke je visoka.', array['flumen', 'fluminis', 'flumini', 'flumine', 'flumina', 'fluminum', 'fluminibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Puella aquam ___ portat.', 'manibus', 'manus', 'ruka', 'abl', 'pl', 'Devojčica nosi vodu rukama.', array['manus', 'manui', 'manum', 'manu', 'manuum', 'manibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Puer ___ lavat.', 'manus', 'manus', 'ruka', 'acc', 'pl', 'Dečak pere ruke.', array['manus', 'manui', 'manum', 'manu', 'manuum', 'manibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ mea parva est.', 'manus', 'manus', 'ruka', 'nom', 'sg', 'Moja ruka je mala.', array['manus', 'manui', 'manum', 'manu', 'manuum', 'manibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Digiti ___ longi sunt.', 'manus', 'manus', 'ruka', 'gen', 'sg', 'Prsti ruke su dugi.', array['manus', 'manui', 'manum', 'manu', 'manuum', 'manibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Bonus ___ est.', 'dies', 'dies', 'dan', 'nom', 'sg', 'Dobar je dan.', array['dies', 'diei', 'diem', 'die', 'dierum', 'diebus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Multos ___ laboramus.', 'dies', 'dies', 'dan', 'acc', 'pl', 'Radimo mnogo dana.', array['dies', 'diei', 'diem', 'die', 'dierum', 'diebus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Lux ___ clara est.', 'diei', 'dies', 'dan', 'gen', 'sg', 'Svetlost dana je jasna.', array['dies', 'diei', 'diem', 'die', 'dierum', 'diebus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Quo ___ venis?', 'die', 'dies', 'dan', 'abl', 'sg', 'Kog dana dolaziš?', array['dies', 'diei', 'diem', 'die', 'dierum', 'diebus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ breves sunt.', 'dies', 'dies', 'dan', 'nom', 'pl', 'Dani su kratki.', array['dies', 'diei', 'diem', 'die', 'dierum', 'diebus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ in horto ludit.', 'filia', 'filia', 'ćerka', 'nom', 'sg', 'Ćerka se igra u vrtu.', array['filia', 'filiae', 'filiam', 'filiarum', 'filiabus', 'filias']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Pater ___ rosam dat.', 'filiae', 'filia', 'ćerka', 'dat', 'sg', 'Otac daje ružu ćerki.', array['filia', 'filiae', 'filiam', 'filiarum', 'filiabus', 'filias']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Mater ___ amat.', 'filiam', 'filia', 'ćerka', 'acc', 'sg', 'Majka voli ćerku.', array['filia', 'filiae', 'filiam', 'filiarum', 'filiabus', 'filias']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Mater cum ___ ambulat.', 'filia', 'filia', 'ćerka', 'abl', 'sg', 'Majka šeta sa ćerkom.', array['filia', 'filiae', 'filiam', 'filiarum', 'filiabus', 'filias']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Pater ___ rosas dat.', 'filiabus', 'filia', 'ćerka', 'dat', 'pl', 'Otac daje ruže ćerkama.', array['filia', 'filiae', 'filiam', 'filiarum', 'filiabus', 'filias']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ servum vocat.', 'dominus', 'dominus', 'gospodar', 'nom', 'sg', 'Gospodar zove roba.', array['dominus', 'domini', 'domino', 'dominum', 'dominorum', 'dominis', 'dominos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Villa ___ magna est.', 'domini', 'dominus', 'gospodar', 'gen', 'sg', 'Gospodareva vila je velika.', array['dominus', 'domini', 'domino', 'dominum', 'dominorum', 'dominis', 'dominos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Servus ___ librum dat.', 'domino', 'dominus', 'gospodar', 'dat', 'sg', 'Rob daje knjigu gospodaru.', array['dominus', 'domini', 'domino', 'dominum', 'dominorum', 'dominis', 'dominos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Servus ___ timet.', 'dominum', 'dominus', 'gospodar', 'acc', 'sg', 'Rob se plaši gospodara.', array['dominus', 'domini', 'domino', 'dominum', 'dominorum', 'dominis', 'dominos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Servus cum ___ ambulat.', 'domino', 'dominus', 'gospodar', 'abl', 'sg', 'Rob šeta sa gospodarom.', array['dominus', 'domini', 'domino', 'dominum', 'dominorum', 'dominis', 'dominos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ in mensa est.', 'liber', 'liber', 'knjiga', 'nom', 'sg', 'Knjiga je na stolu.', array['liber', 'libri', 'libro', 'librum', 'librorum', 'libris', 'libros']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Puer ___ legit.', 'librum', 'liber', 'knjiga', 'acc', 'sg', 'Dečak čita knjigu.', array['liber', 'libri', 'libro', 'librum', 'librorum', 'libris', 'libros']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Puer in ___ legit.', 'libro', 'liber', 'knjiga', 'abl', 'sg', 'Dečak čita u knjizi.', array['liber', 'libri', 'libro', 'librum', 'librorum', 'libris', 'libros']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Magister multos ___ legit.', 'libros', 'liber', 'knjiga', 'acc', 'pl', 'Učitelj čita mnoge knjige.', array['liber', 'libri', 'libro', 'librum', 'librorum', 'libris', 'libros']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Titulus ___ longus est.', 'libri', 'liber', 'knjiga', 'gen', 'sg', 'Naslov knjige je dug.', array['liber', 'libri', 'libro', 'librum', 'librorum', 'libris', 'libros']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ longum est.', 'bellum', 'bellum', 'rat', 'nom', 'sg', 'Rat je dug.', array['bellum', 'belli', 'bello', 'bella', 'bellorum', 'bellis']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Causa ___ magna est.', 'belli', 'bellum', 'rat', 'gen', 'sg', 'Uzrok rata je velik.', array['bellum', 'belli', 'bello', 'bella', 'bellorum', 'bellis']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Romani ___ gerunt.', 'bellum', 'bellum', 'rat', 'acc', 'sg', 'Rimljani vode rat.', array['bellum', 'belli', 'bello', 'bella', 'bellorum', 'bellis']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('In ___ miles pugnat.', 'bello', 'bellum', 'rat', 'abl', 'sg', 'Vojnik se bori u ratu.', array['bellum', 'belli', 'bello', 'bella', 'bellorum', 'bellis']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ bonum est.', 'verbum', 'verbum', 'reč', 'nom', 'sg', 'Reč je dobra.', array['verbum', 'verbi', 'verbo', 'verba', 'verborum', 'verbis']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Puer ___ dicit.', 'verbum', 'verbum', 'reč', 'acc', 'sg', 'Dečak izgovara reč.', array['verbum', 'verbi', 'verbo', 'verba', 'verborum', 'verbis']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Sensus ___ difficilis est.', 'verbi', 'verbum', 'reč', 'gen', 'sg', 'Smisao reči je težak.', array['verbum', 'verbi', 'verbo', 'verba', 'verborum', 'verbis']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Puer multa ___ discit.', 'verba', 'verbum', 'reč', 'acc', 'pl', 'Dečak uči mnoge reči.', array['verbum', 'verbi', 'verbo', 'verba', 'verborum', 'verbis']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ meum fessum est.', 'corpus', 'corpus', 'telo', 'nom', 'sg', 'Moje telo je umorno.', array['corpus', 'corporis', 'corpori', 'corpore', 'corpora', 'corporum', 'corporibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Pars ___ magna est.', 'corporis', 'corpus', 'telo', 'gen', 'sg', 'Deo tela je veliki.', array['corpus', 'corporis', 'corpori', 'corpore', 'corpora', 'corporum', 'corporibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Mens sana in ___ sano.', 'corpore', 'corpus', 'telo', 'abl', 'sg', 'Zdrav duh u zdravom telu.', array['corpus', 'corporis', 'corpori', 'corpore', 'corpora', 'corporum', 'corporibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Medicus ___ curat.', 'corpus', 'corpus', 'telo', 'acc', 'sg', 'Lekar leči telo.', array['corpus', 'corporis', 'corpori', 'corpore', 'corpora', 'corporum', 'corporibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ fugit.', 'tempus', 'tempus', 'vreme', 'nom', 'sg', 'Vreme beži.', array['tempus', 'temporis', 'tempori', 'tempore', 'tempora', 'temporum', 'temporibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Multum ___ habeo.', 'tempus', 'tempus', 'vreme', 'acc', 'sg', 'Imam mnogo vremena.', array['tempus', 'temporis', 'tempori', 'tempore', 'tempora', 'temporum', 'temporibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Illo ___ Roma magna erat.', 'tempore', 'tempus', 'vreme', 'abl', 'sg', 'U ono vreme Rim je bio velik.', array['tempus', 'temporis', 'tempori', 'tempore', 'tempora', 'temporum', 'temporibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ mutantur.', 'tempora', 'tempus', 'vreme', 'nom', 'pl', 'Vremena se menjaju.', array['tempus', 'temporis', 'tempori', 'tempore', 'tempora', 'temporum', 'temporibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ dura est.', 'lex', 'lex', 'zakon', 'nom', 'sg', 'Zakon je tvrd.', array['lex', 'legis', 'legi', 'legem', 'lege', 'leges', 'legum', 'legibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Cives ___ servant.', 'legem', 'lex', 'zakon', 'acc', 'sg', 'Građani poštuju zakon.', array['lex', 'legis', 'legi', 'legem', 'lege', 'leges', 'legum', 'legibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Cives ___ reguntur.', 'lege', 'lex', 'zakon', 'abl', 'sg', 'Građani se vode zakonom.', array['lex', 'legis', 'legi', 'legem', 'lege', 'leges', 'legum', 'legibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Cives ___ parent.', 'legi', 'lex', 'zakon', 'dat', 'sg', 'Građani se pokoravaju zakonu.', array['lex', 'legis', 'legi', 'legem', 'lege', 'leges', 'legum', 'legibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ bonae sunt.', 'leges', 'lex', 'zakon', 'nom', 'pl', 'Zakoni su dobri.', array['lex', 'legis', 'legi', 'legem', 'lege', 'leges', 'legum', 'legibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Scientia ___ magna est.', 'legum', 'lex', 'zakon', 'gen', 'pl', 'Znanje zakona je veliko.', array['lex', 'legis', 'legi', 'legem', 'lege', 'leges', 'legum', 'legibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ obscura est.', 'nox', 'nox', 'noć', 'nom', 'sg', 'Noć je mračna.', array['nox', 'noctis', 'nocti', 'noctem', 'nocte', 'noctes', 'noctium', 'noctibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Nautae ___ navigant.', 'nocte', 'nox', 'noć', 'abl', 'sg', 'Mornari plove noću.', array['nox', 'noctis', 'nocti', 'noctem', 'nocte', 'noctes', 'noctium', 'noctibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Multas ___ vigilo.', 'noctes', 'nox', 'noć', 'acc', 'pl', 'Bdim mnoge noći.', array['nox', 'noctis', 'nocti', 'noctem', 'nocte', 'noctes', 'noctium', 'noctibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Silentium ___ magnum est.', 'noctis', 'nox', 'noć', 'gen', 'sg', 'Tišina noći je velika.', array['nox', 'noctis', 'nocti', 'noctem', 'nocte', 'noctes', 'noctium', 'noctibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ meum dolet.', 'caput', 'caput', 'glava', 'nom', 'sg', 'Boli me glava.', array['caput', 'capitis', 'capiti', 'capite', 'capita', 'capitum', 'capitibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Corona in ___ est.', 'capite', 'caput', 'glava', 'abl', 'sg', 'Kruna je na glavi.', array['caput', 'capitis', 'capiti', 'capite', 'capita', 'capitum', 'capitibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Miles ___ tegit.', 'caput', 'caput', 'glava', 'acc', 'sg', 'Vojnik pokriva glavu.', array['caput', 'capitis', 'capiti', 'capite', 'capita', 'capitum', 'capitibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ longus est.', 'annus', 'annus', 'godina', 'nom', 'sg', 'Godina je duga.', array['annus', 'anni', 'anno', 'annum', 'annorum', 'annis', 'annos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Tres ___ laboro.', 'annos', 'annus', 'godina', 'acc', 'pl', 'Radim tri godine.', array['annus', 'anni', 'anno', 'annum', 'annorum', 'annis', 'annos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ meus bonus est.', 'oculus', 'oculus', 'oko', 'nom', 'sg', 'Moje oko je dobro.', array['oculus', 'oculi', 'oculo', 'oculum', 'oculorum', 'oculis', 'oculos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ videmus.', 'oculis', 'oculus', 'oko', 'abl', 'pl', 'Vidimo očima.', array['oculus', 'oculi', 'oculo', 'oculum', 'oculorum', 'oculis', 'oculos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Puella ___ claudit.', 'oculos', 'oculus', 'oko', 'acc', 'pl', 'Devojčica zatvara oči.', array['oculus', 'oculi', 'oculo', 'oculum', 'oculorum', 'oculis', 'oculos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ celer est.', 'equus', 'equus', 'konj', 'nom', 'sg', 'Konj je brz.', array['equus', 'equi', 'equo', 'equum', 'equorum', 'equis', 'equos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Agricola ___ amat.', 'equum', 'equus', 'konj', 'acc', 'sg', 'Zemljoradnik voli konja.', array['equus', 'equi', 'equo', 'equum', 'equorum', 'equis', 'equos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Miles ___ vehitur.', 'equo', 'equus', 'konj', 'abl', 'sg', 'Vojnik jaše konja.', array['equus', 'equi', 'equo', 'equum', 'equorum', 'equis', 'equos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Cauda ___ longa est.', 'equi', 'equus', 'konj', 'gen', 'sg', 'Rep konja je dug.', array['equus', 'equi', 'equo', 'equum', 'equorum', 'equis', 'equos']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ parva est.', 'insula', 'insula', 'ostrvo', 'nom', 'sg', 'Ostrvo je malo.', array['insula', 'insulae', 'insulam', 'insularum', 'insulis', 'insulas']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('In ___ habito.', 'insula', 'insula', 'ostrvo', 'abl', 'sg', 'Živim na ostrvu.', array['insula', 'insulae', 'insulam', 'insularum', 'insulis', 'insulas']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Romani ___ capiunt.', 'insulam', 'insula', 'ostrvo', 'acc', 'sg', 'Rimljani zauzimaju ostrvo.', array['insula', 'insulae', 'insulam', 'insularum', 'insulis', 'insulas']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ mea magna est.', 'familia', 'familia', 'porodica', 'nom', 'sg', 'Moja porodica je velika.', array['familia', 'familiae', 'familiam', 'familiarum', 'familiis', 'familias']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Pater ___ in domo est.', 'familiae', 'familia', 'porodica', 'gen', 'sg', 'Otac porodice je u kući.', array['familia', 'familiae', 'familiam', 'familiarum', 'familiis', 'familias']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Pater ___ amat.', 'familiam', 'familia', 'porodica', 'acc', 'sg', 'Otac voli porodicu.', array['familia', 'familiae', 'familiam', 'familiarum', 'familiis', 'familias']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ meus altus est.', 'frater', 'frater', 'brat', 'nom', 'sg', 'Moj brat je visok.', array['frater', 'fratris', 'fratri', 'fratrem', 'fratre', 'fratres', 'fratrum', 'fratribus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Soror ___ librum dat.', 'fratri', 'frater', 'brat', 'dat', 'sg', 'Sestra daje knjigu bratu.', array['frater', 'fratris', 'fratri', 'fratrem', 'fratre', 'fratres', 'fratrum', 'fratribus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Soror ___ amat.', 'fratrem', 'frater', 'brat', 'acc', 'sg', 'Sestra voli brata.', array['frater', 'fratris', 'fratri', 'fratrem', 'fratre', 'fratres', 'fratrum', 'fratribus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Cum ___ ludo.', 'fratre', 'frater', 'brat', 'abl', 'sg', 'Igram se sa bratom.', array['frater', 'fratris', 'fratri', 'fratrem', 'fratre', 'fratres', 'fratrum', 'fratribus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ in horto ludunt.', 'fratres', 'frater', 'brat', 'nom', 'pl', 'Braća se igraju u vrtu.', array['frater', 'fratris', 'fratri', 'fratrem', 'fratre', 'fratres', 'fratrum', 'fratribus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('___ mea pulchra est.', 'soror', 'soror', 'sestra', 'nom', 'sg', 'Moja sestra je lepa.', array['soror', 'sororis', 'sorori', 'sororem', 'sorore', 'sorores', 'sororum', 'sororibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Frater ___ amat.', 'sororem', 'soror', 'sestra', 'acc', 'sg', 'Brat voli sestru.', array['soror', 'sororis', 'sorori', 'sororem', 'sorore', 'sorores', 'sororum', 'sororibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Frater cum ___ ambulat.', 'sorore', 'soror', 'sestra', 'abl', 'sg', 'Brat šeta sa sestrom.', array['soror', 'sororis', 'sorori', 'sororem', 'sorore', 'sorores', 'sororum', 'sororibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_grammar_items (sentence, answer, lemma, gloss, grammar_case, number, translation, forms)
values ('Frater ___ rosam dat.', 'sorori', 'soror', 'sestra', 'dat', 'sg', 'Brat daje ružu sestri.', array['soror', 'sororis', 'sorori', 'sororem', 'sorore', 'sorores', 'sororum', 'sororibus']::text[])
on conflict (sentence) do update set answer = excluded.answer, lemma = excluded.lemma, gloss = excluded.gloss,
  grammar_case = excluded.grammar_case, number = excluded.number, translation = excluded.translation, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('amo', 'volim', 'amare', '1', '{"praes":["amo","amas","amat","amamus","amatis","amant"],"impf":["amabam","amabas","amabat","amabamus","amabatis","amabant"],"fut":["amabo","amabis","amabit","amabimus","amabitis","amabunt"],"perf":["amavi","amavisti","amavit","amavimus","amavistis","amaverunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('laudo', 'hvalim', 'laudare', '1', '{"praes":["laudo","laudas","laudat","laudamus","laudatis","laudant"],"impf":["laudabam","laudabas","laudabat","laudabamus","laudabatis","laudabant"],"fut":["laudabo","laudabis","laudabit","laudabimus","laudabitis","laudabunt"],"perf":["laudavi","laudavisti","laudavit","laudavimus","laudavistis","laudaverunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('voco', 'zovem', 'vocare', '1', '{"praes":["voco","vocas","vocat","vocamus","vocatis","vocant"],"impf":["vocabam","vocabas","vocabat","vocabamus","vocabatis","vocabant"],"fut":["vocabo","vocabis","vocabit","vocabimus","vocabitis","vocabunt"],"perf":["vocavi","vocavisti","vocavit","vocavimus","vocavistis","vocaverunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('porto', 'nosim', 'portare', '1', '{"praes":["porto","portas","portat","portamus","portatis","portant"],"impf":["portabam","portabas","portabat","portabamus","portabatis","portabant"],"fut":["portabo","portabis","portabit","portabimus","portabitis","portabunt"],"perf":["portavi","portavisti","portavit","portavimus","portavistis","portaverunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('laboro', 'radim', 'laborare', '1', '{"praes":["laboro","laboras","laborat","laboramus","laboratis","laborant"],"impf":["laborabam","laborabas","laborabat","laborabamus","laborabatis","laborabant"],"fut":["laborabo","laborabis","laborabit","laborabimus","laborabitis","laborabunt"],"perf":["laboravi","laboravisti","laboravit","laboravimus","laboravistis","laboraverunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('ambulo', 'šetam', 'ambulare', '1', '{"praes":["ambulo","ambulas","ambulat","ambulamus","ambulatis","ambulant"],"impf":["ambulabam","ambulabas","ambulabat","ambulabamus","ambulabatis","ambulabant"],"fut":["ambulabo","ambulabis","ambulabit","ambulabimus","ambulabitis","ambulabunt"],"perf":["ambulavi","ambulavisti","ambulavit","ambulavimus","ambulavistis","ambulaverunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('habeo', 'imam', 'habere', '2', '{"praes":["habeo","habes","habet","habemus","habetis","habent"],"impf":["habebam","habebas","habebat","habebamus","habebatis","habebant"],"fut":["habebo","habebis","habebit","habebimus","habebitis","habebunt"],"perf":["habui","habuisti","habuit","habuimus","habuistis","habuerunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('video', 'vidim', 'videre', '2', '{"praes":["video","vides","videt","videmus","videtis","vident"],"impf":["videbam","videbas","videbat","videbamus","videbatis","videbant"],"fut":["videbo","videbis","videbit","videbimus","videbitis","videbunt"],"perf":["vidi","vidisti","vidit","vidimus","vidistis","viderunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('moneo', 'opominjem', 'monere', '2', '{"praes":["moneo","mones","monet","monemus","monetis","monent"],"impf":["monebam","monebas","monebat","monebamus","monebatis","monebant"],"fut":["monebo","monebis","monebit","monebimus","monebitis","monebunt"],"perf":["monui","monuisti","monuit","monuimus","monuistis","monuerunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('timeo', 'bojim se', 'timere', '2', '{"praes":["timeo","times","timet","timemus","timetis","timent"],"impf":["timebam","timebas","timebat","timebamus","timebatis","timebant"],"fut":["timebo","timebis","timebit","timebimus","timebitis","timebunt"],"perf":["timui","timuisti","timuit","timuimus","timuistis","timuerunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('teneo', 'držim', 'tenere', '2', '{"praes":["teneo","tenes","tenet","tenemus","tenetis","tenent"],"impf":["tenebam","tenebas","tenebat","tenebamus","tenebatis","tenebant"],"fut":["tenebo","tenebis","tenebit","tenebimus","tenebitis","tenebunt"],"perf":["tenui","tenuisti","tenuit","tenuimus","tenuistis","tenuerunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('doceo', 'učim (nekoga)', 'docere', '2', '{"praes":["doceo","doces","docet","docemus","docetis","docent"],"impf":["docebam","docebas","docebat","docebamus","docebatis","docebant"],"fut":["docebo","docebis","docebit","docebimus","docebitis","docebunt"],"perf":["docui","docuisti","docuit","docuimus","docuistis","docuerunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('rego', 'vladam', 'regere', '3', '{"praes":["rego","regis","regit","regimus","regitis","regunt"],"impf":["regebam","regebas","regebat","regebamus","regebatis","regebant"],"fut":["regam","reges","reget","regemus","regetis","regent"],"perf":["rexi","rexisti","rexit","reximus","rexistis","rexerunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('duco', 'vodim', 'ducere', '3', '{"praes":["duco","ducis","ducit","ducimus","ducitis","ducunt"],"impf":["ducebam","ducebas","ducebat","ducebamus","ducebatis","ducebant"],"fut":["ducam","duces","ducet","ducemus","ducetis","ducent"],"perf":["duxi","duxisti","duxit","duximus","duxistis","duxerunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('mitto', 'šaljem', 'mittere', '3', '{"praes":["mitto","mittis","mittit","mittimus","mittitis","mittunt"],"impf":["mittebam","mittebas","mittebat","mittebamus","mittebatis","mittebant"],"fut":["mittam","mittes","mittet","mittemus","mittetis","mittent"],"perf":["misi","misisti","misit","misimus","misistis","miserunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('scribo', 'pišem', 'scribere', '3', '{"praes":["scribo","scribis","scribit","scribimus","scribitis","scribunt"],"impf":["scribebam","scribebas","scribebat","scribebamus","scribebatis","scribebant"],"fut":["scribam","scribes","scribet","scribemus","scribetis","scribent"],"perf":["scripsi","scripsisti","scripsit","scripsimus","scripsistis","scripserunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('lego', 'čitam', 'legere', '3', '{"praes":["lego","legis","legit","legimus","legitis","legunt"],"impf":["legebam","legebas","legebat","legebamus","legebatis","legebant"],"fut":["legam","leges","leget","legemus","legetis","legent"],"perf":["legi","legisti","legit","legimus","legistis","legerunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('vivo', 'živim', 'vivere', '3', '{"praes":["vivo","vivis","vivit","vivimus","vivitis","vivunt"],"impf":["vivebam","vivebas","vivebat","vivebamus","vivebatis","vivebant"],"fut":["vivam","vives","vivet","vivemus","vivetis","vivent"],"perf":["vixi","vixisti","vixit","viximus","vixistis","vixerunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('vinco', 'pobeđujem', 'vincere', '3', '{"praes":["vinco","vincis","vincit","vincimus","vincitis","vincunt"],"impf":["vincebam","vincebas","vincebat","vincebamus","vincebatis","vincebant"],"fut":["vincam","vinces","vincet","vincemus","vincetis","vincent"],"perf":["vici","vicisti","vicit","vicimus","vicistis","vicerunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('pono', 'stavljam', 'ponere', '3', '{"praes":["pono","ponis","ponit","ponimus","ponitis","ponunt"],"impf":["ponebam","ponebas","ponebat","ponebamus","ponebatis","ponebant"],"fut":["ponam","pones","ponet","ponemus","ponetis","ponent"],"perf":["posui","posuisti","posuit","posuimus","posuistis","posuerunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('dico', 'kažem', 'dicere', '3', '{"praes":["dico","dicis","dicit","dicimus","dicitis","dicunt"],"impf":["dicebam","dicebas","dicebat","dicebamus","dicebatis","dicebant"],"fut":["dicam","dices","dicet","dicemus","dicetis","dicent"],"perf":["dixi","dixisti","dixit","diximus","dixistis","dixerunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('facio', 'pravim, činim', 'facere', '3io', '{"praes":["facio","facis","facit","facimus","facitis","faciunt"],"impf":["faciebam","faciebas","faciebat","faciebamus","faciebatis","faciebant"],"fut":["faciam","facies","faciet","faciemus","facietis","facient"],"perf":["feci","fecisti","fecit","fecimus","fecistis","fecerunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('capio', 'hvatam', 'capere', '3io', '{"praes":["capio","capis","capit","capimus","capitis","capiunt"],"impf":["capiebam","capiebas","capiebat","capiebamus","capiebatis","capiebant"],"fut":["capiam","capies","capiet","capiemus","capietis","capient"],"perf":["cepi","cepisti","cepit","cepimus","cepistis","ceperunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('rapio', 'otimam', 'rapere', '3io', '{"praes":["rapio","rapis","rapit","rapimus","rapitis","rapiunt"],"impf":["rapiebam","rapiebas","rapiebat","rapiebamus","rapiebatis","rapiebant"],"fut":["rapiam","rapies","rapiet","rapiemus","rapietis","rapient"],"perf":["rapui","rapuisti","rapuit","rapuimus","rapuistis","rapuerunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('audio', 'čujem', 'audire', '4', '{"praes":["audio","audis","audit","audimus","auditis","audiunt"],"impf":["audiebam","audiebas","audiebat","audiebamus","audiebatis","audiebant"],"fut":["audiam","audies","audiet","audiemus","audietis","audient"],"perf":["audivi","audivisti","audivit","audivimus","audivistis","audiverunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('venio', 'dolazim', 'venire', '4', '{"praes":["venio","venis","venit","venimus","venitis","veniunt"],"impf":["veniebam","veniebas","veniebat","veniebamus","veniebatis","veniebant"],"fut":["veniam","venies","veniet","veniemus","venietis","venient"],"perf":["veni","venisti","venit","venimus","venistis","venerunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('scio', 'znam', 'scire', '4', '{"praes":["scio","scis","scit","scimus","scitis","sciunt"],"impf":["sciebam","sciebas","sciebat","sciebamus","sciebatis","sciebant"],"fut":["sciam","scies","sciet","sciemus","scietis","scient"],"perf":["scivi","scivisti","scivit","scivimus","scivistis","sciverunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('dormio', 'spavam', 'dormire', '4', '{"praes":["dormio","dormis","dormit","dormimus","dormitis","dormiunt"],"impf":["dormiebam","dormiebas","dormiebat","dormiebamus","dormiebatis","dormiebant"],"fut":["dormiam","dormies","dormiet","dormiemus","dormietis","dormient"],"perf":["dormivi","dormivisti","dormivit","dormivimus","dormivistis","dormiverunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('sum', 'jesam', 'esse', 'irreg', '{"praes":["sum","es","est","sumus","estis","sunt"],"impf":["eram","eras","erat","eramus","eratis","erant"],"fut":["ero","eris","erit","erimus","eritis","erunt"],"perf":["fui","fuisti","fuit","fuimus","fuistis","fuerunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('possum', 'mogu', 'posse', 'irreg', '{"praes":["possum","potes","potest","possumus","potestis","possunt"],"impf":["poteram","poteras","poterat","poteramus","poteratis","poterant"],"fut":["potero","poteris","poterit","poterimus","poteritis","poterunt"],"perf":["potui","potuisti","potuit","potuimus","potuistis","potuerunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('eo', 'idem', 'ire', 'irreg', '{"praes":["eo","is","it","imus","itis","eunt"],"impf":["ibam","ibas","ibat","ibamus","ibatis","ibant"],"fut":["ibo","ibis","ibit","ibimus","ibitis","ibunt"],"perf":["ii","isti","iit","iimus","istis","ierunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('volo', 'hoću, želim', 'velle', 'irreg', '{"praes":["volo","vis","vult","volumus","vultis","volunt"],"impf":["volebam","volebas","volebat","volebamus","volebatis","volebant"],"fut":["volam","voles","volet","volemus","voletis","volent"],"perf":["volui","voluisti","voluit","voluimus","voluistis","voluerunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

insert into public.lat_verbs (lemma, gloss, infinitive, conj, forms)
values ('fero', 'nosim, trpim', 'ferre', 'irreg', '{"praes":["fero","fers","fert","ferimus","fertis","ferunt"],"impf":["ferebam","ferebas","ferebat","ferebamus","ferebatis","ferebant"],"fut":["feram","feres","feret","feremus","feretis","ferent"],"perf":["tuli","tulisti","tulit","tulimus","tulistis","tulerunt"]}'::jsonb)
on conflict (lemma) do update set gloss = excluded.gloss, infinitive = excluded.infinitive,
  conj = excluded.conj, forms = excluded.forms;

