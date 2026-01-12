# Dotfiles

My personal macOS dotfiles for development environment configuration.

## What's Included

### Shell Configuration
- **Zsh** - Shell configs with enhancements
  - fzf (fuzzy finder)
  - zoxide (smart cd)
  - zsh-autosuggestions
  - zsh-syntax-highlighting
- **Starship** - Minimal, fast prompt

### Development Tools
- **Git** - Aliases, Delta diff viewer, GitButler integration
- **Tmux** - Terminal multiplexer with vim-style keybindings
  - Prefix: Ctrl-Space
  - Mouse support enabled
  - macOS clipboard integration

### Window Management (macOS)
- **Yabai** - Tiling window manager
  - Binary space partitioning layout
  - App pinning to spaces
  - Window borders
- **Skhd** - Hotkey daemon for window management
  - Vim-style window navigation (Alt+hjkl)
  - App launchers with Hyper key

### Terminal
- **Ghostty** - Modern terminal emulator
  - Font: Berkeley Mono
  - Theme: Afterglow

## Installation

### Prerequisites

Install Homebrew packages:
```bash
# Core tools
brew install fzf zoxide fd bat starship tmux git-delta

# Shell enhancements
brew install zsh-autosuggestions zsh-syntax-highlighting

# Window management
brew install koekeishiya/formulae/yabai koekeishiya/formulae/skhd

# Terminal
brew install ghostty

# Clipboard integration for tmux
brew install reattach-to-user-namespace
```

### Install Dotfiles

1. Clone this repository:
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

2. Run the install script:
```bash
./install.sh
```

This will:
- Backup your existing configs to `~/.dotfiles_backup_<timestamp>`
- Create symlinks from your home directory to this repo
- Preserve your current setup (just in case)

3. Reload your shell:
```bash
source ~/.zshrc
```

4. Start window management services:
```bash
brew services start yabai
brew services start skhd
```

## Structure

```
dotfiles/
├── zsh/                 # Shell configurations
│   ├── .zshrc
│   ├── .zshenv
│   ├── .profile
│   └── .zprofile
├── config/
│   ├── starship/        # Prompt configuration
│   ├── ghostty/         # Terminal emulator
│   ├── yabai/           # Window manager
│   └── skhd/            # Hotkey daemon
├── git/
│   └── .gitconfig       # Git configuration
├── tmux/
│   └── .tmux.conf       # Terminal multiplexer
├── install.sh           # Installation script
└── README.md
```

## Key Features

### Shell Aliases & Functions
- `ds()` - Fast deploy: stages, commits with Claude-generated message, and pushes
- Git aliases: `g`, `gs`, `gaa`, `gc`, `gcm`, `gp`, `gpl`, `gco`, `gb`, `gl`

### Git Aliases
- `cm` - Commit with message
- `aa` - Add all
- `s` - Status
- `pu` - Push to current branch
- `wclaude` - Create worktree and launch Claude

### Tmux Keybindings
- Prefix: `Ctrl-Space`
- Split vertical: `|`
- Split horizontal: `-`
- Navigate panes: `h/j/k/l`
- Resize panes: `Shift+h/j/k/l`
- Copy mode: `prefix + v`

### Window Management (Yabai + Skhd)
- Focus windows: `Alt + h/j/k/l`
- Swap windows: `Shift + Alt + h/j/k/l`
- Switch spaces: `Alt + 1/2/3`
- Toggle float: `Alt + t`
- Toggle fullscreen: `Alt + f`
- Balance windows: `Shift + Alt + 0`

## Customization

All configs are in plain text. Edit any file in this repo, and changes will reflect immediately via symlinks.

## Updating Dotfiles

After making changes to any config:

```bash
cd ~/dotfiles
git add .
git commit -m "Update config"
git push
```

## Uninstall

To remove symlinks and restore backups:

```bash
# Remove symlinks
rm ~/.zshrc ~/.zshenv ~/.profile ~/.zprofile ~/.gitconfig ~/.tmux.conf
rm ~/.config/starship.toml ~/.config/ghostty/config
rm ~/.config/yabai/yabairc ~/.config/skhd/skhdrc

# Restore from backup (adjust timestamp)
cp -r ~/.dotfiles_backup_YYYYMMDD_HHMMSS/* ~/
```

## License

MIT
