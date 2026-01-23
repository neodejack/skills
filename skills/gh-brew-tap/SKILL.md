---
name: gh-brew-tap
description: Create or update personal Homebrew taps and formulae from GitHub Releases that publish pre-built tar.gz executable binaries (language-agnostic). Use when you need to inspect releases with gh CLI, scaffold a tap with brew CLI, and generate multi-arch macOS/Linux formulae that cover all architectures present in release assets.
---

# GitHub Release -> Homebrew Tap

## Quick workflow

1. If user hasn't provided The app repo location (local path or GitHub URL) and The Homebrew tap repo location if it exists (local path or GitHub URL). Start by telling the user two assumptions: (a) the app repo on GitHub has pre-built releases, and (b) after they provide the app repo URL or local path, you will verify this with `gh` and abort if it is not true. Then ask the user for:
   - The app repo location (local path or GitHub URL).
   - The Homebrew tap repo location if it exists (local path or GitHub URL).
2. Resolve the app repo to an OWNER/REPO:
   - If given a GitHub URL, parse OWNER/REPO from it.
   - If given a local path, use `git remote get-url origin` or `gh repo view --json nameWithOwner -q .nameWithOwner` from that directory.
3. Verify the pre-built release assumption: use `gh release list -R OWNER/REPO`, then `gh release view` to confirm at least one release has `.tar.gz` binary assets (not just source tarballs). If not, abort and ask the user to publish pre-built releases first.
4. Find similar formulae in Homebrew for conventions: set `HOMEBREW_NO_INSTALL_FROM_API=1`, tap `homebrew/core`, and browse comparable formulae (see references/gh-brew-commands.md).
5. Identify the target repo and release tag. Prefer an explicit tag; otherwise use the latest release.
6. Use `gh` to list release assets and collect all `.tar.gz` binaries. Keep every OS/arch present.
7. For each asset, download and compute `sha256`, then inspect the archive to confirm the binary name/path.
8. If the tap repo doesn't exist yet, create it and push to GitHub (see references/gh-brew-commands.md). If the user only provided a GitHub URL, clone it locally before editing.
9. Generate a formula template from `assets/formula.rb.tmpl`, fill in the URLs and checksums per OS/arch, and align `install` with the archive contents. Use `brew create` only as a starting point if helpful. Use the Formula Cookbook, similar formulae, and upstream docs as references if needed (language-specific docs only when applicable).
10. Write a meaningful `test do` block for the formula.
11. Run `brew install --build-from-source <formula>` to confirm the formula installs cleanly; fix any errors and retry.
12. Run `brew audit --strict --new --online <formula>` and `brew test <formula>` to ensure the formula passes audits and tests.
13. Use git to commit and push the new formula to the tap repo remote.

## Use these references

- OS/arch mapping and formula patterns: `references/arch-mapping.md`
- Recommended CLI commands and JSON fields: `references/gh-brew-commands.md`

## Output expectations

- Support every architecture present in the release assets (no silent omissions).
- If only one asset exists, use a single `url`/`sha256`. If multiple assets exist, use `on_macos`/`on_linux` blocks and `Hardware::CPU.*` branches.
- Keep the formula language-agnostic; only the tar.gz binaries matter.
- Prefer direct GitHub release asset URLs (not source tarballs).

## Notes

- Do not assume asset naming; match by inspecting asset names and archive contents.
- Use explicit dates/tags in communication when the user refers to “latest.”
- If stuck, ask for help with concrete details about what you tried and what failed.
- If instructions in this skill conflict with repo standards, ask before proceeding.
