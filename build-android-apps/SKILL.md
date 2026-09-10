---
name: build-android-apps
description: Build, repair, and verify native Android applications with Jetpack Compose or XML Views, Gradle, lifecycle-aware state, persistence, permissions, background work, backups, release builds, and real-device testing. Use for Android UI fit, insets, keyboard, theme or text bugs; Gradle, manifest, Room, WorkManager, notification, signing, packaging, installation, upgrade, or device-only failures; and end-to-end native Android implementation. Exclude React Native and Expo unless the user explicitly requests them.
---

# Build Android Apps

Build or repair native Android apps from repository evidence through a working install. Do not stop at compilation when the request implies a usable screen, release artifact, or real-device result.

## Route the Work

1. Inspect the repository before choosing an implementation.
2. Confirm Compose, XML Views, or a hybrid; Gradle and Kotlin versions; JDK; SDK levels; navigation; persistence; and release setup.
3. Read the relevant reference:
   - Native Android implementation and runtime failures: [references/android.md](references/android.md)
   - Scope, approval gates, and end-to-end workflow: [references/build-workflow.md](references/build-workflow.md)
   - Compose controls, timers, and interaction state: [references/compose-ui.md](references/compose-ui.md)
   - Permissions, special access, and platform limits: [references/platform-integrations.md](references/platform-integrations.md)
   - State ownership and reuse across flows: [references/project-architecture.md](references/project-architecture.md)
   - Installed-device, ADB, Gradle, and release proof: [references/testing-release.md](references/testing-release.md)
   - Layout, insets, theme, contrast, typography, and encoding: [references/ui-quality.md](references/ui-quality.md)
   - Prior verified Android lessons: search [references/field-notes.md](references/field-notes.md) by symptom and tags
4. Reproduce the failure on the affected device or emulator, configuration, theme, font scale, and keyboard state.
5. Fix the owning layer and preserve existing user data.
6. Build, install, launch, and exercise the changed flow.

## Establish the Baseline

Before editing:

- Read settings and build files, manifests, app entry points, navigation, theme, persistence, background work, backup, and release configuration.
- Check the working tree and preserve unrelated user changes.
- Record the exact Gradle, install, and runtime path that reproduces the problem.
- Determine whether the failure occurs on a clean install, an in-place upgrade, a specific API level, or only a physical device.
- For visual work, capture and inspect the real installed screen before editing. Keep temporary device captures outside the repository.
- Record approved references, screens in scope, and explicitly excluded screens. Treat exclusions as a regression boundary.

For a new app, define the product name, application ID, min/target SDK, supported form factors, navigation and back behavior, theme tokens, data and migration policy, permissions, backup/restore, signing, packaging, installation, and smoke-test commands before expanding feature work.

## Maintain a Product Surface Contract

For an existing app, treat the repository's root `AGENTS.md` as a product contract, not optional background reading. Before editing, read it and verify it against the source, manifest, persistence, and installed behavior. If it is missing and the app is established enough to have multiple flows, create it before implementing the requested feature.

When the user asks for a durable handoff, future-agent guide, or "every detail" of an app, update `AGENTS.md` with verified, actionable facts. Document the product purpose, non-negotiable visual and safety constraints, activity/route map, feature inventory, user journeys, state owners, persistence and migration rules, Android capabilities and denied states, policy precedence, recovery/fail-open paths, package visibility/catalog refresh, analytics definitions, supported device/API assumptions, known limitations, deferred issues, and the exact build/test/install commands. Link each fragile contract to its owning class or test when useful.

Separate facts from decisions and unknowns. Mark mockups and planning ideas as references, never as runtime truth. Record explicit exclusions such as "do not add color," "do not ship generated preview assets," "do not use a second app-selection list," or "do not restore an accidental recovery gesture." Update the contract in the same change when behavior or a safety boundary changes, and remove stale instructions rather than layering contradictions.

Keep the contract useful rather than dumping every implementation line. Do not put secrets, personal paths, device identifiers, signing material, transient logs, or unverified assumptions in it. Before handoff, perform a documentation-to-source audit: every listed feature should have an owner, every claimed behavior should have a test or installed-device proof when applicable, and every deferred item should state what evidence is needed to reopen it. Preserve unrelated user edits and never delete source or crash logs to make the handoff look clean.

For visual work, record the approved reference, the real theme tokens, explicit excluded screens/assets, interaction and motion constraints, accessibility/touch-target rules, and the required post-install screenshot comparison. Keep generated mockups separate from production assets, and never claim visual completion from compilation alone.

