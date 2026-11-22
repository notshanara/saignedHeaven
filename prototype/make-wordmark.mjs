// Makes the signedHeaven wordmark from the Amelie font: the lettering outlined into SVG paths, so the site shows the
// font's shapes without ever serving the font file (its license doesn't allow that). Writes two versions:
//   wordmark.svg        a signature: Amelie's lead-in swash on the s (s.alt1) and its trailing tail on the n (n.alt2)
//   wordmark-plain.svg  the same lettering without them, for narrow screens
// Both are filled with currentColor, so they take the colour of the text around them.
// Needs the opentype.js library once, from this project's folder: npm install --no-save opentype.js@1.3.4
// Usage: node prototype/make-wordmark.mjs <path to Amelie.otf> [output folder, default site_art/]
import opentype from 'opentype.js';
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const [fontFile, outArg] = process.argv.slice(2);
if (!fontFile) throw new Error('usage: node prototype/make-wordmark.mjs <path to Amelie.otf> [output folder]');
const out = outArg || join(dirname(fileURLToPath(import.meta.url)), '..', 'site_art');

const buf = readFileSync(fontFile);
const font = opentype.parse(buf.buffer.slice(buf.byteOffset, buf.byteOffset + buf.length));
const byName = new Map();
for (let i = 0; i < font.numGlyphs; i++) {
  const g = font.glyphs.get(i);
  if (g.name) byName.set(g.name, g);
}

// Lays out glyphs (by name, or a single character for its usual glyph) with the font's kerning, 100 units tall.
function lettering(names) {
  const size = 100, scale = size / font.unitsPerEm, path = new opentype.Path();
  let x = 0, prev = null;
  for (const n of names) {
    const g = n.length === 1 ? font.charToGlyph(n) : byName.get(n);
    if (!g || g.index === 0) throw new Error(`the font has no glyph "${n}"`);
    if (prev) x += font.getKerningValue(prev, g) * scale;
    path.extend(g.getPath(x, 0, size));
    x += g.advanceWidth * scale;
    prev = g;
  }
  const bb = path.getBoundingBox(), pad = 2;
  const box = [bb.x1 - pad, bb.y1 - pad, bb.x2 - bb.x1 + 2 * pad, bb.y2 - bb.y1 + 2 * pad].map((v) => +v.toFixed(1));
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="${box.join(' ')}" fill="currentColor"><path d="${path.toPathData(1)}"/></svg>\n`;
}

const word = [...'signedHeaven'];
const versions = {
  'wordmark.svg': ['s.alt1', ...word.slice(1, -1), 'n.alt2'],
  'wordmark-plain.svg': word,
};
mkdirSync(out, { recursive: true });
for (const [file, names] of Object.entries(versions)) {
  const svg = lettering(names);
  writeFileSync(join(out, file), svg);
  console.log(`wrote ${join(out, file)} (${(svg.length / 1024).toFixed(1)} KB)`);
}
