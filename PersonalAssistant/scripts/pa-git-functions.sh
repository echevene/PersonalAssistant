#!/bin/bash

# Personal Assistant Git Functions
# Add to ~/.bashrc: source /path/to/pa-git-functions.sh

# Create new feature branch
pa-branch() {
    if [ -z "$1" ]; then
        echo "Usage: pa-branch <feature-name>"
        return 1
    fi
    
    BRANCH_NAME="feature/$1"
    echo "🌿 Creating feature branch: $BRANCH_NAME"
    git checkout -b "$BRANCH_NAME"
    gh issue create --title "$1" --body "Working on $1 feature" --label "feature,todo"
}

# Complete development session
pa-session() {
    if [ -z "$1" ]; then
        echo "Usage: pa-session \"Session description\""
        return 1
    fi
    
    SESSION_NUM=$(date +%H)
    echo "💪 Session $SESSION_NUM: $1"
    echo "⏰ Time: $(date)"
    
    git add .
    git commit -m "Session $SESSION_NUM: $1"
    
    # Push to trigger CI
    git push origin $(git branch --show-current)
    
    # Update GitHub issue status
    CURRENT_ISSUE=$(gh issue list --limit 1 --json | jq -r '.[0].number')
    if [ ! -z "$CURRENT_ISSUE" ]; then
        gh issue edit "$CURRENT_ISSUE" --add-label "in-progress" --remove-label "todo"
    fi
    
    echo "✅ Session $SESSION_NUM committed and pushed"
}

# Merge completed feature to sprint branch
pa-merge() {
    if [ -z "$1" ]; then
        echo "Usage: pa-merge <feature-name>"
        return 1
    fi
    
    FEATURE_BRANCH="feature/$1"
    SPRINT_BRANCH=$(git branch --show-current | grep -o 'sprint-[0-9]*' || echo "develop")
    
    echo "🔀 Merging $FEATURE_BRANCH to $SPRINT_BRANCH"
    
    # Switch to target branch
    git checkout "$SPRINT_BRANCH"
    
    # Merge feature
    git merge "$FEATURE_BRANCH" --no-ff
    
    # Push merge
    git push origin "$SPRINT_BRANCH"
    
    # Close related GitHub issue
    ISSUE_NUM=$(gh issue list --search "$1" --limit 1 --json | jq -r '.[0].number')
    if [ ! -z "$ISSUE_NUM" ]; then
        gh issue close "$ISSUE_NUM" --comment "Completed in $(git branch --show-current)"
    fi
    
    # Delete feature branch
    git push origin --delete "$FEATURE_BRANCH"
    
    echo "✅ Feature $1 merged and closed"
}

# Create sprint branch
pa-sprint() {
    if [ -z "$1" ]; then
        echo "Usage: pa-sprint <sprint-number>"
        return 1
    fi
    
    SPRINT_NUM=$1
    SPRINT_BRANCH="sprint-$SPRINT_NUM"
    
    echo "🏁 Creating sprint branch: $SPRINT_BRANCH"
    git checkout develop
    git pull origin develop
    git checkout -b "$SPRINT_BRANCH"
    
    # Create GitHub milestone if it doesn't exist
    gh milestone create "Sprint $SPRINT_NUM" --description "Sprint $SPRINT_NUM development" --due-on "$(date -d '+2 weeks' +%Y-%m-%d)"
}

# Switch between features
pa-switch() {
    if [ -z "$1" ]; then
        echo "Available branches:"
        git branch --list
        echo ""
        echo "Usage: pa-switch <branch-name>"
        return 1
    fi
    
    echo "🔄 Switching to: $1"
    git checkout "$1"
}

# Stash current work
pa-stash() {
    if [ -z "$1" ]; then
        STASH_NAME="session-$(date +%Y%m%d-%H%M%S)"
    else
        STASH_NAME="$1"
    fi
    
    echo "💾 Stashing current work as: $STASH_NAME"
    git stash push -m "$STASH_NAME"
}

