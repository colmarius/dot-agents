import { defineConfig } from "astro/config";

export default defineConfig({
  site: "https://dot-agents.dev",
  output: "static",
  redirects: {
    "/docs/guides": "/docs/",
    "/docs/guides/start-uncertain-work": "/docs/#start",
    "/docs/guides/continue-durable-work": "/docs/#continue",
    "/docs/guides/finish-and-preserve-outcomes": "/docs/#finish",
  },
  vite: {
    server: {
      allowedHosts: [".e2b.app", ".onamp.dev"],
    },
  },
});
