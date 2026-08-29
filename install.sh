#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
BACKED_UP=false

link_file() {
  local source="$DOTFILES_DIR/$1"
  local target="$2"
  local relative_target="${target#"$HOME"/}"
  local backup_target="$BACKUP_DIR/$relative_target"

  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    printf 'unchanged %s\n' "$target"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$(dirname "$backup_target")"
    mv "$target" "$backup_target"
    BACKED_UP=true
    printf 'backed up %s\n' "$target"
  fi

  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
  printf 'linked %s -> %s\n' "$target" "$source"
}

link_file "zsh/.zprofile" "$HOME/.zprofile"
link_file "zsh/.zshrc" "$HOME/.zshrc"
link_file "git/.gitconfig" "$HOME/.gitconfig"
link_file "config/aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
link_file "config/atuin/config.toml" "$HOME/.config/atuin/config.toml"
link_file "config/ghostty/config" "$HOME/.config/ghostty/config"
link_file "config/helix/config.toml" "$HOME/.config/helix/config.toml"
link_file "config/helix/themes/vigil.toml" "$HOME/.config/helix/themes/vigil.toml"
link_file "config/herdr/config.toml" "$HOME/.config/herdr/config.toml"
link_file "config/hunk/config.toml" "$HOME/.config/hunk/config.toml"
link_file "config/mise/config.toml" "$HOME/.config/mise/config.toml"
link_file "config/pi/extensions" "$HOME/.pi/agent/extensions"
link_file "config/pi/pi-codex-compaction.json" "$HOME/.pi/agent/pi-codex-compaction.json"
link_file "config/pi/settings.json" "$HOME/.pi/agent/settings.json"
link_file "config/pi/themes" "$HOME/.pi/agent/themes"
link_file "config/starship/starship.toml" "$HOME/.config/starship.toml"
link_file "config/zed/settings.json" "$HOME/.config/zed/settings.json"
link_file "config/zed/themes/laude.json" "$HOME/.config/zed/themes/laude.json"
link_file "config/zed/themes/vigil.json" "$HOME/.config/zed/themes/vigil.json"

# Cursor uses the VS Code extension and settings formats. Keep the same local
# extensions ready for VS Code as well, even when it is installed later.
link_file "config/vscode/settings.json" "$HOME/Library/Application Support/Cursor/User/settings.json"
link_file "config/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
link_file "config/vscode/extensions/laude-theme" "$HOME/.cursor/extensions/matthewdodd.laude-theme-0.1.0"
link_file "config/vscode/extensions/vigil-theme" "$HOME/.cursor/extensions/matthewdodd.vigil-theme-0.1.1"
link_file "config/vscode/extensions/laude-theme" "$HOME/.vscode/extensions/matthewdodd.laude-theme-0.1.0"
link_file "config/vscode/extensions/vigil-theme" "$HOME/.vscode/extensions/matthewdodd.vigil-theme-0.1.1"

if [[ "$BACKED_UP" == true ]]; then
  printf 'backups saved to %s\n' "$BACKUP_DIR"
fi
