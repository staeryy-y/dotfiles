#!/usr/bin/env bash
# One-liner installer — fetches this repo and hands off to install.sh:
#   curl -fsSL https://raw.githubusercontent.com/staeryy-y/dotfiles/main/bootstrap.sh | bash
set -euo pipefail

REPO="staeryy-y/dotfiles"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

info() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }

if command -v git >/dev/null 2>&1; then
  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    info "Updating existing checkout at $DOTFILES_DIR..."
    git -C "$DOTFILES_DIR" pull --ff-only
  else
    info "Cloning dotfiles to $DOTFILES_DIR..."
    git clone "https://github.com/${REPO}.git" "$DOTFILES_DIR"
  fi
else
  info "git not found; downloading dotfiles as a tarball to $DOTFILES_DIR..."
  mkdir -p "$DOTFILES_DIR"
  curl -fsSL "https://github.com/${REPO}/archive/refs/heads/main.tar.gz" \
    | tar -xz --strip-components=1 -C "$DOTFILES_DIR"
fi

exec "$DOTFILES_DIR/install.sh"
