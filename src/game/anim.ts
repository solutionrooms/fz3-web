// Clip animation table (data/anim.json: clip → timeline frame count + frame labels), the data behind
// DisplayObj.GetNumFrames / GetFrameIndexLabel. Loaded once at startup via setAnimData; the GameObj
// animation methods (cycleAnimation/playAnimation/setAnim) read it. Animation is time/state-driven
// (not physics) — so it's visible without the engine stepping.

import type { Anim } from "../../contracts/game-data";

let animData: Anim = {};

/** Install the clip animation table (data/anim.json). */
export function setAnimData(data: Anim): void {
  animData = data;
}

/** DisplayObj.GetNumFrames — total timeline frames of a clip (0 if unknown). */
export function getNumFrames(clip: string): number {
  return animData[clip]?.frames ?? 0;
}

/** DisplayObj.GetFrameIndexLabel — 0-based frame of a named label (AS3 traces + returns 0 on miss). */
export function getFrameIndexLabel(clip: string, label: string): number {
  const c = animData[clip];
  if (c) for (const l of c.labels) if (l.name === label) return l.frame;
  return 0;
}

/** DisplayObj.DoesFrameIndexLabelExist. */
export function doesFrameLabelExist(clip: string, label: string): boolean {
  const c = animData[clip];
  return c ? c.labels.some((l) => l.name === label) : false;
}
