import { describe, it, expect } from "vitest";
import {
  cameraOffset, objectTransform, screenPosition, timelineFrame, sortByDrawOrder,
} from "../../src/render/transform";
import type { RenderObj, Camera } from "../../contracts/render-state";

function obj(p: Partial<RenderObj>): RenderObj {
  return {
    dobj: "X", frame: 0, xpos: 0, ypos: 0, dir: 0, scale: 1, xflip: false, zpos: 0, alpha: 1,
    ...p,
  };
}

describe("render transform (contract math)", () => {
  it("pixel-snaps camera offset by rounding", () => {
    expect(cameraOffset({ x: 10.4, y: -3.6, scale: 1 })).toEqual({ x: -10, y: 4 });
  });

  it("screenPosition = round(world) - round(camera), per object", () => {
    const cam: Camera = { x: 100.6, y: 50.4, scale: 1 };
    // round(283.5)=284, round(100.6)=101 → 183 ; round(296.5)=297(banker? no, Math.round=297), round(50.4)=50 → 247
    expect(screenPosition(obj({ xpos: 283.5, ypos: 296.5 }), cam)).toEqual({ x: 284 - 101, y: 297 - 50 });
  });

  it("container offset + object x equals the absolute screen formula", () => {
    const cam: Camera = { x: 12.7, y: 8.2, scale: 1 };
    const o = obj({ xpos: 200.3, ypos: 99.9 });
    const off = cameraOffset(cam);
    const t = objectTransform(o);
    expect({ x: off.x + t.x, y: off.y + t.y }).toEqual(screenPosition(o, cam));
  });

  it("converts dir (radians) to degrees", () => {
    expect(objectTransform(obj({ dir: Math.PI })).rotationDeg).toBeCloseTo(180, 10);
    expect(objectTransform(obj({ dir: Math.PI / 2 })).rotationDeg).toBeCloseTo(90, 10);
  });

  it("xflip negates scaleX only", () => {
    const t = objectTransform(obj({ scale: 2, xflip: true }));
    expect(t.scaleX).toBe(-2);
    expect(t.scaleY).toBe(2);
  });

  it("maps 0-based frame to 1-based SWF timeline frame", () => {
    expect(timelineFrame(0)).toBe(1);
    expect(timelineFrame(15)).toBe(16);
  });

  it("sorts by zpos DESCENDING, stable on ties (highest = back, painted first)", () => {
    const a = obj({ dobj: "a", zpos: 10 });
    const b = obj({ dobj: "b", zpos: 50 });
    const c = obj({ dobj: "c", zpos: 50 });
    const d = obj({ dobj: "d", zpos: 5 });
    const order = sortByDrawOrder([a, b, c, d]).map((o) => o.dobj);
    // 50s first (b before c — stable), then 10, then 5
    expect(order).toEqual(["b", "c", "a", "d"]);
  });

  it("does not mutate the input array", () => {
    const input = [obj({ dobj: "a", zpos: 1 }), obj({ dobj: "b", zpos: 2 })];
    const snapshot = input.map((o) => o.dobj);
    sortByDrawOrder(input);
    expect(input.map((o) => o.dobj)).toEqual(snapshot);
  });
});
