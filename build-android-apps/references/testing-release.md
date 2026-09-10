# Android Testing, Device QA, and Release Guide

## Contents

1. Verification ladder
2. Automated tests
3. UI and lifecycle QA
4. Device and ADB safety
5. Resource-constrained Gradle builds
6. Release configuration
7. Packaging and handoff

## Verification ladder

Use evidence proportional to risk:

1. compile the affected source set;
2. run focused unit tests;
3. run relevant UI or instrumentation tests;
4. run formatting/static checks and Android lint;
5. assemble the intended variant;
6. inspect the merged manifest and APK;
7. install with data preservation;
8. exercise the complete changed journey;
9. inspect Logcat and capture screenshots;
10. repeat high-risk flows on a representative physical device.

Do not substitute one layer for another. Unit tests do not prove manifest wiring; compilation does not prove UI; an emulator does not prove OEM Settings behavior; a debug build does not prove R8.

## Automated tests

Pure unit tests should cover:

- validation and business rules;
- time, schedules, and precedence;
- state reducers and ViewModels;
- repositories with fakes;
- serialization and import validation;
- permission/capability policy decisions.

Use deterministic clocks and dispatchers when time or concurrency matters. Test boundaries, overflow, locale/timezone changes, retries, and duplicate callbacks.

Room tests should verify constraints, transactions, queries, and every supported migration. WorkManager tests should verify constraints, retries, idempotency, and repository effects rather than framework internals.

Compose/UI tests should cover critical user journeys and semantics: navigation, input, validation, scrolling to actions, denied states, Back, and state restoration. Prefer stable semantic matchers over coordinates or visual text placement.

Instrumentation tests should focus on Android wiring that cannot be trusted in a JVM test. Keep them targeted so they remain maintainable.

## UI and lifecycle QA

For materially changed screens, inspect:

- small, typical, and large supported windows;
- portrait and landscape;
- gesture and three-button navigation;
- system bars, cutouts, and edge-to-edge;
- default and increased font/display scale;
- keyboard hidden/open and field focus;
- light, dark, and dynamic/app-selected theme;
- short, long, localized, and non-ASCII content;
- loading, empty, error, disabled, denied, and degraded states.

Exercise cold launch, warm resume, background/foreground, rotation or resize, process recreation, and relaunch. For persisted work, test a realistic in-place upgrade.

Capture screenshots from the installed app. Compose previews and screenshot goldens are useful iteration tools, not substitutes for runtime inspection.

For each materially changed visual flow:

1. Capture the current installed screen before editing.
2. Store the capture in an OS temporary directory outside the repository; use a binary-safe `adb exec-out screencap -p` capture path.
3. Open and visually inspect the capture. Compare it with the approved reference and record crop, scale, hierarchy, density, clipping, and state mismatches.
4. After the final data-preserving install, navigate to the same real state, capture again, and inspect the result before claiming success.
5. Remove the temporary captures and any copied Logcat/crash files when verification is complete. Never commit personal-phone captures.
## Device and ADB safety

Before touching a physical phone:

1. prove the feature on an emulator;
2. identify the exact device serial;
3. confirm the intended APK, package, variant, and signing identity;
4. preserve app data with an upgrade install;
5. perform only the interaction the user authorized.

Safe local upgrade:

```text
adb -s <serial> install -r <apk>
```

For wireless debugging, record the exact authorized `<host>:<port>` endpoint, confirm it with `adb devices -l`, reconnect with `adb connect <host>:<port>` only when needed, and pass that serial to every command. Avoid restarting the ADB server casually because doing so can drop an otherwise healthy wireless pairing. Confirm the installed package version after the upgrade and preserve data; never use uninstall as an install-repair shortcut.

Do not automatically launch, navigate, change the default Home, enable Accessibility, activate device administration, grant special access, clear data, uninstall, reboot, or run destructive commands unless the user explicitly authorized that exact action.

When testing launcher, Accessibility, administrator, VPN, overlay, or other high-impact behavior:

- verify deactivation and recovery on an emulator first;
- keep Android Settings, emergency functions, and system UI reachable;
- start with a short reversible test;
- verify timeout and recovery paths before longer sessions;
- stop if the app or device enters an unexpected state.

An offline or unauthorized device is not a code failure. Report it and retry only non-destructive discovery.

## Resource-constrained Gradle builds

Distinguish a Java `OutOfMemoryError`, a Kotlin/Gradle daemon crash, and an OS low-memory process kill from a source failure. Preserve the original stack trace and retry one controlled build rather than repeatedly starting more daemons.

A safe low-memory fallback is:

1. Stop stale Gradle/Kotlin daemons when they are consuming memory.
2. Run the repository wrapper with `--no-daemon --max-workers=1` and only the required task.
3. Disable parallel/configuration-cache work for that retry when the project permits it.
4. Set a command-local Gradle heap that fits the host; a larger heap can worsen an OS-memory failure, while too small a heap can cause Java OOM.
5. Re-run the original verification gate after a successful fallback. Do not treat a reduced build task as proof that skipped tests or lint passed.

Do not commit machine-specific memory settings merely to get one constrained host through a build.
## Release configuration

Confirm:

- stable application ID and namespace;
- monotonically increasing version code;
- accurate user-facing version name;
- min, target, and compile SDK choices;
- release signing outside source control;
- resource shrinking and R8 behavior;
- ProGuard/R8 keep rules for reflection, serialization, JNI, and libraries;
- release logging and debuggability;
- backup/data-extraction policy;
- supported ABIs and package size;
- distribution-specific policy and disclosures.

Build and test a release-relevant artifact. Debug success does not prove release success.

Review the merged manifest for:

- permissions and features;
- exported components;
- intent filters and deep links;
- providers and authorities;
- package visibility;
- foreground-service types;
- backup and network-security configuration;
- debug-only components or test flags.

Use APK Analyzer, `apkanalyzer`, `aapt`, `bundletool`, or the IDE to inspect the packaged result when relevant.

## Packaging and handoff

Before delivery:

- run the agreed test and lint gates;
- install the final artifact or explicitly state why it was not installed;
- record artifact path, variant, application ID, version, size, and checksum when useful;
- confirm upgrade versus clean-install behavior;
- list user actions still required for system permissions or roles;
- report exact device/API coverage and any untested risk;
- confirm the final installed-build screenshot was inspected;
- confirm temporary device captures, generated approval previews, crash logs, and extraction artifacts are outside the repository or removed.

Never commit signing secrets or claim a flow passed without running it. Do not create alternate compressed builds unless the user requested multiple variants.
