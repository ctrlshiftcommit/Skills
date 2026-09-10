# Android Data, Persistence, and Security Guide

## Contents

1. Choose the storage owner
2. Room databases
3. DataStore and files
4. Process death and restoration
5. Backup, restore, and transfer
6. Secrets and sensitive data
7. Verification

## Choose the storage owner

Match storage to the data:

| Data | Default owner |
| --- | --- |
| Temporary visual state | Composable or View state |
| Restorable screen inputs | `rememberSaveable` or `SavedStateHandle` |
| Small durable preferences | Preferences or Proto DataStore |
| Relational, queryable product data | Room |
| User-selected documents or media | Storage Access Framework or MediaStore |
| Credentials or cryptographic keys | Android Keystore-backed design |
| Deferrable work state | WorkManager input/progress plus the durable repository |

Do not keep product truth only in a singleton, ViewModel, Bundle, worker input, alarm, or notification.

Define retention, deletion, export, backup, and migration behavior before choosing a schema. Store the minimum data the feature needs.

## Room databases

Treat the database as an API:

- use explicit entities, primary keys, indexes, foreign keys, and uniqueness rules;
- expose observable reads with `Flow`;
- use `@Transaction` for multi-table invariants;
- keep domain calculations out of DAOs;
- avoid returning mutable entity collections to UI code;
- perform large imports in bounded transactions;
- make retries and repeated callbacks idempotent.

Every schema version change requires a registered migration. Export schemas and test realistic upgrade paths with Room's migration test utilities.

Never enable destructive migration as a repair for an upgrade failure unless the product explicitly defines the data as disposable and the user has approved the loss.

When time is part of the model, store enough information to preserve semantics:

- UTC instants for absolute deadlines;
- local date/time plus zone or recurrence rules for civil schedules;
- monotonic elapsed time only for calculations within the current boot;
- a deliberate policy for clock, timezone, locale, and daylight-saving changes.

## DataStore and files

Use DataStore for small configuration, not large histories or relational records. Proto DataStore is useful when a typed schema and migrations matter; Preferences DataStore is suitable for a small key-value set.

Use application-private files for internal data. Use the Storage Access Framework when the user should choose and retain access to a document. Persist URI permission only when long-term access is required and granted.

Write important files atomically:

1. write a temporary file in the same storage domain;
2. flush and validate it;
3. replace the authoritative file;
4. retain or remove the previous file according to the recovery policy.

Do not invent broad storage permissions to avoid using Android's scoped storage APIs.

## Process death and restoration

Assume the process can disappear whenever the app is backgrounded.

- Reconstruct screens from navigation arguments and durable repositories.
- Store only small serializable workflow inputs in saved state.
- Reload permissions, roles, services, and app-op state from Android.
- Reconcile persisted work or sessions on launch rather than trusting an old in-memory flag.
- Make startup restoration bounded and able to show loading, degraded, or recovery states.

Test process death separately from configuration change. Rotation does not prove process restoration.

## Backup, restore, and transfer

Choose a backup policy explicitly. Review `android:allowBackup`, data extraction rules, device-transfer rules, excluded files, database sidecars, DataStore files, and keys.

Do not back up:

- device-bound secrets that cannot be restored safely;
- cached or reproducible data;
- stale capability grants;
- active state that would become unsafe or invalid on another device.

Restore transactionally where possible. Version exported formats independently of the Room schema. Validate imported data before replacing current data, and preserve the previous state if validation fails.

If backup is disabled, document how the user exports or recreates important data.

## Secrets and sensitive data

- Never commit API keys, signing passwords, tokens, or keystores.
- Do not place secrets in resources, `BuildConfig`, manifests, intent extras, logs, screenshots, or analytics.
- Android Keystore can protect cryptographic key material, but it does not make arbitrary plaintext secure by itself.
- Hash passwords or PINs with a salted password KDF; do not encrypt them for later recovery.
- Use encrypted storage only when the threat model requires it, and define key invalidation and recovery behavior.
- Mark sensitive activities and screenshots only when the privacy benefit outweighs usability costs.
- Redact logs and crash reports. Release logging must not expose personal data.

Security controls need a failure policy. If a keystore key is invalidated or ciphertext is corrupt, fail safely and provide recovery instead of looping or silently discarding unrelated data.

## Verification

- Unit-test repository rules and time calculations.
- Test Room migrations from every supported historical schema.
- Test empty, large, corrupt, partially imported, and duplicate data.
- Test process recreation and app relaunch.
- Test in-place APK upgrade with existing data.
- Test backup/restore or verify exclusions in the packaged manifest and rules.
- Inspect release logs for sensitive values.
- Confirm deletion and reset affect only the intended records.
