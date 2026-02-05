# GitHub Setup Guide for Personal Assistant

This guide explains how to set up your GitHub repository and import the user stories for your Personal Assistant project.

## Step 1: Create GitHub Repository

### Option A: Using GitHub CLI (if installed)
```bash
# Create a new repository on GitHub
gh repo create PersonalAssistant --public --source=. --remote=origin --push

# Or for a private repository
gh repo create PersonalAssistant --private --source=. --remote=origin --push
```

### Option B: Using GitHub Web Interface
1. Go to https://github.com and sign in
2. Click the "+" icon in the top right and select "New repository"
3. Repository name: "PersonalAssistant"
4. Description: "Intelligent personal assistant for managing emails, calls, and appointments"
5. Choose Public or Private
6. Don't initialize with README (we already have one)
7. Click "Create repository"
8. Follow the instructions to push an existing repository:
   ```bash
   git remote add origin https://github.com/YourUsername/PersonalAssistant.git
   git branch -M main
   git push -u origin main
   ```

## Step 2: Configure GitHub Projects

### Create GitHub Project Board
1. In your repository, go to "Projects" tab
2. Click "New project"
3. Choose "Project board"
4. Name: "Personal Assistant Backlog"
5. Select "Blank template"
6. Click "Create"

### Set Up Project Columns
Add columns for your workflow:
- Backlog
- Sprint X (current sprint)
- In Progress
- In Review
- Done

## Step 3: Import User Stories

### Option A: Create Issues Individually
1. Go to "Issues" tab in your repository
2. Click "New issue"
3. Use templates from `doc/agile/github_issues_import.md`
4. Assign appropriate labels (see below)
5. Add to current sprint milestone

### Option B: Bulk Import (Advanced)
If you have GitHub CLI with extended permissions:
```bash
# Install GitHub CLI if not already installed
# Then run commands from the import template file

# Example for first story
gh issue create \
  --title "Connect Gmail Account" \
  --body "As a user, I want to connect my Gmail account, So that I can manage my Gmail emails through the application

## Acceptance Criteria
- User can initiate Gmail OAuth flow
- User can grant necessary permissions
- Account appears in connected accounts list
- System can fetch emails from connected account
- User can disconnect the account

## Technical Details
- OAuth2 with Google Sign-In
- Refresh token storage
- Account state management" \
  --label "sprint-1,email-connectivity,high-priority"
```

## Step 4: Set Up Labels

### Create Label Categories
In your repository settings > Labels, create these labels:

#### Priority Labels
- `high-priority` (Red)
- `medium-priority` (Yellow)
- `low-priority` (Green)

#### Epic Labels
- `email-connectivity` (Blue)
- `email-sync` (Blue)
- `ai-processing` (Purple)
- `mobile` (Orange)
- `offline` (Gray)
- `call-management` (Teal)
- `appointment-management` (Pink)

#### Sprint Labels
- `sprint-1`
- `sprint-2`
- `sprint-3`
- `sprint-4`
- `sprint-5`
- `future`

#### Component Labels
- `api` (Dark Blue)
- `ui` (Light Blue)
- `database` (Brown)
- `testing` (Green)

## Step 5: Set Up Milestones

Create milestones for each sprint:
1. Go to "Issues" > "Milestones"
2. Click "New milestone"
3. Create for each sprint:
   - Sprint 1: Foundation (2 weeks)
   - Sprint 2: Email Synchronization (2 weeks)
   - Sprint 3: AI Integration & Dashboard (2 weeks)
   - Sprint 4: Mobile Application (2 weeks)
   - Sprint 5: Offline Functionality (2 weeks)
   - Future: Call Management (2 weeks)
   - Future: Appointment Management (2 weeks)

## Step 6: Configure Automations (Optional)

### Set Up Branch Protection
1. Go to Settings > Branches
2. Add branch protection rule for main branch
3. Require pull request reviews
4. Require status checks to pass
5. Include administrators in requirements

### Set Up Issue Templates
Create issue templates based on your user stories:
1. Go to Settings > Issues > Templates
2. Create templates for:
   - Bug report
   - Feature request
   - Epic
   - Spike (research task)

## Step 7: Invite Collaborators

1. Go to Settings > Manage access
2. Click "Invite a collaborator"
3. Add team members as needed
4. Assign appropriate permissions

## Step 8: Set Up CI/CD (GitHub Actions)

Create `.github/workflows/` directory for automation:
```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up .NET Core
        uses: actions/setup-dotnet@v1
        with:
          dotnet-version: 8.0.x
      - name: Build
        run: dotnet build
      - name: Test
        run: dotnet test
```

## Step 9: Configure Project Links

1. Go to repository Settings > Features
2. Enable Projects if not already enabled
3. Link issues to project boards for tracking
4. Configure issue linking for dependencies

## Step 10: Documentation

1. Enable GitHub Pages if you want to host documentation
2. Configure README.md as the main page
3. Add links to your documentation in the repository
4. Consider using GitHub's built-in wiki for additional documentation

## Azure DevOps Alternative

If you prefer Azure DevOps instead:

1. **Create Project:**
   - Go to Azure DevOps
   - Create new organization or use existing
   - Create new project: "Personal Assistant"

2. **Import Repository:**
   - Use Git import feature
   - Enter your GitHub repository URL

3. **Set Up Boards:**
   - Go to Boards
   - Create new board based on Agile template
   - Import user stories as work items

4. **Configure Pipelines:**
   - Create build pipeline
   - Link to GitHub repository
   - Set up CI/CD process

## Next Steps

Once your repository is set up:

1. **Start Sprint 1:** Begin working on email account connectivity
2. **Daily Standups:** Use GitHub discussions or your preferred tool
3. **Sprint Reviews:** Create releases for each completed sprint
4. **Documentation Updates:** Keep docs in sync with code changes

## Useful Links

- [GitHub Documentation](https://docs.github.com/)
- [GitHub Projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
- [GitHub Actions](https://docs.github.com/en/actions)
- [GitHub CLI Documentation](https://cli.github.com/manual/)

Would you like me to help with any specific part of this setup process?