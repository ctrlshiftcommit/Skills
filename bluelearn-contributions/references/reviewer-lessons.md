# Bluelearn reviewer lessons

This reference comes from the user's authored pull requests and moderator feedback read through GitHub CLI on 2026-09-20. It is a working record, not a substitute for reading the current PR discussion.

## PR #435

[Dashboard column filters](https://github.com/bluelearn-org/bluelearn/pull/435) received detailed review from `andyrodrigues30`, a Bluelearn member.

The review required:

- Use `SlidersHorizontalIcon` for filter controls.
- Turn the filtered column name blue and show an `XIcon` that clears that column's filter, following the profile activity table.
- Add ascending and descending A to Z sorting to text filters.
- Match the profile page's date filter UI and provide oldest and newest date sorting.
- Show every status and role option, including options that do not occur in the currently loaded rows.
- Show `No data matches these filters` when the filters produce no rows.
- Add the requested Time Left choices: Any, Expired, `< 1 hr`, `1-4 hrs`, `4-12 hrs`, `12-24 hrs`, and Custom range.
- For Custom range, provide Minimum and Maximum hour inputs with sensible validation.
- Use the linked shadcn radio group and remove the old Base UI dependency and references.
- Run `pnpm typecheck` locally before asking for another review.

The useful general lesson is to inspect the closest existing product interaction and match its behavior and visual language. Automated filter tests do not prove that the authenticated dashboard looks correct in a browser.

## PR #450

[Mature content disclaimer and age gate](https://github.com/bluelearn-org/bluelearn/pull/450) received a moderator comment that the PR template check was failing. Fix the template before tagging the reviewer.

## PR #453

[Objective graph view](https://github.com/bluelearn-org/bluelearn/pull/453) received the same moderator feedback: include the PR template so the template check passes before review.

## Other authored PRs checked

The account's other authored PRs were `the-arnav/perfect-stop#1` and `ctrlshiftcommit/millionaireden#1` through `#6`. The moderator-associated review and issue-comment endpoints returned no additional maintainer feedback for those PRs during this audit. Always read the current discussion because a later comment can change that result.

