#!/usr/bin/env bash

set -euo pipefail

info() {
  printf '\n\033[1;34m==>\033[0m %s\n' "$1"
}

warn() {
  printf '\n\033[1;33mWARNING:\033[0m %s\n' "$1"
}

die() {
  printf '\n\033[1;31mERROR:\033[0m %s\n' "$1" >&2
  exit 1
}

if [[ $EUID -eq 0 ]]; then
  die "Run this script as your normal user, not root."
fi

if [[ ! -r /etc/os-release ]]; then
  die "Unable to determine Linux distribution."
fi

source /etc/os-release
DISTRO="${ID:-unknown}"

install_arch() {
  info "Installing Arch dependencies"

  sudo pacman -Syu --needed --noconfirm \
    git \
    openssh \
    zsh \
    neovim \
    starship \
    zoxide \
    eza \
    ripgrep \
    fd \
    fzf \
    curl \
    wget \
    unzip \
    zsh-autosuggestions \
    zsh-syntax-highlighting
}

install_ubuntu() {
  info "Installing Ubuntu dependencies"

  sudo apt update

  sudo apt install -y \
    git \
    openssh-client \
    zsh \
    neovim \
    zoxide \
    ripgrep \
    fd-find \
    fzf \
    curl \
    wget \
    unzip \
    zsh-autosuggestions \
    zsh-syntax-highlighting

  if apt-cache show eza >/dev/null 2>&1; then
    sudo apt install -y eza
  else
    warn "eza is unavailable from this Ubuntu release."
  fi

  if apt-cache show starship >/dev/null 2>&1; then
    sudo apt install -y starship
  elif ! command -v starship >/dev/null 2>&1; then
    info "Installing Starship"
    curl -sS https://starship.rs/install.sh | sh
  fi

  if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  fi
}

fix_zsh_symlink() {
  info "Ensuring portable ~/.zshrc symlink"

  local target="$HOME/.config/zsh/zshrc"

  [[ -f "$target" ]] || die "Missing $target"

  rm -f "$HOME/.zshrc"
  ln -s ".config/zsh/zshrc" "$HOME/.zshrc"
}

set_default_shell() {
  local zsh_path=""

  # Prefer known valid login-shell paths.
  for candidate in /usr/bin/zsh /bin/zsh /usr/local/bin/zsh; do
    if [[ -x "$candidate" ]] && grep -Fxq "$candidate" /etc/shells; then
      zsh_path="$candidate"
      break
    fi
  done

  if [[ -z "$zsh_path" ]]; then
    warn "Zsh is installed, but no valid Zsh path was found in /etc/shells."
    warn "Current Zsh executable: $(command -v zsh 2>/dev/null || echo unknown)"
    return
  fi

  if [[ "${SHELL:-}" != "$zsh_path" ]]; then
    info "Setting Zsh as default shell: $zsh_path"
    chsh -s "$zsh_path"
  else
    info "Zsh is already the default shell"
  fi
}

verify() {
  info "Verifying tools"

  local tools=(
    git
    zsh
    nvim
    starship
    zoxide
    rg
    fd
    fzf
  )

  for tool in "${tools[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
      printf '  ✓ %s\n' "$tool"
    else
      printf '  ✗ %s\n' "$tool"
    fi
  done

  printf '\n.zshrc -> %s\n' "$(readlink "$HOME/.zshrc")"
}

case "$DISTRO" in
  arch)
    install_arch
    ;;
  ubuntu)
    install_ubuntu
    ;;
  *)
    die "Unsupported distribution: $DISTRO"
    ;;
esac

fix_zsh_symlink
set_default_shell
verify

info "Setup complete"
printf '\nRun:\n  exec zsh\n'
