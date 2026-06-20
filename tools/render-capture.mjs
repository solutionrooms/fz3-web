// Headless capture of the FZ3 render app (dev harness). Waits for window.__renderReady,
// screenshots the stage, and dumps render stats + [render] console output.
import puppeteer from "puppeteer";

const URL = process.env.RENDER_URL || "http://localhost:5173/";
const OUT = process.env.RENDER_OUT || "/tmp/fz3-render.png";
const VW = Number(process.env.RENDER_VW || 760);
const VH = Number(process.env.RENDER_VH || 560);
const FULL = process.env.RENDER_FULL === "1"; // screenshot whole page (to see letterbox bars)

const browser = await puppeteer.launch({
  headless: "new",
  args: ["--no-sandbox", "--enable-unsafe-swiftshader", "--use-gl=angle", "--use-angle=swiftshader",
         "--ignore-gpu-blocklist", "--window-size=760,560"],
});
const page = await browser.newPage();
await page.setViewport({ width: VW, height: VH });
const logs = [];
page.on("console", (m) => { const t = m.text(); if (/\[render\]/.test(t)) logs.push(t); });
page.on("pageerror", (e) => logs.push("PAGEERROR: " + e.message));

await page.goto(URL, { waitUntil: "networkidle2", timeout: 60000 });
let ready = false;
for (let i = 0; i < 60; i++) {
  ready = await page.evaluate(() => !!window.__renderReady);
  if (ready) break;
  await new Promise((r) => setTimeout(r, 500));
}
await new Promise((r) => setTimeout(r, 600));

const stats = await page.evaluate(() => window.__renderStats || null);
const pix = await page.evaluate(() => {
  const c = document.querySelector("#stage canvas");
  if (!c) return { error: "no canvas" };
  const t = document.createElement("canvas"); t.width = c.width; t.height = c.height;
  t.getContext("2d").drawImage(c, 0, 0);
  const d = t.getContext("2d").getImageData(0, 0, t.width, t.height).data;
  let nonBg = 0; const total = d.length / 4;
  for (let i = 0; i < d.length; i += 4) {
    // bg 0x6db3e8
    if (Math.abs(d[i] - 0x6d) + Math.abs(d[i + 1] - 0xb3) + Math.abs(d[i + 2] - 0xe8) > 24) nonBg++;
  }
  return { w: c.width, h: c.height, nonBgPct: +(100 * nonBg / total).toFixed(2) };
});

if (FULL) {
  await page.screenshot({ path: OUT });
} else {
  const el = await page.$("#stage");
  await (el || page).screenshot({ path: OUT });
}

console.log("==== [render] LOG ====");
console.log(logs.join("\n"));
console.log("==== READY:", ready, "====");
console.log("==== STATS:", JSON.stringify(stats));
console.log("==== PIXELS:", JSON.stringify(pix));
console.log("==== screenshot ->", OUT);
await browser.close();
