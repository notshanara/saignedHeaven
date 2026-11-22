# signedHeaven

signedHeaven is a web music player. Songs and cover art come from files on your own computer, and the site streams them at their original quality, up to 320 kbps. Its only job is playing music.

> **Status:** design prototyped, with real playback (November 2026). This README is the development plan, and `prototype/` holds a working version of the design that plays the actual songs (see [the prototype](#the-prototype)). As the code lands, the README becomes the setup and usage guide.

**In short:** a static web app (TypeScript + Vite) with a player built on a plain `<audio>` element. The playing song's cover, with a glow that pulses to the bass, sits above an endless wheel of songs. Beside it, a waveform scrolls past as the song plays. Nothing sits in a panel: it's all laid straight on the background, an animated photo of an angel in falling snow, recoloured with the song covers' colours: cream, blush, rose, blood red and oxblood. You add a song by dropping its MP3 into `sai_songs/` and running one command. That command checks quality (up to 320 kbps, never re-encoded), measures the song's loudness and bass for the waveform and the pulse behind the cover, prepares the covers from `song_covers/` and writes the song list. The site is hosted on Cloudflare Pages and the audio on Cloudflare R2.

## Contents

1. [Goals and scope](#1-goals-and-scope)
2. [How it works](#2-how-it-works)
3. [Key decisions](#3-key-decisions)
4. [Adding music: the content pipeline](#4-adding-music-the-content-pipeline)
5. [The player engine](#5-the-player-engine)
6. [The interface](#6-the-interface)
7. [Accessibility and performance](#7-accessibility-and-performance)
8. [Browser support and platform quirks](#8-browser-support-and-platform-quirks)
9. [Tech stack and project layout](#9-tech-stack-and-project-layout)
10. [Testing](#10-testing)
11. [Hosting and deployment](#11-hosting-and-deployment)
12. [Security, rights and privacy](#12-security-rights-and-privacy)
13. [Roadmap](#13-roadmap)
14. [Parked ideas](#14-parked-ideas)
15. [Appendix](#appendix)

---

## 1. Goals and scope

**Goals**

- Play your songs in the browser on a page that feels the way the covers look: pale, dreamy and a little gothic, with an angel in the snow behind everything, yet approachable and fast on phones and desktops.
- Audio and covers come from your own files, not from Spotify, SoundCloud or YouTube.
- Serve audio at its original quality, up to 320 kbps. Nothing is re-encoded or downsampled on the way to the listener.
- Adding a song takes about a minute: copy two files, run one command, deploy.
- Behave like a real music app: lock-screen and headphone controls, keyboard shortcuts, and it remembers where you left off.

**Not in v1:** accounts, playlists, likes or comments, search, lyrics, downloads, an equaliser or a live visualiser (the waveform is drawn from loudness measured ahead of time), offline mode, analytics, an upload page. Some of these are listed under [Parked ideas](#14-parked-ideas).

**Assumptions**

- You're the only person who adds music. Visitors only listen.
- The library is small to medium: tens to a few hundred songs.
- The site is public. For a private site, see [section 12](#12-security-rights-and-privacy).

> **What "320 kbps" means.** It's the bitrate: how much data per second the compressed audio uses. 320 kbps is the highest standard MP3 bitrate, about 2.4 MB per minute. Browsers can play any bitrate, so the player itself isn't the issue. The work is making sure nothing in the pipeline lowers quality, and choosing hosting that delivers around 10 MB per song cheaply, with instant seeking.

## 2. How it works

```
 sai_songs/ + song_covers/   your MP3s and cover images, on your computer
     │
     │  npm run catalog      checks quality, reads durations, measures loudness,
     ▼                       resizes covers, fingerprints files, writes the song list
 public/catalog.json         public/media/
 public/waves/               │
     │                       │ npm run publish:media
     │ deploy site           ▼
     ▼                       Media storage (Cloudflare R2)
 Static host                 audio and covers, served with
 HTML, JS, CSS, catalog      HTTP range requests
 and waveforms               │
     │                       │
     └───────────┬───────────┘
                 ▼
          Visitor's browser
          1. fetches catalog.json and shows the songs
          2. an <audio> element streams the chosen song
```

There's no application server and no database. The site is static files, the song list is one JSON file generated on your computer, each song's waveform is a tiny file generated alongside it, and the audio sits on storage built for serving large files.

## 3. Key decisions

| Topic | Decision | Why |
|---|---|---|
| Kind of app | Static single-page app. No backend, no database. | Only you add music and visitors only listen. With no server there's nothing to secure, patch or pay for. |
| "Uploading" a song | Put its files in `sai_songs/` and run `npm run catalog`. | One command checks and prepares everything. No upload page or login to build. |
| Song list | A generated `catalog.json`, plus one tiny loudness file per song | One small file to load. Durations, cover colours and each song's loudness and bass are worked out ahead of time, so the page renders instantly and the browser never has to analyse audio for the waveform or the pulse. |
| Audio delivery | Original files, streamed over HTTP with range requests | 320 kbps needs only about 40 KB/s, so there's no need for transcoding or adaptive streaming (HLS/DASH). Range requests make seeking instant. |
| Audio format | MP3, ideally 320 kbps CBR. AAC (`.m4a`) is also accepted. | Plays in every browser. |
| Playback | A single `<audio>` element plus the Media Session API | It streams instead of loading whole files into memory, keeps playing in the background, and gets lock-screen and headphone controls. |
| Interface | The playing song's cover above an endless wheel of songs, beside a scrolling waveform and controls, all laid straight on an animated photo with no panels | The direction settled in the prototype ([section 6](#6-the-interface)): soft and dreamy, in the covers' colours, with the waveform as the boldest thing on the page. Everything works by tap, click or key. |
| Background | A photo of an angel in the snow, recoloured and animated by one small WebGL shader that also draws falling snow, on a canvas smaller than the window and stretched to fill it | It keeps the chosen image while matching the site's colours, and one pass on a small canvas costs little. It changes colour with each new song and never stops: the site is always animated. Without WebGL, a plain gradient sky with CSS stars shows instead. |
| Theme | Follows the device's light or dark setting, with a Light mode switch in the footer | Visitors can pick the look they like, and their choice is remembered on their device. |
| Type | Amelie for the wordmark, as an image. Century Gothic for everything else, with Didact Gothic as the free stand-in. | The pairing chosen for the site. Their licenses decide how each one can be used ([section 12](#12-security-rights-and-privacy)). |
| Front end | TypeScript + Vite, no UI framework | It's one screen, and the hard part (the player engine) doesn't depend on a framework. No runtime dependencies keeps the page tiny. |
| Covers | Kept in `song_covers/`, resized at build time with `sharp` into WebP at four sizes, and dealt out to the songs at random on each visit | A 3000 px cover can be several MB, but the player only needs about 30 KB. Dealing them at random keeps the page feeling fresh. |
| Hosting | Site on Cloudflare Pages, audio and covers on Cloudflare R2 | R2 has no egress fees and supports range requests. Static hosts often cap file size (Pages: 25 MiB). See [section 11](#11-hosting-and-deployment). |

### Alternatives considered

- **An upload page on the site.** It needs a login, a server, write access to storage and protection against abuse. That's a lot of moving parts for something only you do now and then. Copying files and running one command does the same job safely. It can be added later.
- **Visitors play files from their own computer.** That's a different product: a local-file player where nothing is shared with listeners. If that's what you want, the player engine and interface below still apply, and a file picker replaces the catalog.
- **HLS/DASH streaming or server-side transcoding.** These are built for video, live streams and adaptive quality. For 40 KB/s audio they add complexity and would re-encode your files.
- **React or Next.js.** Good tools, but a component framework with server rendering is more machinery than a one-screen player needs. If the interface grows a lot, the view layer can move to a framework without touching the engine.
- **The click wheel.** The first direction was a click-wheel music player. The prototype moved to tapping songs in a list instead: it's quicker for everyone and leaves more room for the covers and the waveform. The wheel is parked ([section 14](#14-parked-ideas)).

## 4. Adding music: the content pipeline

"Uploading" a song means putting its MP3 in `sai_songs/`. Cover images go in `song_covers/`. A build script then checks everything and prepares it for the web.

### 4.1 Source folders

```
sai_songs/                                 the songs
├─ a spin.mp3
├─ cliche.mp3
├─ _lucid.mp3
├─ Who's that out there! (prod.wixxy).mp3
├─ Interest (prod kuga).mp3
├─ scream.mp3
└─ songs.json                              optional: order, artists, titles, hidden songs, pinned covers
song_covers/                               the cover images, any names
├─ sai_img1.jpg
├─ …
├─ download (11).jpg
└─ chico y chica foto para compartir.jpg
```

- **The filename is the title, exactly as written.** "a spin" stays lowercase and "_lucid" keeps its underscore. Nothing is auto-capitalised. The one exception is a producer's credit in brackets at the end, such as `(prod kuga)`: it's shown after the artist instead, so `Interest (prod kuga).mp3` appears as "Interest", by "Heaven, vezxqr · prod kuga".
- **An artist in the file's tags is kept.** `Interest (prod kuga).mp3` is tagged "Heaven, vezxqr" and `Who's that out there! (prod.wixxy).mp3` "Heaven", so they always show those. Songs without one get a name from `artists` ([4.2](#42-optional-songsjson)).
- **Covers aren't tied to songs.** On every visit the player deals the images in `song_covers/` out to the songs at random. With more covers than songs, the extras turn up on other visits. To keep a cover with one song, pin it in `songs.json`. Use square images of at least 512 × 512 px: the player never shows a cover wider than about 450 pixels, even on sharp screens. Other shapes are centre-cropped, and smaller images are used as they are, with a warning.
- **Each song gets a URL-safe id** from its title. For example, `Who's that out there!` becomes `whos-that-out-there` and `_lucid` becomes `lucid`. Renaming a file changes its id.
- **`sai_songs/` and `song_covers/` are in git, so Cloudflare's build from GitHub has them.** You chose this in November 2026 to get the site live. The repository is public, so anyone can download them there, as they can from the site. It makes the repository about 28 MB bigger, and every new or replaced song adds its full size for good, so once the library grows, move the media to R2 as [section 11](#11-hosting-and-deployment) plans. Keep a separate backup of both folders too, for example on a cloud drive.

### 4.2 Optional `songs.json`

```json
{
  "artists": ["Heaven", "Saigned"],
  "order": ["a spin", "cliche", "_lucid", "Who's that out there! (prod.wixxy)"],
  "hidden": ["untitled demo"],
  "songs": {
    "cliche": { "title": "cliché" },
    "a spin": { "cover": "sai_img1.jpg" }
  }
}
```

| Field | Meaning |
|---|---|
| `artists` | Who the songs are credited to. A song without its own artist gets one of these at random on every visit, and every name appears at least once when there are enough songs. With a single name, every song shows it. |
| `order` | Songs listed here come first, in this order. Any others follow alphabetically. |
| `hidden` | Songs to leave off the site for now, for example one you're not ready to publish. |
| `songs` | Per-song overrides, keyed by filename without the extension: `title`, `artist`, `album`, and `cover` (an image in `song_covers/` that always goes with this song). |

### 4.3 What `npm run catalog` does

1. **Scan** `sai_songs/` for audio (`.mp3`, `.m4a`, plus `.wav`, `.flac` and `.aiff` masters), skipping songs listed under `hidden`, and `song_covers/` for images.
2. **Read each file's technical details** with `music-metadata`: codec, bitrate, sample rate, channels and exact duration, plus any artist in its tags.
3. **Apply the quality policy** ([4.4](#44-quality-policy)). Errors stop the build and warnings are printed.
4. **Catch duplicates.** Two songs with identical files are flagged, which catches the same file dropped in twice under different names.
5. **Measure loudness for the waveform and the pulse.** Each song is decoded once with ffmpeg, and two readings are recorded every 50 ms: its overall loudness (RMS), which draws the waveform, and its bass (the loudness below about 140 Hz), which drives the pulse behind the cover. Each is scaled so the loudest 1% of moments reach the top, at one byte per reading. That's about 2.4 KB per minute of music, saved as a small file for each song.
6. **Process covers** ([4.5](#45-covers)).
7. **Fingerprint and copy.** Each output file is copied into `public/media/` (audio and covers) or `public/waves/` (loudness) under a URL-safe name that includes a short hash of its contents. Unchanged files are skipped, so re-runs are quick.
8. **Write `public/catalog.json`** and print a summary: title, duration, bitrate, size and any warnings.
9. **Clean up** output files that no longer belong to any song or cover.

### 4.4 Quality policy

| You drop in | What happens |
|---|---|
| MP3 or AAC (`.m4a`) at up to 320 kbps | Published as-is, byte for byte. Lossy audio is never re-encoded, because re-encoding only loses quality. |
| A lossless master (WAV, FLAC, AIFF, ALAC) | Encoded once to MP3 at 320 kbps CBR with ffmpeg. |
| Lossy audio above 320 kbps | Warning. It plays, but uses more bandwidth than the 320 kbps target. |
| Lossy audio below 128 kbps | Warning. It's probably not the file you meant to publish. |
| Ogg, Opus, WMA or other formats | Error. They don't play reliably in every browser. Export an MP3 from the original instead. |
| An MP3 with a large cover image embedded in it (over 200 KB) | Warning. The embedded image has to download before the first second of sound can play. Strip it ([Appendix B](#b-ffmpeg-one-liners)). The site uses the images in `song_covers/` anyway. |

> Converting a 256 kbps MP3 to 320 kbps makes the file bigger, not better. To publish at 320 kbps, export from the original project or a lossless master.

### 4.5 Covers

- Each image in `song_covers/` is square-cropped and resized to 128, 256 and 512 px WebP (never enlarged), plus a 512 px JPEG for lock-screen artwork and link previews.
- **Skeleton art:** each cover is also traced down to its outlines and saved as a 480 px PNG mask of soft white lines ([6.5](#65-the-sky)). The cover is softened, its edges are found (Sobel), thinned to their crests and kept only where they're strong. The prototype does the same tracing in the browser, while the page is idle.
- Each cover's **strongest colour** is saved too: an average weighted towards its most saturated pixels, so a white cover with red details gives a red-leaning colour rather than grey. It fills the cover's space while the image loads, and tints the soft glow behind the player while that cover is showing. Working it out at build time means the browser never has to read the image's pixels.
- With no covers at all, songs show a pale record in the site's colours, plus a warning.

### 4.6 Output

```
public/
├─ catalog.json                         ← generated, committed
├─ waves/                               ← generated, committed (tiny)
│  └─ a-spin.51c0e7d4.bin               loudness and bass every 50 ms, a byte each
└─ media/                               ← generated, not committed
   ├─ audio/a-spin.3f9a1c2e.mp3
   └─ covers/sai-img1.7a2c90e1-256.webp (plus -128 and -512 .webp, -512 .jpg and -lines.png)
```

```json
{
  "version": 1,
  "generatedAt": "2026-11-21T03:00:00.000Z",
  "artists": ["Heaven", "Saigned"],
  "tracks": [
    {
      "id": "a-spin",
      "title": "a spin",
      "duration": 283.35,
      "audio": {
        "path": "audio/a-spin.3f9a1c2e.mp3",
        "type": "audio/mpeg",
        "bitrate": 256,
        "sampleRate": 44100,
        "bytes": 9068174
      },
      "waveform": { "path": "waves/a-spin.51c0e7d4.bin", "rate": 20 }
    }
  ],
  "covers": [
    {
      "id": "sai-img1",
      "color": "#d2bbbb",
      "accent": "#b5485a",
      "webp": {
        "128": "covers/sai-img1.7a2c90e1-128.webp",
        "256": "covers/sai-img1.7a2c90e1-256.webp",
        "512": "covers/sai-img1.7a2c90e1-512.webp"
      },
      "jpg": "covers/sai-img1.7a2c90e1-512.jpg"
    }
  ]
}
```

The hashes and colours above are only illustrative. A track with its own artist or a pinned cover also gets an `artist` or `cover` (the cover's id).

- **Media paths are relative to a media base URL**, set by `VITE_MEDIA_BASE_URL`. It's `/media/` locally and `https://media.your-domain.com/` in production, so the same catalog works in both places.
- **Waveform paths are relative to the site itself.** The files are tiny, so they ship with the site, and the browser can fetch them without any cross-origin setup.
- **Fingerprinted filenames** let browsers and CDNs cache files forever. Replacing a song produces a new name, so nobody hears a stale version. Uploading new files also never breaks the live site, because the old catalog points at old files that still exist.
- **`catalog.json` and `waves/` are committed.** They're small, they record exactly what's published, and the site build needs them. The build server doesn't have your music.

### 4.7 Everyday workflow

| Task | Steps |
|---|---|
| Add a song | Copy its MP3 into `sai_songs/`, run `npm run catalog`, check it with `npm run dev`, then release ([11.5](#115-release-workflow)). |
| Add or change covers | Add, replace or remove images in `song_covers/`, then follow the same steps. |
| Replace a song | Overwrite the file under the same name, then follow the same steps. The id stays the same and the fingerprint changes. |
| Hold a song back | Add its name to `hidden` in `songs.json`, then follow the same steps. |
| Remove a song | Delete its file, then follow the same steps. |
| Reorder songs | Edit `order` in `songs.json`, then follow the same steps. |

## 5. The player engine

### 5.1 Why a plain `<audio>` element

The Web Audio API looks like the natural choice for a music app, but its way of loading audio doesn't suit long songs:

- **Streaming.** `<audio>` starts playing after the first few hundred KB, and seeking fetches only the bytes it needs. Web Audio's `decodeAudioData` has to download the whole file and decode it into raw samples first, using about 20 MB of memory per minute of stereo audio.
- **Background playback.** Media elements keep playing with the screen off and appear in lock-screen controls.
- **The iPhone silent switch.** iOS silences Web Audio when the ring/silent switch is on, but `<audio>` keeps playing.

Web Audio can still be layered on later, for a visualiser or EQ, with `createMediaElementSource`. That needs CORS headers on the media host ([11.3](#113-configuration)).

### 5.2 Engine design

`player/engine.ts` owns one `<audio>` element for the app's whole lifetime. On iOS, reusing a single element is the most reliable way to keep auto-advance working while the screen is locked. The rest of the app talks to the engine, never to the element directly.

```ts
engine.load(track, { autoplay: true, startAt: 0 });
engine.play();
engine.pause();
engine.toggle();
engine.seek(seconds);
engine.subscribe((state) => { /* update the UI */ });
```

There's no volume control in the interface. Listeners use their device's volume.

How element events map to app state:

| `<audio>` event | Effect |
|---|---|
| `playing` | Status becomes *playing* and the buffering spinner hides. |
| `pause` | Status becomes *paused*. |
| `waiting`, `stalled` | Buffering spinner on the play button. |
| `durationchange` | Duration. The catalog's value is shown until this arrives. |
| `timeupdate` | Position. It fires about 4 times a second, so the progress bar animates with `requestAnimationFrame` in between. |
| `progress` | Buffered range, drawn behind the progress bar. |
| `ended` | Ask the queue what's next ([5.4](#54-queue-rules)). |
| `error` | Show "Couldn't play *song*" and skip to the next one. After 3 failures in a row, stop, since the listener is probably offline. |

### 5.3 Loading rules

- **No audio downloads on page load.** The last-played song appears in the player using catalog data (title and duration, with this visit's cover), but its file isn't requested until someone presses play.
- **`play()` returns a promise that can reject.** `NotAllowedError` means the browser blocked autoplay, so the player shows the paused state. `AbortError` means a newer request replaced this one, so it's ignored.
- **Rapid clicks are safe.** Each load gets a token, and events from a superseded load are ignored. Skipping through five songs quickly can't leave the UI out of sync.
- **Playback isn't gapless.** There's a short pause when switching songs. True gapless playback isn't possible with `<audio>` and isn't a goal. If the pause ever bothers you, a small range request for the next song shortly before the current one ends shortens it.

### 5.4 Queue rules

These are pure functions in `player/queue.ts`, fully covered by unit tests.

- **Choosing a song** plays it. Next then continues through the library in order from there.
- **Previous** restarts the current song if it's more than 3 seconds in. Otherwise it goes to the previous song.
- **Shuffle** runs a Fisher–Yates shuffle of the other songs, with the current song first, so every song plays once before any repeats. Turning shuffle off returns to library order from the current song.
- **Repeat** has three modes. *Off* stops after the last song. *All* wraps around, reshuffling if shuffle is on, without playing the same song twice in a row. *One* loops the current song.

### 5.5 Media Session (lock screen, headphones, media keys)

- On every song change, set `navigator.mediaSession.metadata` to a `MediaMetadata` with the title, artist, album (default "signedHeaven") and artwork (the cover dealt to that song on this visit: the 512 px JPEG and the WebP sizes).
- Handle the `play`, `pause`, `previoustrack`, `nexttrack`, `seekto`, `seekbackward` and `seekforward` actions.
- Call `setPositionState()` on load, play, pause and seek. Don't call it on every tick, because the operating system works out the position itself.

The result is lock-screen and notification controls on phones, plus working headphone buttons and keyboard media keys on desktop.

### 5.6 Remembering state

Everything is stored in `localStorage` under one versioned key, `signedHeaven:v1`:

- Shuffle, repeat, the Light mode choice, and the last song with its position. Covers and artist credits are dealt fresh on every visit, so they aren't saved.
- The position is saved every 5 seconds or so while playing, and on `pagehide` and `visibilitychange`. Those are the only reliable "leaving the page" signals on mobile.
- Every storage call is wrapped in `try/catch`, so private browsing or blocked storage never breaks playback.
- When the listener comes back, the last song appears paused at its saved position. It never starts playing by itself.

## 6. The interface

The page is one screen. On the left, the playing song's cover, title and artist sit above an endless wheel of songs. On the right, the song's waveform scrolls past as it plays, with the time bar and controls beneath. Behind everything is an animated photo of an angel in falling snow, recoloured with the song covers' colours. A working version of this design is in `prototype/` ([the prototype](#the-prototype)), and the app should match it.

### 6.1 Design principles

- **From the covers:** paper whites, silver, blush and blood red. Pale and dreamy, a little gothic and romantic, so the page feels like it belongs next to the artwork.
- **Ethereal:** light, glow and translucency, from the glowing wings and the snow to the frosted header and footer.
- **Soft:** rounded shapes, gentle gradients and slow movement. No harsh shadows or sudden motion.
- **Approachable:** one obvious thing to do (tap a song), text that's easy to read, and everything works with a tap, a click or a key.
- **The music comes first:** the waveform is the boldest thing on the page, and everything else stays quiet behind it.

### 6.2 The page

```
+------------------------------------------------------------------------+
| signedHeaven                       [SoundCloud] [guns.lol] [Instagram] |
+------------------------------------------------------------------------+
|                                                                        |
|                                                                        |
|        +--------+          a waveform scrolling past a centre line     |
|        | cover  |          |||  |||||| |||||||  ||  ||||||| ||||| ||   |
|        +--------+                                                      |
|          a spin            o-----------------------------------------  |
|          Heaven            0:12                                  4:43  |
|                                                                        |
|       _lucid      1:58                                                 |
|    ( a spin      4:43 )      repeat   prev   ( > )   next   shuffle    |
|       cliche      3:08                                                 |
|                                                                        |
|                                                                        |
+------------------------------------------------------------------------+
| made by inversedesigns                                 Light mode [o ] |
+------------------------------------------------------------------------+
```

The brackets in the header stand for icons, and the ones around "a spin" show the song wheel's middle band.

- **Header:** the signedHeaven wordmark on the left. On the right, SoundCloud, guns.lol and Instagram appear as single-colour brand icons in the theme's ink colour. Each opens in a new tab, so the music keeps playing. They point to [soundcloud.com/sqruem](https://soundcloud.com/sqruem), [guns.lol/signedheaven](https://guns.lol/signedheaven) and [instagram.com/saiswings](https://www.instagram.com/saiswings). More links can be added the same way.
- **The player** ([6.3](#63-the-player)) and **the playback area** ([6.4](#64-the-waveform-and-controls)), side by side and the same height.
- **Footer:** "made by inversedesigns" on the left, and the Light mode switch on the right. The page follows the device's light or dark setting until a visitor flips the switch, and their choice is remembered on their device.
- The header and footer are frosted bars. Between them, the angel photo fills the window ([6.5](#65-the-sky)).

### 6.3 The player

- **No panel.** Like the playback area beside it, the player sits straight on the sky with no fill, border, shadow or blur. The cover, with its glowing pulse, is the one floating object.
- **Top: the song that's playing.** Its cover (square, glowing softly in the cover's own colour), its title and its artist. Before anything plays, it shows a pale record and "Choose a song".
- **Sizes:** the cover is the biggest thing in the player, about a third of its height (around 200–220 px at common sizes, and a little smaller on the smallest players so a two-line title still fits). The title sits close beneath it at up to 27 px, the artist is smaller under that, and the wheel takes the lower 42%.
- **The pulse:** behind the cover, a glow swells with the song's bass, rising fast and settling slowly, and a ring spreads out from the cover on each bass hit. The bass is measured ahead of time ([4.3](#43-what-npm-run-catalog-does)). The pulse takes the main colour of the song's sky palette, the cover gives the smallest thump with it, and pausing the music stills it.
- **Beneath it: the song wheel**, after the iPhone Clock's timer picker:
  - The songs sit on a drum that turns endlessly: they repeat in order, forever, in both directions.
  - The song in the middle band (soft blush by day, crimson at night) is the chosen one. The rows tip away above and below it and fade towards the edges.
  - Each row has a small cover, the title and the length. Every row showing the playing song carries a small three-bar equaliser mark that moves with the music itself (its bass and loudness). On a narrow player, the mark replaces the playing song's length so its title has room.
- **Turning the wheel:** drag it, flick it (it coasts, then settles on a song), scroll over it, or use ↑ / ↓. The row that comes to rest in the middle becomes the chosen song, and Enter plays it. Tapping a row turns it to the middle and plays it, and tapping the playing song pauses or resumes it.
- **Animation**, after [Animate UI](https://animate-ui.com/)'s effects:
  - the wheel spins into place when the page opens;
  - a new title rolls in letter by letter, and the artist fades up after it;
  - a new cover zooms in out of a soft blur, with a shine passing over it;
  - with a mouse, the cover tilts gently towards the pointer and catches the light.
- **Artists:** a song tagged with an artist keeps it, so Interest is always by "Heaven, vezxqr". The rest are credited to Heaven or Saigned, picked at random on every visit, with both names always appearing. The names come from `artists` in `songs.json` ([4.2](#42-optional-songsjson)).
- **Producer credits:** a credit from the file name follows the artist, as in "Heaven, vezxqr · prod kuga". The song wheel shows titles only, so long names don't get cut short.
- **Covers:** the images in `song_covers/` are dealt out to the songs at random on every visit. A cover pinned in `songs.json` always stays with its song.

### 6.4 The waveform and controls

- **No panel.** The playback area sits straight on the sky with no fill, border, shadow or blur, just its contents, centred and as tall as the player beside it.
- **The waveform** shows the song's loudness as bars, one for every tenth of a second, scrolling right to left past a centre line. Bars left of the line have played and bars to the right are still to come. Each bar has a faint reflection below the baseline. The loudness comes from the catalog build ([4.3](#43-what-npm-run-catalog-does)), so nothing is analysed in the browser.
- **With no music playing, the bars rise and fall with the light passing over the angel's wings** behind them, using the same maths that draws it. Before a song is chosen, they take the sky's colours, lifted towards white at night so they stand out on the photo. When a song is paused, its own bars rise and fall with it.
- **Colours chosen to stand out:** dark wine with a pale halo by day (at least 5 : 1 against any part of the day photo) and ivory with a rose glow at night (about 17 : 1 against the night sky, and about 3 : 1 over the brightest part of the wings), with the part still to come drawn lighter.
- **The time bar:** a thin track with a fill and a knob, with the elapsed time on the left and the length on the right. Tap or drag to seek. When it has focus, the arrow keys step 5 seconds and Home and End jump to the ends.
- **Controls:** repeat, previous, play/pause (larger, in a ring), next and shuffle. Repeat cycles through off, all and one (a small "1" shows for one). Shuffle and repeat show a dot when they're on.

| Key | What it does |
|---|---|
| ↑ / ↓ | Move the highlight in the song list |
| Enter | Play the highlighted song |
| Space or K | Play / pause |
| ← / → | Previous / next song. Hold to rewind or fast-forward. |
| S | Shuffle on or off |
| R | Repeat: off, all, one |

None of these override what a focused control already does with a key.

### 6.5 The sky

- **The angel:** the background is a photo of an angel with white wings on a snowy night (`site_art/angel-wings.jpg`), recoloured into the site's colours and always moving. It's drawn with WebGL on a canvas at up to 60% of the window's size and stretched to fill it, which keeps it soft and cheap.
  - **The colours:** the photo's grey night sinks to the theme's darkest tone (wine-black at night, cream by day), its middle tones take the playing song's colour, and its wings take the theme's light (dusty rose at night, near-white by day). The tokens are `--sky-shadow`, `--sky-light`, `--sky-mid-mix` and `--sky-glow`.
  - **The movement:** the photo breathes slowly in and out, about once every 40 seconds, and drifts a little against the pointer. The wing tips stir as if in a breeze, more on the bass, while the body stays still. A soft band of light crosses the wings every 12 seconds or so, and the song's colour gathers around them, swelling on each bass hit.
  - **Snow:** three layers fall in front of the photo. The nearer flakes are larger, softer and quicker, and move more with the pointer. The snow is ivory at night and white by day.
  - **Fitting the screen:** the photo covers wide screens. On tall ones, such as phones, covering the height would show only the angel's back, so the photo keeps more of its width and fades into the sky colour above and below.
  - **Without WebGL**, or until the photo has loaded, a plain gradient sky shows, with twinkling stars.
- **A new colour for each song:** when a new song starts, the sky fades over about 2.5 seconds to a different palette, and a song that repeats keeps its colours.
  - **At night**, the six palettes are rose, blood moon, blush, gilt, ember and wine, within the covers' reds, pinks, ivory and gold.
  - **By day (Light mode)**, a second set of six keeps to deeper reds and pinks: crimson, blood and blush, deep rose, wine pink, pink, and oxblood rose.
- **Shooting stars:** every 9 to 23 seconds, a shooting star streaks down to the left.
- **Skeleton art:** while a song plays, its cover's outlines ([4.5](#45-covers)) are laid large and faint across the sky, in the song's colour.
  - The art drifts a little against the pointer, and a soft light follows the pointer across its lines. With no pointer about, as on a phone, the light wanders slowly on its own.
  - It breathes with the bass.
  - Pausing fades it out, and a new song's art crossfades in.
- **Readable on the photo:** text and controls on the photo carry a soft halo, dark at night and light by day, so they stay readable over the bright wings.
- **Glow and grain:** a faint glow takes the playing cover's strongest colour, and a light paper grain lies over everything.
- **Always moving:** by choice, the site is always animated. The photo, its light and the snow never stop, even on devices set to reduce motion.

### 6.6 Look and feel

The mood comes from the song covers: crumpled white paper, silver, doll eyes, an anatomical heart, red thread and blood, a golden key.

**Palette**

| Colour | Hex | Used for |
|---|---|---|
| Cream | `#F4EDE6` | The day background. The day photo's darkest tone is `#F1E4DC`, and the plain fallback sky runs from `#F8F3ED` at the top to a blush `#EEDDD5` at the bottom. |
| Bone | `#FBF7F2` | Paper-white highlights, such as the blank record shown before a song is chosen. |
| Blush | `#EBC3C3` | The highlighted song by day, soft glows, and the focus ring at night |
| Rose | `#D98C95` | Glows, and the start of the night time bar's fill. Night-time icons use a brighter `#E58A9A`. |
| Crimson | `#A3122A` | By day: active icons, focus rings and the day sky's palettes. At night: the highlighted song (`#8E1428` to `#B0243C`). |
| Oxblood | `#5E0B1A` | By day: the time bar's knob, and the waveform's dark wine (`#3A0A14` to `#7A0E22`). The part still to come is wine ink at 42% strength. |
| Wine ink | `#2A1518` | Text by day |
| Night | `#140A0D` | The night background. The night photo runs from `#0B0507` in its sky to dusty rose `#A47A84` on its wings, and the plain fallback sky deepens to `#2B0F18` at the bottom. |
| Ivory | `#F7EEE8` | Text at night. The night waveform is `#FFF6F0`. |
| Antique gold | `#B08A55` | A hint of warmth, from the key on one cover. The sky's gilt palette is built around it. |

**Readable combinations**

| Text | Background | Contrast | Use for text? |
|---|---|---|---|
| Wine ink | Cream | 14.9 : 1 | Yes |
| Wine ink | Blush | 10.8 : 1 | Yes |
| Muted ink `#5E4347` | Cream | 7.6 : 1 | Yes |
| Crimson | Cream | 6.8 : 1 | Yes |
| Ivory | Night | 17.0 : 1 | Yes |
| Muted ivory `#D9C3C0` | Night | 11.6 : 1 | Yes |
| `#FFF4EE` | Crimson `#B0243C` | 6.1 : 1 | Yes |
| Rose `#E58A9A` | Night | 7.8 : 1 | Yes, for icons and accents |
| White | Blush or Rose | 1.6–2.6 : 1 | No |
| Crimson | Night | 2.5 : 1 | No |

The rule of thumb: by day, write in wine ink. At night, write in ivory. White text never goes on blush or rose, and crimson never goes on the night sky.

**Two themes.** The page follows the visitor's device setting until they flip Light mode in the footer:

- **Day (Light mode):** the angel photo in cream and blush, with white wings and white snow, white frosted glass, wine-ink text and a dark wine waveform.
- **Night:** the angel photo in wine-black and dusty rose with ivory snow, dark glass, and ivory text and waveform.

**Typography**

- **The wordmark:** "signedHeaven" in Amelie, a flowing brush-script handwriting font by Graphix Line Studio, from Creative Fabrica. Its license doesn't allow embedding the font in a website, so the wordmark is the lettering drawn as outlines (SVG), made from the font file by `prototype/make-wordmark.mjs` ([section 12](#12-security-rights-and-privacy)). There are two versions in `site_art/`: `wordmark.svg`, a signature with Amelie's lead-in swash on the "s" and trailing tail on the "n", for wider screens, and `wordmark-plain.svg`, without them, for phones, where it keeps the letters larger. Both take the text colour, with a soft glow.
- **Everything else:** Century Gothic, a round geometric sans-serif. It's a paid Monotype font. Visitors who have it installed (it comes with Microsoft Office) see it, and showing it to everyone needs a Monotype web license. Everyone else sees Didact Gothic, a free look-alike, self-hosted as a subset WOFF2. All interface text uses the regular weight, which suits the light, airy look.

**The browser tab**

- **Title:** "Saigned".
- **Icon:** a hand-painted-style brush-stroke cross, drawn for the site (`site_art/favicon.svg`): the ink colour, or cream when the device is in dark mode. Safari always shows an icon in its light-mode colours, even on a dark tab bar, so the ink cross has a thin paper-coloured edge that keeps it visible there and can't be seen on light tab bars.
- **Home-screen icon:** `site_art/apple-touch-icon.png`, the same cross on the cream paper, 180 × 180, for iPhones. It's `favicon.svg` drawn 136 px tall in the middle, screenshotted in a headless browser; remake it if the cross changes.

**Motion**

- Slow and floaty. Interface transitions take 200–600 ms with a gentle settle (`cubic-bezier(0.22, 1, 0.36, 1)`). The glow behind the player shifts colour over 2.4 seconds, and the sky over 2.6.
- **Always animated**, by choice: nothing stops the photo's movement, the snow or the equaliser mark, even on devices set to reduce motion ([6.5](#65-the-sky)). Pausing the music stills the pulse.

### 6.7 Layout on different screens

- **Desktops and tablets:** the player on the left and the playback area on the right, side by side, the same height, and centred between the header and footer. The player grows with the window, up to 620 px tall, keeping its shape. Nothing scrolls at common desktop sizes.
- **Phones (under 520 px wide):** the player stacks above the playback area, and the page scrolls.
- **The header** keeps the wordmark and icons on one row down to 360 px wide. On narrower screens the icons move under the wordmark, and the footer's two parts centre.
- Touch targets are at least 38 px (WCAG asks for 24), and nothing depends on hover.
- Safe-area insets keep everything clear of notches and the home bar.

## 7. Accessibility and performance

**Accessibility** (target: WCAG 2.2 AA)

- Real `<button>` elements for previous, play/pause, next, shuffle and repeat, with labels that reflect state, such as "Play", "Pause" and "Repeat: All". Shuffle and repeat also report whether they're on (`aria-pressed`).
- The song wheel is a listbox (`role="listbox"` with `aria-activedescendant`) whose options are hidden copies of the songs. Arrow keys turn it, and screen readers announce each song, for example "a spin by Heaven, 4:43, now playing". The drawn rows are hidden from screen readers.
- The time bar is a real slider that reads naturally, for example `aria-valuetext="1:12 of 4:43"`.
- The header's brand icons carry hidden text names ("SoundCloud", "guns.lol", "Instagram") and a tooltip. Light mode is a real switch (`role="switch"` with `aria-checked`).
- Visible focus rings (crimson by day, blush at night), and everything works with the keyboard alone ([6.4](#64-the-waveform-and-controls)).
- Song changes are announced through a polite live region: "Now playing: a spin by Heaven".
- Covers next to their titles use `alt=""`, so screen readers don't read every title twice. The waveform, the sky and the skeleton art are decorative and hidden from screen readers.
- Text contrast of at least 4.5:1, using only the combinations listed in [6.6](#66-look-and-feel). Nothing sits in a panel, so text has to stay readable over the photo. Over the brightest part of the wings at night, muted text on its own drops to about 2 : 1, so all text and controls on the photo carry a soft halo (dark at night, light by day). Check this with a contrast tool on the real app. If it falls short, lower `--sky-light`.
- **Moving content:** by choice, the site is always animated and offers no way to stop the background. WCAG asks for one when movement runs for more than five seconds (2.2.2), so this is a known gap, which a Motion switch would close. Pausing the music stills the cover's pulse.

**Performance targets**

- App code under 50 KB of compressed JS and CSS.
- Lighthouse on mobile: Performance 90 or higher, Accessibility 100.
- Under a second from click to sound on a normal broadband connection.
- Covers are right-sized through `srcset` and `sizes`, use `loading="lazy"` and `decoding="async"`, and keep a fixed 1:1 aspect ratio so nothing shifts. The cover's colour shows while each image loads.
- **The sky stays cheap.** One small WebGL shader draws the photo and its snow in a single pass, on a canvas at up to 60% of the window's size (never more than 1100 px across or down), up to 60 times a second, and only while the tab is visible. The fallback stars twinkle using only `opacity` and `transform`.
- While a song plays, the waveform redraws every frame and the pulse updates a few small elements. Otherwise the waveform redraws with the sky, about 30 times a second. Each song's loudness file (about 12 KB for a 5-minute song) loads with the song.
- The song wheel redraws its nine rows only while it's turning. Skeleton art is traced once per cover, and it repaints only as the light follows the pointer.
- Fingerprinted files are cached for a year. `catalog.json` and `index.html` are revalidated on every visit, so new songs show up immediately.

## 8. Browser support and platform quirks

The target is the current and previous major versions of Chrome, Edge, Firefox and Safari (macOS and iOS), plus Samsung Internet.

| Where | Quirk | How it's handled |
|---|---|---|
| All browsers | Autoplay is blocked until the visitor interacts with the page. | Nothing plays before the first click or tap. A restored song starts paused. |
| All browsers | Background tabs throttle timers and pause `requestAnimationFrame`. | Auto-advance runs off the `ended` event, not a timer. The sky and the waveform simply stop drawing and carry on when the tab is shown again. |
| All browsers | A graphics driver reset can take the WebGL canvas with it. | The plain sky shows until the photo is set up again on its own. |
| Safari, iOS | Media from servers that ignore range requests won't play. | Hosting checklist and `curl` test ([11.1](#111-what-the-audio-host-must-do), [11.6](#116-check-before-launch)). |
| iOS | Pages can't change `audio.volume`. | Not an issue: the interface has no volume control, and listeners use the device's volume. |
| iOS | Playback must start from a tap, and a newly created element may need another one. | One `<audio>` element, reused for the app's lifetime. |
| iOS, Android | Lock-screen controls and the lock-screen seek bar need Media Session metadata and position state. | See [5.5](#55-media-session-lock-screen-headphones-media-keys). |
| Phones | There's no hover. | Nothing depends on hover. |
| Phones | Dragging the time bar or the song wheel would normally scroll the page. | `touch-action: none` on both, and pointer capture while dragging. |
| Windows, macOS, iOS, Android | Devices with animations turned off report `prefers-reduced-motion`. | The site stays animated anyway, by choice ([6.6](#66-look-and-feel)). |

## 9. Tech stack and project layout

| Part | Choice |
|---|---|
| Language | TypeScript in strict mode. Types are shared between the catalog script and the app. |
| Dev server and bundler | Vite |
| UI | Plain DOM, `<template>` elements and a small observable store. Each UI module subscribes to the state it shows and updates only its own elements. |
| Graphics | Two `<canvas>` elements: one for the waveform (2D), and one for the background photo and its snow (WebGL, one small shader). The fallback sky, its stars and everything else are plain CSS. |
| Styling | Plain CSS with custom properties: one set of tokens for each theme |
| Fonts | Didact Gothic, self-hosted as a subset WOFF2, with Century Gothic named first for visitors who have it. The wordmark is an SVG image. |
| Catalog script | Node.js 24 or newer, with `music-metadata`, `sharp` and `ffmpeg-static` (to measure each song's loudness and bass, and to encode lossless masters) |
| Tests | Vitest for unit tests, Playwright for end-to-end tests |
| Code quality | ESLint and Prettier, both supported out of the box in JetBrains IDEs |
| Hosting | Cloudflare Pages for the site, Cloudflare R2 for media |

```
saigned/
├─ sai_songs/                  your songs (the source of truth)
├─ song_covers/                your cover images
├─ site_art/                   the background photo, the wordmark (SVG) and the tab and home-screen icons
├─ prototype/                  the working design (see below)
│  ├─ player.tpl               the page: HTML, CSS and script in one file
│  ├─ peaks.json               loudness and bass measured from the six songs
│  ├─ build.mjs                player.tpl + peaks.json → dist/, with songs and images beside it
│  ├─ serve.mjs                local preview at http://localhost:5179
│  ├─ make-wordmark.mjs        Amelie.otf → site_art/wordmark.svg
│  ├─ worker.js                serves the songs with range requests on Cloudflare
│  └─ dist/                    the built page with songs/, covers/ and art/ (generated, not in git)
├─ scripts/
│  ├─ build-catalog.ts         sai_songs/ + song_covers/ → public/
│  └─ publish-media.ts         uploads new files in public/media/ to R2
├─ public/
│  ├─ catalog.json             generated, committed
│  ├─ waves/                   loudness files: generated, committed
│  ├─ media/                   generated, not committed
│  ├─ fonts/                   self-hosted WOFF2 fonts
│  ├─ art/                     the background photo, copied from site_art/
│  ├─ wordmark.svg             signedHeaven, outlined from Amelie
│  ├─ _headers                 caching and security headers
│  └─ favicon.svg
├─ src/
│  ├─ main.ts                  start-up: load the catalog, create the engine, mount the UI
│  ├─ config.ts                media base URL and other constants
│  ├─ catalog/
│  │  ├─ types.ts              Track, Cover and Catalog types (shared with scripts/)
│  │  ├─ load.ts               fetches and checks catalog.json
│  │  └─ deal.ts               deals this visit's covers and artist credits
│  ├─ player/
│  │  ├─ engine.ts             wraps the single <audio> element
│  │  ├─ queue.ts              next, previous, shuffle, repeat (pure functions)
│  │  ├─ media-session.ts      lock screen and media keys
│  │  └─ persistence.ts        localStorage, versioned and failure-safe
│  ├─ state/
│  │  └─ store.ts              tiny observable store
│  ├─ ui/
│  │  ├─ header.ts             wordmark and brand links
│  │  ├─ player-panel.ts       now-playing cover, title and artist
│  │  ├─ song-wheel.ts         the endless wheel of songs
│  │  ├─ skeleton.ts           traces covers into skeleton art and lays it on the sky
│  │  ├─ pulse.ts              the cover's bass pulse, rings and tilt
│  │  ├─ playback.ts           time bar and controls
│  │  ├─ waveform.ts           draws the scrolling bars from a loudness file
│  │  ├─ sky.ts                the photo shader and its snow, the fallback sky, shooting stars
│  │  ├─ footer.ts             credit and the Light mode switch
│  │  ├─ keyboard.ts           the shortcuts in 6.4
│  │  └─ format.ts             time formatting
│  └─ styles/
│     ├─ tokens.css            palette, Day and Night themes, spacing, fonts
│     └─ app.css
├─ tests/
│  ├─ fixtures/                three 3-second songs and two covers, made once with ffmpeg
│  ├─ unit/
│  └─ e2e/
├─ .gitignore
├─ wrangler.jsonc              Cloudflare: builds the prototype and deploys it
├─ index.html
├─ package.json
├─ tsconfig.json
├─ vite.config.ts
└─ README.md
```

**Commands**

| Command | What it does |
|---|---|
| `npm install` | Installs dependencies. Run it once. |
| `npm run catalog` | Checks and processes `sai_songs/` and `song_covers/` into `public/catalog.json`, `public/waves/` and `public/media/`. |
| `npm run dev` | Starts a local dev server with hot reload. `npx vite --host` also makes it reachable from your phone on the same Wi-Fi. |
| `npm run build` | Type-checks and builds the production site into `dist/`. |
| `npm run preview` | Serves the production build locally. |
| `npm test` | Runs the unit tests. |
| `npm run test:e2e` | Runs the browser tests. |
| `npm run lint` | Runs the ESLint and Prettier checks. |
| `npm run publish:media` | Uploads new media files to R2. |
| `npm run prune:media` | Deletes media from R2 that no current song uses. |

### The prototype

`prototype/` holds the working design that the app should match. It's one self-contained page with every part of the interface in [section 6](#6-the-interface): the real covers, each song's measured loudness and bass, the pulse and animations, the sky and both themes. It plays the actual songs, with an engine built to the plan in [section 5](#5-the-player-engine):

- one `<audio>` element that downloads nothing until the first play, then streams, with seeking through range requests;
- a buffering ring on the play button while a song loads;
- moving on when a song ends, which keeps working with a phone's screen off;
- "Couldn't play this song" and a skip for a file that won't load, stopping after three in a row;
- lock-screen, headphone and media-key controls through Media Session;
- the last song and the place in it remembered on the device, and shown paused on the next visit.

The waveform, the pulse and the equaliser follow the audio's own clock, so they stay in time with what you hear. Building and previewing need only Node.js, with nothing to install.

| Command | What it does |
|---|---|
| `node prototype/build.mjs` | Builds `prototype/dist/index.html` from `player.tpl` and `peaks.json`, checks that the page's script parses and its tags pair up, and copies the songs from `sai_songs/` into `dist/songs/`, the covers from `song_covers/` into `dist/covers/` and the photo and home-screen icon from `site_art/` into `dist/art/`, so `dist/` is complete on its own. It fills in each song's title, credit, length, file and measurements, and writes the night colours, kept once in `player.tpl`, into both places the page needs them. Songs are named by their ids (`Who's that out there! (prod.wixxy).mp3` becomes `whos-that-out-there.mp3`). Covers get web-safe names (`download (11).jpg` becomes `download-11.jpg`) and are listed in the page automatically, so new ones just need a rebuild. It also puts the wordmark from `site_art/` into the header and the tab icon into the page itself (in the full page only: `--fragment`, for Claude, leaves the icons out), and warns about any song in the page's list (`SONGS` in `player.tpl`) that has no MP3 or measured waveform, and any MP3 missing from that list. |
| `node prototype/make-wordmark.mjs <path to Amelie.otf>` | Draws the wordmark from the font as outlines into `site_art/wordmark.svg` and `wordmark-plain.svg`. It needs the opentype.js library, installed once in this folder with `npm install --no-save opentype.js@1.3.4`. |
| `node prototype/serve.mjs` | Serves the built page at http://localhost:5179, with the songs and images the build copied beside it. Songs are served with range requests, as R2 serves them, so streaming and seeking behave as they will on the real site. Rebuild and refresh to see changes. |

Open the page through `serve.mjs` rather than straight from the disk. Opened as a file, the covers show, but browsers won't let WebGL use the photo, so the plain sky shows instead.

**Adding a song to the prototype:** put its MP3 in `sai_songs/`, add its file name to `SONGS` in `player.tpl` (with `artist` if the file is tagged with one), add its loudness and bass to `peaks.json`, and rebuild. The build fills in everything else. The measurements in `peaks.json` were made in the browser with Web Audio, the same way as step 5 of [4.3](#43-what-npm-run-catalog-does): RMS every 50 ms, then the same through a 140 Hz low-pass for the bass, each scaled to its 99th percentile. There's no script for that in the repository yet, so a new song shows flat bars until it's measured, and the build warns about it.

**On Cloudflare:** the Worker `saignedheaven` builds and deploys the prototype from GitHub on every push to `main`. Its build runs `npx wrangler deploy`, which reads `wrangler.jsonc`: that runs `node prototype/build.mjs`, then uploads `prototype/dist/` (the page, songs, covers and art). Cloudflare's static files ignore range requests, which a browser needs to seek in a song and Safari needs to play one at all, so song requests go through a small Worker, `prototype/worker.js`, that answers them; everything else is served straight from the static files. The build writes a complete web page. With `--fragment`, it leaves out the document around the page, for publishing to Claude, whose host adds its own. If a push to `main` doesn't start a build and the Worker's settings say it's disconnected from your Git account, the Cloudflare Workers and Pages app on GitHub can't see this repository: on GitHub, open Settings, then Applications, then Configure next to the app, and add `saignedHeaven` under Repository access.

A published copy, private to your Claude account, is at https://claude.ai/artifact/7Fb8kujYPy7sawWRwrCWku. It's the built page with the six songs in a `songs/` folder (about 27 MB, byte for byte the files in `sai_songs/`), the nine covers in `covers/` and the photo in `art/`. Anyone you share it with can play the songs and save them, so share it only with people you'd send them to. The songs play there too. If one ever won't stream, the player downloads the whole file and plays that instead.

## 10. Testing

- **Unit tests (Vitest)** cover the queue rules (next and previous at the ends of the list, shuffle visiting every song exactly once, each repeat mode), dealing covers and artist credits (no cover twice in one visit, every artist name appearing), the sky picking a different palette for each new song, time formatting, id generation (`Who's that out there!` → `whos-that-out-there`), splitting a producer's credit from a file name, quality-policy decisions, loudness and bass measurement, bass-hit detection, `songs.json` merging and duplicate detection.
- **A pipeline test** runs the catalog script on `tests/fixtures/` and compares the resulting `catalog.json` with a snapshot, which catches accidental format changes.
- **End-to-end tests (Playwright, in Chromium and Firefox)** run against the fixture songs. They check that choosing a song starts playback and time advances, pause and resume, seeking, next and previous, auto-advance when a song ends, shuffle and repeat, the keyboard controls, turning the song wheel (dragging, flicking, scrolling, keys) and its wrap-around, the Light mode switch (and that it's remembered), state restored after a reload, Media Session metadata, and that a missing file shows an error and gets skipped.
- **A manual device checklist runs before each release.** Safari and iOS are covered here, because their media behaviour differs from Playwright's WebKit build.
  - iPhone (Safari) and Android (Chrome): lock-screen controls, auto-advance with the screen off, Bluetooth headphone buttons, dragging the time bar without scrolling the page, and whether the background photo and snow stay smooth.
  - Desktop: media keys, plus Chrome DevTools network throttling to confirm the buffering spinner appears and nothing gets stuck.
  - A keyboard-only pass and a screen-reader pass (VoiceOver or NVDA).
- **CI (GitHub Actions)** runs type-checking, linting, and the unit and end-to-end tests on every push.

## 11. Hosting and deployment

### 11.1 What the audio host must do

- [ ] Answer range requests with `206 Partial Content`. Seeking depends on it, and Safari won't play audio without it.
- [ ] Send the right `Content-Type`: `audio/mpeg`, `audio/mp4`, `image/webp`, `image/jpeg`.
- [ ] Not compress audio on the fly. MP3 is already compressed, and on-the-fly compression can break range requests.
- [ ] Accept files as large as your longest song, which is about 2.4 MB per minute at 320 kbps.
- [ ] Allow a long `Cache-Control` lifetime on fingerprinted files.
- [ ] Charge little or nothing for bandwidth. Each full play of a 4-minute 320 kbps song is about 10 MB.

### 11.2 Recommended setup

| Piece | Where | Why |
|---|---|---|
| Site: HTML, JS, CSS, `catalog.json` | Cloudflare Pages | Free, served from a global CDN, with a preview URL for every branch |
| Media: audio and covers | A Cloudflare R2 bucket on a custom subdomain such as `media.your-domain.com` | No egress fees, range requests supported, S3-compatible uploads |

- **Why not put the audio on Pages too?** Pages caps each file at 25 MiB, which is about 10.9 minutes at 320 kbps. There have also been reports of Cloudflare's static-asset hosting ignoring range requests. R2 has neither problem.
- **R2 needs a custom domain in production.** Its built-in `r2.dev` address is rate-limited and meant for development only, and a custom domain has to be managed in Cloudflare.
- **Any host that passes the checklist can replace either piece.** For a quick first launch, today's songs (4 to 9 MB each) fit comfortably on a single static host, as long as the [`curl` check](#116-check-before-launch) passes.

### 11.3 Configuration

- `VITE_MEDIA_BASE_URL` defaults to `/media/` for local development. Set it to `https://media.your-domain.com/` in `.env.production`.
- When media is served from R2, the production build leaves `public/media/` out of `dist/`.
- R2 upload keys live in `.env.local`, which git ignores. They never go in code.
- **CORS** isn't needed for plain `<audio>` and `<img>` tags. Add a `GET`/`HEAD` rule for your site's origin only if JavaScript later fetches media itself, for preloading or a visualiser. Never set `crossorigin` on the audio element without that rule, or nothing will play.

### 11.4 Headers

`public/_headers`, which Cloudflare Pages reads:

```
/assets/*
  Cache-Control: public, max-age=31536000, immutable

/waves/*
  Cache-Control: public, max-age=31536000, immutable

/catalog.json
  Cache-Control: no-cache

/*
  Content-Security-Policy: default-src 'self'; img-src 'self' https://media.your-domain.com; media-src 'self' https://media.your-domain.com
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin
```

The publish script sets `Cache-Control: public, max-age=31536000, immutable` and the correct `Content-Type` on every object it uploads to R2.

### 11.5 Release workflow

```powershell
npm run catalog            # check and process the songs
npm run dev                # look at the result locally
npm run publish:media      # upload new audio and covers to R2
git add public/catalog.json
git commit -m "Add new song"
git push                   # Cloudflare Pages rebuilds the site
```

- **Media goes first, then the site**, so the new catalog never points at files that haven't been uploaded yet. Visitors who still have the old page open keep working, because the old files are still there. Run `npm run prune:media` now and then to delete files nothing uses anymore.
- Without a git-connected Pages project, run `npm run build` and then `npx wrangler pages deploy dist` to deploy from your computer instead.

### 11.6 Check before launch

```powershell
curl.exe -s -D - -o NUL -H "Range: bytes=0-1" "https://media.your-domain.com/audio/a-spin.3f9a1c2e.mp3"
```

On macOS or Linux, use `curl` and `-o /dev/null`. Expect `206` in the status line, `Content-Range: bytes 0-1/<file size>` and `Content-Type: audio/mpeg`. A `200` means the host ignores range requests: seeking will break and Safari won't play.

### 11.7 Costs

Today's library (6 songs, about 28 MB, plus about 440 KB of covers) fits easily in free tiers. As a rough guide, 1,000 full plays of 4-minute 320 kbps songs comes to about 10 GB of downloads, and R2 charges no egress fees for that. R2's free storage, 10 GB at the time of writing, holds about 70 hours of 320 kbps audio. Check current pricing before launch.

## 12. Security, rights and privacy

- **Small attack surface.** There are no logins, no database and no user input. Song details are inserted with `textContent`. The only markup built in script is the site's own fixed icon artwork.
- **Security headers** are set as shown in [11.4](#114-headers).
- **No cookies or trackers**, so there's no need for a cookie banner. The few things remembered on a visitor's device (shuffle, repeat, Light mode and where they left off) stay in `localStorage` and never leave it. If you want listening stats later, use a cookieless analytics tool.
- **Secrets** (the R2 keys) live only in `.env.local`.
- **Anything a browser can play, a visitor can save.** The custom player has no download button, but the audio URLs are public. Real protection would need DRM, which is out of scope. Only publish music you have the rights to and are comfortable with people downloading.
- **Hotlinking.** Other sites could embed your audio URLs. If that ever matters, a Cloudflare WAF rule can block requests from other sites. It's a deterrent, not real protection.
- **A private site.** To keep the site to yourself or friends, put both the site and the media domain behind Cloudflare Access, which is free for small groups. Cloudflare handles the login, so the app needs no authentication code.
- **Fonts and their licenses.**
  - **Amelie** (by Graphix Line Studio, from a Creative Fabrica subscription) can be used to make the wordmark image. Its license doesn't allow embedding the font file in a website (that needs Creative Fabrica's Enterprise license) or sharing the file, and designs made with it can't be registered as a trademark. The copy you sent (`amelie.zip`) comes with a Read Me saying the file is for personal use only, with a link to Creative Fabrica for the commercial license. Your subscription is that license if the file came from your Creative Fabrica account. If it came from somewhere else, download it again from Creative Fabrica before the site goes public.
  - **Century Gothic** is a Monotype font, and serving it to visitors needs a Monotype web license. Without one, the site names it first, so visitors who have it installed see it, and serves the free Didact Gothic to everyone else.
  - **Didact Gothic** is free under the SIL Open Font License, so it can be self-hosted.
  - Keep font files out of any public repository.
- **The background photo.** Only use a photo you have the rights to. The angel photo is 736 pixels wide, the size Pinterest serves its images at, so if it came from there, find who took it and ask their permission, or swap in a photo of your own. It is already public: it is in the repository and on the site. The same goes for the covers: `download (11).jpg`, for one, is 736 pixels square, the same Pinterest size.
- **Brand icons.** The SoundCloud and Instagram icons come from Simple Icons, whose artwork is free to use (CC0). The logos remain their owners' trademarks, which is fine for linking to your own profiles. guns.lol publishes no vector logo, so its icon is traced from the one on guns.lol.

## 13. Roadmap

Each milestone ends with something that works.

**Done: the design prototype** (November 2026)

- [x] The whole interface from [section 6](#6-the-interface) as a single page in `prototype/`, with the real covers and each song's measured loudness and bass, published privately for review.
- [x] Real playback in the prototype, built to the engine plan in [section 5](#5-the-player-engine).

**Waiting on you**

- [x] The Amelie font file. The wordmark is made (`site_art/wordmark.svg`).
- [ ] Check that the Amelie file came from your Creative Fabrica account. Its Read Me says personal use only otherwise ([section 12](#12-security-rights-and-privacy)).
- [x] The addresses for SoundCloud, guns.lol and Instagram.
- [x] A corrected `who's that over there.mp3`, now replaced by `Who's that out there! (prod.wixxy).mp3`.
- [x] Whether `scream.mp3` goes on the site: it does.
- [ ] Try the published prototype on your phone: play a song, lock the screen, and check that the next song starts on its own and the lock-screen controls work.
- [ ] Higher-quality exports of `Interest (prod kuga).mp3` and `Who's that out there! (prod.wixxy).mp3`, if you have them. Both are 128 kbps, half the bitrate of the other songs (256 kbps).
- [ ] A larger copy of the angel photo, if you have one. The current one is 736 × 414 pixels, so it looks soft stretched across a big screen. 1920 pixels or more across would sharpen it.
- [ ] Who took the angel photo, and their permission to use it ([section 12](#12-security-rights-and-privacy)).

**M0: Foundations**

- [ ] Vite + TypeScript (strict) project with ESLint, Prettier and Vitest.
- [x] `.gitignore` with `node_modules/`, `dist/` (which covers `prototype/dist/`), `public/media/`, `.env*.local`, `.idea/` and any `.otf` or `.ttf` font files. The songs and covers are committed ([4.1](#41-source-folders)).
- [ ] Folder structure from [section 9](#9-tech-stack-and-project-layout), and the test fixtures.
- *Done when* `npm run dev` serves a page and `npm test` runs.

**M1: Content pipeline**

- [ ] `scripts/build-catalog.ts`: scanning, metadata, the quality policy, duplicate detection, loudness files, covers and their colours, fingerprints, `catalog.json`, the summary and cleanup.
- [ ] Shared `Track`, `Cover` and `Catalog` types.
- [ ] Run it on the real `sai_songs/` and `song_covers/` and fix whatever it reports.
- *Done when* one command turns both folders into `public/` with clear errors and warnings, and a re-run with no changes finishes in seconds.

**M2: Player engine**

- [ ] `engine.ts`, `queue.ts`, the store and persistence, driven from a bare debug page. The prototype's engine in `player.tpl` is a working reference.
- *Done when* play, pause, seek, next, previous, shuffle and repeat all work, the queue tests pass, and state survives a reload.

**M3: Interface**

- [ ] Port the prototype into the app: the header and footer, the cover and the song wheel, the playback area with the waveform, the pulse and animations, the sky with the skeleton art, and Light mode, with design tokens and fonts.
- [ ] Copy the wordmark SVGs from `site_art/` into `public/`. They're made from the Amelie font by `prototype/make-wordmark.mjs`.
- [ ] Draw the waveform and the pulse from the loudness files, and deal covers and artist credits from the catalog.
- *Done when* it matches the prototype on a phone and a desktop, and someone who's never seen it can play a song without help.

**M4: Platform and polish**

- [ ] Media Session, buffering and error states, accessibility and performance passes (including the background shader on a mid-range phone), end-to-end tests and the device checklist.
- *Done when* the targets in [section 7](#7-accessibility-and-performance) are met and the device checklist passes.

**M5: Launch**

- [ ] The signedheaven.art domain (added to Cloudflare; switch its nameservers at Namecheap if you haven't yet), a Pages project, an R2 bucket with a custom domain, `scripts/publish-media.ts`, `_headers`, the page title and description, a favicon, a link-preview image, and CI.
- [ ] The `curl` range check passes.
- *Done when* the site is live on your domain and adding a song takes under five minutes from start to finish.

**v1 is finished when:**

- Adding a song means copying one file and running a couple of commands.
- A 320 kbps MP3 reaches the listener byte-for-byte identical to the file in `sai_songs/`.
- Seeking anywhere in a song is near-instant.
- It works in current Chrome, Edge, Firefox and Safari, and on iOS and Android, including lock-screen controls and auto-advance with the screen off.
- It's fully usable with only a keyboard, and with a screen reader.

## 14. Parked ideas

These aren't in v1, but the design leaves room for them:

- The click wheel from the first design, as another way to move through the songs
- Sky colours taken from each cover, instead of the six fixed palettes
- A shareable link for each song (`/#a-spin`)
- Search and filtering, which becomes worthwhile past about 50 songs
- Albums and EPs as groups
- A 3D view for flicking through covers
- Lyrics
- An installable app with offline listening (PWA)
- A live visualiser drawn from the audio itself (Web Audio, plus CORS on the media host)
- A lower-bitrate version of each song for mobile data
- A browser upload page: a small serverless function that writes to R2 and rebuilds the catalog
- Download buttons
- Cookieless listening stats

## Appendix

### A. File size and bandwidth

| Bitrate | Per minute | 4-minute song | 1 hour |
|---|---|---|---|
| 128 kbps | 0.96 MB | 3.8 MB | 58 MB |
| 256 kbps | 1.92 MB | 7.7 MB | 115 MB |
| 320 kbps | 2.4 MB | 9.6 MB | 144 MB |

Here 1 MB = 1,000,000 bytes. Streaming at 320 kbps needs a steady 0.32 Mbit/s, which an ordinary mobile connection handles easily.

### B. ffmpeg one-liners

ffmpeg is only needed for lossless masters or for fixing a file. Get it from [ffmpeg.org](https://ffmpeg.org/download.html) or through the `ffmpeg-static` npm package.

```powershell
# Lossless master (WAV, FLAC, AIFF) to MP3 at 320 kbps CBR, 44.1 kHz
ffmpeg -i "master.wav" -c:a libmp3lame -b:a 320k -ar 44100 -id3v2_version 3 "song.mp3"

# Remove a cover image embedded in an MP3 without re-encoding the audio
ffmpeg -i "in.mp3" -map 0:a -c:a copy "out.mp3"

# Show a file's codec, sample rate, bitrate and duration
ffprobe -v error -show_entries "format=bit_rate,duration:stream=codec_name,sample_rate" -of "default=nw=1" "song.mp3"
```

### C. References

- [Cloudflare Pages limits](https://developers.cloudflare.com/pages/platform/limits/)
- [Cloudflare R2 documentation](https://developers.cloudflare.com/r2/)
- [Cloudflare: range requests and the cache](https://developers.cloudflare.com/cache/reference/range-requests/)
- [MDN: HTTP range requests](https://developer.mozilla.org/en-US/docs/Web/HTTP/Range_requests)
- [MDN: HTMLMediaElement](https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement)
- [MDN: Media Session API](https://developer.mozilla.org/en-US/docs/Web/API/Media_Session_API)
- [music-metadata](https://github.com/Borewit/music-metadata)
- [sharp](https://sharp.pixelplumbing.com/)
- [Vite](https://vite.dev/)
- [Simple Icons](https://simpleicons.org/), the source of the SoundCloud and Instagram icons
- [Creative Fabrica subscription license](https://www.creativefabrica.com/subscription-license/), which covers the Amelie font
- [Didact Gothic](https://fonts.google.com/specimen/Didact+Gothic), the free stand-in for Century Gothic
- [WCAG 2.2: Pause, Stop, Hide](https://www.w3.org/WAI/WCAG22/Understanding/pause-stop-hide.html), the guideline on pausing moving content ([section 7](#7-accessibility-and-performance))
- [Animate UI](https://animate-ui.com/), the inspiration for the player's animations

---

vibecoded for wifey
