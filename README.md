# Dotfiles tools

- bat
  - What it is: A better `cat` replacement with syntax highlighting and Git-aware output.
  - What it does: Shows file contents in a cleaner terminal UI, supports line numbers, paging, and themes.
  - How to use:
    - `bat .zshrc`
    - `bat -n install.sh`
    - `bat --paging=never README.md`
    - `bat --language bash install.sh`
    - `bat file1 file2`

- eza
  - What it is: A modern replacement for `ls`.
  - What it does: Lists files and directories with icons, Git status, and tree views.
  - How to use:
    - `ls`
    - `ll`
    - `lt`
    - `eza --tree --level=2`
    - `eza -la --git`

- fd
  - What it is: A fast, user-friendly alternative to `find`.
  - What it does: Finds files and directories quickly with intuitive defaults.
  - How to use:
    - `fd .`
    - `fd -t f "*.sh"`
    - `fd -g "*.md"`
    - `fd -I "node_modules"`
    - `find . -name "*.log"` (shell alias fallback)

- fzf
  - What it is: Fuzzy finder for interactive filtering in the terminal.
  - What it does: Lets you search and select files, history, branches, or command output interactively.
  - How to use:
    - `ls | fzf`
    - `history | fzf`
    - `git branch | fzf`
    - `rg -n "TODO" . | fzf`
    - `fd -t f | fzf`

- gh
  - What it is: The GitHub CLI.
  - What it does: Lets you work with GitHub repos, issues, pull requests, and releases from the terminal.
  - How to use:
    - `gh repo view`
    - `gh pr list`
    - `gh issue list`
    - `gh browse`
    - `gh auth login`

- lazygit
  - What it is: A terminal UI for Git.
  - What it does: Makes staging, committing, branching, and history review faster without leaving the shell.
  - How to use:
    - `lazygit`
    - `lg`
    - `lg --logs`
    - `lg --branch`
    - `lazygit -c` (open in current repo)

- ripgrep (`rg`)
  - What it is: A fast text search tool.
  - What it does: Searches codebases quickly and is often faster than `grep`.
  - How to use:
    - `rg "TODO" .`
    - `rg -n "function" src`
    - `rg -i "error" .`
    - `rg -l "TODO" .`
    - `grep "TODO" .` (shell alias fallback)

- starship
  - What it is: A fast shell prompt.
  - What it does: Adds a configurable, informative prompt with git status, tool info, and command context.
  - How to use:
    - Open a new terminal session to see the prompt
    - `starship config`
    - `starship preset nerd-font-symbols > ~/.config/starship.toml`
    - `starship module add git`
    - `starship explain`

- zoxide
  - What it is: A smarter `cd` helper.
  - What it does: Remembers where you have been and lets you jump to frequently used directories quickly.
  - How to use:
    - `z projects`
    - `zi`
    - `zoxide add ~/projects/myapp`
    - `zoxide query --interactive`
    - `cd ~` then `z myapp`

- Shell aliases added here
  - What they are: Small command shortcuts defined in the zsh config.
  - What they do: Replace common commands with more useful defaults.
  - How to use:
    - `ls` → modern directory listing via `eza`
    - `ll` → long listing with git status
    - `lt` → directory tree view
    - `cat` → `bat` output with no paging
    - `grep` → `rg`
    - `find` → `fd`
    - `lg` → `lazygit`
