# GitHub Pages Landing Page Research

## Overview

Research on setting up a simple GitHub Pages site for dot-agents, inspired by CLI installer tools like Homebrew, Oh My Zsh, and Starship.

## Design Patterns from Similar Tools

### Homebrew (brew.sh)

- **Style**: Minimalist, centered layout
- **Hero**: Large install command in monospace code block
- **Copy**: "The Missing Package Manager for macOS (or Linux)"
- **Features**: Listed below the fold with brief descriptions
- **Tech**: Static HTML, simple CSS

### Oh My Zsh (ohmyz.sh)

- **Style**: Colorful, playful branding
- **Hero**: Tagline "Unleash your terminal like never before"
- **Install**: Tabbed code block (curl vs wget options)
- **Features**: Plugin/theme showcase with icons
- **Social proof**: Twitter testimonials

### Starship (starship.rs)

- **Style**: Clean documentation-first approach
- **Hero**: Feature bullets (Fast, Customizable, Universal)
- **Install**: Multi-step guide with shell selection
- **Tech**: VitePress static site generator

## Key Design Elements

1. **Prominent install command** - The one-liner should be immediately visible
2. **Copy button** - Essential for code blocks
3. **Minimal text** - 3-5 bullet features max
4. **Mobile responsive** - Single column on mobile
5. **Dark/light mode** - Optional but nice to have
6. **GitHub link** - Usually in header/hero area

## Technical Implementation

### Option 1: Simple Static HTML (Recommended)

```text
docs/
├── index.html
├── style.css
└── .nojekyll
```

**Pros**: No build step, easy to maintain, fast
**Cons**: Manual updates, no templating

### Option 2: GitHub Actions with Static Generator

Use Jekyll, Hugo, or VitePress with automatic builds.

**Pros**: More features, better DX for complex sites
**Cons**: Overkill for a single landing page

### GitHub Actions Workflow

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: true

jobs:
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Pages
        uses: actions/configure-pages@v4

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: docs

      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### Repository Settings Required

1. Go to **Settings > Pages**
2. Under "Build and deployment", select **GitHub Actions** as source
3. The workflow will automatically deploy on push to main

## Proposed Page Structure

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>dot-agents - AI-ready agent workspace</title>
</head>
<body>
  <header>
    <h1>dot-agents</h1>
    <p>AI-ready agent workspace for any project</p>
  </header>

  <main>
    <section class="install">
      <pre><code>curl -fsSL https://raw.githubusercontent.com/colmarius/dot-agents/main/install.sh | bash</code></pre>
      <button>Copy</button>
    </section>

    <section class="features">
      <ul>
        <li>🚀 One-command setup</li>
        <li>📋 Structured plans and PRDs</li>
        <li>🤖 Ralph autonomous execution</li>
        <li>🔬 Built-in research workflows</li>
      </ul>
    </section>
  </main>

  <footer>
    <a href="https://github.com/colmarius/dot-agents">GitHub</a>
  </footer>
</body>
</html>
```

## Styling Approach

- **Font**: System fonts for speed (`-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif`)
- **Code font**: `"SF Mono", "Fira Code", monospace`
- **Colors**: Dark background (#0d1117), light text, accent color for links
- **Layout**: Centered, max-width container (~800px)
- **Spacing**: Generous whitespace

## Resources

- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [actions/deploy-pages](https://github.com/actions/deploy-pages)
- [actions/upload-pages-artifact](https://github.com/actions/upload-pages-artifact)
- [peaceiris/actions-gh-pages](https://github.com/peaceiris/actions-gh-pages) - Alternative deploy action

## Next Steps

1. Create `docs/` folder with static files
2. Add GitHub Actions workflow
3. Enable GitHub Pages in repository settings
4. Test deployment
5. (Optional) Add custom domain via CNAME file
