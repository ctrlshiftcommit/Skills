# Android Guide

## Establish the Android Stack

- Confirm whether the project uses Jetpack Compose, XML Views, or both.
- Inspect Gradle wrapper, Android Gradle Plugin, Kotlin, JDK, compile SDK, min SDK, target SDK, and dependency versions before changing them.
- Use the repository's Gradle wrapper. On Windows, prefer Android Studio's bundled JBR when the system Java is incompatible.
- Identify navigation, state ownership, persistence, dependency injection, background work, and backup behavior before adding features.

## Make Every Screen Fit

Never assume one emulator represents Android devices. Test narrow phones, short landscape windows, tablets/foldables, large font scale, display zoom, edge-to-edge system bars, and the keyboard.

Compose:

- Apply `WindowInsets.safeDrawing` or Scaffold-provided insets once, at the correct container.
- Apply `WindowInsets.ime` or `imePadding()` to forms that must remain usable above the keyboard.
- Use `LazyColumn`/`LazyRow` for collections and long screens; add content padding so the final action clears navigation bars and floating controls.
- Prefer `fillMaxWidth`, `weight`, `wrapContentHeight`, `heightIn`, and adaptive panes over fixed screen dimensions.
- Do not put an unbounded `LazyColumn` inside another vertical scroller.
- Use `BoxWithConstraints` or Material window size classes for genuine layout changes, not device-model checks.
- Avoid `Spacer(weight = 1f)` in a scrolling column when it can push actions beyond the visible viewport.

Example scrollable form:

```kotlin
Column(
    modifier = Modifier
        .fillMaxSize()
        .verticalScroll(rememberScrollState())
        .windowInsetsPadding(WindowInsets.safeDrawing)
        .imePadding()
        .padding(16.dp),
    verticalArrangement = Arrangement.spacedBy(12.dp),
) {
    // Fields and actions remain reachable on short screens.
}
```

XML Views:

- Use `ConstraintLayout` constraints on both axes; avoid device-specific absolute positions.
- Use `0dp` match-constraints deliberately rather than fixed widths.
- Put long forms in `NestedScrollView` with one direct child and `fillViewport="true"` where appropriate.
- Apply system bar and IME insets; do not solve overlap with hardcoded top or bottom margins.
- Use resource qualifiers or adaptive layouts only when the structure truly changes.

If buttons disappear, check fixed-height parents, weighted siblings, nested scrolling, keyboard resize behavior, bottom navigation overlap, and ignored insets before changing button size.

## Theme, Text, and Encoding

- Define complete light and dark `ColorScheme` values and use `MaterialTheme.colorScheme` instead of hardcoded colors.
- Pass explicit container/content colors to custom surfaces and controls when automatic content color cannot be inferred.
- Test dialogs, snackbars, text fields, disabled controls, status/navigation bars, and dynamic color separately.
- Use string resources for user-facing text. Escape XML correctly and preserve UTF-8 source encoding.
- Bundle or select fonts that contain every required glyph; do not assume a decorative font supports non-Latin scripts.
- Read [ui-quality.md](ui-quality.md) for contrast, corrupted text, centering, and cross-platform checks.

## Persistence and Upgrades

- Write and register a Room migration for every schema version change.
- Never add `fallbackToDestructiveMigration` merely to make a build or test pass.
- Back up every persisted feature and restore transactionally where practical.
- Preserve old backup formats through explicit migration or fallback logic.
- Test an in-place upgrade from a realistic previous database, not only a clean install.
- Use `adb install -r` for data-preserving local updates; do not uninstall or clear app data unless the user explicitly approves data loss.

## Common Build and Runtime Problems

- JDK/Gradle mismatch: compare the Gradle, Android Gradle Plugin, and Java compatibility matrices; run `gradlew --version` with the intended JDK.
- Manifest merge failure: inspect the merged manifest report and resolve the owning dependency or attribute rather than blindly applying `tools:replace`.
- Missing permission: declare it in the manifest, request runtime permission only when needed, and handle denial/permanent denial.
- Background work stops: use WorkManager for deferrable durable work and foreground services only for qualifying user-visible work.
- Release-only crash: inspect R8 mapping and rules, resource shrinking, serialization/reflection use, and release logs.
- Compose state resets: hoist durable screen state, use `rememberSaveable` for UI state that should survive recreation, and persist business data outside composables.
- Navigation surprises: define back behavior, deep links, launch destinations, and state restoration explicitly.

## Android Verification

- Run unit tests, lint, and the release-relevant assemble task.
- Run Compose previews or layout inspection as a convenience, not as final proof.
- Test on at least one small phone profile and one large/tablet profile; include landscape when supported.
- Test font scale, display scaling, light/dark theme, gesture/three-button navigation, cutouts, system bars, and keyboard-open states.
- Install the APK/app bundle path appropriate to the task, launch it, exercise the changed flow, inspect Logcat, and capture screenshots.
- For schema or backup changes, test upgrade, backup, restore, process death, and relaunch without losing existing data.
