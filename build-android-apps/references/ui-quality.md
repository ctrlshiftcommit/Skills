# Android UI Quality Guide

Use this reference for native Android layout, insets, theme, typography, scaling, and encoding failures.

## Responsive Layouts

- Design from constraints, not one emulator or screenshot.
- Test narrow phones, short landscape windows, tablets or foldables where supported, edge-to-edge bars, gesture and three-button navigation, the keyboard, font scale, and display size.
- Prefer available-space constraints, wrapping, weights used inside bounded parents, min/max sizes, adaptive panes, and scrolling over fixed screen dimensions.
- Keep primary actions reachable above system bars and the IME.
- Apply system and IME insets once at the correct owning container; diagnose double padding and ignored insets separately.
- Allow translated and user-generated text to wrap without covering adjacent controls.
- Keep interactive targets at least 48dp unless a platform component provides an equivalent accessible target.

## Approved Editorial and Raster Assets

Treat an approved visual reference as a production constraint, not loose inspiration. Record its line weight, detail level, palette, negative space, subject, aspect ratio, and intended rendered size. Preserve screens and assets the user explicitly excluded.

For generated editorial art:

1. Create approval previews separately and obtain approval before integrating. Never ship a mock phone screen, contact sheet, or preview composite.
2. Generate each production illustration at its intended aspect ratio on a single flat chroma-key background (green screen unless green appears in the art). Avoid background texture, gradients, cast shadows, and semi-transparent decoration that make the key ambiguous.
3. Remove the chroma locally into alpha with a tolerance that preserves antialiased edges; decontaminate colored fringe and inspect the result on black, white, and checkerboard backgrounds.
4. Crop redundant transparent margins without removing intentional negative space. Export a lossless PNG or WebP at an appropriate pixel size and density.
5. Render the asset through the production composable or view at its actual constraints. Check crop mode, aspect ratio, clipping, visual density, and occupied screen area on the installed target device.

Do not substitute complex approved editorial art with improvised Compose Canvas paths, generic icons, or stick figures merely because they are faster to code. Use code-native drawing only when the requested language is genuinely geometric/vector-like or the user approves that rendering.

## Copy and Action Labels

- Keep setup copy focused on the next user action and outcome. Put platform mechanics in logs or help only when the user needs them.
- Label actions with the operation they perform: `Choose apps`, `Open settings`, `Test access`, or `Try again`. Do not repeat a generic `Fix` button for unrelated states.
- Reserve warning language for an actual blocked, risky, or failed state. A configured capability should read as complete, not as another problem to repair.
## Fix Off-Center Controls

Inspect every layout layer before adding offsets:

1. Outline the control, content row, icon, label, and parent.
2. Compare start/end and top/bottom padding.
3. Inspect weighted siblings, baseline alignment, intrinsic measurements, minimum component padding, and transforms.
4. Center the complete icon-plus-label group.
5. Use Compose or View layout constraints rather than manual coordinates.
6. Recheck at larger font and display scales.

Mathematical centering can still look wrong when an icon has asymmetric bounds or a parent reserves unequal space. Verify rendered screenshots.

## Prevent Unreadable Text

- Define complete semantic Material color roles for backgrounds, surfaces, containers, primary and secondary text, disabled states, borders, and actions.
- Derive content colors from the actual container instead of assuming one global text color.
- Avoid hardcoded black or white unless the design guarantees the paired background.
- Inspect dialogs, text fields, snackbars, menus, disabled controls, status/navigation bars, and dynamic color separately.
- Check focused, pressed, selected, error, placeholder, and disabled states.
- Target at least 4.5:1 contrast for normal text and 3:1 for large text and meaningful UI graphics.

## Fix Broken Text and Encoding

Typical symptoms include replacement diamonds, mojibake, missing glyphs, or strings that differ between debug and release builds.

1. Save Kotlin, Java, XML, JSON, CSV, and resource files as UTF-8.
2. Keep user-facing text in Android resources and escape XML deliberately.
3. Decode imported files with a declared or detected encoding rather than the machine default.
4. Use fonts that cover required scripts, emoji, accents, and punctuation.
5. Inspect the release artifact to confirm fonts and localized resources were packaged.
6. Repair corrupted source text rather than transforming already-corrupted strings at runtime.

## Visual Test Matrix

| Axis | Checks |
| --- | --- |
| Device | small phone, typical phone, tablet or foldable where supported |
| Window | portrait, landscape, split-screen or resizable mode where supported |
| System UI | cutout, status/navigation bars, gesture and three-button navigation |
| Scale | default and increased font/display scale |
| Theme | light, dark, dynamic color or app-selected theme |
| Text | short, long, non-ASCII, unbroken, localized |
| State | empty, populated, loading, error, disabled, permission denied |
| Input | focus, IME open, validation error |
| Runtime | debug and release-relevant installed build |

Treat clipping, unreachable actions, unreadable text, and overlapping system UI as release blockers.
