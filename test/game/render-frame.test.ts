import { describe, it, expect } from "vitest";
import { readFileSync, writeFileSync, mkdirSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { buildLevel } from "../../src/game/data/level-loader";
import { buildPhysObjs, buildMaterials } from "../../src/game/data/physobj-loader";
import { buildCreationPlan } from "../../src/game/physics/creation-plan";
import { buildWorld } from "../../src/game/physics/build-world";
import { buildGameObjects, syncFromWorld, toRenderFrame } from "../../src/game/game-objects";
import type { Level as LevelData, PhysObjDef, Materials, Constants } from "../../contracts/game-data";

const root = fileURLToPath(new URL("../../", import.meta.url));
const levels: LevelData[] = JSON.parse(readFileSync(root + "data/levels.json", "utf8"));
const constants: Constants = JSON.parse(readFileSync(root + "data/constants.json", "utf8"));
const lib = buildPhysObjs(JSON.parse(readFileSync(root + "data/physobjs.json", "utf8")) as PhysObjDef[]);
const materials = buildMaterials(JSON.parse(readFileSync(root + "data/materials.json", "utf8")) as Materials);
const intro1 = buildLevel(levels.find((l) => l.name === "Intro 1")!, constants);

describe("authoritative RenderFrame producer (game-state → render contract)", () => {
  it("Intro 1: produces a well-formed RenderFrame", () => {
    const gos = buildGameObjects(intro1, lib);
    const frame = toRenderFrame(gos);
    expect(frame.objects.length).toBeGreaterThan(0);
    expect(frame.stage).toEqual({ width: 700, height: 500 });
    for (const o of frame.objects) {
      expect(o.dobj.length).toBeGreaterThan(0); // a real SWF linkage/clip name
      expect(o.frame).toBeGreaterThanOrEqual(0); // 0-based
      expect(Number.isFinite(o.xpos)).toBe(true);
      expect(Number.isFinite(o.ypos)).toBe(true);
      expect(Number.isFinite(o.dir)).toBe(true); // radians
      expect(o.colorTransform).toBeUndefined(); // vector-path objects untinted
    }
    // 5 physics objects (player + 4 zombies), rest are decoration
    expect(gos.filter((g) => g.isPhysObj).length).toBe(5);
  });

  it("syncFromWorld round-trips physics objects back to their placement (frame 0)", () => {
    const gos = buildGameObjects(intro1, lib);
    const world = buildWorld(buildCreationPlan(intro1, lib, materials));
    // pre-sync the physics objects start at their data position; after sync they read from the bodies,
    // which were created at (inst × w2p) → ×p2w round-trips to the same pixel position.
    const physBefore = gos.filter((g) => g.isPhysObj).map((g) => ({ id: g.id, x: g.xpos, y: g.ypos }));
    syncFromWorld(gos, world);
    const physAfter = gos.filter((g) => g.isPhysObj);
    for (let i = 0; i < physAfter.length; i++) {
      expect(physAfter[i].xpos).toBeCloseTo(physBefore[i].x, 6);
      expect(physAfter[i].ypos).toBeCloseTo(physBefore[i].y, 6);
    }
  });

  it("emits the Intro 1 RenderFrame artifact for the render dev", () => {
    const frame = toRenderFrame(buildGameObjects(intro1, lib));
    mkdirSync(root + "data/render-frames", { recursive: true });
    writeFileSync(root + "data/render-frames/intro1.json", JSON.stringify(frame, null, 2));
    expect(frame.objects.every((o) => Number.isFinite(o.zpos))).toBe(true);
  });
});
