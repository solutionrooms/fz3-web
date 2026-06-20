import type { GameObj } from "../game-objects";
import { initDecal } from "./decal";
import { initHelpText } from "./helptext";

// The behavior registry: AS3 initfunction name → TS init (mirrors `go[physobj.initFunctionName]()`).
// Objects whose initfunction isn't registered yet render statically (their body still exists; behavior
// is a later port). Add entries here as behaviors are ported, family by family.
export type BehaviorInit = (go: GameObj) => void;

export const behaviorRegistry: Record<string, BehaviorInit> = {
  InitDecal: initDecal,
  GameObj_InitHelpText: initHelpText,
  // InitPlayer_BarryZooka, InitZombie_Generic, … — TODO
};

/** Apply an object's init function if it's ported; no-op otherwise. */
export function applyInitFunction(go: GameObj, name: string | null): void {
  if (name == null) return;
  const init = behaviorRegistry[name];
  if (init != null) init(go);
}
