# Git Deploy (gdp)
# Merge current branch into a target branch and push
#
# Usage:
#   gdp <target>           Merge current branch into target, push, return
#   gdp                    Use default target from git config
#   gdp set <branch>       Set default target for this repo
#   gdp status             Show current default target
#
# Setup (per repo):
#   gdp set staging        Sets "staging" as default deploy target
#
# Example:
#   gdp dev                Merge current branch into dev, push, come back
#   gdp                    Same, using the configured default

gdp() {
  if ! git rev-parse --git-dir &>/dev/null; then
    echo "Not a git repository"
    return 1
  fi

  local cmd="$1"

  case "$cmd" in
    -h|--help|help|h)
      cat <<'EOF'
Git Deploy (gdp)
Merge current branch into a target branch and push

Usage:
  gdp <target>           Merge current branch into target, push, return
  gdp                    Use default target from git config
  gdp set <branch>       Set default deploy target for this repo
  gdp status             Show current default target

Setup (per repo):
  gdp set staging

Example:
  gdp dev                Merge into dev, push, come back
EOF
      ;;
    set)
      local branch="$2"
      if [[ -z "$branch" ]]; then
        echo "Usage: gdp set <branch>"
        return 1
      fi
      git config deploy.target "$branch"
      echo "Default deploy target set to: $branch"
      ;;
    status)
      local target
      target=$(git config deploy.target 2>/dev/null)
      if [[ -n "$target" ]]; then
        echo "Default deploy target: $target"
      else
        echo "No default deploy target set. Run: gdp set <branch>"
      fi
      ;;
    *)
      _gdp_deploy "$cmd"
      ;;
  esac
}

_gdp_deploy() {
  local target="$1"

  # Resolve target branch
  if [[ -z "$target" ]]; then
    target=$(git config deploy.target 2>/dev/null)
    if [[ -z "$target" ]]; then
      echo "No target specified and no default set."
      echo "Usage: gdp <target> or gdp set <branch>"
      return 1
    fi
  fi

  local work_branch
  work_branch=$(git branch --show-current 2>/dev/null)

  if [[ -z "$work_branch" ]]; then
    echo "Error: detached HEAD state"
    return 1
  fi

  if [[ "$work_branch" == "$target" ]]; then
    echo "Error: already on target branch '$target'"
    return 1
  fi

  # Check for uncommitted changes
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Error: uncommitted changes detected. Commit or stash first."
    return 1
  fi

  echo "Deploy: $work_branch -> $target"
  echo ""

  # Checkout target, fetch, pull, merge, push
  echo "-> Checking out $target..."
  git checkout "$target" || { echo "Failed to checkout $target"; return 1; }

  echo "-> Fetching..."
  git fetch --prune --quiet

  echo "-> Pulling latest..."
  git pull || { echo "Failed to pull. Returning to $work_branch."; git checkout "$work_branch"; return 1; }

  echo "-> Merging $work_branch..."
  git merge "$work_branch" || {
    echo ""
    echo "Merge conflict detected!"
    echo "Resolve conflicts, then run:"
    echo "  git commit && git push && git checkout $work_branch"
    return 1
  }

  echo "-> Pushing..."
  git push || { echo "Failed to push. You're still on $target."; return 1; }

  echo ""
  echo "-> Returning to $work_branch..."
  git checkout "$work_branch"

  echo ""
  echo "Done! $work_branch merged into $target and pushed."
}
