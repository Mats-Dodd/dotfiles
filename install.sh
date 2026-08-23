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
link_file "config/helix/themes/vesper_lighter.toml" "$HOME/.config/helix/themes/vesper_lighter.toml"
link_file "config/herdr/config.toml" "$HOME/.config/herdr/config.toml"
link_file "config/hunk/config.toml" "$HOME/.config/hunk/config.toml"
link_file "config/mise/config.toml" "$HOME/.config/mise/config.toml"
link_file "config/starship/starship.toml" "$HOME/.config/starship.toml"
link_file "config/zed/themes/vesper-lighter.json" "$HOME/.config/zed/themes/vesper-lighter.json"

if [[ "$BACKED_UP" == true ]]; then
  printf 'backups saved to %s\n' "$BACKUP_DIR"
fi
