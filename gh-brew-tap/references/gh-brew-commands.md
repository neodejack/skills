# gh and brew command snippets

## Inspect releases with gh

List releases (choose the tag explicitly when possible):
```
gh release list -R OWNER/REPO
```

View a specific release with JSON fields:
```
gh release view TAG -R OWNER/REPO --json tagName,assets,publishedAt,url
```

The `assets` array includes `name`, `size`, and `url` fields. Filter to `.tar.gz` files.

## Resolve OWNER/REPO

From a local repo path:
```
git remote get-url origin
gh repo view --json nameWithOwner -q .nameWithOwner
```

From a GitHub URL, parse OWNER/REPO (e.g., https://github.com/OWNER/REPO.git).

## Find similar formulae (reference only)

Homebrew keeps formulae in the `homebrew/core` tap. To search formulas locally:
```
export HOMEBREW_NO_INSTALL_FROM_API=1
brew tap --force homebrew/core
FORMULAE_DIR="$(brew --repository homebrew/core)/Formula"
rg -n "^class " "$FORMULAE_DIR"
rg -n "^\s*desc " "$FORMULAE_DIR"
```

Open a specific formula for patterns:
```
$EDITOR "$FORMULAE_DIR/<formula>.rb"
```

## Download assets and compute sha256

macOS:
```
shasum -a 256 <file>
```

Linux:
```
sha256sum <file>
```

## Create a tap repo template

Local template:
```
brew tap-new OWNER/TAP --no-git
```

With git (creates repo scaffolding):
```
brew tap-new OWNER/TAP
```

If the tap repo doesn't exist yet, prefer this flow:
```
GITHUB_USER=$(gh api user --jq .login)
brew tap-new "$GITHUB_USER/homebrew-tap"
gh repo create "$GITHUB_USER/homebrew-tap" --push --public --source "$(brew --repository "$GITHUB_USER/homebrew-tap")"
```

## Clone an existing tap repo

```
gh repo clone OWNER/TAP
```

## Create a formula scaffold (optional)

You can generate a base formula from a URL and then replace it with the template:
```
brew create --no-fetch --set-name <formula_name> <release_asset_url>
```

If the formula is language-specific, consider `brew create` template options (e.g. `--python`).

## Local validation

Prefer the tap-qualified name once the tap is created, or use the local formula path.
```
FORMULA_NAME="<tap>/<formula>"   # e.g. USERNAME/homebrew-tap/mytool
FORMULA_PATH="./Formula/<formula>.rb"

brew install --build-from-source "$FORMULA_NAME"
# or
brew install --build-from-source "$FORMULA_PATH"

brew audit --strict --new --online "$FORMULA_NAME"
# or
brew audit --strict --new --online "$FORMULA_PATH"

brew test <formula>
```
