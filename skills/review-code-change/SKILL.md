---
name: review-code-change
description: Review a code change for concrete correctness, security, compatibility, and maintainability problems. Use for pull request, patch, branch, commit, or working-tree reviews; report actionable findings rather than editing the change.
---

# Review Code Change

Find defects introduced by the change. Prefer a small number of well-supported findings over speculative commentary.

## Workflow

1. Establish the review boundary and read repository instructions. Compare against the intended base when one is available.
2. Understand the changed behavior and inspect enough surrounding code, tests, schemas, and callers to verify it.
3. Check important execution paths, error handling, state transitions, compatibility boundaries, security assumptions, and missing tests.
4. Validate suspected issues with repository evidence or focused read-only checks. Do not report style preferences as defects.
5. Return findings ordered by severity. For each finding, identify the precise location, triggering conditions, impact, and a practical correction.

If no actionable defect is found, say so and mention material validation gaps. Do not modify files or post review comments unless the user explicitly asks.
