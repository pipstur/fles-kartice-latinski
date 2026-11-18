import { motion } from 'framer-motion'
import type { Item } from '../lib/srs'

interface Props {
  item: Item
  flipped: boolean
  onFlip: () => void
}

export function Flashcard({ item, flipped, onFlip }: Props) {
  const { card, direction } = item
  const srFront = direction === 'sr_lat'
  const prompt = srFront ? card.serbian : card.latin
  const answer = srFront ? card.latin : card.serbian

  return (
    <div
      className="flip"
      role="button"
      tabIndex={0}
      aria-label={flipped ? 'Kartica, odgovor prikazan' : 'Okreni karticu'}
      onClick={() => !flipped && onFlip()}
    >
      <motion.div
        className="flip-inner"
        initial={false}
        animate={{ rotateY: flipped ? 180 : 0 }}
        transition={{ type: 'spring', stiffness: 220, damping: 22 }}
      >
        <div className="face front">
          <span className="dir-label">{srFront ? 'Srpski → Latinski' : 'Latinski → Srpski'}</span>
          {!srFront && card.symbol && <span className="symbol">{card.symbol}</span>}
          <span className="word">{prompt}</span>
          <span className="tap-hint">Dodirni da okreneš</span>
        </div>

        <div className="face back">
          <span className="dir-label">{prompt}</span>
          {srFront && card.symbol && <span className="symbol">{card.symbol}</span>}
          <span className="word">{answer}</span>
          {card.note && <span className="note">{card.note}</span>}
          {card.example && <span className="example">{card.example}</span>}
        </div>
      </motion.div>
    </div>
  )
}
