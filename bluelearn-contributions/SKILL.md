---
name: bluelearn-contributions
description: Plan, implement, review, test, and update Bluelearn open-source contributions with repository conventions, maintainable code rules, and moderator-aware review practice.
metadata:
  short-description: Bluelearn contribution workflow and review rules
---

# Bluelearn contributions

Use this skill for work in `bluelearn-org/bluelearn`, including issue planning, frontend or API changes, review fixes, tests, commits, and pull request updates.

This is a mutating skill. It may edit the Bluelearn checkout, create signed commits, push a branch, and update a pull request when the user asks for that work. Loading this skill by itself does not authorize a remote mutation. Preserve unrelated work in the checkout and inspect the current status before editing. Only edit the skill if the user explicitly mentions a new guideline that is not already in the skill which may be useful for working on the project in the future, if you find such stuff, ask the user if it needs to be added to the skill.

## **MODEL GUIDANCE: WRITE MAINTAINABLE BLUELEARN CODE**

Use the moderator feedback as coding guidance. Do not produce generic, opaque, over-abstracted, inconsistent, hard-to-review, or unmaintainable code, and do not leave generated code unchanged when it does not fit the repository. The contributor is responsible for understanding every submitted line.

Before proposing code, read `CONTRIBUTING.md` and representative nearby Bluelearn code. Compare the implementation with those patterns, keep the data flow obvious, choose names that explain intent, and rewrite anything that feels like AI slop. A passing typecheck or generated test is not evidence that code is readable, maintainable, or consistent.

## **READ THE PROJECT GUIDES BEFORE EVERY CONTRIBUTION**

