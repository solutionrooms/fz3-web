# FZ3 — Flaming Zombooka 3 → TypeScript port

## ⛔ THE PRIME DIRECTIVE: 100% bit-faithful physics, or it is a failure

**This port must reproduce the original game's physics *exactly* — bit-for-bit. 99.9% is a
total failure, not "almost there."** Read this section before doing anything in this repo.

### Why "almost" is worthless here

FZ3 is a **physics puzzle game**, which means the simulation is **chaotic**: it has sensitive
dependence on initial conditions. A difference in the **last bit of a single floating-point number**
compounds over a few seconds of collisions and bouncing into a *completely different outcome*.

So a port that is "99.9% accurate" does **not** mean "99.9% of levels work." It means:

- A **random, invisible subset of levels silently break** — a shot that should solve a puzzle now
  misses, or a stack that should fall now stands.
- The breakage is **undetectable by inspection**. The only way to find it is to **play every level**,
  which is enormously time-consuming.
- Because all levels share **one physics engine**, "fixing" the engine to rescue one broken level
  **perturbs the math and breaks a different, previously-working level.** This is whack-a-mole that
  **never converges.**

Therefore approximate-and-playtest-and-patch is a **trap**, not a strategy. The only viable path is to
make divergence **impossible**, then prove it mechanically.

### The rules that follow from this (inviolable)

1. **Bit-exact is the engine's spec.** The bar is `hex16(ours) === hex16(original)` for every body's
   `(x, y, angle, vx, vy, ω)` on **every** simulation step. Tolerance comparisons (`abs(a-b) < ε`) are
   **banned** as the primary correctness gate — they hide exactly the drift that kills us. Two bars,
   deliberately (per SB2 experience):
   - **Engine (the physics math): bit-exact.** Everything that *can* be exact — which is almost
     everything — is gated `hex16`. The **only** physical exception is the trig ceiling (rule 5),
     handled by a strict escalation, never by a blanket loosening.
   - **Game (levels): behavioural** — every level's intended solution works, nothing feels off. But a
     behavioural failure is a **signal to go find the bit-level engine divergence**, never a licence to
     relax a tolerance. You do not bit-match a 60-second multi-bounce playthrough; you bit-match the
     *engine* so the playthrough is correct by construction.

2. **Never tune physics to fix a level.** If a level behaves wrong, the **port has a bug versus the
   original** — fix the port to match the original bit-for-bit. **Never** change a physics constant,
   reorder math, or nudge a behavior to make a symptom go away. Tuning *is* the whack-a-mole trap.
   Every divergence is a porting bug with a single correct answer (what the original did), not a
   balancing decision.

3. **Preserve operation order exactly.** AS3 `Number` and JS `number` are both IEEE-754 doubles, so a
   *faithful* port is bit-identical **by construction** — but only if you preserve parenthesization,
   temporaries, and evaluation order. **Do not "simplify" arithmetic.** `a*b + a*c` is not `a*(b+c)`.
   Cite the AS3 source file + line range in a comment above every ported function.

4. **The oracle is the single source of truth.** Ground truth = **the original SWF running under
   Ruffle** (it executes the *shipped 2011 bytecode*, so an engine-version mismatch is impossible).
   When in doubt about *any* behavior, capture what the original does and match it. Never guess, never
   "improve."

5. **The trig ceiling — solve by escalation, never wave away.** Box2D rebuilds a rotation matrix from
   native `Math.sin/cos` every step for every rotating body (`b2Mat22.Set(angle)`), and the TOI sweep
   (`b2Sweep`) rebuilds it again at the sub-step. `+ − × ÷ √` are IEEE-754 round-to-nearest → V8,
   Ruffle and Adobe all agree to the bit (this is why ~everything reproduces exactly). The **only**
   primitive that can differ is `sin/cos` (≤1 ULP). A 1-ULP `sin/cos` error **only matters when the
   rotation angle feeds an *offset* back into the solve** (off-centre COM, a contact/joint anchor away
   from the origin, a tumble-to-edge settle, a grazing-corner near-tangent contact). A centred
   single-fixture body is trig-immune (verified on SB2: a spinning wheel stayed bit-exact 150 steps).
   Escalation, in order — do the cheap thing first:
   1. **Measure.** Capture goldens for *our actual* missile shots early; ballistic shots usually stay
      bit-exact far longer than feared.
   2. Keep **bit-exact** wherever achievable (the common case).
   3. Where trig genuinely feeds back, gate **exact-prefix + bounded tolerance**, and say so in the
      test header. **Never label a tolerance gate "exact."**
   4. **Only if a real level outcome actually flips on trig**, implement a TS `sin/cos` that matches
      the oracle's libm bit-for-bit. SB2 never needed step 4; FZ3's TOI is more exposed, so it stays on
      the table.

