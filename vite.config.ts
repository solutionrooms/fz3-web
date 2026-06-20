import { defineConfig } from "vite";
import { resolve } from "node:path";

// FZ3 render app. Vite is the dev server + build tool for the web app only; it never
// runs in the simulation path (determinism lives entirely in the TS code). The FZ3
// AssetLibrary is produced out-of-band by `npm run assets` (openfljs process) into
// `public/assets/fz3/` and loaded at runtime — no swf-loader, bundler-agnostic.
const openfl = (p: string) => resolve(__dirname, "node_modules/openfl/lib/openfl", p);

export default defineConfig({
  root: __dirname,
  publicDir: "public",
  resolve: {
    // OpenFL's npm package has no `exports` map; mirror its path-mapping so `import type`
    // from "openfl/display/Stage" etc. resolves. Runtime still uses the UMD bundle (main).
    alias: [
      { find: /^openfl\/(.*)$/, replacement: openfl("$1") },
    ],
  },
  build: {
    target: "es2020",
    outDir: "dist-web",
    emptyOutDir: true,
  },
  // The 19 MB swflite.bin is a static asset, not a module to optimise.
  assetsInclude: ["**/*.bin"],
});
