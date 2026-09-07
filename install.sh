#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Backup existing .zshrc if it's a real file (not a symlink)
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    echo "==> Backing up existing ~/.zshrc to ~/.zshrc.backup"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

echo "==> Linking ~/.zshrc..."
ln -sf "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"

# macOS / Homebrew
if command -v brew >/dev/null 2>&1; then
    if [ -f "$DOTFILES_DIR/Brewfile" ]; then
        echo "==> Running brew bundle..."
        brew bundle --file="$DOTFILES_DIR/Brewfile"
    fi

# Linux / Debian Devcontainer (apt)
elif command -v apt-get >/dev/null 2>&1; then
    echo "==> Linux devcontainer detected. Installing packages via apt..."
    sudo apt-get update -y
    sudo apt-get install -y git curl ripgrep fd-find bat fzf zsh

    mkdir -p "$HOME/.local/bin"

    # Fix Debian binary renames
    [ -f "/usr/bin/batcat" ] && ln -sf /usr/bin/batcat "$HOME/.local/bin/bat"
    [ -f "/usr/bin/fdfind" ] && ln -sf /usr/bin/fdfind "$HOME/.local/bin/fd"

    # Standalone binaries not in standard apt repos
    if ! command -v starship >/dev/null 2>&1; then
        echo "==> Installing starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi

    if ! command -v zoxide >/dev/null 2>&1; then
        echo "==> Installing zoxide..."
        curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    fi

    if ! command -v lazygit >/dev/null 2>&1; then
        echo "==> Installing lazygit..."
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar -xf /tmp/lazygit.tar.gz -C /tmp
        install /tmp/lazygit "$HOME/.local/bin"
        rm -rf /tmp/lazygit*
    fi
fi

echo "==> Setup complete."
