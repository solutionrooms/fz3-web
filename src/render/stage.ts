/**
 * RenderStage — boots an OpenFL Stage onto a DOM element and loads the FZ3 AssetLibrary.
 * It owns ONLY presentation plumbing (the canvas, the fixed 700×500 Flash stage, the
 * asset library). It never advances physics or game logic.
 *
 * Note on boot: OpenFL's HTML5 window only attaches its canvas when given a parent
 * element via `windowAttributes.element`, so we always pass one.
 */
import { Stage, AssetLibrary, Sprite, type AssetLibrary as AssetLibraryT } from "./openfl";

export const STAGE_WIDTH = 700;
export const STAGE_HEIGHT = 500;

export interface RenderStageOptions {
  /** Parent element the OpenFL canvas is appended to. */
  parent: HTMLElement;
  /** Path to the generated AssetLibrary manifest (e.g. "assets/fz3/library.json"). */
  libraryUrl: string;
  /** Stage background colour (RGB). Default opaque black. */
  background?: number;
}

export interface RenderStage {
  /** The OpenFL stage root (a Sprite document object) you parent render content under. */
  readonly root: Sprite;
  readonly library: AssetLibraryT;
}

/**
 * Boot the stage and resolve once the AssetLibrary has loaded. The returned `root` is the
 * document Sprite; mount a SceneRenderer under it.
 */
export function bootRenderStage(opts: RenderStageOptions): Promise<RenderStage> {
  return new Promise((resolve, reject) => {
    let root: Sprite | null = null;

    // The document class OpenFL instantiates as the stage root. Capturing `this` gives us
    // the root Sprite to mount content under.
    function Root(this: Sprite) {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      (Sprite as any).call(this);
      root = this;
    }
    Root.prototype = Object.create(Sprite.prototype);

    try {
      new Stage(STAGE_WIDTH, STAGE_HEIGHT, opts.background ?? 0x000000, Root, { element: opts.parent });
    } catch (e) {
      reject(e);
      return;
    }

    AssetLibrary.loadFromFile(opts.libraryUrl)
      .onComplete((library) => {
        if (!root) { reject(new Error("OpenFL stage root was not created")); return; }
        resolve({ root, library });
      })
      .onError((error) => reject(error instanceof Error ? error : new Error(String(error))));
  });
}
