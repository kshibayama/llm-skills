---
name: add-regression-test
description: Add a focused automated test that reproduces a reported or fixed defect and protects the intended behavior. Use when a user asks for regression coverage for a bug or bug fix; do not redesign unrelated production code.
---

# Add Regression Test

Create the smallest stable test that would fail for the defect and pass for the intended behavior.

## Workflow

1. Read repository instructions and locate the closest existing tests for the affected behavior.
2. Confirm the defect's observable contract, trigger, and expected result from the report, fix, or implementation.
3. Add the test at the lowest useful level. Reuse existing fixtures and conventions; avoid broad snapshots when a direct assertion is clearer.
4. Demonstrate that the test detects the regression when practical, then run it against the intended implementation. Avoid destructive reversal of user changes merely to prove failure.
5. Run the narrow test first and the relevant broader suite when cost permits. Report what ran and any validation limitation.

Keep production changes out of scope unless they are necessary to expose an existing test seam or the user also asks for the fix. Avoid timing dependence, live network calls, and assertions on incidental implementation details.
