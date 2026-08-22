# Work Dotfiles

Minimal macOS configuration for a fast Zsh and terminal workflow.

## Included

- Native Zsh without a framework or plugin manager
- History-only inline autosuggestions
- Starship with directory and Git branch only
- fzf, fd, bat, and zoxide
- Local-only Atuin history
- Mise-managed Node with `.nvmrc` support
- Delta as the default Git pager
- Hunk aliases, Vesper++ Lighter colors, and review preferences
- Helix with a Vesper++ Lighter theme
- Herdr with Vesper++ Lighter colors
- Ghostty with Berkeley Mono and Vesper++ Lighter colors
- AeroSpace with Vim-style navigation and JankyBorders

There is intentionally no tmux or shell syntax highlighting.

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

User and work identity belong in the untracked `~/.gitconfig.local` file.
Machine- and employer-specific shell settings belong in `~/.zshrc.local`.
Delta remains the standard pager. Hunk is available explicitly:

```sh
git hdiff
git hshow HEAD~1
```

## Mise

Mise manages the default Node version and automatically honors project
`.nvmrc` files. Node versions and globally installed npm packages remain
machine-local.

## AeroSpace

AeroSpace provides nine persistent workspaces, Vim-style focus and movement,
and small gaps. JankyBorders highlights the active window. AeroSpace starts at
login and launches the border process itself.

## Helix

Helix uses a native port of
[Vesper++ Lighter](https://github.com/itspedr0/vesper), adapted from its
MIT-licensed palette and inheriting Helix's built-in Vesper scope coverage.
Editor behavior otherwise remains at its defaults. Add language servers only
as the work language stack requires them; use `hx --health` to inspect support.

## Herdr

Herdr's interface uses the same Vesper++ Lighter palette as Helix. The theme
changes Herdr's panels, menus, borders, and semantic state colors without
changing session, terminal, or remote-access behavior.

## Hunk

Hunk uses the same Vesper++ Lighter palette for its interface, syntax, and diff
states. Its portable review preferences live alongside the theme; runtime state
remains local to the machine.

## Structure

```text
.
├── Brewfile
├── config
│   ├── aerospace/aerospace.toml
│   ├── atuin/config.toml
│   ├── ghostty/config
│   ├── helix
│   │   ├── config.toml
│   │   └── themes/vesper_lighter.toml
│   ├── herdr/config.toml
│   ├── hunk/config.toml
│   ├── mise/config.toml
│   └── starship/starship.toml
├── git/.gitconfig
├── install.sh
└── zsh
    ├── .zprofile
    └── .zshrc
```