6. **Build the oracle/golden-trace harness FIRST** — golden #1 (one freefalling `b2Body`, `hex16`) is
   literally commit #1, before a line of game code. Mechanical bit-comparison is the *only* tool that
   catches divergence before playtesting does, and the only thing that proves a fix is non-regressive.
   No engine unit is "done" until its hex16 gate is green. Grow the engine **milestone-gated**:
   freefall → integration → collision → solver → sleeping → joints → CCD/TOI; each lands with its
   golden; don't move on until the gate passes.

7. **No Haxe. No shim. Pure TypeScript, engine called natively.** The all-TS route deletes an entire
   bug class (see "Lessons from SoccerBalls2"). The one subsystem it does *not* give you free is
   **rendering** — decide that strategy explicitly and early (see "The rendering decision").

---

## What this project is

Port **Flaming Zombooka 3** (Long Animals Games, 2011, AS3/Flash) to a maintainable, faithful
**TypeScript** web build. The original SWF has been decompiled into `extracted/` (see `ANALYSIS.md`).

- **Physics engine: Box2DFlash 2.0.2** — the AS3 port of Box2D 2.0.x. Full source is in the SWF:
  74 `.as` files, ~11,350 LOC under `extracted/scripts/Box2D/`. **We port THIS source line-by-line** —
  never a different/newer Box2D, never box2d-wasm, never planck.js. Version match is load-bearing.
- **Game framework** is (near-certainly) the same one SoccerBalls2 used, one revision earlier:
  `GameObj` (5190 LOC), `GameObj_Base` (2825), `Game` (2798), `PhysObj`, `DisplayObj`, `GameObjects`,
  `Levels`, `Particle`, `Triangulate`, `KeyReader`, `SoundPlayer`, `MusicPlayer`, `ExternalData`,
  `Collision`, `GraphicObjects`. ~527 game `.as` files, ~29,300 LOC.
- **Document class: `Preloader`** (confirmed) — this is the `-replace` injection target for harnesses.
- **Stage** 700×500, **30 fps** display. **Physics steps TWICE per render frame**, back-to-back, only
  when not transitioning:
  ```
  Game.as:1791  if (UI.isInTransition == false) {
  Game.as:1793     PhysicsBase.world.Step(physStep = 1/60, physNumIterations = 5)   // step 1
  Game.as:1794     PhysicsBase.world.Step(physStep = 1/60, physNumIterations = 5)   // step 2
              }
  ```
  i.e. **60 Hz physics = 2×(1/60) substeps per 30 fps `ENTER_FRAME`** (`Main.as:116`). This is NOT one
  `1/30` step and NOT a variable loop. Reproduce the cadence, the count, the `isInTransition` gate, and
  the order {game pre-update → 2× step → write-back → game logic} **exactly** — a doubled or mis-ordered
  step desyncs everything downstream.
- World: gravity 300 px/s², scale 50 px = 1 m, allowSleep on, world AABB ±2500. Joints: revolute,
  prismatic, pulley, distance, mouse. **Bullet/TOI continuous collision** is used (fast missiles).
- **Levels + materials** are XML blobs in `extracted/binaryData/` (41 campaign levels + 3 bonus modes).

## Target architecture (all TypeScript)

```
Physics engine   Box2DFlash 2.0.2 ported → TS, faithful & native. Pure-math module, ZERO game/render/Flash deps.
Engine wrapper   PhysicsBase / PhysObj / Collision / ContactListener (game's own Box2D wrapper)
Game framework   GameObj / Levels / Particle / level-loader / DisplayObj model (lift SB2 TS logic skeleton; re-bind to Box2D)
Rendering        DECIDED: OpenFL npm (pure TS, approach A display-list) + Vite + openfljs-process prebuild. Spike passed.
Data / assets    XML levels + materials from binaryData/; FFDec + audio flow reused; per-schema parsers re-written for Box2D material model
Verification     Golden-trace oracle: FFDec -replace harness → Ruffle headless → hex16 bit-compare in vitest
```
**The fixed point:** the game adapts to the engine, never the reverse. The engine ships as a
self-contained module and never bends to make a level pass.

