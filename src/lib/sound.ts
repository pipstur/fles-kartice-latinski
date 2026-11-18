// Kratki zvukovi preko WebAudio, bez audio fajlova.
let ctx: AudioContext | null = null

function tone(freq: number, start: number, dur: number, volume = 0.08) {
  if (!ctx) return
  const osc = ctx.createOscillator()
  const gain = ctx.createGain()
  osc.type = 'sine'
  osc.frequency.value = freq
  gain.gain.setValueAtTime(volume, ctx.currentTime + start)
  gain.gain.exponentialRampToValueAtTime(0.0001, ctx.currentTime + start + dur)
  osc.connect(gain).connect(ctx.destination)
  osc.start(ctx.currentTime + start)
  osc.stop(ctx.currentTime + start + dur)
}

export function play(kind: 'good' | 'bad' | 'done', enabled: boolean) {
  if (!enabled) return
  try {
    ctx ??= new AudioContext()
    if (kind === 'good') {
      tone(660, 0, 0.12)
      tone(880, 0.09, 0.18)
    } else if (kind === 'bad') {
      tone(220, 0, 0.22)
    } else {
      ;[523, 659, 784, 1047].forEach((f, i) => tone(f, i * 0.11, 0.25))
    }
  } catch {
    // zvuk nije kritičan
  }
}
