import { useEffect } from 'react'
import { AnimatePresence, motion, useAnimationControls } from 'framer-motion'

interface Props {
  level: number // 0..1, koliko je lončić pun
  color: string // boja tečnosti
  smokeKey: number // povećava se pri svakoj grešci i pokreće dim i tresenje
  done: boolean // kraj recepta: sija
}

const POT = 'M40 92 Q40 178 110 178 Q180 178 180 92 Z'

export function Cauldron({ level, color, smokeKey, done }: Props) {
  const liquidY = 178 - 84 * level
  const shake = useAnimationControls()

  // Tresenje pri grešci, bez ponovnog pravljenja lončića (tečnost ostaje).
  useEffect(() => {
    if (smokeKey > 0) void shake.start({ x: [0, -8, 8, -6, 6, 0], transition: { duration: 0.45 } })
  }, [smokeKey, shake])

  return (
    <motion.svg viewBox="0 0 220 230" className="cauldron" role="img" aria-label="Lončić" animate={shake}>
      <defs>
        <clipPath id="pot-clip">
          <path d={POT} />
        </clipPath>
        <radialGradient id="glow" cx="50%" cy="50%" r="50%">
          <stop offset="0%" stopColor="#ffd966" stopOpacity="0.9" />
          <stop offset="100%" stopColor="#ffd966" stopOpacity="0" />
        </radialGradient>
      </defs>

      {done && <motion.circle cx="110" cy="110" r="105" fill="url(#glow)" initial={{ opacity: 0 }} animate={{ opacity: [0, 1, 0.6] }} transition={{ duration: 1.2 }} />}

      {/* plamen */}
      <g className="flames">
        <path className="flame f1" d="M78 222 Q72 200 86 184 Q94 200 96 222 Z" />
        <path className="flame f2" d="M100 226 Q92 198 110 178 Q126 198 120 226 Z" />
        <path className="flame f3" d="M124 222 Q124 200 136 184 Q146 202 142 222 Z" />
      </g>

      {/* telo lončića */}
      <path d={POT} fill="#2b2622" stroke="#0f0d0b" strokeWidth="3" />

      {/* tečnost */}
      <g clipPath="url(#pot-clip)">
        <motion.rect
          x="30"
          width="160"
          height="110"
          initial={{ y: 178, fill: '#555555' }}
          animate={{ y: liquidY, fill: color }}
          transition={{ type: 'spring', stiffness: 70, damping: 16 }}
        />
        {level > 0 && (
          <g className="bubbles">
            <circle className="bubble b1" cx="80" cy="170" r="5" />
            <circle className="bubble b2" cx="110" cy="172" r="4" />
            <circle className="bubble b3" cx="138" cy="170" r="6" />
            <circle className="bubble b4" cx="96" cy="170" r="3" />
          </g>
        )}
      </g>

      {/* ivica i drške */}
      <ellipse cx="110" cy="92" rx="72" ry="10" fill="none" stroke="#6a5a45" strokeWidth="6" />
      <path d="M38 100 Q18 100 24 122" fill="none" stroke="#6a5a45" strokeWidth="6" strokeLinecap="round" />
      <path d="M182 100 Q202 100 196 122" fill="none" stroke="#6a5a45" strokeWidth="6" strokeLinecap="round" />

      {/* dim posle greške */}
      <AnimatePresence>
        {smokeKey > 0 && (
          <g key={`smoke-${smokeKey}`} pointerEvents="none">
            {[0, 1, 2].map((i) => (
              <motion.circle
                key={i}
                cx={92 + i * 18}
                cy={86}
                r={9 + i * 2}
                fill="#8a8a8a"
                initial={{ opacity: 0.8, cy: 86, scale: 0.6 }}
                animate={{ opacity: 0, cy: 30 - i * 8, scale: 1.8 }}
                transition={{ duration: 1.1, delay: i * 0.08 }}
              />
            ))}
          </g>
        )}
      </AnimatePresence>
    </motion.svg>
  )
}
