// [ORIG]-vs-[PORT] render comparison harness.
//
//   node tools/render-compare.mjs <a.json> [b.json] [out.png]
//
// Each input is a RenderFrame (contracts/render-state.ts). With one frame it just renders
// it. With two it does the meaningful render-faithfulness check: an OBJECT-LEVEL diff
// (position / dobj / frame / zpos / scale / dir per object — precise, no rasteriser noise)
// AND a side-by-side render of both frames THROUGH THIS RENDERER, so a frame from an
// instrumented original ([ORIG] render-state dump) can be compared to the game producer's
// frame ([PORT]). Both panels are drawn by the same renderer, so any visual difference comes
// purely from the frame data — which is exactly what we want to surface.
//
// Assumes the Vite dev server is running (npm run dev) at :5173.
import puppeteer from "puppeteer";
import { PNG } from "pngjs";
import { readFileSync } from "node:fs";

const URL = process.env.RENDER_URL || "http://localhost:5173/";
const [aPath, bPath, outArg] = process.argv.slice(2);
if (!aPath) { console.error("usage: render-compare.mjs <a.json> [b.json] [out.png]"); process.exit(2); }
const OUT = outArg || "/tmp/fz3-compare.png";
const LABEL_A = process.env.LABEL_A || "ORIG";
const LABEL_B = process.env.LABEL_B || "PORT";
const POS_EPS = Number(process.env.POS_EPS || 0.5); // px threshold for "position differs"

const load = (p) => JSON.parse(readFileSync(p, "utf8"));
const frameA = load(aPath);
const frameB = bPath ? load(bPath) : null;

// ---------- object-level diff (no rendering needed) ----------
function diffFrames(a, b) {
  const oa = a.objects ?? [], ob = b.objects ?? [];
  const rows = [];
  const n = Math.max(oa.length, ob.length);
  let mismatches = 0;
  for (let i = 0; i < n; i++) {
    const x = oa[i], y = ob[i];
    if (!x || !y) { rows.push({ i, issue: !x ? "missing in A" : "missing in B", dobj: (x || y).dobj }); mismatches++; continue; }
    const d = {};
    if (x.dobj !== y.dobj) d.dobj = `${x.dobj}≠${y.dobj}`;
    if (Math.abs((x.xpos ?? 0) - (y.xpos ?? 0)) > POS_EPS || Math.abs((x.ypos ?? 0) - (y.ypos ?? 0)) > POS_EPS)
      d.pos = `(${x.xpos},${x.ypos})→(${y.xpos},${y.ypos})`;
    if ((x.frame ?? 0) !== (y.frame ?? 0)) d.frame = `${x.frame}→${y.frame}`;
    if (Math.abs((x.zpos ?? 0) - (y.zpos ?? 0)) > 1e-6) d.zpos = `${x.zpos}→${y.zpos}`;
    if (Math.abs((x.dir ?? 0) - (y.dir ?? 0)) > 1e-4) d.dir = `${x.dir}→${y.dir}`;
    if (Math.abs((x.scale ?? 1) - (y.scale ?? 1)) > 1e-6) d.scale = `${x.scale}→${y.scale}`;
    if ((x.xflip ?? false) !== (y.xflip ?? false)) d.xflip = `${x.xflip}→${y.xflip}`;
    if (!!x.colorTransform !== !!y.colorTransform) d.tint = `${!!x.colorTransform}→${!!y.colorTransform}`;
    if ((x.blend ?? "normal") !== (y.blend ?? "normal")) d.blend = `${x.blend ?? "normal"}→${y.blend ?? "normal"}`;
    if (Object.keys(d).length) { rows.push({ i, dobj: x.dobj, ...d }); mismatches++; }
  }
  return { countA: oa.length, countB: ob.length, mismatches, rows };
}

// ---------- render a frame to a native 700×500 PNG through the live renderer ----------
const browser = await puppeteer.launch({
  headless: "new",
  args: ["--no-sandbox", "--enable-unsafe-swiftshader", "--use-gl=angle", "--use-angle=swiftshader",
         "--ignore-gpu-blocklist", "--window-size=700,500"],
});
const page = await browser.newPage();
await page.setViewport({ width: 700, height: 500 }); // window == stage → letterbox scale 1 → native capture
page.on("pageerror", (e) => console.log("PAGEERROR:", e.message));
await page.goto(URL, { waitUntil: "networkidle2", timeout: 60000 });
for (let i = 0; i < 60; i++) { if (await page.evaluate(() => !!window.__renderReady)) break; await new Promise((r) => setTimeout(r, 500)); }

const el = await page.$("#stage");
async function renderPng(frame) {
  await page.evaluate((f) => window.__renderFrame(f), frame);
  await new Promise((r) => setTimeout(r, 150));
  return PNG.sync.read(Buffer.from(await el.screenshot()));
}

const pngA = await renderPng(frameA);
const pngB = frameB ? await renderPng(frameB) : null;
await browser.close();

// ---------- compose output ----------
function sideBySide(left, right, gap = 6) {
  const h = Math.max(left.height, right.height);
  const w = left.width + gap + right.width;
  const out = new PNG({ width: w, height: h });
  out.data.fill(0x22);
  const blit = (src, dx) => {
    for (let y = 0; y < src.height; y++) for (let x = 0; x < src.width; x++) {
      const s = (y * src.width + x) * 4, t = (y * w + (x + dx)) * 4;
      out.data[t] = src.data[s]; out.data[t + 1] = src.data[s + 1];
      out.data[t + 2] = src.data[s + 2]; out.data[t + 3] = 255;
    }
  };
  blit(left, 0); blit(right, left.width + gap);
  return out;
}

import { writeFileSync } from "node:fs";
if (pngB) {
  writeFileSync(OUT, PNG.sync.write(sideBySide(pngA, pngB)));
  const r = diffFrames(frameA, frameB);
  console.log(`\nOBJECT DIFF  [${LABEL_A}] ${r.countA} objs  vs  [${LABEL_B}] ${r.countB} objs  →  ${r.mismatches} differ\n`);
  for (const row of r.rows.slice(0, 40)) {
    const { i, dobj, issue, ...deltas } = row;
    console.log(`  #${i} ${dobj}${issue ? "  " + issue : ""}  ${Object.entries(deltas).map(([k, v]) => `${k}:${v}`).join("  ")}`);
  }
  if (r.rows.length > 40) console.log(`  … ${r.rows.length - 40} more`);
  console.log(`\nside-by-side (${LABEL_A} | ${LABEL_B}) -> ${OUT}`);
  console.log(r.mismatches === 0 ? "MATCH ✅ (frames are render-equivalent)" : `${r.mismatches} object(s) render differently ⚠`);
} else {
  writeFileSync(OUT, PNG.sync.write(pngA));
  console.log(`rendered ${frameA.objects?.length ?? 0} objects -> ${OUT}`);
}
