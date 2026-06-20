import { describe, it, expect } from "vitest";
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { buildLevel } from "../../src/game/data/level-loader";
import { buildPhysObjs, buildMaterials } from "../../src/game/data/physobj-loader";
import { buildCreationPlan, type CreationPlan } from "../../src/game/physics/creation-plan";
import { buildWorld } from "../../src/game/physics/build-world";
import type { Level as LevelData, PhysObjDef, Materials, Constants } from "../../contracts/game-data";

const root = fileURLToPath(new URL("../../", import.meta.url));
const levels: LevelData[] = JSON.parse(readFileSync(root + "data/levels.json", "utf8"));
const constants: Constants = JSON.parse(readFileSync(root + "data/constants.json", "utf8"));
const lib = buildPhysObjs(JSON.parse(readFileSync(root + "data/physobjs.json", "utf8")) as PhysObjDef[]);
const materials = buildMaterials(JSON.parse(readFileSync(root + "data/materials.json", "utf8")) as Materials);

function intro1World() {
  const d = levels.find((l) => l.name === "Intro 1")!;
  return buildWorld(buildCreationPlan(buildLevel(d, constants), lib, materials));
}

// a minimal hand-built plan: one dynamic box high in the air, nothing to hit (free-fall only)
function freefallPlan(): CreationPlan {
  return {
    meta: { level: "synthetic-freefall", w2p: 1 / 50, note: "one dynamic box, no contacts" },
    ops: [
      {
        kind: "body", source: "instance", type: "box", id: "box",
        bodyDef: { position: { x: 5, y: -5 }, angle: 0, linearDamping: 0, angularDamping: 0, isBullet: false, fixedRotation: false },
        shapes: [{
          shape: "polygon",
          vertices: [{ x: -0.1, y: -0.1 }, { x: 0.1, y: -0.1 }, { x: 0.1, y: 0.1 }, { x: -0.1, y: 0.1 }],
          density: 1, friction: 0.5, restitution: 0, categoryBits: 1, maskBits: 0xffff, isSensor: false,
        }],
        massMode: "fromShapes",
      },
    ],
  };
}

describe("build-world: real level data → live Box2D engine", () => {
  it("Intro 1 builds on the live engine (8 bodies, no joints, dynamic + static)", () => {
    const w = intro1World();
    expect(w.bodies.length).toBe(8); // 5 instance + 3 line
    expect(w.skippedJoints).toBe(0);
    expect(w.bodies.filter((b) => b.GetMass() > 0).length).toBeGreaterThan(0); // dynamic (mass from shapes)
    expect(w.bodies.filter((b) => b.GetMass() === 0).length).toBeGreaterThanOrEqual(3); // ≥ 3 terrain lines
  });

  it("full build→step pipeline runs on the live engine: a free-fall body falls under +Y gravity", () => {
    const w = buildWorld(freefallPlan());
    const body = w.bodies[0];
    const y0 = body.GetPosition().y;
    for (let frame = 0; frame < 15; frame++) {
      w.world.Step(1 / 60, 5); // real cadence: two 1/60 steps per render frame
      w.world.Step(1 / 60, 5);
    }
    const y1 = body.GetPosition().y;
    expect(Number.isFinite(y1)).toBe(true);
    expect(y1).toBeGreaterThan(y0); // fell downward (+Y)
  });

  // STRUCTURAL smoke gate only — NOT a correctness claim. The engine is feature-complete (m0–m7), so
  // Intro 1 now steps end-to-end without throwing or producing NaN. Whether the resulting trajectories
  // are *bit-faithful* is a separate question that ONLY the Intro-1 [ORIG] golden can answer (see the
  // patched-game trace harness). This test guards the structural plumbing, nothing more.
  it("Intro 1 steps end-to-end on the feature-complete engine (no throw, no NaN)", () => {
    const w = intro1World();
    expect(() => {
      for (let frame = 0; frame < 120; frame++) {
        w.world.Step(1 / 60, 5); // real cadence: two 1/60 steps per render frame
        w.world.Step(1 / 60, 5);
      }
    }).not.toThrow();
    for (const b of w.bodies) {
      const p = b.GetPosition();
      expect(Number.isFinite(p.x) && Number.isFinite(p.y) && Number.isFinite(b.GetAngle())).toBe(true);
    }
  });
});
