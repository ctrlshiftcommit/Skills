# Android Build Workflow

## Contents

1. Define the product
2. Inspect or create the project
3. Plan the implementation
4. Build vertical slices
5. Integrate Android capabilities
6. Verify continuously
7. Package and hand off

## 1. Define the product

Turn the request into an implementation contract before editing code:

- Identify the primary user journey and the smallest useful release.
- Separate required behavior from later enhancements.
- List data that must survive process death, device restart, upgrade, and restore.
- List Android capabilities such as notifications, camera, location, background work, roles, or special access.
- State what happens when each capability is unavailable or denied.
- Identify destructive or difficult-to-reverse actions and require explicit authorization for them.
- Define acceptance checks in user-observable language.
- For visual work, list every screen and asset in scope, every explicit exclusion, the approved reference, and the required installed-device comparison.
- Keep asset approval separate from implementation approval. A preview or contact sheet is not a production asset.

Do not choose privileged APIs merely because they make enforcement easier. Confirm that the requested behavior is possible for the distribution model: Play Store, enterprise/device-owner, or direct install.

## 2. Inspect or create the project

For an existing project, inspect before changing:

- repository instructions and working-tree state;
- Gradle wrapper, Android Gradle Plugin, Kotlin, JDK, compile SDK, target SDK, and minimum SDK;
- modules, build variants, application ID, namespace, signing setup, and dependency catalog;
- manifest components and permissions;
- UI system, navigation, state ownership, persistence, background work, and tests.

Preserve unrelated user changes. Prefer the project's established patterns unless they are the source of the problem.

For a new native app, default to:

- Kotlin;
- Gradle Kotlin DSL with a version catalog;
- Jetpack Compose and Material 3 unless XML Views are required;
- a single app module until a real boundary justifies more modules;
- coroutines and Flow;
- ViewModels for screen/business state;
- Room for relational durable data and DataStore for small preferences;
- Navigation Compose for multi-screen apps;
- JDK 17 when compatible with the selected Android Gradle Plugin.

Choose SDK and dependency versions from the installed toolchain or current official documentation. Do not invent version combinations.

## 3. Plan the implementation

Create a short dependency-ordered plan. A reliable default order is:

1. project builds and launches;
2. theme, navigation shell, and core models;
3. one complete user journey with in-memory state;
4. persistence and restoration;
5. platform integrations and denied states;
6. secondary screens and polish;
7. automated tests;
8. release build, manifest audit, and installed-device verification.

Implement vertical slices that can be observed and tested. Avoid building every repository layer before any screen works. Do not run the final build/install while a required asset approval or requested slice is still outstanding; focused compile checks may still run during implementation.

Define one owner for each state:

- composable-local state for temporary presentation details;
- ViewModel state for screen and workflow state;
- repository/database state for durable product truth;
- Android system APIs as the live authority for permissions, roles, and special access.

## 4. Build vertical slices

For each slice:

1. Add or update the domain model.
2. Implement repository behavior behind a small interface when it improves testability.
3. Expose immutable UI state and explicit events from the ViewModel.
4. Render loading, content, empty, error, denied, and degraded states as applicable.
5. Connect navigation and system handoffs.
6. Add focused tests.
7. Build and inspect the actual screen.
8. For approved visual work, compare the installed screen with the reference before moving to the next slice.

Keep composables mostly declarative. Move time calculations, validation, filtering, permission checks, and rule evaluation into testable Kotlin.

Do not store an Activity, View, Context, or navigation controller in durable state. Use application context only where an Android API genuinely requires it.

## 5. Integrate Android capabilities

Treat each permission or special-access flow as a state machine:

1. explain the user-facing benefit at the moment it is needed;
2. request or open the correct Android settings surface;
3. re-check the live system state on return and on resume;
4. perform a capability test when a granted flag is insufficient;
5. provide a useful denied/degraded path;
6. never trap the user in a settings loop.

Manifest declarations, runtime grants, app-op access, roles, and service connection are different states. Verify the states the feature actually needs.

Use WorkManager for guaranteed deferrable work. Use alarms, foreground services, or boot receivers only when their semantics are required. Keep boot work short and idempotent.

## 6. Verify continuously

Use the smallest fast check after each edit, then expand:

- compile the affected module;
- run focused unit tests;
- run relevant Compose or instrumentation tests;
- run Android lint;
- assemble the intended debug or release-relevant variant;
- inspect the merged manifest and packaged APK;
- install with data-preserving upgrade semantics;
- exercise the user journey on an emulator or physical device.

For UI work, capture the installed screen before editing and again after the final install. Store temporary captures outside the repository and inspect them for hierarchy, density, crop, rendered asset scale, keyboard behavior, insets, and navigation. A successful build is not visual proof.

For lifecycle-sensitive work, test rotation or size change, background/foreground, process recreation, and relaunch. For persisted behavior, test an in-place upgrade.

## 7. Package and hand off

Before handoff:

- confirm the application ID, version code, version name, and build variant;
- keep signing secrets outside source control;
- verify release R8 behavior when release packaging is in scope;
- review the merged manifest for accidental permissions and exported components;
- record the APK or bundle path and checksum when useful;
- report exactly what was tested and what still requires user action.

Never claim a device flow passed if only compilation or unit tests ran.
