// Intro-1 [ORIG]-vs-[PORT] bit-exact golden — the first REAL-level faithfulness gate.
//
// [ORIG] = the shipped 2011 Box2DFlash bytecode running Intro 1 under Ruffle (tools/oracle/harness-intro1.as
// → test/goldens/intro1.json): the GAME's OWN creation code builds the world (PhysicsBase.InitBox2D +
// InitLevelPlayFromEditorObjects + InitLines + InitJoints), then it steps 2×(1/60) per render frame with NO
// game logic — idle zombies never touch their bodies (UpdateZombie state 0 only animates; see harness
// header) — for 150 frames, dumping every level body's (x,y,angle,vx,vy,ω) as raw f64 each step.
//
// [PORT] = our pipeline (buildLevel → buildCreationPlan → buildWorld) stepped the same way. Bodies are
// matched by frame-0 position (order-agnostic: ORIG walks GetBodyList = reverse creation order).
//
// STATUS (2026-06-21): the golden PROVES level→body CREATION is bit-exact (all 8 frame-0 states match) and
// the held missile is bit-exact for all 150 steps. It also CAUGHT A REAL DIVERGENCE: the 4 dynamic zombie
// bodies, resting on the triangulated terrain, get a large wrong contact impulse on step 1 and slide
// sideways (ORIG: they sit perfectly still). Exactly the hidden, chaotic divergence the Prime Directive
// exists to surface. The full-step gate below is SKIPPED until that contact/fixture bug is fixed — DO NOT
// delete it; un-skip it the moment the zombies match, that is the definition of done. See DEVELOPER_MESSAGES.

import { describe, it, expect } from "vitest";
import { readFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { buildLevel } from "../../src/game/data/level-loader";
import { buildPhysObjs, buildMaterials } from "../../src/game/data/physobj-loader";
import { buildCreationPlan } from "../../src/game/physics/creation-plan";
import { buildWorld, type BuiltWorld } from "../../src/game/physics/build-world";
import { f64hex, type Golden } from "../helpers/hex16";
import type { b2Body } from "../../src/box2d/index";
import type { Level as LevelData, PhysObjDef, Materials, Constants } from "../../contracts/game-data";

const root = fileURLToPath(new URL("../../", import.meta.url));
const GOLDEN_PATH = root + "test/goldens/intro1.json";
const PHYS_STEP = 1 / 60;
const PHYS_ITERS = 5;
const FIELDS = ["px", "py", "a", "vx", "vy", "w"];

function snap(b: b2Body): string[] {
  const p = b.GetPosition();
  const v = b.GetLinearVelocity();
  return [f64hex(p.x), f64hex(p.y), f64hex(b.GetAngle()), f64hex(v.x), f64hex(v.y), f64hex(b.GetAngularVelocity())];
}

function buildIntro1(): BuiltWorld {
  const levels: LevelData[] = JSON.parse(readFileSync(root + "data/levels.json", "utf8"));
  const constants: Constants = JSON.parse(readFileSync(root + "data/constants.json", "utf8"));
  const lib = buildPhysObjs(JSON.parse(readFileSync(root + "data/physobjs.json", "utf8")) as PhysObjDef[]);
  const materials = buildMaterials(JSON.parse(readFileSync(root + "data/materials.json", "utf8")) as Materials);
  const intro1 = buildLevel(levels.find((l) => l.name === "Intro 1")!, constants);
  return buildWorld(buildCreationPlan(intro1, lib, materials));
}

/** Pair each ORIG body tag to one of our bodies by frame-0 (px,py). Throws on any creation mismatch. */
function pairByFrame0(golden: Golden, w: BuiltWorld): { tag: string; bodyIdx: number }[] {
  const tags = Object.keys(golden.golden).filter((t) => t.startsWith("I1B"));
  const f0 = w.bodies.map(snap);
  const used = new Set<number>();
  const pairing: { tag: string; bodyIdx: number }[] = [];
  for (const tag of tags) {
    const g0 = golden.golden[tag][0].fields;
    let found = -1;
    for (let i = 0; i < f0.length; i++) {
      if (!used.has(i) && f0[i][0] === g0[0] && f0[i][1] === g0[1]) { found = i; break; }
    }
    if (found === -1) throw new Error(`${tag} ORIG f0 (px,py)=${g0[0]},${g0[1]} has no creation-position match`);
    used.add(found);
    pairing.push({ tag, bodyIdx: found });
  }
  return pairing;
}

describe("Intro 1 — [ORIG] golden vs [PORT] (bit-exact, real level)", () => {
  it.runIf(existsSync(GOLDEN_PATH))("CREATION is bit-exact: all 8 bodies' frame-0 (x,y,angle,v,ω) match the shipped engine", () => {
    const golden: Golden = JSON.parse(readFileSync(GOLDEN_PATH, "utf8"));
    const w = buildIntro1();
    const tags = Object.keys(golden.golden).filter((t) => t.startsWith("I1B"));
    expect(w.bodies.length).toBe(tags.length); // exactly 8 — no dropped/extra bodies
    const pairing = pairByFrame0(golden, w); // throws unless every frame-0 (px,py) matches
    for (const { tag, bodyIdx } of pairing) {
      // frame-0 = creation state (before any step); all 6 fields must be bit-identical
      expect(snap(w.bodies[bodyIdx])).toEqual(golden.golden[tag][0].fields);
    }
  });

  // FULLY GREEN — Intro 1 simulates BIT-EXACT for all 150 steps. The earlier "zombie ejection" was a missing
  // init-function physics flag: the scroll-area line (InitGameObjLine_ScrollArea → SetBodyCollisionMask(_,0))
  // must have maskBits=0 so it doesn't collide. Once creation-plan folds that in, the spurious contacts
  // vanish (124/16 → 70/0) and the whole level is faithful. The first level proven bit-exact end-to-end.
  it.runIf(existsSync(GOLDEN_PATH))("steps bit-faithfully for 150 frames (every body, every field)", () => {
    const golden: Golden = JSON.parse(readFileSync(GOLDEN_PATH, "utf8"));
    const w = buildIntro1();
    const pairing = pairByFrame0(golden, w);
    const nSteps = golden.golden[pairing[0].tag].length;
    for (let step = 1; step < nSteps; step++) {
      w.world.Step(PHYS_STEP, PHYS_ITERS);
      w.world.Step(PHYS_STEP, PHYS_ITERS);
      for (const { tag, bodyIdx } of pairing) {
        const og = golden.golden[tag][step].fields;
        const mine = snap(w.bodies[bodyIdx]);
        for (let f = 0; f < 6; f++) {
          expect(`${tag} step ${step} ${FIELDS[f]}: ${mine[f]}`).toBe(`${tag} step ${step} ${FIELDS[f]}: ${og[f]}`);
        }
      }
    }
  });
});
