import { describe, it, expect, beforeAll } from "vitest";
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { setAnimData, getNumFrames, getFrameIndexLabel, doesFrameLabelExist } from "../../src/game/anim";
import { GameObj } from "../../src/game/game-objects";
import type { Anim } from "../../contracts/game-data";

const root = fileURLToPath(new URL("../../", import.meta.url));

beforeAll(() => {
  setAnimData(JSON.parse(readFileSync(root + "data/anim.json", "utf8")) as Anim);
});

describe("anim table (clip frame counts + labels)", () => {
  it("exposes frame counts and label indices from data/anim.json", () => {
    expect(getNumFrames("Zombie")).toBe(185);
    expect(getNumFrames("Flame1")).toBe(16);
    expect(getFrameIndexLabel("Zombie", "walk")).toBe(95);
    expect(getFrameIndexLabel("Zombie", "walk_end")).toBe(123);
    expect(getFrameIndexLabel("Civilian", "idle")).toBe(0);
    expect(doesFrameLabelExist("Zombie", "climb")).toBe(true);
    expect(doesFrameLabelExist("Zombie", "nope")).toBe(false);
    expect(getNumFrames("not-a-clip")).toBe(0); // unknown → 0
  });
});

describe("GameObj animation methods", () => {
  it("cycleAnimation loops over the whole clip (Flame1: 16 frames)", () => {
    const go = new GameObj();
    go.dobjClip = "Flame1";
    go.frame = 0;
    go.frameVel = 1;
    for (let i = 0; i < 15; i++) go.cycleAnimation();
    expect(go.frame).toBe(15); // advanced to last frame
    go.cycleAnimation();
    expect(go.frame).toBe(0); // wrapped (16 ≥ 16 → -16)
  });

  it("playAnimation clamps at the final frame and reports completion", () => {
    const go = new GameObj();
    go.dobjClip = "Flame1"; // 16 frames → last = 15
    go.frame = 14;
    expect(go.playAnimation()).toBe(false); // 14→15, not past
    expect(go.frame).toBe(15);
    expect(go.playAnimation()).toBe(true); // 15→16 clamped to 15
    expect(go.frame).toBe(15);
  });

  it("setAnim + cycleAnimationEx loops a label range (Zombie walk: 95–123)", () => {
    const go = new GameObj();
    go.dobjClip = "Zombie";
    go.frameVel = 1;
    go.setAnim("walk", "walk_end");
    expect(go.minFrame).toBe(95);
    expect(go.maxFrame).toBe(123);
    expect(go.frame).toBe(95);
    for (let i = 0; i < 28; i++) go.cycleAnimationEx(); // 95 → 123
    expect(go.frame).toBe(123);
    go.cycleAnimationEx(); // 124 > 123 → wrap by span (28) → 96
    expect(go.frame).toBe(96);
  });
});
