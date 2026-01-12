# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Created by `pipx` on 2024-11-21 19:12:24
export PATH="$PATH:$HOME/.local/bin"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Added by `rbenv init` on Mon Jan 13 12:46:41 CET 2025
eval "$(rbenv init - --no-rehash zsh)"
