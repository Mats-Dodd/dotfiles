#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODE_DIR="$(dirname "$DOTFILES_DIR")"

sync_theme() {
  local slug="$1"
  local zed_file="$2"
  local vscode_file="$3"
  local pi_file="${4:-}"
  local source_dir="$CODE_DIR/$slug"
  local extension_dir="$DOTFILES_DIR/config/vscode/extensions/$slug-theme"

  if [[ ! -d "$source_dir" ]]; then
    printf 'missing theme repository: %s\n' "$source_dir" >&2
    return 1
  fi

  npm test --prefix "$source_dir"

  mkdir -p "$DOTFILES_DIR/config/zed/themes" "$extension_dir/vscode"
  cp "$source_dir/themes/$zed_file" "$DOTFILES_DIR/config/zed/themes/$zed_file"
  cp "$source_dir/vscode/$vscode_file" "$extension_dir/vscode/$vscode_file"
  cp "$source_dir/package.json" "$extension_dir/package.json"
  cp "$source_dir/LICENSE" "$extension_dir/LICENSE"
  cp "$source_dir/README.md" "$extension_dir/README.md"
  cp "$source_dir/THIRD_PARTY_NOTICES.md" "$extension_dir/THIRD_PARTY_NOTICES.md"

  if [[ -n "$pi_file" ]]; then
    mkdir -p "$DOTFILES_DIR/config/pi/themes"
    cp "$source_dir/pi/$pi_file" "$DOTFILES_DIR/config/pi/themes/$pi_file"
  fi

  printf 'synced %s\n' "$slug"
}

sync_theme "laude" "laude.json" "laude-color-theme.json"
sync_theme "vigil" "vigil.json" "vigil-color-theme.json" "vigil.json"
