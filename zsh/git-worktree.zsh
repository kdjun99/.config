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
    -h|--help|help|h)
      cat <<'EOF'
Git Worktree Manager (gw)
Interactive git worktree management with fzf

Usage:
  gw                      Switch to a worktree (fzf)
  gw add <branch> [base]  Create worktree and cd into it
  gw rm                   Remove a worktree (fzf, multi-select)
  gw ls                   List all worktrees
  gw help                 Show this help

Aliases:
  switch|s    gw switch
  add|a       gw add
  rm|remove|r gw rm
  ls|list|l   gw ls
EOF
      ;;
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
      _gw_list
      ;;
    *)
      echo "Unknown command: $cmd"
      echo "Run 'gw --help' for usage"
      return 1
      ;;
  esac
}

# Parse porcelain output into "branch  path" format
_gw_fmt() {
  git worktree list --porcelain | awk '
    /^worktree / { path = substr($0, 10) }
    /^branch /   { branch = $2; sub(/^refs\/heads\//, "", branch) }
    /^HEAD /     { head = $2 }
    /^$/ {
      if (branch != "") {
        printf "%-40s %s\n", branch, path
      } else {
        printf "%-40s %s\n", "(detached " substr(head,1,7) ")", path
      }
      branch = ""; head = ""; path = ""
    }
    END {
      if (path != "") {
        if (branch != "") {
          printf "%-40s %s\n", branch, path
        } else {
          printf "%-40s %s\n", "(detached " substr(head,1,7) ")", path
        }
      }
    }
  '
}

_gw_switch() {
  local selected
  selected=$(_gw_fmt | fzf \
    --height=40% \
    --reverse \
    --prompt="Switch worktree > " \
    --preview='git -C {2} log --oneline --decorate -15 2>/dev/null' \
    --preview-window=right:50%)

  if [[ -n "$selected" ]]; then
    local wt_path
    wt_path=$(echo "$selected" | awk '{print $NF}')
    cd "$wt_path" || return 1
    echo "Switched to: $(git branch --show-current 2>/dev/null || echo 'detached HEAD')"
  fi
}

_gw_list() {
  _gw_fmt | while IFS= read -r line; do
    local branch path
    branch=$(echo "$line" | awk '{$NF=""; sub(/[[:space:]]+$/, ""); print}')
    path=$(echo "$line" | awk '{print $NF}')
    if [[ "$path" == "$PWD" ]]; then
      printf "* \033[1;32m%-40s\033[0m %s\n" "$branch" "$path"
    else
      printf "  %-40s %s\n" "$branch" "$path"
    fi
  done
}

_gw_add() {
  local branch="$1"
  local base="$2"
  local has_base=$([[ -n "$base" ]] && echo true || echo false)

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

  # Fetch latest remote branches
  echo "Fetching remote branches..."
  git fetch --prune --quiet

  # Check if branch exists locally or remotely
  if $has_base; then
    # Base specified: create/reset branch at base point
    git worktree add "$worktree_path" -B "$branch" "$base"
  elif git show-ref --verify --quiet "refs/heads/$branch" 2>/dev/null; then
    # Local branch exists
    git worktree add "$worktree_path" "$branch"
  elif git show-ref --verify --quiet "refs/remotes/origin/$branch" 2>/dev/null; then
    # Remote branch exists, create tracking branch
    git worktree add "$worktree_path" -b "$branch" "origin/$branch"
  else
    # New branch from HEAD
    git worktree add "$worktree_path" -b "$branch" HEAD
  fi

  if [[ $? -eq 0 ]]; then
    # Copy .env* files from main worktree preserving directory structure
    _gw_copy_env_files "$repo_root" "$worktree_path"

    cd "$worktree_path" || return 1
    echo "Created worktree: $worktree_path"
    echo "Branch: $(git branch --show-current)"

    # Auto setup: nvm use + npm install if .nvmrc exists
    _gw_setup_node "$worktree_path"
  fi
}

_gw_setup_node() {
  local wt_path="$1"

  if [[ -f "$wt_path/.nvmrc" ]]; then
    echo ""
    echo "Found .nvmrc — setting up Node environment..."
    nvm use
    if [[ -f "$wt_path/package-lock.json" ]]; then
      npm install
    elif [[ -f "$wt_path/yarn.lock" ]]; then
      yarn install
    elif [[ -f "$wt_path/pnpm-lock.yaml" ]]; then
      pnpm install
    fi
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
  selected=$(_gw_fmt | tail -n +2 | fzf \
    --height=40% \
    --reverse \
    --multi \
    --prompt="Remove worktree > " \
    --preview='git -C {2} status -sb 2>/dev/null')

  if [[ -z "$selected" ]]; then
    return 0
  fi

  local -a wt_lines=("${(@f)selected}")

  for line in "${wt_lines[@]}"; do
    local wt_path
    wt_path=$(echo "$line" | awk '{print $NF}')

    # If we're inside the worktree being removed, cd out first
    if [[ "$PWD" == "$wt_path"* ]]; then
      cd "$main_worktree" || cd "$HOME"
      echo "Moved to: $(pwd)"
    fi

    git worktree remove "$wt_path" 2>/dev/null
    if [[ $? -ne 0 ]]; then
      printf "Force remove $wt_path? (y/N) "
      read -r confirm
      if [[ "$confirm" =~ ^[Yy]$ ]]; then
        git worktree remove --force "$wt_path"
      fi
    fi

    # Clean up leftover directory under ~/.gw
    if [[ "$wt_path" == "$HOME/.gw/"* && -e "$wt_path" ]]; then
      rm -rf "$wt_path"
    fi
    git worktree prune 2>/dev/null
    echo "Removed: $wt_path"
  done
}
