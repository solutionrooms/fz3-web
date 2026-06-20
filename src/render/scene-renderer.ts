/**
 * SceneRenderer — consumes one `RenderFrame` (the game→render contract) and draws it
 * with OpenFL using approach (A) display-list: each object is a library MovieClip whose
 * transform / colorTransform / frame are set from the snapshot, parented under a camera
 * container, composited by OpenFL. It reads state and draws; it never owns game state
 * and never advances a clock — animation frames come from `RenderObj.frame` via
 * `gotoAndStop`, never `play()`, so the game's fixed 2×(1/60) loop stays the only clock.
 */
import type { RenderFrame, ColorTransformLike } from "../../contracts/render-state";
import {
  Sprite, ColorTransform, BlendMode,
  type AssetLibrary, type DisplayObjectContainer, type MovieClip,
} from "./openfl";
import { cameraOffset, objectTransform, timelineFrame, sortByDrawOrder } from "./transform";

const IDENTITY_CT = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);

function toColorTransform(ct: ColorTransformLike): ColorTransform {
  return new ColorTransform(
    ct.redMultiplier, ct.greenMultiplier, ct.blueMultiplier, ct.alphaMultiplier,
    ct.redOffset, ct.greenOffset, ct.blueOffset, ct.alphaOffset,
  );
}

export class SceneRenderer {
  /** Camera container — its offset realises the round-snapped camera; children are world objects. */
  readonly world: Sprite;

  private readonly library: AssetLibrary;
  /** Free-list of reusable instances per symbol (`dobj`). */
  private readonly pool = new Map<string, MovieClip[]>();
  /** Instances added to `world` this frame, with the symbol they came from (for recycling). */
  private active: Array<{ dobj: string; mc: MovieClip }> = [];
  /** Symbols the library couldn't resolve — logged once each so a bad `dobj` is visible, not silent. */
  private readonly missing = new Set<string>();

  constructor(library: AssetLibrary, parent: DisplayObjectContainer) {
    this.library = library;
    this.world = new Sprite();
    parent.addChild(this.world as unknown as never);
  }

  render(frame: RenderFrame): void {
    // 1. Recycle last frame's instances back into the per-symbol pools.
    for (const { dobj, mc } of this.active) {
      this.world.removeChild(mc as unknown as never);
      this.bucket(dobj).push(mc);
    }
    this.active.length = 0;

    // 2. Camera: round-snapped offset (per-object snap is preserved because each child's
    //    x/y is itself round()ed — see objectTransform).
    const cam = cameraOffset(frame.camera);
    this.world.x = cam.x;
    this.world.y = cam.y;
    const zoom = frame.camera.scale ?? 1;
    this.world.scaleX = zoom;
    this.world.scaleY = zoom;

    // 3. Paint in draw order (zpos DESC → highest backmost). addChild appends, and OpenFL
    //    paints child 0 first, so adding highest-z first puts it at the back.
    for (const o of sortByDrawOrder(frame.objects)) {
      const mc = this.acquire(o.dobj);
      if (!mc) continue;

      mc.gotoAndStop(timelineFrame(o.frame));

      const t = objectTransform(o);
      mc.x = t.x;
      mc.y = t.y;
      mc.rotation = t.rotationDeg;
      mc.scaleX = t.scaleX;
      mc.scaleY = t.scaleY;
      mc.alpha = o.alpha;

      // Tint only when present; otherwise reset (a recycled instance may carry a prior tint).
      // The original's vector path ignores ColorTransform, so `game` only sets it where the
      // original actually tints — we honour exactly what's in the snapshot.
      mc.transform.colorTransform = o.colorTransform ? toColorTransform(o.colorTransform) : IDENTITY_CT;
      mc.blendMode = o.blend === "add" ? BlendMode.ADD : BlendMode.NORMAL;

      this.world.addChild(mc as unknown as never);
      this.active.push({ dobj: o.dobj, mc });
    }
  }

  /** Resolved symbols that failed to load this session (for diagnostics). */
  get missingSymbols(): readonly string[] {
    return [...this.missing];
  }

  private bucket(dobj: string): MovieClip[] {
    let b = this.pool.get(dobj);
    if (!b) { b = []; this.pool.set(dobj, b); }
    return b;
  }

  private acquire(dobj: string): MovieClip | null {
    const reused = this.bucket(dobj).pop();
    if (reused) return reused;
    const mc = this.library.getMovieClip(dobj) as MovieClip | null;
    if (!mc) {
      if (!this.missing.has(dobj)) {
        this.missing.add(dobj);
        console.warn(`[render] no library symbol for dobj '${dobj}'`);
      }
      return null;
    }
    return mc;
  }
}
