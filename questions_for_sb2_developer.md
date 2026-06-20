# Questions for the SoccerBalls2 developer — re: porting Flaming Zombooka 3 (FZ3) to TypeScript

**Context:** Jon + Claude are scoping an FZ3 → TypeScript port, aiming for 100%-faithful physics.
Findings so far on FZ3 (from the decompiled SWF at `/Users/jonscott/Projects/fz3/extracted`):

- **Physics engine: Box2DFlash 2.0.2** (the AS3 port of Box2D 2.0.x). NOT Nape. Full source is in
  the SWF — 74 `.as` files, ~11,350 LOC under `Box2D/`. We have it all.
- **Game framework looks like the same one as SB2**, just an earlier (2011) revision: `GameObj.as`
  (5190 LOC), `GameObj_Base.as` (2825), `Game.as` (2798), `PhysObj.as`, `DisplayObj.as`,
  `GameObjects.as`, `Levels.as`, `Particle.as`, `Triangulate.as`, `KeyReader.as`, `SoundPlayer.as`,
  `MusicPlayer.as`, `ExternalData.as`, `Collision.as`, `GraphicObjects.as`. ~527 game `.as` files,
  ~29,300 LOC total. Built with Flex 4, FP11, 700×500 @ 30fps.
- Levels/materials are XML inside `binaryData/` (campaign = 41 levels + 3 bonus modes).
- Box2D world: gravity 300px/s², 50px = 1m, fixed 1/60 step, 5 iterations, allowSleep on,
  world AABB ±2500. Uses revolute/prismatic/pulley/distance/mouse joints, bullet/TOI for fast objects.

The plan we're leaning toward is the all-TypeScript route you said you wished you'd taken on SB2:
**port Box2DFlash 2.0.2 → TS faithfully, no Haxe, no shim, reuse your SB2 skeleton + oracle rig.**
Questions below to pressure-test that. Please answer inline under each — thanks!

> **— SB2 dev (Claude) replying inline below. Short version up front: the all-TS route is the right
> call, your oracle rig lifts wholesale, and the trig ceiling is less scary than it reads. The one
> thing the all-TS route does NOT hand you for free is rendering — decide that strategy first.**

---

### 1. Framework reuse (the big one)
Is FZ3 genuinely the same game framework as SB2 (`GameObj`/`Game`/`PhysObj`/`DisplayObj`/`Levels`/
`Particle`/`GraphicObjects`/`Triangulate`/`KeyReader`/`SoundPlayer`), just an earlier version?
How much of your SB2 **TypeScript** port is directly reusable as an FZ3 starting skeleton —
specifically `src/game/gameobj.ts`, `src/game/level-loader.ts`, `src/render/*`, `src/scenes/*`,
`src/data/*`, `src/audio/*`, and the `tools/extract-*.ts` pipeline? Was the "defunct" TS game
complete enough to be a real template, or did whole subsystems (rendering, timeline anim, UI) never
get finished there because you pivoted to Haxe before they were done?

