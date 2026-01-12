#!/bin/bash

# Dotfiles Installation Script
# This script creates symlinks from your home directory to the dotfiles in this repo
# It will backup any existing files before creating symlinks

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo -e "${GREEN}Installing dotfiles from: $DOTFILES_DIR${NC}"

# Create backup directory
mkdir -p "$BACKUP_DIR"
echo -e "${YELLOW}Backups will be stored in: $BACKUP_DIR${NC}"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"

    # Backup existing file/symlink if it exists
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo -e "${YELLOW}Backing up existing: $target${NC}"
        mv "$target" "$BACKUP_DIR/"
    fi

    # Create symlink
    ln -sf "$source" "$target"
    echo -e "${GREEN}✓ Linked: $target -> $source${NC}"
}

echo ""
echo "Creating symlinks..."
echo ""

# Zsh configs
create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"
create_symlink "$DOTFILES_DIR/zsh/.profile" "$HOME/.profile"
create_symlink "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"

# Git config
create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# Tmux config
create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Starship config
create_symlink "$DOTFILES_DIR/config/starship/starship.toml" "$HOME/.config/starship.toml"

# Ghostty config
create_symlink "$DOTFILES_DIR/config/ghostty/config" "$HOME/.config/ghostty/config"

# Yabai config
create_symlink "$DOTFILES_DIR/config/yabai/yabairc" "$HOME/.config/yabai/yabairc"

# Skhd config
create_symlink "$DOTFILES_DIR/config/skhd/skhdrc" "$HOME/.config/skhd/skhdrc"

echo ""
echo -e "${GREEN}✅ Dotfiles installation complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Reload your shell: source ~/.zshrc"
echo "  2. Restart yabai: brew services restart yabai"
echo "  3. Restart skhd: brew services restart skhd"
echo ""
echo -e "${YELLOW}Your old configs have been backed up to: $BACKUP_DIR${NC}"
