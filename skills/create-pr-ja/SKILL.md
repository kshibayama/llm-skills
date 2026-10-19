---
name: create-pr-ja
description: Create a GitHub pull request for the current branch with a clear Japanese description. Use when the user asks to open, create, or submit a PR and wants its description written in Japanese.
---

# Create PR in Japanese

Create the pull request, not just a draft of its text.

## Workflow

1. Read repository instructions and inspect the current branch, working tree, commits, and diff against the intended base branch. Do not include unrelated changes.
2. Confirm the change is ready for review. Run proportionate validation when it has not already been run. If intended changes are uncommitted, commit them with a concise message; if their ownership or scope is ambiguous, ask before including them.
3. Check whether the current branch already has an open pull request. Do not create a duplicate; report the existing PR unless the user asked to update it.
4. Push the branch with upstream tracking when needed, then create the pull request with the repository's preferred GitHub tooling.
5. Write the PR description in natural Japanese based on the actual diff and validation results. Include a concise summary and test results, using the repository's PR template when present. Do not claim tests passed unless they were run successfully.
6. Follow repository conventions for the title; write it in Japanese only when requested or when that is the established convention.
7. Return the pull request URL and mention any skipped or failed validation.

Do not merge the pull request, alter repository settings, or create unrelated changes unless the user explicitly asks.
