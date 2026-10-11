#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
test_root="$(mktemp -d)"
trap 'rm -rf -- "$test_root"' EXIT
target="$test_root/skills"

fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }

"$repo_dir/install.sh" --target "$target" install
for name in diagnose-ci-failure review-code-change add-regression-test; do
  [[ -L "$target/$name" ]] || fail "$name was not linked"
  [[ -f "$target/$name/SKILL.md" ]] || fail "$name link is invalid"
done

"$repo_dir/install.sh" --target "$target" install >/dev/null
"$repo_dir/install.sh" --target "$target" doctor >/dev/null

mkdir -p "$test_root/conflict"
touch "$test_root/conflict/review-code-change"
if "$repo_dir/install.sh" --target "$test_root/conflict" install review-code-change >/dev/null 2>&1; then
  fail "install replaced or accepted a conflicting path"
fi

"$repo_dir/install.sh" --target "$target" uninstall
for name in diagnose-ci-failure review-code-change add-regression-test; do
  [[ ! -e "$target/$name" && ! -L "$target/$name" ]] || fail "$name was not removed"
done

printf 'PASS: installer lifecycle and conflict protection\n'
