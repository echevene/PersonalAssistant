#!/bin/bash

# Create updated Sprint 2 stories for email processing and insights
gh issue create --title "Email Content Analysis" --body "## User Story
As a user, I want the system to analyze email content without storing it, So that I can get insights and action items

## Acceptance Criteria
- AI analyzes emails for content, sentiment, and key information
- System extracts action items, deadlines, and commitments
- Analysis completes within 30 seconds per email
- Processing history is maintained for insights
- Email content is not permanently stored
- User can view analysis results and confidence scores

## Technical Details
- Gemini API integration for content analysis
- Entity extraction and sentiment analysis
- Action item detection algorithms
- Temporary content processing without persistence
- Results storage in database (not original content)" --label "sprint-2,ai-processing,high-priority"

gh issue create --title "Email Prioritization" --body "## User Story
As a user, I want emails automatically prioritized based on content analysis, So that I can focus on important communications

## Acceptance Criteria
- AI assigns priority scores to emails based on content
- System identifies urgent emails requiring immediate attention
- Priorities consider sender relationship, content urgency, and deadlines
- User can review and adjust prioritization rules
- Priority scores are displayed in dashboard
- System learns from user corrections to prioritization

## Technical Details
- Priority scoring algorithm based on multiple factors
- Sender relationship analysis
- Urgency keyword detection
- User feedback integration for model improvement
- Dashboard visualization of prioritized items" --label "sprint-2,ai-processing,high-priority"

gh issue create --title "Action Items Extraction" --body "## User Story
As a user, I want action items automatically extracted from emails, So that I never miss important tasks or commitments

## Acceptance Criteria
- System extracts action items from email content
- Action items include deadlines, assignees, and context
- Extracted items are consolidated in dashboard
- User can mark items as complete or edit details
- System tracks completion status and follow-up needs
- Action items can be linked to original emails for context

## Technical Details
- Natural language processing for task extraction
- Deadline and commitment detection
- Action item categorization and grouping
- Dashboard integration with task management
- Linkage to original email references" --label "sprint-2,ai-processing,medium-priority"