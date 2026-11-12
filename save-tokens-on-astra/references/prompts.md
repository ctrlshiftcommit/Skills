# Reusable prompts for saving Astra usage

Replace bracketed task inputs and use only the template relevant to the current task.

## 1. Focused implementation

```text
Use $save-tokens-on-astra. Fix [behavior] in [page/component/file].
Reproduction: [steps]. Actual: [what happens]. Expected: [what should happen].
Acceptance: [observable result]. Start with these files and follow evidence
if they are not the cause. Run relevant checks and report the result briefly.
```

## 2. Usage target

```text
Target at most [N percentage points] of my weekly Codex allowance for [task].
Check usage before starting and at completion if the tool is available.
Use efficient execution while preserving the acceptance criteria. This is a
best-effort target, not a token cap. Report resets, concurrent activity, or
measurement limits rather than inventing a precise per-task cost.
```

For a hard limit, explicitly add: “Pause at a safe checkpoint before further work when the observed budget is exhausted; report what remains.” Do not use that sentence for tasks the user expects completed regardless of a soft target.

## 3. Bounded workflow experiment

```text
Optimize this repeated workflow: [workflow]. Keep these outputs and quality
checks unchanged: [criteria]. Use at most [experiment budget] and compare
[number] variants, changing one factor at a time. Include worker and review
cost. Record the metric and elapsed time. Stop experiments when the budget is
reached, then recommend the cheapest variant that actually passes.
```

## 4. Economical delegation

```text
Let Astra handle decisions, integration, and final review. Delegate substantial,
well-specified execution to available Luna agents. Choose the lowest adequate
effort; use Max only when justified. Give workers narrow ownership and compact
context. Avoid delegation when its overhead exceeds the work. Review their
actual changes and evidence without redoing the whole task.
```

Worker packet:

```text
Objective: [one bounded outcome].
Own: [exact files or responsibility]. You are not alone in this codebase;
preserve others' changes and adapt to concurrent edits.
Inputs and settled interfaces: [only necessary context].
Acceptance: [observable criteria].
Verification: [focused command or interaction].
Return: changed files, result, checks, unresolved issues. No full logs on success.
```

## 5. Capture a proven workflow

```text
Turn the successful [workflow] into a reusable skill at [repository path].
Keep the entrypoint short. Extract repeated deterministic operations into
scripts only when useful. Link conditional detail from references. Include
inputs, outputs, and the checks that established success. Validate the skill.
```

## 6. Persist a preference

```text
Save this stable preference in [personal AGENTS.md / this project's AGENTS.md]:
[preference]. Keep it concise, merge duplication, preserve unrelated rules,
and show the change. Do not copy today's task history into permanent instructions.
```

## 7. Audit instruction overhead

```text
Review my active AGENTS.md files and relevant skills for duplicate, stale,
conflicting, or overly broad instructions. Identify concrete examples and their
effects. Propose a small diff; apply only changes within my requested scope.
Do not remove useful project requirements just to shorten the files.
```

## 8. Steer a run

```text
Correction for the current task: [new fact or requirement]. Keep [completed
work worth retaining]. Stop the part based on [incorrect assumption] and
continue toward [correct outcome].
```

## 9. Review tools and plugins

```text
Inventory the active tools and plugins relevant to [workflow]. Identify
overlap and candidates I do not need. Distinguish installed/enabled state from
actual prompt overhead. Measure one change at a time where possible. Preserve
working integrations and provide an undo path for any authorized change.
```

## 10. Compact tool output

```text
Keep tool results compact: bounded search matches, short successful check
summaries, and actionable failure details. Save noisy command output in a local
log and preserve its exit code. Inspect additional log context when necessary
to explain a failure. Do not hide errors just to reduce tokens.
```

## 11. Concise final answers

```text
Lead with the outcome. For a small change, give the result, verification, and
any blocker in a few sentences. Skip repeated plans and narration. Use normal,
clear language and expand when the complexity or my question requires it.
```

## 12. Map an unfamiliar codebase

```text
Create a compact map of the entry points relevant to [feature family]. Record
routes, owning modules, key interfaces, and focused verification commands.
Link to actual files. Keep it scoped and note when it was checked; future
tasks should verify that the map still matches the code.
```

## 13. Resume safely

```text
For this long task, keep [task-local path]/PROGRESS.md updated at meaningful
milestones. Include completed work, artifact paths, checks, failures, and next
steps. On resume inspect those artifacts before repeating work. Record enough
state to avoid duplicate drafts or external actions.
```

Progress template:

```markdown
# Task progress
Updated: [timestamp]
Objective and acceptance: [brief]
Completed: [items and file paths]
Verified: [checks and results]
Failures / open decisions: [brief]
External actions already performed: [identifiers only when relevant]
Next action: [specific step]
```

## 14. Focused UI bug fix

```text
Use $save-tokens-on-astra to repair the background-color buttons in [component].
The page is [route]; clicking [buttons] currently does nothing. Each should
apply its named color. Start at [file]. Target [budget] if measurable. Use a
bounded Luna worker if worthwhile, then inspect the diff and verify every
button in the browser. Keep routine logs and the final report short.
```
