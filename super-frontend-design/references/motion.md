# Motion reference

Use motion only when it communicates cause, direction, hierarchy, continuity, or feedback.

## Decision sequence

1. Decide whether the interaction benefits from motion. Do not animate every element.
2. Name the purpose: feedback, spatial transition, attention, progress, or delight.
3. Choose the smallest effect that communicates the purpose.
4. Make it interruptible and keep input available.
5. Test at reduced motion, slow speed, and on a real touch device.

## Defaults

- Entering elements normally use ease-out; exiting elements normally use ease-in.
- Use short transitions for controls and slightly longer transitions for spatial changes.
- Use springs for tactile drag, release, and physically meaningful movement—not as decoration.
- Prefer transform and opacity to avoid layout shifts.
- Prefer CSS transitions for simple state changes; use WAAPI or a motion library for coordinated or programmatic sequences.
- Use origin-aware popovers and preserve spatial direction between forward and backward navigation.
- Avoid bounce, elastic easing, scale-from-zero, perpetual motion, and large staggered delays.

## Accessibility and performance

- Honor `prefers-reduced-motion` with an immediate or opacity-only alternative.
- Do not rely on animation to reveal meaning, status, or essential controls.
- Avoid animating layout properties when transform or opacity can communicate the same change.
- Test hover interactions on touch devices and protect drag interactions with pointer capture and multi-touch checks.
