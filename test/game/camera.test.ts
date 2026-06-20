import { describe, it, expect } from "vitest";
import { Camera } from "../../src/game/camera";

describe("Camera (follow + bounds)", () => {
  it("starts at reset (origin)", () => {
    const c = new Camera();
    expect([c.x, c.y, c.scale]).toEqual([0, 0, 1]);
  });

  it("centres a still target at view offset (320,240), no lookahead", () => {
    const c = new Camera();
    c.resetBounds(); // bounds unset → no clamping
    c.updatePosition(500, 400, 0, 0); // velocity 0 → no lookahead
    expect(c.x).toBe(500 - 320); // 180
    expect(c.y).toBe(400 - 240); // 160
    expect(c.scale).toBe(1);
  });

  it("adds a smoothed velocity lookahead (squared-length gate)", () => {
    const c = new Camera();
    c.resetBounds();
    // velX=3,velY=0 → getLength = 9 (squared) ≥ 3 → lookahead in +x; one step smooths 10% toward it
    c.updatePosition(0, 0, 3, 0);
    expect(c.toDX).toBeGreaterThan(0); // moved toward the lookahead target
    expect(c.x).toBeCloseTo(0 - 320 + c.toDX, 10);
  });

  it("clamps to level bounds when set", () => {
    const c = new Camera();
    c.minX = 100;
    c.minY = 100;
    c.maxX = 400;
    c.maxY = 400; // tiny world (< view) → max - displayarea is very negative → clamps x to maxX-700
    c.updatePosition(0, 0, 0, 0); // target at 0 → x would be -320, below minX(100) → clamp to 100? then maxX-700=-300...
    // min applied first (x=-320 → 100), then max (x > 400-700=-300? 100 > -300 → x = -300)
    expect(c.x).toBe(400 - 700);
    expect(c.y).toBe(400 - 500);
  });

  it("shake updates without throwing (cosmetic, non-deterministic)", () => {
    expect(() => Camera.updateShakeCam(15)).not.toThrow();
  });
});
