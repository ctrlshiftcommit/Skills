# Chrome Extension Field Notes

This is the mutable knowledge layer for verified Chrome Manifest V3 problems discovered during real work. Search it before diagnosing a related issue. Add or revise entries only when the user explicitly asks the skill to remember the lesson.

## Entry Template

<!--
### lowercase-stable-id

- Platform: chrome-extension
- Applies to: browser, API, framework, or version context
- Symptom: what the user observes
- Root cause: verified technical cause
- Fix: concise reusable repair
- Verify: commands and runtime checks that proved the fix
- Avoid: tempting workaround that does not solve the cause
- Tags: comma-separated search terms
-->

## Lessons

### mv3-service-worker-ephemeral-state

- Platform: chrome-extension
- Applies to: Chrome extensions using Manifest V3 service workers
- Symptom: Rules, sessions, or timers vanish after the extension is idle or the browser restarts
- Root cause: Persistent state is kept only in service-worker memory even though MV3 workers are suspended and recreated
- Fix: Register listeners at top level, persist durable state in chrome.storage, reconstruct runtime state on wake, and use chrome.alarms rather than in-memory timers for durable scheduling
- Verify: Let the worker suspend, restart the browser, and trigger each event path without first opening the popup
- Avoid: Treating module globals, setTimeout, or an open message port as permanent storage
- Tags: mv3,service-worker,lifecycle,chrome.storage,chrome.alarms,persistence

### mv3-dynamic-content-script-injection

- Platform: chrome-extension
- Applies to: MV3 content scripts on single-page and dynamically rendered sites
- Symptom: Injected UI is missing after navigation or appears multiple times as the page changes
- Root cause: The script runs before the target exists or only handles the initial DOM
- Fix: Use run_at document_idle, make injection idempotent, and observe the smallest stable container with a debounced MutationObserver that disconnects during teardown
- Verify: Test cold load, client-side navigation, delayed content, repeated mutations, and extension reload without duplicate UI
- Avoid: One immediate querySelector call, observing the entire document forever, or injecting without a stable marker
- Tags: mv3,content-script,document_idle,MutationObserver,spa,injection

### mv3-persistent-storage-choice

- Platform: chrome-extension
- Applies to: Chrome extension popup, service worker, options page, and content scripts
- Symptom: Settings or session data disappear after popup close, worker suspension, or browser restart
- Root cause: State is stored in localStorage, page memory, or service-worker globals instead of extension storage
- Fix: Use chrome.storage.local for extension-owned persistent state, await writes and reads, react to chrome.storage.onChanged where multiple contexts need synchronization, and account for quota and serialization limits
- Verify: Change settings, close every extension UI, allow worker suspension, restart the browser, and confirm all contexts restore the same values
- Avoid: Using localStorage as cross-context extension state or assuming a completed UI update means the storage write succeeded
- Tags: mv3,chrome.storage.local,localStorage,persistence,restart,state

### mv3-popup-size-contract

- Platform: chrome-extension
- Applies to: Chrome extension action popups
- Symptom: Popup content overflows, collapses, or opens at inconsistent dimensions
- Root cause: The popup relies on viewport units, unconstrained intrinsic content, missing html/body sizing, or asynchronous content that changes its layout
- Fix: Set explicit min/max inline sizes on html, body, and the app root, use border-box sizing and controlled overflow, reserve space for loading states, and keep content within browser popup limits
- Verify: Open from multiple window sizes and display scales; test loading, empty, error, long text, and populated states without horizontal overflow
- Avoid: Using 100vw/100vh as if the popup were a normal tab or sizing only a nested React component
- Tags: mv3,popup,dimensions,overflow,css,react

### mv3-popup-local-font-bundling

- Platform: chrome-extension
- Applies to: Chrome extension popup and extension pages
- Symptom: A font loaded with CSS @import works on the web but not inside the packaged popup
- Root cause: Remote font loading is blocked or unreliable under extension CSP, permissions, packaging, or offline conditions
- Fix: Bundle WOFF2 font files in the extension, declare them with local @font-face URLs, include all used weights/styles, and preload only when measured as useful
- Verify: Disable network access, reload the extension, inspect font requests and computed font-family, and confirm the packaged popup uses the bundled glyphs
- Avoid: Remote @import dependencies, silently falling back to a system font, or declaring weights whose files are not packaged
- Tags: mv3,popup,font,@font-face,@import,csp,woff2,assets

