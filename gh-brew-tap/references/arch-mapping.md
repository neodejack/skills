# OS/arch mapping and formula patterns

## Asset name to OS/arch mapping heuristics

Use filename tokens to infer OS/arch. Confirm with `file` or `tar -tzf` if unclear.

OS tokens:
- macOS: `macos`, `darwin`, `osx`
- Linux: `linux`

Arch tokens:
- arm64: `arm64`, `aarch64`
- x86_64: `x86_64`, `amd64`
- 386: `386`, `i386` (rare; Homebrew may not accept 32-bit)

If a token is ambiguous, inspect the binary:
- `tar -tzf <asset>.tar.gz | head`
- `tar -xzf <asset>.tar.gz -C /tmp/<name>`
- `file /tmp/<name>/<binary>`

## Formula pattern for multi-arch assets

Use `on_macos` and `on_linux` with CPU branches. Example pattern:

```
on_macos do
  if Hardware::CPU.arm?
    url "<macos-arm64-url>"
    sha256 "<sha256>"
  else
    url "<macos-x86_64-url>"
    sha256 "<sha256>"
  end
end

on_linux do
  if Hardware::CPU.arm?
    url "<linux-arm64-url>"
    sha256 "<sha256>"
  else
    url "<linux-x86_64-url>"
    sha256 "<sha256>"
  end
end
```

If only one OS/arch exists, prefer a single `url`/`sha256` without `on_*` blocks.

## Install block guidance

- If the tarball contains a single binary at the top level: `bin.install "<binary>"`
- If the binary is nested in a folder: `bin.install "<folder>/<binary>"`
- If multiple binaries exist, install only the intended primary binary unless the user asks otherwise.
