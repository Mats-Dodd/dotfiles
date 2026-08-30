#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# A checkout migration can leave the old ~/.zprofile symlink unavailable before
# chezmoi has applied the replacement. Bootstrap Homebrew explicitly on macOS
# instead of relying on the caller's shell profile.
if ! command -v brew >/dev/null 2>&1; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

if ! command -v chezmoi >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    brew install chezmoi
  else
    printf 'chezmoi is required. See https://www.chezmoi.io/install/\n' >&2
    exit 1
  fi
fi

exec chezmoi init --source="$DOTFILES_DIR" --apply
