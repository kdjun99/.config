### ─────────────────────────────
### 기본 설정
### ─────────────────────────────
export LANG="en_US.UTF-8"
export EDITOR="/opt/homebrew/bin/nvim"

### ─────────────────────────────
### alias 설정
### ─────────────────────────────
#alias cd="z"
alias ls="eza --icons=always"
alias ll="ls -al"
alias nv="nvim"
alias la="tree"
alias nvuse="nvm use"
alias cx="codex"
alias lz="lazygit"
alias rosetta-zsh='arch -x86_64 zsh'

# git alias
alias g="git"
alias gmj="gitmoji commit"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%C(yellow)%h%C(reset)%C(bold cyan)%d %C(cyan)%ar %C(green)%an%n%C(bold white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gshow="git show"
alias gbranch="git branch"
alias gadd="git add"
alias gpush="git push"
alias gpull="git pull"
alias gp="git push"
alias gc="gitmoji -c"

# 디렉토리 이동
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# tmux 세션
alias tl='~/scripts/tmux-linkareer.sh'
alias tb='~/scripts/tmux-boughtit.sh'

# 기타
alias wp='~/.config/ghostty/rotate-wallpaper.sh && echo "Wallpaper changed! Reapply setting by restarting Ghostty."'
# wpc: toggle ghostty background-image on/off (comment/uncomment)
wpc() {
  local cfg="$HOME/.config/ghostty/config"
  if grep -q "^background-image " "$cfg" 2>/dev/null; then
    sed -i '' 's/^background-image /#background-image /' "$cfg"
    echo "Wallpaper disabled. Restart Ghostty to apply."
  elif grep -q "^#background-image " "$cfg" 2>/dev/null; then
    sed -i '' 's/^#background-image /background-image /' "$cfg"
    echo "Wallpaper enabled. Restart Ghostty to apply."
  else
    echo "No background-image lines found in config."
  fi
}

alias gm="gemini"
alias claude="$HOME/.claude/claude-theme-wrapper.sh"
alias cl="claude --dangerously-skip-permissions"
alias mc="micro"
alias nu="nvm use"
alias ros='arch -x86_64 zsh'
alias grw="./gradlew"
alias cat="bat -p --paging=never"

### ─────────────────────────────
### history 설정
### ─────────────────────────────
export HISTFILE="$HOME/.zsh_history"
export SAVEHIST=1000
export HISTSIZE=999

setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

#bindkey '^[[A' history-search-backward
#bindkey '^[[B' history-search-forward

### ─────────────────────────────
### 경로 설정 (중복 제거)
### ─────────────────────────────
export PATH="/opt/homebrew/opt/libpq/bin:/opt/homebrew/opt/mysql-client@8.0/bin:$PATH"
export PATH="$HOME/.flutter/3.29.2/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="$HOME/.gem/bin:/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"
export PATH="$HOME/Library/Android/sdk/tools/latest/bin:$PATH"

export GEM_HOME="$HOME/.gem"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
export OMC_SLACK=1
export NVM_DIR="$HOME/.nvm"

### ─────────────────────────────
### brew prefix 캐싱
### ─────────────────────────────
BREW_PREFIX="$(brew --prefix)"

# zsh 플러그인
source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

plugins=(
    git
    docker
    kubectl
    aws
    terraform
    python
    node
    ruby
    vscode
    zsh-syntax-highlighting
    zsh-autosuggestions
)

### ─────────────────────────────
### starship & zoxide
### ─────────────────────────────
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

### nvm lazy load

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
eval "$(atuin init zsh)"
export PATH="$HOME/.local/bin:$PATH"

# pyenv 설정
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi


export AWS_PROFILE=dongjun

# Git Worktree Manager
[[ -f "$HOME/.config/zsh/git-worktree.zsh" ]] && source "$HOME/.config/zsh/git-worktree.zsh"

[[ ":$PATH:" != *":$HOME/.config/kaku/zsh/bin:"* ]] && export PATH="$HOME/.config/kaku/zsh/bin:$PATH" # Kaku PATH Integration
[[ -f "$HOME/.config/kaku/zsh/kaku.zsh" ]] && source "$HOME/.config/kaku/zsh/kaku.zsh" # Kaku Shell Integration
