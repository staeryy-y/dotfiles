#!/usr/bin/env bash
# Bootstraps this dotfiles setup on macOS or Ubuntu/Debian Linux.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

info() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }

# --- Homebrew -------------------------------------------------------------
# Used as the single package manager on both macOS and Linux so package
# names and versions (neovim, zellij, pure) don't have to be tracked
# per-distro.
if [[ "$OS" == "Linux" ]] && ! command -v brew >/dev/null 2>&1 && command -v apt-get >/dev/null 2>&1; then
  info "Installing Homebrew build prerequisites (apt)..."
  sudo apt-get update
  sudo apt-get install -y build-essential procps curl file git
fi

if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

for prefix in /opt/homebrew /home/linuxbrew/.linuxbrew /usr/local; do
  if [[ -x "$prefix/bin/brew" ]]; then
    eval "$("$prefix/bin/brew" shellenv)"
    break
  fi
done

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not on PATH after installation; aborting." >&2
  exit 1
fi

# --- Packages ---------------------------------------------------------------
info "Installing neovim, zellij, zsh, pure, lazygit, difftastic..."
brew install neovim zellij zsh pure lazygit difftastic

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
BREW_ZSH="$(command -v zsh)"
if [[ "${SHELL:-}" != "$BREW_ZSH" ]]; then
  info "Setting zsh ($BREW_ZSH) as the default shell..."
  grep -qx "$BREW_ZSH" /etc/shells 2>/dev/null || echo "$BREW_ZSH" | sudo tee -a /etc/shells >/dev/null
  chsh -s "$BREW_ZSH" || info "Could not chsh automatically; run 'chsh -s $BREW_ZSH' manually."
fi

info "Done. Restart your terminal or run: exec zsh"
