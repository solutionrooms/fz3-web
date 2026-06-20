/**
 * DEV HARNESS ONLY — not part of the render layer's contract surface.
 *
 * Producing the authoritative `RenderFrame` from live game state is the GAME dev's job
 * (it applies the exact AS3 conversions). This builder synthesises a *plausible* frame
 * straight from the static level/physobj data so the renderer can be exercised on real
 * symbols + placements before that producer exists. It deliberately approximates
 * (z = graphic `zoffset`, degrees→radians for rotation) and must never leak into
 * `src/render` core or be mistaken for the contract producer.
 */
import type { RenderFrame, RenderObj, Camera } from "../../../contracts/render-state";

interface RawGraphic { clip: string; frame: string; pos: string; rot: string; zoffset: string }
interface RawBody { pos: string; graphic: RawGraphic[] }
interface RawPhysObj { name: string; graphics: RawGraphic[]; bodies?: RawBody[] }
interface RawLevelObj { type: string; x: string; y: string; rot: string; scale: string }
interface RawObjGroup { objs: RawLevelObj[] }
interface RawLevel { id: string; name: string; objgroups: RawObjGroup[] }

const DEG_TO_RAD = Math.PI / 180;

/** Rotate a local offset by `rad` (mirrors AddPhysObjAt's `m.transformPoint(bodyOff)`). */
function rotate(p: { x: number; y: number }, rad: number): { x: number; y: number } {
  const c = Math.cos(rad), s = Math.sin(rad);
  return { x: p.x * c - p.y * s, y: p.x * s + p.y * c };
}

function num(s: string | undefined, fallback = 0): number {
  const n = parseFloat(s ?? "");
  return Number.isFinite(n) ? n : fallback;
}

/** Parse a "x,y" pair string. */
function pair(s: string | undefined): { x: number; y: number } {
  const [x, y] = (s ?? "0,0").split(",");
  return { x: num(x), y: num(y) };
}

export interface DemoFrameResult {
  frame: RenderFrame;
  /** Diagnostics for the harness/report. */
  stats: { instances: number; emitted: number; missingPhysObj: string[]; noGraphics: string[] };
}

/**
 * Build a demo RenderFrame for one level. `camera` defaults to the world origin so the
 * level's initial layout maps straight onto the 700×500 stage.
 */
export function buildDemoFrame(
  level: RawLevel,
  physObjs: RawPhysObj[],
  camera: Camera = { x: 0, y: 0, scale: 1 },
): DemoFrameResult {
  const byName = new Map(physObjs.map((p) => [p.name, p]));
  const objects: RenderObj[] = [];
  const missingPhysObj = new Set<string>();
  const noGraphics = new Set<string>();
  let instances = 0;

  for (const group of level.objgroups ?? []) {
    for (const obj of group.objs ?? []) {
      instances++;
      const def = byName.get(obj.type);
      if (!def) { missingPhysObj.add(obj.type); continue; }

      // Graphics live in two places (PhysicsBase.AddPhysObjAt sources `dobj` from both):
      // the physobj's top-level `graphics[]`, and each body's `graphic[]` (offset by the
      // body's local `pos`, rotated into world by the object rotation).
      const sources: Array<{ g: RawGraphic; bodyOff: { x: number; y: number } }> = [];
      for (const g of def.graphics ?? []) sources.push({ g, bodyOff: { x: 0, y: 0 } });
      for (const b of def.bodies ?? []) {
        const bo = pair(b.pos);
        for (const g of b.graphic ?? []) sources.push({ g, bodyOff: bo });
      }
      if (!sources.length) { noGraphics.add(obj.type); continue; }

      const baseX = num(obj.x);
      const baseY = num(obj.y);
      const baseRotRad = num(obj.rot) * DEG_TO_RAD;
      const scale = num(obj.scale, 1);

      for (const { g, bodyOff } of sources) {
        const rot = rotate(bodyOff, baseRotRad);
        const off = pair(g.pos);
        objects.push({
          dobj: g.clip,
          frame: Math.max(0, num(g.frame, 1) - 1), // physobj frame is 1-based; contract is 0-based
          xpos: baseX + rot.x + off.x,
          ypos: baseY + rot.y + off.y,
          dir: baseRotRad + num(g.rot) * DEG_TO_RAD,
          scale,
          xflip: false,
          zpos: num(g.zoffset, 0),
          alpha: 1,
        });
      }
    }
  }

  return {
    frame: { objects, camera, stage: { width: 700, height: 500 } },
    stats: { instances, emitted: objects.length, missingPhysObj: [...missingPhysObj], noGraphics: [...noGraphics] },
  };
}
