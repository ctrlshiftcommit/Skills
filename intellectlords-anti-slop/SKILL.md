---
name: intellectlords-anti-slop
description: Apply an anti-slop design and product-integrity review while building, redesigning, or reviewing user-facing interfaces. Prevent generic visual tropes, fabricated product content, and avoidable product omissions from entering the project.
metadata:
  short-description: Block generic UI patterns and fabricated product content
---

# Intellectlord's Anti-Slop

Use this skill for frontend, mobile, dashboard, landing-page, and product-interface work. It is a preflight and final-review policy. Its job is to stop predictable AI-generated design patterns and product-integrity failures before they become part of the project.

## Core rule

Do not add the prohibited patterns below to a project. Do not use them as a placeholder, fallback, sample, empty state, marketing section, demo decoration, component-library default, loading treatment, or "polish" pass.

The denylist belongs in this skill and in developer-facing QA notes only. Never render the list itself in a user-facing product, copy it into product text, or use its examples as visual inspiration.

If an existing project already contains one of these patterns, do not silently rewrite unrelated product behavior. Report it during review, and remove or replace it when the requested work includes a redesign or explicitly asks for cleanup. A direct user request can opt into a specific exception, but the exception must be narrow and visible in the implementation notes.

## Anti-slop denylist

### Visual language

- Harsh gradients, rainbow coloring, neon colors, and generic/basic pastel palettes.
- A pure white page background as an unexamined default.
- Blue side icons, decorative colored stripes, or a single colored stripe used to make a generic layout look branded.
- Drop shadows and ornamental depth effects used everywhere.
- Liquid glass, glassmorphism, or translucent blur as a default surface treatment.
- Purple-and-black palettes used as a generic AI aesthetic.
- Soft, over-rounded, or inflated corner radii.
- Bento grids used because they are fashionable rather than because the information hierarchy requires one.
- Dot grids, radio-orb decoration, sparkle icons, and animated arrows.
- A terminal window used as a fake product surface or hero visual.
- Three identical feature cards in one row as a default marketing section.
- Emojis used as interface icons, feature icons, badges, or decorative filler.
- Hover animations on everything. Motion must explain state, hierarchy, or causality, and remain restrained.
- Inter, Geist, or Space Grotesk as automatic defaults. Treat the user's phrase "space protest fonts" as part of this prohibition.

### Copy and credibility

- Engagement bait such as "Drop a follow if this helped."
- Em dashes in product copy. Prefer commas, periods, colons, or parentheses.
- The formula "It's not X, it's Y" and close variants.
- Checkmark bullets or checkmark-emoji lists used as a substitute for real information hierarchy.
- Fake testimonials, invented customer names, invented logos, or unsupported social proof.
- Pre-pricing tiers, placeholder prices, or pricing cards presented before the product's actual pricing model is known.

### Product-quality omissions

These are failure modes, not components to add:

- A project with no real product demo when a demo is relevant. Use real screenshots, real states, a truthful interactive flow, or a clearly labeled honest placeholder. Never manufacture a fake demo.
- A project that says "no skeleton loaders" or otherwise has no appropriate loading state. When asynchronous content takes meaningful time, provide a product-appropriate skeleton or loading treatment instead of leaving a blank region or pretending content is instant.
- A project with "no TOS" or "no privacy policy" when the product collects data, has accounts, or otherwise needs those documents. Include real Terms of Service and Privacy Policy links or clearly marked approved destinations. Never invent legal text.

## Working method

1. Read the existing product surface, design tokens, content, and requested scope before changing visuals. Preserve working behavior and real product affordances.
2. Turn the denylist into acceptance criteria for the changed surface. Check the actual implementation, not only the design description.
3. Choose a specific, product-grounded visual direction with deliberate typography, spacing, geometry, color, and hierarchy. Distinctive does not mean ornamental.
4. Use real product evidence and truthful copy. If testimonials, pricing, legal URLs, or demo assets are unavailable, omit the unsupported claim or mark the dependency clearly instead of inventing it.
5. Add complete states that the surface needs: loading, empty, error, success, responsive, keyboard, and reduced-motion behavior. Do not add motion or decoration merely to fill silence.
6. Review the changed files and, when possible, inspect the rendered surface at representative widths. Search for denylist phrases and obvious markers in user-facing copy and markup.
7. Report any pre-existing denylist violations separately from newly introduced ones. Do not claim the project is clean based only on a source search if the rendered result was not inspected.

## Acceptance checklist

Before handing off UI work, confirm:

- No denylisted visual trope was introduced as a default, placeholder, or decorative shortcut.
- Typography and color choices are intentional and are not the prohibited defaults.
- Copy contains no engagement bait, em dashes, contrastive "not X, but Y" framing, fake testimonials, or checkmark filler.
- Any demo, testimonial, pricing, or legal surface is real, supplied, approved, or clearly marked as unavailable.
- Relevant asynchronous screens have a loading treatment, including a skeleton when the wait is meaningful.
- Terms of Service and Privacy Policy links are present when the product needs them.
- Motion is selective, accessible, and tied to meaningful state.
- The skill's denylist was not copied into the user-facing project.
