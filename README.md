# Work Dotfiles

Minimal macOS configuration for a fast Zsh and terminal workflow.

## Included

- Native Zsh without a framework or plugin manager
- History-only inline autosuggestions
- Starship with directory and Git branch only
- fzf, fd, bat, and zoxide
- Local-only Atuin history
- Delta as the default Git pager
- Hunk aliases for interactive diff review
- Helix with a Vesper++ Lighter theme
- Herdr
- Ghostty with Berkeley Mono

There is intentionally no tmux, yabai, skhd, or shell syntax highlighting.

## Install

Install Homebrew first, then review and run the package installation:

```sh
brew bundle --file ./Brewfile
```

Link the configuration files separately:

```sh
./install.sh
exec zsh
```

The link script does not install software. Existing targets are moved to a
timestamped directory under `~/.dotfiles-backup/`, preserving their paths. It
is safe to run the script repeatedly.

## Berkeley Mono

Berkeley Mono is licensed software and is not included in this repository.
Install a properly licensed copy manually. Ghostty will use it once available.

## Atuin

Atuin sync is disabled. History remains in the local Atuin database unless sync
is explicitly configured later. Atuin owns `Ctrl-R`; fzf continues to provide
file and directory selection.

## Git

The configuration uses the work identity `Matthew Dodd <mats.dodd12@gmail.com>`.
Delta remains the standard pager. Hunk is available explicitly:

```sh
git hdiff
git hshow HEAD~1
```

## Helix

Helix uses a native port of
[Vesper++ Lighter](https://github.com/itspedr0/vesper), adapted from its
MIT-licensed palette and inheriting Helix's built-in Vesper scope coverage.
Editor behavior otherwise remains at its defaults. Add language servers only
as the work language stack requires them; use `hx --health` to inspect support.

## Structure

```text
.
├── Brewfile
├── config
│   ├── atuin/config.toml
│   ├── ghostty/config
│   ├── helix
│   │   ├── config.toml
│   │   └── themes/vesper_lighter.toml
│   └── starship/starship.toml
├── git/.gitconfig
├── install.sh
└── zsh
    ├── .zprofile
    └── .zshrc
```
