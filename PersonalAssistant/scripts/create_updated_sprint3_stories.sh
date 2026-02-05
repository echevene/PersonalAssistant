#!/bin/bash

# Create Sprint 3 stories for dashboard and auto-response features
gh issue create --title "Insights Dashboard" --body "## User Story
As a user, I want a dashboard showing email insights and trends, So that I can understand my communication patterns

## Acceptance Criteria
- Dashboard displays email statistics and trends
- Visual representation of email categories and volume
- Prioritized list of important emails and action items
- Search across processed email metadata
- Performance remains responsive with 1000+ emails in history
- Dashboard updates in real-time with new insights

## Technical Details
- Data visualization using Flutter charts
- Real-time dashboard updates
- Search functionality across metadata
- Responsive design for mobile
- Cached data for offline viewing" --label "sprint-3,dashboard,high-priority"

gh issue create --title "Auto-Response Configuration" --body "## User Story
As a user, I want to configure auto-response rules for certain email types, So that I can automate routine communications

## Acceptance Criteria
- User can define auto-response rules for specific email types
- System identifies emails matching auto-response criteria
- AI generates appropriate responses based on email content
- User reviews and confirms all auto-responses before sending
- Auto-responses maintain appropriate tone and context
- System learns from user approval/rejection patterns

## Technical Details
- Rule engine for email pattern matching
- Template-based response generation
- User confirmation workflow
- Machine learning for response improvement
- Response preview and editing interface" --label "sprint-3,auto-response,high-priority"

gh issue create --title "Meeting Scheduling Assistant" --body "## User Story
As a user, I want the system to schedule meetings based on email content, So that I can automate calendar management

## Acceptance Criteria
- AI extracts meeting details from email content
- System suggests optimal meeting times based on calendar
- User confirms meeting invitations before sending
- Calendar integration for conflict checking
- Follow-up reminders scheduled automatically
- User can modify suggested details before confirmation

## Technical Details
- Calendar API integration (Google/Outlook)
- Meeting detail extraction from natural language
- Conflict detection and resolution
- Invitation generation and sending
- Follow-up reminder system" --label "sprint-3,scheduling,medium-priority"

gh issue create --title "Contact Relationship Management" --body "## User Story
As a user, I want to track contact relationships and communication patterns, So that I can understand my professional network

## Acceptance Criteria
- AI identifies and categorizes contact relationships
- Relationship strength calculated from communication patterns
- Contact importance scores displayed in dashboard
- Communication history summarized per contact
- User can add relationship notes and tags
- Network visualization available for key contacts

## Technical Details
- Contact analysis algorithms
- Relationship strength calculations
- Network graph generation
- Contact metadata storage (not content)
- Privacy controls for relationship data" --label "sprint-3,contacts,medium-priority"