---
name: kickoff
description: Start a substantial project or feature with an Opus 4.8 XHigh planning pass. Invoke manually from Plan mode.
argument-hint: <task or project brief>
disable-model-invocation: true
model: claude-opus-4-8
effort: xhigh
---

Plan this substantial task:

$ARGUMENTS

Stay in Plan mode. Do not implement.

1. Inspect the repository and existing constraints.
2. Fan out up to three independent `opus-flow:scout` investigations in parallel when that will reduce uncertainty.
3. Define the outcome, non-goals, acceptance criteria, risks, and material unknowns.
4. Produce an implementation plan with dependency order and genuinely parallel lanes.
5. Route each slice deliberately:
   - main orchestrator for integration and decisions
   - `opus-flow:builder` for ordinary implementation
   - `opus-flow:builder-worktree` for independent parallel writers
   - `opus-flow:surgeon` for narrow subtle work
6. Note whether GPT consultation, image generation, or Codex review is likely to be justified.
7. Stop for approval.

Keep the plan concrete enough to execute but do not turn it into line-by-line ceremony.
