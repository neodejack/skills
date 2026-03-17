#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="${1:?Usage: dev-setup.sh <skills_dir> <agents_dir>}"
AGENTS_DIR="${2:?Usage: dev-setup.sh <skills_dir> <agents_dir>}"

if [[ ! -d "$AGENTS_DIR" ]]; then
    echo "Creating $AGENTS_DIR"
    mkdir -p "$AGENTS_DIR"
fi

linked=()
skipped=()
backed_up=()

for skill_path in "$SKILLS_DIR"/*/SKILL.md; do
    [[ -f "$skill_path" ]] || continue
    skill_name="$(basename "$(dirname "$skill_path")")"
    target="$AGENTS_DIR/$skill_name"
    source="$SKILLS_DIR/$skill_name"

    # already symlinked to this repo — skip
    if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$source" ]]; then
        skipped+=("$skill_name")
        continue
    fi

    # existing real directory — back up
    if [[ -d "$target" ]] && [[ ! -L "$target" ]]; then
        echo "  Backing up $target → ${target}.bak"
        mv "$target" "${target}.bak"
        backed_up+=("$skill_name")
    fi

    # existing symlink pointing elsewhere — remove it
    if [[ -L "$target" ]]; then
        echo "  Removing stale symlink $target"
        rm "$target"
    fi

    ln -s "$source" "$target"
    linked+=("$skill_name")
done

echo ""
if (( ${#linked[@]} > 0 )); then
    echo "✓ Linked: ${linked[*]}"
fi
if (( ${#backed_up[@]} > 0 )); then
    echo "✓ Backed up: ${backed_up[*]}"
fi
if (( ${#skipped[@]} > 0 )); then
    echo "· Already linked: ${skipped[*]}"
fi
echo ""
echo "Dev mode active — edits in skills/ are live in Amp/Codex."
echo "Run 'just dev-teardown' when done."
