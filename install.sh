#!/usr/bin/env bash
# Bootstraps this dotfiles setup on macOS or Ubuntu/Debian Linux.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"
BIN_DIR="$HOME/.local/bin"

info() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }

# Downloads the newest GitHub release asset of $repo whose URL matches
# $pattern, extracts it, and installs the $bin_name executable it contains
# into $BIN_DIR. Used for tools that apt doesn't reliably package
# (zellij/lazygit/difftastic are missing or too old on many Ubuntu releases).
install_binary_release() {
  local repo="$1" pattern="$2" bin_name="$3"
  local url tmp
  url="$(curl -fsSL "https://api.github.com/repos/${repo}/releases/latest" \
    | grep -o '"browser_download_url": *"[^"]*"' \
    | cut -d'"' -f4 \
    | grep "$pattern" \
    | head -n1)"
  if [[ -z "$url" ]]; then
    echo "Could not find a release asset for $repo matching '$pattern'" >&2
    return 1
  fi
  info "Installing ${bin_name} from ${url}..."
  tmp="$(mktemp -d)"
  curl -fsSL "$url" -o "$tmp/asset.tar.gz"
  tar -xzf "$tmp/asset.tar.gz" -C "$tmp"
  mkdir -p "$BIN_DIR"
  install -m 755 "$(find "$tmp" -type f -name "$bin_name")" "$BIN_DIR/$bin_name"
  rm -rf "$tmp"
}

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
    info "Installing neovim, zsh, git, curl (apt)..."
    sudo apt-get update
    sudo apt-get install -y neovim zsh git curl

    # zellij, lazygit, and difftastic are missing (or too old) in many
    # Ubuntu apt repos, so grab prebuilt binaries straight from GitHub
    # releases instead.
    case "$(uname -m)" in
      x86_64) lazygit_arch=x86_64 ;;
      aarch64|arm64) lazygit_arch=arm64 ;;
      *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
    esac
    install_binary_release "zellij-org/zellij" "/zellij-$(uname -m)-unknown-linux-musl.tar.gz" zellij
    install_binary_release "jesseduffield/lazygit" "_linux_${lazygit_arch}.tar.gz" lazygit
    install_binary_release "Wilfred/difftastic" "/difft-$(uname -m)-unknown-linux-gnu.tar.gz" difft
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
