import { describe, it, expect } from "vitest";
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { buildPhysObjs, buildMaterials, getPhysMaterialByName } from "../../src/game/data/physobj-loader";
import { PhysObjShape } from "../../src/game/model/phys-obj-def";
import type { PhysObjDef, Materials } from "../../contracts/game-data";

const root = fileURLToPath(new URL("../../", import.meta.url));
const physData: PhysObjDef[] = JSON.parse(readFileSync(root + "data/physobjs.json", "utf8"));
const matData: Materials = JSON.parse(readFileSync(root + "data/materials.json", "utf8"));

const lib = buildPhysObjs(physData);
const materials = buildMaterials(matData);

describe("physobj library loader", () => {
  it("loads all 166 object defs", () => {
    expect(lib.getNum()).toBe(166);
  });

  it("parses a circle body faithfully (hook_fixed)", () => {
    const p = lib.findByName("hook_fixed")!;
    expect(p).toBeTruthy();
    expect(p.hasPhysics).toBe(true);
    expect(p.initFunctionName).toBe("InitStickyPad");
    expect(p.bodies.length).toBe(1);
    const b = p.bodies[0];
    expect(b.fixed).toBe(true); // booleanFromString("true")
    expect(b.sensor).toBe(true);
    expect(b.linearDamping).toBe(0); // FromXml overrides to 0
    expect(b.shapes.length).toBe(1);
    const s = b.shapes[0];
    expect(s.type).toBe(PhysObjShape.Type_Circle);
    expect(s.circle_radius).toBe(8); // raw radius (w2p/scale applied later in AddPhysObjAt)
    expect(s.materialName).toBe("average");
    expect(s.collisionCategory).toBe(1); // col "1,15"
    expect(s.collisionMask).toBe(15);
  });

  it("parses a polygon body faithfully (tiedup1)", () => {
    const p = lib.findByName("tiedup1")!;
    const s = p.bodies[0].shapes[0];
    expect(s.type).toBe(PhysObjShape.Type_Poly);
    expect(p.bodies[0].fixed).toBe(false);
    expect(s.collisionCategory).toBe(4); // col "4,15"
    expect(s.collisionMask).toBe(15);
    // vertices "-10,-60,10,-60, 10,0,-10,0" → 4 points; poly_rot=0 so calculate() is identity
    expect(s.poly_points).toEqual([
      { x: -10, y: -60 },
      { x: 10, y: -60 },
      { x: 10, y: 0 },
      { x: -10, y: 0 },
    ]);
  });

  it("findIndexByName / getByIndex round-trip", () => {
    const i = lib.findIndexByName("tiedup1");
    expect(lib.getByIndex(i).name).toBe("tiedup1");
  });

  it("loads 18 materials; 'average' = d0.3 f1 r0.1", () => {
    expect(materials.length).toBe(18);
    const avg = getPhysMaterialByName(materials, "average")!;
    expect(avg.density).toBe(0.3);
    expect(avg.friction).toBe(1);
    expect(avg.restitution).toBe(0.1);
  });

  it("CONSISTENCY: every shape's material resolves (no missing materials)", () => {
    const missing = new Set<string>();
    for (const p of lib.list) {
      for (const b of p.bodies) {
        for (const s of b.shapes) {
          if (s.materialName && !getPhysMaterialByName(materials, s.materialName)) {
            missing.add(s.materialName);
          }
        }
      }
    }
    expect([...missing]).toEqual([]);
  });

  it("every def builds without throwing; shapes are circle or poly", () => {
    for (const p of lib.list) {
      for (const b of p.bodies) {
        for (const s of b.shapes) {
          expect([PhysObjShape.Type_Poly, PhysObjShape.Type_Circle]).toContain(s.type);
        }
      }
    }
  });
});
