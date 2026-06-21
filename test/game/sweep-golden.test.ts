// Multi-level faithfulness sweep — the first 10 campaign levels, each [ORIG] (shipped engine, captured by
// tools/oracle/harness-sweep.as → goldens/sweep.json) vs [PORT] (buildLevel → buildCreationPlan → buildWorld),
// stepped 2×(1/60) ×50 with no game logic. This is the regression net that catches init-function physics-flag
// gaps (e.g. a new walking-character variant needing SetUpright, or a line init needing maskBits/sensor):
// invisible to a frame-0 creation golden, caught here. 6 levels bit-exact, 4 trig-only (rule 5); the bound
// 1e-9 sits far below any real bug (gross gaps are ≥0.1) and far above the worst trig drift (≤2e-14).

import { describe, it, expect } from "vitest";
import { readFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { buildLevel } from "../../src/game/data/level-loader";
import { buildPhysObjs, buildMaterials } from "../../src/game/data/physobj-loader";
import { buildCreationPlan } from "../../src/game/physics/creation-plan";
import { buildWorld } from "../../src/game/physics/build-world";
import { f64hex } from "../helpers/hex16";
import type { b2Body } from "../../src/box2d/index";
import type { Level as LevelData, PhysObjDef, Materials, Constants } from "../../contracts/game-data";

const root = fileURLToPath(new URL("../../", import.meta.url));
const GOLDEN_PATH = root + "test/goldens/sweep.json";
const LEVELS = ["Intro 1", "Intro 2", "Coming Atya", "Wheel Of Death", "Teamwork!",
  "Trapezey", "County Cork", "Goldfish Bowls", "Bob the Zombie", "Tower Of Piano"];
const FIELDS = ["px", "py", "a", "vx", "vy", "w"];
const TRIG_BOUND = 1e-9; // » worst trig drift (≤2e-14), « any real init-flag gap (≥0.1)
const dec = (h: string) => Buffer.from(h, "hex").readDoubleBE(0);
function snap(b: b2Body): string[] {
  const p = b.GetPosition(), v = b.GetLinearVelocity();
  return [f64hex(p.x), f64hex(p.y), f64hex(b.GetAngle()), f64hex(v.x), f64hex(v.y), f64hex(b.GetAngularVelocity())];
}

describe("Campaign sweep — first 10 levels faithful to the shipped engine (rule-5 bound)", () => {
  const golden = existsSync(GOLDEN_PATH) ? JSON.parse(readFileSync(GOLDEN_PATH, "utf8")).golden : null;
  const levels: LevelData[] = JSON.parse(readFileSync(root + "data/levels.json", "utf8"));
  const constants: Constants = JSON.parse(readFileSync(root + "data/constants.json", "utf8"));
  const lib = buildPhysObjs(JSON.parse(readFileSync(root + "data/physobjs.json", "utf8")) as PhysObjDef[]);
  const materials = buildMaterials(JSON.parse(readFileSync(root + "data/materials.json", "utf8")) as Materials);

  for (let li = 0; li < LEVELS.length; li++) {
    it.runIf(golden != null)(`${LEVELS[li]} steps faithfully (≤ ${TRIG_BOUND})`, () => {
      const tags = Object.keys(golden).filter((t) => new RegExp("^L" + li + "B\\d+$").test(t));
      expect(tags.length).toBeGreaterThan(0);
      const lvl = buildLevel(levels.find((l) => l.name === LEVELS[li])!, constants);
      const w = buildWorld(buildCreationPlan(lvl, lib, materials));
      expect(w.bodies.length).toBe(tags.length); // same body count

      // pair by frame-0 (px,py) — also a creation-position check
      const f0 = w.bodies.map(snap);
      const used = new Set<number>();
      const pairing: { tag: string; i: number }[] = [];
      for (const tag of tags) {
        const g0 = golden[tag][0].fields;
        let fi = -1;
        for (let i = 0; i < f0.length; i++) if (!used.has(i) && f0[i][0] === g0[0] && f0[i][1] === g0[1]) { fi = i; break; }
        expect(fi, `${tag} frame-0 (px,py) unmatched`).toBeGreaterThanOrEqual(0);
        used.add(fi); pairing.push({ tag, i: fi });
      }

      const n = golden[tags[0]].length;
      let maxDrift = 0, at = "";
      for (let s = 1; s < n; s++) {
        w.world.Step(1 / 60, 5); w.world.Step(1 / 60, 5);
        for (const { tag, i } of pairing) {
          const o = golden[tag][s].fields, m = snap(w.bodies[i]);
          for (let k = 0; k < 6; k++) if (o[k] !== m[k]) {
            const d = Math.abs(dec(o[k]) - dec(m[k]));
            if (d > maxDrift) { maxDrift = d; at = `step ${s} ${tag} ${FIELDS[k]}`; }
          }
        }
      }
      expect(maxDrift, `max drift ${maxDrift.toExponential(2)} @ ${at}`).toBeLessThan(TRIG_BOUND);
    });
  }
});
