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

# Claude Code (used by the VS Code extension too)
mkdir -p "$HOME/.claude"

if [ -f "$HOME/.claude/CLAUDE.md" ] && [ ! -L "$HOME/.claude/CLAUDE.md" ]; then
    echo "==> Backing up existing ~/.claude/CLAUDE.md to ~/.claude/CLAUDE.md.backup"
    mv "$HOME/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md.backup"
fi

echo "==> Linking ~/.claude/CLAUDE.md..."
ln -sf "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# settings.json is copied/merged rather than symlinked, since Claude Code writes to it
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
if [ ! -f "$CLAUDE_SETTINGS" ]; then
    echo "==> Installing ~/.claude/settings.json..."
    cp "$DOTFILES_DIR/claude/settings.json" "$CLAUDE_SETTINGS"
elif command -v jq >/dev/null 2>&1; then
    echo "==> Merging dotfiles settings into ~/.claude/settings.json..."
    jq -s '.[0] * .[1]' "$CLAUDE_SETTINGS" "$DOTFILES_DIR/claude/settings.json" > "$CLAUDE_SETTINGS.tmp"
    mv "$CLAUDE_SETTINGS.tmp" "$CLAUDE_SETTINGS"
else
    echo "==> jq not found; skipping merge into existing ~/.claude/settings.json"
fi

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
    sudo apt-get install -y git curl ripgrep fd-find bat zsh jq

    if ! command -v fzf >/dev/null 2>&1 || [[ "$(fzf --version)" < "0.48" ]]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --bin
        sudo ln -sf ~/.fzf/bin/fzf /usr/local/bin/fzf
    fi

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

    # GitHub CLI
    if ! command -v gh >/dev/null 2>&1; then
        sudo apt-get install -y gh
    fi

    # eza
    if ! command -v eza >/dev/null 2>&1; then
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
        sudo apt-get update && sudo apt-get install -y eza
    fi

    # Set default shell to zsh
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "==> Setting default shell to zsh..."
        sudo chsh -s "$(which zsh)" "$USER"
    fi
fi

# Claude Code plugins from claude/settings.json (see README: Claude Code)
if command -v claude >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    echo "==> Installing Claude Code plugins..."
    jq -r '.extraKnownMarketplaces // {} | .[].source | .repo // .url' "$DOTFILES_DIR/claude/settings.json" |
        while read -r source; do
            claude plugin marketplace add "$source" --scope user || true
        done
    jq -r '.enabledPlugins // {} | to_entries[] | select(.value) | .key' "$DOTFILES_DIR/claude/settings.json" |
        while read -r plugin; do
            claude plugin install "$plugin" --scope user --yes || true
        done
else
    echo "==> claude or jq not found; skipping Claude Code plugins"
fi

echo "==> Setup complete."
