#!/usr/bin/env node
// FZ3 render asset prebuild.
//   node tools/assets/process-swf.mjs <input.swf> <outDir>
//
// 1. Runs `openfljs process` (the SWF→AssetLibrary converter shipped INSIDE the
//    openfl npm package — pure Node, no Haxe toolchain) into a temp dir.
// 2. Strips SOUND assets from the manifest + deletes the sounds/ dir, so the render
//    AssetLibrary carries no audio payload and OpenFL never needs the `howler` global
//    at load time. (Audio is owned by the game dev's SoundPlayer/MusicPlayer.)
// 3. Publishes the cleaned AssetLibrary to <outDir>.
//
// Idempotent + incremental: skips the (slow) conversion when the output is newer than
// the SWF. Force a rebuild with FZ3_ASSETS_FORCE=1.

import { execFileSync } from "node:child_process";
import {
  mkdtempSync, rmSync, mkdirSync, cpSync, readFileSync, writeFileSync,
  existsSync, statSync,
} from "node:fs";
import { tmpdir } from "node:os";
import { join, resolve, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { unserializeAssets, serializeAssets } from "./haxe-manifest.mjs";

const here = dirname(fileURLToPath(import.meta.url));
const repoRoot = resolve(here, "..", "..");

const [, , swfArg, outArg] = process.argv;
if (!swfArg || !outArg) {
  console.error("usage: process-swf.mjs <input.swf> <outDir>");
  process.exit(2);
}
const swf = resolve(repoRoot, swfArg);
const outDir = resolve(repoRoot, outArg);
const openfljs = resolve(repoRoot, "node_modules", "openfl", "bin", "openfl.js");

if (!existsSync(swf)) { console.error(`[assets] SWF not found: ${swf}`); process.exit(1); }
if (!existsSync(openfljs)) { console.error(`[assets] openfljs not found (npm install openfl): ${openfljs}`); process.exit(1); }

// Incremental: skip if outDir/library.json is newer than the SWF.
const manifestOut = join(outDir, "library.json");
if (!process.env.FZ3_ASSETS_FORCE && existsSync(manifestOut)) {
  if (statSync(manifestOut).mtimeMs >= statSync(swf).mtimeMs) {
    console.log(`[assets] up to date (${manifestOut}); set FZ3_ASSETS_FORCE=1 to rebuild.`);
    process.exit(0);
  }
}

const tmp = mkdtempSync(join(tmpdir(), "fz3-assets-"));
try {
  console.log(`[assets] converting ${swfArg} → AssetLibrary …`);
  // openfljs emits SWF-parser "excess bytes" warnings to stderr; they're non-fatal.
  execFileSync("node", [openfljs, "process", swf, tmp], { stdio: ["ignore", "inherit", "ignore"] });

  // --- strip SOUND assets from the manifest ---
  const manifestPath = join(tmp, "library.json");
  const lib = JSON.parse(readFileSync(manifestPath, "utf8"));
  const assets = unserializeAssets(lib.assets);
  const counts = {};
  for (const a of assets) if (a) counts[a.type] = (counts[a.type] || 0) + 1;
  const kept = assets.filter((a) => a && a.type !== "SOUND");
  lib.assets = serializeAssets(kept);
  writeFileSync(manifestPath, JSON.stringify(lib));

  // drop the audio payload entirely
  rmSync(join(tmp, "sounds"), { recursive: true, force: true });

  // --- publish ---
  rmSync(outDir, { recursive: true, force: true });
  mkdirSync(outDir, { recursive: true });
  cpSync(tmp, outDir, { recursive: true });

  const stripped = (counts.SOUND || 0);
  console.log(
    `[assets] done → ${outArg}  ` +
    `(kept ${kept.length} assets: ${counts.IMAGE || 0} image, ${counts.TEXT || 0} text; ` +
    `stripped ${stripped} sound)`,
  );
} finally {
  rmSync(tmp, { recursive: true, force: true });
}
