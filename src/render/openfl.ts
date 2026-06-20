/**
 * Typed facade over OpenFL (the `openfl` npm package, 9.5.x).
 *
 * Runtime: OpenFL's UMD bundle is loaded as a global `<script>` (see index.html) and
 * exposes the nested namespace `window.openfl` (`openfl.display.Stage`, `openfl.geom.*`,
 * …) — the exact surface the spike proved renders FZ3.swf. It is loaded as a global
 * because the UMD's internal webpack runtime breaks if an ESM bundler (Vite/esbuild)
 * re-optimises it. Types: OpenFL ships real `.d.ts` per submodule (each `export default`s
 * its class), pulled in via `import type` — fully erased at build, so this stays
 * decoupled from the bundler. This is the ONLY file that knows how OpenFL is wired.
 */
import type StageT from "openfl/display/Stage";
import type SpriteT from "openfl/display/Sprite";
import type MovieClipT from "openfl/display/MovieClip";
import type DisplayObjectT from "openfl/display/DisplayObject";
import type DisplayObjectContainerT from "openfl/display/DisplayObjectContainer";
import type ColorTransformT from "openfl/geom/ColorTransform";
import type AssetLibraryT from "openfl/utils/AssetLibrary";
import type BlendModeT from "openfl/display/BlendMode";

// The UMD namespace is loosely typed (it's a generated bundle); we re-expose the
// handful of classes the render layer uses, each cast to its real shipped type.
const ofl: any = (globalThis as any).openfl;
if (!ofl) {
  throw new Error("OpenFL global not found — ensure vendor/openfl.js is loaded before the app module.");
}

// Re-export the OpenFL types under clean names (type + value declaration-merge, so
// `Stage` is usable as both a type annotation and a constructor).
export type Stage = StageT;
export type Sprite = SpriteT;
export type MovieClip = MovieClipT;
export type DisplayObject = DisplayObjectT;
export type DisplayObjectContainer = DisplayObjectContainerT;
export type ColorTransform = ColorTransformT;
export type AssetLibrary = AssetLibraryT;

export const Stage = ofl.display.Stage as {
  new (
    width?: number,
    height?: number,
    color?: number,
    documentClass?: unknown,
    windowAttributes?: unknown,
  ): StageT;
};

export const Sprite = ofl.display.Sprite as { new (): SpriteT };

export const ColorTransform = ofl.geom.ColorTransform as {
  new (
    redMultiplier?: number, greenMultiplier?: number, blueMultiplier?: number, alphaMultiplier?: number,
    redOffset?: number, greenOffset?: number, blueOffset?: number, alphaOffset?: number,
  ): ColorTransformT;
};

/** Minimal shape of the lime `Future` returned by the AssetLibrary loaders. */
export interface OpenFLFuture<T> {
  onComplete(cb: (value: T) => void): OpenFLFuture<T>;
  onError(cb: (error: unknown) => void): OpenFLFuture<T>;
  onProgress?(cb: (loaded: number, total: number) => void): OpenFLFuture<T>;
}

export const AssetLibrary = ofl.utils.AssetLibrary as {
  loadFromFile(path: string, rootPath?: string): OpenFLFuture<AssetLibraryT>;
};

export const BlendMode = ofl.display.BlendMode as { ADD: BlendModeT; NORMAL: BlendModeT };
export const Event = ofl.events.Event as { ENTER_FRAME: string };