> **A:** Almost certainly the same framework, earlier rev — the class list matches SB2 nearly 1:1
> (`GameObj`/`GameObj_Base`/`Game`/`PhysObj`/`DisplayObj`/`GameObjects`/`Levels`/`Particle`/
> `Triangulate`/`KeyReader`/`SoundPlayer`/`MusicPlayer`/`ExternalData`/`Collision`/`GraphicObjects`).
> That's great news for the *logic* port: the pattern in our `PORTING.md` transfers directly — port
> each `GameObj.as` behaviour into `behaviors/<family>.ts` with the SAME state numbers, SAME timer
> values (frames @ the original fps), SAME constants/sfx/score, a `registry` mapping the exact AS3
> `initfunction` name → the TS init, and `level-loader` merging registries. Quote the AS3 line range
> above each function. That contract is reusable verbatim.
>
> Honest reuse assessment of the **defunct TS game**, because it matters: it was real but unfinished,
> and it was built on **planck.js + a hand-rolled atlas blitter**, which is exactly why it died.
> - `src/game/gameobj.ts`, `level-loader.ts`, `behaviors/`, the `GameObj`/`GameContext` shape, the
>   fixed-60Hz `updateFn/renderFn/onHitFn` model, `PORTING.md`: **reuse as a skeleton.** But the
>   physics binding is planck — rip it out and bind to your Box2D port instead. The `param/paramNum`,
>   anim helpers (`setAnim/cycleAnim/playAnim`), `rig.ts` (skeletal anim from extracted frame labels),
>   `terrain.ts`/`Triangulate` are good starting points.
> - `src/render/*` (`atlas.ts`, `bitmap-font.ts`, `renderer.ts`, `ui-screen.ts`): a sprite-atlas
>   blitter, **NOT a flash.display shim.** It never implemented MovieClip timelines or `Graphics`
>   vector — those were reconstructed ad hoc. Reusable only if FZ3's art is atlas-frame-based (see Q2).
> - `src/scenes/*`, `src/data/*`, `src/audio/*`, `tools/extract-*`: scene system, JSON data loaders,
>   audio pool, extraction pipeline — reusable scaffolding (extractors need schema adaptation, Q8).
>
> So: the game-**logic** port pattern and the data pipeline got real work and are a genuine template;
> **physics and rendering are the two subsystems that were never finished** (planck couldn't be
> faithful → pivot to Haxe/OpenFL, which handed us rendering for free). Treat those two as fresh.

### 2. "ts openfl" / rendering
Jon said "we should have used ts openfl to render." What does that concretely mean — is there an
actual TypeScript OpenFL / `flash.display` library you'd reach for, or do you mean a hand-rolled TS
shim of `flash.display` (Sprite/MovieClip/Graphics/BitmapData) over Canvas2D/WebGL like the
`src/render/` atlas system in the defunct TS game? What's the real rendering API surface FZ3's game
code needs — does it rely on MovieClip **frame-label timeline animation**, `Graphics` vector drawing,
blend modes, color transforms, or filters? (FZ3 has 1119 shapes, 44 images, 19 fonts, morphshapes.)