Use this minimum contract outline when starting or repairing an established app:

- Purpose, audience, platform, and non-negotiable safety/design constraints.
- Runtime surfaces and navigation, including launcher, system-settings, recovery, and fail-open boundaries.
- Feature behavior and interactions, including what must remain reachable during restrictions.
- Data ownership, durable state, migrations, time sources, and rule/evaluation precedence.
- Permissions, package visibility, background triggers, lifecycle refresh points, and denied/degraded behavior.
- Verification matrix: unit tests, lint/build, manifest/APK inspection, data-preserving install, real-device flow, screenshot, and known untested risk.

## Implement Safely

- Follow the repository architecture unless evidence shows it owns the defect.
- Keep durable state outside composables and views; use lifecycle-aware state collection.
- Centralize design tokens and reusable controls.
- Handle system bars, display cutouts, IME, font scale, display scaling, and short screens explicitly.
- Preserve data. Never uninstall, clear data, replace a database, or enable destructive migration as a routine fix.
- Add and test a migration for every persisted schema change.
- Request runtime permissions only at the point of need and handle denial without trapping the user.
- Give visible feedback for save, delete, import, backup, restore, sync, and other important actions.
- Keep concise user-facing errors and actionable technical detail in logs.
- Do not start the final build/install while a required visual approval or requested implementation is still pending.

## Build Smooth Input and Selection Controls

- Do not use default Android input popups or platform-styled selectors for product-facing controls when implementing text fields, dates, times, durations, or other selections. Build selectors that match the app's design system and provide an explicit confirm/cancel path where the choice is modal. Use the platform APIs only for required system behavior, and wrap them in the app's own surface when a custom product UI is requested.
- Treat every text field as an IME-aware layout. When the keyboard opens, keep the focused field, its label, validation message, and primary action visible by using window insets/IME padding plus a scrollable parent or an equivalent XML insets-aware layout. Verify behavior with fields near the bottom of short screens; do not rely on a fixed offset or a single device's resize behavior.
- Preserve focus, cursor position, selection, and typed text across recomposition, configuration changes, validation, and transient state updates. Keep input state owned by the appropriate screen/state holder rather than recreating it from an `onValueChange` side effect or unstable item key.
- Make typing continuous and predictable: do not debounce or transform on every keystroke unless required, do not steal focus, dismiss the IME, move the cursor unexpectedly, or rebuild the field while the user types. Configure the correct keyboard/input type, support paste and non-ASCII text, and make labels, errors, and supporting text update without shifting the focused control out of view.
- For Compose, use stable state and keys, `imePadding()`/window inset handling, and `BringIntoViewRequester` or a properly configured scroll container when necessary. For XML Views, use edge-to-edge insets deliberately, an IME-compatible window soft-input mode, and a scroll container that can reach the focused field. Avoid nested scrolling containers that fight each other.
- Test each changed field and selector on a small phone and a representative device with the IME both closed and open: tap/focus, type rapidly, edit in the middle, select all, paste, rotate or recreate where supported, submit invalid input, recover from an error, dismiss the keyboard, reopen the screen, and confirm that no text is lost or unexpectedly reformatted.

## Preserve Existing Product Contracts

- For small Compose visual or quality-of-life requests, keep existing navigation, theme, state ownership, and layout intact; change the owning component and avoid broad UI rewrites. When the product specifies strict monochrome, use black, white, and neutral-gray tokens consistently, and make generated mockups match the real theme.
- Make carousel selection change immediately on swipe, animate the transition over 150–300 ms, and provide visible Previous and Next controls. Remove planning-only UI and duplicate actions from production settings, while retaining safety-critical enforcement gates even when their normal UI promotion is reduced.
- Default blocking schedules to the user’s previously selected distracting apps. Provide an explicit “all eligible apps” option, keep protected, system, and recovery paths available, and use corner radii no greater than 5dp for scheduled-blocking surfaces when requested. Offer a broader set of useful break-duration choices rather than sparse jumps.
- Refresh launcher and app catalogs from package add/remove/change broadcasts, on Activity resume, and on a bounded periodic interval so newly installed apps appear without a restart.
- Respect Android system boundaries: do not replace the system lock screen with a regular app overlay; document safe alternatives and limitations. Make emergency recovery deliberate and two-stage: a fallback trigger may arm a recovery screen, but entering emergency safe mode requires explicit confirmation or a hold, and fail-open paths must remain intact.
- Use green-screen/chroma-key only as a temporary extraction workflow. Ship transparent monochrome icon assets and verify that no chroma color leaks into the app.
## Write the Product Surface

