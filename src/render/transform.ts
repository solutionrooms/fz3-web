/**
 * Pure world→screen / object-transform math for the render layer, derived line-by-line
 * from `contracts/render-state.ts` (which itself mirrors DisplayObj.as / GameObj.as /
 * Camera.as). Kept free of any OpenFL dependency so it is unit-testable in plain Node.
 *
 * Conventions reproduced exactly:
 *   - Per-object pixel snapping: screen = round(world) − round(camera)  (GameObj.Render).
 *   - `dir` is RADIANS; OpenFL `rotation` is DEGREES → convert.
 *   - Transform build order flip → rotate → scale → translate collapses, for a
 *     display-list object, to: scaleX = xflip ? −scale : scale, scaleY = scale.
 */
import type { RenderObj, Camera } from "../../contracts/render-state";

const RAD_TO_DEG = 180 / Math.PI;

/** Container offset that realises the round-snapped camera (subtracted from world). */
export function cameraOffset(camera: Camera): { x: number; y: number } {
  return { x: -Math.round(camera.x), y: -Math.round(camera.y) };
}

export interface ObjectTransform {
  x: number;
  y: number;
  rotationDeg: number;
  scaleX: number;
  scaleY: number;
}

/**
 * Local transform for an object placed under the camera container. Combined with
 * `cameraOffset`, the object's stage position equals the contract's
 * `round(world) − round(camera)`.
 */
export function objectTransform(o: RenderObj): ObjectTransform {
  return {
    x: Math.round(o.xpos),
    y: Math.round(o.ypos),
    rotationDeg: o.dir * RAD_TO_DEG,
    scaleX: o.xflip ? -o.scale : o.scale,
    scaleY: o.scale,
  };
}

/** Absolute pixel-snapped screen position (container + object), per the contract formula. */
export function screenPosition(o: RenderObj, camera: Camera): { x: number; y: number } {
  return {
    x: Math.round(o.xpos) - Math.round(camera.x),
    y: Math.round(o.ypos) - Math.round(camera.y),
  };
}

/** SWF timeline frame for a 0-based contract frame (AS3 does gotoAndStop(frame + 1)). */
export function timelineFrame(frame: number): number {
  return frame + 1;
}

/**
 * Draw order: sort a COPY by `zpos` DESCENDING and paint in that order — highest zpos
 * is backmost, lowest is on top (GameObjects.Render). Returns a new array; ties keep
 * their original relative order (stable sort).
 */
export function sortByDrawOrder<T extends { zpos: number }>(objects: readonly T[]): T[] {
  return objects.map((o, i) => [o, i] as const)
    .sort((a, b) => (b[0].zpos - a[0].zpos) || (a[1] - b[1]))
    .map(([o]) => o);
}
