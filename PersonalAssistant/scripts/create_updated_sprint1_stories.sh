#!/bin/bash

# Create updated Sprint 1 stories for read-only email processing approach
gh issue create --title "Connect Gmail Account (Read-Only)" --body "## User Story
As a user, I want to connect my Gmail account with read-only access, So that the assistant can analyze my emails without storing them

## Acceptance Criteria
- User can initiate Gmail OAuth flow with read-only scope
- User can grant necessary permissions (no compose/delete access)
- Account appears in connected accounts list
- System can read emails from connected account
- User can disconnect the account at any time
- System clearly indicates no email content is stored permanently

## Technical Details
- OAuth2 with Google Sign-In using read-only scopes
- Gmail API access with GmailReadonly scope
- Refresh token storage
- Account state management
- Temporary processing of email content without persistent storage" --label "sprint-1,email-connectivity,high-priority"

gh issue create --title "Connect Outlook Account (Read-Only)" --body "## User Story
As a user, I want to connect my Outlook account with read-only access, So that the assistant can analyze my emails without storing them

## Acceptance Criteria
- User can initiate Outlook OAuth flow with read-only scope
- User can grant necessary permissions (no compose/delete access)
- Account appears in connected accounts list
- System can read emails from connected account
- User can disconnect the account at any time
- System clearly indicates no email content is stored permanently

## Technical Details
- OAuth2 with Microsoft Graph using read-only scopes
- Refresh token storage
- Account state management
- Temporary processing of email content without persistent storage" --label "sprint-1,email-connectivity,high-priority"

gh issue create --title "Configure Processing Rules" --body "## User Story
As a user, I want to configure how my emails are processed, So that I can customize the AI analysis and insights

## Acceptance Criteria
- User can define which email categories to track
- User can set processing frequency
- User can exclude certain senders from processing
- User can customize action item extraction rules
- User can configure privacy settings for content processing
- Settings can be updated at any time

## Technical Details
- Configuration API for processing rules
- User preference storage
- Rule validation and error handling
- Real-time rule application updates" --label "sprint-1,medium-priority"