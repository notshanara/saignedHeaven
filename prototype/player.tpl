<title>Saigned</title>
<meta name="claude:viewport-fit-sides" content="cover">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Didact+Gothic&display=swap">
<style>
/* Layout: a full-bleed sky (the angel photo graded into each song's colours, falling snow, paper grain) between a
   frosted header and footer. Between them, two panels of equal height side by side, both flush with the sky: the
   player on the left (the current song's cover, name and artist on top, the song wheel beneath) and the playback
   controls on the right (moving waveform, time bar, controls). Phones stack them. Colours come from the song
   covers: cream, blush, rose, blood red, oxblood. */
@property --tint { syntax: "<color>"; inherits: true; initial-value: #D98C95; }
@property --pulse { syntax: "<color>"; inherits: true; initial-value: #E58A9A; }

:root {
  /* type */
  /* Century Gothic for everything, falling back to Didact Gothic, a free look-alike from Google Fonts, wherever it
     isn't installed. The signedHeaven wordmark is Amelie's lettering drawn as outlines (site_art/wordmark.svg), so
     the font file itself is never served; --font-display only sets the name in type if those outlines are missing. */
  --font-display: "Amelie", cursive;
  --font-ui: "Century Gothic", CenturyGothic, "Didact Gothic", "Avenir Next", Avenir, "Segoe UI", sans-serif;
  --ease-soft: cubic-bezier(0.22, 1, 0.36, 1);

  /* Day (light): cream paper, the angel photo in cream, blush and white with white snow, a crimson waveform */
  --bg: #F4EDE6;
  --ink: #2A1518;
  --ink-muted: #5E4347;
  --brand-glow: rgba(217, 140, 149, 0.55);
  --sky-top: #F8F3ED;
  --sky-mid: #F3EAE3;
  --sky-bottom: #EEDDD5;
  --sky-set: day; /* the script's palettes of deeper reds and pinks */
  /* The background photo's grade: its dark sky becomes --sky-shadow, its brightest parts --sky-light, and the tones
     between take the song's colour, lifted towards white (+) or darkened towards black (-) by --sky-mid-mix.
     --sky-glow: how strongly the song's colour gathers around the wings. The snow falls in --sky-snow. */
  --sky-shadow: #F1E4DC;
  --sky-light: #FFFDFB;
  --sky-mid-mix: 0.55;
  --sky-glow: 0.4;
  --sky-snow: #FFFFFF;
  --sky-snow-alpha: 0.85;
  --star: #B7838B;
  --star-glow: rgba(255, 255, 255, 0.95);
  --tint-strength: 30%;
  --grain-opacity: 0.35;
  --grain-blend: soft-light;
  /* a soft glow behind text and icons that sit on the photo, so they stay readable over its bright wings */
  --text-halo: 0 0 10px rgba(251, 247, 242, 0.85), 0 0 2px rgba(251, 247, 242, 0.6);
  --icon-halo: drop-shadow(0 0 6px rgba(251, 247, 242, 0.75));
  --skeleton-blend: multiply; /* how the skeleton art mixes into the sky */
  --skeleton-opacity: 0.27;

  --hdr-bg: rgba(255, 252, 248, 0.5);
  --hdr-line: rgba(42, 21, 24, 0.08);
  --hover: rgba(42, 21, 24, 0.06);

  --track-line: rgba(42, 21, 24, 0.1);
  --sel-a: #EBC3C3;
  --fill-glow: rgba(163, 18, 42, 0.28);
  --track: rgba(42, 21, 24, 0.14);
  --fill: linear-gradient(90deg, #C2213C, #5E0B1A);
  --knob: #5E0B1A;
  --knob-halo: rgba(94, 11, 26, 0.18);
  --icon: #A3122A;
  --ctl-ink: #2A1518;
  --ctl-muted: #6E5155;
  --ctl-active: #A3122A;
  --focus: #A3122A;
  --art-shadow: rgba(42, 21, 24, 0.4);

  /* the waveform is the boldest thing on the page: dark wine with a pale halo, against the cream and blush photo */
  --wave-past: #3A0A14;
  --wave-past-2: #7A0E22;
  --wave-future: rgba(42, 21, 24, 0.42);
  --wave-idle-lift: 0; /* how far the idle bars' palette colours are lifted towards white, to stand out on the photo */
  --wave-head: #2A1518;
  --wave-glow: rgba(255, 250, 246, 0.75);

  transition: --tint 2.4s var(--ease-soft);
}

/* Night. Its colours apply on a device set to dark (unless the visitor picked Light mode) and when the visitor picks
   dark with the switch. They're written once, in the :root[data-theme="dark"] block below, and the build copies them
   into this block. */
@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) {
    /*NIGHT*/
  }
}

:root[data-theme="dark"] {
  /* Night (dark): the angel photo in wine-black and rose with ivory snow, an ivory waveform */
  --bg: #140A0D;
  --ink: #F7EEE8;
  --ink-muted: #D9C3C0;
  --brand-glow: rgba(229, 138, 154, 0.6);
  --sky-top: #0A0507;
  --sky-mid: #150A0E;
  --sky-bottom: #2B0F18;
  --sky-set: night;
  --sky-shadow: #0B0507;
  --sky-light: #A47A84;
  --sky-mid-mix: -0.55;
  --sky-glow: 0.45;
  --sky-snow: #FFF0F2;
  --sky-snow-alpha: 0.8;
  --star: #FFF3EA;
  --star-glow: rgba(240, 150, 165, 0.55);
  --tint-strength: 24%;
  --grain-opacity: 0.2;
  --grain-blend: overlay;
  --text-halo: 0 0 10px rgba(11, 5, 7, 0.75), 0 0 2px rgba(11, 5, 7, 0.55);
  --icon-halo: drop-shadow(0 0 6px rgba(11, 5, 7, 0.65));
  --skeleton-blend: screen;
  --skeleton-opacity: 0.3;
  --hdr-bg: rgba(20, 10, 13, 0.45);
  --hdr-line: rgba(235, 195, 195, 0.12);
  --hover: rgba(235, 195, 195, 0.1);
  --track-line: rgba(235, 195, 195, 0.14);
  --sel-a: #8E1428;
  --fill-glow: rgba(240, 140, 160, 0.3);
  --track: rgba(235, 195, 195, 0.18);
  --fill: linear-gradient(90deg, #D98C95, #FFE9DF);
  --knob: #FFE9DF;
  --knob-halo: rgba(255, 233, 223, 0.18);
  --icon: #E58A9A;
  --ctl-ink: #F7EEE8;
  --ctl-muted: #CDB2B1;
  --ctl-active: #E58A9A;
  --focus: #EBC3C3;
  --art-shadow: rgba(0, 0, 0, 0.6);
  --wave-past: #FFF6F0;
  --wave-past-2: #F2AEB8;
  --wave-future: rgba(255, 240, 234, 0.36);
  --wave-idle-lift: 0.45;
  --wave-head: #FFF6F0;
  --wave-glow: rgba(240, 120, 140, 0.55);
  color-scheme: dark;
}

* { box-sizing: border-box; }
html { height: 100%; }
body {
  margin: 0;
  min-height: 100%;
  background: var(--bg);
  color: var(--ink);
  font-family: var(--font-ui);
  display: flex;
  flex-direction: column;
  overflow-x: hidden;
  -webkit-tap-highlight-color: transparent;
}
.sr-only {
  position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px;
  overflow: hidden; clip: rect(0 0 0 0); white-space: nowrap; border: 0;
}

/* ---------- scene: sky, the angel photo and its snow, a glow in the playing cover's colour, paper grain ---------- */
.scene { position: fixed; inset: 0; z-index: 0; overflow: hidden; pointer-events: none; }
.sky { position: absolute; inset: 0; background: linear-gradient(180deg, var(--sky-top), var(--sky-mid) 55%, var(--sky-bottom)); }
/* The angel photo, drawn by the script (with WebGL) at part of the screen's size and stretched over it. It fades in
   once the photo has loaded; until then, or without WebGL, the plain gradient sky above shows, with its stars. */
.sky-photo { position: absolute; inset: 0; width: 100%; height: 100%; opacity: 0; transition: opacity 1.4s var(--ease-soft); }
.sky-photo.ready { opacity: 1; }
/* the photo brings its own falling snow, so the twinkling stars stand down (the odd shooting star still passes) */
.sky-photo.ready ~ .stars .star { display: none; }
.haze { position: absolute; width: 72vmax; height: 72vmax; left: calc(50% - 36vmax); top: calc(52% - 36vmax); border-radius: 50%; background: radial-gradient(closest-side, color-mix(in srgb, var(--tint) var(--tint-strength), transparent), transparent); transition: opacity 1.4s var(--ease-soft); }
/* the photo already carries the song's colour, so the cover's glow over it is kept faint */
.sky-photo.ready ~ .haze { opacity: 0.3; }
.stars { position: absolute; inset: 0; }
.star {
  position: absolute; width: var(--s); height: var(--s); border-radius: 50%;
  background: var(--star); box-shadow: 0 0 calc(var(--s) * 2.5) var(--star-glow);
  opacity: var(--lo); animation: twinkle var(--d) ease-in-out var(--delay) infinite alternate;
}
/* the brightest stars catch a soft four-point glint */
.star.glint::before, .star.glint::after {
  content: ""; position: absolute; left: 50%; top: 50%; width: calc(var(--s) * 6); height: 1px;
  translate: -50% -50%; background: linear-gradient(90deg, transparent, var(--star), transparent);
}
.star.glint::after { rotate: 90deg; }
.shoot {
  position: absolute; width: 150px; height: 1.5px; border-radius: 1px;
  background: linear-gradient(90deg, transparent, var(--star));
  filter: drop-shadow(0 0 4px var(--star-glow));
  transform-origin: 100% 50%;
  opacity: 0; animation: shoot 1.3s cubic-bezier(0.2, 0.6, 0.3, 1) forwards;
}
/* Skeleton art: the playing cover traced down to its outlines and laid large and faint across the sky, in the colour
   of the song's sky. It drifts a little against the pointer, a soft light follows the pointer across its lines,
   and it breathes with the bass. The script supplies each cover's lines as a mask. */
.skeletons { position: absolute; inset: 0; mix-blend-mode: var(--skeleton-blend); transition: --pulse 2.6s var(--ease-soft); }
.skeleton {
  position: absolute; left: 50%; top: 50%;
  width: min(118vmin, 1180px); aspect-ratio: 1;
  translate: calc(-50% + var(--px, 0px)) calc(-50% + var(--py, 0px));
  -webkit-mask-position: center; mask-position: center;
  -webkit-mask-size: contain; mask-size: contain;
  -webkit-mask-repeat: no-repeat; mask-repeat: no-repeat;
  background: radial-gradient(circle 24vmin at var(--mx, 50%) var(--my, 50%), color-mix(in srgb, var(--pulse) 40%, white), var(--pulse) 60%, color-mix(in srgb, var(--pulse) 55%, transparent));
  opacity: 0; transition: opacity 1.6s var(--ease-soft);
}
.skeleton.on { opacity: var(--skeleton-opacity); }
.grain {
  position: absolute; inset: 0;
  opacity: var(--grain-opacity); mix-blend-mode: var(--grain-blend);
  background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='200' height='200'><filter id='g'><feTurbulence type='fractalNoise' baseFrequency='0.8' numOctaves='3' stitchTiles='stitch'/><feColorMatrix type='saturate' values='0'/></filter><rect width='100%' height='100%' filter='url(%23g)'/></svg>");
  background-size: 200px 200px;
}
@keyframes twinkle { from { opacity: var(--lo); scale: 0.65; } to { opacity: var(--hi); scale: 1; } }
@keyframes shoot {
  0% { opacity: 0; transform: translate(0, 0) rotate(var(--ang)); }
  12% { opacity: 1; }
  100% { opacity: 0; transform: translate(var(--dx), var(--dy)) rotate(var(--ang)); }
}

/* ---------- header ---------- */
.site-header {
  position: relative; z-index: 2; flex: none;
  background: var(--hdr-bg);
  border-bottom: 1px solid var(--hdr-line);
  -webkit-backdrop-filter: blur(16px) saturate(1.2);
  backdrop-filter: blur(16px) saturate(1.2);
}
.hdr-inner {
  max-width: 1320px; margin: 0 auto; min-height: 64px;
  display: flex; align-items: center; justify-content: space-between; gap: 24px;
  padding-left: max(16px, env(safe-area-inset-left, 0px));
  padding-right: max(16px, env(safe-area-inset-right, 0px));
  padding-block: 10px;
}
/* The wordmark: Amelie's lettering as outlines, put in by the build. Wider screens get the full signature, with the
   font's lead-in swash and trailing tail; phones get the plain lettering, which keeps the letters larger. */
.wordmark { margin: 0; min-width: 0; flex: 0 1 auto; color: var(--ink); line-height: 0; }
.wordmark-art { display: block; height: 44px; width: auto; max-width: 100%; filter: drop-shadow(0 0 12px var(--brand-glow)); }
.wordmark-plain { display: none; }
.wordmark-text { font-family: var(--font-display); font-size: 38px; line-height: 1.15; white-space: nowrap; text-shadow: 0 0 22px var(--brand-glow); }
.hdr-links { display: flex; flex-wrap: wrap; align-items: center; justify-content: flex-end; gap: 6px; }
.hdr-links:empty { display: none; }
.hdr-links a {
  display: grid; place-items: center; width: 40px; height: 40px; border-radius: 50%;
  color: var(--ink);
  transition: color 0.2s, background-color 0.2s;
}
.hdr-links svg { width: 21px; height: 21px; fill: currentColor; overflow: visible; filter: drop-shadow(0 0 8px var(--brand-glow)); }
.hdr-links .ic-soundcloud svg { width: 25px; height: 25px; } /* a wide, short mark: a little larger so it weighs the same */
.hdr-links a[href]:hover { color: var(--focus); background: var(--hover); }
.hdr-links a:not([href]) { cursor: default; }
.hdr-links a:focus-visible { outline: 2px solid var(--focus); outline-offset: 2px; }

/* ---------- main layout: two panels of equal height ---------- */
.main {
  position: relative; z-index: 1; flex: 1;
  display: grid; align-content: center; row-gap: 14px;
  padding-left: max(16px, env(safe-area-inset-left, 0px));
  padding-right: max(16px, env(safe-area-inset-right, 0px));
  padding-block: 24px;
}
.stage {
  width: 100%; max-width: 1180px; margin: 0 auto;
  display: grid; grid-template-columns: auto minmax(0, 1fr); align-items: stretch;
  column-gap: clamp(16px, 3.5vw, 48px);
}
.note {
  width: 100%; max-width: 1180px; margin: 0 auto;
  font-size: 12.5px; line-height: 1.5; letter-spacing: 0.02em; color: var(--ink-muted); text-align: center;
}
/* ---------- footer: the credit on the left, the Light mode switch on the right ---------- */
.site-footer {
  position: relative; z-index: 2; flex: none;
  background: var(--hdr-bg);
  border-top: 1px solid var(--hdr-line);
  -webkit-backdrop-filter: blur(16px) saturate(1.2);
  backdrop-filter: blur(16px) saturate(1.2);
}
.ftr-inner {
  max-width: 1320px; margin: 0 auto; min-height: 52px;
  display: flex; flex-wrap: wrap; align-items: center; justify-content: space-between; gap: 2px 24px;
  padding-left: max(16px, env(safe-area-inset-left, 0px));
  padding-right: max(16px, env(safe-area-inset-right, 0px));
  padding-block: 8px;
}
.credit { margin: 0; font-size: 12.5px; letter-spacing: 0.06em; color: var(--ink-muted); }
.credit-name { color: var(--ink); }
/* Light mode: a small switch between the night look and the day look */
.switch {
  display: inline-flex; align-items: center; gap: 10px; min-height: 36px; padding: 4px 6px 4px 12px; margin-right: -6px;
  border: 0; border-radius: 99px; background: transparent; color: var(--ink-muted);
  font: inherit; font-size: 12.5px; letter-spacing: 0.04em; cursor: pointer;
}
.switch:hover { background: var(--hover); }
.switch:focus-visible { outline: 2px solid var(--focus); outline-offset: 2px; }
.switch-track {
  position: relative; flex: none; width: 30px; height: 18px; border-radius: 99px;
  background: var(--track); box-shadow: inset 0 0 0 1px var(--track-line); transition: background-color 0.2s;
}
.switch-thumb {
  position: absolute; top: 3px; left: 3px; width: 12px; height: 12px; border-radius: 50%;
  background: var(--ink-muted); transition: translate 0.25s var(--ease-soft), background-color 0.2s;
}
.switch[aria-checked="true"] .switch-track { background: color-mix(in srgb, var(--knob) 30%, transparent); }
.switch[aria-checked="true"] .switch-thumb { translate: 12px 0; background: var(--knob); }

/* ---------- player: the current song on top, an endless wheel of songs beneath ----------
   No tile: like the playback area beside it, the player's contents sit straight on the sky, and the cover with its
   glowing pulse is the one floating object. */
.device {
  /* the player's height: as tall as fits between the header and the note and footer */
  --dh: max(300px, min(620px, calc(100dvh - 200px), 58vw));
  position: relative;
  height: var(--dh);
  width: calc(var(--dh) * 0.58);
  display: flex; flex-direction: column; gap: calc(var(--dh) * 0.03);
  container: device / size;
}

/* The song wheel, after the iPhone Clock's timer picker: the songs sit on a drum that turns endlessly (they repeat in
   order, forever), the row in the middle band is the chosen one, and the rows tip away above and below it, fading
   out towards the edges. Drag, flick, scroll or use the arrow keys to turn it; tap a row to play it. */
.picker {
  position: relative; flex: none; width: 100%; height: 42cqh;
  outline: none; touch-action: none; cursor: grab; user-select: none; -webkit-user-select: none;
  -webkit-mask-image: linear-gradient(180deg, transparent, #000 24%, #000 76%, transparent);
  mask-image: linear-gradient(180deg, transparent, #000 24%, #000 76%, transparent);
  container: display / size;
}
.picker.dragging { cursor: grabbing; }
.picker-band {
  position: absolute; left: 0; right: 0; top: 50%; height: var(--row-h, 44px); translate: 0 -50%;
  border-radius: 13px; pointer-events: none;
  background: color-mix(in srgb, var(--sel-a) 32%, transparent);
}
.picker:focus-visible .picker-band { outline: 2px solid var(--focus); outline-offset: 2px; }
.picker-drum { position: absolute; inset: 0; perspective: 700px; pointer-events: none; }
.wheel-row {
  position: absolute; left: 0; right: 0; top: 50%; height: var(--row-h, 44px); margin-top: calc(var(--row-h, 44px) / -2);
  display: flex; align-items: center; gap: 10px; padding: 0 14px;
  font-size: clamp(13.5px, 4.8cqh, 17px); letter-spacing: 0.02em; white-space: nowrap;
  color: var(--ink-muted);
  backface-visibility: hidden; will-change: transform, opacity;
  transition: color 0.25s;
}
.wheel-row.centre { color: var(--ink); }
.wheel-row .label { flex: 1; min-width: 0; overflow: hidden; text-overflow: ellipsis; }
.wheel-row .right { font-size: 0.86em; font-variant-numeric: tabular-nums; opacity: 0.8; }
.thumb { width: 1.75em; height: 1.75em; border-radius: 7px; object-fit: cover; flex: none; box-shadow: 0 2px 6px -2px var(--art-shadow); }
/* the playing song's equaliser mark moves with the music itself (its bass and loudness), not a loop */
.eq { display: none; align-items: flex-end; gap: 2px; height: 0.8em; color: var(--icon); }
.eq i { display: block; width: 3px; height: 100%; border-radius: 2px; background: currentColor; transform-origin: 50% 100%; transform: scaleY(0.3); transition: transform 0.09s linear; }
.wheel-row.playing .eq { display: inline-flex; }
/* on a narrow player the equaliser mark stands in for the length, so the playing title has room */
@container device (max-width: 200px) { .wheel-row.playing .right { display: none; } }

.plate {
  flex: 1; min-height: 0;
  display: flex; flex-direction: column; align-items: center; justify-content: center;
  gap: clamp(10px, 2.2cqh, 14px); text-align: center;
}
/* The cover: a glow behind it that swells with the song's bass and sends out rings on each bass hit, in the
   colour of the song's sky; a gentle tilt towards the pointer with a passing shine (after animate-ui's Tilt
   and Shine); and each new cover zooms in out of a soft blur. */
.art-stage { position: relative; display: grid; place-items: center; transition: --pulse 2.6s var(--ease-soft); }
.pulse-glow {
  position: absolute; inset: -42%; z-index: 0; border-radius: 50%; pointer-events: none;
  background: radial-gradient(closest-side, color-mix(in srgb, var(--pulse) 80%, transparent), color-mix(in srgb, var(--pulse) 30%, transparent) 50%, transparent 74%);
  opacity: 0.22; transform: scale(0.8);
}
.pulse-rings { position: absolute; inset: 0; z-index: 0; pointer-events: none; }
.pulse-ring {
  position: absolute; inset: 0; border-radius: clamp(10px, 4cqw, 18px);
  border: 2px solid var(--pulse); box-shadow: 0 0 18px -2px var(--pulse);
  opacity: 0; animation: ring 1.35s cubic-bezier(0.2, 0.7, 0.3, 1) forwards;
}
@keyframes ring { from { transform: scale(1); opacity: var(--ring-o, 0.6); } to { transform: scale(1.8); opacity: 0; } }
.art-thump { position: relative; z-index: 1; }
.art-tilt {
  position: relative;
  width: min(66cqw, 36cqh); aspect-ratio: 1; border-radius: clamp(10px, 4cqw, 18px);
  box-shadow: 0 18px 32px -18px var(--art-shadow), 0 0 44px -10px var(--tint);
  transform: perspective(800px) rotateX(var(--rx, 0deg)) rotateY(var(--ry, 0deg));
  transition: transform 0.8s var(--ease-soft);
}
.art-tilt.is-tilting { transition-duration: 0.15s; }
/* on the smallest players the cover gives up a little size, so a two-line title still fits */
@container device (max-height: 360px) { .art-tilt { width: min(66cqw, 32cqh); } }
.plate-art { display: block; width: 100%; height: 100%; border-radius: inherit; object-fit: cover; }
.art-shine {
  position: absolute; inset: 0; border-radius: inherit; pointer-events: none;
  background: linear-gradient(105deg, transparent 35%, rgba(255, 255, 255, 0.55) 50%, transparent 65%) no-repeat;
  background-size: 300% 100%; background-position: var(--shine-x, 130%) 0;
  mix-blend-mode: soft-light; opacity: var(--shine-o, 0);
  transition: opacity 0.5s;
}
.plate-text { min-width: 0; max-width: 100%; display: flex; flex-direction: column; gap: 3px; }
.plate-title {
  margin: 0; font-size: clamp(16px, 7.4cqw, 27px); line-height: 1.2; letter-spacing: 0.01em; color: var(--ink);
  overflow-wrap: anywhere; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
}
.plate-artist { margin: 0; font-size: clamp(12px, 4.4cqw, 15px); line-height: 1.3; letter-spacing: 0.04em; color: var(--ink-muted); }
/* a new title rolls in letter by letter (after animate-ui's Rolling text); words stay whole when it wraps */
.plate-title .word { display: inline-block; white-space: nowrap; }
.plate-title .ch { display: inline-block; animation: ch-in 0.6s cubic-bezier(0.2, 0.8, 0.2, 1) backwards; animation-delay: calc(var(--i) * 30ms); }
@keyframes ch-in { from { opacity: 0; transform: perspective(240px) translateY(0.55em) rotateX(-80deg); filter: blur(5px); } }

/* ---------- playback card: same height as the player, contents centred ----------
   Entirely flush with the background: no fill, border, shadow or blur, so only the waveform,
   time bar and controls show, sitting straight on the sky. */
.np-wrap { min-width: 0; width: 100%; max-width: 820px; container: np / inline-size; display: flex; }
.card {
  flex: 1; min-width: 0;
  display: flex; flex-direction: column; justify-content: center; gap: clamp(16px, 3cqi, 28px);
  padding: clamp(18px, 4cqi, 36px);
}
.listen {
  flex: 1 1 clamp(96px, 26cqi, 220px); min-height: 96px; max-height: 260px;
  display: grid; grid-template-columns: minmax(0, 1fr);
}
.wave-wrap {
  position: relative; height: 100%;
  -webkit-mask-image: linear-gradient(90deg, transparent, #000 8%, #000 92%, transparent);
  mask-image: linear-gradient(90deg, transparent, #000 8%, #000 92%, transparent);
}
.wave-wrap::after {
  content: ""; position: absolute; left: 50%; top: 6%; bottom: 6%; width: 2px; translate: -1px 0; border-radius: 2px;
  background: linear-gradient(180deg, transparent, var(--wave-head), transparent);
  box-shadow: 0 0 14px 2px var(--wave-glow);
}
.wave-wrap canvas { position: absolute; inset: 0; width: 100%; height: 100%; filter: drop-shadow(0 0 5px var(--wave-glow)); }

.seek { display: flex; flex-direction: column; gap: 10px; }
.bar { position: relative; height: 4px; border-radius: 99px; background: var(--track); cursor: pointer; touch-action: none; }
.bar::before { content: ""; position: absolute; inset: -16px 0; }
.bar .fill { position: absolute; left: 0; top: 0; bottom: 0; width: 0; border-radius: inherit; background: var(--fill); box-shadow: 0 0 10px -1px var(--fill-glow); }
.bar .knob {
  position: absolute; left: 0; top: 50%; width: 14px; height: 14px; border-radius: 50%;
  background: var(--knob); box-shadow: 0 0 0 5px var(--knob-halo);
  translate: -50% -50%;
}
.bar[aria-disabled="true"] { cursor: default; opacity: 0.55; }
.bar:focus-visible { outline: 2px solid var(--focus); outline-offset: 8px; }
.times { display: flex; justify-content: space-between; font-size: 13px; letter-spacing: 0.02em; color: var(--ink-muted); font-variant-numeric: tabular-nums; }
/* text and controls on the photo carry a soft halo (--text-halo, --icon-halo), so they stay readable over its wings */
.plate-title, .plate-artist, .wheel-row, .times, .note { text-shadow: var(--text-halo); }
.ctl { filter: var(--icon-halo); }

.controls { display: flex; align-items: center; justify-content: center; gap: clamp(4px, 2.6cqi, 28px); }
.ctl {
  position: relative; display: grid; place-items: center;
  width: clamp(38px, 9cqi, 48px); height: clamp(38px, 9cqi, 48px); padding: 0; flex: none;
  border: 0; border-radius: 50%; background: transparent; color: var(--ctl-ink); cursor: pointer;
  transition: background-color 0.2s, scale 0.2s var(--ease-soft), color 0.2s;
}
.ctl:hover { background: var(--hover); }
.ctl:active { scale: 0.94; }
.ctl:focus-visible { outline: 2px solid var(--focus); outline-offset: 2px; }
.ctl:disabled { opacity: 0.4; cursor: default; background: transparent; scale: 1; }
.ctl svg { width: clamp(18px, 5cqi, 24px); height: auto; aspect-ratio: 1; }
.ctl .ic-fill { fill: currentColor; }
.ctl .ic-line { fill: none; stroke: currentColor; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }
.ctl-mode { color: var(--ctl-muted); }
.ctl-mode[aria-pressed="true"] { color: var(--ctl-active); }
.ctl-mode[aria-pressed="true"]::after {
  content: ""; position: absolute; bottom: 4px; left: 50%; width: 4px; height: 4px; margin-left: -2px;
  border-radius: 50%; background: currentColor;
}
.ctl .one { position: absolute; top: 8px; right: 6px; display: none; font-size: 9px; font-weight: 800; line-height: 1; }
.ctl-repeat[data-mode="one"] .one { display: block; }
.ctl-play { width: clamp(46px, 13cqi, 66px); height: clamp(46px, 13cqi, 66px); border: 2px solid var(--ctl-ink); }
.ctl-play svg { width: clamp(20px, 5.6cqi, 26px); }
.ctl-play .i-pause { display: none; }
.ctl-play.is-playing .i-play { display: none; }
.ctl-play.is-playing .i-pause { display: block; }
/* while a song is loading or catching up, a thin arc turns around the play button */
.ctl-play.is-buffering::before {
  content: ""; position: absolute; inset: -6px; border-radius: 50%; pointer-events: none;
  border: 2px solid transparent; border-top-color: var(--ctl-active); border-right-color: var(--ctl-active);
  animation: buffering 0.9s linear infinite;
}
@keyframes buffering { to { rotate: 360deg; } }

/* ---------- phone-width screens: the player stacks above the card ---------- */
@media (max-width: 519px) {
  .hdr-inner { min-height: 56px; gap: 12px; }
  .wordmark-full { display: none; }
  .wordmark-plain { display: block; height: 31px; }
  .wordmark-text { font-size: 30px; }
  .hdr-links { gap: 2px; }
  .main { align-content: start; padding-block: 18px 32px; }
  .stage { display: flex; flex-direction: column; gap: 20px; }
  .device { width: min(100%, 360px); height: auto; aspect-ratio: 0.62; align-self: center; gap: 14px; }
  .np-wrap { max-width: none; }
}

/* very narrow phones: the wordmark sits above the icons, and the footer's two parts centre, all stacked */
@media (max-width: 359px) {
  .hdr-inner { flex-direction: column; justify-content: center; gap: 0; padding-block: 8px 4px; }
  .hdr-links { justify-content: center; }
  .ftr-inner { justify-content: center; }
}

/* ---------- motion ----------
   By the site owner's choice, the site is always animated: the photo's light and its snow never stop, even when a device
   asks for less motion. Pausing the music stills the cover's pulse and fades out the skeleton art. */
</style>

<div class="scene" aria-hidden="true">
  <div class="sky"></div>
  <canvas class="sky-photo" id="skyCanvas"></canvas>
  <div class="haze"></div>
  <div class="stars" id="stars"></div>
  <div class="skeletons" id="skeletons"><div class="skeleton" id="skeletonA"></div><div class="skeleton" id="skeletonB"></div></div>
  <div class="grain"></div>
</div>

<header class="site-header">
  <div class="hdr-inner">
    <h1 class="wordmark"><span class="sr-only">signedHeaven</span><!--WORDMARK--></h1>
    <nav class="hdr-links" id="links" aria-label="Links"></nav>
  </div>
</header>

<main class="main">
  <div class="stage">
    <div class="device">
      <div class="plate" id="plate" role="group" aria-label="Now playing">
        <div class="art-stage" id="artStage">
          <i class="pulse-glow" id="pulseGlow" aria-hidden="true"></i>
          <div class="pulse-rings" id="pulseRings" aria-hidden="true"></div>
          <div class="art-thump" id="artThump">
            <div class="art-tilt" id="artTilt">
              <img class="plate-art" id="npArt" alt="">
              <i class="art-shine" id="artShine" aria-hidden="true"></i>
            </div>
          </div>
        </div>
        <div class="plate-text">
          <p class="plate-title" id="npTitle">Choose a song</p>
          <p class="plate-artist" id="npArtist">Pick one from the list</p>
        </div>
      </div>
      <div class="picker" id="songList" role="listbox" aria-label="Songs" tabindex="0">
        <div class="picker-band" aria-hidden="true"></div>
        <div class="picker-drum" id="pickerDrum" aria-hidden="true"></div>
        <div class="sr-only" id="pickerOptions"></div>
      </div>
    </div>

    <div class="np-wrap">
      <section class="card" aria-label="Playback">
        <div class="listen" aria-hidden="true">
          <div class="wave-wrap"><canvas id="wave"></canvas></div>
        </div>

        <div class="seek">
          <div class="bar" id="seekBar" role="slider" tabindex="0" aria-label="Position in song" aria-valuemin="0" aria-valuemax="0" aria-valuenow="0" aria-valuetext="No song playing" aria-disabled="true"><div class="fill" id="seekFill"></div><div class="knob" id="seekKnob"></div></div>
          <div class="times"><span id="tElapsed">0:00</span><span id="tTotal">0:00</span></div>
        </div>

        <div class="controls" role="group" aria-label="Playback controls">
          <button class="ctl ctl-mode ctl-repeat" id="cRepeat" type="button" aria-label="Repeat: Off" aria-pressed="false">
            <svg viewBox="0 0 24 24" aria-hidden="true"><path class="ic-line" d="M17 2l3 3-3 3M4 11V9a4 4 0 0 1 4-4h12M7 22l-3-3 3-3M20 13v2a4 4 0 0 1-4 4H4"/></svg>
            <span class="one" aria-hidden="true">1</span>
          </button>
          <button class="ctl" id="cPrev" type="button" aria-label="Previous song">
            <svg viewBox="0 0 24 24" aria-hidden="true"><path class="ic-fill" d="M6 5h2.6v14H6zM19 5v14L9.2 12z"/></svg>
          </button>
          <button class="ctl ctl-play" id="cPlay" type="button" aria-label="Play">
            <svg class="i-play" viewBox="0 0 24 24" aria-hidden="true"><path class="ic-fill" d="M8.5 5.2v13.6L19 12z"/></svg>
            <svg class="i-pause" viewBox="0 0 24 24" aria-hidden="true"><path class="ic-fill" d="M7 5h3.6v14H7zM13.4 5H17v14h-3.6z"/></svg>
          </button>
          <button class="ctl" id="cNext" type="button" aria-label="Next song">
            <svg viewBox="0 0 24 24" aria-hidden="true"><path class="ic-fill" d="M15.4 5H18v14h-2.6zM5 5v14l9.8-7z"/></svg>
          </button>
          <button class="ctl ctl-mode" id="cShuffle" type="button" aria-label="Shuffle" aria-pressed="false">
            <svg viewBox="0 0 24 24" aria-hidden="true"><path class="ic-line" d="M16 3h5v5M4 20L21 3M21 16v5h-5M15 15l6 6M4 4l5 5"/></svg>
          </button>
        </div>
      </section>
    </div>
  </div>
  <p class="note">Prototype: the songs play for real, their waveforms are measured from the files, covers are shuffled each visit, and the text font is a stand-in for Century Gothic.</p>
</main>

<footer class="site-footer">
  <div class="ftr-inner">
    <p class="credit">made by <span class="credit-name">inversedesigns</span></p>
    <button class="switch" id="lightSwitch" type="button" role="switch" aria-checked="false">Light mode<span class="switch-track" aria-hidden="true"><span class="switch-thumb"></span></span></button>
  </div>
</footer>

<div class="sr-only" id="live" aria-live="polite"></div>

<script>
(() => {
  "use strict";

  /* ---------- content ---------- */
  // Header links, shown as brand icons in this order. Each opens in a new tab, so the music keeps playing. More
  // links are added the same way, with a matching entry in ICONS (a link with an empty href shows but goes nowhere).
  const LINKS = [
    { label: "SoundCloud", href: "https://soundcloud.com/sqruem", icon: "soundcloud" },
    { label: "guns.lol", href: "https://guns.lol/signedheaven", icon: "gunslol" },
    { label: "Instagram", href: "https://www.instagram.com/saiswings", icon: "instagram" },
  ];
  // Single-colour brand marks on a 24×24 grid, so they take the theme's ink colour. SoundCloud and Instagram are
  // from Simple Icons 16.38.0 (CC0); guns.lol has no vector logo, so its mark is traced from the one on guns.lol.
  const ICONS = {
    soundcloud: { rule: "nonzero", d: "M23.999 14.165c-.052 1.796-1.612 3.169-3.4 3.169h-8.18a.68.68 0 0 1-.675-.683V7.862a.747.747 0 0 1 .452-.724s.75-.513 2.333-.513a5.364 5.364 0 0 1 2.763.755 5.433 5.433 0 0 1 2.57 3.54c.282-.08.574-.121.868-.12.884 0 1.73.358 2.347.992s.948 1.49.922 2.373ZM10.721 8.421c.247 2.98.427 5.697 0 8.672a.264.264 0 0 1-.53 0c-.395-2.946-.22-5.718 0-8.672a.264.264 0 0 1 .53 0ZM9.072 9.448c.285 2.659.37 4.986-.006 7.655a.277.277 0 0 1-.55 0c-.331-2.63-.256-5.02 0-7.655a.277.277 0 0 1 .556 0Zm-1.663-.257c.27 2.726.39 5.171 0 7.904a.266.266 0 0 1-.532 0c-.38-2.69-.257-5.21 0-7.904a.266.266 0 0 1 .532 0Zm-1.647.77a26.108 26.108 0 0 1-.008 7.147.272.272 0 0 1-.542 0 27.955 27.955 0 0 1 0-7.147.275.275 0 0 1 .55 0Zm-1.67 1.769c.421 1.865.228 3.5-.029 5.388a.257.257 0 0 1-.514 0c-.21-1.858-.398-3.549 0-5.389a.272.272 0 0 1 .543 0Zm-1.655-.273c.388 1.897.26 3.508-.01 5.412-.026.28-.514.283-.54 0-.244-1.878-.347-3.54-.01-5.412a.283.283 0 0 1 .56 0Zm-1.668.911c.4 1.268.257 2.292-.026 3.572a.257.257 0 0 1-.514 0c-.241-1.262-.354-2.312-.023-3.572a.283.283 0 0 1 .563 0Z" },
    gunslol: { rule: "evenodd", d: "M16.91 0.05L17.11 0L17.48 0.02L17.86 0.23L18.08 0.52L18.23 0.58L18.7 0.2L19.17 0.07L19.73 0.11L20.11 0.3L21.53 2.2L22.09 3.05L22.24 3.52L22.21 4.08L22.03 4.45L21.7 4.78L21.14 5.09L20.77 5.41L19.61 6.14L19.52 6.33L19.38 7.45L19.21 7.83L18.85 8.2L18.08 8.77L17.91 8.95L17.92 9.14L18.43 10.83L18.74 12.23L18.74 12.8L18.33 13.63L18.07 13.92L17.67 14.24L16.55 14.94L14.54 16.36L14.51 16.55L14.56 16.73L15.73 19.55L15.91 20.11L16.01 20.77L15.83 21.33L15.42 21.72L12.33 23.78L11.95 23.91L11.39 23.88L11.02 23.7L10.79 23.39L10.57 22.73L10.34 22.27L9.22 19.55L8.75 18.23L8.59 17.58L8.3 16.98L7.92 16.61L7.55 16.44L7.27 16.4L6.89 16.44L6.05 16.94L5.77 17.03L5.3 17.04L4.83 16.84L4.55 16.55L3.16 14.48L2 13.08L1.82 12.52L1.86 12.05L2.08 11.58L2.39 11.28L2.86 11.04L15.42 2.47L16.45 1.83L16.55 1.73L16.6 1.55L16.4 1.08L16.36 0.8L16.41 0.52L16.59 0.23ZM17.61 3.89L17.86 3.82L18.05 3.84L18.23 3.92L18.42 4.1L18.54 4.36L18.56 4.64L18.49 4.83L18.33 4.95L17.3 5.7L9.61 10.91L8.02 12.07L6.14 13.29L5.86 13.41L5.48 13.43L5.3 13.39L5.04 13.17L4.94 12.89L4.97 12.61L5.11 12.4L5.58 12.03L7.92 10.48L8.86 9.78L11.02 8.4L14.86 5.79L16.55 4.53ZM16.23 10.17L16.36 10.11L16.45 10.18L16.94 11.95L16.98 12.52L16.73 12.76L15.7 13.42L14.11 14.6L13.92 14.62L13.76 14.48L13.62 14.2L12.96 12.23L13.36 11.94Z" },
    instagram: { rule: "nonzero", d: "M7.0301.084c-1.2768.0602-2.1487.264-2.911.5634-.7888.3075-1.4575.72-2.1228 1.3877-.6652.6677-1.075 1.3368-1.3802 2.127-.2954.7638-.4956 1.6365-.552 2.914-.0564 1.2775-.0689 1.6882-.0626 4.947.0062 3.2586.0206 3.6671.0825 4.9473.061 1.2765.264 2.1482.5635 2.9107.308.7889.72 1.4573 1.388 2.1228.6679.6655 1.3365 1.0743 2.1285 1.38.7632.295 1.6361.4961 2.9134.552 1.2773.056 1.6884.069 4.9462.0627 3.2578-.0062 3.668-.0207 4.9478-.0814 1.28-.0607 2.147-.2652 2.9098-.5633.7889-.3086 1.4578-.72 2.1228-1.3881.665-.6682 1.0745-1.3378 1.3795-2.1284.2957-.7632.4966-1.636.552-2.9124.056-1.2809.0692-1.6898.063-4.948-.0063-3.2583-.021-3.6668-.0817-4.9465-.0607-1.2797-.264-2.1487-.5633-2.9117-.3084-.7889-.72-1.4568-1.3876-2.1228C21.2982 1.33 20.628.9208 19.8378.6165 19.074.321 18.2017.1197 16.9244.0645 15.6471.0093 15.236-.005 11.977.0014 8.718.0076 8.31.0215 7.0301.0839m.1402 21.6932c-1.17-.0509-1.8053-.2453-2.2287-.408-.5606-.216-.96-.4771-1.3819-.895-.422-.4178-.6811-.8186-.9-1.378-.1644-.4234-.3624-1.058-.4171-2.228-.0595-1.2645-.072-1.6442-.079-4.848-.007-3.2037.0053-3.583.0607-4.848.05-1.169.2456-1.805.408-2.2282.216-.5613.4762-.96.895-1.3816.4188-.4217.8184-.6814 1.3783-.9003.423-.1651 1.0575-.3614 2.227-.4171 1.2655-.06 1.6447-.072 4.848-.079 3.2033-.007 3.5835.005 4.8495.0608 1.169.0508 1.8053.2445 2.228.408.5608.216.96.4754 1.3816.895.4217.4194.6816.8176.9005 1.3787.1653.4217.3617 1.056.4169 2.2263.0602 1.2655.0739 1.645.0796 4.848.0058 3.203-.0055 3.5834-.061 4.848-.051 1.17-.245 1.8055-.408 2.2294-.216.5604-.4763.96-.8954 1.3814-.419.4215-.8181.6811-1.3783.9-.4224.1649-1.0577.3617-2.2262.4174-1.2656.0595-1.6448.072-4.8493.079-3.2045.007-3.5825-.006-4.848-.0608M16.953 5.5864A1.44 1.44 0 1 0 18.39 4.144a1.44 1.44 0 0 0-1.437 1.4424M5.8385 12.012c.0067 3.4032 2.7706 6.1557 6.173 6.1493 3.4026-.0065 6.157-2.7701 6.1506-6.1733-.0065-3.4032-2.771-6.1565-6.174-6.1498-3.403.0067-6.156 2.771-6.1496 6.1738M8 12.0077a4 4 0 1 1 4.008 3.9921A3.9996 3.9996 0 0 1 8 12.0077" },
  };
  // Songs without an artist of their own are credited to one of these, picked at random on every visit (both names
  // always appear).
  const ARTISTS = ["Heaven", "Saigned"];
  // Colours from the covers' palette (README, 6.6): the blank record cover, and the page's glow until a cover's own
  // colour is known.
  const P = { bone: "#FBF7F2", blush: "#EBC3C3", rose: "#D98C95" };
  // The songs in library order, by their file names in sai_songs/ (without .mp3). A song whose file is tagged with an
  // artist keeps it. The build adds the rest from the files themselves: each song's title and producer's credit (a
  // "(prod …)" at the end of the file name), where its MP3 is, its length, and its loudness and bass every 50 ms
  // (base64, one byte per reading, from peaks.json).
  const SONGS = [
    { file: "a spin" },
    { file: "cliche" },
    { file: "_lucid" },
    { file: "Who's that out there! (prod.wixxy)", artist: "Heaven" },
    { file: "Interest (prod kuga)", artist: "Heaven, vezxqr" },
    { file: "scream" },
  ];
  const SONG_DATA = /*SONGDATA*/{};
  SONGS.forEach((song) => Object.assign(song, SONG_DATA[song.file] || { title: song.file, credit: "", src: "", duration: 0 }));
  // The images in song_covers/ (copied to covers/ under web-safe names by the build), dealt out to the songs at
  // random on every visit.
  const COVERS = /*COVERS*/[];

  /* ---------- helpers ---------- */
  const $ = (id) => document.getElementById(id);
  const clamp = (v, lo, hi) => Math.min(hi, Math.max(lo, v));
  const now = () => performance.now();
  const pad2 = (n) => String(n).padStart(2, "0");
  const byline = (s) => (s.credit ? `${s.artist} · ${s.credit}` : s.artist); // the artist, then any producer's credit
  function fmt(sec) {
    const s = Math.max(0, Math.floor(sec));
    const h = Math.floor(s / 3600), m = Math.floor((s % 3600) / 60), r = s % 60;
    return h ? `${h}:${pad2(m)}:${pad2(r)}` : `${m}:${pad2(r)}`;
  }
  function el(tag, cls, text) {
    const e = document.createElement(tag);
    if (cls) e.className = cls;
    if (text != null) e.textContent = text;
    return e;
  }
  const hexRgb = (hex) => { const n = parseInt(hex.slice(1), 16); return [n >> 16, (n >> 8) & 255, n & 255]; };
  function shuffled(arr) {
    const a = arr.slice();
    for (let i = a.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [a[i], a[j]] = [a[j], a[i]];
    }
    return a;
  }
  function addGrain(g, S, amount) {
    const img = g.getImageData(0, 0, S, S), d = img.data;
    for (let i = 0; i < d.length; i += 4) {
      const n = (Math.random() - 0.5) * amount;
      d[i] += n; d[i + 1] += n; d[i + 2] += n;
    }
    g.putImageData(img, 0, 0);
  }

  /* ---------- covers ---------- */
  // The page's soft glow takes each cover's strongest colour: its reds and pinks rather than its whites.
  function coverTint(src) {
    return new Promise((resolve) => {
      const im = new Image();
      im.onload = () => {
        try {
          const S = 24;
          const c = document.createElement("canvas");
          c.width = c.height = S;
          const g = c.getContext("2d");
          g.drawImage(im, 0, 0, S, S);
          const d = g.getImageData(0, 0, S, S).data;
          let r = 0, gr = 0, b = 0, sum = 0;
          for (let i = 0; i < d.length; i += 4) {
            const hi = Math.max(d[i], d[i + 1], d[i + 2]), lo = Math.min(d[i], d[i + 1], d[i + 2]);
            const sat = hi ? (hi - lo) / hi : 0;
            const w = sat * sat + 0.002;
            r += d[i] * w; gr += d[i + 1] * w; b += d[i + 2] * w; sum += w;
          }
          resolve(`rgb(${Math.round(r / sum)}, ${Math.round(gr / sum)}, ${Math.round(b / sum)})`);
        } catch {
          resolve(P.rose);
        }
      };
      im.onerror = () => resolve(P.rose);
      im.src = src;
    });
  }
  // Shown before anything plays: a pale record on blush paper.
  function makeBlankCover() {
    const S = 480;
    const c = document.createElement("canvas");
    c.width = c.height = S;
    const g = c.getContext("2d");
    const base = g.createLinearGradient(0, 0, S, S);
    base.addColorStop(0, P.bone);
    base.addColorStop(0.5, P.blush);
    base.addColorStop(1, P.rose);
    g.fillStyle = base;
    g.fillRect(0, 0, S, S);
    const bloom = g.createRadialGradient(S * 0.25, S * 0.2, 0, S * 0.25, S * 0.2, S * 0.6);
    bloom.addColorStop(0, "rgba(255,255,255,0.6)");
    bloom.addColorStop(1, "rgba(255,255,255,0)");
    g.fillStyle = bloom;
    g.fillRect(0, 0, S, S);
    const cx = S / 2, cy = S / 2;
    g.fillStyle = "rgba(255,255,255,0.22)";
    g.beginPath(); g.arc(cx, cy, S * 0.33, 0, Math.PI * 2); g.fill();
    g.strokeStyle = "rgba(255,255,255,0.3)";
    g.lineWidth = 2;
    for (const k of [0.29, 0.25, 0.21, 0.17]) { g.beginPath(); g.arc(cx, cy, S * k, 0, Math.PI * 2); g.stroke(); }
    g.fillStyle = "rgba(255,255,255,0.45)";
    g.beginPath(); g.arc(cx, cy, S * 0.1, 0, Math.PI * 2); g.fill();
    g.fillStyle = "rgba(94, 11, 26, 0.45)"; // oxblood
    g.beginPath(); g.arc(cx, cy, S * 0.022, 0, Math.PI * 2); g.fill();
    addGrain(g, S, 16);
    return c.toDataURL("image/jpeg", 0.86);
  }

  /* ---------- waveforms and bass ---------- */
  const b64bytes = (s) => {
    const bin = atob(s);
    const out = new Uint8Array(bin.length);
    for (let i = 0; i < bin.length; i++) out[i] = bin.charCodeAt(i);
    return out;
  };
  // data: overall loudness (the waveform). bass: loudness below about 140 Hz (the cover's pulse). A song that hasn't
  // been measured gets no readings, so its bars lie flat and the cover doesn't pulse (the build warns about it).
  function decodeWave(song) {
    if (!song.peaks) return { rate: 20, data: new Uint8Array(0), bass: new Uint8Array(0) };
    return { rate: song.rate, data: b64bytes(song.peaks), bass: b64bytes(song.bass || "") };
  }
  // Bass hits: readings that peak clearly above the bass of the 0.6 s before them, at least 0.3 s apart.
  function findBeats(wave) {
    const b = wave.bass, look = Math.round(wave.rate * 0.6), gap = Math.round(wave.rate * 0.3), beats = [];
    let last = -Infinity;
    for (let i = 1; i < b.length - 1; i++) {
      const v = b[i];
      if (v < 110 || v < b[i - 1] || v <= b[i + 1] || i - last < gap) continue;
      let sum = 0, n = 0;
      for (let k = Math.max(0, i - look); k < i; k++) { sum += b[k]; n++; }
      if (n && v > (sum / n) * 1.25 + 12) { beats.push(i); last = i; }
    }
    return beats;
  }

  /* ---------- remembered on this device: repeat, shuffle, Light mode, and the last song and the place in it ---------- */
  const KEY = "signedHeaven:prototype:v1";
  function loadSaved() {
    try { return JSON.parse(localStorage.getItem(KEY) || "{}") || {}; } catch { return {}; }
  }
  function save() {
    const s = cur();
    try {
      localStorage.setItem(KEY, JSON.stringify({ repeat: state.repeat, shuffle: state.shuffle, theme: state.theme, song: s ? s.file : null, at: s ? Math.round(pos()) : 0 }));
    } catch { /* storage unavailable */ }
  }
  const saved = loadSaved();

  const state = {
    queue: [],
    qi: -1,
    playing: false,
    buffering: false, // the song is loading or catching up
    error: null, // the song that couldn't be played
    basePos: 0, // where the current song is while its file isn't loaded, or where to start it
    shuffle: saved.shuffle === true,
    repeat: ["off", "all", "one"].includes(saved.repeat) ? saved.repeat : "off",
    holdDir: 0,
    sel: 0,
    theme: saved.theme === "light" || saved.theme === "dark" ? saved.theme : null, // null: follow the device
  };
  const root = document.documentElement;

  /* ---------- announcements ---------- */
  const live = $("live");
  let liveTimer = 0;
  function announce(msg) {
    clearTimeout(liveTimer);
    live.textContent = "";
    liveTimer = setTimeout(() => { live.textContent = msg; }, 60);
  }

  /* ---------- playback: one <audio> element for the whole visit ---------- */
  // After the engine planned in the README (5.2 to 5.6). One element plays every song, which keeps auto-advance working
  // on phones with the screen off, and nothing is downloaded until the first play. The waveform, the pulse and the
  // equaliser read the element's own clock, so they stay in time with what you hear. The files are the MP3s from
  // sai_songs/, copied beside the page by the build (each song's src says where).
  const audio = new Audio();
  audio.preload = "none";
  let audioFor = null; // the song whose file the element holds
  let playToken = 0; // each play request gets a token, so a superseded request's failure is ignored
  let failures = 0; // songs that failed to play in a row
  let refetched = null; // the song fetched whole after the element couldn't stream it
  let blobUrl = "";
  let waveDirty = true;
  const cur = () => (state.qi >= 0 ? SONGS[state.queue[state.qi]] : null);
  // whether the element holds song s and knows its length, so it can say where it is and seek
  const ready = (s) => !!s && audioFor === s && audio.readyState >= 1;
  function pos() {
    const s = cur();
    if (!s) return 0;
    return clamp(ready(s) ? audio.currentTime : state.basePos, 0, s.duration);
  }
  function setPos(p) {
    const s = cur();
    if (!s) return;
    state.basePos = clamp(p, 0, s.duration);
    if (ready(s)) {
      try { audio.currentTime = state.basePos; } catch { /* not seekable yet: applied once the file is ready */ }
    }
    waveDirty = true;
    syncSession();
  }
  // Puts song s's file in the element. A different song replaces the old file; the same song keeps its place.
  function loadAudio(s) {
    if (audioFor === s) return;
    audioFor = s;
    refetched = null;
    state.buffering = false;
    if (blobUrl) { URL.revokeObjectURL(blobUrl); blobUrl = ""; }
    audio.src = s.src;
  }
  // Starts or resumes the current song. play() returns a promise: NotAllowedError means the browser wants a tap
  // first, so the player shows the paused state; AbortError means a newer request replaced this one; a file that
  // can't be played is dealt with by the element's error event.
  function startAudio() {
    const s = cur();
    if (!s) return;
    loadAudio(s);
    state.playing = true;
    const token = ++playToken;
    let request;
    try { request = audio.play(); } catch (err) { request = Promise.reject(err); }
    if (request && request.catch) {
      request.catch((err) => {
        const name = err && err.name;
        if (token !== playToken || name === "AbortError" || name === "NotSupportedError") return;
        state.playing = false;
        state.buffering = false;
        renderAll();
      });
    }
  }
  // Pauses the element and shows the song as paused; a play request still on its way is superseded.
  function stopAudio() {
    playToken++;
    audio.pause();
    state.playing = false;
    state.buffering = false;
  }
  const libraryOrder = () => SONGS.map((_, i) => i);
  // The queue: the library in order or, with shuffle on, song `first` followed by the others in a random order.
  const queueFrom = (first, shuffle) => (shuffle ? [first, ...shuffled(libraryOrder().filter((i) => i !== first))] : libraryOrder());
  function startQueue(songIndex, shuffle) {
    const first = songIndex ?? (shuffle ? Math.floor(Math.random() * SONGS.length) : 0);
    state.shuffle = shuffle;
    state.queue = queueFrom(first, shuffle);
    state.qi = state.queue.indexOf(first);
    loadCurrent(true);
  }
  function loadCurrent(autoplay) {
    const s = cur();
    state.basePos = 0;
    state.error = null;
    state.buffering = false;
    if (s) {
      root.style.setProperty("--tint", s.tint);
      skyForSong(state.queue[state.qi], now());
      announce(autoplay ? `Now playing: ${s.title} by ${s.artist}` : `${s.title} by ${s.artist}, paused`);
      setSessionSong(s);
      if (audioFor === s) {
        try { audio.currentTime = 0; } catch { /* not loaded yet */ }
      }
    }
    if (autoplay && s) startAudio();
    else stopAudio();
    renderAll();
    save();
  }
  function play() {
    if (!cur()) { startQueue(state.sel, state.shuffle); return; }
    state.error = null;
    startAudio();
    renderAll();
  }
  function pause() {
    if (!state.playing) return;
    state.basePos = pos();
    stopAudio();
    renderAll();
    save();
  }
  function togglePlay() { if (state.playing) pause(); else play(); }
  function chooseSong(i) {
    if (cur() && state.queue[state.qi] === i) { togglePlay(); return; }
    startQueue(i, false);
  }
  function goNext() {
    if (!cur()) return;
    if (state.qi < state.queue.length - 1) { state.qi++; loadCurrent(state.playing); return; }
    if (state.repeat === "all") {
      if (state.shuffle) {
        const last = state.queue[state.qi];
        const q = shuffled(libraryOrder());
        if (q[0] === last && q.length > 1) q.push(q.shift());
        state.queue = q;
      }
      state.qi = 0;
      loadCurrent(state.playing);
      return;
    }
    // End of the list: stop, ready at the start of the last song.
    stopAudio();
    setPos(0);
    renderAll();
  }
  function goPrev() {
    if (!cur()) return;
    if (pos() > 3) { setPos(0); return; }
    if (state.qi > 0) { state.qi--; loadCurrent(state.playing); return; }
    if (state.repeat === "all") { state.qi = state.queue.length - 1; loadCurrent(state.playing); return; }
    setPos(0);
  }
  function setShuffle(on) {
    if (cur()) {
      const curIdx = state.queue[state.qi];
      state.queue = queueFrom(curIdx, on);
      state.qi = state.queue.indexOf(curIdx);
    }
    state.shuffle = on;
    announce(`Shuffle ${on ? "on" : "off"}`);
    renderAll();
    save();
  }
  const REPEAT_LABEL = { off: "Off", all: "All", one: "One" };
  function cycleRepeat() {
    state.repeat = { off: "all", all: "one", one: "off" }[state.repeat];
    save();
    announce(`Repeat: ${REPEAT_LABEL[state.repeat]}`);
    renderAll();
  }
  // Says a song couldn't be played and, if the listener was listening, moves on to the next one after a moment.
  // After three failures in a row it stops there, since the listener is probably offline.
  function failSong(s, wanted) {
    failures++;
    state.error = s;
    stopAudio();
    announce(`Couldn't play ${s.title}`);
    renderAll();
    if (!wanted || failures >= 3) return;
    setTimeout(() => {
      if (state.error !== s || cur() !== s) return;
      state.error = null;
      state.playing = true;
      goNext();
    }, 1800);
  }

  // What the element reports. A pause while a song is ending, or while a new song takes over, isn't the listener
  // pausing, so it's ignored; any other pause (unplugged headphones, another app taking the sound) shows as paused.
  audio.addEventListener("playing", () => {
    failures = 0;
    state.buffering = false;
    state.playing = true;
    renderAll();
  });
  audio.addEventListener("pause", () => {
    if (audio.ended || !audio.paused || !state.playing) return;
    state.basePos = audio.currentTime;
    stopAudio();
    renderAll();
  });
  audio.addEventListener("waiting", () => {
    if (state.playing && !state.buffering) { state.buffering = true; renderCard(); }
  });
  audio.addEventListener("canplay", () => {
    if (state.buffering && !audio.paused) { state.buffering = false; renderCard(); }
  });
  audio.addEventListener("loadedmetadata", () => {
    const s = audioFor;
    if (!s) return;
    if (Number.isFinite(audio.duration) && audio.duration > 0) s.duration = audio.duration; // the file's own length
    if (cur() === s && state.basePos > 0) {
      try { audio.currentTime = Math.min(state.basePos, s.duration); } catch { /* not seekable */ }
    }
    renderCard();
    syncSession();
  });
  audio.addEventListener("seeked", syncSession);
  audio.addEventListener("ended", () => {
    if (audioFor !== cur()) return;
    if (state.repeat === "one") { setPos(0); startAudio(); return; }
    goNext();
  });
  let lastSave = 0;
  audio.addEventListener("timeupdate", () => {
    if (state.playing && now() - lastSave > 5000) { lastSave = now(); save(); }
  });
  audio.addEventListener("error", () => {
    const s = audioFor;
    if (!s || !audio.error) return;
    const wanted = state.playing;
    // Some hosts can't serve the partial downloads that streaming relies on, so the whole file is fetched once and
    // played from memory. If that fails too, the song is skipped.
    if (refetched !== s && s.src) {
      refetched = s;
      if (wanted) { state.buffering = true; renderCard(); }
      fetch(s.src)
        .then((r) => { if (!r.ok) throw new Error(`HTTP ${r.status}`); return r.blob(); })
        .then((b) => {
          if (audioFor !== s) return;
          if (blobUrl) URL.revokeObjectURL(blobUrl);
          blobUrl = URL.createObjectURL(b);
          audio.src = blobUrl;
          if (wanted && cur() === s) startAudio();
        })
        .catch(() => { if (audioFor === s) failSong(s, wanted); });
      return;
    }
    failSong(s, wanted);
  });
  // the place in the song is saved every 5 seconds while playing, and whenever the page is left or hidden
  window.addEventListener("pagehide", () => save());
  document.addEventListener("visibilitychange", () => { if (document.visibilityState === "hidden") save(); });

  // Lock-screen, notification and headphone controls, and keyboard media keys (README 5.5).
  const session = "mediaSession" in navigator ? navigator.mediaSession : null;
  function setSessionSong(s) {
    if (!session || typeof MediaMetadata === "undefined") return;
    try {
      session.metadata = new MediaMetadata({
        title: s.title,
        artist: byline(s),
        album: "signedHeaven",
        artwork: [{ src: new URL(s.cover, document.baseURI).href, type: "image/jpeg" }],
      });
    } catch { /* not supported here */ }
  }
  function syncSession() {
    if (!session) return;
    const s = cur();
    try { session.playbackState = state.playing ? "playing" : s ? "paused" : "none"; } catch { /* not supported here */ }
    if (!ready(s) || !session.setPositionState || !Number.isFinite(audio.duration)) return;
    try {
      session.setPositionState({ duration: audio.duration, playbackRate: audio.playbackRate || 1, position: Math.min(audio.currentTime, audio.duration) });
    } catch { /* briefly out of range while seeking */ }
  }
  if (session) {
    const on = (action, fn) => { try { session.setActionHandler(action, fn); } catch { /* this action isn't supported */ } };
    on("play", () => play());
    on("pause", () => pause());
    on("previoustrack", () => goPrev());
    on("nexttrack", () => goNext());
    on("seekto", (d) => { if (d && Number.isFinite(d.seekTime)) setPos(d.seekTime); });
    on("seekbackward", (d) => setPos(pos() - ((d && d.seekOffset) || 10)));
    on("seekforward", (d) => setPos(pos() + ((d && d.seekOffset) || 10)));
  }

  /* ---------- the player: current song on top, an endless wheel of songs beneath ---------- */
  const list = $("songList"); // the wheel itself: a listbox whose options are hidden copies for screen readers
  const drum = $("pickerDrum"), optionsBox = $("pickerOptions");
  const npArt = $("npArt"), npTitle = $("npTitle"), npArtist = $("npArtist");
  let options = [];
  let BLANK_COVER = "";
  // a cover that can't be loaded shows the blank record instead of a broken image
  const blankOnError = (img) => img.addEventListener("error", () => { if (BLANK_COVER && img.src !== BLANK_COVER) img.src = BLANK_COVER; });
  blankOnError(npArt);

  // The wheel, after the iPhone Clock's timer picker. `wheel` is a position counted in rows: a whole number puts a
  // song in the middle band, and the songs repeat in both directions, so the wheel never runs out.
  const SLOT_SPAN = 4; // rows drawn above and below the middle
  const STEP = 21; // degrees between neighbouring rows on the drum
  const mod = (n, m) => ((n % m) + m) % m;
  let slots = [], rowH = 44, radius = 120, slotBase = null;
  let wheel = 0, wheelVel = 0, wheelTarget = null, wheelEase = 12, wheelIdle = 0, drag = null;

  function buildDrum() {
    drum.replaceChildren();
    slots = [];
    for (let k = -SLOT_SPAN; k <= SLOT_SPAN; k++) {
      const row = el("div", "wheel-row");
      const im = el("img", "thumb");
      im.alt = "";
      blankOnError(im);
      const label = el("span", "label"), right = el("span", "right"), eq = el("span", "eq");
      eq.append(el("i"), el("i"), el("i"));
      row.append(im, label, eq, right);
      drum.append(row);
      slots.push({ k, row, im, label, right, song: -1 });
    }
    sizeDrum();
  }
  function sizeDrum() {
    rowH = clamp((list.clientHeight || 280) / 5.4, 34, 54);
    radius = rowH / (2 * Math.sin((STEP * Math.PI) / 360));
    list.style.setProperty("--row-h", `${rowH.toFixed(1)}px`);
    slotBase = null;
    layoutDrum();
  }
  // Puts each drawn row on the drum for the wheel's position. Songs are reassigned to rows only when a new song
  // reaches the middle; each row's tilt, depth and fade are worked out every time.
  function layoutDrum() {
    const base = Math.round(wheel), f = wheel - base, N = SONGS.length;
    if (base !== slotBase) {
      slotBase = base;
      for (const s of slots) {
        const i = mod(base + s.k, N);
        if (s.song === i) continue;
        const song = SONGS[i];
        s.song = i;
        s.im.src = song.cover;
        s.label.textContent = song.title;
        s.right.textContent = fmt(song.duration);
      }
      refreshMarks();
    }
    for (const s of slots) {
      const a = (s.k - f) * STEP;
      if (Math.abs(a) > 84) { s.row.style.visibility = "hidden"; continue; }
      const r = (a * Math.PI) / 180;
      s.row.style.visibility = "";
      s.row.style.transform = `translateY(${(radius * Math.sin(r)).toFixed(2)}px) translateZ(${(radius * (Math.cos(r) - 1)).toFixed(2)}px) rotateX(${(-a).toFixed(2)}deg)`;
      s.row.style.opacity = (0.12 + 0.88 * Math.cos(r) ** 3).toFixed(3);
      s.row.classList.toggle("centre", Math.abs(s.k - f) < 0.5);
    }
  }
  // The nearest wheel position that shows song i in the middle, going whichever way round is shorter.
  function nearestPos(i) {
    const from = Math.round(wheelTarget ?? wheel), N = SONGS.length;
    let d = mod(i - from, N);
    if (d > N / 2) d -= N;
    return from + d;
  }
  function spinTo(pos, ease = 12) {
    wheelTarget = pos;
    wheelEase = ease;
    wheelVel = 0;
  }
  // Every frame: glide to a target, coast after a flick and then settle on the nearest row, or settle once
  // scrolling stops. The row that comes to rest in the middle becomes the chosen song.
  function tickWheel(dt) {
    if (drag) return;
    if (wheelTarget !== null) {
      wheel += (wheelTarget - wheel) * (1 - Math.exp(-dt * wheelEase));
      if (Math.abs(wheelTarget - wheel) < 0.002) {
        wheel = wheelTarget;
        wheelTarget = null;
        const i = mod(Math.round(wheel), SONGS.length);
        if (i !== state.sel) setSel(i, true);
      }
      layoutDrum();
    } else if (wheelVel) {
      wheel += wheelVel * dt;
      wheelVel *= Math.exp(-dt * 3);
      if (Math.abs(wheelVel) < 1) spinTo(Math.round(wheel), 10);
      layoutDrum();
    } else if (wheelIdle && now() - wheelIdle > 140) {
      wheelIdle = 0;
      spinTo(Math.round(wheel), 10);
    }
  }
  list.addEventListener("wheel", (e) => {
    e.preventDefault();
    const px = e.deltaY * (e.deltaMode === 1 ? 32 : e.deltaMode === 2 ? 300 : 1);
    wheel += clamp(px / (rowH * 1.6), -1, 1);
    wheelTarget = null;
    wheelVel = 0;
    wheelIdle = now();
    layoutDrum();
  }, { passive: false });
  list.addEventListener("pointerdown", (e) => {
    if (e.button !== 0) return;
    list.setPointerCapture(e.pointerId);
    list.classList.add("dragging");
    drag = { id: e.pointerId, y0: e.clientY, w0: wheel, y: e.clientY, t: now(), v: 0, moved: 0 };
    wheelTarget = null;
    wheelVel = 0;
  });
  list.addEventListener("pointermove", (e) => {
    if (!drag || e.pointerId !== drag.id) return;
    const t = now(), dtS = Math.max(0.008, (t - drag.t) / 1000);
    drag.v = 0.75 * (-(e.clientY - drag.y) / rowH / dtS) + 0.25 * drag.v;
    drag.y = e.clientY;
    drag.t = t;
    drag.moved = Math.max(drag.moved, Math.abs(e.clientY - drag.y0));
    wheel = drag.w0 - (e.clientY - drag.y0) / rowH;
    layoutDrum();
  });
  function endDrag(e) {
    if (!drag || e.pointerId !== drag.id) return;
    const d = drag;
    drag = null;
    list.classList.remove("dragging");
    if (d.moved < 6 && e.type === "pointerup") {
      // a tap: turn the tapped row to the middle and play it
      const r = list.getBoundingClientRect();
      const sin = clamp((e.clientY - (r.top + r.height / 2)) / radius, -0.99, 0.99);
      const target = Math.round(wheel) + Math.round((Math.asin(sin) * 180) / Math.PI / STEP);
      const i = mod(target, SONGS.length);
      spinTo(target, 12);
      setSel(i, true);
      chooseSong(i);
    } else if (now() - d.t > 90) {
      spinTo(Math.round(wheel), 10); // held still before letting go: just settle
    } else {
      wheelVel = clamp(d.v, -30, 30);
      if (Math.abs(wheelVel) < 1) spinTo(Math.round(wheel), 10);
    }
  }
  list.addEventListener("pointerup", endDrag);
  list.addEventListener("pointercancel", endDrag);
  window.addEventListener("resize", () => sizeDrum());

  function renderList() {
    optionsBox.replaceChildren();
    options = SONGS.map((song, i) => {
      const o = el("div", null, song.title);
      o.id = `song-${i}`;
      o.setAttribute("role", "option");
      optionsBox.append(o);
      return o;
    });
    buildDrum();
    // the wheel spins into place when the page opens
    wheel = -2 * SONGS.length;
    layoutDrum();
    setSel(state.sel, true);
    spinTo(nearestPos(state.sel) + 2 * SONGS.length, 4.5);
  }
  // Chooses song i (wrapping around the ends) and turns the wheel to it, unless the wheel itself is choosing.
  function setSel(i, fromWheel = false) {
    state.sel = mod(i, SONGS.length);
    options.forEach((o, k) => o.setAttribute("aria-selected", String(k === state.sel)));
    if (options[state.sel]) list.setAttribute("aria-activedescendant", options[state.sel].id);
    if (!fromWheel) spinTo(nearestPos(state.sel), 12);
  }
  function markPlaying() {
    const playingIdx = cur() ? state.queue[state.qi] : -1;
    options.forEach((o, i) => {
      const song = SONGS[i];
      const status = i === playingIdx ? (state.playing ? ", now playing" : ", paused") : "";
      o.setAttribute("aria-label", `${song.title} by ${song.artist}${song.credit ? ` (${song.credit})` : ""}, ${fmt(song.duration)}${status}`);
    });
    refreshMarks();
  }
  // Every row showing the playing song gets the equaliser mark (with only a few songs, it shows on more than one).
  function refreshMarks() {
    const playingIdx = cur() ? state.queue[state.qi] : -1, bars = [];
    for (const s of slots) {
      const on = s.song === playingIdx;
      s.row.classList.toggle("playing", on);
      if (on) bars.push(...s.row.querySelectorAll(".eq i"));
    }
    eqBars = bars.length ? bars : null;
  }
  // A new title rolls in letter by letter. Screen readers get the whole title from a hidden copy.
  function setRolling(node, text) {
    if (node.dataset.text === text) return;
    node.dataset.text = text;
    const shown = el("span");
    shown.setAttribute("aria-hidden", "true");
    let i = 0;
    for (const part of text.split(/(\s+)/)) {
      if (!part) continue;
      if (/^\s+$/.test(part)) { shown.append(" "); continue; }
      const word = el("span", "word");
      for (const letter of part) {
        const ch = el("span", "ch", letter);
        ch.style.setProperty("--i", i++);
        word.append(ch);
      }
      shown.append(word);
    }
    node.replaceChildren(el("span", "sr-only", text), shown);
  }
  function setFading(node, text, delay) {
    if (node.textContent === text) return;
    node.textContent = text;
    node.animate(
      [{ opacity: 0, transform: "translateY(6px)", filter: "blur(4px)" }, { opacity: 1, transform: "none", filter: "blur(0px)" }],
      { duration: 550, delay, easing: "cubic-bezier(0.2, 0.8, 0.2, 1)", fill: "backwards" },
    );
  }
  function renderPlate() {
    const s = cur();
    const src = s ? s.cover : BLANK_COVER;
    if (npArt.dataset.src !== src) {
      const first = !npArt.dataset.src;
      npArt.src = src;
      npArt.dataset.src = src;
      // a new cover zooms in out of a soft blur, then a shine passes over it (after animate-ui's Zoom and Shine)
      if (!first) {
        npArt.animate(
          [{ opacity: 0, transform: "scale(0.88) rotate(-2deg)", filter: "blur(10px)" }, { opacity: 1, transform: "none", filter: "blur(0px)" }],
          { duration: 650, easing: "cubic-bezier(0.2, 0.8, 0.2, 1)" },
        );
        artShine.animate(
          [{ backgroundPosition: "130% 0", opacity: 1 }, { backgroundPosition: "-30% 0", opacity: 0 }],
          { duration: 1200, delay: 250, easing: "ease-out" },
        );
      }
    }
    setRolling(npTitle, s ? s.title : "Choose a song");
    const line = !s ? "Pick one from the list"
      : state.error === s ? (failures >= 3 ? "Couldn't play this song. Check your connection" : "Couldn't play this song")
      : byline(s);
    setFading(npArtist, line, 200);
    showSkeleton(s && state.playing ? s.cover : "");
  }

  /* ---------- the cover's bass pulse and tilt ---------- */
  const plate = $("plate"), artStage = $("artStage"), artTilt = $("artTilt"), artThump = $("artThump"), artShine = $("artShine");
  const pulseGlow = $("pulseGlow"), pulseRings = $("pulseRings");
  let bassLevel = 0, shownBass = -1, beatSong = null, beatCursor = 0, lastPulsePos = 0, eqBars = null;
  const levelAt = (arr, rate, t) => {
    const i = Math.floor(t * rate);
    return arr && i >= 0 && i < arr.length ? arr[i] / 255 : 0;
  };
  function emitRing(strength) {
    if (pulseRings.childElementCount >= 4) return;
    const ring = el("i", "pulse-ring");
    ring.style.setProperty("--ring-o", (0.3 + strength * 0.5).toFixed(2));
    ring.addEventListener("animationend", () => ring.remove());
    pulseRings.append(ring);
  }
  // Every frame: the glow swells with the bass under the playhead (rising fast, settling slowly), the cover gives
  // the smallest thump, a ring spreads on each bass hit, and the equaliser mark follows the music.
  function tickPulse(dt, t) {
    const s = cur(), live = !!(s && state.playing), w = s && s.wave;
    const target = live ? Math.pow(levelAt(w.bass, w.rate, t), 1.5) : 0;
    bassLevel += (target - bassLevel) * (1 - Math.exp(-dt / (target > bassLevel ? 0.035 : 0.25)));
    if (Math.abs(bassLevel - shownBass) > 0.002) {
      shownBass = bassLevel;
      pulseGlow.style.transform = `scale(${(0.8 + bassLevel * 0.45).toFixed(3)})`;
      pulseGlow.style.opacity = (0.22 + bassLevel * 0.78).toFixed(3);
      artThump.style.transform = `scale(${(1 + bassLevel * 0.035).toFixed(4)})`;
    }
    if (live) {
      if (beatSong !== s || t < lastPulsePos || t - lastPulsePos > 0.5) {
        // a new song or a jump: carry on from here without firing the hits that were skipped
        beatSong = s;
        beatCursor = s.beats.findIndex((i) => i / w.rate >= t);
        if (beatCursor < 0) beatCursor = s.beats.length;
      } else {
        while (beatCursor < s.beats.length && s.beats[beatCursor] / w.rate <= t) {
          emitRing(levelAt(w.bass, w.rate, s.beats[beatCursor] / w.rate));
          beatCursor++;
        }
      }
      lastPulsePos = t;
    }
    if (eqBars) {
      const v = live ? [levelAt(w.bass, w.rate, t), levelAt(w.data, w.rate, t), levelAt(w.data, w.rate, t - 0.15)] : [0.15, 0.3, 0.15];
      eqBars.forEach((bar, k) => { bar.style.transform = `scaleY(${(0.2 + v[k] * 0.8).toFixed(3)})`; });
    }
  }
  // The cover tilts gently towards the pointer and catches a shine as it moves (mouse and pen; touch skips it).
  plate.addEventListener("pointermove", (e) => {
    if (e.pointerType === "touch") return;
    const r = artStage.getBoundingClientRect();
    const x = clamp((e.clientX - r.left) / r.width, -0.25, 1.25), y = clamp((e.clientY - r.top) / r.height, -0.25, 1.25);
    artTilt.classList.add("is-tilting");
    artTilt.style.setProperty("--ry", `${((x - 0.5) * 16).toFixed(2)}deg`);
    artTilt.style.setProperty("--rx", `${((0.5 - y) * 16).toFixed(2)}deg`);
    artTilt.style.setProperty("--shine-x", `${(125 - x * 110).toFixed(1)}%`);
    artTilt.style.setProperty("--shine-o", "1");
  });
  plate.addEventListener("pointerleave", () => {
    artTilt.classList.remove("is-tilting");
    artTilt.style.setProperty("--rx", "0deg");
    artTilt.style.setProperty("--ry", "0deg");
    artTilt.style.setProperty("--shine-o", "0");
  });

  /* ---------- skeleton art ---------- */
  // Each cover traced down to its outlines: softened, its edges found (Sobel), thinned to their crests (the
  // picture's "skeleton") and kept only where they're strong. The lines become a mask, made once per cover.
  const skeletons = $("skeletons"), skelLayers = [$("skeletonA"), $("skeletonB")];
  const skeletonCache = new Map();
  let skelFront = 0, skelSrc = "";
  function boxBlur(src, S, r) {
    const tmp = new Float32Array(src.length), out = new Float32Array(src.length), w = 2 * r + 1;
    for (let y = 0; y < S; y++) {
      let acc = 0;
      for (let x = -r; x <= r; x++) acc += src[y * S + clamp(x, 0, S - 1)];
      for (let x = 0; x < S; x++) {
        tmp[y * S + x] = acc / w;
        acc += src[y * S + Math.min(S - 1, x + r + 1)] - src[y * S + Math.max(0, x - r)];
      }
    }
    for (let x = 0; x < S; x++) {
      let acc = 0;
      for (let y = -r; y <= r; y++) acc += tmp[clamp(y, 0, S - 1) * S + x];
      for (let y = 0; y < S; y++) {
        out[y * S + x] = acc / w;
        acc += tmp[Math.min(S - 1, y + r + 1) * S + x] - tmp[Math.max(0, y - r) * S + x];
      }
    }
    return out;
  }
  function makeSkeleton(src) {
    if (skeletonCache.has(src)) return skeletonCache.get(src);
    const job = new Promise((resolve) => {
      const im = new Image();
      im.onload = () => {
        try {
          const S = 480, c = document.createElement("canvas");
          c.width = c.height = S;
          const g = c.getContext("2d", { willReadFrequently: true });
          const side = Math.min(im.naturalWidth, im.naturalHeight);
          g.drawImage(im, (im.naturalWidth - side) / 2, (im.naturalHeight - side) / 2, side, side, 0, 0, S, S);
          const px = g.getImageData(0, 0, S, S).data;
          let lum = new Float32Array(S * S);
          for (let i = 0; i < S * S; i++) lum[i] = (px[i * 4] * 0.299 + px[i * 4 + 1] * 0.587 + px[i * 4 + 2] * 0.114) / 255;
          lum = boxBlur(boxBlur(lum, S, 2), S, 1); // soft enough that paper grain and texture don't read as lines
          const mag = new Float32Array(S * S), dir = new Uint8Array(S * S);
          for (let y = 1; y < S - 1; y++) {
            for (let x = 1; x < S - 1; x++) {
              const i = y * S + x;
              const gx = lum[i - S + 1] + 2 * lum[i + 1] + lum[i + S + 1] - lum[i - S - 1] - 2 * lum[i - 1] - lum[i + S - 1];
              const gy = lum[i + S - 1] + 2 * lum[i + S] + lum[i + S + 1] - lum[i - S - 1] - 2 * lum[i - S] - lum[i - S + 1];
              mag[i] = Math.hypot(gx, gy);
              dir[i] = Math.round(((Math.atan2(gy, gx) + Math.PI) / Math.PI) * 4) % 4;
            }
          }
          const strong = Float32Array.from(mag).sort()[Math.floor(S * S * 0.93)] || 1;
          const out = g.createImageData(S, S), o = out.data;
          const AXIS = [[1, 0], [1, 1], [0, 1], [-1, 1]];
          for (let y = 1; y < S - 1; y++) {
            for (let x = 1; x < S - 1; x++) {
              const i = y * S + x, m = mag[i], [dx, dy] = AXIS[dir[i]];
              if (m < mag[i + dy * S + dx] || m < mag[i - dy * S - dx]) continue; // not the crest of its edge
              const v = clamp((m / strong - 0.5) / 0.7, 0, 1);
              if (!v) continue;
              o[i * 4] = o[i * 4 + 1] = o[i * 4 + 2] = 255;
              o[i * 4 + 3] = Math.round(v * 255);
            }
          }
          g.putImageData(out, 0, 0);
          c.toBlob((blob) => resolve(blob ? URL.createObjectURL(blob) : null), "image/png");
        } catch {
          resolve(null);
        }
      };
      im.onerror = () => resolve(null);
      im.src = src;
    });
    skeletonCache.set(src, job);
    return job;
  }
  // While a song plays, its cover's skeleton art fades in across the sky. Two layers take turns, so a new song's art
  // crossfades with the last one. Pausing fades it out.
  function showSkeleton(src) {
    if (src === skelSrc) return;
    skelSrc = src;
    if (!src) { skelLayers.forEach((l) => l.classList.remove("on")); return; }
    makeSkeleton(src).then((url) => {
      if (!url || skelSrc !== src) return;
      const next = skelLayers[1 - skelFront];
      next.style.webkitMaskImage = next.style.maskImage = `url("${url}")`;
      next.classList.add("on");
      skelLayers[skelFront].classList.remove("on");
      skelFront = 1 - skelFront;
    });
  }
  // The art drifts a little against the pointer, and a soft light follows the pointer across its lines. With no
  // pointer about (or on a touch screen), the light wanders slowly on its own. The whole layer breathes with the bass.
  let ptrX = 0.5, ptrY = 0.5, ptrSeen = -Infinity, skX = 0.5, skY = 0.5, shownSk = "";
  window.addEventListener("pointermove", (e) => {
    if (e.pointerType === "touch") return;
    ptrX = e.clientX / innerWidth;
    ptrY = e.clientY / innerHeight;
    ptrSeen = now();
  }, { passive: true });
  function tickSkeleton(dt, ms) {
    if (!skelSrc) return;
    let tx = ptrX, ty = ptrY;
    if (ms - ptrSeen > 4000) {
      const t = ms / 1000;
      tx = 0.5 + 0.32 * Math.sin(t * 0.13);
      ty = 0.5 + 0.26 * Math.sin(t * 0.17 + 1.3);
    }
    const k = 1 - Math.exp(-dt / 0.4);
    skX += (tx - skX) * k;
    skY += (ty - skY) * k;
    const vw = innerWidth, vh = innerHeight, size = Math.min(1.18 * Math.min(vw, vh), 1180);
    const px = (0.5 - skX) * 40, py = (0.5 - skY) * 40;
    const mx = skX * vw - (vw - size) / 2 - px, my = skY * vh - (vh - size) / 2 - py;
    const key = `${px.toFixed(1)}|${py.toFixed(1)}|${mx.toFixed(0)}|${my.toFixed(0)}|${bassLevel.toFixed(2)}`;
    if (key === shownSk) return;
    shownSk = key;
    skeletons.style.setProperty("--px", `${px.toFixed(1)}px`);
    skeletons.style.setProperty("--py", `${py.toFixed(1)}px`);
    skeletons.style.setProperty("--mx", `${mx.toFixed(0)}px`);
    skeletons.style.setProperty("--my", `${my.toFixed(0)}px`);
    skeletons.style.opacity = (0.7 + bassLevel * 0.3).toFixed(3);
  }

  /* ---------- the playback card ---------- */
  const seekBar = $("seekBar"), seekFill = $("seekFill"), seekKnob = $("seekKnob"), tElapsed = $("tElapsed"), tTotal = $("tTotal");
  const cRepeat = $("cRepeat"), cPrev = $("cPrev"), cPlay = $("cPlay"), cNext = $("cNext"), cShuffle = $("cShuffle");
  let seekLast = null;

  function renderCard() {
    const s = cur();
    tTotal.textContent = s ? fmt(s.duration) : "0:00";
    seekBar.setAttribute("aria-disabled", String(!s));
    cPrev.disabled = !s;
    cNext.disabled = !s;
    cPlay.classList.toggle("is-playing", state.playing);
    cPlay.classList.toggle("is-buffering", state.playing && state.buffering);
    cPlay.setAttribute("aria-busy", String(state.playing && state.buffering));
    cPlay.setAttribute("aria-label", state.playing ? "Pause" : "Play");
    cShuffle.setAttribute("aria-pressed", String(state.shuffle));
    cRepeat.setAttribute("aria-pressed", String(state.repeat !== "off"));
    cRepeat.dataset.mode = state.repeat;
    cRepeat.setAttribute("aria-label", `Repeat: ${REPEAT_LABEL[state.repeat]}`);
    seekLast = null;
    waveDirty = true;
  }
  function updateSeek(p) {
    const s = cur();
    const pct = s ? (p / s.duration) * 100 : 0;
    seekFill.style.width = `${pct}%`;
    seekKnob.style.left = `${pct}%`;
    const sec = s ? Math.floor(p) : -1;
    if (sec === seekLast) return;
    seekLast = sec;
    tElapsed.textContent = s ? fmt(p) : "0:00";
    seekBar.setAttribute("aria-valuemax", String(s ? Math.round(s.duration) : 0));
    seekBar.setAttribute("aria-valuenow", String(s ? sec : 0));
    seekBar.setAttribute("aria-valuetext", s ? `${fmt(p)} of ${fmt(s.duration)}` : "No song playing");
  }
  function renderAll() {
    markPlaying();
    renderPlate();
    renderCard();
    syncSession(); // the lock screen shows the same state
  }
  cRepeat.addEventListener("click", cycleRepeat);
  cPrev.addEventListener("click", goPrev);
  cPlay.addEventListener("click", togglePlay);
  cNext.addEventListener("click", goNext);
  cShuffle.addEventListener("click", () => setShuffle(!state.shuffle));

  const seekAt = (e) => {
    const s = cur();
    if (!s) return;
    const r = seekBar.getBoundingClientRect();
    setPos(clamp((e.clientX - r.left) / r.width, 0, 1) * s.duration);
  };
  seekBar.addEventListener("pointerdown", (e) => {
    if (!cur()) return;
    e.preventDefault();
    seekBar.setPointerCapture(e.pointerId);
    seekBar.focus({ preventScroll: true });
    seekAt(e);
  });
  seekBar.addEventListener("pointermove", (e) => { if (seekBar.hasPointerCapture(e.pointerId)) seekAt(e); });
  seekBar.addEventListener("keydown", (e) => {
    const s = cur();
    if (!s) return;
    const delta = { ArrowLeft: -5, ArrowDown: -5, ArrowRight: 5, ArrowUp: 5 }[e.key];
    if (delta) setPos(pos() + delta);
    else if (e.key === "Home") setPos(0);
    else if (e.key === "End") setPos(s.duration - 1);
    else return;
    e.preventDefault();
  });

  /* ---------- keyboard ---------- */
  const HOLD_MS = 450;
  let keyHold = null;
  document.addEventListener("keydown", (e) => {
    if (e.ctrlKey || e.metaKey || e.altKey) return;
    const t = e.target instanceof Element ? e.target : null;
    const onButton = !!(t && t.closest("button, a"));
    const onSlider = !!(t && t.closest('[role="slider"]'));
    const onListOrPage = !t || t === document.body || !!t.closest("#songList");
    const k = e.key;
    if (onSlider && ["ArrowLeft", "ArrowRight", "ArrowUp", "ArrowDown", "Home", "End"].includes(k)) return;
    switch (k) {
      case "ArrowUp":
      case "ArrowDown":
        if (!onListOrPage) return;
        e.preventDefault();
        setSel(state.sel + (k === "ArrowDown" ? 1 : -1));
        break;
      case "Enter":
        if (onButton) return;
        e.preventDefault();
        chooseSong(state.sel);
        break;
      case " ":
        if (onButton) return;
        e.preventDefault();
        togglePlay();
        break;
      case "k":
      case "K": togglePlay(); break;
      case "ArrowLeft":
      case "ArrowRight": {
        e.preventDefault();
        if (e.repeat || keyHold) return;
        const dir = k === "ArrowRight" ? 1 : -1;
        const h = { dir, holding: false, timer: 0 };
        h.timer = setTimeout(() => { if (keyHold === h) { h.holding = true; state.holdDir = dir; } }, HOLD_MS);
        keyHold = h;
        break;
      }
      case "s":
      case "S": setShuffle(!state.shuffle); break;
      case "r":
      case "R": cycleRepeat(); break;
      default: break;
    }
  });
  document.addEventListener("keyup", (e) => {
    if ((e.key !== "ArrowLeft" && e.key !== "ArrowRight") || !keyHold) return;
    const h = keyHold;
    keyHold = null;
    clearTimeout(h.timer);
    if (h.holding) state.holdDir = 0;
    else if (h.dir > 0) goNext();
    else goPrev();
  });

  /* ---------- the moving waveform ---------- */
  const canvas = $("wave");
  const wctx = canvas.getContext("2d");
  const BAR_SEC = 0.1, BAR_W = 3, BAR_GAP = 4;
  let waveColors = null;
  function readWaveColors() {
    const cs = getComputedStyle(root);
    const v = (name) => cs.getPropertyValue(name).trim();
    waveColors = { past: v("--wave-past"), past2: v("--wave-past-2"), future: v("--wave-future"), idleLift: parseFloat(v("--wave-idle-lift")) || 0 };
    waveDirty = true;
  }
  function barAmp(song, t0) {
    const w = song.wave;
    if (t0 < 0 || t0 >= song.duration) return -1;
    const i0 = Math.floor(t0 * w.rate);
    const i1 = Math.max(i0, Math.floor((t0 + BAR_SEC) * w.rate) - 1);
    let m = 0;
    for (let i = i0; i <= i1 && i < w.data.length; i++) m = Math.max(m, w.data[i]);
    return m / 255;
  }
  function bar(x, y, w, h) {
    wctx.beginPath();
    wctx.roundRect(x, y, w, h, w / 2);
    wctx.fill();
  }
  // Bars rise from a baseline with a soft reflection underneath; left of the centre line is what has played.
  // While no music is playing, the bars rise and fall with the band of light passing over the angel's wings behind
  // them: with no song chosen they take the sky's colours, and a paused song's bars swell and settle with it.
  function drawWave(t, ms = now()) {
    const dpr = Math.min(2, window.devicePixelRatio || 1);
    const W = Math.round(canvas.clientWidth * dpr), H = Math.round(canvas.clientHeight * dpr);
    if (!W || !H) return;
    if (canvas.width !== W || canvas.height !== H) { canvas.width = W; canvas.height = H; }
    if (!waveColors) readWaveColors();
    wctx.clearRect(0, 0, W, H);
    const song = cur();
    const cx = W / 2, base = H * 0.6;
    const stepPx = (BAR_W + BAR_GAP) * dpr, bw = BAR_W * dpr;
    const upMax = base - 4 * dpr, gap = 2 * dpr;
    const perSec = stepPx / BAR_SEC;
    const tNow = song ? t : 0;
    const half = Math.ceil(cx / stepPx) + 1;
    const first = Math.floor(tNow / BAR_SEC) - half;
    const past = wctx.createLinearGradient(0, base - upMax, 0, base);
    past.addColorStop(0, waveColors.past);
    past.addColorStop(1, waveColors.past2);
    let sway = null, idleFill = null; // the bars before a song is chosen take the sky's colours (set below)
    if (!state.playing) {
      const r = canvas.getBoundingClientRect(), vw = window.innerWidth || 1, vh = window.innerHeight || 1;
      const v = 1 - (r.top + r.height * 0.6) / vh; // the baseline's height up the screen, as the sky's shader counts it
      sway = (x) => skyLight((r.left + x / dpr) / vw, v, ms);
      if (!song) {
        const pal = currentPalette(ms), k = waveColors.idleLift;
        const lift = (hex, by) => `rgb(${hexRgb(hex).map((c) => Math.round(c + (255 - c) * by)).join(",")})`;
        idleFill = wctx.createLinearGradient(0, base - upMax, 0, base);
        idleFill.addColorStop(0, lift(pal[0], k));
        idleFill.addColorStop(1, lift(pal[1], k * 0.6));
      }
    }
    for (let b = first; b <= first + half * 2 + 1; b++) {
      const bt = b * BAR_SEC;
      const x = cx + (bt - tNow) * perSec;
      if (x < -bw || x > W) continue;
      let amp, style;
      if (song) {
        amp = barAmp(song, bt);
        if (amp < 0) continue;
        if (sway) amp = Math.min(1, amp * (0.45 + 0.75 * sway(x)));
        style = x + bw / 2 <= cx ? past : waveColors.future;
      } else {
        amp = 0.06 + 0.7 * Math.pow(sway(x), 1.3);
        style = idleFill;
      }
      const up = Math.max(2 * dpr, Math.pow(amp, 0.85) * upMax);
      const down = Math.max(1 * dpr, up * 0.42);
      wctx.fillStyle = style;
      wctx.globalAlpha = 1;
      bar(x, base - up, bw, up);
      wctx.globalAlpha = 0.38;
      bar(x, base + gap, bw, down);
    }
    wctx.globalAlpha = 1;
  }
  const darkQuery = window.matchMedia("(prefers-color-scheme: dark)");
  const onThemeChange = () => { readWaveColors(); readSkyColors(); };
  new MutationObserver(onThemeChange).observe(root, { attributes: true, attributeFilter: ["data-theme"] });
  new ResizeObserver(() => { waveDirty = true; }).observe(canvas);

  /* ---------- header links, scene ---------- */
  function renderLinks() {
    const nav = $("links");
    LINKS.forEach((link) => {
      const icon = ICONS[link.icon];
      const a = el("a", `ic-${link.icon}`);
      a.innerHTML = `<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path fill-rule="${icon.rule}" d="${icon.d}"/></svg>` +
        `<span class="sr-only">${link.label}</span>`;
      if (link.href) {
        // a new tab, so the music keeps playing
        a.href = link.href;
        a.target = "_blank";
        a.rel = "noopener";
        a.title = link.label;
      } else {
        a.title = `${link.label} (link coming soon)`;
      }
      nav.append(a);
    });
  }
  /* ---------- background: the angel photo, graded into the song's colours, with falling snow ---------- */
  // The photo in art/ is drawn with WebGL over the plain gradient sky, which shows instead if WebGL or the photo isn't
  // available. Its tones are mapped onto three colours: its dark sky onto the theme's shadow (wine-black at night,
  // cream by day), its middle tones onto the playing song's colour, its bright wings onto the theme's light. It
  // breathes slowly in and out and drifts a little against the pointer; the wing tips stir as if in a breeze; a soft
  // band of light passes across the wings (the idle waveform rises and falls with it); the song's colour gathers
  // around the wings, more on each bass hit; and three layers of snow fall in front, the nearest largest and softest.
  const SKY_PHOTO = "art/angel-wings.jpg";
  const SKY_AXIS = 0.475; // where the angel's spine runs across the photo (0 left, 1 right): the wings stir away from it
  const SNOW_FALL = [1.15, 0.85, 0.55]; // how fast each snow layer falls, far to near, in its own cells a second
  const sky = $("skyCanvas");
  // Each new song fades to another palette from the theme's set. Its main colour tints the photo, the cover's pulse
  // and the skeleton art; the idle waveform takes the first two. At night: reds, pinks, ivory and antique gold. By
  // day (Light mode): the deeper reds and pinks.
  const SKY_PALETTES = {
    night: [
      ["#E58A9A", "#C2213C", "#F2D2B0"], // rose
      ["#D42A45", "#8E1428", "#F4B5BF"], // blood moon
      ["#F3B4C2", "#FFE4D6", "#D77A90"], // blush
      ["#E2B878", "#FFF0D6", "#D98C95"], // gilt
      ["#E8604C", "#F2A27E", "#B3122E"], // ember
      ["#C25A85", "#F0A6C0", "#7E1836"], // wine
    ],
    day: [
      ["#C2213C", "#E0607A", "#8E1428"], // crimson
      ["#D42A45", "#F08CA0", "#A3122A"], // blood and blush
      ["#D45A7A", "#B0243C", "#E88FA6"], // deep rose
      ["#B5306A", "#D96A95", "#7E1836"], // wine pink
      ["#E0607A", "#C2213C", "#F0A6C0"], // pink
      ["#A3122A", "#D98C95", "#C25A85"], // oxblood rose
    ],
  };
  const SKY_FADE = 2600; // milliseconds for one palette to melt into the next
  let skySet = SKY_PALETTES.night;
  let palFrom = skySet[0], palTo = skySet[0], palIndex = 0, palStart = -Infinity, skySong = -1;
  let skyTheme = { shadow: [0.04, 0.02, 0.03], light: [0.85, 0.68, 0.71], midMix: -0.5, glow: 0.6, snow: [1, 0.94, 0.95, 0.8] };
  let lastSky = -Infinity, lastIdleWave = -Infinity, skyPtrX = 0.5, skyPtrY = 0.5;
  const hexUnit = (hex) => hexRgb(hex).map((v) => v / 255);
  const mixTo = (c, target, k) => c.map((v, i) => v + (target[i] - v) * k);
  // Theme settings from the CSS: the photo's grade, how strongly the song's colour gathers around the wings, the
  // snow's colour and strength, and which palette set to use.
  function readSkyColors() {
    const cs = getComputedStyle(root), v = (name) => cs.getPropertyValue(name).trim();
    const num = (name, fallback) => { const n = parseFloat(v(name)); return Number.isFinite(n) ? n : fallback; };
    skyTheme = {
      shadow: hexUnit(v("--sky-shadow") || "#0B0507"),
      light: hexUnit(v("--sky-light") || "#D9AEB6"),
      midMix: num("--sky-mid-mix", 0),
      glow: num("--sky-glow", 0.5),
      snow: [...hexUnit(v("--sky-snow") || "#FFFFFF"), num("--sky-snow-alpha", 0.7)],
    };
    const set = SKY_PALETTES[v("--sky-set")] || SKY_PALETTES.night;
    if (set !== skySet) {
      // a change of theme swaps straight to the same palette in the other set
      skySet = set;
      palFrom = palTo = set[palIndex];
      palStart = -Infinity;
      artStage.style.setProperty("--pulse", palTo[0]);
      skeletons.style.setProperty("--pulse", palTo[0]);
    }
    lastSky = -Infinity;
  }
  // A new song fades the sky to a different palette; a song that repeats keeps its colours.
  function skyForSong(index, ms) {
    if (index === skySong) return;
    skySong = index;
    let next = palIndex;
    while (next === palIndex) next = Math.floor(Math.random() * skySet.length);
    palFrom = currentPalette(ms);
    palTo = skySet[next];
    artStage.style.setProperty("--pulse", palTo[0]); // the cover's pulse takes the new palette's main colour,
    skeletons.style.setProperty("--pulse", palTo[0]); // and so does the skeleton art
    palIndex = next;
    palStart = ms;
  }
  function currentPalette(ms) {
    const p = clamp((ms - palStart) / SKY_FADE, 0, 1);
    if (p >= 1) return palTo;
    const e = p * p * (3 - 2 * p);
    return palTo.map((to, i) => {
      const a = hexRgb(palFrom[i]), b = hexRgb(to);
      return "#" + a.map((v, k) => Math.round(v + (b[k] - v) * e).toString(16).padStart(2, "0")).join("");
    });
  }

  // The shader. Everything that moves is driven by phases the script works out (kept within one turn of a circle),
  // so the motion stays smooth however long the page is left open.
  const SKY_VERT = "attribute vec2 aPos; varying vec2 vUv; void main() { vUv = aPos * 0.5 + 0.5; gl_Position = vec4(aPos, 0.0, 1.0); }";
  const SKY_FRAG = `
    #ifdef GL_FRAGMENT_PRECISION_HIGH
    precision highp float;
    #else
    precision mediump float;
    #endif
    varying vec2 vUv;
    uniform sampler2D uImg;
    uniform vec2 uView, uImgSize, uPtr;
    uniform float uZoom, uFill, uFade, uAxis, uBass, uGlow;
    uniform vec4 uPh, uBreeze, uSnow;
    uniform vec3 uFall, uShadow, uMid, uLight, uTint;
    float luma(vec3 c) { return dot(c, vec3(0.299, 0.587, 0.114)); }
    float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }
    // One layer of snow. The screen is cut into square cells (cells to the screen's height) and a share of them
    // (keep) hold a soft flake somewhere inside; the layer slides down by fall cells, swaying sideways as it goes. The
    // pattern repeats every 32 cells upwards and the sway every 8, so the fall can wrap round without a jump.
    float snow(vec2 p, float cells, float fall, float size, float sway, float keep) {
      vec2 q = p * cells;
      q.y += fall;
      q.x += sin(q.y * 0.7853982 + uPh.w) * sway;
      vec2 cell = floor(q);
      cell.y = mod(cell.y, 32.0);
      float h = hash(cell);
      if (h > keep) return 0.0;
      vec2 at = vec2(hash(cell + 17.0), hash(cell + 41.0)) - 0.5;
      float d = length(fract(q) - 0.5 - at * 0.6);
      return smoothstep(size, size * 0.2, d) * (0.45 + 0.55 * hash(cell + 5.0));
    }
    void main() {
      // the photo covers the screen (on tall screens it keeps more of its width and stops short of the top and bottom,
      // see below), breathing slowly in and out and drifting a little against the pointer
      vec2 drift = (uPtr - 0.5) * vec2(0.03, -0.03);
      float s = max(uView.x / uImgSize.x, uView.y / uImgSize.y * uFill) * uZoom;
      vec2 uv = (vUv + drift - 0.5) * uView / (uImgSize * s) + 0.5;
      // where the wings are: a soft map of the bright parts nearby
      float near = 0.0;
      for (int k = 0; k < 8; k++) {
        float a = float(k) * 0.7853982;
        near += smoothstep(0.5, 0.95, luma(texture2D(uImg, uv + vec2(cos(a), sin(a) * uImgSize.x / uImgSize.y) * 0.02).rgb));
      }
      near /= 8.0;
      // the wing tips stir as if in a breeze, more on the bass; the body along the spine stays still
      vec2 breeze = vec2(
        sin(uv.y * 23.0 + uBreeze.x) + 0.6 * sin((uv.x + uv.y) * 31.0 - uBreeze.y),
        sin(uv.x * 19.0 - uBreeze.z) + 0.6 * sin((uv.x - uv.y) * 27.0 + uBreeze.w)) * 0.3;
      float tips = smoothstep(0.07, 0.2, abs(uv.x - uAxis));
      float l = luma(texture2D(uImg, uv + breeze * near * tips * (0.006 + uBass * 0.008)).rgb);
      // the tone curve: the photo's grey night sinks towards the shadow, and the wings keep their feathering
      float lt = clamp((l - 0.22) / 0.78, 0.0, 1.0);
      float bright = smoothstep(0.35, 0.8, lt);
      // a soft band of light passing across, strongest on the wings, which glow a little past the theme's light where
      // it's brightest (the same sums as skyLight in the script)
      float sweep = 0.5 + 0.5 * sin(vUv.x * 6.0 - uPh.x + sin(vUv.y * 3.0 + uPh.y) * 1.5);
      float ripple = 0.5 + 0.5 * sin(vUv.x * 17.0 - uPh.z + vUv.y * 4.0);
      float light = 0.65 * sweep + 0.35 * ripple;
      lt *= 0.92 + 0.08 * light + 0.16 * light * bright;
      // the grade: the dark sky to the theme's shadow, the middle tones to the song's colour, the brightest to the light
      vec3 col = lt < 0.5 ? mix(uShadow, uMid, lt * 2.0) : mix(uMid, uLight, lt * 2.0 - 1.0);
      // the song's colour gathers softly just outside the wings, more on the bass
      float halo = near * near * (1.0 - bright);
      col = mix(col, uTint, clamp(halo * uGlow * (0.5 + uBass), 0.0, 0.8));
      // where the photo stops short of the top and bottom (tall screens), it fades into the shadow
      if (uFade > 0.0) col = mix(uShadow, col, smoothstep(0.0, uFade, uv.y) * smoothstep(1.0, 1.0 - uFade, uv.y));
      // falling snow: far, middle and near layers, the nearer ones larger, softer and moving more with the pointer
      vec2 p = vec2((vUv.x - 0.5) * uView.x / uView.y, vUv.y);
      vec2 lean = (uPtr - 0.5) * vec2(1.0, -1.0);
      float flakes = snow(p + lean * 0.012, 26.0, uFall.x, 0.13, 0.25, 0.3) * 0.45
        + snow(p + lean * 0.03, 14.0, uFall.y, 0.12, 0.3, 0.32) * 0.7
        + snow(p + lean * 0.06, 7.0, uFall.z, 0.085, 0.35, 0.22);
      col = mix(col, uSnow.rgb, clamp(flakes * uSnow.a, 0.0, 1.0));
      // a soft vignette
      float vig = smoothstep(1.4, 0.35, length((vUv - 0.5) * vec2(uView.x / uView.y, 1.0)));
      gl_FragColor = vec4(mix(uShadow, col, vig), 1.0);
    }`;
  const SKY_UNIFORMS = ["uImg", "uView", "uImgSize", "uPtr", "uZoom", "uFill", "uFade", "uAxis", "uBass", "uGlow", "uPh", "uBreeze", "uSnow", "uFall", "uShadow", "uMid", "uLight", "uTint"];
  let gl = null, photo = null;
  const skyU = {};
  function initSky() {
    photo = null;
    try {
      gl = sky.getContext("webgl", { alpha: false, antialias: false, depth: false, stencil: false, powerPreference: "low-power" });
    } catch {
      gl = null;
    }
    if (!gl) return;
    try {
      const compile = (type, src) => {
        const sh = gl.createShader(type);
        gl.shaderSource(sh, src);
        gl.compileShader(sh);
        if (!gl.getShaderParameter(sh, gl.COMPILE_STATUS)) throw new Error(gl.getShaderInfoLog(sh));
        return sh;
      };
      const prog = gl.createProgram();
      gl.attachShader(prog, compile(gl.VERTEX_SHADER, SKY_VERT));
      gl.attachShader(prog, compile(gl.FRAGMENT_SHADER, SKY_FRAG));
      gl.linkProgram(prog);
      if (!gl.getProgramParameter(prog, gl.LINK_STATUS)) throw new Error(gl.getProgramInfoLog(prog));
      gl.useProgram(prog);
      gl.bindBuffer(gl.ARRAY_BUFFER, gl.createBuffer());
      gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1, -1, 1, -1, -1, 1, 1, 1]), gl.STATIC_DRAW);
      const loc = gl.getAttribLocation(prog, "aPos");
      gl.enableVertexAttribArray(loc);
      gl.vertexAttribPointer(loc, 2, gl.FLOAT, false, 0, 0);
      for (const n of SKY_UNIFORMS) skyU[n] = gl.getUniformLocation(prog, n);
    } catch (err) {
      console.warn("The sky's shader didn't start, so the plain sky shows instead:", err);
      gl = null;
      return;
    }
    const im = new Image();
    im.onload = () => {
      if (!gl) return;
      try {
        gl.bindTexture(gl.TEXTURE_2D, gl.createTexture());
        gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, true);
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGB, gl.RGB, gl.UNSIGNED_BYTE, im);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
        gl.uniform1i(skyU.uImg, 0);
        photo = { w: im.naturalWidth, h: im.naturalHeight };
        drawSky(now()); // the first frame is drawn before the canvas fades in
        sky.classList.add("ready");
      } catch (err) {
        photo = null;
        console.warn("The sky photo couldn't be used, so the plain sky shows instead:", err);
      }
    };
    im.onerror = () => console.warn("The sky photo didn't load, so the plain sky shows instead:", SKY_PHOTO);
    im.src = SKY_PHOTO;
  }
  // If the graphics card resets, the plain sky shows until the photo is set up again.
  sky.addEventListener("webglcontextlost", (e) => { e.preventDefault(); photo = null; sky.classList.remove("ready"); });
  sky.addEventListener("webglcontextrestored", () => initSky());
  // Drawn at up to 60% of the screen's size (never more than 1100 pixels across or down) and stretched: the photo is
  // soft anyway, and it keeps the work light on big screens.
  function sizeSky() {
    const scale = Math.min(0.6, 1100 / Math.max(1, innerWidth), 1100 / Math.max(1, innerHeight));
    const w = Math.max(64, Math.round(innerWidth * scale)), h = Math.max(64, Math.round(innerHeight * scale));
    if (sky.width !== w || sky.height !== h) {
      sky.width = w;
      sky.height = h;
      lastSky = -Infinity;
    }
  }
  const TAU = Math.PI * 2;
  const turn = (t, rate) => (t * rate) % TAU;
  function drawSky(ms) {
    if (!gl || !photo) return;
    const t = ms / 1000, tint = hexUnit(currentPalette(ms)[0]), m = skyTheme.midMix;
    const mid = m < 0 ? mixTo(tint, [0, 0, 0], -m) : mixTo(tint, [1, 1, 1], m);
    gl.viewport(0, 0, sky.width, sky.height);
    gl.uniform2f(skyU.uView, sky.width, sky.height);
    gl.uniform2f(skyU.uImgSize, photo.w, photo.h);
    gl.uniform2f(skyU.uPtr, skyPtrX, skyPtrY);
    gl.uniform1f(skyU.uZoom, 1.08 + 0.03 * Math.sin(t * 0.16));
    // On screens taller than about 6:5 wide, covering the screen would zoom in on the angel's back alone, so the photo
    // is allowed to fall short of the top and bottom (down to 55% of the height), keeping more of the wings in view.
    const fill = clamp(sky.width / sky.height / 1.2, 0.55, 1);
    gl.uniform1f(skyU.uFill, fill);
    gl.uniform1f(skyU.uFade, fill < 1 ? 0.06 + 0.18 * (1 - fill) : 0);
    gl.uniform1f(skyU.uAxis, SKY_AXIS);
    gl.uniform1f(skyU.uBass, bassLevel);
    gl.uniform1f(skyU.uGlow, skyTheme.glow);
    gl.uniform4f(skyU.uPh, turn(t, 0.5), turn(t, 0.2), turn(t, 1.1), turn(t, 0.7));
    gl.uniform4f(skyU.uBreeze, turn(t, 0.9), turn(t, 1.3), turn(t, 0.8), turn(t, 1.1));
    gl.uniform3f(skyU.uFall, (t * SNOW_FALL[0]) % 32, (t * SNOW_FALL[1]) % 32, (t * SNOW_FALL[2]) % 32);
    gl.uniform3fv(skyU.uShadow, skyTheme.shadow);
    gl.uniform3fv(skyU.uMid, mid);
    gl.uniform3fv(skyU.uLight, skyTheme.light);
    gl.uniform3fv(skyU.uTint, tint);
    gl.uniform4fv(skyU.uSnow, skyTheme.snow);
    gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
  }
  // How bright the passing band of light is at a point on the screen (u across from the left, v up from the bottom;
  // 0 to 1), from the same sums as the shader, so the idle waveform can rise and fall in time with it.
  function skyLight(u, v, ms) {
    const t = ms / 1000;
    const sweep = 0.5 + 0.5 * Math.sin(u * 6 - t * 0.5 + Math.sin(v * 3 + t * 0.2) * 1.5);
    const ripple = 0.5 + 0.5 * Math.sin(u * 17 - t * 1.1 + v * 4);
    return 0.65 * sweep + 0.35 * ripple;
  }
  // Called from the frame loop. The sky is redrawn up to about 60 times a second, following the pointer with a little
  // lag; while no music is playing, the waveform is redrawn about 30 times a second alongside it.
  function tickSky(ms, dt) {
    const k = 1 - Math.exp(-dt / 0.6);
    skyPtrX += (ptrX - skyPtrX) * k;
    skyPtrY += (ptrY - skyPtrY) * k;
    if (ms - lastSky >= 15) {
      lastSky = ms;
      drawSky(ms);
    }
    if (!state.playing && ms - lastIdleWave >= 33) {
      lastIdleWave = ms;
      drawWave(pos(), ms);
    }
  }
  // The plain sky's twinkling stars (they stand down once the photo shows) and the odd shooting star.
  function makeStars() {
    const box = $("stars");
    const count = Math.round(clamp((window.innerWidth * window.innerHeight) / 15000, 36, 110));
    for (let i = 0; i < count; i++) {
      const s = el("i", "star");
      const glint = Math.random() < 0.12;
      if (glint) s.classList.add("glint");
      const size = glint ? 2 + Math.random() * 1.4 : 0.8 + Math.random() * 1.4;
      s.style.left = `${(Math.random() * 100).toFixed(2)}%`;
      s.style.top = `${(Math.pow(Math.random(), 1.6) * 100).toFixed(2)}%`; // thicker towards the top of the sky
      s.style.setProperty("--s", `${size.toFixed(1)}px`);
      s.style.setProperty("--lo", (0.12 + Math.random() * 0.22).toFixed(2));
      s.style.setProperty("--hi", (0.55 + Math.random() * 0.45).toFixed(2));
      s.style.setProperty("--d", `${(2.8 + Math.random() * 5).toFixed(1)}s`);
      s.style.setProperty("--delay", `${(-Math.random() * 8).toFixed(1)}s`);
      box.append(s);
    }
  }
  // Every 9 to 23 seconds a star streaks down and to the left (not while the tab is hidden).
  function scheduleShootingStar() {
    setTimeout(() => {
      if (!document.hidden) {
        const s = el("i", "shoot");
        const dx = -(220 + Math.random() * 200), dy = 90 + Math.random() * 110;
        s.style.left = `${(35 + Math.random() * 55).toFixed(1)}%`;
        s.style.top = `${(4 + Math.random() * 32).toFixed(1)}%`;
        s.style.setProperty("--dx", `${dx.toFixed(0)}px`);
        s.style.setProperty("--dy", `${dy.toFixed(0)}px`);
        s.style.setProperty("--ang", `${((Math.atan2(dy, dx) * 180) / Math.PI).toFixed(1)}deg`);
        s.addEventListener("animationend", () => s.remove());
        $("stars").append(s);
      }
      scheduleShootingStar();
    }, 9000 + Math.random() * 14000);
  }
  window.addEventListener("resize", sizeSky);

  /* ---------- light mode ---------- */
  // The page follows the device's light or dark setting until the visitor flips Light mode in the footer; their
  // choice is then remembered on their device. Changing data-theme also re-reads the waveform and sky colours.
  const lightSwitch = $("lightSwitch");
  const isLight = () => (state.theme ? state.theme === "light" : !darkQuery.matches);
  function applyTheme() {
    if (state.theme) root.dataset.theme = state.theme;
    else delete root.dataset.theme;
    lightSwitch.setAttribute("aria-checked", String(isLight()));
  }
  lightSwitch.addEventListener("click", () => {
    state.theme = isLight() ? "dark" : "light";
    save();
    applyTheme();
  });
  // when the device switches between light and dark, the switch and the colours follow (unless a theme was chosen)
  darkQuery.addEventListener("change", () => { applyTheme(); onThemeChange(); });

  /* ---------- frame loop ---------- */
  let lastFrame = now(), holdFor = 0;
  function frame() {
    const t = now();
    const dt = Math.min(0.1, (t - lastFrame) / 1000);
    lastFrame = t;
    // holding ← or → rewinds or fast-forwards in small jumps, so the file isn't asked to seek on every frame
    holdFor = state.holdDir && cur() ? holdFor + dt : 0;
    if (holdFor >= 0.15) { setPos(pos() + state.holdDir * 6 * holdFor); holdFor = 0; }
    const p = pos();
    if (state.playing || waveDirty) { drawWave(p, t); waveDirty = false; }
    updateSeek(p);
    tickPulse(dt, p);
    tickWheel(dt);
    tickSkeleton(dt, t);
    tickSky(t, dt);
    requestAnimationFrame(frame);
  }

  /* ---------- start ---------- */
  // songs without an artist of their own get Heaven or Saigned, dealt so that both names appear
  const unnamed = SONGS.filter((song) => !song.artist);
  shuffled(unnamed.map((_, i) => ARTISTS[i % ARTISTS.length])).forEach((name, i) => { unnamed[i].artist = name; });
  const deck = shuffled(COVERS);
  SONGS.forEach((song, i) => {
    song.cover = deck[i % deck.length];
    song.tint = P.rose;
    song.wave = decodeWave(song);
    song.beats = findBeats(song.wave);
    coverTint(song.cover).then((tint) => {
      song.tint = tint;
      if (cur() === song) root.style.setProperty("--tint", tint);
    });
  });
  BLANK_COVER = makeBlankCover();
  // the last song comes back paused where the listener left it; it never starts playing by itself
  const last = SONGS.findIndex((song) => song.file === saved.song);
  if (last >= 0) {
    state.queue = queueFrom(last, state.shuffle);
    state.qi = state.queue.indexOf(last);
    state.sel = last;
    const at = Number(saved.at) || 0;
    state.basePos = at < SONGS[last].duration - 5 ? at : 0;
    skyForSong(last, now());
    setSessionSong(SONGS[last]);
  }
  applyTheme();
  readWaveColors();
  readSkyColors();
  sizeSky();
  initSky();
  renderLinks();
  renderList();
  renderAll();
  makeStars();
  scheduleShootingStar();
  // trace the dealt covers' skeleton art one at a time while the page is idle, so it's ready before a song plays
  const whenIdle = window.requestIdleCallback || ((fn) => setTimeout(fn, 400));
  SONGS.reduce((p, song) => p.then(() => new Promise((done) => whenIdle(() => makeSkeleton(song.cover).then(done)))), Promise.resolve());
  requestAnimationFrame(frame);
})();
</script>
