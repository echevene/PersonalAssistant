# Personal Assistant - Project Overview

## Project Vision
Create an intelligent personal assistant that helps users manage their digital communications and schedule with AI-powered automation, accessible through cross-platform applications.

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

### Sprint 1: Foundation
1. ✅ Connect Gmail Account - [Issue #1](https://github.com/echevene/PersonalAssistant/issues/1)
2. ✅ Connect Outlook Account - [Issue #2](https://github.com/echevene/PersonalAssistant/issues/2)
3. ✅ View Connected Accounts - [Issue #3](https://github.com/echevene/PersonalAssistant/issues/3)

### Sprint 2: Email Synchronization
1. ✅ Initial Email Sync - [Issue #4](https://github.com/echevene/PersonalAssistant/issues/4)
2. ✅ Incremental Email Sync - [Issue #5](https://github.com/echevene/PersonalAssistant/issues/5)
3. ✅ Manual Sync Trigger - [Issue #6](https://github.com/echevene/PersonalAssistant/issues/6)

### Sprint 3: AI Integration & Dashboard
1. ✅ Email Categorization - [Issue #7](https://github.com/echevene/PersonalAssistant/issues/7)
2. ✅ Email Summarization - [Issue #8](https://github.com/echevene/PersonalAssistant/issues/8)
3. ✅ Smart Reply Suggestions - [Issue #9](https://github.com/echevene/PersonalAssistant/issues/9)
4. ✅ Unified Inbox View - [Issue #10](https://github.com/echevene/PersonalAssistant/issues/10)
5. ✅ Communication Search - [Issue #11](https://github.com/echevene/PersonalAssistant/issues/11)
6. ✅ Email Actions - [Issue #12](https://github.com/echevene/PersonalAssistant/issues/12)

## 📚 Documentation

- [📋 Requirements](doc/requirements/requirements.md) - Functional and non-functional requirements
- [🏗️ Architecture](doc/architecture/architecture.md) - System design and component architecture
- [🎨 Design](doc/design/design.md) - Detailed component designs and interactions
- [🚀 Agile Planning](doc/agile/user_stories.md) - Epics, stories, and sprint planning
- [🗺️ Roadmap](doc/agile/roadmap.md) - Release timeline and success metrics
- [⚙️ GitHub Setup](doc/github_setup.md) - Repository configuration guide

## 🛠️ Development

### Technology Stack
- **Backend**: .NET 8 Web API with PostgreSQL
- **AI**: Google Gemini API integration
- **Mobile**: Flutter (Android-first)
- **Automation**: n8n workflows
- **Infrastructure**: Kubernetes on Proxmox with Ceph storage
- **Authentication**: OAuth2 for email providers

### Getting Started
1. Clone the repository: `git clone https://github.com/echevene/PersonalAssistant.git`
2. Review the [architecture documentation](doc/architecture/architecture.md)
3. Check the current sprint issues on GitHub
4. Follow the [development setup guide](doc/github_setup.md)

---

*This project follows an agile methodology with 2-week sprints. See [agile planning](doc/agile/user_stories.md) for detailed user stories.*