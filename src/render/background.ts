/**
 * BackgroundLayer — the per-level backdrop.
 *
 * Faithful model (GameObj.InitBackground / RenderBackground, GameObj.as): the background
 * is the `background01` symbol shown at frame `bgFrame-1`, drawn via `RenderDispObjAt(0,0,…)`
 * — i.e. **fixed to the screen at (0,0), bypassing the camera** (unlike world objects, which
 * scroll). So it is its own screen-fixed layer behind the camera-transformed world, not a
 * `RenderObj`. It needs exactly one datum: which frame of the background symbol to show.
 */
import { Sprite, type AssetLibrary, type DisplayObjectContainer, type MovieClip } from "./openfl";
import { timelineFrame } from "./transform";

export interface BackgroundSpec {
  /** Background symbol linkage name (FZ3: always "background01"). */
  dobj: string;
  /** 0-based frame (the level's `bg` field is 1-based → frame = bg - 1). */
  frame: number;
}

export class BackgroundLayer {
  /** Screen-fixed container — added to the stage root BEHIND the camera/world container. */
  readonly container: Sprite;

  private readonly library: AssetLibrary;
  private current: MovieClip | null = null;
  private currentDobj: string | null = null;

  constructor(library: AssetLibrary, parent: DisplayObjectContainer) {
    this.library = library;
    this.container = new Sprite();
    parent.addChild(this.container as unknown as never);
  }

  /** Set (or clear) the backdrop. Re-instantiates only when the symbol changes. */
  set(spec: BackgroundSpec | null): void {
    if (!spec) { this.clear(); return; }

    if (this.currentDobj !== spec.dobj) {
      this.clear();
      const mc = this.library.getMovieClip(spec.dobj) as MovieClip | null;
      if (!mc) { console.warn(`[render] no background symbol '${spec.dobj}'`); return; }
      mc.x = 0;
      mc.y = 0;
      this.container.addChild(mc as unknown as never);
      this.current = mc;
      this.currentDobj = spec.dobj;
    }

    if (this.current) this.current.gotoAndStop(timelineFrame(spec.frame));
  }

  private clear(): void {
    if (this.current) {
      this.container.removeChild(this.current as unknown as never);
      this.current = null;
      this.currentDobj = null;
    }
  }
}
