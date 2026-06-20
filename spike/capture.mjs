// Headless capture for the FZ3 OpenFL spike.
// Loads the served page, scrapes [SPIKE] console output, waits for __spikeDone,
// screenshots the OpenFL canvas. Mirrors SB2's puppeteer capture approach.
import puppeteer from "puppeteer";

const URL = process.env.SPIKE_URL || "http://localhost:8099/index.html";
const OUT = process.env.SPIKE_OUT || "/tmp/fz3-spike.png";

const browser = await puppeteer.launch({
  headless: "new",
  args: [
    "--no-sandbox",
    "--enable-unsafe-swiftshader",
    "--use-gl=angle",
    "--use-angle=swiftshader",
    "--ignore-gpu-blocklist",
    "--window-size=1100,560",
  ],
});

const page = await browser.newPage();
await page.setViewport({ width: 1100, height: 560 });

const logs = [];
page.on("console", (m) => {
  const t = m.text();
  if (t.includes("[SPIKE]")) logs.push(t.replace(/^\[SPIKE\]\s*/, ""));
});
page.on("pageerror", (e) => logs.push("PAGEERROR: " + e.message));

await page.goto(URL, { waitUntil: "networkidle2", timeout: 60000 });

// Wait for the spike to signal completion (or time out).
let done = false;
for (let i = 0; i < 60; i++) {
  done = await page.evaluate(() => (window.__spikeDone ? window.__spikeDone() : false));
  if (done) break;
  await new Promise((r) => setTimeout(r, 500));
}

// Give one more paint, then screenshot the canvas region.
await new Promise((r) => setTimeout(r, 400));
const canvas = await page.$("canvas");
if (canvas) {
  await canvas.screenshot({ path: OUT });
} else {
  await page.screenshot({ path: OUT });
}

// Pull non-blank-pixel stats off the canvas to prove something actually drew.
const pixStats = await page.evaluate(() => {
  const c = document.querySelector("canvas");
  if (!c) return { error: "no canvas" };
  try {
    // OpenFL may use WebGL; read back via a 2D copy.
    const tmp = document.createElement("canvas");
    tmp.width = c.width; tmp.height = c.height;
    const g = tmp.getContext("2d");
    g.drawImage(c, 0, 0);
    const d = g.getImageData(0, 0, tmp.width, tmp.height).data;
    let nonBg = 0, opaque = 0;
    // bg is 0x202830
    for (let i = 0; i < d.length; i += 4) {
      const r = d[i], gg = d[i + 1], b = d[i + 2], a = d[i + 3];
      if (a > 8) opaque++;
      if (Math.abs(r - 0x20) + Math.abs(gg - 0x28) + Math.abs(b - 0x30) > 24) nonBg++;
    }
    const total = (d.length / 4);
    return { w: c.width, h: c.height, total, opaque, nonBg,
             nonBgPct: +(100 * nonBg / total).toFixed(2) };
  } catch (e) { return { error: String(e) }; }
});

console.log("==== SPIKE LOG ====");
console.log(logs.join("\n"));
console.log("==== DONE? " + done + " ====");
console.log("==== CANVAS PIXEL STATS ====");
console.log(JSON.stringify(pixStats));
console.log("==== screenshot -> " + OUT + " ====");

await browser.close();
