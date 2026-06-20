import { describe, it, expect } from "vitest";
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { buildLevel } from "../../src/game/data/level-loader";
import { buildPhysObjs, buildMaterials } from "../../src/game/data/physobj-loader";
import { GameObj, buildGameObjects, updateGameObjects } from "../../src/game/game-objects";
import { applyInitFunction, behaviorRegistry } from "../../src/game/behaviors/registry";
import type { Level as LevelData, PhysObjDef, Constants } from "../../contracts/game-data";

const root = fileURLToPath(new URL("../../", import.meta.url));
const levels: LevelData[] = JSON.parse(readFileSync(root + "data/levels.json", "utf8"));
const constants: Constants = JSON.parse(readFileSync(root + "data/constants.json", "utf8"));
const lib = buildPhysObjs(JSON.parse(readFileSync(root + "data/physobjs.json", "utf8")) as PhysObjDef[]);
const intro1 = buildLevel(levels.find((l) => l.name === "Intro 1")!, constants);

describe("behavior dispatch", () => {
  it("updateGameObjects runs each active object's updateFn", () => {
    let calls = 0;
    const go = new GameObj();
    go.updateFn = () => calls++;
    const inactive = new GameObj();
    inactive.active = false;
    inactive.updateFn = () => calls++;
    updateGameObjects([go, inactive, go]);
    expect(calls).toBe(2); // the active object twice; the inactive one skipped
  });

  it("GameObj.update applies sortByY (zpos = -ypos*0.01)", () => {
    const go = new GameObj();
    go.sortByY = true;
    go.ypos = 100;
    go.update();
    expect(go.zpos).toBe(-1);
  });

  it("registry applies InitDecal (name + updateFn); unported init is a safe no-op", () => {
    const go = new GameObj();
    applyInitFunction(go, "InitDecal");
    expect(go.name).toBe("decal");
    expect(go.updateFn).not.toBeNull();
    expect(() => go.update()).not.toThrow(); // UpdateDecal is a no-op

    const go2 = new GameObj();
    applyInitFunction(go2, "InitPlayer_BarryZooka"); // not registered yet
    expect(go2.updateFn).toBeNull(); // unported → static, no crash
    applyInitFunction(go2, null); // null initfunction → no-op
  });

  it("buildGameObjects applies init functions: Intro 1 decals get name='decal'", () => {
    const gos = buildGameObjects(intro1, lib);
    const decals = gos.filter((g) => g.name === "decal");
    expect(decals.length).toBe(2); // decal2 + decal3 (both InitDecal)
    expect(Object.keys(behaviorRegistry)).toContain("InitDecal");
  });
});
