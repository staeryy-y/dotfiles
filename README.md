# dotfiles

Personal terminal setup: neovim, zsh (Oh My Zsh + [pure](https://github.com/sindresorhus/pure) prompt),
[zellij](https://zellij.dev), [lazygit](https://github.com/jesseduffield/lazygit), and
[difftastic](https://difftastic.wilfred.me.uk) as the git diff. Works on macOS and Ubuntu/Debian Linux.

## Install

```sh
git clone <this-repo-url> ~/Projects/dotfiles
cd ~/Projects/dotfiles
./install.sh
```

This will:

1. Install [Homebrew](https://brew.sh) if it's not already present (used as the package
   manager on both macOS and Linux, via [Linuxbrew](https://docs.brew.sh/Homebrew-on-Linux)).
2. `brew install` neovim, zellij, zsh, pure, lazygit, and difftastic.
3. Install Oh My Zsh (unattended).
4. Symlink:
   - `zsh/zshrc` → `~/.zshrc`
   - `nvim/` → `~/.config/nvim`
   - `zellij/config.kdl` → `~/.config/zellij/config.kdl`
   - `git/gitconfig` → `~/.gitconfig`
5. Set zsh as the default login shell.

Re-run `./install.sh` any time — every step is idempotent.

## Layout

- `nvim/` — Neovim config (lazy.nvim, bootstraps itself on first launch).
- `zsh/zshrc` — shell config: Oh My Zsh + pure prompt.
- `zellij/config.kdl` — zellij config (custom vim-style keybinds).
- `git/gitconfig` — git config, `git diff`/`git show`/`git log -p` piped through difftastic.
- `install.sh` — bootstrap script, detects macOS vs Linux.
