# Reverse-engineering reference

Use `npxskillui` when reproducing an existing website, design system, or local project rather than inventing a new visual language.

## Commands

```bash
npm install -g skillui
skillui --url https://example.com --out ./design-system
skillui --url https://example.com --mode ultra --screens 7 --out ./design-system
skillui --dir ./my-app --out ./design-system
skillui --repo https://github.com/org/repo --out ./design-system
```

Default mode extracts HTML/CSS, colors, fonts, typography, spacing, and tokens. Ultra mode uses Playwright to capture screenshots, hover/focus differences, animations, layout, and DOM component fingerprints.

## Applying output

Read the generated `SKILL.md` and `DESIGN.md` first. Use `tokens/` as the source of truth for colors, spacing, and typography. Consult `references/ANIMATIONS.md`, `LAYOUT.md`, `COMPONENTS.md`, `INTERACTIONS.md`, and `VISUAL_GUIDE.md` only for the relevant screen or behavior. Match the extracted language while preserving the user's product requirements and accessibility.

Never copy a site's identity, private content, or protected assets without authorization. Extract design principles and structure; use original product content and appropriately licensed assets.
