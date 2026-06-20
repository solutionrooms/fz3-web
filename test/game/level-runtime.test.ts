import { describe, it, expect } from "vitest";
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { buildLevel } from "../../src/game/data/level-loader";
import { buildPhysObjs, buildMaterials } from "../../src/game/data/physobj-loader";
import { buildWorld } from "../../src/game/physics/build-world";
import { GameObj } from "../../src/game/game-objects";
import { LevelRuntime, stepPhysics } from "../../src/game/level-runtime";
import type { CreationPlan } from "../../src/game/physics/creation-plan";
import type { Level as LevelData, PhysObjDef, Materials, Constants } from "../../contracts/game-data";

const root = fileURLToPath(new URL("../../", import.meta.url));
const levels: LevelData[] = JSON.parse(readFileSync(root + "data/levels.json", "utf8"));
const constants: Constants = JSON.parse(readFileSync(root + "data/constants.json", "utf8"));
const lib = buildPhysObjs(JSON.parse(readFileSync(root + "data/physobjs.json", "utf8")) as PhysObjDef[]);
const materials = buildMaterials(JSON.parse(readFileSync(root + "data/materials.json", "utf8")) as Materials);
const intro1 = buildLevel(levels.find((l) => l.name === "Intro 1")!, constants);

function freefallPlan(): CreationPlan {
  return {
    meta: { level: "synthetic-freefall", w2p: 1 / 50, note: "one dynamic box, no contacts" },
    ops: [{
      kind: "body", source: "instance", type: "box", id: "box",
      bodyDef: { position: { x: 5, y: -5 }, angle: 0, linearDamping: 0, angularDamping: 0, isBullet: false, fixedRotation: false },
      shapes: [{
        shape: "polygon",
        vertices: [{ x: -0.1, y: -0.1 }, { x: 0.1, y: -0.1 }, { x: 0.1, y: 0.1 }, { x: -0.1, y: 0.1 }],
        density: 1, friction: 0.5, restitution: 0, categoryBits: 1, maskBits: 0xffff, isSensor: false,
      }],
      massMode: "fromShapes",
    }],
  };
}

describe("LevelRuntime — the per-frame orchestration", () => {
  it("stepPhysics ticks the engine and syncs the view (free-fall, live engine)", () => {
    const world = buildWorld(freefallPlan());
    const go = new GameObj();
    go.isPhysObj = true;
    go.bodyIndex = 0;
    stepPhysics(world, [go], true); // sync to the body's start position without stepping
    const y0 = go.ypos; // = -5 × p2w(50) = -250
    for (let frame = 0; frame < 10; frame++) stepPhysics(world, [go]); // 2× Step + sync each frame
    expect(go.ypos).toBeGreaterThan(y0); // fell downward (+Y) — view tracked the body (px)
    expect(Number.isFinite(go.ypos)).toBe(true);
  });

  it("inTransition gate skips the physics step", () => {
    const world = buildWorld(freefallPlan());
    const go = new GameObj();
    go.isPhysObj = true;
    go.bodyIndex = 0;
    stepPhysics(world, [go], true); // gated → no Step
    expect(go.ypos).toBe(world.bodies[0].GetPosition().y * 50); // synced, but body didn't move
  });

  // STRUCTURAL smoke gate — the full per-frame orchestration (pre-update → 2× Step → write-back → logic)
  // runs Intro 1 for many frames on the feature-complete engine without throwing or going NaN. This is
  // NOT a faithfulness claim: the trajectories are only PROVEN correct by the Intro-1 [ORIG] golden.
  it("LevelRuntime(Intro 1) builds 20 objects, emits 17 visible, and runs many frames cleanly", () => {
    const rt = new LevelRuntime(intro1, lib, materials);
    expect(rt.gameObjs.length).toBe(20); // all 20 objects created
    expect(rt.renderFrame().objects.length).toBe(17); // 3 help-text objects hidden until their delay (visible=false)
    expect(() => { for (let f = 0; f < 120; f++) rt.step(); }).not.toThrow();
    for (const go of rt.gameObjs) {
      expect(Number.isFinite(go.xpos) && Number.isFinite(go.ypos) && Number.isFinite(go.dir)).toBe(true);
    }
  });
});
