import { defineCollection } from "astro:content";
import { glob } from "astro/loaders";
import { z } from "astro/zod";

const guides = defineCollection({
  loader: glob({
    base: new URL("../../docs/guides", import.meta.url),
    pattern: "*.md",
  }),
  schema: z.object({
    title: z.string(),
    description: z.string(),
    order: z.number().int().positive(),
  }),
});

export const collections = { guides };
