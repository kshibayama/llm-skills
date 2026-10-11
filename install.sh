#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
manifest="$repo_dir/skills.txt"
target_dir="${CODEX_SKILLS_DIR:-${CODEX_HOME:-$HOME/.codex}/skills}"

usage() {
  cat <<'EOF'
Usage: ./install.sh [--target DIR] <install|uninstall|doctor|list> [SKILL ...]

Commands:
  install     Link selected skills, or every allowlisted skill when omitted.
  uninstall   Remove links installed from this repository.
  doctor      Check source skills and installed links.
  list        Show allowlisted skill names and installation state.

CODEX_SKILLS_DIR may also override the target directory.
EOF
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

skill_paths() {
  [[ -f "$manifest" ]] || die "missing manifest: $manifest"
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -z "$line" ]] || printf '%s\n' "$line"
  done < "$manifest"
}

all_names() {
  local path
  while IFS= read -r path; do basename -- "$path"; done < <(skill_paths)
}

is_allowed() {
  local wanted="$1" name
  while IFS= read -r name; do
    [[ "$name" == "$wanted" ]] && return 0
  done < <(all_names)
  return 1
}

selected_names() {
  if (($#)); then
    local name
    for name in "$@"; do
      is_allowed "$name" || die "unknown skill: $name"
      printf '%s\n' "$name"
    done
  else
    all_names
  fi
}

source_for() {
  local wanted="$1" path
  while IFS= read -r path; do
    [[ "$(basename -- "$path")" == "$wanted" ]] && {
      printf '%s/%s\n' "$repo_dir" "$path"
      return 0
    }
  done < <(skill_paths)
  return 1
}

canonical_dir() {
  (cd -- "$1" 2>/dev/null && pwd -P)
}

is_ours() {
  local link="$1" resolved expected
  [[ -L "$link" ]] || return 1
  resolved="$(canonical_dir "$link")" || return 1
  expected="$(canonical_dir "$(source_for "$(basename -- "$link")")")" || return 1
  [[ "$resolved" == "$expected" ]]
}

command_install() {
  mkdir -p -- "$target_dir"
  local name source target
  while IFS= read -r name; do
    source="$(source_for "$name")"
    [[ -f "$source/SKILL.md" ]] || die "$name has no SKILL.md"
    target="$target_dir/$name"
    if [[ -e "$target" || -L "$target" ]]; then
      is_ours "$target" && { printf 'ok: %s already installed\n' "$name"; continue; }
      die "refusing to replace existing path: $target"
    fi
    ln -s -- "$source" "$target"
    printf 'installed: %s -> %s\n' "$target" "$source"
  done < <(selected_names "$@")
}

command_uninstall() {
  local name target
  while IFS= read -r name; do
    target="$target_dir/$name"
    if [[ ! -e "$target" && ! -L "$target" ]]; then
      printf 'ok: %s is not installed\n' "$name"
    elif is_ours "$target"; then
      rm -- "$target"
      printf 'uninstalled: %s\n' "$target"
    else
      die "refusing to remove path not installed from this repository: $target"
    fi
  done < <(selected_names "$@")
}

command_doctor() {
  local failed=0 name source target
  while IFS= read -r name; do
    source="$(source_for "$name")"
    target="$target_dir/$name"
    if [[ ! -f "$source/SKILL.md" ]]; then
      printf 'invalid: %s has no SKILL.md\n' "$name" >&2
      failed=1
    elif [[ ! -e "$target" && ! -L "$target" ]]; then
      printf 'missing: %s\n' "$name"
      failed=1
    elif is_ours "$target"; then
      printf 'ok: %s\n' "$name"
    else
      printf 'conflict: %s\n' "$target" >&2
      failed=1
    fi
  done < <(selected_names "$@")
  return "$failed"
}

command_list() {
  local name state target
  while IFS= read -r name; do
    target="$target_dir/$name"
    if is_ours "$target"; then state=installed
    elif [[ -e "$target" || -L "$target" ]]; then state=conflict
    else state=available
    fi
    printf '%-28s %s\n' "$name" "$state"
  done < <(all_names)
}

if [[ "${1:-}" == "--target" ]]; then
  (($# >= 3)) || { usage >&2; exit 2; }
  target_dir="$2"
  shift 2
fi

command="${1:-}"
[[ -n "$command" ]] || { usage >&2; exit 2; }
shift

case "$command" in
  install) command_install "$@" ;;
  uninstall) command_uninstall "$@" ;;
  doctor) command_doctor "$@" ;;
  list) command_list "$@" ;;
  -h|--help|help) usage ;;
  *) usage >&2; die "unknown command: $command" ;;
esac
