// Verifies the render layer's additive-blend and ColorTransform paths against the live
// OpenFL scene. Drives synthesized RenderFrames via the dev hook window.__renderFrame
// (real FZ3 symbols: Flame1 for additive, Anvil for tint), then measures mean RGB from
// compositor-level screenshots (OpenFL's WebGL buffer isn't readable in-page) to assert:
//   (1) additive-blended overlapping flames are brighter than normal-blended;
//   (2) a red ColorTransform shifts the red channel.
// A/B frames use identical positions, so the only variable is the blend/tint.
import puppeteer from "puppeteer";
import { PNG } from "pngjs";

const URL = "http://localhost:5173/";
const OUT = process.env.RENDER_OUT || "/tmp/fz3-blend.png";

const browser = await puppeteer.launch({
  headless: "new",
  args: ["--no-sandbox", "--enable-unsafe-swiftshader", "--use-gl=angle", "--use-angle=swiftshader",
         "--ignore-gpu-blocklist", "--window-size=760,560"],
});
const page = await browser.newPage();
await page.setViewport({ width: 760, height: 560 });
page.on("pageerror", (e) => console.log("PAGEERROR:", e.message));

await page.goto(URL, { waitUntil: "networkidle2", timeout: 60000 });
for (let i = 0; i < 60; i++) {
  if (await page.evaluate(() => !!window.__renderReady)) break;
  await new Promise((r) => setTimeout(r, 500));
}

await page.evaluate(() => {
  window.__flame = (x, y, add) => ({
    dobj: "Flame1", frame: 6, xpos: x, ypos: y, dir: 0, scale: 3, xflip: false, zpos: 10, alpha: 1,
    ...(add ? { blend: "add" } : {}),
  });
  window.__anvil = (x, y, ct) => ({
    dobj: "Anvil", frame: 0, xpos: x, ypos: y, dir: 0, scale: 3, xflip: false, zpos: 5, alpha: 1,
    ...(ct ? { colorTransform: ct } : {}),
  });
  window.__render = (objects) =>
    window.__renderFrame({ objects, camera: { x: 0, y: 0, scale: 1 }, stage: { width: 700, height: 500 } });
});

const el = await page.$("#stage");
const render = (js) => page.evaluate((src) => window.__render(eval(src)), js); // eslint-disable-line no-eval
const meanRGB = async () => {
  const png = PNG.sync.read(Buffer.from(await el.screenshot()));
  let r = 0, g = 0, b = 0; const n = png.width * png.height;
  for (let i = 0; i < png.data.length; i += 4) { r += png.data[i]; g += png.data[i + 1]; b += png.data[i + 2]; }
  return { r: r / n, g: g / n, b: b / n, lum: (0.299 * r + 0.587 * g + 0.114 * b) / n };
};

// --- Additive: two overlapping flames, normal vs additive (identical positions) ---
await render(`[window.__flame(335,250,false), window.__flame(370,250,false)]`);
const normalFlames = await meanRGB();
await render(`[window.__flame(335,250,true), window.__flame(370,250,true)]`);
const addFlames = await meanRGB();

// --- Tint: same anvil, untinted vs red ColorTransform ---
const RED = `{redMultiplier:1,greenMultiplier:0.15,blueMultiplier:0.15,alphaMultiplier:1,redOffset:90,greenOffset:0,blueOffset:0,alphaOffset:0}`;
await render(`[window.__anvil(330,250,null)]`);
const plain = await meanRGB();
await render(`[window.__anvil(330,250,${RED})]`);
const tinted = await meanRGB();

// --- Showcase screenshot ---
await render(`[
  window.__flame(90,150,false),
  window.__flame(250,150,true),
  window.__flame(430,150,true), window.__flame(465,150,true),
  window.__anvil(120,350,null),
  window.__anvil(300,350,${RED}),
  window.__anvil(480,350,{redMultiplier:0.2,greenMultiplier:0.4,blueMultiplier:1,alphaMultiplier:1,redOffset:0,greenOffset:0,blueOffset:120,alphaOffset:0})
]`);
await el.screenshot({ path: OUT });

const addBrighter = addFlames.lum > normalFlames.lum + 1;
const tintRedShift = (tinted.r - tinted.g) > (plain.r - plain.g) + 2;
console.log("ADDITIVE  normal.lum=%s  additive.lum=%s  -> brighter:%s",
  normalFlames.lum.toFixed(2), addFlames.lum.toFixed(2), addBrighter);
console.log("TINT      plain(R-G)=%s  tinted(R-G)=%s  -> redder:%s",
  (plain.r - plain.g).toFixed(2), (tinted.r - tinted.g).toFixed(2), tintRedShift);
console.log("screenshot ->", OUT);
console.log(addBrighter && tintRedShift ? "VERIFY: PASS" : "VERIFY: FAIL");

await browser.close();
process.exit(addBrighter && tintRedShift ? 0 : 1);
