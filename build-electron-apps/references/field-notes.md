# Electron Field Notes

This is the mutable knowledge layer for verified Electron desktop problems discovered during real work. Search it before diagnosing a related issue. Add or revise entries only when the user explicitly asks the skill to remember the lesson.

## Entry Template

<!--
### lowercase-stable-id

- Platform: electron
- Applies to: framework, tool, or version context
- Symptom: what the user observes
- Root cause: verified technical cause
- Fix: concise reusable repair
- Verify: commands and runtime checks that proved the fix
- Avoid: tempting workaround that does not solve the cause
- Tags: comma-separated search terms
-->

## Lessons

### electron-unreadable-theme-text

- Platform: electron
- Applies to: Electron renderer UI
- Symptom: Text becomes black on a black background or white on a white background
- Root cause: Components use inherited or hardcoded colors that do not match the active renderer surface and theme
- Fix: Use semantic CSS foreground and background variables, then set component content colors from the actual container
- Verify: Render every component state in light and dark themes in development and packaged runtimes
- Avoid: Fixing individual labels with hardcoded black or white values
- Tags: theme,dark-mode,light-mode,contrast,text,color

### electron-ipc-bridge-contract

- Platform: electron
- Applies to: Electron main process, preload, and renderer
- Symptom: Renderer IPC calls fail, reach the wrong handler, or require unsafe Node access
- Root cause: Channel names drift between sender and handler, or the preload exposes raw IPC or Node capabilities
- Fix: Define an allowlisted channel contract shared by both ends, validate channel names and payloads in preload and main, and expose narrow methods with contextBridge.exposeInMainWorld
- Verify: Exercise every exposed method from the renderer and confirm unknown channels and malformed payloads are rejected
- Avoid: Enabling nodeIntegration or exposing ipcRenderer, require, fs, or arbitrary send methods
- Tags: ipc,contextBridge,preload,renderer,security,channels

### electron-destroyed-window-instance

- Platform: electron
- Applies to: Electron BrowserWindow lifecycle
- Symptom: Window actions throw after a window is closed or create duplicate windows
- Root cause: Code keeps stale BrowserWindow references or relies on implicit window lookup
- Fix: Track each window instance explicitly, set its reference to null on closed, and guard operations with isDestroyed before calling methods
- Verify: Open, close, recreate, and invoke window actions repeatedly without stale-reference errors or duplicate instances
- Avoid: Calling methods on a cached BrowserWindow without checking its lifecycle
- Tags: BrowserWindow,lifecycle,isDestroyed,window-management

### electron-sqlite-before-init

- Platform: electron
- Applies to: Electron with better-sqlite3
- Symptom: Queries fail during startup or run against an uninitialized database handle
- Root cause: Renderer or startup tasks can reach repository code before database initialization completes
- Fix: Initialize better-sqlite3 once in the main process, expose repositories only after init succeeds, and keep its query flow synchronous and transaction-based where atomicity is required
- Verify: Test cold launch, initialization failure, migrations, concurrent IPC requests, and packaged runtime queries
- Avoid: Running queries before init confirmation or wrapping synchronous better-sqlite3 calls in misleading fire-and-forget flows
- Tags: sqlite,better-sqlite3,database,initialization,transactions

### electron-puppeteer-profile-singleton

- Platform: electron
- Applies to: Electron automation using Puppeteer
- Symptom: Login sessions disappear or multiple browser processes compete for the same profile
- Root cause: Each action launches a fresh browser or uses a temporary profile instead of the persistent userDataDir
- Fix: Use a stable userDataDir, restore the same profile on launch, keep one owned browser instance, and reconnect or recreate it only after confirming the previous instance ended
- Verify: Authenticate once, restart the app, confirm the session persists, and trigger concurrent actions without launching duplicate browsers
- Avoid: Launching a browser per request or opening the same userDataDir in competing processes
- Tags: puppeteer,userDataDir,session,persistence,singleton,browser

### electron-puppeteer-dynamic-dom-targeting

