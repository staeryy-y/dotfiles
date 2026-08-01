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

1. Install neovim, zsh, lazygit, and difftastic. On macOS all five (plus zellij) come
   from Homebrew. On Linux, neovim/zsh come from `apt`; zellij, lazygit, and difftastic
   are downloaded as prebuilt binaries straight from their GitHub releases into
   `~/.local/bin`, since Ubuntu's apt repos don't reliably carry them (missing or too old
   depending on release).
2. Install the [pure](https://github.com/sindresorhus/pure) prompt by cloning it to
   `~/.zsh/pure` (not reliably packaged by either brew or apt, so it's handled the
   same way on both platforms).
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