- Keep app UI copy plain, natural, concise, and human. Use short sentences, familiar words, and specific actions.
- Do not use AI-looking emoji buttons, emoji-only controls, fake enthusiasm, generic filler, repetitive summaries, unnecessary headings, backend or frontend implementation explanations, planning commentary, or internal architectural details in the product UI.
- Conversation-only planning context must not be copied into app strings, UI, onboarding, or code unless the user explicitly turns it into a product requirement.
- Avoid unnecessary em dashes and AI-like punctuation patterns. Prefer ordinary punctuation and direct wording.
- Treat accessibility as part of copy. Make labels and actions clear without relying on color, position, or icons alone, and provide meaningful content descriptions for icon controls.

Before handoff, run a copy QA pass:

1. Inspect visible strings and empty, loading, error, disabled, and permission states for a human tone.
2. Remove implementation language, planning notes, and accidental internal, tool, or agent language.
3. Check that labels and actions are clear, concise, consistent, and accessible.
4. Read the screens in context and remove filler, repetition, and headings that do not help the user.

AI-text detectors are not reliable proof of authorship. Do not optimize copy to evade a detector or promise that it will pass one. Use research-backed human-writing principles such as plain language, active voice, specificity, inclusive wording, and user testing.

## Treat Visual References as Requirements

- Separate approval mockups from production assets. Never ship a composite preview, phone mockup, or contact sheet as an in-app asset.
- For editorial raster art, follow the generation, chroma-key, alpha-removal, cropping, and scale checks in [references/ui-quality.md](references/ui-quality.md). Do not replace approved art with improvised Canvas or stick-figure drawings.
- Preserve explicitly excluded screens and assets byte-for-byte unless a shared dependency makes that impossible; if so, stop and disclose the impact.
- Do not declare visual work done from source, previews, or a successful build. Install the final artifact, navigate to the real state, capture a new device screenshot, and compare it with the approved direction.

## Diagnose Visual Bugs

1. Confirm viewport, orientation, font scale, display size, theme, content length, keyboard state, system bars, and navigation mode.
2. Inspect parent constraints and insets before changing a child.
3. Remove fixed sizes or weights that make actions unreachable.
4. Make long content scroll or adapt rather than shrinking controls below usable sizes.
5. Use semantic Material colors for every foreground/background pair.
6. Verify UTF-8 source/resources and font glyph coverage.
7. Capture screenshots at boundary configurations.
8. Compare the installed result with the approved reference for composition, density, crop, and rendered scale.

Do not declare a fit, centering, or contrast problem fixed from code inspection alone.

## Verification Gate

Complete the checks relevant to the change:

- Run formatting, static analysis, unit tests, lint, and the release-relevant Gradle task.
- Install with a data-preserving path when upgrading an existing app.
- Launch the real app and inspect Logcat for the changed flow.
- Capture and inspect a post-install screenshot of every materially changed screen.
- Test a small phone, a typical phone, and a large or tablet layout when supported.
- Test portrait/landscape, light/dark theme, increased font/display scale, gesture and three-button navigation, cutouts, system bars, and IME-open states.
- Test long labels, non-ASCII text, empty, loading, error, disabled, denied-permission, process-death, and relaunch states as applicable.
- For every text-entry or date/time/duration control, test that the custom control opens and closes reliably, the focused field moves above the IME, the cursor and selection remain stable, rapid typing is lossless, validation does not interrupt entry, and no default Android popup or selector leaks into the product UI.
- For persistence or backup changes, test a realistic in-place upgrade and confirm existing data remains intact.
- Verify app name, launcher icon, notification identity, signing, and the requested APK or bundle artifact.
- Remove temporary screenshots, generated previews, crash logs, and extraction artifacts from the repository before handoff.

Report what changed, the commands that passed, the device/runtime checked, and anything that could not be tested.

## Grow the Skill

Keep stable Android practices in android.md and ui-quality.md. Store project-derived, verified lessons in field-notes.md only when the user explicitly asks to add, remember, teach, or save them.

For each lesson:

1. Verify the symptom, root cause, fix, and proof.
2. Search field-notes.md for matching symptoms, causes, and tags.
3. Strengthen an existing entry instead of creating a near-duplicate.
4. Otherwise add a lowercase hyphenated ID through scripts/add-field-note.ps1.
5. Remove secrets, personal paths, tokens, IDs, and unnecessary product details.
6. Label version-sensitive claims.
7. Run the skill validator after structural or frontmatter changes.

Promote a lesson into android.md or ui-quality.md only after it is broadly reusable.
