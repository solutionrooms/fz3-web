/**
 * Render-layer web entry (DEV harness). Boots the OpenFL stage, loads the FZ3
 * AssetLibrary, and renders a demo RenderFrame built from real level data — proving the
 * contract→OpenFL display path end-to-end. The real app will receive RenderFrames from
 * the game loop instead of the demo builder; nothing here advances the simulation.
 */
import { bootRenderStage } from "./stage";
import { SceneRenderer } from "./scene-renderer";
import { buildDemoFrame } from "./demo/build-demo-frame";
import levels from "../../data/levels.json";
import physobjs from "../../data/physobjs.json";

const LIBRARY_URL = "assets/fz3/library.json";

interface SpikeWindow extends Window {
  __renderReady?: boolean;
  __renderStats?: unknown;
}
declare const window: SpikeWindow;

async function main(): Promise<void> {
  const mount = document.getElementById("stage") ?? document.body;

  const levelIndex = Number(new URLSearchParams(location.search).get("level") ?? "0");
  const level = (levels as any[])[levelIndex];

  const { frame, stats } = buildDemoFrame(level as any, physobjs as any);
  console.log(
    `[render] demo level ${levelIndex} "${level?.name}": ` +
    `${stats.instances} instances → ${stats.emitted} draw objects` +
    (stats.missingPhysObj.length ? `; missing physobj: ${stats.missingPhysObj.join(",")}` : "") +
    (stats.noGraphics.length ? `; no-graphics: ${stats.noGraphics.join(",")}` : ""),
  );

  const stage = await bootRenderStage({ parent: mount as HTMLElement, libraryUrl: LIBRARY_URL, background: 0x6db3e8 });
  const scene = new SceneRenderer(stage.library, stage.root as any);
  scene.render(frame);

  window.__renderStats = { ...stats, missingSymbols: scene.missingSymbols };
  window.__renderReady = true;
  console.log(`[render] rendered. missing symbols: ${scene.missingSymbols.join(",") || "none"}`);
}

main().catch((e) => {
  console.error("[render] FATAL:", e);
  (window as SpikeWindow).__renderReady = true; // unblock the headless waiter even on error
});
