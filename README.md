# Work Dotfiles

Minimal macOS configuration for a fast Zsh and terminal workflow.

## Included

- Native Zsh without a framework or plugin manager
- History-only inline autosuggestions
- Starship with directory and Git branch only
- fzf, fd, bat, and zoxide
- Local-only Atuin history
- Mise-managed Node, pnpm, Bun, and Rust, with `.nvmrc` support
- Delta as the default Git pager
- Hunk aliases, Vigil colors, and review preferences
- Helix with a Vigil theme
- Herdr with Vigil colors
- Ghostty with Berkeley Mono and Vigil colors
- Zed and VS Code-compatible editors with system-switching Laude and Vigil themes
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

The current install is the **variable** build: TX-02 v2.004, one OTF
(`BerkeleyMonoVariable.otf`), compiled with `zero.dotted` + `seven.european`
(matching the web build on chezdodds.dev). Recompile at usgraphics.com with
those options for reproducibility. Ghostty maps bold to wght 600
(`font-variation-bold`) — the "never 700" rule from the blog's type system.

Two measured facts worth knowing:

- Box-drawing glyphs are exactly **1.2 em** tall. Anything rendering ASCII
  diagrams outside a terminal (e.g. Zed) needs line-height 1.2 for verticals
  to join: `"buffer_line_height": { "custom": 1.2 }`.
- The variable axes are wght 100–900, wdth 60–100, slnt −16–0, with named
  instances including Retina (375) and Book (450).

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

Mise manages the default Node, pnpm, Bun, and Rust versions and automatically
honors project `.nvmrc` files. Tool installations and globally installed
packages remain machine-local.

## AeroSpace

AeroSpace provides nine persistent workspaces, Vim-style focus and movement,
and small gaps. JankyBorders highlights the active window. AeroSpace starts at
login and launches the border process itself.

## Helix

Helix uses a native port of
Vigil, the author's fork of [Vesper](https://github.com/itspedr0/vesper), adapted from its
MIT-licensed palette and inheriting Helix's built-in Vesper scope coverage.
Editor behavior otherwise remains at its defaults. Add language servers only
as the work language stack requires them; use `hx --health` to inspect support.

## Herdr

Herdr's interface uses the same Vigil palette as Helix. The theme
changes Herdr's panels, menus, borders, and semantic state colors without
changing session, terminal, or remote-access behavior.

## Hunk

Hunk uses the same Vigil palette for its interface, syntax, and diff
states. Its portable review preferences live alongside the theme; runtime state
remains local to the machine.

## Zed

Zed uses Laude in light mode and Vigil in dark mode, following the system
appearance. Both native themes cover the editor, interface, syntax,
diagnostics, Git states, and integrated terminal.

## VS Code and Cursor

The link installer exposes self-contained Laude and Vigil extensions to both
VS Code and Cursor. Their shared settings follow the system appearance, using
Laude in light mode and Vigil in dark mode.

The canonical theme sources live in the sibling `laude` and `vigil`
repositories. After changing either theme, refresh the copies tracked here:

```sh
./scripts/sync-themes.sh
```

Fonts remain editor settings rather than theme properties. To use Berkeley
Mono in Zed, add it to `~/.config/zed/settings.json`:

```json
{
  "theme": "Vigil",
  "buffer_font_family": "Berkeley Mono",
  "terminal": {
    "font_family": "Berkeley Mono"
  }
}
```

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
│   │   └── themes/vigil.toml
│   ├── herdr/config.toml
│   ├── hunk/config.toml
│   ├── mise/config.toml
│   ├── starship/starship.toml
│   ├── vscode
│   │   ├── extensions/{laude-theme,vigil-theme}
│   │   └── settings.json
│   └── zed
│       ├── settings.json
│       └── themes/{laude.json,vigil.json}
├── git/.gitconfig
├── install.sh
├── scripts/sync-themes.sh
└── zsh
    ├── .zprofile
    └── .zshrc
```
