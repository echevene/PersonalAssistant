#!/bin/bash

# Create Sprint 3 stories for AI Integration & Dashboard
gh issue create --title "Email Categorization" --body "## User Story
As a user, I want to have my emails automatically categorized, So that I can better organize my inbox

## Acceptance Criteria
- AI categorizes emails into predefined categories
- Categories include: Primary, Social, Promotions, Updates, Forums
- User can see AI confidence score
- User can correct miscategorized emails
- System learns from user corrections

## Technical Details
- Integration with Gemini API
- Category training and feedback loop
- Performance optimization for batch processing" --label "sprint-3,ai-processing,high-priority"

gh issue create --title "Email Summarization" --body "## User Story
As a user, I want to receive summaries of long email threads, So that I can quickly understand long conversations

## Acceptance Criteria
- AI generates summaries for threads with 5+ emails
- Summary includes key points and action items
- Summary appears in email list view
- Full thread accessible with single tap
- User can request custom summary length" --label "sprint-3,ai-processing,medium-priority"

gh issue create --title "Smart Reply Suggestions" --body "## User Story
As a user, I want to receive smart reply suggestions, So that I can respond to emails faster

## Acceptance Criteria
- AI generates 2-3 reply suggestions based on email content
- Suggestions maintain appropriate tone and context
- One-tap acceptance of suggestion
- User can edit suggestion before sending
- System learns from which suggestions are used" --label "sprint-3,ai-processing,medium-priority"

gh issue create --title "Unified Inbox View" --body "## User Story
As a user, I want to see all my emails in one unified inbox, So that I don't need to switch between accounts

## Acceptance Criteria
- Unified inbox shows emails from all connected accounts
- Each email clearly shows source account
- Default sort by date (newest first)
- User can filter by account
- Performance remains responsive with 1000+ emails" --label "sprint-3,high-priority"

gh issue create --title "Communication Search" --body "## User Story
As a user, I want to search across all my communications, So that I can quickly find specific information

## Acceptance Criteria
- Search works across all connected accounts
- Search includes sender, subject, and content
- Results show relevance score
- Advanced filters available (date range, sender, account)
- Search completes within 2 seconds
- Future: Search includes call transcripts and appointment details" --label "sprint-3,medium-priority"

gh issue create --title "Email Actions" --body "## User Story
As a user, I want to perform standard email actions, So that I can manage my emails effectively

## Acceptance Criteria
- Mark as read/unread functionality
- Star/unstar functionality
- Archive functionality
- Delete functionality
- Actions sync back to original email provider" --label "sprint-3,medium-priority"