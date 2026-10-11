---
name: diagnose-ci-failure
description: Diagnose failing CI jobs, tests, builds, or checks and report the root cause with evidence and a minimal repair strategy. Use when a user asks why CI failed or wants a CI failure investigated; do not modify code unless the user also asks for a fix.
---

# Diagnose CI Failure

Identify the earliest actionable cause, not merely the last error printed by the job.

## Workflow

1. Read repository instructions and the relevant CI configuration.
2. Inspect the failing job, command, logs, and recent related changes. Separate the primary failure from retries and downstream noise.
3. Reproduce the smallest relevant command locally when it is safe and practical. Do not claim reproduction when only static evidence is available.
4. Test competing explanations against the available evidence. Distinguish repository defects from infrastructure, credentials, flaky tests, and environment drift.
5. Report the failed check, root cause, supporting evidence, affected scope, and smallest credible repair. State uncertainty and the next discriminating check when evidence is incomplete.

Keep diagnosis read-only unless the user requests implementation. Do not retry remote jobs, change CI settings, or mutate external systems without authorization.
