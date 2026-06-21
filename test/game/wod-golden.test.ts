// Wheel Of Death [ORIG]-vs-[PORT] creation golden — verifies the JOINT + CIRCLE creation paths that Intro 1
// (polys + static lines, no joints) never exercised. WoD has 12 bodies, 11 revolute joints, 53 poly + 2
// circle fixtures. Captured via tools/oracle/harness-intro1.as (LEVEL_NAME="Wheel Of Death") → goldens/wod.json.
//
// STATUS (2026-06-21): CREATION is bit-exact — frame-0 bodies AND every fixture (poly world-verts + circle
// centre/radius) match the shipped engine, with all 11 joints created. WoD also STEPS bit-exact through step 4
// (proving the joint anchors/setup are faithful — wrong anchors would diverge at step 1), then diverges at
// step 5 (same engine broadphase/trig class as Intro 1's zombies — see intro1-golden.test.ts). The full-step
// gate is SKIPPED until that engine fix lands.

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
const GOLDEN_PATH = root + "test/goldens/wod.json";

function snap(b: b2Body): string[] {
  const p = b.GetPosition(), v = b.GetLinearVelocity();
  return [f64hex(p.x), f64hex(p.y), f64hex(b.GetAngle()), f64hex(v.x), f64hex(v.y), f64hex(b.GetAngularVelocity())];
}

function buildWoD(): BuiltWorld {
  const levels: LevelData[] = JSON.parse(readFileSync(root + "data/levels.json", "utf8"));
  const constants: Constants = JSON.parse(readFileSync(root + "data/constants.json", "utf8"));
  const lib = buildPhysObjs(JSON.parse(readFileSync(root + "data/physobjs.json", "utf8")) as PhysObjDef[]);
  const materials = buildMaterials(JSON.parse(readFileSync(root + "data/materials.json", "utf8")) as Materials);
  const wod = buildLevel(levels.find((l) => l.name === "Wheel Of Death")!, constants);
  return buildWorld(buildCreationPlan(wod, lib, materials));
}

// [PORT] fixtures of a body, in the harness world-vertex format:
//   polygon → [px0,py0, px1,py1, ...] ; circle → ["C", cx, cy, r]   (hex16, world space)
function portFixtures(b: b2Body): string[][] {
  const xf = (b as any).GetXForm();
  const out: string[][] = [];
  let s = (b as any).m_shapeList;
  while (s) {
    if (s.m_type === 1) { // polygon
      const verts: string[] = [];
      for (let i = 0; i < s.m_vertexCount; i++) {
        const v = s.m_vertices[i];
        verts.push(f64hex(xf.position.x + (xf.R.col1.x * v.x + xf.R.col2.x * v.y)));
        verts.push(f64hex(xf.position.y + (xf.R.col1.y * v.x + xf.R.col2.y * v.y)));
      }
      out.push(verts);
    } else { // circle
      const lp = s.m_localPosition;
      const cx = f64hex(xf.position.x + (xf.R.col1.x * lp.x + xf.R.col2.x * lp.y));
      const cy = f64hex(xf.position.y + (xf.R.col1.y * lp.x + xf.R.col2.y * lp.y));
      out.push(["C", cx, cy, f64hex(s.m_radius)]);
    }
    s = s.m_next;
  }
  return out;
}

// [ORIG] fixtures of body walk-index k, from the golden's FX (poly) / FXC (circle) rows keyed k*100+fixIdx.
function origFixtures(golden: any, k: number): string[][] {
  const rows: { fix: number; fields: string[] }[] = [];
  for (const r of golden.FX || []) if (Math.floor(r.step / 100) === k) rows.push({ fix: r.step % 100, fields: r.fields });
  for (const r of golden.FXC || []) if (Math.floor(r.step / 100) === k) rows.push({ fix: r.step % 100, fields: ["C", ...r.fields] });
  rows.sort((a, b) => a.fix - b.fix);
  return rows.map((r) => r.fields);
}

describe("Wheel Of Death — [ORIG] creation golden (joints + circles)", () => {
  it.runIf(existsSync(GOLDEN_PATH))("CREATION is bit-exact: frame-0 bodies + all fixtures (poly verts + circle centre/radius)", () => {
    const golden: Golden & { golden: any } = JSON.parse(readFileSync(GOLDEN_PATH, "utf8"));
    const g = golden.golden;
    const w = buildWoD();
    const tags = Object.keys(g).filter((t) => /^I1B/.test(t)).sort((a, b) => +a.slice(3) - +b.slice(3));
    expect(w.bodies.length).toBe(tags.length); // 12
    expect(w.joints).toBe(11); // all level joints created (was skipped pre-m6)

    // pair each ORIG body (walk-index k = tag suffix) to our body by frame-0 (px,py)
    const f0 = w.bodies.map(snap);
    const used = new Set<number>();
    for (const tag of tags) {
      const k = +tag.slice(3);
      const g0 = g[tag][0].fields;
      let j = -1;
      for (let i = 0; i < f0.length; i++) if (!used.has(i) && f0[i][0] === g0[0] && f0[i][1] === g0[1]) { j = i; break; }
      expect(j, `${tag} frame-0 (px,py) has no creation match`).toBeGreaterThanOrEqual(0);
      used.add(j);
      // frame-0 all 6 fields bit-exact
      expect(snap(w.bodies[j])).toEqual(g[tag][0].fields);
      // fixtures (poly verts + circle centre/radius) bit-exact, in order
      expect(portFixtures(w.bodies[j])).toEqual(origFixtures(g, k));
    }
  });
});
