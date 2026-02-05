# Personal Assistant - Project Overview

## Project Vision
Create an intelligent personal assistant that **enhances existing email apps** with AI-powered insights and automation, focusing on read-only processing, dashboard analytics, and intelligent prioritization.

## Project Goals
1. **Primary**: Simplify management of emails, calls, and appointments
2. **Secondary**: Provide AI-driven insights and automation across all communications
3. **Technical**: Create a portable architecture for future cloud deployment

## Success Metrics
- Time saved on communication management: Target 30% reduction
- Response time to communications: Target 50% improvement
- User satisfaction: Target 4.5/5 rating
- System uptime: Target 99.5% availability

## Constraints
- Android-first development with future iOS support
- Home lab deployment on Proxmox/Kubernetes
- Must integrate with existing Ceph storage
- Cloud-agnostic design for future migration

## Stakeholders
- Primary: User (project owner)
- Secondary: Development team (user as developer)
- Tertiary: Future potential users

## Project Scope
### In Scope (Phase 1)
- Multi-account email integration (Gmail, Outlook)
- AI-powered email processing with Gemini
- Flutter Android application
- n8n workflow automation
- Home lab deployment on Kubernetes

### In Scope (Future Phases)
- Call management and transcription
- Appointment scheduling and reminders
- iOS application (Phase 2)
- Cloud deployment (Phase 2)
- Additional communication channels (Slack, Teams, etc.)

### Out of Scope
- Hardware integrations (smart home, IoT)
- Voice assistant capabilities (Phase 3+)
- Multi-user support (Phase 3+)

## 🚀 Quick Start

### Repository
- **GitHub**: [https://github.com/echevene/PersonalAssistant](https://github.com/echevene/PersonalAssistant)

### Current Status
- **Issues Created**: 12 user stories across 3 sprints
- **Project Board**: [Personal Assistant Backlog](https://github.com/users/echevene/projects/3)
- **Documentation**: Complete requirements, architecture, and design
- **Next Step**: Begin Sprint 1 implementation

### Read-Only Email Processing Approach
This Personal Assistant does **not** store or replace your email app. Instead, it:
- Connects to your email accounts with **read-only access**
- Processes emails with AI to extract insights
- Delivers **dashboard, priorities, and automation**
- Enhances your existing email experience

### Sprint 1: Foundation (Updated)
13. ✅ Connect Gmail Account (Read-Only) - [Issue #13](https://github.com/echevene/PersonalAssistant/issues/13)
14. ✅ Connect Outlook Account (Read-Only) - [Issue #14](https://github.com/echevene/PersonalAssistant/issues/14)
15. ✅ Configure Processing Rules - [Issue #15](https://github.com/echevene/PersonalAssistant/issues/15)

### Sprint 2: Email Analysis & Prioritization
16. ✅ Email Content Analysis - [Issue #16](https://github.com/echevene/PersonalAssistant/issues/16)
17. ✅ Email Prioritization - [Issue #17](https://github.com/echevene/PersonalAssistant/issues/17)
18. ✅ Action Items Extraction - [Issue #18](https://github.com/echevene/PersonalAssistant/issues/18)

### Sprint 3: Dashboard & Automation
19. ✅ Insights Dashboard - [Issue #19](https://github.com/echevene/PersonalAssistant/issues/19)
20. ✅ Auto-Response Configuration - [Issue #20](https://github.com/echevene/PersonalAssistant/issues/20)
21. ✅ Meeting Scheduling Assistant - [Issue #21](https://github.com/echevene/PersonalAssistant/issues/21)
22. ✅ Contact Relationship Management - [Issue #22](https://github.com/echevene/PersonalAssistant/issues/22)

## 📚 Documentation

- [📋 Requirements](doc/requirements/requirements.md) - Functional and non-functional requirements
- [🏗️ Architecture](doc/architecture/architecture.md) - System design and component architecture
- [🎨 Design](doc/design/design.md) - Detailed component designs and interactions
- [🚀 Agile Planning](doc/agile/user_stories.md) - Epics, stories, and sprint planning
- [🗺️ Roadmap](doc/agile/roadmap.md) - Release timeline and success metrics
- [⚙️ GitHub Setup](doc/github_setup.md) - Repository configuration guide

## 🛠️ Development

### Technology Stack
- **Backend**: .NET 8 Web API with PostgreSQL (read-only email processing)
- **AI**: Google Gemini API for content analysis and insights
- **Mobile**: Flutter dashboard app (Android-first)
- **Automation**: n8n workflows for email processing
- **Infrastructure**: Kubernetes on Proxmox with Ceph storage
- **Authentication**: OAuth2 with read-only scopes

### Getting Started
1. Clone the repository: `git clone https://github.com/echevene/PersonalAssistant.git`
2. Review the [architecture documentation](doc/architecture/architecture.md)
3. Check the current sprint issues on GitHub
4. Follow the [development setup guide](doc/github_setup.md)

---

*This project follows an agile methodology with 2-week sprints. See [agile planning](doc/agile/user_stories.md) for detailed user stories.*