# Technical Architecture

## System Overview

The Personal Assistant consists of multiple components working together to provide intelligent communication management:

```
┌─────────────────────────────────────────────────────────────────┐
│                        Client Layer                           │
├─────────────────────┬─────────────────────┬───────────────────┤
│  Flutter Android   │  Future: Flutter    │  Future: Web      │
│     Application    │     iOS/Desktop     │   Application      │
└─────────────────────┴─────────────────────┴───────────────────┘
                              │
                         HTTPS/REST
                              │
┌─────────────────────────────────────────────────────────────────┐
│                      API Gateway                               │
│                  (Traefik Ingress)                             │
└─────────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────────┐
│                    Service Layer                               │
├───────────────┬─────────────────┬──────────────────────────────┤
│  .NET 8 API    │  Authentication │      n8n Workflows         │
│  (Core Logic)  │    Service      │    (Automation Engine)     │
└───────────────┴─────────────────┴──────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────────┐
│                    External Services                           │
├───────────────┬─────────────────┬──────────────────────────────┤
│   Gmail API    │  Microsoft      │       Gemini AI             │
│                │   Graph API     │                             │
│   Call API     │  Calendar API   │                             │
└───────────────┴─────────────────┴──────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────────┐
│                    Data Layer                                  │
├───────────────┬─────────────────┬──────────────────────────────┤
│  PostgreSQL    │     Redis        │       Ceph Storage         │
│   (Primary)    │    (Cache)       │     (Backups/Archive)      │
└───────────────┴─────────────────┴──────────────────────────────┘
```

## Component Architecture

### 1. Client Layer (Flutter Application)

**Technology Stack:**
- Flutter 3.x with Dart
- Material Design 3 components
- Provider/Riverpod for state management
- Dio for HTTP communications
- SQLite for local storage
- WorkManager for background tasks

**Key Responsibilities:**
- User interface and experience
- Local data caching and offline support
- Authentication token management
- Background synchronization
- Push notifications

**Architecture Pattern:**
```
flutter_app/
├── lib/
│   ├── core/           # Shared utilities, constants
│   ├── data/           # Data sources, repositories
│   ├── domain/         # Business entities, use cases
│   ├── presentation/   # UI components, screens
│   └── services/       # External services integration
```

### 2. API Gateway (Traefik)

**Configuration:**
- SSL termination with Let's Encrypt
- Path-based routing
- Rate limiting
- Request authentication
- Circuit breaker pattern

**Routing Rules:**
```
/api/* -> .NET API Service
/workflows/* -> n8n Service
/auth/* -> Authentication Service
/static/* -> Static Assets
```

### 3. Service Layer

#### 3.1 .NET 8 Web API

**Architecture:**
```
PersonalAssistant.Api/
├── Controllers/       # API endpoints
├── Services/         # Business logic
├── Repositories/     # Data access
├── Models/          # Data models
├── Configuration/    # App settings
└── Middleware/      # Request processing
```

**Key Services:**
- EmailAccountService: Account management
- EmailFetchService: Email synchronization
- AIProcessingService: Gemini integration
- NotificationService: Push notifications
- CacheService: Redis integration
- CallService: Future call management
- CalendarService: Future appointment management

#### 3.2 Authentication Service

**Features:**
- OAuth2 flow management
- JWT token generation/validation
- User session management
- API key rotation
- Multi-provider authentication

#### 3.3 n8n Workflow Engine

**Workflow Examples:**
1. Email Sync Workflow:
   ```
   [Schedule Trigger] → [Gmail Node] → [Category AI Node] → [Database Node]
   ```

2. Smart Reply Workflow:
   ```
   [API Trigger] → [Email Data Node] → [Gemini Node] → [Response API Node]
   ```

3. Call Processing Workflow (Future):
   ```
   [Webhook Trigger] → [Call Recording Node] → [Transcription AI Node] → [Database Node]
   ```

**Custom Nodes:**
- Gemini AI Processing Node
- Email Categorization Node
- Database Integration Node
- Call Transcription Node (Future)

### 4. Data Layer

#### 4.1 PostgreSQL Schema

