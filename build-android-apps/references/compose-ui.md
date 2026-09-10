# Jetpack Compose UI Guide

## Contents

1. Design before components
2. Screen structure
3. Insets and keyboard
4. Adaptive layouts
5. Typography and hierarchy
6. Interaction and accessibility
7. Time and duration controls
8. Motion
9. Visual verification

## Design before components

Define a small visual system before styling individual screens:

- background, surface, text, outline, and semantic colors;
- type roles with size, weight, line height, and letter spacing;
- spacing rhythm;
- corner shapes;
- control heights and touch targets;
- icon style;
- motion rules.

Use Material components as behavior foundations, not as a requirement that every app look like default Material. Centralize overrides in a design system.

When implementing from a reference, extract hierarchy, density, alignment, spacing, and interaction patterns. Do not blindly copy another product's branding or ornamental details.

## Screen structure

A screen should communicate:

1. where the user is;
2. the most important current state;
3. the primary next action;
4. secondary details only when needed.

Break settings into clearly named groups. Prefer a short summary and drill-down screen over a wall of explanatory text. Use different text roles for section labels, titles, descriptions, values, and warnings.

Every screen should implement relevant states:

- loading;
- content;
- empty;
- error;
- permission denied;
- degraded capability;
- offline, if networked.

Avoid placeholder-looking boxes. Use real sample content in previews and intentional empty-state illustrations or copy.

## Insets and keyboard

Apply edge-to-edge deliberately. Choose one owner for each inset; do not stack `Scaffold` padding, `safeDrawingPadding`, and navigation-bar padding blindly.

Typical structure:

```kotlin
Scaffold(
    contentWindowInsets = WindowInsets.safeDrawing
) { innerPadding ->
    ScreenContent(
        modifier = Modifier
            .fillMaxSize()
            .padding(innerPadding)
    )
}
```

For forms, combine scrolling and IME handling so the focused field and primary action remain reachable. Test both gesture and three-button navigation.

Do not hardcode status-bar or navigation-bar heights. Inspect cutouts, landscape, and keyboard-open states.

## Adaptive layouts

Build from constraints, not device names. Use `WindowSizeClass`, `BoxWithConstraints`, flow layouts, and adaptive panes where they improve the experience.

Test:

- narrow phones;
- typical phones;
- landscape;
- split screen;
- tablets and foldables where supported;
- large font and display scaling.

Avoid fixed heights around text. Let labels wrap or ellipsize intentionally. Lists should use stable keys.

## Typography and hierarchy

Use a limited number of roles. A practical screen might use:

- display or hero value;
- screen title;
- section title;
- body;
- supporting text;
- label.

Do not make every line the same size and weight. Emphasize the value or action the product is about, not the explanatory paragraph around it.

Use tabular numerals for timers and aligned metrics when the font supports them. Check long, short, and non-ASCII strings.

## Interaction and accessibility

Use at least 48dp touch targets. Make the entire visual row clickable when that matches the affordance. Provide visible pressed, selected, focused, disabled, and error states.

Add semantic labels for meaningful images and icon-only controls. Mark decorative graphics with null content descriptions. Merge semantics only when the combined announcement is clearer.

Do not communicate status through color alone. Maintain readable contrast and support screen readers, switch access, keyboard/D-pad focus where relevant, and reduced motion.

Keep destructive actions visually and spatially distinct. Confirm only when the consequence is meaningful; avoid confirmation fatigue.

## Time and duration controls

Choose the control from the value model:

- Use cards, chips, or a segmented control for a small set of meaningful discrete choices.
- Use a slider for a broad ordered range, with a prominent live value and clear minimum/maximum labels. Avoid rendering a dot for every step when the range contains dozens of increments.
- Offer direct entry or step buttons when exact values matter or accessibility makes dragging difficult.

Store durations in one canonical unit and snap once to the nearest valid step. Clamp to the inclusive bounds before persistence. Format the snapped value from the same canonical value used by the rule engine: show `15 min`, `1 hour`, `2 hr 15 min`, and `24 hours`, not a raw total such as `855 min`. Test the minimum, maximum, half-step rounding, values immediately around one hour, restoration, and locale changes.
## Motion

Motion should explain:

- where content came from;
- what changed;
- what is currently active;
- completion or transition between steps.

Keep onboarding animation short and skippable. Pause nonessential looping work when the app is not visible. Respect system animator settings and reduced-motion expectations.

Prefer Compose animation APIs for UI state changes. Use Lottie or raster/video assets only when the visual complexity justifies the dependency and package size.

## Visual verification

For every materially changed screen:

1. build the real app;
2. navigate to the real state or a debug-only preview backed by production composables;
3. capture a screenshot;
4. inspect alignment, hierarchy, clipping, contrast, and visual noise;
5. repeat with keyboard, large text, and at least one narrow layout.

Compose previews accelerate iteration but do not replace installed runtime inspection.

Use screenshot tests for stable design-system components or critical screens when the project can maintain golden images. Keep tests robust against intentional platform font/rendering differences.
