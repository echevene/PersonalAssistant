#!/bin/bash

# Release Automation Script
# Automates version bumping and release creation

set -e

echo "🚀 Starting release process..."

# Check if on main branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "❌ You must be on main branch to create a release"
    exit 1
fi

# Ensure working directory is clean
if [ -n "$(git status --porcelain)" ]; then
    echo "❌ Working directory is not clean. Please commit changes first."
    exit 1
fi

# Get current version
CURRENT_VERSION=$(node -p "require('./package.json').version")
echo "📦 Current version: $CURRENT_VERSION"

# Bump version
NEW_VERSION=$(npm version patch --no-git-tag-version)
echo "📦 New version: $NEW_VERSION"

# Create release notes
echo "📝 Creating release notes..."
RELEASE_NOTES="## Changes in $NEW_VERSION\n\n$(git log --pretty=format:"- %s" $(git describe --tags --abbrev=0)..HEAD)"

# Create GitHub release
echo "🌐 Creating GitHub release..."
gh release create "v$NEW_VERSION" \
    --title "Release v$NEW_VERSION" \
    --notes "$RELEASE_NOTES" \
    --target main \
    --latest

# Tag and push
echo "🏷️ Creating and pushing tag..."
git tag "v$NEW_VERSION"
git push origin "v$NEW_VERSION"

# Trigger deployment (will happen automatically via GitHub Actions)
echo "🚀 Deployment triggered via GitHub Actions"

echo ""
echo "✅ Release $NEW_VERSION created successfully!"
echo ""
echo "📊 Release available at: https://github.com/echevene/PersonalAssistant/releases/tag/v$NEW_VERSION"
echo "🚀 Check deployment status at: https://github.com/echevene/PersonalAssistant/actions"