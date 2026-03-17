#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="${1:?Usage: dev-teardown.sh <skills_dir> <agents_dir>}"
AGENTS_DIR="${2:?Usage: dev-teardown.sh <skills_dir> <agents_dir>}"

removed=()
restored=()
no_backup=()

for skill_path in "$SKILLS_DIR"/*/SKILL.md; do
    [[ -f "$skill_path" ]] || continue
    skill_name="$(basename "$(dirname "$skill_path")")"
    target="$AGENTS_DIR/$skill_name"
    source="$SKILLS_DIR/$skill_name"

    # only remove if it's a symlink pointing into this repo
    if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$source" ]]; then
        rm "$target"
        removed+=("$skill_name")

        # restore backup if one exists
        if [[ -d "${target}.bak" ]]; then
            mv "${target}.bak" "$target"
            restored+=("$skill_name")
        else
            no_backup+=("$skill_name")
        fi
    fi
done

echo ""
if (( ${#removed[@]} > 0 )); then
    echo "✓ Removed symlinks: ${removed[*]}"
else
    echo "· No dev symlinks found — nothing to do."
fi
if (( ${#restored[@]} > 0 )); then
    echo "✓ Restored backups: ${restored[*]}"
fi
if (( ${#no_backup[@]} > 0 )); then
    echo "⚠ No backup for: ${no_backup[*]}"
    echo "  Run 'npx skills add neodejack/skills' to reinstall."
fi
echo ""
echo "Dev mode deactivated."
