# Android Project and Architecture Guide

## Contents

1. Project configuration
2. Package structure
3. State and events
4. Navigation
5. Coroutines and lifecycle
6. Dependency boundaries
7. Common failure patterns

## Project configuration

Keep version ownership centralized. Prefer `gradle/libs.versions.toml` for plugins and libraries, and use the Gradle wrapper committed by the project.

Align:

- Android Gradle Plugin with the Gradle wrapper;
- Kotlin and Compose compiler/plugin requirements;
- JDK with the Android Gradle Plugin;
- `compileSdk` with installed SDK platforms;
- `targetSdk` with current behavior and distribution requirements;
- `minSdk` with the real device audience.

Set `namespace` independently from `applicationId`. Changing an application ID creates a different installed app and is not an upgrade. Use product flavors only for genuine environment or distribution differences.

Keep signing configuration out of committed source. Local properties, environment variables, or CI secrets may point to a keystore; do not commit credentials.

## Package structure

Organize by feature for medium and large apps:

```text
app/
  core/
    data/
    designsystem/
    platform/
  feature/
    onboarding/
    home/
    settings/
```

Small apps may stay in one module and still use feature packages. Add modules only when they improve build isolation, ownership, reuse, or dependency enforcement.

Keep Android entry points thin:

- Activities host Compose and system handoffs.
- Services and receivers validate input, delegate work, and finish quickly.
- ViewModels coordinate UI-facing workflows.
- Repositories own data access and synchronization.
- Pure Kotlin classes own rules and calculations.

## State and events

Expose a single immutable `UiState` per screen or tightly coupled workflow. Represent user actions as explicit functions or events.

Prefer:

```kotlin
data class ScreenUiState(
    val isLoading: Boolean = true,
    val items: List<Item> = emptyList(),
    val message: String? = null,
)

class ScreenViewModel(...) : ViewModel() {
    val uiState: StateFlow<ScreenUiState> = ...
    fun onItemSelected(id: String) { ... }
}
```

Use `collectAsStateWithLifecycle()` in Compose. Avoid launching long-lived collectors directly from a composable without lifecycle control.

Separate durable state from one-time effects:

- durable: selected tab, loaded content, validation state;
- effect: open a system page, show a transient snackbar, launch a document picker.

Model one-time effects with an event channel/flow or by returning control to the UI. Do not encode a consumable event in durable state without a clear consumption protocol.

Treat an onboarding choice as product state when later flows use the same concept. Persist it through the owning repository and prepopulate later setup from that source; do not make the user select the same apps, goals, accounts, or preferences again. Create a separate selection only when its semantics or scope are genuinely different, and explain that difference.

Derive setup alerts from a current state snapshot. Combine persisted configuration with live Android capability checks, refresh on resume and after settings handoffs, and remove the alert as soon as its success condition is true. Do not display a warning merely because an onboarding flag, cached permission value, or test-completed flag is stale.
Use `SavedStateHandle` for small navigation/workflow values that must survive process recreation. Durable product data belongs in Room or DataStore.

## Navigation

Use stable route identifiers and typed arguments where supported. Pass IDs, not large objects. Reload durable objects from their source of truth.

Define navigation ownership clearly:

- top-level host controls destinations;
- screens emit navigation intent;
- ViewModels do not hold `NavController`;
- deep links validate every argument and handle missing data.

For onboarding or setup workflows, persist the last completed step and required answers. Recompute permission and role state from Android after every settings handoff.

Back behavior must be intentional:

- allow system Back for ordinary stacks;
- close transient UI before leaving a screen;
- use predictive Back APIs through current Navigation/Compose support;
- do not consume Back globally unless implementing a true Home/launcher root or another justified surface.

## Coroutines and lifecycle

Use structured concurrency:

- `viewModelScope` for ViewModel work;
- `lifecycleScope` with `repeatOnLifecycle` for Activity/Fragment collection;
- application-owned scopes only for work whose lifetime truly matches the process;
- WorkManager for durable deferrable work.

Inject dispatchers when deterministic tests need control. Do not switch to `Dispatchers.IO` around Room suspend functions merely by habit; Room already dispatches database operations.

Make operations idempotent when they may repeat after recreation, retry, boot, or worker rescheduling.

Never depend only on an in-memory timer for a persisted deadline. Store an absolute wall-clock deadline for reboot survival and, where needed, use monotonic elapsed time while the current boot is active.

## Dependency boundaries

Introduce interfaces at volatile or test-sensitive boundaries:

- system capability checks;
- time;
- package/app catalog;
- network or database sources;
- policy/rule engines.

Do not create an interface for every class. A concrete Room DAO or simple repository is often sufficient.

Use dependency injection consistently if the project already has Hilt/Koin. For small apps, constructor wiring in an application container is acceptable and easier to debug.

## Common failure patterns

- Two sources of truth update the same screen independently.
- Navigation passes mutable objects instead of IDs.
- UI reads Android permission state once and caches it forever.
- A composable starts work on every recomposition.
- A repository exposes mutable collections.
- A receiver performs long work instead of scheduling it.
- Process death restores navigation but not the referenced data.
- Build variants silently use different application IDs or manifests.
- Tests replace behavior with mocks so completely that wiring bugs remain invisible.
