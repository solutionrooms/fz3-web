import { describe, it, expect } from "vitest";
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { buildLevel } from "../../src/game/data/level-loader";
import { PhysObjJoint } from "../../src/game/model/phys-obj-joint";
import type { Level as LevelData, Constants } from "../../contracts/game-data";

const root = fileURLToPath(new URL("../../", import.meta.url));
const levels: LevelData[] = JSON.parse(readFileSync(root + "data/levels.json", "utf8"));
const constants: Constants = JSON.parse(readFileSync(root + "data/constants.json", "utf8"));

describe("level-loader against real extracted data", () => {
  it("loads the campaign (43 levels: final + rob + julian)", () => {
    expect(levels.length).toBe(43);
    expect(levels[0].source).toBe("final");
  });

  it("builds level[0] 'Intro 1' faithfully", () => {
    const lv = buildLevel(levels[0], constants);
    expect(lv.name).toBe("Intro 1");
    expect(lv.id).toBe("1");
    expect(lv.bgFrame).toBe(2);
    expect(lv.gold_score).toBe(8700);
    expect(lv.fullyLoaded).toBe(true);
    // 5 objgroups, 20 instances total (objgroup order preserved)
    expect(lv.instances.length).toBe(20);
    expect(lv.lines.length).toBe(3);
    expect(lv.joints.length).toBe(0);
    // a line decoded its points
    expect(lv.lines[0].points.length).toBeGreaterThan(0);
    // line default param seeding survives (material 'average' unless overridden)
    expect(lv.lines[0].objParameters.getValueString("line_physmaterial")).not.toBe("");
  });

  it("instance order = objgroups (in order) then top-level objs", () => {
    // reconstruct expected order directly from the raw data and compare
    const d = levels[0];
    const expected: string[] = [];
    for (const g of d.objgroups) for (const o of g.objs) expected.push(o.type);
    for (const o of d.objs) expected.push(o.type);
    const lv = buildLevel(d, constants);
    expect(lv.instances.map((i) => i.typeName)).toEqual(expected);
  });

  it("builds rev joints with seeded+overridden params (Wheel Of Death)", () => {
    const data = levels.find((l) => l.name === "Wheel Of Death")!;
    expect(data).toBeTruthy();
    const lv = buildLevel(data, constants);
    expect(lv.joints.length).toBeGreaterThan(0);
    const rev = lv.joints.find((j) => j.type === PhysObjJoint.Type_Rev)!;
    expect(rev).toBeTruthy();
    expect(rev.obj1Name).toBe("uid_782234");
    expect(rev.rev_pos).toEqual({ x: 142, y: 183 });
    // setType seeded rev_enablemotor=false; valuesFromString overrode it to true
    expect(rev.objParameters.getValueBoolean("rev_enablemotor")).toBe(true);
    expect(rev.objParameters.getValueNumber("rev_motorspeed")).toBe(2);
    expect(rev.objParameters.getValueNumber("rev_maxmotortorque")).toBe(2.5);
    expect(rev.objParameters.getValueString("joint_initfunction")).toBe("InitGameObjJoint_Null");
  });

  it("loads every level without throwing (faithful coverage smoke)", () => {
    let totalInstances = 0;
    let totalJoints = 0;
    for (const d of levels) {
      const lv = buildLevel(d, constants);
      totalInstances += lv.instances.length;
      totalJoints += lv.joints.length;
    }
    // 1287 campaign objgroup objs + 7 (julian) + 50 (rob) = 1344
    expect(totalInstances).toBe(1344);
    // 166 campaign joints + 8 (rob) = 174
    expect(totalJoints).toBe(174);
  });
});
