# Work Dotfiles

Portable macOS and Ubuntu 24.04 LTS configuration managed with
[chezmoi](https://www.chezmoi.io/).

## Included

- Native Zsh without a framework or plugin manager
- Starship, fzf, fd, bat, zoxide, and local-only Atuin history
- Mise-managed language runtimes and Pi, plus Linux installs of Helix,
  Starship, Atuin, and Hunk
- Delta as the default Git pager
- Vigil themes for Ghostty, Helix, Herdr, Hunk, Pi, Zed, VS Code, and Cursor
- AeroSpace and JankyBorders on macOS only
- Linux-native VS Code and Cursor settings paths

There is intentionally no tmux or shell syntax highlighting.

## Ubuntu 24.04 LTS

Install the bootstrap dependencies and apply the repository:

```sh
sudo apt-get update
sudo apt-get install -y git curl
mkdir -p ~/.local/bin
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
~/.local/bin/chezmoi init --apply Mats-Dodd
```

Chezmoi installs the remaining APT packages, installs Mise into
`~/.local/bin`, applies the configuration, and installs the tools declared in
`~/.config/mise/config.toml`.

Make Zsh the login shell after the first apply:

```sh
chsh -s "$(command -v zsh)"
exec zsh
```

The Ubuntu package bootstrap is designed and tested for Ubuntu 24.04 Noble.
Ubuntu installs `fd` and, where necessary, `bat` compatibility links under
`~/.local/bin`.

Ghostty, Zed, VS Code, Cursor, and the licensed Berkeley Mono font remain
optional desktop installations. Chezmoi deploys their configuration whether or
not the applications are installed. AeroSpace and JankyBorders are not deployed
on Linux.

## macOS

Install Homebrew and Chezmoi first, then apply:

```sh
brew install chezmoi
chezmoi init --apply Mats-Dodd
```

The Chezmoi package script applies the tracked `Brewfile`; Mise installs the
portable tools and language runtimes.

## Existing clone

To use this checkout directly as the Chezmoi source directory:

```sh
./install.sh
```

Review changes at any time:

```sh
chezmoi diff
chezmoi status
chezmoi apply -v
```

After editing a target file, import it into the repository with `chezmoi add`,
or edit the source directly with `chezmoi edit`.

## Local configuration

User and work identity belong in the untracked `~/.gitconfig.local` file.
Machine- and employer-specific shell settings belong in `~/.zshrc.local`.
Credentials, Atuin history, Pi sessions, and application runtime state remain
machine-local.

The shared Git configuration uses `osxkeychain` on macOS. It deliberately does
not select a credential helper on Linux; use SSH, Git Credential Manager, or a
machine-local helper in `~/.gitconfig.local`.

## Package ownership

- Ubuntu system packages: APT, from the Chezmoi package script
- macOS system and desktop packages: Homebrew, from `Brewfile`
- Language tools and Linux-only portable CLI tools: Mise, from
  `home/dot_config/mise/config.toml`
- Desktop applications and Berkeley Mono: installed separately where noted

Python projects and Python-based tools should use uv rather than global pip,
pipx, or pipenv installations.

## Berkeley Mono

Berkeley Mono is licensed software and is not included. The configuration
expects the variable TX-02 v2.004 build with `zero.dotted` and
`seven.european`. Ghostty maps bold to weight 600.

## Atuin

Atuin sync is disabled. History remains in the local Atuin database unless sync
is explicitly configured. Atuin owns `Ctrl-R`; fzf provides file and directory
selection.

## Themes

The canonical theme sources live in sibling `laude` and `vigil` repositories.
Refresh the tracked copies after changing either source:

```sh
./scripts/sync-themes.sh
```

VS Code-compatible extensions are deployed once under
`~/.local/share/dotfiles/vscode-extensions` and linked into both VS Code and
Cursor extension directories.

## Audit

Run the read-only cross-platform audit:

```sh
./scripts/audit.sh
```

It reports Chezmoi drift, Homebrew or Ubuntu package state, Mise versions,
global language packages, command ownership, and broken executable links.

## Structure

```text
.
├── .chezmoiroot                 # selects home/ as the source-state root
├── Brewfile                     # macOS packages
├── home
│   ├── .chezmoi.toml.tmpl       # preserves the selected source directory
│   ├── .chezmoiignore           # OS-specific target exclusions
│   ├── .chezmoitemplates
│   ├── dot_config               # XDG application configuration
│   ├── dot_gitconfig.tmpl
│   ├── dot_local/share/dotfiles # shared editor extension payloads
│   ├── dot_pi/agent             # Pi configuration
│   ├── dot_zprofile.tmpl
│   ├── dot_zshrc.tmpl
│   ├── run_onchange_before_install-packages.sh.tmpl
│   └── run_onchange_after_install-tools.sh.tmpl
├── install.sh                   # local-checkout Chezmoi wrapper
└── scripts
    ├── audit.sh
    └── sync-themes.sh
```