# Pop last stash
pa-pop() {
    echo "📤 Popping last stash"
    git stash pop
}

# Show current status
pa-status() {
    echo "📊 Current Status"
    echo "═════════════════════════════════════"
    echo "Current Branch: $(git branch --show-current)"
    echo "Sprint: $(git branch --show-current | grep -o 'sprint-[0-9]*' || echo 'Not on sprint')"
    echo "Uncommitted Changes: $(git status --porcelain | wc -l)"
    echo "Last Commit: $(git log -1 --pretty=format:'%h - %an, %ar (%s)' --no-pager)"
    echo "═══════════════════════════════════════"
    
    # Show current GitHub issues
    echo "🐛 Current Issues:"
    gh issue list --limit 5 --state open --label "sprint-1,todo,in-progress"
}

# Quick cleanup
pa-cleanup() {
    echo "🧹 Cleaning up merged branches..."
    
    # Remove merged local branches
    git branch --merged | grep -v '\\*' | xargs git branch -d
    
    # Prune remote branches
    git remote prune origin
    
    # Show remaining branches
    echo "🌿 Remaining branches:"
    git branch --list
}

# Setup git aliases
pa-aliases() {
    echo "📝 Setting up git aliases..."
    
    git config --global alias.session '!bash -c "pa-session \"$1\""'
    git config --global alias.branch '!bash -c "pa-branch \"$1\""'
    git config --global alias.merge '!bash -c "pa-merge \"$1\""'
    git config --global alias.sprint '!bash -c "pa-sprint \"$1\""'
    git config --global alias.switch '!bash -c "pa-switch \"$1\""'
    git config --global alias.stash '!bash -c "pa-stash \"$1\""'
    git config --global alias.pop '!bash -c "pa-pop"'
    git config --global alias.status '!bash -c "pa-status"'
    git config --global alias.cleanup '!bash -c "pa-cleanup"'
    
    echo "✅ Git aliases configured!"
    echo "   git session \"commit message\""
    echo "   git branch <feature-name>"
    echo "   git merge <feature-name>"
    echo "   git sprint <number>"
    echo "   git switch <branch>"
    echo "   git stash [name]"
    echo "   git pop"
    echo "   git status"
    echo "   git cleanup"
}

# Install the functions
pa-install() {
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    echo "📥 Installing Personal Assistant git functions..."
    
    # Add to ~/.bashrc
    if ! grep -q "pa-git-functions.sh" ~/.bashrc; then
        echo "" >> ~/.bashrc
        echo "# Personal Assistant Git Functions" >> ~/.bashrc
        echo "source \"$SCRIPT_DIR/pa-git-functions.sh\"" >> ~/.bashrc
    fi
    
    # Reload shell
    echo "✅ Functions installed! Run 'source ~/.bashrc' or restart your shell."
}

# Help command
pa-help() {
    echo "🚀 Personal Assistant Git Functions"
    echo ""
    echo "Available commands:"
    echo "  pa-branch <name>     Create new feature branch"
    echo "  pa-session \"desc\"    Complete development session"
    echo "  pa-merge <name>     Merge feature to sprint"
    echo "  pa-sprint <num>      Create sprint branch"
    echo "  pa-switch <name>     Switch to branch"
    echo "  pa-stash [name]      Stash current work"
    echo "  pa-pop              Pop last stash"
    echo "  pa-status           Show current status"
    echo "  pa-cleanup          Clean up merged branches"
    echo "  pa-aliases          Configure git aliases"
    echo "  pa-install           Install functions to ~/.bashrc"
    echo "  pa-help             Show this help"
    echo ""
    echo "Installation:"
    echo "  source pa-git-functions.sh"
    echo "  pa-install"
}

# Auto-install if sourced directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    case "${1}" in
        install)
            pa-install
            ;;
        help)
            pa-help
            ;;
        *)
            pa-help
            ;;
    esac
fi