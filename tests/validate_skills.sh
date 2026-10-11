#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
validator="${SKILL_VALIDATOR:-$HOME/.codex/skills/.system/skill-creator/scripts/quick_validate.py}"

validate_without_pyyaml() {
  ruby -ryaml -e '
    path = ARGV.fetch(0)
    text = File.read(File.join(path, "SKILL.md"))
    match = text.match(/\A---\n(.*?)\n---/m) or abort "Invalid frontmatter format: #{path}"
    data = YAML.safe_load(match[1], permitted_classes: [], aliases: false)
    abort "Frontmatter must be a mapping: #{path}" unless data.is_a?(Hash)
    allowed = %w[name description license allowed-tools metadata]
    extra = data.keys - allowed
    abort "Unexpected frontmatter keys #{extra.join(", ")}: #{path}" unless extra.empty?
    name = data["name"] or abort "Missing name: #{path}"
    description = data["description"] or abort "Missing description: #{path}"
    abort "Invalid name: #{name}" unless name.match?(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/) && name.length <= 64
    abort "Invalid description: #{path}" unless description.is_a?(String) && !description.empty? && description.length <= 1024 && !description.include?("<") && !description.include?(">")
    abort "Unfinished TODO: #{path}" if text.match?(/^\s*\[TODO:/)
    ui = File.join(path, "agents", "openai.yaml")
    if File.file?(ui)
      ui_data = YAML.safe_load(File.read(ui), permitted_classes: [], aliases: false)
      short = ui_data.dig("interface", "short_description")
      abort "Invalid short_description length: #{ui}" unless short.is_a?(String) && (25..64).cover?(short.length)
    end
    puts "Skill is valid! (dependency-free validator)"
  ' "$1"
}

validate() {
  local path="$1"
  if [[ -f "$validator" ]] && python3 -c 'import yaml' >/dev/null 2>&1; then
    python3 "$validator" "$path"
  else
    validate_without_pyyaml "$path"
  fi
}

while IFS= read -r path; do
  [[ -z "$path" || "$path" == \#* ]] && continue
  validate "$repo_dir/$path"
done < "$repo_dir/skills.txt"
