# Android Field Notes

This is the mutable knowledge layer for verified native Android problems discovered during real work. Search it before diagnosing a related issue. Add or revise entries only when the user explicitly asks the skill to remember the lesson.

## Entry Template

<!--
### lowercase-stable-id

- Platform: android
- Applies to: framework, tool, or version context
- Symptom: what the user observes
- Root cause: verified technical cause
- Fix: concise reusable repair
- Verify: commands and runtime checks that proved the fix
- Avoid: tempting workaround that does not solve the cause
- Tags: comma-separated search terms
-->

## Contents

- [Unreadable theme text](#android-unreadable-theme-text)
- [Catalog refresh must publish the current snapshot](#android-catalog-refresh-must-publish-current-snapshot)
- [Metadata refresh must not overwrite user state](#android-metadata-refresh-must-not-overwrite-user-state)
- [Enforcement snapshots must own rule values](#android-enforcement-snapshot-must-own-rule-values)
- [Unknown-package policy needs launchable provenance](#android-unknown-package-policy-needs-launchable-provenance)
- [Usage-query empty is not zero](#android-usage-query-empty-is-not-zero)
- [Coroutine cancellation must escape broad catches](#android-coroutine-cancellation-must-escape-broad-catches)
- [Release must not use debug signing](#android-release-must-not-use-debug-signing)
- [Protected grayscale needs honest activation](#android-protected-grayscale-needs-honest-activation)
- [Bulk “all” must be semantic, not truncated](#android-bulk-all-must-be-semantic-not-truncated)
- [Fail-open paths still need local evidence](#android-fail-open-paths-still-need-local-evidence)
- [A passing build can hide processor fallback](#android-passing-build-can-hide-processor-fallback)
- [Countdown options must match the enforced duration](#android-countdown-options-must-match-enforced-duration)
- [A time-control audit must trace the whole loop](#android-time-control-audit-must-trace-the-whole-loop)

## Lessons

### android-unreadable-theme-text

- Platform: android
- Applies to: Android Compose and Android XML Views
- Symptom: Text becomes black on a black background or white on a white background
- Root cause: Components use inherited or hardcoded colors that do not match the active Material surface and theme
- Fix: Use semantic Material foreground and background roles, then set component content colors from the actual container
- Verify: Render every component state in light and dark themes and check contrast, including disabled fields, dialogs, snackbars, and buttons
- Avoid: Fixing individual labels with hardcoded black or white values
- Tags: theme,dark-mode,light-mode,contrast,text,color

### android-catalog-refresh-must-publish-current-snapshot

- Platform: android
- Applies to: Launcher and installed-app catalogs backed by PackageManager or LauncherApps flows
- Symptom: Package broadcasts or lifecycle refreshes run, but newly installed, removed, or renamed apps never appear in the visible list
- Root cause: The producer compares complete and primary results from the same refresh instead of comparing the completed result with the last published snapshot, or marks an empty first result as permanently usable
- Fix: Retain the last published snapshot and emit every completed catalog that differs from it; model empty or failed initial discovery explicitly and keep optional fast primary emission separate from final publication
- Verify: Drive empty-to-populated, add, remove, rename, primary-equals-complete, primary-to-enriched-complete, rapid invalidation, and process-restart sequences and assert every changed final snapshot is emitted once
- Avoid: Adding more refresh triggers without proving that a changed snapshot is actually published
- Tags: launcher,package-manager,launcherapps,flow,refresh,stale-list
### android-metadata-refresh-must-not-overwrite-user-state

- Platform: android
- Applies to: Room-backed package catalogs with user-managed role, favorite, hidden, or custom-label fields
- Symptom: A label refresh or package replacement unexpectedly reverts a user role, favorite order, Home selection, or custom metadata
- Root cause: A read-copy-upsert metadata refresh races with a user edit and writes an obsolete full entity over newer columns
- Fix: Use a transaction with insert-if-absent and column-scoped metadata updates, or optimistic version checks; never rewrite user-owned columns merely to refresh a system label
- Verify: Run concurrent label-refresh and role/favorite/custom-label edits repeatedly and assert first-seen and every user-owned field are preserved
- Avoid: Assuming a preliminary equality check makes a later full-entity upsert race-free
- Tags: room,race,upsert,catalog,metadata,lost-update
### android-enforcement-snapshot-must-own-rule-values

- Platform: android
- Applies to: Focus, parental-control, launcher, or digital-wellbeing sessions whose settings remain editable while enforcement is active
- Symptom: Editing, disabling, deleting, or increasing a rule or timer weakens a protection session that was advertised as immutable
- Root cause: The session snapshots package IDs or rule IDs, but the evaluator still loads mutable live rule values or timer state during each decision
- Fix: Snapshot every value required to evaluate the running session and make that snapshot the sole authority until expiry or trusted recovery; apply live edits only to future sessions
- Verify: Start a session, mutate every supported rule and timer in each direction, restart the process, and assert current decisions stay fixed while a subsequent session receives the edits
- Avoid: Hiding Settings or storing rule IDs while continuing to dereference mutable live rows
- Tags: snapshot,enforcement,locked-mode,rules,timers,immutability
### android-unknown-package-policy-needs-launchable-provenance

- Platform: android
- Applies to: Foreground-app enforcement that blocks newly installed launchable packages but must allow unknown system surfaces
- Symptom: A newly installed app can open during an active lock before asynchronous catalog persistence records it
- Root cause: Unknown packages fail open to protect system UI, and the decision cannot distinguish an unrecorded launchable app from an arbitrary Android surface
- Fix: Carry trusted launchable provenance and first-seen evidence separately from arbitrary foreground package observations, then apply the new-app snapshot policy only to confirmed launchables
- Verify: Install and immediately open an app during a lock while also exercising System UI, permission dialogs, installer, Settings recovery, work-profile entries, and package replacement
- Avoid: Blocking every unknown package or requesting QUERY_ALL_PACKAGES as a shortcut
- Tags: package-visibility,new-app,fail-open,launcher,enforcement,safety
### android-usage-query-empty-is-not-zero

- Platform: android
- Applies to: UsageStats, keyguard-event, health, battery, and other permission-gated aggregate readers
- Symptom: Denied access, an OEM query failure, incomplete history, and a real zero all render as the same believable zero value
- Root cause: The platform adapter catches exceptions or absent access and returns an empty domain snapshot without availability or completeness metadata
- Fix: Return an explicit success, unavailable, partial, or error outcome; define inclusion filters before computing totals and use the documented number of complete periods as the average denominator
- Verify: Exercise denied access, thrown platform queries, empty data, partial history, excluded system/self packages, day boundaries, and time-zone changes and assert labels and totals remain honest
- Avoid: Using empty collections as both the failure sentinel and a valid measured result
- Tags: usagestats,analytics,empty-state,error,availability,averages
### android-coroutine-cancellation-must-escape-broad-catches

- Platform: android
- Applies to: Kotlin Flow collectLatest, mapLatest, lifecycle scopes, and suspending persistence loops
- Symptom: Superseded refresh work continues, writes stale state, or rebuilds UI after a newer flow emission
- Root cause: runCatching or catch Exception intercepts CancellationException around a suspending call and treats cancellation as an ordinary recoverable failure
- Fix: Catch CancellationException first and rethrow it; catch only expected platform or persistence failures afterward and keep non-suspending result wrappers narrowly scoped
- Verify: Delay the old operation, emit a replacement, cancel the scope, and assert the old path performs no later writes or UI publication
- Avoid: Wrapping an entire suspending collector body in runCatching for convenience
- Tags: kotlin,coroutines,cancellation,flow,collectlatest,race
### android-release-must-not-use-debug-signing

- Platform: android
- Applies to: Android application release variants and CI distribution artifacts
- Symptom: An APK named release builds successfully but has the debug certificate and cannot establish a safe production update identity
- Root cause: The release build type explicitly reuses the debug signingConfig, often to make local assembleRelease convenient
- Fix: Inject release signing from local or CI secrets outside source control, fail distribution tasks when it is absent, and keep any unsigned local-release workflow explicitly named and non-distributable
- Verify: Inspect the final APK or AAB signing certificate and scheme, compare the expected fingerprint, install an upgrade over the prior production build, and launch the minified artifact
- Avoid: Treating assembleRelease success, filename, minification, or non-debuggable state as signing proof
- Tags: release,signing,debug-key,apk,aab,certificate,ci
### android-protected-grayscale-needs-honest-activation

- Platform: android
- Applies to: System-wide or per-app grayscale implemented through secure display color-correction settings
- Symptom: An in-app grayscale switch opens Settings every time, silently does nothing, or claims a normal runtime permission can enable direct control
- Root cause: The display daltonizer keys require WRITE_SECURE_SETTINGS, which an ordinary third-party app cannot self-grant; an overlay cannot desaturate arbitrary interactive apps safely
- Fix: Provide an honest Settings/reminder fallback and, only when the product accepts a technical setup, a one-time explicit-device ADB activation followed by verified in-app toggling; preserve other accessibility color-correction modes
- Verify: Test permission absent, present, and revoked; monochromacy enable/disable; another correction mode active; process death and reboot; timed restore; notification denial; and physical display output on explicitly selected OEM devices
- Avoid: Requesting WRITE_SETTINGS as if it covers secure settings, hiding the computer requirement, using implicit-device ADB, or screen-capture overlays
- Tags: grayscale,write-secure-settings,daltonizer,adb,accessibility,color-correction
### android-bulk-all-must-be-semantic-not-truncated

- Platform: android
- Applies to: Rule editors that offer all apps, every item, select all, or future items behavior
- Symptom: The UI claims every eligible target is protected but a storage or validation cap silently prevents the bulk state on larger devices
- Root cause: The product models all as a materialized finite ID set subject to a target-count ceiling instead of storing the semantic policy
- Fix: Persist an explicit all-eligible mode with protected exclusions and define whether future items join automatically; otherwise label and validate the exact finite cap before selection
- Verify: Test zero, one, cap, cap-plus-one, newly installed, removed, protected, work-profile, and restored targets and compare saved policy with user-facing copy
- Avoid: Selecting the first capped subset while retaining words such as all or every
- Tags: bulk-selection,limits,rules,copy,package-catalog,semantics
### android-fail-open-paths-still-need-local-evidence

- Platform: android
- Applies to: Safety-sensitive launchers, accessibility services, capability monitors, and local-only apps
- Symptom: A capability, catalog, usage, or enforcement feature degrades to empty or allowed state and neither the user nor developer can determine why
- Root cause: Broad exception handling correctly avoids a crash or lockout but discards failure category, state transition, and bounded diagnostic context
- Fix: Keep the safe fail-open decision while mapping expected failures to explicit degraded UI and recording a bounded, redacted, local-only diagnostic trail with no content or secrets
- Verify: Inject each platform and persistence failure, confirm emergency/recovery surfaces remain reachable, confirm the degraded state is honest, and inspect that diagnostics are bounded and contain no sensitive payloads
- Avoid: Crashing closed, blocking unknown system surfaces, swallowing CancellationException, or adding network telemetry without a product and privacy decision
- Tags: fail-open,diagnostics,local-only,accessibility,safety,observability
### android-passing-build-can-hide-processor-fallback

- Platform: android
- Applies to: Kotlin 2.x Android builds using KAPT and Room schema export
- Symptom: The APK builds successfully while logs say KAPT fell back to an older language level or Room schema processor arguments were not recognized
- Root cause: The Kotlin language level, annotation-processing backend, and compiler plugin versions are only compatibility-tolerated rather than deliberately aligned, so generated-code or schema tasks may not provide the expected evidence
- Fix: Align a supported Kotlin and processor combination or migrate Room deliberately to compatible KSP; treat processor warnings as release evidence until a clean build proves generation and schema export
- Verify: Run from clean generated outputs, change a test entity, confirm expected generated sources and a new Room schema snapshot, compile all variants, and run a migration test from a real prior schema
- Avoid: Calling the pipeline healthy merely because assemble succeeds or deleting schema snapshots and processor arguments to silence warnings
- Tags: kotlin,kapt,ksp,room,schema,annotation-processing,build-warning

### android-countdown-options-must-match-enforced-duration

- Platform: android
- Applies to: Mindfulness gates, focus launchers, parental controls, app timers, cooldowns, and any flow where one countdown hands off to another timed allowance
- Symptom: The user selects a duration after a countdown, but the app starts a different configured timer, grants a different allowance, or shows choices that the enforcement layer ignores
- Root cause: Duration choices are recreated independently in the domain, service, Activity, and UI instead of being carried as part of one enforcement decision; the command handler then trusts stale presentation state or substitutes live configuration
- Fix: Make the authoritative evaluator emit the permitted durations, propagate them through every platform/intent boundary, render only those values, and validate the selected value again against current durable configuration before creating the grant or timer
- Verify: Test the default choices, a configured non-default duration, configuration changed while the countdown is visible, forged or stale intent extras, process recreation, and the exact transition from countdown completion to the next block/cooldown decision
- Avoid: Hard-coding the same-looking duration list in several layers, accepting any positive minute value, or silently starting the configured timer after the user tapped a different label
- Tags: countdown,timer,duration,intent,enforcement,state-validation,accessibility

### android-time-control-audit-must-trace-the-whole-loop

- Platform: android
- Applies to: Digital-wellbeing, focus, launcher, screen-time, scheduling, and local enforcement apps with several overlapping limits
- Symptom: Individual timer tests pass, but real users see late blocks, stale active cards, limits that fail open after a permission change, or one setting unexpectedly overriding another
- Root cause: Controls are reviewed by screen rather than as an end-to-end loop of durable owner, clock source, capability dependency, precedence, observation cadence, expiry action, recovery path, and UI reconciliation
- Fix: Maintain a control matrix for every timer/rule; use deterministic clocks in policy tests, monotonic time for same-boot countdowns, a documented wall-clock/reboot policy for durable deadlines, explicit capability degradation, one precedence table, and a periodic or deadline-driven expiry signal for time-only state changes
- Verify: For every control, exercise exact boundary, foreground/background, screen-off, process death, reboot, manual clock and zone changes, permission revocation, overlapping higher/lower-priority rules, natural expiry with no database mutation, and the installed Accessibility-to-block-Activity handoff
- Avoid: Treating a saved value, animated countdown, green JVM suite, or successful build as proof that Android will redirect the foreground app at the promised time
- Tags: timers,limits,schedules,precedence,clock,expiry,permissions,accessibility,e2e

### android-active-timer-edits-must-preserve-running-window

- Platform: android
- Applies to: App timers and cooldown controls whose configuration remains editable while a timed window is running
- Symptom: Turning a timer off in Settings immediately removes an already-started session or cooldown and lets the app reopen early
- Root cause: The configuration row is also the runtime state row, so disabling deletes the deadlines that enforcement still needs
- Fix: Separate pending configuration from active runtime state, or reject the weakening edit until the current session and cooldown finish; never delete active deadlines through ordinary Settings
- Verify: Start a timer, attempt disable and shorter edits during both the open window and cooldown, restart the process, test exact boundaries, then confirm removal succeeds only after expiry
- Avoid: Treating a Settings toggle as authority to erase an active enforcement window
- Tags: timers,cooldown,settings,immutability,persistence
### android-capabilities-must-disable-only-dependent-rules

- Platform: android
- Applies to: Enforcement engines combining UsageStats, Accessibility observation, schedules, and durable timers
- Symptom: Revoking one Android capability silently disables unrelated rules that obtain their evidence from another source
- Root cause: A single broad enabled flag is applied to several budgets even though only some depend on the missing capability
- Fix: Declare the evidence and capability dependency per rule input, remove only unavailable inputs from the evaluation context, and expose a precise degraded state
- Verify: Revoke each capability independently while exercising every rule kind and assert only the dependent decisions fail open
- Avoid: Using one usageBudgetsEnabled or protectionReady switch for semantically different evidence sources
- Tags: capabilities,usagestats,accessibility,degraded-state,enforcement
### android-managed-rule-targets-must-follow-role-edits

- Platform: android
- Applies to: Onboarding-created shared rules whose target set is later managed from Settings
- Symptom: A newly managed app receives one limit but misses a shared opening pause, while a removed app remains targeted by the old onboarding rule
- Root cause: Onboarding persists a one-time target snapshot and later role edits update app preferences without reconciling the owned shared rule
- Fix: Give the shared rule a stable owner identity and reconcile its targets atomically whenever managed or essential roles change, when the editor opens, and during relevant migrations
- Verify: Add, remove, and make apps essential after onboarding, restart the process, and assert every consumer sees the same target set without touching unrelated user rules
- Avoid: Treating onboarding selections as a permanently authoritative category list
- Tags: onboarding,settings,rule-targets,synchronization,roles,mindful-delay
### android-room-schema-change-needs-upgrade-preservation-test

- Platform: android
- Applies to: Room schema changes that add enforcement, timer, session, or recovery state
- Symptom: A fresh install builds and works but an in-place upgrade crashes, loses state, or silently resets a protection contract
- Root cause: Only the current generated schema is compiled; no test creates a real exported prior schema, seeds data, runs every registered migration, and validates the latest schema
- Fix: Export and commit every schema, register explicit non-destructive migrations, add MigrationTestHelper coverage from each supported prior version, seed contract-critical rows, and verify both schema and preserved values
- Verify: Compile the instrumentation source, run it on an explicitly selected emulator or device, then perform a data-preserving install upgrade with the actual release-relevant artifact
- Avoid: Using fallbackToDestructiveMigration or treating schema JSON generation and a green fresh-install unit suite as upgrade proof
- Tags: room,migration,upgrade,persistence,instrumentation,schema
### android-schedule-boundaries-need-one-deterministic-policy

- Platform: android
- Applies to: Recurring local-time schedules evaluated by repositories, services, workers, and UI previews
- Symptom: Overnight, same-minute, all-day, or day-of-week schedules disagree between previews and foreground enforcement
- Root cause: Boundary math is duplicated in several layers and eventually diverges in inclusivity or previous-day handling
- Fix: Route every production caller and preview through one pure policy with injected local time and zone; keep storage and UI mapping free of independent boundary calculations
- Verify: Test start, end, one millisecond or minute around each edge, all-day equality, overnight previous-day ownership, every weekday bit, DST, and zone changes
- Avoid: Copying a small-looking time-window when expression into each consumer
- Tags: schedules,time-boundaries,overnight,dst,policy,duplication