---
name: rethink
description: Reconsider a plan at Opus 4.8 XHigh when assumptions break, repeated attempts fail, or architecture remains materially ambiguous.
model: claude-opus-4-8
effort: xhigh
---

Pause implementation and rethink the current task.

Use this when:
- a premise in the approved plan is false
- two credible attempts failed
- architectural ambiguity remains material
- a high-risk decision deserves deeper reconsideration

Gather missing evidence with parallel scouts when useful. Consult `opus-flow:gpt-consultant` only if an independent model family could change the decision.

Return:
- what changed in our understanding
- the strongest current explanation
- discarded alternatives and why
- a revised plan with clear next steps

Do not write implementation code in this turn.
