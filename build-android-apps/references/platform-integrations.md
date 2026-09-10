# Android Permissions and Platform Integrations Guide

## Contents

1. Capability model
2. Runtime permissions and special access
3. Restricted settings and protected changes
4. Components and exported surfaces
5. Background work
6. Notifications, links, and system UI
7. Privileged and policy-sensitive APIs
8. Safe failure and verification

## Capability model

Model a platform capability as live state, not a setup checkbox. A feature may depend on several independent facts:

- manifest declaration;
- runtime permission;
- app-op or special access;
- selected system role;
- enabled service or administrator;
- actual service connection;
- OEM restriction;
- current process and device state.

Expose a capability snapshot from one platform boundary and refresh it on launch, resume, and return from Settings. Persist onboarding progress, but never persist a grant as the authority.

For each capability define:

1. the user benefit;
2. the minimum access required;
3. what the app can technically observe or change;
4. the Settings or runtime request path;
5. a live verification test;
6. denied, revoked, and degraded behavior;
7. a recovery route that cannot trap the user.

## Runtime permissions and special access

Request dangerous runtime permissions at the point of need. Group requests only when the permissions support one understandable action.

- Explain before requesting when the reason is not obvious.
- Use Activity Result APIs.
- Handle denial and permanent denial without repeatedly reopening Settings.
- Re-check on resume; users and the system may revoke access.
- Keep the app useful when optional access is absent.

Special access such as Usage Access, notification listener, Accessibility, exact alarms, overlays, VPN, device administration, and default roles is not a normal runtime permission. Open the narrowest relevant Android surface and verify the actual API state afterward.

Do not deep-link to undocumented OEM pages as the only path. Provide a standard Android route and concise manual instructions when device behavior differs.

## Restricted settings and protected changes

Treat Android Restricted Settings as installation-source and system policy, not as a grant the app controls. When Android blocks a sensitive setting for a sideloaded app, do not attempt to bypass it. Give the shortest actionable route only when relevant, re-check the real capability on return, and avoid showing the warning after access works.

A fresh install delivered by Google Play is generally not subject to the sideload-specific untrusted-source gate. Publishing a listing does not change an already sideloaded installation, and OEM behavior can vary, so verify the actual Play-installed build. Accessibility, notification access, and other sensitive capabilities still require their normal user-controlled setup and Play policy compliance.

Before promising an automatic system change such as grayscale, inspect the public API and required permission. If it needs a signature, secure, device-owner, or other protected grant unavailable to an ordinary Play app, implement an honest degraded behavior such as a reminder or settings handoff. Keep in-app copy about what the feature will do; do not expose ADB, protected-permission, or Android-internals explanations unless the user explicitly asks for technical help.
## Components and exported surfaces

Audit every Activity, Service, Receiver, and Provider:

- set `android:exported` explicitly where required;
- export only components that must accept outside calls;
- protect exported components with permissions or strict input validation;
- treat intents, URIs, extras, deep links, broadcasts, and pending intents as untrusted input;
- use immutable `PendingIntent` unless mutation is required;
- avoid implicit intents for sensitive internal actions;
- keep component class names stable when Android persists their identity.

Receivers and services should validate quickly, delegate to repositories or workers, and finish. Avoid long database, file, or network work directly in a receiver.

Use package visibility queries narrowly. Do not add `QUERY_ALL_PACKAGES` unless the product qualifies and scoped queries cannot satisfy the feature.

## Background work

Choose the API by semantics:

| Need | Preferred API |
| --- | --- |
| Guaranteed deferrable work with constraints | WorkManager |
| User-visible ongoing operation that qualifies | Foreground service |
| Exact user-facing event with policy justification | AlarmManager exact alarm |
| Approximate future work | WorkManager or inexact alarm |
| Short reconciliation after boot | boot receiver delegating bounded work |
| UI-lifetime task | lifecycle-aware coroutine |

WorkManager is not an exact scheduler. Workers may run late. Make work idempotent, persist authoritative state outside worker memory, apply sensible constraints and backoff, and cap input/output data.

Foreground services require a valid service type, manifest declarations, runtime prerequisites, a prompt notification, and correct stop behavior. Do not use one merely to keep the process alive.

Boot receivers must do little work. Reconcile persisted state and schedule what is needed. Never assume every OEM restarts a process immediately or preserves an enabled service connection.

## Notifications, links, and system UI

Notifications:

- create stable channels with user-understandable importance;
- request notification permission only when the user enables a notification benefit;
- use unique or deliberately reused IDs;
- make pending intents safe and navigation-aware;
- test denied permission, disabled channel, grouped notifications, and tap actions;
- avoid leaking sensitive content on the lock screen.

Deep links and app links:

- validate scheme, host, path, and every argument;
- handle missing authentication or missing records;
- prevent a link from bypassing required setup or security checks;
- verify cold, warm, and already-open navigation.

Roles and system surfaces:

- request only after the app can fulfill the role;
- verify the role after return;
- preserve a safe exit and a degraded experience if the role is lost;
- never assume a role grants unrelated permissions.

## Privileged and policy-sensitive APIs

Accessibility, device administration, VPN, overlays, default launcher, usage access, notification access, and device-owner APIs have strong user and distribution consequences.

- Confirm that the requested behavior is technically possible for an ordinary app.
- Distinguish device administrator from device owner/profile owner and lock-task/kiosk capabilities.
- Do not claim uninstall prevention, settings lockout, or forced persistence beyond what the selected management mode provides.
- Declare only the policies actually used.
- Avoid wipe, password, camera, lock, or encryption policies unless explicitly required and separately authorized.
- Do not enable, grant, or provision privileged access through ADB on the user's device without explicit authorization.
- Review current distribution policy before publishing an app that uses sensitive APIs.

An enforcement or launcher app must fail open when its authoritative state is corrupt or unreadable. Permanently allow essential system and recovery surfaces. Add loop prevention around redirects. Validate every dangerous flow on an emulator before a personal phone.

The default Home role does not let an ordinary third-party launcher reskin the OEM SystemUI Recents/Overview surface. An ordinary app also cannot make the Home role irrevocable, prevent uninstall, or force-stop another app. Implement timers and cooldowns with the permitted observation plus redirect/blocking behavior, keep recovery reachable, and describe the result truthfully instead of promising system-level control.
## Safe failure and verification

For each integration, test:

- never granted;
- denied once;
- denied permanently;
- granted;
- revoked while the app is backgrounded;
- service enabled but not connected;
- process killed and relaunched;
- device reboot where relevant;
- OEM settings path unavailable;
- corrupt or missing durable state.

Review the merged manifest and packaged APK, not only the source manifest. Confirm there are no accidental permissions, exported components, providers, foreground-service types, queries, or backup behaviors.

Never use uninstall, clear-data, factory reset, device-owner provisioning, destructive ADB, or permission grants as routine verification. Preserve user state and report any test that still needs explicit user action.
