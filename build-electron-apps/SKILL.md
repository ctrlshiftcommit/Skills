---
name: build-electron-apps
description: Build, repair, and verify Electron desktop applications with secure main/preload/renderer boundaries, IPC, BrowserWindow lifecycle, native integrations, SQLite, automation, responsive renderer UI, branding, packaging, signing, installation, and packaged-runtime testing. Use for Electron window controls, custom title bars, IPC or preload contracts, native-module failures, renderer layout or theme bugs, persistence, Puppeteer, app identity, installer, or behavior that differs after restart or packaging.
---

# Build Electron Apps

Build or repair Electron desktop apps from repository evidence through an installed packaged runtime. Do not treat a browser preview or development launch as final proof.

## Route the Work

1. Inspect the repository before choosing an implementation.
2. Confirm the Electron version, main/preload/renderer entry points, renderer framework, bundler, IPC surface, native modules, persistence, and packager.
3. Read the relevant reference:
   - Architecture, IPC, windows, native modules, branding, and packaging: [references/electron.md](references/electron.md)
   - Renderer layout, theme, typography, encoding, and window-scale quality: [references/ui-quality.md](references/ui-quality.md)
   - Prior verified Electron lessons: search [references/field-notes.md](references/field-notes.md) by symptom and tags
4. Reproduce the failure in the affected development or packaged runtime.
5. Fix the owning main, preload, renderer, persistence, or packaging layer.
6. Build, package, install, launch, and exercise the changed flow.

## Establish the Baseline

Before editing:

- Read package and build files, main/preload/renderer entry points, BrowserWindow creation, IPC registration, persistence initialization, and packager configuration.
- Check the working tree and preserve unrelated user changes.
- Record the exact development and packaged commands that reproduce the problem.
- Determine whether the issue occurs only after packaging, installation, restart, resize, native-module loading, or on a particular operating system.
- Inspect screenshots, computed styles, DevTools, and the live desktop window when the problem is visual.

For a new app, define product identity, app ID, supported operating systems, window frame and size policy, navigation and close behavior, theme tokens, privilege boundaries, data and migration policy, signing, packaging, installer, and smoke-test commands before expanding feature work.

## Implement Safely

- Keep filesystem, database, shell, native OS, and automation capabilities in the main process.
- Expose narrow typed methods through preload; validate IPC channels, senders, and payloads.
- Keep context isolation enabled and Node access out of untrusted renderer code.
- Track BrowserWindow instances explicitly and guard destroyed-window operations.
- Centralize renderer design tokens and reusable controls.
- Preserve persisted data and add migrations for schema changes.
- Separate development URLs and paths from packaged asset and user-data paths.
- Give visible feedback for important operations and keep actionable detail in logs.

## Diagnose Visual and Window Bugs

1. Confirm operating system, window size, display scale, zoom, theme, text length, renderer state, and native-frame versus custom-titlebar behavior.
2. Inspect parent grid/flex constraints and computed styles before changing a child.
3. Remove fixed sizes, default min-width constraints, or drag regions that cover controls.
4. Make long content wrap, truncate deliberately, or scroll at the owning region.
5. Use explicit semantic CSS variables and coordinate app theme state with nativeTheme.
6. Verify UTF-8 assets and bundled font coverage in the packaged app.
7. Test minimize, maximize/restore, close, resize, keyboard focus, and native shortcuts in the actual window.

Do not declare a centering, title-bar, icon, or packaging problem fixed from source inspection alone.

## Verification Gate

Complete the checks relevant to the change:

- Run formatting, static analysis, unit tests, and the production packaging task.
- Fix main, preload, and renderer console errors.
- Test the configured minimum window, a typical window, and a large/high-DPI window.
- Test zoom/display scaling, light/dark/app-selected themes, long and non-ASCII text, empty/loading/error/disabled states, focus, and keyboard navigation.
- Test cold launch, single-instance behavior, minimize, maximize/restore, resize, close, relaunch, tray, notifications, deep links, and file associations as applicable.
- Test missing files, read-only paths, no network, and non-ASCII user paths where relevant.
- Install the distributable and confirm app name, executable, icon, taskbar/dock identity, shortcuts, installer/uninstaller, and absence of unintended Electron branding.
- For persistence changes, upgrade a realistic existing data set and confirm it remains intact.

Report what changed, the commands that passed, the installed runtime checked, and anything that could not be tested.

## Grow the Skill

Keep stable Electron practices in electron.md and ui-quality.md. Store project-derived, verified lessons in field-notes.md only when the user explicitly asks to add, remember, teach, or save them.

For each lesson:

1. Verify the symptom, root cause, fix, and proof.
2. Search field-notes.md for matching symptoms, causes, and tags.
3. Strengthen an existing entry instead of creating a near-duplicate.
4. Otherwise add a lowercase hyphenated ID through scripts/add-field-note.ps1.
5. Remove secrets, personal paths, tokens, IDs, and unnecessary product details.
6. Label Electron, Chromium, framework, or packager version dependencies.
7. Run the skill validator after structural or frontmatter changes.

Promote a lesson into electron.md or ui-quality.md only after it is broadly reusable.
