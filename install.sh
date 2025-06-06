#!/usr/bin/env bash

# Dotfiles installer
# 
# This script creates symlinks from the home directory to the dotfiles in ~/.dotfiles

# Variables
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to backup and link files
link_file() {
    local src="$1"
    local dest="$2"
    
    # Backup existing file
    if [ -f "$dest" ] || [ -L "$dest" ]; then
        echo "Backing up $dest to $BACKUP_DIR/"
        mv "$dest" "$BACKUP_DIR/"
    fi
    
    # Create symlink
    echo "Creating symlink: $dest -> $src"
    ln -sf "$src" "$dest"
}

# Files to symlink
files=(
    ".aliases"
    ".bash_profile"
    ".bash_prompt"
    ".bashrc"
    ".curlrc"
    ".editorconfig"
    ".exports"
    ".functions"
    ".gdbinit"
    ".gitattributes"
    ".gvimrc"
    ".inputrc"
    ".profile"
    ".screenrc"
    ".tmuxp"
    ".wgetrc"
)

# Create symlinks
for file in "${files[@]}"; do
    link_file "$DOTFILES_DIR/$file" "$HOME/$file"
done

# Source bash_profile
source "$HOME/.bash_profile"

# Add Docker aliases
if [ ! -d "$HOME/.docker" ]; then
    mkdir -p "$HOME/.docker"
fi
link_file "$DOTFILES_DIR/docker-aliases" "$HOME/.docker/aliases"

# Make sure the script is executable
chmod +x "$DOTFILES_DIR/install.sh"

echo "Dotfiles installation complete!"
echo "You may need to restart your terminal or run 'source ~/.bash_profile'" 