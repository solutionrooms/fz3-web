/**
 * Render-layer web entry. Boots the OpenFL stage, loads the FZ3 AssetLibrary, and draws
 * the authoritative `RenderFrame` produced by the game layer
 * (`src/game/game-objects.ts` → `data/render-frames/*.json`). The renderer only reads the
 * snapshot and draws — it never advances the simulation. Once the engine can step (m4) and
 * the game wires `syncFromWorld`, the producer emits live frames and this consumes them
 * unchanged (positions are already authoritative; MovieClip animation frames arrive with
 * the GameObj behavior port).
 */
import { bootRenderStage } from "./stage";
import { SceneRenderer } from "./scene-renderer";
import type { RenderFrame } from "../../contracts/render-state";
import intro1 from "../../data/render-frames/intro1.json";

const LIBRARY_URL = "assets/fz3/library.json";
const FRAME = intro1 as unknown as RenderFrame;

interface SpikeWindow extends Window {
  __renderReady?: boolean;
  __renderStats?: unknown;
}
declare const window: SpikeWindow;

async function main(): Promise<void> {
  const mount = (document.getElementById("stage") ?? document.body) as HTMLElement;

  const stage = await bootRenderStage({ parent: mount, libraryUrl: LIBRARY_URL, background: 0x6db3e8 });
  const scene = new SceneRenderer(stage.library, stage.root as never);
  scene.render(FRAME);

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
