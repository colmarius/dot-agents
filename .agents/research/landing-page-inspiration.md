# Research: Landing Page Design Inspiration

**Date:** 2026-02-03
**Status:** Complete
**Tags:** design, landing-page, UI, developer-tools

## Summary

Researched modern developer tool landing pages (Bun, Deno, Cursor, Zed, Warp) to gather design inspiration for the dot-agents landing page. Key patterns identified include dark themes, prominent install commands, feature grids, social proof, and clean typography.

## Key Learnings

- **Dark themes dominate** - All modern dev tools use dark backgrounds (#0d1117, #1a1a2e range)
- **Hero section is king** - Large, bold headline + concise tagline + immediate install command
- **Install command prominence** - Copy button, monospace font, platform tabs (Linux/macOS/Windows)
- **Feature presentation** - Grid or card-based layouts with icons/emojis, short descriptions
- **Social proof** - "Used by" logos, testimonials, GitHub stars
- **Minimal UI** - Lots of whitespace, focused CTAs, clean typography

## Design Patterns by Site

### Bun (bun.sh)

- Large headline with **bold emphasis** on key words
- Install command with platform tabs (Linux/macOS, Windows)
- "Used by" company logos
- Feature comparison tables
- Code examples with syntax highlighting
- Performance benchmarks with visual bars

### Deno (deno.com)

- Minimal hero: "Uncomplicate JavaScript"
- Stats displayed: 100k+ GitHub stars, 400k+ users, 2M+ modules
- Company logos (Slack, Netlify, GitHub, Stripe)
- Feature grid with icons
- Code examples showing real usage
- Testimonials carousel

### Cursor (cursor.com)

- Bold tagline: "Built to make you extraordinarily productive"
- Download button prominently placed
- Interactive demos (video/animation)
- Feature cards with descriptions
- Prominent testimonials from known figures
- Changelog highlights

### Zed (zed.dev)

- "Love your editor again" - emotional hook
- Three pillars: Fast, Intelligent, Collaborative
- Testimonials from known developers (José Valim, Dan Abramov)
- Feature showcase with animations
- Extensions ecosystem display
- Team letter section

### Warp (warp.dev)

- Action-oriented: "The best terminal for building with agents"
- winget install command shown
- Use cases listed: Build features, Fix bugs, Debug prod
- Trust badges and rankings
- Step-by-step workflow explanation
- Privacy/security callouts

## Design Recommendations for dot-agents

1. **Hero section**: Strong headline + tagline + install command
2. **Visual hierarchy**: Use size and weight to guide the eye
3. **Feature cards**: Icons + short titles + brief descriptions
4. **Code block**: Prominent, with copy button, good contrast
5. **CTA button**: Single, clear action (GitHub link)
6. **Footer**: Minimal, just essentials

## Color Palette Inspiration

| Tool | Background | Text | Accent |
|------|------------|------|--------|
| Bun | #14151a | #e6edf3 | #f472b6 (pink) |
| Deno | #0b0d0f | #ffffff | #70ffaf (green) |
| Cursor | #0a0a0a | #ffffff | #6366f1 (indigo) |
| Zed | #09090b | #fafafa | #3b82f6 (blue) |
| Warp | #0f0f14 | #e5e5e5 | #00d9ff (cyan) |

## Typography Patterns

- System fonts preferred for performance
- Large headlines: 2.5-4rem, bold (600-800 weight)
- Taglines: 1.25-1.5rem, muted color
- Body: 1rem, regular weight
- Code: Monospace, slightly smaller (0.875rem)

## Sources

- [Bun](https://bun.sh) - Install command prominence, feature tables
- [Deno](https://deno.com) - Stats display, minimal hero
- [Cursor](https://cursor.com) - Testimonials, interactive demos
- [Zed](https://zed.dev) - Emotional hook, pillars layout
- [Warp](https://warp.dev) - Use cases, workflow steps

## Implementation Notes

For dot-agents, recommend:

- Keep current dark theme (#0d1117)
- Add subtle accent color (cyan #00d9ff or green #3fb950)
- Improve code block styling (better contrast, larger font)
- Add subtle gradient or glow effect to hero
- Consider adding a terminal-style animation or visual
- Feature list could use better visual separation