## The rendering decision — DECIDED: OpenFL npm (pure TS), spike passed ✅

**Rendering is NOT bound by the Prime Directive** — it's visual, not physics. Puzzle correctness lives
entirely in the bit-exact Box2D port; the renderer only reads game state and draws. So the renderer is
chosen for visual fidelity + dev velocity, not bit-determinism. **Our fixed 2×(1/60) step loop stays
authoritative;** OpenFL renders from state — OpenFL's `ENTER_FRAME` timing never drives the sim.

**Spike result (render dev, 2026-06-20 — see `DEVELOPER_MESSAGES.md` + `spike/`):** confirmed on the real
FZ3.swf, pure TS, no Haxe. Decisions now locked:
- **`openfl` 9.5.2 npm package**, approach **(A) display-list** (instantiate library MovieClips; set
  `.x/.y/.rotation/.scaleX(±)/.transform.colorTransform/.gotoAndStop(frame+1)`; OpenFL composites).
- **Build: Vite + an `openfljs process <swf> <out>` prebuild** (that CLI ships inside the openfl npm
  package; **drop `swf-loader`**, which was just a Webpack wrapper around it). `AssetLibrary.loadFromFile`
  loads the generated library at runtime under any bundler.
- **`dobj` = the SWF linkage/class name** = the `clip` field in `data/physobjs.json` **verbatim**
  (134/134 exact, case-sensitive). Render calls `library.getMovieClip(clip)`.
- Symbol counts cross-validated vs `ANALYSIS.md` (1119 shapes, 44 images, 93 text, 966 sprites…);
  frame-label timelines (e.g. `Civilian` → `[idle,idle_end,walk,walk_end]`) come through — the exact
  capability that stalled SB2's atlas blitter works for free.
- **Special-cases (non-blocking):** 2 morphshapes drop (decorative — special-case to static if either
  animates); fonts aren't standalone `getFont()`-addressable (render owns the text path); **audio mapping
  is the GAME dev's** (SoundPlayer/MusicPlayer + `extracted/sounds/`; strip SOUND from the render library).
- **Render-state contract honoured with 3 refinements:** emit `colorTransform` ONLY where the original
  uses the bitmap/CT path (the vector path ignores tint — game dev sets this per object); spot-check
  symbol registration vs the framework's `getRect` offsets at the first real level; render drives frames
  via `gotoAndStop(frame+1)` only, never `play()` (determinism guard).

