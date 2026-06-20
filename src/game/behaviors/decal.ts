import type { GameObj } from "../game-objects";

// GameObj.InitDecal (GameObj.as:4696): name + a per-frame update that is a no-op in the FZ3 build
// (UpdateDecal is `if(state==0){}`). Trivial, but the first real behavior through the registry.
export function initDecal(go: GameObj): void {
  go.name = "decal";
  go.updateFn = () => updateDecal(go);
}

function updateDecal(_go: GameObj): void {
  // GameObj.UpdateDecal — no-op
}
