import { Defs } from "../defs";
import type { LevelObjInstance } from "./level-obj-instance";
import type { PhysObjJoint } from "./phys-obj-joint";
import { PhysLine } from "./phys-line";

/**
 * Port of LevelBase.as + Level.as. Field set is faithful to the source (incl. some fields vestigial in
 * FZ3 — they come from sibling games sharing this framework). The loader populates the level-data
 * subset; progression/save fields (available/complete/rating/best*) are runtime state set elsewhere.
 */
export class Level {
  // identity / data
  id = "";
  name = "";
  description = "";
  category = 0;
  bgFrame = 0;
  music = 0;
  creator = "";

  // level contents (populated by the loader)
  instances: LevelObjInstance[] = [];
  joints: PhysObjJoint[] = [];
  lines: PhysLine[] = [];
  helpscreenFrames: number[] = [];

  // spatial map grid
  map: number[] = [];
  mapCellW = 16;
  mapCellH = 16;
  mapMinX = 0;
  mapMinY = 0;
  mapMaxX = 0;
  mapMaxY = 0;

  // surface / fill (render)
  fillFrame = 1;
  surfaceFrame = 5;
  surfaceThickness = 10;

  // Level.as
  gold_score = 0;

  // progression / save state (runtime; not set by the loader)
  played = false;
  available = false;
  complete = false;
  fullyLoaded = false;
  hasHitRef = false;
  numRockets = 0;
  exclusiveChar = 1;
  bestScore = 0;
  levelScore = 0;
  percentage = 0;
  bestPercentage = 0;
  rating = 0;
  lastTime = 9999999;
  lastTimeTotal = 9999999;
  bestTime = 9999999;
  bestTimeTotal = 9999999;
  goldTime = 10 * Defs.fps;
  silverTime = 20 * Defs.fps;
  levelFunctionName = "";

  // vestigial in FZ3 (race/AI/event fields from sibling games) — kept for fidelity
  eventType = "none";
  eventOpponentsString = "";
  eventWinParam = 1;
  aiCarMaxSpeed = 0;
  aiCarMinSpeed = 0;
  raceType = "";
  aiCarTypeString = "";

  /** LevelBase.Calculate — a no-op in the FZ3 build. */
  calculate(): void {}

  /** LevelBase.GetLineByName. */
  getLineByName(name: string): PhysLine | null {
    for (const l of this.lines) if (l.id === name) return l;
    return null;
  }
}
