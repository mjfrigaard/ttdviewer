import { defineConfig } from "vite";

// Builds src/ui.tsx into ../inst/www/ui.js and ui.css. React is not bundled:
// shinyreact.js (served by the R package) provides it as window.shinyreact.React.
export default defineConfig({
  build: {
    outDir: "../inst/www",
    emptyOutDir: true,
    lib: {
      entry: "src/ui.tsx",
      formats: ["iife"],
      name: "ttdviewer",
      fileName: () => "ui.js",
      cssFileName: "ui",
    },
    rollupOptions: {
      external: ["react"],
      output: { globals: { react: "shinyreact.React" } },
    },
  },
});
