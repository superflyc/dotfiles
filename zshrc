# Environment & Editor
export EDITOR="vim"  # Used by lazygit (Shift+C) for multi-line commits
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
[ -d "/opt/homebrew/bin" ] && export PATH="/opt/homebrew/bin:$PATH"

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS SHARE_HISTORY

# Shell Completion
autoload -Uz compinit && compinit -C

# Tool Initializers
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

# Modern CLI Tool Aliases & Fallbacks
if command -v eza >/dev/null 2>&1; then
    alias ls="eza --icons"
    alias ll="eza -la --icons --git"
    alias lt="eza --tree --level=2 --icons"
else
    alias ll="ls -la"
fi

command -v bat >/dev/null 2>&1 && alias cat="bat --paging=never"
command -v rg >/dev/null 2>&1 && alias grep="rg"
command -v fd >/dev/null 2>&1 && alias find="fd"
command -v lazygit >/dev/null 2>&1 && alias lg="lazygit"
