---
name: gh-brew-tap
description: Create or update Homebrew taps and formulae from GitHub Releases that publish pre-built tar.gz executable binaries (language-agnostic). Use when you need to inspect releases with gh CLI, scaffold a tap with brew CLI, and generate multi-arch macOS/Linux formulae that cover all architectures present in release assets.
---

# GitHub Release -> Homebrew Tap

## Quick workflow

1. Ask the user for:
   - The local path to the application repo they want to publish.
   - The local path to the Homebrew tap repo (if it exists yet).
1. Identify the target repo and release tag. Prefer an explicit tag; otherwise use the latest release.
2. Use `gh` to list release assets and collect all `.tar.gz` binaries. Keep every OS/arch present.
3. For each asset, download and compute `sha256`, then inspect the archive to confirm the binary name/path.
4. If the tap repo doesn't exist yet, create it and push to GitHub (see references/gh-brew-commands.md).
5. Generate a formula template from `assets/formula.rb.tmpl`, fill in the URLs and checksums per OS/arch, and align `install` with the archive contents.
6. Run `brew audit --new-formula` and a local install/test to confirm the formula works.

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
- If instructions in this skill conflict with repo standards, ask before proceeding.
