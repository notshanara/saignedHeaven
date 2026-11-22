// Local preview of the prototype. Serves dist/index.html inside the same kind of page skeleton the artifact host
// adds around a published page, and the files the build copied beside it: the songs (dist/songs/), covers
// (dist/covers/) and art (dist/art/). Songs are served with range requests, as a proper audio host does, so the
// player can stream and seek.
// Usage, from anywhere: node prototype/serve.mjs [port]   then open http://localhost:5179 (or your port)
// Rebuild with node prototype/build.mjs and refresh the browser to see changes.
import { createServer } from 'node:http';
import { existsSync, readFileSync, readdirSync, statSync, createReadStream } from 'node:fs';
import { dirname, join, extname } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const dist = join(here, 'dist');
const page = join(dist, 'index.html');
const port = Number(process.argv[2] || 5179);
// the only folders served, and only files of these kinds actually in them
const FOLDERS = { songs: /\.mp3$/i, covers: /\.(jpe?g|png|webp)$/i, art: /\.(jpe?g|png|webp)$/i };
const TYPES = { '.mp3': 'audio/mpeg', '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg', '.png': 'image/png', '.webp': 'image/webp' };

const wrap = (body) => `<!doctype html><html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<style>:root{color-scheme:light;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}body{margin:0;font:14px system-ui,sans-serif}img{max-width:100%}[hidden]{display:none!important}</style>
</head><body>${body}</body></html>`;

createServer((req, res) => {
  const url = new URL(req.url, 'http://localhost');
  const head = req.method === 'HEAD';
  if (req.method !== 'GET' && !head) {
    res.writeHead(405);
    res.end();
    return;
  }

  if (url.pathname === '/') {
    if (!existsSync(page)) {
      res.writeHead(500, { 'content-type': 'text/plain; charset=utf-8' });
      res.end('No built page yet. Run: node prototype/build.mjs');
      return;
    }
    res.writeHead(200, { 'content-type': 'text/html; charset=utf-8', 'cache-control': 'no-store' });
    res.end(head ? undefined : wrap(readFileSync(page, 'utf8')));
    return;
  }

  const [, folder, ...rest] = url.pathname.split('/');
  if (Object.hasOwn(FOLDERS, folder) && rest.length === 1) {
    const name = decodeURIComponent(rest[0]);
    const dir = join(dist, folder);
    const allowed = existsSync(dir) ? readdirSync(dir).filter((f) => FOLDERS[folder].test(f)) : [];
    if (allowed.includes(name)) {
      const path = join(dir, name), size = statSync(path).size;
      const headers = { 'content-type': TYPES[extname(name).toLowerCase()], 'accept-ranges': 'bytes', 'cache-control': 'no-store' };
      // a range request ("bytes=start-end", "bytes=start-" or "bytes=-suffix") gets just those bytes
      const m = /^bytes=(\d*)-(\d*)$/.exec(req.headers.range || '');
      if (m && (m[1] || m[2])) {
        const start = m[1] ? Number(m[1]) : Math.max(0, size - Number(m[2]));
        const end = m[1] && m[2] ? Math.min(Number(m[2]), size - 1) : size - 1;
        if (start >= size || start > end) {
          res.writeHead(416, { 'content-range': `bytes */${size}` });
          res.end();
          return;
        }
        res.writeHead(206, { ...headers, 'content-length': end - start + 1, 'content-range': `bytes ${start}-${end}/${size}` });
        if (head) res.end();
        else createReadStream(path, { start, end }).pipe(res);
        return;
      }
      res.writeHead(200, { ...headers, 'content-length': size });
      if (head) res.end();
      else createReadStream(path).pipe(res);
      return;
    }
  }

  res.writeHead(404);
  res.end();
}).listen(port, '127.0.0.1', () => console.log(`prototype preview on http://localhost:${port}`));
