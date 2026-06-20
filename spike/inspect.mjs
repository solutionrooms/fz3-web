import puppeteer from "puppeteer";
const URL = "http://localhost:8099/index.html";
const browser = await puppeteer.launch({
  headless: "new",
  args: ["--no-sandbox","--enable-unsafe-swiftshader","--use-gl=angle","--use-angle=swiftshader","--ignore-gpu-blocklist","--window-size=1100,560"],
});
const page = await browser.newPage();
await page.setViewport({ width: 1100, height: 560 });
const errs=[]; page.on("pageerror",e=>errs.push(e.message));
await page.goto(URL, { waitUntil: "networkidle2", timeout: 60000 });
for (let i=0;i<40;i++){ if(await page.evaluate(()=>window.__spikeDone&&window.__spikeDone())) break; await new Promise(r=>setTimeout(r,500)); }
await new Promise(r=>setTimeout(r,500));
const dom = await page.evaluate(() => {
  const dump = (el, d=0) => {
    if (d>3) return "";
    let s = "  ".repeat(d) + "<" + el.tagName.toLowerCase() +
      (el.id?("#"+el.id):"") +
      (el.className&&typeof el.className==="string"?("."+el.className.split(" ").join(".")):"");
    if (el.tagName==="CANVAS") s += ` [${el.width}x${el.height}] style="${el.getAttribute('style')||''}"`;
    s += ">";
    for (const c of el.children) { const sub = dump(c,d+1); if (sub) s += "\n"+sub; }
    return s;
  };
  const canvases = [...document.querySelectorAll("canvas")].map(c=>({w:c.width,h:c.height,inDom:document.body.contains(c),style:c.getAttribute("style")}));
  // openfl stage refs
  const stageInfo = (()=>{ try {
    const L = window.openfl.Lib;
    const st = L.current && L.current.stage;
    return st ? {stageW:st.stageWidth, stageH:st.stageHeight, numChildren:st.numChildren} : "no Lib.current.stage";
  } catch(e){ return "err:"+e.message; }})();
  return { bodyTree: dump(document.body), canvasCount: canvases.length, canvases, stageInfo };
});
console.log("PAGEERRORS:", JSON.stringify(errs));
console.log("CANVAS COUNT:", dom.canvasCount);
console.log("CANVASES:", JSON.stringify(dom.canvases,null,1));
console.log("STAGE:", JSON.stringify(dom.stageInfo));
console.log("BODY TREE:\n"+dom.bodyTree);
await browser.close();
