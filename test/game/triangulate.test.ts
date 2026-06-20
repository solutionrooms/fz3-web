import { describe, it, expect } from "vitest";
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { triangulate, area } from "../../src/game/util/triangulate";
import { buildPhysObjs } from "../../src/game/data/physobj-loader";
import { PhysObjShape } from "../../src/game/model/phys-obj-def";
import type { Pt } from "../../src/game/util/packed";
import type { PhysObjDef } from "../../contracts/game-data";

const root = fileURLToPath(new URL("../../", import.meta.url));
const lib = buildPhysObjs(JSON.parse(readFileSync(root + "data/physobjs.json", "utf8")) as PhysObjDef[]);

// sum of |triangle area| over a flat 3-per-triangle point list
function triAreaSum(tris: Pt[]): number {
  let s = 0;
  for (let i = 0; i < tris.length; i += 3) s += Math.abs(area([tris[i], tris[i + 1], tris[i + 2]]));
  return s;
}

describe("triangulate (ear-clipping)", () => {
  it("a convex quad → 2 triangles, area conserved", () => {
    const quad: Pt[] = [
      { x: -10, y: -60 },
      { x: 10, y: -60 },
      { x: 10, y: 0 },
      { x: -10, y: 0 },
    ];
    const tris = triangulate(quad)!;
    expect(tris).not.toBeNull();
    expect(tris.length).toBe(6); // 2 triangles
    expect(triAreaSum(tris)).toBeCloseTo(Math.abs(area(quad)), 9);
    // every emitted vertex is one of the contour vertices
    for (const p of tris) expect(quad).toContainEqual(p);
  });

  it("a single triangle → 1 triangle", () => {
    const tri: Pt[] = [{ x: 0, y: 0 }, { x: 10, y: 0 }, { x: 0, y: 10 }];
    expect(triangulate(tri)!.length).toBe(3);
  });

  it("clockwise winding triangulates the same area", () => {
    const cw: Pt[] = [{ x: -10, y: 0 }, { x: 10, y: 0 }, { x: 10, y: -60 }, { x: -10, y: -60 }];
    const tris = triangulate(cw)!;
    expect(tris.length).toBe(6);
    expect(triAreaSum(tris)).toBeCloseTo(Math.abs(area(cw)), 9);
  });

  it("fewer than 3 points → null", () => {
    expect(triangulate([{ x: 0, y: 0 }, { x: 1, y: 1 }])).toBeNull();
  });

  it("degenerate (collinear) polygon → null (the NaN guard)", () => {
    expect(triangulate([{ x: 0, y: 0 }, { x: 1, y: 1 }, { x: 2, y: 2 }])).toBeNull();
  });

  it("CONSISTENCY: every real physobj polygon triangulates, area conserved", () => {
    let polyShapes = 0;
    const failed: string[] = [];
    for (const p of lib.list) {
      for (const b of p.bodies) {
        for (const s of b.shapes) {
          if (s.type !== PhysObjShape.Type_Poly) continue;
          polyShapes++;
          const tris = triangulate(s.poly_points);
          if (tris == null || tris.length === 0) {
            failed.push(`${p.name}/${s.name}`);
            continue;
          }
          expect(tris.length % 3).toBe(0);
          // each triangle is non-degenerate, and the total area matches the polygon
          expect(triAreaSum(tris)).toBeCloseTo(Math.abs(area(s.poly_points)), 6);
        }
      }
    }
    expect(polyShapes).toBeGreaterThan(0);
    expect(failed).toEqual([]); // the shipped game has no untriangulable poly
  });
});
