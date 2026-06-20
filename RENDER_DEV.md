# Rendering / OpenFL Developer — brief & contract

You own **how FZ3 looks**: the OpenFL-npm integration, the SWF asset pipeline, the build tooling, and
the `flash.display`-facing port of the game's display layer. You render from a per-frame game-state
snapshot the game developer hands you; you never touch the physics or the game loop. You communicate
with the game dev bidirectionally via the shared **`DEVELOPER_MESSAGES.md`** (address notes
`To: game` / `From: render`; you can ignore notes addressed to `engine`).

## Read first
- **`CLAUDE.md` → "The rendering decision"** — the leading architecture (OpenFL npm, pure TS) and the
  three open integration items. Also skim the Prime Directive so you understand the project's bar.
- **`questions_for_sb2_developer.md` → Q2** (rendering) and **Q8** (asset pipeline) — the SB2 dev's
  account of why an atlas blitter stalled and why rendering the SWF display list directly is the win.

## The key mental model: rendering is NOT bound by the Prime Directive
Puzzle correctness lives entirely in the game dev's **bit-exact physics**. The renderer only **reads
game state and draws.** So you are judged on **visual fidelity + dev velocity**, not bit-determinism.
Two hard rules anyway:
1. **Never drive the simulation.** The game dev owns the fixed 2×(1/60) step loop. OpenFL's
   `ENTER_FRAME` / `Stage` timing must **not** advance physics or game logic — you receive a state
   snapshot and render it. If you need a render tick, it reads state; it never mutates it.
2. **Determinism stays the game dev's.** No game state lives in your layer.

## How FZ3 actually renders (what you're mapping onto OpenFL)
The framework's display primitive (`DisplayObj.as`) blits a **frame of a display object** onto a target
`BitmapData` through a `Matrix` + `ColorTransform`:
```
DisplayObj.RenderAtRotScaled_Vector(frame:int, bd:BitmapData, x, y, scale, rot, ct:ColorTransform, _, xflip:Boolean)
```
- A `DisplayObj` wraps an original library symbol (`origMC:MovieClip`) and exposes `frames`, `frame`,
  `labels`, `name`. Symbols are looked up via `GraphicObjects.GetDisplayObjByIndex(...)`.
- Objects are drawn in **`zpos` z-order**; transform is position + `dir` (rotation, radians, via
  `Matrix.rotate(dir)`) + `scale` + `xflip`; recolour/alpha via `ColorTransform`.
- A `Camera` (`x`, `y`, `scale`, + shake offsets `shakeCamX/Y`) transforms world→screen onto the fixed
  **700×500** stage (letterbox into the window).

You have two faithful ways to realise this on OpenFL — **recommend one in your spike report**:
- **(A) Display-list** — instantiate OpenFL `Sprite`/`MovieClip` from the loaded SWF `AssetLibrary`,
  set `.x/.y/.rotation/.scaleX(±)/.transform.colorTransform/.gotoAndStop(frame)`, add under a camera
  container, let OpenFL composite (GPU). Most idiomatic; gets timelines/vector/filters for free.
- **(B) Blit-faithful** — mirror the framework: `BitmapData.draw(symbol, matrix, colorTransform)` into a
  stage bitmap each frame. Closest to the original's exact compositing if (A) ever diverges visually.

## The render-state contract (what `game` hands you each frame — provisional)
The game dev owns this and will publish the final TS interface (derived from `DisplayObj.as` /
`GameObj.as`). Provisional shape so you can start:
```ts
interface RenderObj {
  dobj: number | string;   // display-object identity (GraphicObjects index / symbol name)
  frame: number;           // current timeline frame (1-based, as in the SWF)
  x: number; y: number;    // world position (px)
  dir: number;             // rotation (radians)
  scale: number;           // uniform scale
  xflip: boolean;          // horizontal flip
  z: number;               // zpos — draw order (sort ascending/descending per spec)
  alpha: number;           // 0..1
  tint?: ColorTransformLike; // optional recolour (offsets + multipliers)
  visible: boolean;
}
interface RenderFrame {
  objects: RenderObj[];                       // already in a stable order; you z-sort by `z`
  camera: { x: number; y: number; scale: number };
  // UI/overlay layer handled separately (see below)
}
```
You consume `RenderFrame` and draw. Field names/units get frozen with the game dev before you build the
full layer — raise mismatches in `DEVELOPER_MESSAGES.md`.

## Scope (yours)
- OpenFL-npm setup: `openfl` (9.5.x) as a TS dependency; `swf-loader` (or a Vite-prebuild equivalent)
  turning `flaming-zombooka-3.swf` into an `AssetLibrary`; bundler config (Webpack vs. Vite — your call,
  justify it).
- The display port: `DisplayObj`, `GraphicObjects`, and the `GameObj` draw paths → TS against OpenFL's
  `flash.display`. These target the same API the AS3 used, so port near-mechanically.
- Fonts (19), bitmap/vector text, `ColorTransform` recolour (cache one offscreen per (frame,colour) —
  brutal if recomputed every frame), morphshapes (2 — "where possible" via `swf-loader`; special-case
  if needed), the camera transform + letterboxing, UI/overlay screens.

## Non-goals (not yours)
- No physics, no game logic, no level/state code, no fixed-step loop. If a render need seems to require
  touching game state, it's a contract gap — raise it with `game`, don't reach into the sim.

## First deliverable: the OpenFL spike (timebox ~½ day — do this before building anything)
1. `npm install openfl`; minimal TS project + bundler.
2. Run `swf-loader` on `flaming-zombooka-3.swf`; load the `AssetLibrary`.
3. Render in TS: (a) one **static symbol**, (b) a **MovieClip timeline** playing, (c) a **ColorTransform**
   recolour. Confirm the **19 fonts** and **2 morphshapes** load.
4. Report in `DEVELOPER_MESSAGES.md` (`To: game`): what loaded clean vs. needs special-casing; approach
   **(A) display-list vs. (B) blit-faithful**; **Webpack vs. Vite**; any blockers. If the symbol library
   comes through, the all-TS architecture is locked end-to-end.

## Comms protocol
- Shared **`DEVELOPER_MESSAGES.md`**, `To: game` / `From: render`, newest on top, signed + dated. Raise:
  contract mismatches, anything you need from the game side (state fields, draw order, camera math), and
  the spike report. Where a visual detail is ambiguous, match the original SWF running under Ruffle.
