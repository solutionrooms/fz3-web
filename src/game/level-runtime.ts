// LevelRuntime — the per-level orchestration: owns the live Box2D world + the GameObjects, runs the
// faithful per-frame tick, and emits the RenderFrame the render layer consumes. This is the integration
// point where physics (engine), game state (game), and rendering (render) meet.

import { buildWorld, type BuiltWorld } from "./physics/build-world";
import { buildCreationPlan } from "./physics/creation-plan";
import { buildGameObjects, syncFromWorld, linkBodies, updateGameObjects, toRenderFrame, type GameObj } from "./game-objects";
import type { Level } from "./model/level";
import type { PhysObjs } from "./model/phys-obj-def";
import type { PhysObjMaterial } from "./model/phys-obj-material";
import type { RenderFrame, Camera } from "../../contracts/render-state";

export const PHYS_STEP = 1 / 60; // PhysicsBase.physStep
export const PHYS_ITERS = 5; // PhysicsBase.physNumIterations

/**
 * Faithful per-frame order — Game.UpdateGameplay (Game.as:1686). Normal play runs ONE tick per frame
 * (`fastForwardFlag` makes it 10×). Each tick:
 *   1. 2× world.Step(1/60, 5)              — gated on !UI.isInTransition (the cadence: 60Hz @ 30fps)
 *   2. GameObjects.UpdateGOsFromPhysics()  — body → GameObj (position×p2w, angle)   [ported: syncFromWorld]
 *   3. GameObjects.Update()                — per-object behavior dispatch            [TODO: behavior port]
 *   4. Collision.Update()                  — game contact logic                      [TODO: ContactListener/Collision]
 *   5. KillObjects() / DoAddList()         — object lifecycle                         [TODO]
 *   6. Particles.Update / sounds / hud / level-end tests                             [TODO]
 * The frame is then rendered (here: toRenderFrame). Steps 3–6 are stubbed for now and have no effect on
 * the simulation, so the physics + view sync are already faithful; behaviors layer on later.
 */
export function stepPhysics(world: BuiltWorld, gameObjs: GameObj[], inTransition = false): void {
  if (!inTransition) {
    world.world.Step(PHYS_STEP, PHYS_ITERS);
    world.world.Step(PHYS_STEP, PHYS_ITERS);
  }
  syncFromWorld(gameObjs, world); // GameObjects.UpdateGOsFromPhysics
  // TODO (later ports): GameObjects.Update (behaviors), Collision.Update, Kill/Add, Particles, sounds, hud.
}

/** Per-level runtime: build the world + GameObjs, tick faithfully, emit the RenderFrame. */
export class LevelRuntime {
  readonly world: BuiltWorld;
  readonly gameObjs: GameObj[];
  /** Camera.as (follow-target + shake) is ported once a gameplay follow-target exists; origin until then. */
  camera: Camera = { x: 0, y: 0, scale: 1 };

  constructor(level: Level, lib: PhysObjs, materials: PhysObjMaterial[]) {
    this.world = buildWorld(buildCreationPlan(level, lib, materials));
    this.gameObjs = buildGameObjects(level, lib);
    linkBodies(this.gameObjs, this.world); // wire GameObjs to their b2Body for the per-frame WakeUp
  }

  /** One render-frame of simulation (the UpdateGameplay tick; fastForward not modelled). */
  step(inTransition = false): void {
    stepPhysics(this.world, this.gameObjs, inTransition); // 2× Step (gated) + UpdateGOsFromPhysics
    if (!inTransition) updateGameObjects(this.gameObjs); // GameObjects.Update (gated on !isInTransition)
  }

  renderFrame(): RenderFrame {
    return toRenderFrame(this.gameObjs, this.camera);
  }
}
