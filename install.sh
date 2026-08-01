#!/usr/bin/env bash
# Bootstraps this dotfiles setup on macOS or Ubuntu/Debian Linux.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

info() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }

# --- Packages ---------------------------------------------------------------
case "$OS" in
  Darwin)
    if ! command -v brew >/dev/null 2>&1; then
      info "Installing Homebrew..."
      NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    for prefix in /opt/homebrew /usr/local; do
      if [[ -x "$prefix/bin/brew" ]]; then
        eval "$("$prefix/bin/brew" shellenv)"
        break
      fi
    done
    info "Installing neovim, zellij, zsh, lazygit, difftastic (brew)..."
    brew install neovim zellij zsh lazygit difftastic
    ;;
  Linux)
    info "Installing neovim, zellij, zsh, lazygit, difftastic, git, curl (apt)..."
    sudo apt-get update
    sudo apt-get install -y neovim zellij zsh lazygit difftastic git curl
    ;;
  *)
    echo "Unsupported OS: $OS" >&2
    exit 1
    ;;
esac

# --- Pure prompt ----------------------------------------------------------
# Installed the same way on both platforms (not packaged consistently by
# apt or brew), so the zshrc fpath logic doesn't need an OS branch.
PURE_DIR="$HOME/.zsh/pure"
if [[ -d "$PURE_DIR/.git" ]]; then
  info "Updating pure prompt..."
  git -C "$PURE_DIR" pull --ff-only -q
else
  info "Installing pure prompt..."
  mkdir -p "$(dirname "$PURE_DIR")"
  git clone -q https://github.com/sindresorhus/pure.git "$PURE_DIR"
fi

# --- Oh My Zsh --------------------------------------------------------------
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --- Symlink dotfiles ---------------------------------------------------
info "Linking dotfiles..."
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
ln -sfn "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
mkdir -p "$HOME/.config/zellij"
ln -sf "$DOTFILES_DIR/zellij/config.kdl" "$HOME/.config/zellij/config.kdl"
ln -sf "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"

# --- Default shell -----------------------------------------------------
ZSH_BIN="$(command -v zsh)"
if [[ "${SHELL:-}" != "$ZSH_BIN" ]]; then
  info "Setting zsh ($ZSH_BIN) as the default shell..."
  grep -qx "$ZSH_BIN" /etc/shells 2>/dev/null || echo "$ZSH_BIN" | sudo tee -a /etc/shells >/dev/null
  chsh -s "$ZSH_BIN" || info "Could not chsh automatically; run 'chsh -s $ZSH_BIN' manually."
fi

info "Done. Restart your terminal or run: exec zsh"