- Platform: electron
- Applies to: Puppeteer automation of dynamic third-party UIs such as WhatsApp Web
- Symptom: Automation breaks when generated classes, DOM nesting, or load timing changes
- Root cause: Selectors depend on brittle implementation details or run before the dynamic target exists
- Fix: Prefer stable attributes, roles, labels, and text-based locators; use waitForSelector or waitForFunction with a bounded generous timeout and visible failure diagnostics
- Verify: Run against cold and warm loads, slow networks, and multiple UI states; capture a screenshot and DOM context on timeout
- Avoid: Hardcoded generated class chains, nth-child selectors, fixed sleeps, or unbounded waits
- Tags: puppeteer,selectors,waitForSelector,dynamic-dom,whatsapp-web,timeouts

### electron-react-css-variable-chromium-drift

- Platform: electron
- Applies to: Electron renderer with React and CSS custom properties
- Symptom: Monochrome or accent colors differ between development, packaged Electron, or Electron versions
- Root cause: The cascade, fallback values, unsupported CSS features, native theme state, or color-scheme handling differs in the bundled Chromium runtime
- Fix: Inspect computed styles in the actual Electron runtime, define complete semantic variables with fallbacks at :root and explicit theme selectors, and test features against the Chromium version bundled with the pinned Electron release
- Verify: Compare computed variables and screenshots in development and packaged builds for light, dark, and app-selected themes
- Avoid: Assuming a Chromium bug before inspecting the cascade, or relying on browser-only defaults and unsupported color functions
- Tags: react,css-variables,chromium,theme,accent,computed-style

### electron-strict-theme-system-interference

- Platform: electron
- Applies to: Electron renderer with strict monochrome or fixed-palette design systems
- Symptom: A black-and-white interface gains unintended system colors or unreadable native controls when OS theme changes
- Root cause: System color preference, nativeTheme, color-scheme, form control defaults, and app theme state are allowed to compete
- Fix: Choose one theme authority, set nativeTheme.themeSource and the document color-scheme deliberately, provide explicit semantic colors for native-looking controls, and synchronize theme changes through one state path
- Verify: Switch OS and app themes independently and inspect text, forms, menus, scrollbars, dialogs, and window chrome
- Avoid: Mixing prefers-color-scheme, hardcoded colors, and app theme classes without precedence rules
- Tags: monochrome,dark-mode,light-mode,nativeTheme,color-scheme,design-system

### electron-webview-scrollbar-target

- Platform: electron
- Applies to: Electron webview and embedded guest content
- Symptom: Custom scrollbar CSS affects the host renderer but not scrollbars inside a webview
- Root cause: The webview guest has its own document and styling context, and Chromium or OS overlay scrollbar behavior may differ
- Fix: Apply scrollbar CSS inside the guest document when content is controlled, or inject narrowly scoped CSS into the guest webContents after it is ready; include standard scrollbar-color/scrollbar-width plus Chromium pseudo-elements where supported
- Verify: Test the actual scroll container inside the webview in packaged Electron on each target OS and with overlay scrollbars enabled and disabled
- Avoid: Styling only the webview host element or assuming every OS exposes the same scrollbar surface
- Tags: webview,scrollbar,insertCSS,guest,chromium,css

### electron-react-text-truncation-constraints

- Platform: electron
- Applies to: React web UI inside Electron
- Symptom: Text refuses to truncate or forces a flex or grid layout wider than its container
- Root cause: The text or an ancestor lacks a definite width constraint, or a flex/grid child retains its default min-width:auto
- Fix: Give the containing region a definite or maximum width, set min-width:0 on shrinking flex/grid children, then apply overflow:hidden, white-space:nowrap, and text-overflow:ellipsis where single-line truncation is intended
- Verify: Test short, long, unbroken, localized, and zoomed text at the minimum window width
- Avoid: Adding ellipsis styles without constraining the element or its flex/grid ancestors
- Tags: react,text-overflow,truncation,ellipsis,flexbox,grid,min-width

### electron-react-library-button-overrides

- Platform: electron
- Applies to: React component libraries in Electron renderers
- Symptom: Button shadows, border radius, colors, or states ignore custom styles
- Root cause: Library variants, theme tokens, CSS specificity, slot structure, or inline styles override the consumer rule
- Fix: Use the library theme or supported variant/slot API first, inspect the rendered element and computed styles, and apply a scoped class or style override at the owning layer
- Verify: Check default, hover, focus, pressed, disabled, and dark/light states in the packaged renderer
- Avoid: Global element selectors, broad !important rules, or styling a wrapper while the library styles the inner button
- Tags: react,button,component-library,css-specificity,theme,styles

