#!/bin/bash

# Create Sprint 2 stories first
gh issue create --title "Initial Email Sync" --body "## User Story
As a user, I want to perform an initial synchronization of my emails, So that I can see my emails in the application

## Acceptance Criteria
- Initial sync downloads all emails from past 30 days
- Progress indicator shows sync progress
- Sync completes in reasonable time for 10,000 emails
- Email metadata is stored in local database
- User receives notification when sync completes

## Technical Details
- Batch processing for large email volumes
- Progress tracking and reporting
- Error handling for failed emails" --label "sprint-2,email-sync,high-priority"

gh issue create --title "Incremental Email Sync" --body "## User Story
As a user, I want to receive new emails automatically, So that my inbox is always up-to-date

## Acceptance Criteria
- New emails appear within 5 minutes of arrival
- System checks for new emails every 5 minutes
- Push notification received for important emails
- Sync works when app is in background
- Sync logs are available for troubleshooting" --label "sprint-2,email-sync,high-priority"

gh issue create --title "Manual Sync Trigger" --body "## User Story
As a user, I want to manually trigger email synchronization, So that I can refresh my inbox on demand

## Acceptance Criteria
- Pull-to-refresh gesture triggers sync
- Manual sync button available in settings
- Visual feedback shows sync is in progress
- User receives notification when manual sync completes" --label "sprint-2,email-sync,medium-priority"