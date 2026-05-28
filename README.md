# homebrew-tap

Homebrew tap for [x-mesh](https://github.com/x-mesh) tools.

```bash
brew tap x-mesh/tap
```

## Installable packages

### `gk` — Lightweight Go git helper CLI

`gk` ships as a **Cask** (pre-built binary, signed and notarized). It
was published as a Formula through v0.54, then migrated to a Cask at
v0.55 because the upstream release pipeline (goreleaser ≥ 2.16)
removed the deprecated `brews:` block.

```bash
# Install
brew install --cask x-mesh/tap/gk

# Upgrade
brew upgrade --cask x-mesh/tap/gk

# Uninstall
brew uninstall --cask x-mesh/tap/gk
```

The `--cask` flag is required on both macOS and Linux. Without it
`brew` may match the legacy `Formula/gk.rb` (pinned to v0.54.0,
retained only so existing installs do not error mid-`brew update`),
which is several releases stale.

If you installed before v0.55 and `brew upgrade x-mesh/tap/gk` keeps
reporting v0.54.0, switch to the cask once:

```bash
brew uninstall --formula x-mesh/tap/gk
brew install --cask x-mesh/tap/gk
```

After that, `gk update` and `brew upgrade --cask x-mesh/tap/gk` both
keep you on the latest release. `gk update` itself detects the install
shape (Caskroom vs Cellar) and adds `--cask` automatically.

### `aic` — AI commit message companion

```bash
brew install x-mesh/tap/aic
```

(Formula — no cask migration planned.)

## Notes

- This tap is written by [goreleaser](https://goreleaser.com/) on each
  upstream release. Do not edit `Casks/*.rb` or `Formula/*.rb` by hand
  — changes are overwritten on the next release. Metadata files like
  this README and `tap_migrations.json` (if added) are safe to edit.
- Issues with a specific tool belong in that tool's repository (e.g.
  [x-mesh/gk/issues](https://github.com/x-mesh/gk/issues)), not here.
