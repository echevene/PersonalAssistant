# Branching Strategy for 5 Hours/Week Development

## Overview

For a developer with limited time, the branching strategy must **minimize context switching, maximize automation, and enable parallel work without complexity**. This strategy ensures your 5 hours go entirely to feature development.

## 🎯 Branching Model: Simplified GitHub Flow

```
main (production)
├── develop (integration)
├── feature/read-only-integration
├── feature/email-analysis
├── feature/action-items
└── feature/dashboard
```

## 🌳 Branch Types & Purpose

### main Branch
- **Purpose**: Production-ready code
- **Protection**: Require PR reviews and passing CI
- **Automated**: Direct deployment to production
- **Frequency**: Updated only via PR merges

### develop Branch
- **Purpose**: Integration of all features
- **Automated**: Daily deployment to staging
- **Frequency**: Merged from feature branches
- **Protection**: Require passing CI checks

### Feature Branches
- **Purpose**: Single user story or micro-feature
- **Naming**: `feature/<story-name>` or `sprint-1/<task-name>`
- **Lifespan**: Created → Developed → Merged → Deleted
- **Strategy**: One feature per branch, tiny scope

## 📅 Sprint-Based Branching

### Sprint Branches
For each sprint, we create **temporary sprint branches** to group related work:

```
sprint-1 (main development branch for Sprint 1)
├── feature/project-structure
├── feature/database-setup
└── feature/basic-auth
```

### Sprint Workflow
```bash
# Start of Sprint 1
git checkout -b sprint-1 develop
git checkout -b feature/project-structure sprint-1

# Work on micro-stories
# Session 1: feature/project-structure
# Session 2: feature/database-setup
# Session 3: feature/basic-auth

# Merge to sprint branch
git checkout sprint-1
git merge feature/project-structure
git merge feature/database-setup
git merge feature/basic-auth

# Merge to develop when Sprint complete
git checkout develop
git merge sprint-1

# Delete sprint branch
git branch -d sprint-1
```

## 🔄 Automated Branch Management

### GitHub Actions for Branch Management
```yaml
# .github/workflows/branch-management.yml
name: Branch Management

on:
  pull_request:
    types: [opened, closed]
    
jobs:
  cleanup-branches:
    if: github.event.pull_request.merged == true
    runs-on: ubuntu-latest
    steps:
      - name: Delete merged feature branch
        run: |
          BRANCH=${{ github.event.pull_request.head.ref }}
          if [[ "$BRANCH" == feature/* ]]; then
            git push origin --delete $BRANCH
          fi
```

## 📋 Development Commands

### Daily Workflow (5 hours/week)
```bash
# Start of development session
git checkout feature/current-task

# Work for 1-2 hours
# Commit frequently with descriptive messages
git add .
git commit -m "Session 1: Implement basic JWT authentication"

# End of session - push for CI/backup
git push origin feature/current-task
```

### Weekly Workflow
```bash
# Monday morning - Plan week
gh issue list --label "sprint-1,todo"

# During week - Work on features
# Each session picks up where left off

# Friday evening - Review and merge
git checkout develop
git merge feature/task-1
git merge feature/task-2
git push origin develop
```

## 🎯 Branch Protection Rules

### main Branch
```yaml
# GitHub branch protection settings
main:
  required_status_checks:
    strict: true
    contexts: ["backend-ci", "mobile-ci", "codeql-analysis"]
  enforce_admins: true
  required_pull_request_reviews:
    required_approving_review_count: 1
    dismiss_stale_reviews: true
    require_code_owner_reviews: false
```

### develop Branch
```yaml
# GitHub branch protection settings
develop:
  required_status_checks:
    strict: true
    contexts: ["backend-ci", "mobile-ci"]
  enforce_admins: false
  required_pull_request_reviews: false
```

## 🚀 Release Workflow

### Automated Releases
```bash
# From main branch only
git checkout main
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0

# GitHub Actions handle the rest
# Automatic deployment to production
# Release notes generation
```

## 📊 Time-Saving Features

### Parallel Development Support
```bash
# If one feature is blocked, switch to another
git checkout feature/next-task

# Stash changes if needed
git stash push -m "WIP on current feature"
git checkout feature/next-task
# Work on next feature...
git checkout feature/previous-task
git stash pop
```

### Smart Rebase Strategy
```bash
# Keep feature branches up to date
git checkout feature/current-task
git fetch origin
git rebase origin/develop

# Automate with GitHub Actions when possible
```

## 📝 Commit Message Standards

### Session-Based Commits
```
Session 1: Create .NET 8 project structure
Session 2: Set up PostgreSQL schema
Session 3: Implement basic JWT authentication
```

### Feature Completion
```
feat: Add Gmail read-only integration
fix: Resolve authentication token refresh issue
docs: Update API documentation
```

## 🔧 Git Configuration

