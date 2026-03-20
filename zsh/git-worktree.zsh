# Git Worktree Manager (gw)
# Interactive git worktree management with fzf
#
# Usage:
#   gw          - Switch to a worktree (fzf)
#   gw add <branch> [base]  - Create worktree and cd into it
#   gw rm       - Remove a worktree (fzf)
#   gw ls       - List all worktrees

gw() {
  if ! git rev-parse --git-dir &>/dev/null; then
    echo "Not a git repository"
    return 1
  fi

  local cmd="${1:-switch}"
  shift 2>/dev/null

  case "$cmd" in
    switch|s)
      _gw_switch
      ;;
    add|a)
      _gw_add "$@"
      ;;
    rm|remove|r)
      _gw_remove
      ;;
    ls|list|l)
      git worktree list
      ;;
    *)
      # If first arg isn't a subcommand, treat bare "gw" as switch
      _gw_switch
      ;;
  esac
}

_gw_switch() {
  local selected
  selected=$(git worktree list | fzf \
    --height=40% \
    --reverse \
    --prompt="Switch worktree > " \
    --preview='git -C {1} log --oneline -10 2>/dev/null' \
    --preview-window=right:50%)

  if [[ -n "$selected" ]]; then
    local path="${selected%% *}"
    cd "$path" || return 1
    echo "Switched to: $path"
    echo "Branch: $(git branch --show-current 2>/dev/null)"
  fi
}

_gw_add() {
  local branch="$1"
  local base="${2:-HEAD}"

  if [[ -z "$branch" ]]; then
    # No branch specified: fzf select from remote branches
    branch=$(git branch -r --format='%(refname:short)' | sed 's|origin/||' | sort -u | fzf \
      --height=40% \
      --reverse \
      --prompt="Branch to checkout > " \
      --preview='git log --oneline -10 origin/{} 2>/dev/null || git log --oneline -10 {} 2>/dev/null')

    if [[ -z "$branch" ]]; then
      echo "Cancelled"
      return 1
    fi
  fi

  local repo_root
  repo_root=$(git worktree list | head -1 | awk '{print $1}')
  local repo_name
  repo_name=$(basename "$repo_root")

  # ~/.gw/[repo]/[branch-path] structure
  local worktree_path="$HOME/.gw/${repo_name}/${branch}"
  mkdir -p "$(dirname "$worktree_path")"

  # Check if branch exists locally or remotely
  if git show-ref --verify --quiet "refs/heads/$branch" 2>/dev/null; then
    # Local branch exists
    git worktree add "$worktree_path" "$branch"
  elif git show-ref --verify --quiet "refs/remotes/origin/$branch" 2>/dev/null; then
    # Remote branch exists, create tracking branch
    git worktree add "$worktree_path" -b "$branch" "origin/$branch"
  else
    # New branch from base
    git worktree add "$worktree_path" -b "$branch" "$base"
  fi

  if [[ $? -eq 0 ]]; then
    # Copy .env* files from main worktree preserving directory structure
    _gw_copy_env_files "$repo_root" "$worktree_path"

    cd "$worktree_path" || return 1
    echo "Created worktree: $worktree_path"
    echo "Branch: $(git branch --show-current)"
  fi
}

_gw_copy_env_files() {
  local src="$1"
  local dst="$2"
  local count=0

  # Find all .env* files in the source worktree (respecting common patterns)
  while IFS= read -r envfile; do
    local relpath="${envfile#$src/}"
    local target="$dst/$relpath"
    mkdir -p "$(dirname "$target")"
    cp "$envfile" "$target"
    echo "  Copied: $relpath"
    (( count++ ))
  done < <(find "$src" -name '.env' -o -name '.env.*' -o -name '.env.local' 2>/dev/null \
    | grep -v node_modules \
    | grep -v .git/ \
    | grep -v dist/ \
    | grep -v build/ \
    | sort)

  if (( count > 0 )); then
    echo "Copied $count env file(s)"
  fi
}

_gw_remove() {
  local main_worktree
  main_worktree=$(git worktree list | head -1 | awk '{print $1}')

  local selected
  selected=$(git worktree list | tail -n +2 | fzf \
    --height=40% \
    --reverse \
    --multi \
    --prompt="Remove worktree > " \
    --preview='git -C {1} status -sb 2>/dev/null')

  if [[ -z "$selected" ]]; then
    return 0
  fi

  echo "$selected" | while IFS= read -r line; do
    local path="${line%% *}"
    local current_dir="$PWD"

    # If we're inside the worktree being removed, cd out first
    if [[ "$current_dir" == "$path"* ]]; then
      cd "$main_worktree" || cd "$HOME"
      echo "Moved to: $(pwd)"
    fi

    git worktree remove "$path" 2>/dev/null
    if [[ $? -ne 0 ]]; then
      echo "Force remove $path? (y/N)"
      read -r confirm
      if [[ "$confirm" =~ ^[Yy]$ ]]; then
        git worktree remove --force "$path"
      fi
    fi
    echo "Removed: $path"
  done
}
