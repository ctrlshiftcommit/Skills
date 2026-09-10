# Chrome Manifest V3 Guide

## Establish the Extension Stack

- Inspect manifest_version, permissions, host_permissions, action, background service_worker, content_scripts, web_accessible_resources, commands, options, and externally connectable declarations.
- Identify the build tool, output directory, generated manifest, browser targets, extension contexts, and storage schema before editing.
- Load and inspect the built output rather than assuming source files are the installed extension.
- Keep React or other UI framework concerns inside extension pages; do not confuse them with service-worker or content-script lifecycle.

## Service-Worker Lifecycle

- Register event listeners synchronously at module top level so Chrome can wake the worker for them.
- Treat module globals as disposable cache, not durable state.
- Store durable state in chrome.storage and rebuild runtime state on wake.
- Use chrome.alarms for durable scheduling instead of relying on setTimeout or setInterval.
- Avoid artificially keeping the worker alive; design each event path to resume safely.
- Make initialization idempotent because install, startup, update, and event wakeups can overlap.

## Messaging and Permissions

- Define a small message contract with explicit types and validated payloads.
- Validate sender origin, tab, frame, and extension context before privileged actions.
- Return or await asynchronous responses according to the API contract; do not let the channel close early.
- Request the narrowest permissions and host access necessary for the requested feature.
- Handle denied optional permissions as a normal state with a visible recovery path.
- Avoid remote executable code and inline script patterns blocked by extension CSP.

## Content Scripts on Dynamic Pages

- Prefer stable roles, labels, data attributes, and semantic anchors over generated class chains.
- Make injection idempotent with a stable marker.
- Observe the smallest stable container and debounce mutation handling.
- Disconnect observers and remove injected UI during teardown or navigation when appropriate.
- Account for client-side routing, delayed content, iframes, isolated worlds, and repeated extension reloads.
- Use programmatic injection only when its permissions and lifecycle are deliberate.

## Storage and Upgrades

- Use chrome.storage.local or sync according to ownership, quota, privacy, and cross-device needs.
- Await reads and writes; a rendered UI update does not prove persistence succeeded.
- Listen for storage changes when popup, options, worker, and content contexts must stay synchronized.
- Version stored schemas and migrate them without discarding existing user data.
- Treat localStorage as page-context storage, not shared extension state.

## Popup, Options, and Assets

- Set explicit min/max inline sizes for popup html, body, and the app root.
- Reserve space for loading and error states; avoid horizontal overflow and viewport-unit assumptions.
- Test keyboard focus, display scaling, long labels, non-ASCII text, and offline mode.
- Bundle runtime fonts and assets locally, include all used weights and styles, and verify CSP-safe paths.
- Keep secrets and privileged data out of extension page bundles.

## Verification

- Build the production output and load that directory through the extension manager.
- Inspect the service-worker console, each extension page, and content-script errors separately.
- Test install, update, extension reload, worker suspension, browser restart, cold page load, client-side navigation, delayed target DOM, and repeated mutations.
- Test storage restoration without first opening the popup.
- Test denied permissions, removed host access, offline mode, invalid messages, and missing target elements.
- Inspect the packaged archive for source maps, secrets, unused permissions, remote dependencies, and unintended files.
