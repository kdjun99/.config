#!/bin/bash
set -euo pipefail

# ─────────────────────────────
# macOS Development Environment Setup
# Usage: curl -fsSL https://raw.githubusercontent.com/kdjun99/.config/main/setup.sh | bash
# ─────────────────────────────

DOTFILES_DIR="$HOME/.config"
DOTFILES_REPO="git@github.com:kdjun99/.config.git"
DOTFILES_REPO_HTTPS="https://github.com/kdjun99/.config.git"

info()  { printf "\033[1;34m[INFO]\033[0m  %s\n" "$1"; }
ok()    { printf "\033[1;32m[OK]\033[0m    %s\n" "$1"; }
warn()  { printf "\033[1;33m[WARN]\033[0m  %s\n" "$1"; }
error() { printf "\033[1;31m[ERROR]\033[0m %s\n" "$1"; exit 1; }

# ─────────────────────────────
# Phase 1: Xcode Command Line Tools
# ─────────────────────────────
phase_xcode() {
  info "Phase 1: Xcode Command Line Tools"
  if xcode-select -p &>/dev/null; then
    ok "Xcode CLT already installed"
  else
    info "Installing Xcode CLT..."
    xcode-select --install
    echo "Press Enter after Xcode CLT installation completes..."
    read -r
  fi
}

