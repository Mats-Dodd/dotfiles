#!/usr/bin/env bash

# Read-only report of the development environment and dotfiles drift.
set -uo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BREWFILE="$DOTFILES_DIR/Brewfile"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# Make configured tools visible without changing the caller's shell.
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

section() {
  printf '\n## %s\n' "$1"
}

section "System"
sw_vers 2>/dev/null || uname -a
printf 'architecture: %s\n' "$(uname -m)"
printf 'shell: %s\n' "$SHELL"

section "Dotfiles"
git -C "$DOTFILES_DIR" status --short --branch
broken_dotfiles=0
while IFS= read -r link; do
  if [[ ! -e "$link" ]]; then
    printf 'broken: %s -> %s\n' "$link" "$(readlink "$link")"
    broken_dotfiles=1
  fi
done < <(find "$HOME" -maxdepth 5 -type l -lname "$DOTFILES_DIR/*" 2>/dev/null)
[[ "$broken_dotfiles" -eq 0 ]] && printf 'managed links: OK\n'

section "Homebrew bundle"
if command -v brew >/dev/null 2>&1; then
  HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --file="$BREWFILE" --no-upgrade --verbose 2>&1 || true

  awk -F'"' '$1 ~ /^brew / {name=$2; sub(/^.*\//, "", name); print name}' "$BREWFILE" | sort -u > "$TMP_DIR/declared"
  brew leaves | sed 's#^.*/##' | sort -u > "$TMP_DIR/installed"
  printf '\nExplicitly installed but not declared:\n'
  comm -23 "$TMP_DIR/installed" "$TMP_DIR/declared" || true

  printf '\nDeclared but not installed as leaves:\n'
  comm -13 "$TMP_DIR/installed" "$TMP_DIR/declared" || true

  printf '\nOutdated formulae:\n'
  HOMEBREW_NO_AUTO_UPDATE=1 brew outdated --formula 2>/dev/null || true
  printf '\nOutdated casks:\n'
  HOMEBREW_NO_AUTO_UPDATE=1 brew outdated --cask 2>/dev/null || true
else
  printf 'brew: missing\n'
fi

section "Mise"
if command -v mise >/dev/null 2>&1; then
  mise config ls 2>/dev/null || true
  printf '\n'
  mise current 2>/dev/null || true
  printf '\nInstalled but inactive:\n'
  mise ls 2>/dev/null | awk '$3 == "" {print}' || true
else
  printf 'mise: missing\n'
fi

section "Global language packages"
printf 'npm:\n'
if command -v npm >/dev/null 2>&1; then
  npm ls -g --depth=0 2>/dev/null || true
else
  printf 'missing\n'
fi
printf '\nCargo:\n'
if command -v cargo >/dev/null 2>&1; then
  cargo install --list 2>/dev/null || true
else
  printf 'missing\n'
fi
printf '\npipx:\n'
if command -v pipx >/dev/null 2>&1; then
  pipx list 2>/dev/null || true
else
  printf 'missing\n'
fi

section "Command ownership"
for command_name in git gh hx node npm pnpm bun rustc cargo go uv pi python3 pip3 docker kubectl; do
  command_path="$(command -v "$command_name" 2>/dev/null || true)"
  printf '%-10s %s\n' "$command_name" "${command_path:-missing}"
done

section "Broken executable links"
found_broken=0
for directory in "$HOME/.local/bin" /usr/local/bin; do
  [[ -d "$directory" ]] || continue
  while IFS= read -r link; do
    printf '%s -> %s\n' "$link" "$(readlink "$link")"
    found_broken=1
  done < <(find "$directory" -maxdepth 1 -type l ! -exec test -e {} \; -print 2>/dev/null)
done
[[ "$found_broken" -eq 0 ]] && printf 'none\n'

section "Unmanaged config directories"
if [[ -d "$HOME/.config" ]]; then
  for directory in "$HOME/.config"/*; do
    [[ -e "$directory" ]] || continue
    if ! find "$directory" -maxdepth 4 -type l -lname "$DOTFILES_DIR/*" -print -quit 2>/dev/null | grep -q .; then
      printf '%s\n' "${directory#"$HOME/"}"
    fi
  done
fi
