// Builds the prototype from player.tpl and writes dist/, which is complete on its own and is what gets published:
//   index.html  the page, with what the build fills in: each song's title, credit, length, file and measured
//               loudness and bass (from peaks.json), the list of covers, the wordmark, and the night colours
//   songs/      the MP3s in ../sai_songs, under ids made from their titles
//   covers/     the images in ../song_covers, under web-safe names
//   art/        the images in ../site_art (the background photo)
// It also checks that the page's main tags pair up and its script parses, and warns about songs that are missing
// a file, a measurement or a place in the page's song list.
// Usage, from anywhere: node prototype/build.mjs
import { readFileSync, writeFileSync, mkdirSync, readdirSync, copyFileSync, existsSync, rmSync } from 'node:fs';
import { dirname, join, extname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { Script } from 'node:vm';

const here = dirname(fileURLToPath(import.meta.url));
const dist = join(here, 'dist');
const IMAGE = /\.(jpe?g|png|webp)$/i;

// accents and look-alike letters made plain (ₛᵢ becomes si), for file names
const plain = (s) => s.normalize('NFKD').replace(/[̀-ͯ]/g, '');
// name + ext, or name-2 + ext, name-3 + ext and so on if it's taken
function unique(name, taken, ext = '') {
  let out = name + ext;
  for (let n = 2; taken.has(out); n++) out = `${name}-${n}${ext}`;
  taken.add(out);
  return out;
}
// A song file name's title and producer's credit: `Interest (prod kuga)` is "Interest", credited "prod kuga".
function splitCredit(name) {
  const [, title, credit = ''] = /^(.*?)(?:\s*\((prod\b[^)]*)\))?\s*$/i.exec(name);
  return { title, credit };
}
// An image's web-safe name: anything that isn't a letter, digit, dot, dash or underscore becomes a dash, all in
// lower case. Names that are already safe, like sai_img1.jpg, stay as they are.
function safeName(file, taken) {
  const ext = extname(file).toLowerCase();
  const base = plain(file.slice(0, file.length - ext.length)).replace(/[^A-Za-z0-9._-]+/g, '-').replace(/^[-.]+|[-.]+$/g, '').toLowerCase();
  return unique(base || 'image', taken, ext);
}
// A song's file name, from its id: its title the way the README makes ids (4.1), in lower case, apostrophes
// dropped, and anything else that isn't a letter or digit turned into a dash. `Who's that out there! (prod.wixxy).mp3`
// becomes whos-that-out-there.mp3.
function songName(file, taken) {
  const { title } = splitCredit(file.replace(/\.mp3$/i, ''));
  const id = plain(title).toLowerCase().replace(/['’]/g, '').replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '');
  return unique(id || 'song', taken, '.mp3');
}

// Copies a folder's files of one kind beside the page under new names, replacing whatever was there, and returns
// each file's new name, keyed by its old name without the extension.
function copyFiles(from, to, kind, rename) {
  const src = join(here, '..', from), dest = join(dist, to), names = {}, taken = new Set();
  rmSync(dest, { recursive: true, force: true });
  if (!existsSync(src)) {
    console.warn(`no ${from}/ folder: skipped`);
    return names;
  }
  mkdirSync(dest, { recursive: true });
  for (const f of readdirSync(src).filter((n) => kind.test(n)).sort()) {
    const name = rename(f, taken);
    copyFileSync(join(src, f), join(dest, name));
    names[f.slice(0, f.length - extname(f).length)] = name;
  }
  console.log(`copied ${Object.keys(names).length} file(s) from ${from}/ to dist/${to}/`);
  return names;
}

mkdirSync(dist, { recursive: true });
const songFiles = copyFiles('sai_songs', 'songs', /\.mp3$/i, songName);
const covers = Object.values(copyFiles('song_covers', 'covers', IMAGE, safeName));
copyFiles('site_art', 'art', IMAGE, safeName);

let html = readFileSync(join(here, 'player.tpl'), 'utf8');

// Each song in the page's list (SONGS in player.tpl, by file name without .mp3) gets its title and credit, its file,
// its length, and its loudness and bass, one byte per 50 ms reading (peaks.json, measured from the MP3s).
const peaks = JSON.parse(readFileSync(join(here, 'peaks.json'), 'utf8'));
const listed = [...html.matchAll(/\{\s*file:\s*"((?:[^"\\]|\\.)*)"/g)].map((m) => JSON.parse(`"${m[1]}"`));
const songData = {};
for (const f of listed) {
  const mp3 = songFiles[f], w = peaks[f];
  if (!mp3) console.warn(`warning: "${f}" is in the page's song list but not in sai_songs/, so it will show "Couldn't play"`);
  if (!w) console.warn(`warning: "${f}" has no measurement in peaks.json, so its bars lie flat and the cover doesn't pulse`);
  songData[f] = { ...splitCredit(f), src: mp3 ? `songs/${mp3}` : '', duration: w ? w.duration : 0, ...(w && { rate: w.rate, peaks: w.peaks, bass: w.bass }) };
}
for (const f of Object.keys(songFiles)) {
  if (!listed.includes(f)) console.warn(`warning: "${f}.mp3" is in sai_songs/ but not in the page's song list (SONGS in player.tpl), so it doesn't show`);
}

// The wordmark: Amelie's lettering as outlines (site_art/wordmark.svg and wordmark-plain.svg, made by
// make-wordmark.mjs), put straight into the header. Without both files, the name is set in type instead.
const marks = [['wordmark.svg', 'wordmark-full'], ['wordmark-plain.svg', 'wordmark-plain']].map(([f, cls]) => [join(here, '..', 'site_art', f), cls]);
const wordmark = marks.every(([p]) => existsSync(p))
  ? marks.map(([p, cls]) => readFileSync(p, 'utf8').trim().replace('<svg ', `<svg class="wordmark-art ${cls}" aria-hidden="true" focusable="false" `)).join('')
  : '<span class="wordmark-text" aria-hidden="true">signedHeaven</span>';

// The night colours are written once, in the :root[data-theme="dark"] block; the dark-device block gets a copy.
const night = /\n:root\[data-theme="dark"\] \{\n([\s\S]*?)\n\}\n/.exec(html);
if (!night) throw new Error('player.tpl has no :root[data-theme="dark"] block to copy the night colours from');

// data put into the script is kept from closing it early
const json = (v) => JSON.stringify(v).replace(/</g, '\\u003c');
for (const [marker, value] of [
  ['/*SONGDATA*/{}', json(songData)],
  ['/*COVERS*/[]', json(covers.map((n) => `covers/${n}`))],
  ['<!--WORDMARK-->', wordmark],
  ['    /*NIGHT*/', night[1].replace(/^/gm, '  ')],
]) {
  const count = html.split(marker).length - 1;
  if (count !== 1) throw new Error(`the placeholder ${marker.trim()} appears ${count} times in player.tpl (expected once)`);
  html = html.replace(marker, () => value);
}

// The page's script must parse. It is only compiled here, never run.
new Script(html.slice(html.indexOf('<script>') + 8, html.lastIndexOf('</script>')), { filename: 'player.tpl <script>' });

// A rough check that the main tags open and close in pairs.
const names = ['div', 'section', 'span', 'button', 'svg', 'p', 'main', 'header', 'footer', 'nav', 'h1', 'style', 'script'];
const opened = (n) => html.split(`<${n} `).length + html.split(`<${n}>`).length - 2;
const closed = (n) => html.split(`</${n}>`).length - 1;
const off = names.filter((n) => opened(n) !== closed(n)).map((n) => `${n} ${opened(n)}/${closed(n)}`);
if (off.length) throw new Error(`tags that don't pair up (opened/closed): ${off.join(', ')}`);

writeFileSync(join(dist, 'index.html'), html);
console.log(`built prototype/dist/index.html (${(Buffer.byteLength(html) / 1024).toFixed(1)} KB)`);
console.log(`songs: ${listed.map((f) => songData[f].src || `${f} (no file)`).join(' | ')}`);
console.log(`covers: ${covers.join(' | ')}`);
console.log(`wordmark: ${wordmark.startsWith('<svg') ? 'Amelie outlines' : 'set in type (no wordmark SVGs in site_art/)'}`);
