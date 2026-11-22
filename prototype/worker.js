// Serves the songs with range requests ("give me bytes 141000 onwards"). Cloudflare's static files ignore them, and
// without them a browser can't seek in a song, and Safari won't play it at all. wrangler.jsonc sends only /songs/*
// requests here; the page, covers and art are served straight from the static files.
export default {
  async fetch(request, env) {
    // the whole file from the static files, which don't say how long it is, so it's read to find out
    const file = await env.ASSETS.fetch(request.url);
    if (!file.ok) return file;
    const bytes = new Uint8Array(await file.arrayBuffer()), size = bytes.byteLength;
    const headers = new Headers(file.headers);
    headers.set("Accept-Ranges", "bytes");
    const body = (part) => (request.method === "HEAD" ? null : part);
    // "bytes=start-end", "bytes=start-" or "bytes=-suffix"; anything else gets the whole file
    const m = /^bytes=(\d*)-(\d*)$/.exec(request.headers.get("Range") || "");
    if (!m || (!m[1] && !m[2])) return new Response(body(bytes), { status: 200, headers });
    const start = m[1] ? Number(m[1]) : Math.max(0, size - Number(m[2]));
    const end = m[1] && m[2] ? Math.min(Number(m[2]), size - 1) : size - 1;
    if (start >= size || start > end) {
      return new Response(null, { status: 416, headers: { "Content-Range": `bytes */${size}`, "Accept-Ranges": "bytes" } });
    }
    headers.set("Content-Range", `bytes ${start}-${end}/${size}`);
    return new Response(body(bytes.subarray(start, end + 1)), { status: 206, headers });
  },
};
