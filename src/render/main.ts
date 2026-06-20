/**
 * Render-layer web entry. Boots the OpenFL stage, loads the FZ3 AssetLibrary, and draws
 * the authoritative `RenderFrame` produced by the game layer
 * (`src/game/game-objects.ts` → `data/render-frames/*.json`). The renderer only reads the
 * snapshot and draws — it never advances the simulation. Once the engine can step (m4) and
 * the game wires `syncFromWorld`, the producer emits live frames and this consumes them
 * unchanged (positions are already authoritative; MovieClip animation frames arrive with
 * the GameObj behavior port).
 */
import { bootRenderStage, STAGE_WIDTH, STAGE_HEIGHT } from "./stage";
import { SceneRenderer } from "./scene-renderer";
import { BackgroundLayer, type BackgroundSpec } from "./background";
import { letterbox } from "./letterbox";
import type { RenderFrame } from "../../contracts/render-state";
import intro1 from "../../data/render-frames/intro1.json";
import levels from "../../data/levels.json";

const LIBRARY_URL = "assets/fz3/library.json";
const FRAME = intro1 as unknown as RenderFrame;

// TEMP (dev entry only): the backdrop comes from the level's 1-based `bg` field
// (GameObj.InitBackground → `background01`, frame bg-1, screen-fixed). Until the producer
// emits it on the frame (proposed `RenderFrame.background?`), the entry reads it from level
// data for the Intro 1 preview. Swap to `FRAME.background` when that contract field lands.
const INTRO1_BG: BackgroundSpec = { dobj: "background01", frame: Number((levels as any)[0].bg) - 1 };

interface SpikeWindow extends Window {
  __renderReady?: boolean;
  __renderStats?: unknown;
}
declare const window: SpikeWindow;

async function main(): Promise<void> {
  const mount = (document.getElementById("stage") ?? document.body) as HTMLElement;

  // Scale the fixed 700×500 stage to fit the window (letterbox bars = page background).
  letterbox(mount, STAGE_WIDTH, STAGE_HEIGHT);

  const stage = await bootRenderStage({ parent: mount, libraryUrl: LIBRARY_URL, background: 0x000000 });

  // Background first (added to root → painted behind), then the camera-transformed world.
  const background = new BackgroundLayer(stage.library, stage.root as never);
  background.set(INTRO1_BG);

  const scene = new SceneRenderer(stage.library, stage.root as never);
  scene.render(FRAME);

  // Thin dev hook: lets headless tooling drive arbitrary RenderFrames against the live
  // scene (e.g. to verify the additive-blend / colorTransform paths). Not used by the app.
  (window as unknown as { __renderFrame?: (f: RenderFrame) => void }).__renderFrame =
    (f: RenderFrame) => scene.render(f);

  window.__renderStats = { objects: FRAME.objects.length, missingSymbols: scene.missingSymbols };
  window.__renderReady = true;
  console.log(
    `[render] consumed authoritative RenderFrame: ${FRAME.objects.length} objects; ` +
    `missing symbols: ${scene.missingSymbols.join(",") || "none"}`,
  );
}

main().catch((e) => {
  console.error("[render] FATAL:", e);
  (window as SpikeWindow).__renderReady = true; // unblock the headless waiter even on error
});