### Aliases for Efficiency
```bash
# Add to ~/.gitconfig
[alias]
    session-start = "!bash -c 'git checkout -b feature/$(date +%Y%m%d-%H%M%S)'"
    session-commit = "!bash -c 'git add . && git commit -m \"Session $(date +%H): $1\"'"
    session-done = "!bash -c 'git push origin $(git branch --show-current)'"
    cleanup = "!git branch --merged | grep -v '\\*' | xargs git branch -d"
```

### Useful Bash Functions
```bash
# Add to ~/.bashrc
pa-branch() {
    git checkout -b feature/$1
}

pa-session() {
    git add .
    git commit -m "Session $(date +%H): $1"
    git push origin $(git branch --show-current)
}

pa-merge() {
    git checkout develop
    git merge feature/$1
    git push origin develop
    git branch -d feature/$1
}
```

## 📱 Mobile App Branching

### Flutter Feature Branches
```bash
# Feature development
flutter create --org-name com.personalassistant feature/email-analysis
cd feature/email-analysis
# Work on feature...
flutter test
flutter build apk
```

### Release Branching for Mobile
```bash
# Release preparation
git checkout -b release/v1.0.0
# Bump version numbers
# Update changelog
# Build and test
flutter build apk --release
# Tag release
git tag -a v1.0.0
git push origin v1.0.0
git push origin release/v1.0.0
```

## 🎯 Sprint Branch Strategy for 5 Hours/Week

### Pre-Sprint Setup
```bash
# Before each sprint
git checkout develop
git pull origin develop
git checkout -b sprint-2

# Create feature branches from sprint branch
git checkout -b sprint-2/email-analysis sprint-2
git checkout -b sprint-2/prioritization sprint-2
git checkout -b sprint-2/action-items sprint-2
```

### In-Sprint Management
```bash
# Track time spent per feature
# Use GitHub issues to track session progress

# Merge completed features to sprint branch
git checkout sprint-2
git merge sprint-2/email-analysis
git push origin sprint-2

# PR sprint branch to develop when complete
gh pr create --base develop --head sprint-2 --title "Sprint 2: Email Analysis Features"
```

## 📋 Branch Cleanup Strategy

### Automated Cleanup
```yaml
# .github/workflows/cleanup.yml
name: Branch Cleanup

on:
  schedule:
    - cron: "0 6 * * 1"  # Weekly cleanup
    
jobs:
  cleanup:
    runs-on: ubuntu-latest
    steps:
      - name: Delete merged branches
        run: |
          git branch --merged | grep -v '\\*' | xargs git branch -d
          
      - name: Delete stale branches
        run: |
          # Delete branches older than 30 days with no activity
          git branch -r --sort=committerdate | awk 'NR>10 {print $1}' | xargs -r git push origin --delete
```

### Manual Cleanup Commands
```bash
# Quick cleanup utility
git-cleanup() {
    # Delete merged local branches
    git branch --merged | grep -v '\\*' | xargs git branch -d
    
    # Delete stale remote branches
    git remote prune origin
    
    # Show remaining branches
    git branch -a
}
```

## 🔍 Branch Status Tracking

### GitHub Project Board Integration
- Feature branches linked to issues
- Sprint branches show progress on Kanban board
- Automated branch status updates

### Dashboard for Branch Overview
```bash
# Script to show current branch status
pa-status() {
    echo "Current Branch: $(git branch --show-current)"
    echo "Sprint: $(git branch --show-current | grep -o 'sprint-[0-9]*' || echo 'None')"
    echo "Unmerged Features:"
    git branch --no-merged | grep 'feature/'
}
```

## 🎯 Benefits for 5 Hours/Week

### Time Savings
- **No context switching** - One feature per branch
- **Parallel work possible** - Multiple features in parallel branches
- **Minimal merging conflicts** - Small, focused branches
- **Automated cleanup** - No manual branch management overhead

### Risk Mitigation
- **Feature isolation** - Broken code affects only one feature
- **Easy rollbacks** - Revert individual features
- **Clear history** - Meaningful commit messages
- **Parallel testing** - Test features independently

## 📞 Branch Management Commands

### Quick Reference
```bash
# Start new feature
pa-branch feature-name

# Complete session
pa-session "implement JWT validation"

# Merge completed feature
pa-merge feature-name

# Switch between features
git checkout feature/other-feature

# Stash current work
git stash push -m "session incomplete"

# Cleanup merged branches
pa-cleanup
```

## 🔄 Recommended Workflow

### Weekly Rhythm (5 hours/week)
1. **Monday**: Review current sprint, create missing feature branches
2. **Tuesday-Thursday**: 1-2 hour sessions on current feature branch
3. **Friday**: Complete current features, merge to sprint branch
4. **Weekend**: Automated testing and deployment (via CI/CD)

### Daily Session (1-2 hours)
1. **Start**: `pa-branch feature-name`
2. **Work**: Focus on one micro-story
3. **Commit**: `pa-session "task description"`
4. **Push**: Automatic CI testing begins
5. **Repeat**: Next session continues where left off

This branching strategy maximizes your 5 hours/week by minimizing overhead and enabling focused, parallel feature development.