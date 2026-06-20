// Camera.as — the game-side follow camera. Produces the scroll position (top-left of the view in world
// coords) that the contract's `camera` field carries; the renderer applies it (screen = round(world) −
// round(camera)). Pure view logic (NOT Prime-Directive-bound): the lookahead uses trig and the shake
// uses RNG — both cosmetic, neither affects the simulation.

import { Defs } from "./defs";
import { getLength, limitNumber, scaleTo, randBetweenInt, randBetweenFloat } from "./util/utils";

const NO_BOUND = 12345678; // ResetBounds sentinel

export class Camera {
  x = 0;
  y = 0;
  oldX = 0;
  oldY = 0;
  cx = 0;
  cy = 0;
  maxX = 0;
  maxY = 0;
  minX = 0;
  minY = 0;
  toDX = 0;
  toDY = 0;
  scale = 1;
  savedx = 0;
  savedy = 0;

  // static shake state (Camera.as) — cosmetic
  static shakeCamToX = 0;
  static shakeCamToY = 0;
  static shakeCamX = 0;
  static shakeCamY = 0;
  static shakeCamDX = 0;
  static shakeCamDY = 0;
  static shakeCamTimer = 50;
  static shakeCamTimerMax = 50;

  constructor() {
    this.reset();
  }

  reset(): void {
    this.x = 0;
    this.y = 0;
    this.oldX = 0;
    this.oldY = 0;
    this.cx = 0;
    this.cy = 0;
    this.maxX = this.minX = 0;
    this.maxY = this.minY = 0;
    this.toDX = this.toDY = 0;
    this.scale = 1;
  }

  resetBounds(): void {
    this.minX = NO_BOUND;
    this.maxX = NO_BOUND;
    this.minY = NO_BOUND;
    this.maxY = NO_BOUND;
  }

  pushPos(): void {
    this.savedx = this.x;
    this.savedy = this.y;
  }

  popPos(): void {
    this.x = this.savedx;
    this.y = this.savedy;
  }

  /**
   * Camera.UpdatePosition — centre `target` at view (320,240) with a velocity-based lookahead
   * (smoothed), clamped to the level bounds when set. `vel` is the followed body's velocity.
   */
  updatePosition(targetX: number, targetY: number, velX: number, velY: number): void {
    this.oldX = this.x;
    this.oldY = this.y;
    const offX = 320;
    const offY = 240;
    this.cx = targetX;
    this.cy = targetY;
    const angle = Math.atan2(velY, velX);
    let len = getLength(velX, velY); // length-SQUARED (Utils.GetLength quirk)
    let dx: number;
    let dy: number;
    if (len < 3) {
      dx = 0;
      dy = 0;
    } else {
      len = limitNumber(3, 10, len);
      const mag = scaleTo(0, 150, 0, 30, len);
      dx = Math.cos(angle) * mag;
      dy = Math.sin(angle) * mag;
    }
    this.toDX += (dx - this.toDX) * 0.1;
    this.toDY += (dy - this.toDY) * 0.1;
    this.x = targetX - offX + this.toDX;
    this.y = targetY - offY + this.toDY;
    if (this.minX !== NO_BOUND && this.minY !== NO_BOUND) {
      if (this.x < this.minX) this.x = this.minX;
      if (this.y < this.minY) this.y = this.minY;
      if (this.x > this.maxX - Defs.displayarea_w) this.x = this.maxX - Defs.displayarea_w;
      if (this.y > this.maxY - Defs.displayarea_h) this.y = this.maxY - Defs.displayarea_h;
    }
    this.scale = 1;
  }

  /** Camera.UpdateShakeCam — cosmetic screen shake (random walk toward a target offset). */
  static updateShakeCam(intensity: number): void {
    --Camera.shakeCamTimer;
    if (Camera.shakeCamTimer <= 0) {
      Camera.shakeCamTimer = randBetweenInt(5, 20);
      Camera.shakeCamTimerMax = Camera.shakeCamTimer;
      const m = scaleTo(2, 20, 0, 30, intensity);
      Camera.shakeCamToX = randBetweenFloat(-m, m);
      Camera.shakeCamToY = randBetweenFloat(-m, m);
      Camera.shakeCamDX = (Camera.shakeCamToX - Camera.shakeCamX) / Camera.shakeCamTimer;
      Camera.shakeCamDY = (Camera.shakeCamToY - Camera.shakeCamY) / Camera.shakeCamTimer;
    }
    Camera.shakeCamX += Camera.shakeCamDX;
    Camera.shakeCamY += Camera.shakeCamDY;
  }
}
