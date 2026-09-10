# Electron UI Quality Guide

Use this reference for Electron renderer layout, desktop window scaling, theme, typography, encoding, and custom-titlebar failures.

## Responsive Desktop Layouts

- Design from the configured minimum window through large and high-DPI displays.
- Test width and height failures independently; short windows often need scrolling even when width is generous.
- Prefer CSS Grid and Flexbox, minmax(), clamp(), wrapping, and bounded overflow over screen-specific coordinates.
- Set min-width: 0 on shrinking grid and flex children that contain long text.
- Keep primary actions reachable and give the owning content region overflow rather than making the entire frameless window scroll.
- Test browser zoom and operating-system display scaling independently.
- Allow translated and user-generated text to wrap, or truncate only when the full value remains discoverable.
- Keep interactive targets roughly 44 CSS pixels unless a native desktop convention clearly calls for a different size.

## Fix Off-Center Controls

Inspect every layout layer before adding offsets:

1. Add temporary outlines to the control, content wrapper, icon, label, and parent.
2. Compare inline/block padding, margins, gap, line-height, borders, and pseudo-elements.
3. Inspect flex/grid alignment, intrinsic icon bounds, transforms, and inherited library styles.
4. Center the complete icon-plus-label group.
5. Remove default element appearance only when the replacement fully restores focus and interaction states.
6. Recheck at different zoom and display scales.

A control can be mathematically centered but look wrong because an icon, border, title-bar region, or parent column is asymmetric. Verify the actual desktop window.

## Prevent Unreadable Text

- Define semantic CSS variables for backgrounds, surfaces, primary and secondary text, disabled text, borders, focus rings, and actions.
- Resolve app-selected theme, nativeTheme, color-scheme, and system preference through one explicit authority.
- Derive foreground colors from the actual container.
- Avoid hardcoded black or white unless the paired background is guaranteed.
- Inspect native-looking inputs, menus, dialogs, title bars, scrollbars, placeholders, and disabled controls separately.
- Check hover, focus, pressed, selected, error, and disabled states.
- Target at least 4.5:1 contrast for normal text and 3:1 for large text and meaningful UI graphics.

## Fix Broken Text and Encoding

Typical symptoms include replacement diamonds, mojibake, missing glyphs, or text that works in development but fails after packaging.

1. Save JavaScript, TypeScript, HTML, CSS, JSON, CSV, and imported data as UTF-8.
2. Place a UTF-8 charset declaration near the top of every HTML entry document.
3. Decode external files explicitly rather than relying on the machine default.
4. Bundle fonts with every used weight and style, and verify required scripts and punctuation.
5. Repair corrupted source text instead of transforming already-corrupted strings at runtime.
6. Inspect the packaged app and asar contents to confirm resources and fonts were included.

## Desktop Visual Test Matrix

| Axis | Checks |
| --- | --- |
| Window | configured minimum, typical, large, maximized |
| Display | 100%, 125%, 150%, 200% scaling where supported |
| Renderer | default zoom and supported zoom boundaries |
| Theme | light, dark, system, app-selected |
| Text | short, long, non-ASCII, unbroken, localized |
| State | empty, populated, loading, error, disabled |
| Input | mouse, keyboard focus, shortcuts, validation error |
| Chrome | native frame or custom title bar, drag and no-drag regions |
| Runtime | development, packaged, and installed build |

Treat clipping, unreachable actions, unreadable text, covered window controls, and development-only rendering as release blockers.