```sql
-- Users and Authentication
users (id, email, created_at, updated_at)
email_accounts (id, user_id, provider, refresh_token, is_active)

-- Email Data
emails (id, account_id, message_id, thread_id, subject, 
        sender, recipients, date_received, is_read, 
        is_starred, category_id, ai_summary, ai_category)

-- Categories and Labels
categories (id, user_id, name, color, is_system)
email_labels (email_id, category_id)

-- AI Processing Data
ai_processing_log (id, email_id, processing_type, 
                   result, confidence, created_at)

-- Call Data (Future)
calls (id, user_id, phone_number, duration, recording_url, 
       transcription, summary, ai_processed)

-- Appointment Data (Future)
appointments (id, user_id, title, start_time, end_time, 
              location, attendees, reminders, provider_id)
```

#### 4.2 Redis Caching Strategy

```
User Sessions:       "session:{user_id}"          (TTL: 24h)
Email Cache:         "email:{account_id}:{page}"  (TTL: 1h)
API Rate Limits:     "ratelimit:{user_id}:{type}" (TTL: 1h)
AI Results:          "ai:{email_id}"             (TTL: 7d)
Call Cache:          "call:{user_id}:{date}"     (TTL: 30d) (Future)
```

#### 4.3 Ceph Storage Strategy

```
Daily Backups:       "backups/daily/{date}/"
Weekly Archives:     "archives/weekly/{week}/"
User Exports:        "exports/user_{user_id}/"
System Logs:         "logs/{app}/{date}/"
Call Recordings:     "recordings/{user_id}/{date}/" (Future)
```

## Security Architecture

### 1. Authentication Flow
```
[Flutter App] → [OAuth2 Provider] → [Access Token] → [JWT] → [API Access]
```

### 2. Data Encryption
- TLS 1.3 for all network communications
- AES-256 for data at rest
- Encrypted secrets management
- API key rotation policies

### 3. Access Control
- Role-based access control (RBAC)
- API scope limitations
- Request rate limiting
- IP whitelisting for admin

## Deployment Architecture

### Kubernetes Configuration

```yaml
# Namespace Configuration
apiVersion: v1
kind: Namespace
metadata:
  name: personal-assistant
  labels:
    name: personal-assistant

# Storage Classes
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: longhorn-fast
provisioner: driver.longhorn.io
parameters:
  numberOfReplicas: "3"
  staleReplicaTimeout: "30"
```

### Service Dependencies

```yaml
# .NET API Service
apiVersion: apps/v1
kind: Deployment
metadata:
  name: personal-assistant-api
spec:
  replicas: 2
  selector:
    matchLabels:
      app: personal-assistant-api
  template:
    metadata:
      labels:
        app: personal-assistant-api
    spec:
      containers:
      - name: api
        image: personal-assistant/api:latest
        ports:
        - containerPort: 80
        env:
        - name: ConnectionStrings__DefaultConnection
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: connection-string
```

## Monitoring and Observability

### 1. Application Metrics
- API response times
- Email sync success rates
- AI processing latency
- User session metrics

### 2. Infrastructure Metrics
- Kubernetes resource utilization
- Database performance
- Ceph storage status
- Network traffic patterns

### 3. Logging Strategy
- Structured logging with correlation IDs
- Log aggregation to central system
- Log retention policies
- Security event logging

## Performance Considerations

### 1. Caching Strategy
- Multi-level caching (client, API, database)
- Cache invalidation patterns
- Predictive caching for user behavior

### 2. Database Optimization
- Query optimization with proper indexing
- Connection pooling
- Read replicas for scale
- Query result caching

### 3. API Optimization
- Response compression
- Pagination for large datasets
- GraphQL for efficient data fetching
- API response caching

## Future Architecture Considerations

### 1. Call Management
- Real-time audio processing pipeline
- Integration with telephony providers
- Speech-to-text service integration

### 2. Appointment Management
- Calendar synchronization mechanisms
- Conflict resolution algorithms
- Reminder delivery system

### 3. Scaling Considerations
- Multi-tenant architecture
- Regional deployment for latency
- Service mesh for inter-service communication