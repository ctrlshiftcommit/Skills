---
name: build-chrome-extensions
description: Build, repair, and verify Chrome Manifest V3 extensions with service workers, content scripts, popups, options pages, messaging, permissions, storage, CSP-safe assets, dynamic-page injection, and packaged-extension testing. Use for MV3 lifecycle, lost state, duplicate or missing injection, popup layout, chrome.storage, messaging, permissions, remote-asset, content-security-policy, reload, or browser-restart failures.
---

# Build Chrome Extensions

Build or repair Chrome Manifest V3 extensions from repository evidence through a loaded packaged extension. Verify behavior after service-worker suspension and browser restart.

## Route the Work

1. Inspect the manifest, service worker, content scripts, extension pages, permissions, storage, messaging, build output, and target sites.
2. Read [references/chrome-extension.md](references/chrome-extension.md) for stable MV3 guidance.
3. Search [references/field-notes.md](references/field-notes.md) by symptom and tags before diagnosing a recurring failure.
4. Reproduce the issue after extension reload, worker suspension, relevant page navigation, and browser restart.
5. Fix the owning lifecycle, injection, message, storage, permission, UI, or packaging layer.
6. Build, load the unpacked output, inspect every extension context, and exercise the changed flow.

## Implement Safely

- Register service-worker listeners synchronously at module top level.
- Persist durable state in extension storage and reconstruct runtime state after worker wake.
- Keep content injection idempotent and scope DOM observation to the smallest stable container.
- Validate messages and senders, request only necessary permissions, and avoid remote executable code.
- Bundle fonts and runtime assets required under extension CSP.
- Make popups and options pages usable with long text, loading/error states, display scaling, and keyboard navigation.
- Preserve stored user data across updates and migrate stored schemas explicitly.

## Verification Gate

- Run formatting, static analysis, tests, and the production extension build.
- Load the actual build output through the browser extension manager.
- Inspect service-worker, popup/options, and content-script consoles.
- Test cold load, extension reload, worker suspension, browser restart, delayed dynamic content, single-page navigation, and repeated mutations.
- Test denied permissions, missing target elements, offline mode, storage upgrades, and long/non-ASCII content as applicable.
- Confirm the packaged archive contains only intended files and no remote runtime dependency violates CSP.

Report what changed, the commands that passed, the browser contexts checked, and anything that could not be tested.

## Grow the Skill

Keep stable MV3 practices in chrome-extension.md. Store project-derived, verified lessons in field-notes.md only when the user explicitly asks to add, remember, teach, or save them.

Search for duplicates before using scripts/add-field-note.ps1, remove sensitive details, label browser or API version dependencies, and validate the skill after structural changes.