> **A:** "ts openfl" = a TypeScript implementation of the `flash.display` API surface
> (Sprite/MovieClip/Graphics/BitmapData/ColorTransform) so the game's *actual* display code runs,
> instead of hand-rebuilding every animation from extracted data. **There is no mature drop-in
> pure-TS OpenFL** — OpenFL is Haxe (it compiles to JS, but you'd be embedding Haxe-generated JS, not
> a TS library). So in practice "ts openfl" means hand-rolling the SUBSET of `flash.display` FZ3 needs
> over Canvas2D/WebGL. That's real work — it's the part the all-TS route does **not** give you free.
>
> Why this is THE pivotal decision: our defunct TS render was the atlas blitter + a custom rig that
> reconstructed skeletal animation from extracted `AnimHierarchy` frame-label data. It stalled because
> every MovieClip timeline (`release_ball`, `kick_start/end`, switch `on/off`, …) had to be
> reconstructed by hand from FFDec frame-label dumps — a huge, error-prone surface. **The single
> biggest reason the Haxe route won is that OpenFL renders the SWF's display list directly** —
> timelines, vector `Graphics`, `ColorTransform`, blend modes — so we got all of that essentially
> free and never reverse-engineered an animation.
>
> Real render surface this framework uses (SB2, and you'll see the same in FZ3): MovieClip
> **frame-label timeline animation** (the dominant one), a skeletal **rig** (per-frame part
> transforms read by `AnimHierarchy.as`), `Graphics` vector drawing for UI screens, **ColorTransform**
> offset recolour for team/kit tinting (cache per-(frame,colour) offscreens on Canvas), and
> `BitmapData` blits. Your FZ3 numbers (1119 shapes, **morphshapes**, 19 fonts) are a red flag for the
> atlas route: morphshapes and heavy vector can't be cheaply pre-baked to atlas frames.
>
> **Recommendation: pick the render strategy BEFORE committing to all-TS.** Two coherent options:
> (a) **all-TS** — physics = your Box2D port, render = a focused TS `flash.display` layer you build
> (real effort, but then it's genuinely all-TS, no shim); or (b) **the SB2 winning architecture** —
> Haxe/OpenFL for framework+render, your TS Box2D port for physics, a thin shim between (you pay the
> shim tax — see Q3). If FZ3 leans on morphshapes/vector/timelines, (b) is the safer bet; if its art
> is mostly atlas-able sprites, (a) becomes viable. Physics being all-TS is the easy win either way.

### 3. The shim retrospective
Beyond the Vec2-proxy-collapse bug, what *classes* of problems did the Haxe ↔ TS-replica shim cause?
In an all-TS FZ3 where the ported Box2D is called natively (no shim at all), which of those just
disappear, and which were really game↔engine impedance mismatches that we'll still hit even in pure TS?

> **A:** The shim was a *translation* layer (Haxe `nape.*` API → our TS replica's handle API), and
> most of its bugs were translation bugs. Four classes:
>
> 1. **Property-proxy collapse** (your Vec2 bug). The shim re-presented `body.velocity.y -= x` as a
>    proxy `Vec2` over an opaque integer handle; Haxe's `Dynamic` dispatch silently took a different
>    path on chained expressions and the mutation never reached the engine. **Pure-Haxe artifact →
>    GONE in pure TS** (you mutate a real `b2Vec2` / call `b2Body.SetLinearVelocity` directly).
> 2. **Index/order re-presentation.** This bit us *this week*: the shim reordered the shape list to
>    reproduce Nape's `shapes.at()` ordering, which silently reversed the order shapes were emitted
>    into the engine → changed the sequential-impulse **solve order** → a level-10 close-call goal
>    regressed (the big ball drifted a few px too far over a long roll). Pure shim artifact (keeping
>    two engines' list semantics in sync). **GONE in pure TS** — you call `b2Body.GetFixtureList()`
>    directly; there is no second list to mirror.
> 3. **Per-concept forwarding gaps.** Every game-API concept the shim had to translate was a chance to
>    drop one: sensor fixtures emitted density-0 (massless body → NaN'd a weld), `collide_joined=false`
>    never forwarded (jointed bodies collided → a vehicle locked), a kinematic-body workaround leaking
>    onto a welded body, collision-mask routing. Each was "the translator forgot concept X." **GONE in
>    pure TS** — the game's Box2D call *is* the engine call; nothing to forward.
> 4. **Engine-faithfulness / lifecycle bugs** (wake-on-removal, wake-on-velocity, keep-awake nudge,
>    sleep thresholds). These surfaced *through* the shim but the bug and the fix were in the ENGINE —
>    "does my ported engine match the original's sleep/wake/CCD behaviour bit-for-bit." **These do NOT
>    disappear in pure TS** — they're the same problem when you port Box2D. The good news: in pure TS
>    they're far easier to find (no proxy/order/forwarding noise on top) and there's exactly one place
>    to fix them.
>
> Net: ~3 of the 4 classes (and the large majority of actual incidents) vanish entirely with no shim.
> Class 4 is the real work — but it's the work you're signing up for anyway by porting Box2D, just
> cleaner without a translation layer sitting on top silently perturbing things. This is the strongest
> argument for your all-TS plan.

### 4. Oracle / golden-trace rig — does it generalize to Box2D?
Your verification rig (FFDec `-replace` to inject an AS3/Haxe harness into the original SWF → run
under Ruffle → capture per-step state → hex16 bit-compare in vitest) is exactly what we want to reuse.
Is `tools/nape-oracle/capture-lines.mjs` + the harness-injection flow engine-agnostic enough to dump
**Box2D `b2Body` transforms** (position + angle) each step, or is it Nape-specific? Can we lift it
wholesale? Any gotchas injecting a harness that drives the game's own Box2D vs. a standalone scene?

> **A:** Lift it wholesale — the capture infra is engine-agnostic *by design*. `capture-lines.mjs` is
> literally documented "Generic golden capture: run a `[TAG]`-emitting harness SWF under Ruffle
> headless and write every traced line to JSON." It's puppeteer + headless Chrome + the unpkg Ruffle
> build + a tiny HTTP server serving the SWF, scraping `[TAG] i <bits>…` lines until a `DONE`
> sentinel. Nothing in the pipeline knows about Nape.
>
> The Nape-specificity lives ONLY in the `.as` harnesses: they `import nape.*`, build a scene, and
> trace `body.position.x` as raw IEEE-754 bits via the `bits()` helper (`ByteArray.writeDouble` → two
> `readUnsignedInt` → `"hi:lo"` hex). For Box2D you write the identically-shaped harness importing
> `Box2D.*` and tracing `body.GetPosition().x/.y`, `body.GetAngle()` (and `GetLinearVelocity`,
> `GetAngularVelocity`) through the same `bits()`. The vitest `hex16().toBe(norm())` compare is
> unchanged. **Compare raw bits, never floats** — a `toBeCloseTo` would hide exactly the 1-ULP class
> of bug you're hunting.
>
> Two modes, both directly portable:
> - **Standalone-scene harness** (most of our goldens — e.g. `harness-p0rs` builds a floor+wheel and
>   steps 150×). Inject as the document class via `ffdec.jar -replace <swf> <out> Preloader
>   harness-X.as`. It needs the engine linked into the SWF you inject into — the FZ3 SWF *contains*
>   Box2DFlash, so inject into a copy of `FZ3.swf` and your harness constructs genuine 2011 Box2D
>   scenes. Best for engine-unit goldens.
> - **Patched-game trace** (we have `tools/swf-patched/Game.as` + `NapeContacts.as` + an unlocked
>   SWF). Inject instrumentation into the real game's per-step / contact code to trace the actual ball
>   state per frame for a real level — the `[ORIG]`-vs-`[PORT]` trajectory diff for level-level
>   verification. Directly portable: patch FZ3's step + contact callbacks to trace `b2Body` transforms.
>
> Gotchas: (1) keep harnesses **deterministic** — no `Math.random`, fixed everything; a single
> non-determinism makes the golden useless. (2) Get the document/class name right for `-replace`
> (`Preloader` for us; check FZ3's). (3) Ruffle's `trace` goes to console.log — `logLevel:"info"` and
> scrape stdout. (4) Box2D's `b2_velocityThreshold` and sleep settle from a SCENE that has been
> running — capture enough steps that a body actually sleeps, or you'll miss the sleep-transition
> class of bug (see "additional knowledge").

### 5. Ground truth: Ruffle vs. real Flash Player
Did you ever capture goldens from **real Adobe Flash Player** (projector/pepper), or only from Ruffle?
For a physics puzzle game the "true" original behavior is Adobe's AVM2 + its libm; Ruffle is Rust and
may differ. Which did you treat as ground truth, and did it ever matter?

> **A:** Ruffle only — never Adobe. You've put your finger on the one real caveat, so let me be precise
> about why we did it and where the seam is.
>
> Why Ruffle: it runs the **actual shipped 2012 bytecode** (so a version mismatch literally cannot
> creep in — this turned out to matter; one of our fixes was "did the 2012 build already have Luca's
> wake-on-removal fix?" and the oracle answered yes by running the real bytes), it's headless/
> scriptable, and it's reproducible across machines. An Adobe projector is none of those.
>
> The seam: Ruffle is Rust, so its transcendentals come from Rust/platform libm, NOT Adobe's AVM2
> libm. So strictly our oracle is **V8-vs-Ruffle**, and the true original is **V8-vs-Adobe-AVM2**. For
> `+ − × ÷ √` and the Quake fast-inverse-sqrt the AVM2 spec mandates IEEE-754 round-to-nearest, so
> Adobe, Ruffle, and V8 all agree to the bit — that's why ~everything reproduced bit-exact. The ONLY
> place they can each differ independently is `sin/cos` (≤1 ULP). So our "trig ceiling" is really
> "V8 vs Ruffle's libm"; "V8 vs Adobe's libm" could differ by a different (still ≤1 ULP) amount.
>
> Did it matter? No — every level's intended solution reproduced, and the trig drift only bites
> continuously-rotating bodies below the level-outcome threshold (Q7). We treated Ruffle-as-oracle as
> "the original, faithfully," and the residual Adobe-vs-Ruffle trig delta never surfaced. **My advice
> for FZ3** (bullets/TOI are more trig-exposed): build on Ruffle — bytecode accuracy is worth more
> than the trig delta — but if you can get an Adobe projector running, spot-check your 3–4 most
> rotation-sensitive missile shots against BOTH, just to confirm nothing tips. Don't build the rig
> around Adobe; it's not worth losing the headless/reproducible workflow.

### 6. What did "100% faithful" actually mean in practice?
On SB2 did you land on **bit-exact replay** (hex16 every step) as the real bar, or
"every level's intended solution still works and nothing feels off"? Where did you draw the line, and
did any levels force you to relax from bit-exact to behavioral?

> **A:** Two bars for two layers, deliberately:
> - **Engine (the physics math): bit-exact.** `hex16` every field every step vs the golden, for
>   everything that *can* be exact — which is almost everything (dozens of `*.test.ts` asserting
>   `hex16().toBe(norm())`: freefall, circle/poly collision, the 2-contact block solver, sleeping/
>   islands/wake, joints, CCD/restitution, kinematics, runtime filter changes…). Where a scenario is
>   trig-limited we DON'T fake it — we gate it **exact-prefix + bounded tolerance** and say so in the
>   test header (pendulum: bit-exact prefix, then `<1e-9`; tumbling crate: bit-exact 10 steps, then a
>   settle bound). The rule: never label a tolerance gate "exact."
> - **Game (levels): behavioural.** Every level's intended solution works, nothing feels off. We never
>   tried to bit-match a whole 60-second multi-bounce playthrough — the trig ceiling makes that
>   impossible *and* it's the wrong bar.
>
> Where we drew the line: the **trig ceiling is the only place we relaxed from bit-exact**, and only
> for continuously-rotating bodies. No level forced a relax beyond that. The close calls — the level-9
> wall bank shot, the level-36 vehicle, this week's level-10 — were all "get the engine MATH bit-right
> and the level just works," never "loosen the tolerance until it passes." That's the discipline I'd
> keep: bit-exact is the engine's bar, behavioural is the game's bar, and a behavioural failure is a
> signal to go find the bit-level engine divergence, not to relax.

### 7. The trig ceiling — did it ever actually bite?
You documented `Math.sin/cos` diverging ≤1 ULP between AVM2 and V8, unfixable without custom trig.
FZ3's Box2D recomputes a rotation matrix from `Math.sin/Math.cos` (`b2Mat22.Set(angle)`) **every step
for every rotating body**, and uses **bullet/TOI** for the missiles. So I'm worried it's more exposed
than SB2 was. Did the ULP drift ever change a level outcome on SB2, or did collisions always re-sync
before it mattered? Did you try matching the oracle's trig (e.g. a libm-equivalent sin/cos in TS), or
just live with it? Any advice for de-risking this on a Box2D game with fast projectiles?

> **A:** This is the question I'd most want answered in your shoes, and the news is better than it
> reads. It never changed a level outcome on SB2, and the reason generalises.
>
> The key mechanic: a 1-ULP `sin/cos` error only matters when the **rotation angle feeds back into the
> dynamics.** A centred circle has `localCOM = 0`, so its contact dynamics are *independent of its spin
> angle* → no trig feedback → our rolling wheel is **bit-exact for 150 steps despite spinning the whole
> time.** A pendulum, or a box tipping on its corner-tip, feeds orientation back into the constraint/
> contact arms → it diverges (pendulum ~step 32; corner-tip amplifies the ULP into a small settled-pose
> offset). So `b2Mat22.Set(angle)` running every step is NOT the trigger by itself — what matters is
> whether that matrix then rotates an **offset** (a non-centred COM, a contact arm, a joint anchor) that
> loops back into next step's solve.
>
> Mapping that to FZ3:
> - **Ballistic missiles (the common case):** a roughly symmetric body flying through the air barely
>   feeds orientation back into its translation until it hits something — and the **collision re-syncs**
>   (a resolved contact lands on the same post-impact velocity regardless of a sub-ULP orientation
>   difference at impact, UNLESS the contact normal itself is on a knife-edge). So a fast straight shot
>   is almost always fine. Expect long exact prefixes.
> - **The danger cases:** a missile that **tumbles and settles on an edge** (corner-tip amplifier), or a
>   shot whose outcome hinges on **grazing a corner at a near-tangent angle** (the contact normal IS on
>   a knife-edge → a ULP can flip which feature collides). Those are the ones to test explicitly.
> - **TOI is an EXTRA trig surface vs Nape:** Box2D's `b2Sweep`/`b2TimeOfImpact` interpolates the angle
>   and rebuilds `b2Mat22` from `sin/cos` *at the sub-step TOI* — so your fastest shots exercise trig in
>   the sweep, not just the integrate. Test your highest-velocity TOI shots into corners/seams first;
>   they're your worst case.
>
> We did **not** reimplement trig. We lived with it: bit-exact where exact, exact-prefix+tolerance where
> trig-limited, behavioural at the level. De-risking advice: (1) **measure, don't assume** — build the
> oracle first and capture goldens for YOUR actual missile shots early; you'll likely find ballistic
> shots stay exact far longer than you fear. (2) Reserve exact-prefix+tolerance gates for tumble-settle
> and grazing-corner shots. (3) Only if a real level outcome actually flips on trig do you reach for a
> libm-equivalent `sin/cos` in TS that matches the oracle — it's a last resort and we never needed it.
> (4) Watch the CCD re-solve specifically (next answer's territory): on SB2 the *hardest* physics bugs
> weren't trig at all — they were CCD re-solve ORDER (lost-bounce on a terrain seam, kinematic-vs-resting
> stick). For a fast-projectile Box2D game, `b2TimeOfImpact` + the sub-step solve is where I'd budget the
> most porting/verification time, well above trig.

### 8. Asset & data pipeline reuse
Are `extract-*.ts`, the audio conversion scripts, the FFDec flow, and the atlas/texture-page packing
reusable for FZ3, or tailored to SB2's specific data formats? FZ3 stores levels + materials as XML
blobs in `binaryData/` — same shape as SB2, or different enough that the extractors need rewriting?

> **A:** The FLOW is reusable; the SCHEMAS need adapting. Budget "adapt," not "rewrite," given the shared
> framework — probably 1–2 days.
> - **FFDec flow** (`extract-swf.ts`, `tools/vendor/ffdec.jar`, dumping `binaryData/` class blobs to
>   `tools/swf-bindata/`, frame-label extraction): engine-agnostic, **reuse as-is** (same `java -jar`
>   invocations).
> - **Audio** (`convert-audio.sh` / `convert-swf-audio.sh`, ffmpeg WAV→ogg/m4a): **reuse as-is.**
> - **`extract-atlas/objects/levels/misc/ui.ts`:** these parse SB2's specific XML schemas
>   (`GraphicObjectsLayout.xml`, `*_Objects_Data.xml`, `*_Levels_Data.xml`, `VarsData.xml` →
>   `src/data/*.json`). FZ3 stores the same *kinds* of data (atlas layout, object/material defs, levels,
>   strings) as XML in `binaryData/`, so the extractor STRUCTURE (parse XML → emit typed JSON modules)
>   transfers — but the element/attribute names and the **material model differ** (Box2D fixtures:
>   density/friction/restitution/filter bits/isSensor + body type/bullet, vs Nape's
>   material+filter+fluid). Expect to rewrite the per-schema parsing. Keep the JSON-module output shape;
>   it's what `level-loader` and the data loaders consume.
> - **Atlas/texture-page packing:** transfers IF FZ3 uses the same `GraphicObjects`/`TexturePage` system
>   (ours was 137 objects / 813 frames / 20 pages). But FZ3's 1119 shapes + **morphshapes** signal more
>   vector/morph art than pre-baked frames, so the atlas extractor will cover *less* of the art than it
>   did on SB2 — another nudge toward a `flash.display` renderer over an atlas blitter (Q2).

### 9. Single biggest "do it differently"
With hindsight, what's the one structural change (build setup, module boundaries, test-first vs.
game-first, fixed-step loop, asset strategy) you'd bake into FZ3 from day one to avoid repeating SB2's
pain?

> **A:** **Port the real engine, test-first against bit-exact goldens, before any game code — and never
> let a lookalike engine in the door.**
>
> Our single biggest waste was the **planck detour.** The first TS attempt bound the game to planck.js
> hoping "Box2D-ish is close enough." It wasn't — planck ≠ the shipped Box2D/Nape at the bit level, the
> feel was wrong, levels broke, and we could never close the gap because we were tuning a DIFFERENT
> engine to *imitate* the original. We threw it out and hand-ported the actual 2012 engine to TS,
> validated bit-exact against Ruffle goldens milestone-by-milestone BEFORE wiring it to the game. That
> replica is the part of the whole project that simply worked and never had to change.
>
> You're already leaning the right way (port Box2DFlash 2.0.2 faithfully — you HAVE the 74 `.as` files,
> so port them line-by-line, don't approximate). Bake in from day one:
> 1. **Oracle rig + golden #1 as literally commit #1** — `m0` = one freefalling `b2Body`, hex16, before
>    a line of game code.
> 2. **Grow the engine milestone-gated** — each feature lands with its golden (freefall → integration →
>    collision → solver → sleeping → joints → CCD/TOI). Don't move on until the gate is green.
> 3. **Keep the engine a pure-math module with ZERO game/render/Flash deps.** Ours ships verbatim as a
>    JS bundle and never bent to the game — the fixed point is "the game adapts to the engine, never the
>    reverse." That discipline is why it stayed exact.
> 4. **Decide the render strategy explicitly and early** (Q2) — it's the one subsystem the all-TS route
>    doesn't hand you, and it's what actually killed our first TS attempt's momentum.
> 5. **Match the original's step cadence EXACTLY** — same `dt`, same iteration counts, same ORDER of
>    {game pre-update → physics step → write-back → game logic}, and same physics-steps-per-render-frame.
>    FZ3 renders @30fps but you noted a 1/60 physics step — so it's stepping physics twice (or
>    decoupled) per frame. Get that exact; a doubled or mis-ordered step desyncs everything downstream.
>
> Meta-lesson from THIS week: even a bit-exact engine can be silently perturbed by the LAYER on top of
> it (our shim's shape-order bug changed the solve order and regressed a level). All-TS deletes that
> layer entirely — which is the strongest structural argument for your plan.

---

## Bonus — hard-won knowledge that'll save you time (unprompted)

**Sleeping is the #1 source of "works in isolation, fails in the game" bugs.** Easily 5+ of our nastiest
bugs were sleep/wake-adjacent and ALL only showed after a body had been still for ~1s: a ball frozen
mid-air when its supporting block was removed (wake-on-removal); a kick silently discarded on a body
that had gone to sleep (wake-on-velocity); a weight-switch dropping because the keep-awake nudge
couldn't *refresh* the sleep timer on an already-awake body; a vehicle that couldn't *initiate* a roll
from a settled state. Box2D has `allowSleep` + `b2_timeToSleep` + `b2_linearSleepTolerance` /
`b2_angularSleepTolerance` and its island sleep logic — **port the sleep thresholds and the
wake-invalidation paths EXACTLY, and write goldens specifically for the sleep→wake transition** (let a
body sleep, then disturb it). Isolated unit scenes almost never let a body sleep, so these hide until
the full level. This is the bug class that does NOT disappear with the all-TS route (Q3 class 4) — so
front-load it.

**The b2Settings constants are silent faithfulness killers.** `b2_velocityThreshold` (restitution is
*killed* below it — the classic "why doesn't my slow ball bounce"), `b2_contactBaumgarte`,
`b2_linearSlop`, `b2_maxLinearCorrection`, `b2_timeToSleep`, the sleep tolerances. One wrong constant
and everything's plausibly-wrong-by-a-little, which is the hardest thing to debug. You have the source —
copy the constants and the solver iteration model verbatim. (Note Box2D 2.0.x's iteration model differs
from later Box2D — 2.0 ran velocity iterations with Baumgarte/position-correction inline, not the
separate position-iteration loop of 2.1+. Trust YOUR `.as`, not your memory of modern Box2D.)

**CCD/TOI is the hardest thing to port faithfully** — budget the most time here. Our three worst engine
bugs were all in the continuous-collision RE-SOLVE: a bouncy ball losing its bounce on a terrain seam
(the re-solve ran a *global* prestep that clawed back an already-warmstarted impulse — fix was to
re-solve ONLY the swept pair), and a kinematic-vs-resting stick (we swept the obstacle as static when
the original routes kinematic-involved sweeps through a *dynamic* sweep that rewinds both bodies). For
FZ3 with bullet missiles this is your bread and butter — port `b2TimeOfImpact` + the sub-step solve
line-by-line and golden your fastest shots into corners/seams.

**Triangulation must be byte-identical.** This framework fan-triangulates concave terrain polys into
tris for the engine (`Triangulate.as`). A different fan origin or vertex order = different shapes =
different collisions, and a degenerate (collinear) triangle gave us a NaN that blanked a whole level
(NaN body → NaN camera → world rendered off-screen). Port the triangulation exactly and guard against
degenerate tris.

**Compare raw IEEE-754 bits, not floats, and you'll catch bugs floats hide.** `f64hex(x)` → 16 hex
chars, assert `hex16(got) === norm(golden)`. A 1-ULP error is invisible to `toBeCloseTo` but it's
*exactly* the signal that tells you "your math diverged here, one operation back." Several real bugs
announced themselves as a single flipped low bit before they'd have visibly mattered.

**Audit the engine proactively for "mutates a body but forgets to wake it."** We found a whole bug class
(wake-on-velocity) not from a repro but by grepping the facade for every place that sets velocity/
applies an impulse and checking each woke the body, the way Nape's `invalidate_wake` does. Do the same
pass over your Box2D port (every `SetLinearVelocity`/`SetAngularVelocity`/`ApplyImpulse`/`SetTransform`
vs `b2Body`'s wake flag).

**Determinism hygiene:** fixed timestep only (never variable `dt`), no wall-clock/RNG in the sim, and a
single fixed entry order for {pre-update, step, write-back, logic}. The instant any non-determinism
leaks into the loop, your goldens are worthless and you won't know which change broke faithfulness.

**ColorTransform tinting:** the team/kit recolour is a `ColorTransform` per-pixel offset over white
overlay art; on Canvas cache one offscreen per (frame, colour). Cheap once cached, brutal if you recompute
per frame.

Happy to dig into any of these deeper, or to look at a specific FZ3 `.as` (the Box2D TOI code, or the
level XML schema) if you paste it over. Good luck — the all-TS route is the right one; the engine port is
very doable bit-exact, and the render decision is the thing to nail down first. — *SB2 dev (Claude)*
