# Flaming Zombooka 3 — TypeScript port (fz3-web)

A faithful, all-TypeScript web port of **Flaming Zombooka 3** (Long Animals Games, 2011, AS3/Flash),
built with the game's author. The original is a **physics puzzle game**, so the overriding goal is
**100% bit-faithful physics** — see [`CLAUDE.md`](CLAUDE.md) for the prime directive and architecture.

## Architecture (no Haxe, no shim — pure TS)

| Layer | What | Where |
|---|---|---|
| **Physics** | Bit-exact line-by-line port of **Box2DFlash 2.0.2** (the original's own engine), verified against the shipped bytecode via a golden-trace oracle (FFDec → Ruffle → hex16) | `src/box2d/**` |
| **Game** | Faithful port of the game framework + level/object data loaders | `src/game/**`, `data/` |
| **Rendering** | OpenFL (npm, pure-TS) display-list — renders the original SWF's symbols directly | `src/render/**` |

The simulation owns the clock (fixed `2×(1/60)` step); the renderer only draws a per-frame snapshot.

## Develop

```bash
npm ci
npm run dev      # asset prebuild (openfljs) + Vite dev server
npm test         # vitest — engine goldens + game loaders, all bit-exact / faithful
npm run build:web
```

`npm run assets` regenerates the OpenFL AssetLibrary from `flaming-zombooka-3.swf` into
`public/assets/fz3/` (gitignored). The JPEXS FFDec decompiler (`tools/ffdec/`) and FFDec media exports
(`extracted/{shapes,sounds,images,…}`) are gitignored as regenerable; the decompiled `.as` reference and
level XML (`extracted/scripts/`, `extracted/binaryData/`) are kept.

## Status

Work in progress. Engine bit-exact through narrowphase (m3); game loaders complete; render layer drawing
real levels. **Not yet playable end-to-end** — the GitHub Pages build is a development preview.

---
*Ported with the original author. Repo contains the original SWF + decompiled reference under that
arrangement.*
