---
name: save-tokens-on-astra
description: Reduce GPT-6 Astra usage through focused context, economical delegation, concise tool output, and resumable work. Use for Astra token-saving requests or usage-budgeted workflows.
---

# How to Save Tokens on Astra

Complete the requested work with less avoidable model work. Preserve correctness, required checks, and the user's scope; fewer tokens alone is not success.

## Budget and scope

- Start from supplied files, reproduction steps, expected behavior, and existing progress records. Search narrowly with `rg`; expand when evidence requires it. Do not ask for information already available.
- If a usage budget is supplied, read the available usage-limits tool before work and after a meaningful milestone or completion. Record the window and reset time. Percentages are account-wide, possibly rounded or delayed; concurrent tasks and resets prevent precise attribution. Never convert a weekly percentage into an invented token cap or promise enforcement.
- Honor an explicit hard stopping limit. Treat a stated target as best effort unless the user makes it a cap. Avoid frequent usage polling and unrequested benchmark runs.

## Execution

- For substantial separable work, keep Astra on scoping, decisions, integration, and review. Delegate bounded execution to available GPT-5.6 Luna agents when likely to save total work. Give each a file boundary, inputs, acceptance criteria, and focused verification. Start with the least expensive adequate effort; Max is an escalation, not a default requirement.
- Prefer installed roles such as `token_saver_luna_high` when their runtime definitions actually match. Pass a compact task packet instead of the full conversation. Parallelize only independent useful lanes; never manufacture agents for a tiny edit. If the route is unavailable, report it and use an appropriate available route without claiming Luna was used.
- Inspect a worker's diff and evidence; do not repeat its entire investigation. Resolve shared interfaces before parallel writes. Preserve other contributors' changes.
- Batch independent reads. Request bounded search results and concise tool output. For noisy commands, retain full output in a task-local log and return exit status plus useful diagnostics. On failure inspect enough context to understand it, including earlier errors when the tail is insufficient. Never discard failure output or turn a failing exit code into success.
- Run the checks required by the change. Broaden checks for new failures or unresolved risks, not as a ritual. Distinguish source edits, tests, builds, and visible behavior.
- Honor steering promptly. For long or interruption-prone work, maintain a small task-local checkpoint containing completed work, files, checks, failures, and the next action. Do not create progress files for trivial tasks or write private memory without authorization.

## Output and reuse

- Lead with the result. Give the changed behavior, verification, and any blocker in as little space as clarity permits. Expand when the user asks or complexity warrants it; no caveman grammar or loss of important detail is required.
- Reuse established workflow scripts and skills. Load supporting references only when needed. Save new permanent instructions or configuration only when authorized.
- When asked to tune a setup, inspect current settings, back up intended changes, and apply supported narrow edits. Do not blindly disable plugins, alter security controls, switch primary models, or schedule background jobs. Keep measured savings separate from predictions.

## Templates

Read [the prompt bank](references/prompts.md) only when the user wants reusable task prompts, an agent packet, or a progress template. Keep it out of ordinary task context when the instructions above are sufficient.
