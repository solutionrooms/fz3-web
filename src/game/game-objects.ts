// GameObjects — the display/view layer: builds a level's GameObjs (faithful routing + display from the
// physobj graphics), syncs physics objects from the live world, and emits the authoritative RenderFrame
// the render layer consumes (contracts/render-state.ts).
//
// SCOPE: this is the DISPLAY subset of GameObj/GameObj_Base. The full per-object behavior (the
// init-function state machines that drive animation frames, spawning, etc.) is a later port; until then
// objects use their physobj's static graphic, which is correct for the initial layout and goes dynamic
// (position/angle) automatically via syncFromWorld once the engine can step.

import { degToRad } from "./util/utils";
import type { Level } from "./model/level";
import { type PhysObjs, type PhysObj } from "./model/phys-obj-def";
import type { BuiltWorld } from "./physics/build-world";
import { applyInitFunction } from "./behaviors/registry";
import type { b2Body } from "../box2d/index";
import type { RenderFrame, RenderObj, Camera } from "../../contracts/render-state";

const P2W = 50; // PhysicsBase.p2w  (world units → pixels)

/** Display + behavior state of a game object (subset; see SCOPE note above). */
export class GameObj {
  active = true;
  visible = true;
  id = "";
  name = "";
  type = "";
  xpos = 0; // pixels
  ypos = 0;
  zpos = 0;
  dir = 0; // radians
  scale = 1;
  xflip = false;
  dobjClip = ""; // SWF linkage/clip name == contract `dobj`
  frame = 0; // 0-based
  alpha = 1;
  isPhysObj = false;
  bodyIndex = -1; // index into BuiltWorld.bodies (physics objects only)

  // behavior (GameObj/GameObj_Base)
  state = 0;
  timer = 0;
  timerMax = 0;
  killed = false;
  sortByY = false;
  updateFn: (() => void) | null = null;
  removeFn: (() => void) | null = null;
  body: b2Body | null = null; // set by linkBodies (for the per-frame WakeUp)
  initParams = "";
  initFunctionVarString = "";

  /** GameObj.Update (GameObj_Base.as:782): wake the body, run the behavior, optional Y-depth sort. */
  update(): void {
    if (this.body != null) this.body.WakeUp(); // AS3: bodies[0].WakeUp() — keeps active physobjs awake
    if (this.updateFn != null) this.updateFn();
    if (this.sortByY) this.zpos = 0 - this.ypos * 0.01;
  }
}

// Game.InitLevelPlayFromEditorObjects routing: physics (AddPhysObjAt) iff bodies>0 AND no top-level
// graphics; otherwise AddGameObjectAt (decoration, no body).
function routePhysics(def: PhysObj): boolean {
  return def.bodies.length > 0 && def.graphics.length === 0;
}

/**
 * Build a level's GameObjs (initial layout). Decoration objects draw their top-level graphic[0]
 * (zpos = zoffset + zsortoffset); physics objects draw bodies[0].graphic[0] (zpos = zoffset). The
 * per-instance zsortoffset (+0.01) breaks z-ties by creation order, exactly as the framework.
 * `bodyIndex` links physics objects to BuiltWorld.bodies (created in the same physics-instance order).
 */
export function buildGameObjects(level: Level, lib: PhysObjs): GameObj[] {
  const out: GameObj[] = [];
  let zsortoffset = 0;
  let physicsBodyIndex = 0; // BuiltWorld creates instance bodies first, in this order
  for (const inst of level.instances) {
    const def = lib.findByName(inst.typeName);
    if (def == null) {
      zsortoffset += 0.01;
      continue;
    }
    const physics = routePhysics(def);
    const graphic = physics ? def.bodies[0].graphics[0] : def.graphics[0];
    if (graphic == null) {
      // nothing to draw yet (visual comes from the init-function at runtime — later port)
      if (physics) physicsBodyIndex++; // it still made a body in BuiltWorld
      zsortoffset += 0.01;
      continue;
    }
    const go = new GameObj();
    go.type = inst.typeName;
    go.id = inst.id;
    go.xpos = inst.x;
    go.ypos = inst.y;
    go.dir = degToRad(inst.rot);
    go.scale = inst.scale;
    go.dobjClip = graphic.graphicName;
    go.frame = graphic.frame;
    go.isPhysObj = physics;
    go.zpos = physics ? graphic.zoffset : graphic.zoffset + zsortoffset;
    if (physics) go.bodyIndex = physicsBodyIndex++;
    // go.initParams (the obj's params string) plumbs through when behaviors actually consume it — TODO
    applyInitFunction(go, def.initFunctionName); // go[physobj.initFunctionName]() — no-op if unported
    out.push(go);
    zsortoffset += 0.01;
  }
  return out;
}

/** Link physics GameObjs to their b2Body (for the per-frame WakeUp); call after building both. */
export function linkBodies(gameObjs: GameObj[], world: BuiltWorld): void {
  for (const go of gameObjs) {
    if (go.isPhysObj && go.bodyIndex >= 0 && go.bodyIndex < world.bodies.length) {
      go.body = world.bodies[go.bodyIndex];
    }
  }
}

/** GameObjects.Update (GameObjects.as:259): run each active object's per-frame update. */
export function updateGameObjects(gameObjs: GameObj[]): void {
  for (const go of gameObjs) if (go.active) go.update();
}

/** GameObjects.UpdateGOsFromPhysics (default path): xpos/ypos = body.position × p2w, dir = body.angle. */
export function syncFromWorld(gameObjs: GameObj[], world: BuiltWorld): void {
  for (const go of gameObjs) {
    if (!go.isPhysObj || go.bodyIndex < 0 || go.bodyIndex >= world.bodies.length) continue;
    const p = world.bodies[go.bodyIndex].GetPosition();
    go.xpos = p.x * P2W;
    go.ypos = p.y * P2W;
    go.dir = world.bodies[go.bodyIndex].GetAngle();
  }
}

/**
 * Emit the authoritative RenderFrame (contracts/render-state.ts). Objects are emitted in stable creation
 * order; the renderer z-sorts descending by zpos. `colorTransform` is left undefined (vector-path objects
 * are untinted; the bitmap/CT tint path lands with the behavior port).
 */
export function toRenderFrame(gameObjs: GameObj[], camera: Camera = { x: 0, y: 0, scale: 1 }): RenderFrame {
  const objects: RenderObj[] = [];
  for (const go of gameObjs) {
    if (!go.active || !go.visible) continue;
    objects.push({
      dobj: go.dobjClip,
      frame: go.frame,
      xpos: go.xpos,
      ypos: go.ypos,
      dir: go.dir,
      scale: go.scale,
      xflip: go.xflip,
      zpos: go.zpos,
      alpha: go.alpha,
    });
  }
  return { objects, camera, stage: { width: 700, height: 500 } };
}
