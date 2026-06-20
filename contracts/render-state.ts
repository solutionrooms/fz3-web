/**
 * FZ3 render-state contract  (game → render)  — v1
 * Owner: game developer. Derived line-by-line from DisplayObj.as, GameObj.as (Render paths),
 * GameObjects.as (Render loop), Camera.as. This supersedes the provisional shape in RENDER_DEV.md.
 *
 * SEPARATION OF CONCERNS
 *   The game dev produces one `RenderFrame` per displayed frame from game state. The render dev
 *   consumes it and draws. Rendering is NOT bound by the Prime Directive (visual, not physics) — but
 *   match these conventions so it looks identical to the original.
 *
 * COORDINATE / TRANSFORM CONVENTIONS  (must match the AS3 exactly)
 *   - xpos/ypos are WORLD pixels. The framework converts to screen PER OBJECT with pixel-snapping:
 *         screenX = Math.round(xpos) - Math.round(camera.x)
 *         screenY = Math.round(ypos) - Math.round(camera.y)
 *     (GameObj.Render). Replicate the round()s — they pixel-snap the art.
 *   - dir is RADIANS (AS3 builds the matrix via Matrix.rotate(dir)).
 *         ⚠ OpenFL DisplayObject.rotation is DEGREES — convert: rotationDeg = dir * 180/Math.PI.
 *   - Transform build order (DisplayObj.RenderAtRotScaled_Vector, lines 322-334):
 *         identity → if(xflip) scale(-1,1) → rotate(dir) → scale(scale,scale) → translate(screenX,screenY)
 *     For an OpenFL display-list object this equals: scaleX = xflip ? -scale : scale, scaleY = scale,
 *     rotation = dir(→deg), x = screenX, y = screenY  (registration at the symbol's origin).
 *   - frame is 0-BASED. The symbol's timeline frame is frame+1 (AS3 does gotoAndStop(frame+1)).
 *   - zpos is the draw-order key. Sort DESCENDING (Array.NUMERIC | Array.DESCENDING) and paint in that
 *     order → highest zpos is backmost, lowest zpos is frontmost (on top). (GameObjects.Render:210.)
 *   - Only active && visible objects are emitted; render still sorts by zpos.
 *
 * COLOUR / BLEND
 *   - The original has two draw paths: a VECTOR path (re-rasterises the MovieClip; ignores
 *     ColorTransform) and a BITMAP-FRAME path (blits a cached frame; supports ColorTransform + an
 *     ADDITIVE variant). In OpenFL both collapse to "draw the symbol with transform + colorTransform",
 *     so you always get vector quality + tint. Honour `blend: 'add'` with an additive blend mode.
 *   - `alpha` is separate for convenience; it equals colorTransform.alphaMultiplier when a CT is present.
 */

export interface ColorTransformLike {
  redMultiplier: number;
  greenMultiplier: number;
  blueMultiplier: number;
  alphaMultiplier: number;
  redOffset: number;
  greenOffset: number;
  blueOffset: number;
  alphaOffset: number;
}

export interface RenderObj {
  /** Symbol identity in the loaded SWF AssetLibrary. OPEN: keyed by symbol class/linkage name
   *  (string) — confirm what your swf-loader AssetLibrary exposes; I'll map GraphicObjects→that key. */
  dobj: string;
  /** Optional cross-ref: the GraphicObjects display-object index (for debugging/parity checks). */
  dobjIndex?: number;
  /** 0-based timeline frame; draw symbol frame (frame + 1). */
  frame: number;
  /** World position (px). Convert to screen with the round()-snapped camera formula above. */
  xpos: number;
  ypos: number;
  /** Rotation in RADIANS. */
  dir: number;
  /** Uniform scale. */
  scale: number;
  /** Horizontal flip (negates X before rotate/scale/translate). */
  xflip: boolean;
  /** Draw-order key; sort DESCENDING, paint in that order. */
  zpos: number;
  /** 0..1. */
  alpha: number;
  /** Optional recolour. Applied on the tinting path (and to alpha). */
  colorTransform?: ColorTransformLike;
  /** 'normal' (default) or 'add' (additive blend). */
  blend?: "normal" | "add";
}

export interface Camera {
  /** World-space top-left the camera is scrolled to (subtracted from world coords, round-snapped). */
  x: number;
  y: number;
  /** Zoom; usually 1. Reserved for zoom effects — confirm usage before relying on it. */
  scale: number;
}

export interface RenderFrame {
  /** Active && visible objects only. Render sorts by zpos descending and paints in that order. */
  objects: RenderObj[];
  camera: Camera;
  /** Fixed Flash stage; letterbox into the window. */
  stage: { width: 700; height: 500 };
}