# ─────────────────────────────
# Phase 2: Homebrew
# ─────────────────────────────
phase_homebrew() {
  info "Phase 2: Homebrew"
  if command -v brew &>/dev/null; then
    ok "Homebrew already installed"
  else
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

# ─────────────────────────────
# Phase 3: Git configuration & SSH key
# ─────────────────────────────
phase_git() {
  info "Phase 3: Git & SSH setup"

  # Install gh first (needed for SSH key upload)
  if ! command -v gh &>/dev/null; then
    info "Installing GitHub CLI..."
    brew install gh
  fi

  # Git user config
  if [[ -z "$(git config --global user.name 2>/dev/null)" ]]; then
    read -rp "Git user.name: " git_name
    git config --global user.name "$git_name"
  else
    ok "Git user.name: $(git config --global user.name)"
  fi

  if [[ -z "$(git config --global user.email 2>/dev/null)" ]]; then
    read -rp "Git user.email: " git_email
    git config --global user.email "$git_email"
  else
    ok "Git user.email: $(git config --global user.email)"
  fi

  # SSH key
  local ssh_key="$HOME/.ssh/id_ed25519"
  if [[ -f "$ssh_key" ]]; then
    ok "SSH key already exists"
  else
    info "Generating SSH key..."
    local email
    email="$(git config --global user.email)"
    ssh-keygen -t ed25519 -C "$email" -f "$ssh_key" -N ""
    eval "$(ssh-agent -s)"
    ssh-add "$ssh_key"
    ok "SSH key generated"
  fi

  # GitHub authentication & SSH key upload
  if gh auth status &>/dev/null; then
    ok "GitHub CLI already authenticated"
  else
    info "Authenticating with GitHub (browser will open)..."
    gh auth login -p ssh -w
  fi

  # Upload SSH key if not already on GitHub
  local key_fingerprint
  key_fingerprint="$(ssh-keygen -lf "$ssh_key.pub" | awk '{print $2}')"
  if gh ssh-key list 2>/dev/null | grep -q "$key_fingerprint"; then
    ok "SSH key already registered on GitHub"
  else
    local hostname
    hostname="$(scutil --get ComputerName 2>/dev/null || hostname -s)"
    gh ssh-key add "$ssh_key.pub" --title "$hostname"
    ok "SSH key uploaded to GitHub"
  fi
}

# ─────────────────────────────
# Phase 4: Clone dotfiles
# ─────────────────────────────
phase_clone() {
  info "Phase 4: Clone dotfiles"
  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    ok "Dotfiles repo already cloned"
    info "Pulling latest changes..."
    git -C "$DOTFILES_DIR" pull --rebase
  else
    # Backup existing .config if it exists
    if [[ -d "$DOTFILES_DIR" ]]; then
      warn "Backing up existing ~/.config to ~/.config.backup"
      mv "$DOTFILES_DIR" "$DOTFILES_DIR.backup"
    fi
    info "Cloning dotfiles..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR" || {
      warn "SSH clone failed, trying HTTPS..."
      git clone "$DOTFILES_REPO_HTTPS" "$DOTFILES_DIR"
    }
  fi
}

# ─────────────────────────────
# Phase 5: Brew bundle
# ─────────────────────────────
phase_brew_bundle() {
  info "Phase 5: Installing packages via Brewfile"
  if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
    brew bundle --file="$DOTFILES_DIR/Brewfile" --no-lock
    ok "Brew bundle complete"
  else
    warn "Brewfile not found, skipping"
  fi
}

# ─────────────────────────────
# Phase 6: Symlinks
# ─────────────────────────────
phase_symlinks() {
  info "Phase 6: Creating symlinks"

  local -A links=(
    ["$HOME/.zshrc"]="$DOTFILES_DIR/.zshrc"
    ["$HOME/.gitconfig"]="$DOTFILES_DIR/git/gitconfig"
    ["$HOME/.gitmessage.txt"]="$DOTFILES_DIR/git/gitmessage.txt"
    ["$HOME/.tmux.conf"]="$DOTFILES_DIR/tmux/tmux.conf"
  )

  for target in "${!links[@]}"; do
    local source="${links[$target]}"
    if [[ -L "$target" ]]; then
      ok "Already linked: $target"
    elif [[ -f "$target" ]]; then
      warn "Backing up: $target → ${target}.backup"
      mv "$target" "${target}.backup"
      ln -s "$source" "$target"
      ok "Linked: $target → $source"
    else
      ln -s "$source" "$target"
      ok "Linked: $target → $source"
    fi
  done

  # Git commit template
  git config --global commit.template "$DOTFILES_DIR/git/gitmessage.txt"
  ok "Git commit template configured"
}

# ─────────────────────────────
# Phase 7: Version Managers
# ─────────────────────────────
phase_version_managers() {
  info "Phase 7: Version managers"

  # NVM - Node
  export NVM_DIR="$HOME/.nvm"
  if [[ -d "$NVM_DIR" ]]; then
    ok "NVM already installed"
  else
    info "NVM directory will be created by brew's nvm"
    mkdir -p "$NVM_DIR"
  fi
  [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"
  if command -v nvm &>/dev/null; then
    info "Installing latest LTS Node..."
    nvm install --lts
    ok "Node $(node --version) installed"
  fi

  # SDKMAN - Java/Kotlin/Gradle
  if [[ -d "$HOME/.sdkman" ]]; then
    ok "SDKMAN already installed"
  else
    info "Installing SDKMAN..."
    curl -s "https://get.sdkman.io?rcupdate=false" | bash
    ok "SDKMAN installed"
  fi

  # pyenv - Python (already installed via brew)
  if command -v pyenv &>/dev/null; then
    ok "pyenv already installed via Homebrew"
  fi
}

# ─────────────────────────────
# Phase 8: macOS defaults
# ─────────────────────────────
phase_macos() {
  info "Phase 8: macOS preferences"

  # Show hidden files in Finder
  defaults write com.apple.finder AppleShowAllFiles -bool true

  # Show path bar in Finder
  defaults write com.apple.finder ShowPathbar -bool true

  # Disable press-and-hold for keys in favor of key repeat
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

  # Fast key repeat rate
  defaults write NSGlobalDomain KeyRepeat -int 2
  defaults write NSGlobalDomain InitialKeyRepeat -int 15

  ok "macOS preferences configured"
}

# ─────────────────────────────
# Main
# ─────────────────────────────
main() {
  echo ""
  echo "╔══════════════════════════════════════╗"
  echo "║   macOS Dev Environment Setup        ║"
  echo "║   github.com/kdjun99/.config         ║"
  echo "╚══════════════════════════════════════╝"
  echo ""

  phase_xcode
  phase_homebrew
  phase_git
  phase_clone
  phase_brew_bundle
  phase_symlinks
  phase_version_managers
  phase_macos

  echo ""
  ok "Setup complete! Restart your terminal or run: exec zsh"
  echo ""
  warn "Manual steps remaining:"
  echo "  1. SDKMAN: Open new terminal, run 'sdk install java' for desired version"
  echo "  2. Flutter: Download and install manually if needed"
  echo "  3. Android Studio: Install from https://developer.android.com/studio"
  echo ""
}

main "$@"