Before planning, implementing, reviewing, or fixing any contribution, read [`CONTRIBUTING.md`](https://github.com/bluelearn-org/bluelearn/blob/main/CONTRIBUTING.md) and [`app/README.md`](https://github.com/bluelearn-org/bluelearn/blob/main/app/README.md). Read them again for each new contribution, even when the task looks similar to an earlier one. Use the checkout copies when available and use these links as the canonical references.

`CONTRIBUTING.md` defines the contribution process, repository layout, branch and commit conventions, frontend and backend checks, tests, focused PR scope, and manual browser verification. `app/README.md` defines the frontend starting point: TanStack Start with React, TypeScript, and shadcn/ui. For app UI, use the existing `app/src/components/ui` shadcn components and the repository's `@/components/ui/...` imports. Do not reach for a different React component library or invent a replacement control without first checking the README, nearby code, and any exact reviewer direction.

## **READ AND MATCH THE WHOLE RELEVANT SOURCE PATH**

Do not stop at UI components. Read the complete relevant source path across `app/`, `api/`, `packages/schemas/`, `supabase/`, and tests before editing. Trace the feature end to end where applicable: route, component, client request, API route, handler, service, shared schema, authorization, migration or database type, and tests. Inspect representative code at every layer and understand how the pieces fit together.

For frontend work, compare nearby `app/src/components/ui` wrappers and feature components for import grouping, `@/` aliases, Tailwind classes, field layout, labels, buttons, loading and error states, spacing, and accessible behavior. For API and database work, compare neighboring Hono handlers, services, schemas, authorization checks, migrations, database types, and error responses. Reuse the repository's existing structure and user-facing tone instead of applying generic React, shadcn, API, or database patterns from memory.

## **FOLLOW THE BLUELEARN READABILITY CHECKLIST**

Apply this checklist to every edit. Large dense blocks are difficult to read, edit, review, and maintain.

- Check formatting while writing code.
- Add spacing between imports, functions, components, and `div` or JSX blocks where it makes sense. Use blank lines to separate logical blocks instead of leaving one dense wall of code.
- Add concise comments only when a non-obvious reason needs explanation. Do not add long comments that restate the implementation.
- Always use curly braces for `if` and `else` statements, even when a one-line branch is technically valid.
- Group imports by type and put a blank line between import groups.
- Use `@/` imports for internal app files and components, such as `import { Badge } from "@/components/ui/badge";`.
- When a component has a separate responsibility or a file is becoming difficult to read, move the component into a separate file or focused folder. Do not be afraid to create a focused folder under `components`.
- Prefer small functions, explicit names, direct data flow, and the repository's existing patterns. Rewrite generated or repetitive blocks until they fit the surrounding code.

Human-written quality comes from coherent decisions and useful detail, not fake quirks. Do not add random spaces, typos, wrong capitalization, missing punctuation, inconsistent formatting, or awkward code to simulate authorship. Keep formatting correct and consistent with the repository.

## **NEVER MENTION AI AUTHORSHIP**

Never say or imply that a file, code change, comment, commit, pull request, documentation page, or user-facing message was written or generated by AI. Do not add AI attribution, model names, generated-by labels, or author metadata. Preserve the repository's real authorship and required DCO information without inventing or changing it.

## **WRITE LIKE A HUMAN, NOT A TEMPLATE**

Use plain, direct, natural wording with specific details from the repository. Avoid polished AI filler, repetitive headings, fake certainty, generic summaries, and corporate language. Human-like writing means a clear, context-appropriate voice, not deliberately broken code or documentation. Do not force typos, incorrect capitalization, or missing punctuation into code, tests, commits, pull requests, or technical documentation.

## **COMMENTS ARE EXCEPTIONS**

Do not add comments by default. If a comment is necessary, use the no-slop comment guidance: keep it short, factual, and limited to a non-obvious reason that the code itself cannot express. Never use a comment to restate the implementation, narrate obvious steps, or explain generated code.

## **NO EM DASHES**

Do not use em dashes anywhere in code comments, documentation, commit messages, pull requests, or user-facing copy. Use a full stop, comma, colon, or parentheses instead.

## Working location and repository facts

- Prefer the checkout under `D:\Github\bluelearn`. Do not create the main contribution checkout under `C:\` when the D: checkout is available.
- Bluelearn is a pnpm monorepo. The frontend is in `app/`, the Hono and Cloudflare Workers API is in `api/`, shared schemas are in `packages/schemas/`, and database work is in `supabase/`.
- Use the repository-pinned pnpm version, currently `pnpm@10.33.1`, when installing, checking, or running hooks.
- Read `CONTRIBUTING.md`, the issue and all current comments, the current PR discussion when fixing a PR, and relevant local code before changing anything.
- Bluelearn expects DCO sign-off. Use `git commit -s` and a clear Conventional Commit style subject when the user asks for a commit.
- Keep a contribution focused on the issue or review request. Do not add unrelated cleanup, reformat the repository, or redesign existing UI.

## Standing code and writing rules

Follow these rules on every Bluelearn contribution:

- Preserve the existing UI, design, theme, colors, typography, layout, and component conventions.
- Reuse existing components and patterns before creating new ones.
- Keep changes narrowly scoped to the issue or review request.
- Do not add unrelated cleanup, broad refactors, or repository-wide reformatting.
- Check formatting while writing code.
- Add spacing between imports, functions, components, and JSX blocks where it improves readability.
- Group imports by type and put blank lines between groups.
- Use `@/` aliases when importing internal app files or components.
- Always use curly braces for `if` and `else` branches.
- Do not add comments by default. If one is necessary, keep it concise and explain only a non-obvious reason.
- Do not add long comments that merely restate the implementation. Apply the no-slop comment guidance when a comment is unavoidable.
- Move a component into a separate file or focused folder when it has a separate responsibility or the current file is becoming hard to read.
- Prefer small functions, explicit names, clear data flow, and simple types.
- Avoid giant components, clever abstractions, duplicated request models, hidden side effects, and speculative generalization.
- Write clear, straightforward, human-like text.
- Avoid AI filler, fake certainty, generic summaries, slop, and em dashes.
- Keep comments, PR descriptions, commit messages, and user-facing copy plain and useful.

Follow the repository's existing formatter, lint rules, and component conventions when they are more specific than this list. Do not use `// @ts-ignore` or `// @ts-expect-error` without a short comment explaining the reason, as required by `CONTRIBUTING.md`.

## Before implementation

1. Read [`CONTRIBUTING.md`](https://github.com/bluelearn-org/bluelearn/blob/main/CONTRIBUTING.md) and [`app/README.md`](https://github.com/bluelearn-org/bluelearn/blob/main/app/README.md) before contributing anything. This applies to planning, implementation, review fixes, documentation changes, and tests.
2. Read the issue and all current comments, linked references, and acceptance criteria.
3. Read the current PR discussion when fixing a PR.
4. Inspect `git status`, the current branch, remotes, and any existing work before editing.
5. Inspect relevant routes, components, API handlers, services, shared schemas, migrations, database types, and tests.
6. Search the repository for existing implementations of the same interaction or data path.
7. Write a short plan naming the files to change and the data path before editing.
8. Check whether the requested feature belongs in an existing data model or needs a new focused model; do not force different concepts into a convenient but incorrect table or service.
9. Use the exact source or component link supplied by a reviewer. Do not substitute a similar custom control or library.
10. Preserve existing behavior outside the requested scope.

The plan must identify the validation boundary, data path through schemas and services, existing UI pattern to reuse, and tests. Investigate an unclear data model before writing frontend state.

## Implementation and delegation

Validate inputs at the API boundary and in shared schemas when data crosses client and server boundaries. Client validation improves feedback but does not replace authorization or integrity checks. Keep loading, empty, validation, error, retry, and success states explicit for new requests and flows. Keep state for a new concept separate from unrelated editor or prerequisite state.

When multi-agent tools are available and the task is substantial, use sub-agents for bounded implementation work, not only research. Do not delegate a tiny task when coordination costs more than the work.

- Use `gpt-5.6-luna` for bounded implementation, test, search, and documentation tasks.
- Use `gpt-5.6-luna` with max reasoning for difficult but clearly bounded implementation tasks.
- Use `gpt-5.6-sol` with medium or high reasoning for architecture-sensitive work, review, integration, and final code audits.
- Do not spend a high-cost model on trivial searches or small edits.
- The primary agent owns final integration and must review every sub-agent change.
- Give every sub-agent explicit file ownership, relevant context, acceptance checks, and the instruction that other agents may be editing the same repository.
- Sub-agents are allowed and expected to write implementation code when implementation is delegated. They must not be limited to research or suggestions.
- Every sub-agent follows the same Bluelearn readability and maintainability rules, uses `apply_patch` for edits, preserves unrelated changes, runs relevant checks, and reports exactly what it changed and tested.

After delegation, inspect the actual diff and tests yourself. Resolve overlaps deliberately; never revert another agent's work merely because it was made by another agent.

## Checks and pull request handoff

For new behavior, add focused tests for the changed boundary and regression tests for nearby behavior. Run the typecheck, lint, formatting, relevant build, and relevant test commands required by the current `CONTRIBUTING.md` (currently `pnpm typecheck && pnpm lint && pnpm build && pnpm test`, plus frontend-specific format/lint and app tests). Do not assume a monorepo-wide command exists when the repository scripts say otherwise.

Also run `git diff --check` and inspect the final diff for unwanted dependencies, generated files, lockfile churn, and unrelated formatting changes. Report verification honestly and distinguish source edits, focused tests, typecheck/lint/format/build results, package output, installation, rendered browser behavior, authenticated behavior, production behavior, and device behavior. Do not claim browser, authenticated, production, or device verification unless it actually ran. For UI work, exercise visible interaction, navigation, persistence, empty state, and retry/error behavior in a browser when possible.

Before pushing, confirm that the remote branch has not moved and that the branch contains the intended diff. After pushing, check the PR template status, CI status, PR head, and reviewer state. Tag a reviewer only after the requested change is pushed and local checks pass. Loading this skill never by itself authorizes remote mutations.

## Pull request review lessons

Read [references/reviewer-lessons.md](references/reviewer-lessons.md) when reviewing or preparing a Bluelearn PR. It records moderator feedback from the user's authored pull requests and should be updated when new maintainer feedback appears.

The recurring lessons are:

- Match the repository's existing profile and activity UI for filters, icons, active-column styling, clear controls, sorting, date controls, all enum choices, and no-results states.
- Include every requested range and boundary in a filter, including custom inputs and invalid-input handling.
- Use the exact shadcn component requested by a reviewer. Remove replaced dependencies and all references, and regenerate the lockfile.
- Check the PR template before tagging a maintainer. A failing template check is a review blocker.
- Tag the reviewer only after the requested change is pushed and the relevant local checks have passed.
