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

## Create a formula scaffold (optional)

You can generate a base formula from a URL and then replace it with the template:

```
brew create --no-fetch --set-name <formula_name> <release_asset_url>
```

## Local validation

```
brew audit --new-formula ./Formula/<formula_name>.rb
brew install --formula ./Formula/<formula_name>.rb
brew test <formula_name>
```
