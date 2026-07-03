---
name: ship-check
description: Verify a substantial change against its acceptance criteria and choose the appropriate Codex review gate.
argument-hint: [base-branch]
model: claude-opus-4-8
effort: high
---

Perform a final quality gate. Treat `$ARGUMENTS` as the base branch when provided; otherwise use `main` unless the repository clearly uses another default branch.

1. Re-read the task outcome and acceptance criteria.
2. Inspect git status and the relevant diff.
3. Run the most relevant tests, type checks, lint, build, or focused runtime verification.
4. Check for unrelated changes and unresolved uncertainty.
5. Decide the review level:
   - no external review for truly tiny low-risk changes
   - normal review for coherent non-trivial changes
   - adversarial review for auth, data loss, migrations, concurrency, rollback, reliability, or major design risk

If review is warranted, give the user the exact command to run and stop:

```text
/codex:review --background --base <base>
```

or:

```text
/codex:adversarial-review --background --base <base> <specific risk to challenge>
```

After review results return, the orchestrator must adjudicate each finding before fixes are delegated.
