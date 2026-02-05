#!/bin/bash

# Create micro-stories for Sprint 1 that can be completed in 1-2 hour sessions

# Session 1: Project Structure (2 hours)
gh issue create --title "Create .NET 8 API Project Structure" --body "## Micro-Story (2 hours)
Create the basic .NET 8 Web API project structure with minimal functionality.

## Acceptance Criteria
- [ ] .NET 8 Web API project created
- [ ] Basic project structure with folders (Controllers, Services, Models)
- [ ] Health check endpoint (/health) implemented
- [ ] GitHub Actions CI workflow created
- [ ] Project pushes to repository successfully

## Definition of Done
- Code committed and pushed to GitHub
- CI pipeline runs successfully
- Basic project documentation updated" --label "sprint-1,infrastructure,low-effort"

# Session 2: Database Setup (2 hours)
gh issue create --title "Set Up PostgreSQL Schema for Metadata" --body "## Micro-Story (2 hours)
Create basic PostgreSQL schema for storing email processing metadata (not content).

## Acceptance Criteria
- [ ] PostgreSQL database created for development
- [ ] Entity Framework Core configured
- [ ] Email metadata model created (no content storage)
- [ ] Basic migration script created
- [ ] Connection string configured in development

## Definition of Done
- Database accessible from API project
- Migration scripts committed to repository
- Development environment documentation updated" --label "sprint-1,database,low-effort"

# Session 3: Basic Authentication (1 hour)
gh issue create --title "Implement Basic JWT Authentication" --body "## Micro-Story (1 hour)
Set up basic JWT authentication structure for API endpoints.

## Acceptance Criteria
- [ ] JWT service created for token generation
- [ ] Authentication middleware added
- [ ] Basic login endpoint implemented
- [ ] Token validation working
- [ ] Configuration for JWT settings

## Definition of Done
- Authentication endpoints working with test tokens
- Middleware properly validates requests
- Basic security configuration documented" --label "sprint-1,authentication,low-effort"