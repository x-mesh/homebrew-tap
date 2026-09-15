# homebrew-tap

Homebrew tap for [x-mesh](https://github.com/x-mesh) tools.

```bash
brew tap x-mesh/tap
```

## Packages

| Package | Type | Description | Install command |
| --- | --- | --- | --- |
| `gk` | Cask | Git helper CLI | `brew install --cask x-mesh/tap/gk` |
| `httprove` | Cask | HTTP(S) service diagnostics for SREs | `brew install --cask x-mesh/tap/httprove` |
| `space-mesh` | Cask (macOS) | Disk space analyzer | `brew install --cask x-mesh/tap/space-mesh` |
| `term-mesh` | Cask (macOS) | Terminal emulator with agent orchestration | `brew install --cask x-mesh/tap/term-mesh` |
| `aic` | Formula | Shell command error analyzer with LLM | `brew install x-mesh/tap/aic` |
| `x-backup` | Formula | MongoDB/PostgreSQL backup and restore CLI | `brew install x-mesh/tap/x-backup` |

On macOS, each cask removes the `com.apple.quarantine` attribute after installation.

### `gk`

Use the `--cask` flag on macOS and Linux.

```bash
brew install --cask x-mesh/tap/gk
brew upgrade --cask x-mesh/tap/gk
brew uninstall --cask x-mesh/tap/gk
```

The tap published `gk` as a Formula through v0.54. Version v0.55 and later ship only as a Cask, because goreleaser 2.16 removed the `brews:` block.

If `brew upgrade x-mesh/tap/gk` reports v0.54.0, replace the Formula with the Cask once:

```bash
brew uninstall --formula x-mesh/tap/gk
brew install --cask x-mesh/tap/gk
```

After the switch, `gk update` and `brew upgrade --cask x-mesh/tap/gk` both install the latest release.

### `x-backup`

The `x-backup` repository is private. The download requires a GitHub token:

```bash
export HOMEBREW_GITHUB_API_TOKEN=$(gh auth token)
brew install x-mesh/tap/x-backup
```

`lib/private_strategy.rb` contains the download strategy for private release assets.

## Maintenance

The release process of each tool writes its package file. The next release overwrites manual changes in `Casks/*.rb` and `Formula/*.rb`.

| File | Source |
| --- | --- |
| `Casks/gk.rb` | `homebrew_casks` in `.goreleaser.yaml` of `x-mesh/gk` |
| `Casks/httprove.rb` | `.github/workflows/release.yml` of `x-mesh/httprove` |
| `Casks/space-mesh.rb` | `scripts/update-homebrew-cask.sh` of `x-mesh/space-mesh` |
| `Casks/term-mesh.rb` | `scripts/update-homebrew-cask.sh` of `x-mesh/term-mesh` |
| `Formula/aic.rb` | Release workflow of `x-mesh/aic` |
| `Formula/x-backup.rb` | `scripts/release.sh` of `x-mesh/x-backup` |

To change a package file, change its source first. Then apply the same change here, or release the tool.

For cask install actions, use `preflight_steps` and `postflight_steps`. Homebrew deprecated the Ruby `preflight` and `postflight` blocks.

Report an issue for a tool in the repository of that tool, for example [x-mesh/gk/issues](https://github.com/x-mesh/gk/issues).
