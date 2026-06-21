import { describe, it, expect } from "vitest";
import { readFileSync, writeFileSync, mkdirSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { buildLevel } from "../../src/game/data/level-loader";
import { buildPhysObjs, buildMaterials } from "../../src/game/data/physobj-loader";
import { buildCreationPlan, type CreationPlan, type BodyOp, type JointOp } from "../../src/game/physics/creation-plan";
import type { Level as LevelData, PhysObjDef, Materials, Constants } from "../../contracts/game-data";

const root = fileURLToPath(new URL("../../", import.meta.url));
const levels: LevelData[] = JSON.parse(readFileSync(root + "data/levels.json", "utf8"));
const constants: Constants = JSON.parse(readFileSync(root + "data/constants.json", "utf8"));
const lib = buildPhysObjs(JSON.parse(readFileSync(root + "data/physobjs.json", "utf8")) as PhysObjDef[]);
const materials = buildMaterials(JSON.parse(readFileSync(root + "data/materials.json", "utf8")) as Materials);

const planFor = (name: string): CreationPlan => {
  const d = levels.find((l) => l.name === name)!;
  return buildCreationPlan(buildLevel(d, constants), lib, materials);
};

// every numeric field in the plan must be finite (a NaN here = the SB2 "blanked whole level" bug)
function assertAllFinite(plan: CreationPlan): void {
  const walk = (v: unknown): void => {
    if (typeof v === "number") expect(Number.isFinite(v)).toBe(true);
    else if (Array.isArray(v)) v.forEach(walk);
    else if (v && typeof v === "object") Object.values(v).forEach(walk);
  };
  walk(plan.ops);
}

describe("creation-order plan", () => {
  it("Intro 1: produces well-formed body/shape ops, emits artifact", () => {
    const plan = planFor("Intro 1");
    const bodies = plan.ops.filter((o): o is BodyOp => o.kind === "body");
    expect(bodies.length).toBeGreaterThan(0);
    // every physics body has at least one shape; polys are triangles; filter bits are ints
    for (const b of bodies) {
      expect(b.shapes.length).toBeGreaterThan(0);
      for (const s of b.shapes) {
        if (s.shape === "polygon") expect(s.vertices!.length).toBe(3);
        if (s.shape === "circle") expect(s.radius).toBeGreaterThan(0);
        expect(Number.isInteger(s.categoryBits)).toBe(true);
        expect(Number.isInteger(s.maskBits)).toBe(true);
      }
    }
    // Intro 1 has 3 type-0 lines → 3 static line bodies: 2 Grassy (cat 1 / mask 31) + 1 ScrollArea whose
    // InitGameObjLine_ScrollArea sets maskBits=0 (SetBodyCollisionMask(_,0)) so it never collides.
    const lines = bodies.filter((b) => b.source === "line");
    expect(lines.length).toBe(3);
    const lineMasks = lines.map((b) => b.shapes[0].maskBits).sort((a, c) => a - c);
    expect(lineMasks).toEqual([0, 31, 31]); // one scroll-area line → mask 0
    for (const b of lines) {
      expect(b.massMode).toBe("static"); // line_fixed defaults true
      for (const s of b.shapes) {
        expect(s.categoryBits).toBe(1); // categoryBits unchanged by SetBodyCollisionMask
        expect([0, 31]).toContain(s.maskBits);
      }
    }
    assertAllFinite(plan);
    mkdirSync(root + "data/creation-plans", { recursive: true });
    writeFileSync(root + "data/creation-plans/intro1.json", JSON.stringify(plan, null, 2));
  });

  it("Wheel Of Death: emits a plan with revolute joints (collideConnected=false)", () => {
    const plan = planFor("Wheel Of Death");
    const joints = plan.ops.filter((o): o is JointOp => o.kind === "joint");
    expect(joints.length).toBeGreaterThan(0);
    const rev = joints.find((j) => j.jointType === "revolute")!;
    expect(rev).toBeTruthy();
    expect(rev.def.collideConnected).toBe(false);
    assertAllFinite(plan);
    writeFileSync(root + "data/creation-plans/wheel-of-death.json", JSON.stringify(plan, null, 2));
  });

  it("NO NaN in any level's plan (the degenerate-triangle landmine)", () => {
    for (const d of levels) {
      assertAllFinite(buildCreationPlan(buildLevel(d, constants), lib, materials));
    }
  });
});
