---
name: gh-brew-tap
description: Create or update personal Homebrew taps and formulae from GitHub Releases that publish pre-built tar.gz executable binaries (language-agnostic). Use when you need to inspect releases with gh CLI, scaffold a tap with brew CLI, and generate multi-arch macOS/Linux formulae that cover all architectures present in release assets.
---

# GitHub Release -> Homebrew Tap

## Quick workflow

1. Ask the user for:
   - The local path to the application repo they want to publish.
   - The local path to the Homebrew tap repo (if it exists yet).
2. Find similar formulae in Homebrew for conventions: set `HOMEBREW_NO_INSTALL_FROM_API=1`, tap `homebrew/core`, and browse comparable formulae (see references/gh-brew-commands.md).
3. Identify the target repo and release tag. Prefer an explicit tag; otherwise use the latest release.
4. Use `gh` to list release assets and collect all `.tar.gz` binaries. Keep every OS/arch present.
5. For each asset, download and compute `sha256`, then inspect the archive to confirm the binary name/path.
6. If the tap repo doesn't exist yet, create it and push to GitHub (see references/gh-brew-commands.md).
7. Generate a formula template from `assets/formula.rb.tmpl`, fill in the URLs and checksums per OS/arch, and align `install` with the archive contents. Use `brew create` only as a starting point if helpful. Use the Formula Cookbook, similar formulae, and upstream docs as references if needed (language-specific docs only when applicable).
8. Write a meaningful `test do` block for the formula.
9. Run `brew install --build-from-source <formula>` to confirm the formula installs cleanly; fix any errors and retry.
10. Run `brew audit --strict --new --online <formula>` and `brew test <formula>` to ensure the formula passes audits and tests.

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
