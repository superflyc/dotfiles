# Global instructions

These apply to every project. Project-level CLAUDE.md files take precedence.

## Working style
- Keep changes minimal and focused on what was asked.
- Match the existing code's style, naming, and conventions.
- Ask before destructive or hard-to-reverse actions (force pushes, deleting files, dropping data).
- Answers should be short and focused, ideally a sentence or two. I prefer to iterate quickly and this enables that.
- For code generation, use CLI commands where available to take advantage of deterministic scaffolding

## Git
- Don't commit or push unless asked.
- Use conventional commit messages (`feat:`, `fix:`, `chore:`, ...).

## Environment
- Shell tools available: bat, eza, fd, fzf, ripgrep, zoxide, lazygit, gh.
