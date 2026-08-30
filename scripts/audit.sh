#!/usr/bin/env bash

# Read-only report of the development environment and dotfiles drift.
set -uo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BREWFILE="$DOTFILES_DIR/Brewfile"
OS="$(uname -s)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

export PATH="$HOME/.local/bin:$PATH"
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

section() {
  printf '\n## %s\n' "$1"
}

section "System"
if [[ "$OS" == Darwin ]]; then
  sw_vers 2>/dev/null || uname -a
elif [[ -r /etc/os-release ]]; then
  cat /etc/os-release
else
  uname -a
fi
printf 'architecture: %s\n' "$(uname -m)"
printf 'shell: %s\n' "$SHELL"

section "Nix and devenv"
if command -v nix >/dev/null 2>&1; then
  nix --version
else
  printf 'nix: missing\n'
fi
if command -v devenv >/dev/null 2>&1; then
  devenv version
else
  printf 'devenv: missing\n'
fi
if [[ -r "$HOME/.config/nix/nix.conf" ]] && grep -Eq '^experimental-features = .*nix-command.*flakes' "$HOME/.config/nix/nix.conf"; then
  printf 'nix-command and flakes: enabled\n'
else
  printf 'nix-command and flakes: missing\n'
fi

section "Dotfiles"
git -C "$DOTFILES_DIR" status --short --branch
if command -v chezmoi >/dev/null 2>&1; then
  chezmoi --source="$DOTFILES_DIR" status || true
else
  printf 'chezmoi: missing\n'
fi

if [[ "$OS" == Darwin ]]; then
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
elif [[ -r /etc/os-release ]] && grep -q '^ID=ubuntu$' /etc/os-release; then
  section "Ubuntu packages"
  packages=(bat build-essential ca-certificates curl fd-find fzf git git-delta software-properties-common unzip zoxide zsh zsh-autosuggestions)
  for package in "${packages[@]}"; do
    if dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q 'install ok installed'; then
      printf '%-30s installed\n' "$package"
    else
      printf '%-30s missing\n' "$package"
    fi
  done
  printf '\nPending upgrades:\n'
  apt list --upgradable 2>/dev/null || true
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

section "Command ownership"
for command_name in git gh hx nix devenv node npm pnpm bun rustc cargo go uv pi python3 pip3 docker kubectl; do
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
