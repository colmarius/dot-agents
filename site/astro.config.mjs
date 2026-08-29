import { defineConfig } from "astro/config";

export default defineConfig({
  site: "https://dot-agents.dev",
  output: "static",
  redirects: {
    "/docs/guides": "/docs/",
  },
  vite: {
    server: {
      allowedHosts: [".e2b.app", ".onamp.dev"],
    },
  },
});
