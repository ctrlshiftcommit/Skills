# Electron Guide

## Architecture

- Keep filesystem, database, shell, and native OS access in the main process.
- Expose a small typed API through a preload script using `contextBridge`.
- Keep `contextIsolation: true`, `nodeIntegration: false`, and sandboxing enabled where compatible.
- Validate every IPC argument in the main process. Do not expose raw `ipcRenderer`, arbitrary file access, or command execution to the renderer.
- Open external URLs only after validating their protocol and destination.

## Remove Electron Name and Logo

Branding has several independent sources. Check all of them:

1. Set `name`, `description`, and preferably `productName` in `package.json`.
2. Set the packager/builder `appId`, `productName`, artifact name, and platform icons.
3. Call `app.setName(productName)` before creating windows when runtime identity needs it.
4. Set each `BrowserWindow` title and icon; set the HTML `<title>` as a fallback.
5. Replace renderer favicons, splash assets, About dialog text, tray icons, and notification icons.
6. Configure installer/uninstaller, Start Menu shortcut, desktop shortcut, and executable icon.
7. Remove development menus when the product does not need them; do not hide useful menus accidentally on platforms where they are conventional.
8. Rebuild and reinstall. Windows caches icons and shortcut metadata, so an old installed build can look unchanged after the source is fixed.

Use platform formats expected by the packager: `.ico` for Windows, `.icns` for macOS, and suitable PNG sizes for Linux. Inspect the installed app, taskbar/dock, Alt-Tab view, shortcuts, notifications, file dialogs, and Apps list.

## Fix Minimize and Maximize

First determine whether the app uses the native frame or a frameless/custom title bar.

For native frames:

- Confirm `frame` is enabled and `minimizable`, `maximizable`, `resizable`, and `closable` are not disabled.
- Check kiosk, fullscreen, modal, parent-window, and fixed-size settings.
- Test platform behavior directly; maximize may intentionally be unavailable for a non-resizable window.

For custom title bars:

- Put window operations in the main process.
- Expose only named methods from preload, such as `minimize`, `toggleMaximize`, and `close`.
- Wire button click handlers after the DOM/component mounts.
- Update the maximize icon and accessible label on `maximize` and `unmaximize` events.
- Mark draggable title-bar regions with `-webkit-app-region: drag` and every interactive control with `-webkit-app-region: no-drag`.
- Do not place an invisible drag region over the buttons.
- Preserve double-click-to-maximize behavior where users expect it.

Example main-process handlers:

```js
ipcMain.handle('window:minimize', (event) => {
  BrowserWindow.fromWebContents(event.sender)?.minimize()
})

ipcMain.handle('window:toggle-maximize', (event) => {
  const win = BrowserWindow.fromWebContents(event.sender)
  if (!win) return false
  win.isMaximized() ? win.unmaximize() : win.maximize()
  return win.isMaximized()
})
```

Authorize IPC by sender when untrusted or remote content can reach the window.

## Layout and Theme

- Make the window usable at its configured `minWidth` and `minHeight`.
- Use CSS Grid/Flexbox and `minmax()`, `clamp()`, and wrapping instead of screen-specific coordinates.
- Set `min-width: 0` on grid/flex children that contain long text.
- Give content regions `overflow: auto`; avoid making the entire frameless window unintentionally draggable.
- Use semantic CSS variables for every foreground/background pair and native `color-scheme` where appropriate.
- Read [ui-quality.md](ui-quality.md) for centering, contrast, encoding, and the visual test matrix.

## Build and Packaging Problems

- Keep development and packaged paths separate; use `app.isPackaged` and `app.getAppPath()` deliberately.
- Load bundled assets through paths that work inside `app.asar`; unpack only native binaries or files that truly require direct filesystem access.
- Rebuild native modules for Electron's ABI. A module working under plain Node does not prove it works under Electron, and the reverse is also true.
- Confirm preload scripts and worker files are included by the bundler and packager.
- Sign distributables when shipping outside local testing; unsigned Windows builds commonly trigger SmartScreen warnings.
- Test the installed artifact, not only the unpacked directory.
- Verify update metadata and artifact cleanup rules before deleting builder output.

## Electron Verification

- Launch with development tools and fix renderer, preload, and main-process errors.
- Package and install on each target OS available.
- Test cold launch, single-instance behavior, deep links/file associations if used, minimize, maximize/restore, resize, close, relaunch, tray, and notifications.
- Test with no network, missing files, read-only paths, and non-ASCII user paths.
- Confirm no development URL, DevTools, Electron logo, default menu, or generic Electron name leaks into the release unless intentionally retained.