**Finding (corrects the SB2 dev's "no pure-TS OpenFL", which was out of date):** OpenFL ships a real,
current **npm package** — `openfl` **9.5.2** (published 2026-05-13; the *same major version SB2 shipped
its proven-faithful render on*). It is OpenFL precompiled from Haxe to JS modules **with TypeScript
type definitions**, consumed as a normal TS dependency — **no Haxe toolchain needed to use it**; works
with Webpack/Vite. The companion **`swf-loader`** (Webpack) converts a `.swf` into an OpenFL
`AssetLibrary` preserving **Shapes, MovieClips (timelines), buttons, masks, filters, blend modes**, and
can load the **entire SWF timeline**.

Why this is the leading path (and better than hand-rolling or going Haxe):
- It hands us the exact advantage that made SB2's Haxe route win — **render the SWF display list
  directly** (timelines, vector `Graphics`, `ColorTransform`, fonts) — but in **pure TS, no Haxe, no
  shim.** That is Jon's stated wish, now achievable for rendering too.
- FZ3's AS3 display code (`DisplayObj`, `GraphicObjects`, `GameObj` draw paths) targets `flash.display`;
  OpenFL's TS API *mirrors* `flash.display`, so that code becomes a **near-mechanical line-for-line
  port** — no reverse-engineering animation from frame-label dumps (the work that stalled SB2's
  atlas-blitter TS attempt).
- Same OpenFL major SB2 proved visually faithful; actively maintained (61 npm releases, latest 2026-05).

**The clean target architecture this enables:** physics = our bit-exact TS Box2D (our loop owns
determinism); display + assets = OpenFL npm (load FZ3.swf symbol library, draw from state); game
framework = AS3→TS against Box2D + flash.display/OpenFL — **both target the same APIs the original
used**, so the port is faithful and mechanical throughout. No Haxe, no shim, all TS.

**Open integration items — settle with a timeboxed spike (~½ day) before committing:**
1. `swf-loader` is a **Webpack** loader; SB2 tooling leaned Vite. Adopt Webpack (OpenFL templates
   default to it) or run the SWF→AssetLibrary step as a Vite pre-build/plugin. Minor–moderate.
2. Confirm `swf-loader` fully ingests **flaming-zombooka-3.swf**'s symbols — MovieClip timelines, the
   19 fonts, and the **2 morphshapes** ("where possible" caveat; trivially special-cased if not).
3. AS3→TS-against-OpenFL is mechanical but not literal copy-paste (Event constants, `Vector`→`Array`,
   getter/setter conventions, property access). Easy, but budget for it.

**Spike to run:** `npm install openfl`, run `swf-loader` on FZ3.swf, load the `AssetLibrary`, render one
static symbol + one MovieClip timeline + a `ColorTransform` recolour in TS. If the symbol library comes
through, this becomes the decided architecture and the all-TS plan is complete end-to-end.

## The four places faithfulness actually lives

Port these line-by-line and write a dedicated golden for each — per both SB2 sessions, this is where
faithfulness is won or lost:

1. **CCD / TOI re-solve order** — *the hardest part; budget the most time.* FZ3's bullet missiles hit
   it constantly. Port `b2TimeOfImpact` (two `b2Sweep`s) + `b2World::SolveTOI` + the sub-step solve
   verbatim. Two specific traps SB2 hit (they map straight onto Box2D):
   - **Lost-bounce on a seam:** the TOI re-solve must be scoped to **only the swept pair** — it must
     NOT run a global prestep that claws back already-warm-started impulses on resolved contacts.
   - **Kinematic-vs-resting stick:** never shortcut "the obstacle is static." `b2TimeOfImpact` advances
     **both** sweeps; a separating pair must yield `toi < 0` and be left alone.
   - This compounds with `b2_velocityThreshold` (below) — a re-solved bounce off an already-separated
     relative velocity gets clamped to 0 and the bounce vanishes. Test low-speed bounces *through* TOI.
2. **`b2Settings` constants & the 2.0.x iteration model.** Copy every constant verbatim:
   `b2_velocityThreshold` (restitution is *killed* below it — "why won't my slow ball bounce"),
   `b2_contactBaumgarte`, `b2_linearSlop`, `b2_maxLinearCorrection`, `b2_timeToSleep`,
   `b2_linearSleepTolerance`, `b2_angularSleepTolerance`. **Box2D 2.0.x ≠ modern Box2D:** 2.0 runs
   velocity iterations with Baumgarte/position-correction **inline**, not the separate position-
   iteration loop of 2.1+. **Trust the `.as`, never memory of modern Box2D.**
3. **`b2Body::ShouldCollide` / `collideConnected`.** A tiny method that walks the joint-edge list and
   returns `false` for a pair connected by a non-colliding joint. Easy to skip; if you do, jointed
   bodies that **fully overlap** (chassis fixture inside its wheel) get a deep-penetration internal
   contact that pins the assembly — it reads as "the contraption won't move from rest" (a fake
   sleep/friction bug). Golden up front: two overlapping jointed bodies must move freely.
4. **Sleep / wake (`m_sleepTime`).** The #1 source of "works in isolation, fails in the game" bugs —
   all surface only after a body has been still ~1s. In Box2D **2.0.x several velocity setters do NOT
   call `WakeUp()`** — that's the trap. Audit by grepping **every** mutator
   (`SetLinearVelocity`/`SetAngularVelocity`/`ApplyImpulse`/`ApplyForce`/`SetTransform`) and confirm
   each wakes + resets `m_sleepTime`; confirm `DestroyBody`/contact destruction wakes the partner
   (else a body sleeping on a removed support stays **frozen mid-air**). A sub-threshold "keep-awake
   nudge" only works if the setter resets `m_sleepTime` **unconditionally** (not just "wake if asleep").

## Verification: the golden-trace oracle (build this first)

Lift SB2's rig wholesale — the capture infra is engine-agnostic. Loop (ran ~20× on SB2):
1. Write `harness-X.as`, **document class `Preloader`**, build a deterministic scene (no `Math.random`,
   fixed everything), `trace("[TAG] " + i + " " + bits(v))` each step, end with `trace("[TAG] DONE")`.
   `bits(n)` = `ByteArray.writeDouble(n)` → two `readUnsignedInt()` → `"hi:lo"` hex. **Never trace
   decimals** — raw IEEE-754 bits are the whole point (a 1-ULP error is invisible to `toBeCloseTo`).
2. `java -jar tools/ffdec/ffdec.jar -replace <copy-of-FZ3.swf> <out.swf> Preloader harness-X.as`
   (arg order is sensitive: `<in> <out> <DocClass> <file.as>`). Inject into a **copy of the real FZ3
   SWF** so the harness links the *shipped* 2011 Box2D bytes.
3. `node capture-lines.mjs <out.swf> <golden.json> DONE` (puppeteer + headless Chrome + unpkg Ruffle;
   Ruffle `trace`→`console.log`, so `logLevel:"info"` + scrape stdout).
4. vitest gate: `expect(hex16(got)).toBe(norm(golden))`.

Per-step fields to trace for Box2D: `GetPosition().x/.y`, `GetAngle()`, `GetLinearVelocity().x/.y`,
`GetAngularVelocity()` — **and for TOI shots also dump the `b2Sweep` (`c, a, c0, a0`)**, because that's
where the sub-step `sin/cos` lives and where the fastest shots diverge first.

Two harness modes (both portable): **standalone-scene** (build a fresh Box2D scene — best for engine
units) and **patched-game trace** (instrument FZ3's per-step + contact callbacks to dump the real
ball/level state for `[ORIG]`-vs-`[PORT]` level verification).

**Non-negotiable capture rule: run long enough for a body to actually SLEEP.** On SB2 a stack-settle
golden was bit-exact through step 66 and diverged at step 67 — the frame `allowSleep` zeroed a ~1e-15
residual. A 60-step capture would have shipped a sleep bug. **Run 150–250 steps with a real settle**
(`b2_timeToSleep` = 0.5 s = 30 rest-steps, so ≥ ~40 + settle-in before "it sleeps" is trustworthy).

Toolchain notes: macOS has **no `timeout`**; ffdec needs a real JDK (have Temurin 21). Optional: if an
Adobe projector can be stood up, spot-check the 3–4 most rotation-sensitive missile shots against BOTH
Ruffle and Adobe to confirm the residual `sin/cos` delta tips nothing. Don't build the rig around Adobe
— headless/reproducible Ruffle is worth more than the trig delta.

## Other faithfulness hazards

- **Triangulation must be byte-identical.** `Triangulate.as` fan-triangulates concave terrain into
  tris for the engine. A different fan origin or vertex order = different shapes = different collisions;
  a degenerate (collinear) tri gave SB2 a NaN that blanked a whole level (NaN body → NaN camera →
  world off-screen). Port it exactly; guard degenerate tris.
- **Determinism hygiene:** fixed timestep only, never variable `dt`; no wall-clock / RNG in the sim;
  one fixed entry order for {pre-update, 2× step, write-back, logic}. Any non-determinism makes goldens
  worthless and you won't know which change broke faithfulness.
- **ColorTransform tinting:** recolour is a per-pixel offset over white overlay art; on Canvas cache one
  offscreen per (frame, colour). Cheap cached, brutal if recomputed per frame.

## Lessons from SoccerBalls2 — what we keep vs. change (`/Users/jonscott/Projects/SoccerBalls2`)

SB2 is the same team's previous port of (almost certainly) this framework, with **Nape**. Their two
Claude sessions (game/framework dev + nape-replica engine dev) answered our questions in
`questions_for_sb2_developer.md` — read it; it's the single richest source we have.

- **KEEP:** the hand-ported bit-exact engine validated against Ruffle goldens *before* wiring to the
  game; the `PORTING.md` discipline (cite AS3 lines, preserve op order, registry mapping AS3
  `initfunction` → TS init with SAME state numbers/timers/constants); the FFDec/oracle/audio tooling;
  the TS **game-logic** skeleton.
- **REUSE MAP (their honest assessment):**
  - **Reuse as skeleton:** `src/game/gameobj.ts`, `level-loader.ts`, `behaviors/`, the
    `GameObj`/`GameContext` shape, the fixed-60Hz `updateFn/renderFn/onHitFn` model, `param/paramNum`,
    anim helpers, `rig.ts`, `terrain.ts`. **But rip out the planck binding and bind to our Box2D port.**
  - **Reuse the FLOW, rewrite the SCHEMAS (~1–2 days):** FFDec extraction + audio convert as-is;
    `extract-atlas/objects/levels/misc.ts` re-written for FZ3's element names and **Box2D material
    model** (density/friction/restitution/filter bits/isSensor + body type/bullet — not Nape's
    material/fluid). Keep the JSON-module output shape the loaders consume.
  - **Treat as fresh:** physics (Box2D ≠ Nape) and rendering (their TS render was an atlas blitter,
    never a `flash.display` shim; physics + render were the two subsystems never finished before the
    Haxe pivot).
- **CHANGE — go pure TS, drop Haxe + the shim.** SB2's shim caused 4 bug classes; **3 vanish entirely**
  with no shim (property-proxy collapse, list-order re-presentation that silently changed solve order,
  per-concept forwarding gaps). The 4th — **engine faithfulness/lifecycle (sleep/wake/CCD)** — does NOT
  disappear; it's the work you sign up for by porting Box2D, but far easier to find with no shim noise
  on top. This is the strongest argument for all-TS.
- **Biggest waste to avoid:** the **planck.js detour** — "Box2D-ish is close enough" was false at the
  bit level and never closeable. Port the real engine; never let a lookalike in the door.

## Known risks (tracked, not waved away)

- **Trig ceiling** (rule 5) — highest bit-exactness threat; FZ3 more exposed than SB2 (TOI sweep is an
  extra `sin/cos` surface). Measure early; escalate per protocol.
- **CCD/TOI re-solve** — hardest engine area; SB2's worst three bugs. Budget accordingly.
- **Body/contact ordering** — island assembly + contact ordering affect solver results; creation and
  iteration order must match the original exactly.

## Open decisions

1. *(Resolved)* Rendering = **OpenFL npm, approach (A) display-list, Vite + `openfljs process` prebuild**.
   Spike passed; `dobj` = `physobjs.json` `clip` (linkage name). See "The rendering decision".
2. *(Resolved)* Ground truth = **Ruffle** (runs shipped bytecode).
3. *(Resolved)* Reuse = game-logic skeleton + tooling flow **yes**; physics **fresh** (Box2D≠Nape);
   rendering = OpenFL npm (new vs. SB2's atlas blitter).

## Repo layout

```
flaming-zombooka-3.swf                 original (CWS, 5.6 MB)
flaming-zombooka-3.uncompressed.swf    decompressed (FWS)
abc_bytecode.bin                       extracted AS3 bytecode
ANALYSIS.md                            SWF teardown / engine identification
extracted/                             full FFDec export (scripts, shapes, images, sounds, binaryData XML)
tools/ffdec/                           JPEXS FFDec 26.2.1 (decompiler + harness injector)
questions_for_sb2_developer.md         async Q&A with the two SB2 dev sessions — READ THIS
ENGINE_DEV.md                          brief/contract for the Box2D engine developer
RENDER_DEV.md                          brief/contract for the rendering / OpenFL developer
DEVELOPER_MESSAGES.md                  shared bidirectional channel (game ↔ engine ↔ render)
contracts/render-state.ts              game→render interface (the RenderFrame the renderer draws)
contracts/game-data.ts                 types for data/*.json (raw-string discipline; loader converts)
data/                                  extracted level/library JSON (constants/materials/objparams/physobjs/levels)
tools/extract_data.py                  build-time XML→JSON transcriber (faithful, raw strings)
src/box2d/**                           engine dev: bit-exact Box2DFlash 2.0.2 port (Common/Collision/Dynamics)
src/game/**                            game dev: framework port — util/ (AS3 decoders+utils, Triangulate), model/ (Level/instance/joint/line + PhysObj library), data/ (level-loader, physobj-loader). AddPhysObjAt + InitLines/InitJoints → creation-order dump next.
src/render/**                          render dev: OpenFL display layer (forthcoming)
test/**                                vitest suites (test/goldens/ engine; test/game/ decoders) + helpers/hex16.ts
spike/                                 render dev's OpenFL spike (proof + candidates.json catalog)
package.json / tsconfig.json / vitest.config.ts   shared project (ESM, strict, no-shuffle determinism)
CLAUDE.md                              this file
```

## Team / sessions
- **game** (this session) — framework port, level/material data, fixed-step loop, integration, hub.
- **engine** — bit-exact Box2D port + oracle/goldens (`ENGINE_DEV.md`).
- **render** — OpenFL-npm display layer + asset pipeline (`RENDER_DEV.md`); first task = OpenFL spike.
Comms via `DEVELOPER_MESSAGES.md` (address `To: game|engine|render`). game↔engine and game↔render are
bidirectional; engine↔render route through game.
