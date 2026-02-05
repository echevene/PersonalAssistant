# System Design Documentation

## 1. Component Design Details

### 1.1 Flutter Application Design

#### Screen Hierarchy
```
PersonalAssistantApp
├── SplashScreen
├── AuthenticationFlow
│   ├── LoginScreen
│   ├── AccountSetupScreen
│   └── PermissionsScreen
├── MainNavigation
│   ├── InboxScreen
│   ├── CallsScreen (Future)
│   ├── AppointmentsScreen (Future)
│   └── SettingsScreen
├── EmailDetailFlow
│   ├── EmailDetailScreen
│   ├── ComposeScreen
│   └── ReplyScreen
├── CallDetailFlow (Future)
│   ├── CallHistoryScreen
│   ├── CallDetailScreen
│   └── CallRecordingScreen
├── AppointmentFlow (Future)
│   ├── CalendarScreen
│   ├── AppointmentDetailScreen
│   └── ScheduleScreen
└── OnboardingFlow
    ├── WelcomeScreen
    ├── FeaturesScreen
    └── PermissionsRequestScreen
```

#### State Management Pattern
```
Provider Hierarchy:
ChangeNotifierProvider<AuthNotifier>
ChangeNotifierProvider<EmailNotifier>
ChangeNotifierProvider<SettingsNotifier>
ChangeNotifierProvider<AIPreferencesNotifier>
ChangeNotifierProvider<CallNotifier> (Future)
ChangeNotifierProvider<CalendarNotifier> (Future)
```

#### Data Flow in Flutter
```
UI Event → Action → Repository → API → State Update → UI Rebuild
```

### 1.2 .NET API Design

#### Controller Structure
```
Controllers/
├── AuthController.cs          // Authentication endpoints
├── AccountController.cs       // Email account management
├── EmailController.cs         // Email CRUD operations
├── CategoryController.cs      // Category management
├── AIController.cs           // AI processing endpoints
├── AnalyticsController.cs    // Usage analytics
├── CallController.cs        // Call management (Future)
└── AppointmentController.cs // Appointment management (Future)
```

#### Service Layer Design
```
Services/
├── IEmailService.cs          // Email operations interface
├── EmailService.cs          // Email operations implementation
├── IAIProcessingService.cs   // AI interface
├── AIProcessingService.cs   // AI implementation
├── ICacheService.cs         // Caching interface
├── CacheService.cs          // Redis implementation
├── INotificationService.cs  // Push notifications
├── NotificationService.cs   // FCM/Android implementation
├── ICallService.cs         // Call operations (Future)
├── CallService.cs          // Call implementation (Future)
├── ICalendarService.cs     // Calendar operations (Future)
└── CalendarService.cs      // Calendar implementation (Future)
```

#### Repository Pattern Implementation
```
Repositories/
├── IEmailRepository.cs       // Data access interface
├── EmailRepository.cs       // PostgreSQL implementation
├── IUserRepository.cs       // User data interface
├── UserRepository.cs         // User data implementation
├── IAIResultRepository.cs   // AI results interface
├── AIResultRepository.cs    // AI results implementation
├── ICallRepository.cs      // Call data (Future)
├── CallRepository.cs       // Call implementation (Future)
├── IAppointmentRepository.cs // Appointment data (Future)
└── AppointmentRepository.cs  // Appointment implementation (Future)
```

### 1.3 n8n Workflow Design

#### Email Synchronization Workflow
```
Trigger: Schedule (every 5 minutes)
├── Get all active email accounts
├── For each account:
│   ├── Check last sync timestamp
│   ├── Fetch new emails via provider API
│   ├── Process emails through AI categorization
│   ├── Store results in database
│   └── Update sync timestamp
└── Send summary notification
```

#### AI Processing Workflow
```
Trigger: Webhook from API
├── Receive communication data
├── Categorize communication (Primary/Secondary/Promotional)
├── Generate summary (if long thread/recording)
├── Suggest smart replies/actions
├── Store AI results
└── Return processed data via webhook
```

#### Call Processing Workflow (Future)
```
Trigger: Webhook from telephony service
├── Receive call recording data
├── Transcribe call using speech-to-text
├── Extract action items and decisions
├── Generate call summary
├── Store results in database
└── Notify user of key information
```

## 2. Data Models

### 2.1 Communication Domain Models (C#)
```csharp
public class Email
{
    public int Id { get; set; }
    public int AccountId { get; set; }
    public string MessageId { get; set; }
    public string ThreadId { get; set; }
    public string Subject { get; set; }
    public string Sender { get; set; }
    public List<string> Recipients { get; set; }
    public DateTime DateReceived { get; set; }
    public bool IsRead { get; set; }
    public bool IsStarred { get; set; }
    public int? CategoryId { get; set; }
    public string AISummary { get; set; }
    public string AICategory { get; set; }
    public string Content { get; set; }
    public List<EmailAttachment> Attachments { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}

public class Call // Future
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public string PhoneNumber { get; set; }
    public DateTime StartTime { get; set; }
    public DateTime EndTime { get; set; }
    public TimeSpan Duration { get; set; }
    public CallDirection Direction { get; set; }
    public string RecordingUrl { get; set; }
    public string Transcription { get; set; }
    public string AISummary { get; set; }
    public List<string> ActionItems { get; set; }
    public DateTime CreatedAt { get; set; }
}

public class Appointment // Future
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public string Title { get; set; }
    public string Description { get; set; }
    public DateTime StartTime { get; set; }
    public DateTime EndTime { get; set; }
    public string Location { get; set; }
    public List<string> Attendees { get; set; }
    public string ProviderId { get; set; }
    public List<Reminder> Reminders { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}

public enum EmailProvider
{
    Gmail,
    Outlook,
    IMAP
}

public enum CallDirection
{
    Inbound,
    Outbound,
    Missed
}
```

### 2.2 Flutter Domain Models (Dart)
```dart
class Email {
  final int id;
  final int accountId;
  final String messageId;
  final String threadId;
  final String subject;
  final String sender;
  final List<String> recipients;
  final DateTime dateReceived;
  final bool isRead;
  final bool isStarred;
  final int? categoryId;
  final String? aiSummary;
  final String? aiCategory;
  final String content;
  final List<EmailAttachment> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;

  Email({
    required this.id,
    required this.accountId,
    required this.messageId,
    required this.threadId,
    required this.subject,
    required this.sender,
    required this.recipients,
    required this.dateReceived,
    required this.isRead,
    required this.isStarred,
    this.categoryId,
    this.aiSummary,
    this.aiCategory,
    required this.content,
    required this.attachments,
    required this.createdAt,
    required this.updatedAt,
  });
}

class Call { // Future
  final int id;
  final int userId;
  final String phoneNumber;
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;
  final CallDirection direction;
  final String? recordingUrl;
  final String? transcription;
  final String? aiSummary;
  final List<String> actionItems;
  final DateTime createdAt;

  Call({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.direction,
    this.recordingUrl,
    this.transcription,
    this.aiSummary,
    required this.actionItems,
    required this.createdAt,
  });
}
```

## 3. API Design

### 3.1 RESTful API Endpoints

#### Authentication
```
POST   /api/auth/login           // Initiate OAuth flow
POST   /api/auth/callback        // OAuth callback
POST   /api/auth/refresh         // Refresh JWT token
DELETE /api/auth/logout          // Logout user
```

#### Email Accounts
```
GET    /api/accounts             // Get all accounts
POST   /api/accounts             // Add new account
PUT    /api/accounts/{id}        // Update account
DELETE /api/accounts/{id}        // Remove account
POST   /api/accounts/{id}/sync   // Trigger sync
```

#### Emails
```
GET    /api/emails               // Get paginated emails
GET    /api/emails/{id}          // Get specific email
PUT    /api/emails/{id}          // Update email status
DELETE /api/emails/{id}          // Delete email
POST   /api/emails/{id}/reply    // Send reply
POST   /api/emails/search        // Search emails
```

#### Calls (Future)
```
GET    /api/calls                // Get call history
GET    /api/calls/{id}           // Get specific call
POST   /api/calls/{id}/transcribe // Trigger transcription
GET    /api/calls/search         // Search calls
```

#### Appointments (Future)
```
GET    /api/appointments         // Get calendar events
POST   /api/appointments         // Create appointment
PUT    /api/appointments/{id}    // Update appointment
DELETE /api/appointments/{id}    // Delete appointment
POST   /api/appointments/suggest // AI scheduling suggestions
```

#### AI Processing
```
POST   /api/ai/categorize        // Categorize communication
POST   /api/ai/summarize         // Generate summary
POST   /api/ai/reply             // Generate reply
POST   /api/ai/train             // Train with user feedback
```

### 3.2 Response Format Standard

```json
{
  "success": true,
  "data": {
    // Response data
  },
  "pagination": {
    "currentPage": 1,
    "totalPages": 10,
    "totalItems": 100,
    "itemsPerPage": 10
  },
  "errors": [],
  "metadata": {
    "timestamp": "2023-11-15T10:30:00Z",
    "requestId": "req-123456789"
  }
}
```

## 4. Database Schema Design

### 4.1 Entity Relationship Diagram

```
Users (1) -----> (N) EmailAccounts (1) -----> (N) Emails
   |                  |                        |
   |                  |                        |
 (N) Categories     (N) SyncLogs              (N) AIResults
   |                  |                        |
   |                  |                        |
   |             (Future: Calls)          (Future: CallResults)
   |                  |                        |
   |             (Future: Appointments)      (Future: AppointmentResults)
```

### 4.2 Detailed Schema

```sql
-- Users Table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Email Accounts Table
CREATE TABLE email_accounts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    provider VARCHAR(50) NOT NULL,
    email_address VARCHAR(255) NOT NULL,
    refresh_token TEXT,
    is_active BOOLEAN DEFAULT true,
    last_sync_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Emails Table
CREATE TABLE emails (
    id SERIAL PRIMARY KEY,
    account_id INTEGER REFERENCES email_accounts(id) ON DELETE CASCADE,
    message_id VARCHAR(255) NOT NULL,
    thread_id VARCHAR(255),
    subject TEXT,
    sender VARCHAR(255),
    recipients TEXT[], -- PostgreSQL array
    date_received TIMESTAMP,
    is_read BOOLEAN DEFAULT false,
    is_starred BOOLEAN DEFAULT false,
    category_id INTEGER,
    ai_summary TEXT,
    ai_category VARCHAR(100),
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(account_id, message_id)
);

-- Categories Table
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    color VARCHAR(7), -- Hex color code
    is_system BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, name)
);

-- AI Processing Results Table
CREATE TABLE ai_results (
    id SERIAL PRIMARY KEY,
    item_id INTEGER, -- Can reference emails, calls, appointments
    item_type VARCHAR(50) NOT NULL, -- 'email', 'call', 'appointment'
    processing_type VARCHAR(50) NOT NULL,
    result JSONB, -- Flexible JSON storage
    confidence FLOAT,
    model_version VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Future: Calls Table
CREATE TABLE calls (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    phone_number VARCHAR(50),
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    direction VARCHAR(20), -- 'inbound', 'outbound', 'missed'
    recording_url TEXT,
    transcription TEXT,
    ai_summary TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Future: Appointments Table
CREATE TABLE appointments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255),
    description TEXT,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    location VARCHAR(255),
    provider_id VARCHAR(50), -- 'google', 'outlook'
    provider_event_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sync Logs Table
CREATE TABLE sync_logs (
    id SERIAL PRIMARY KEY,
    account_id INTEGER REFERENCES email_accounts(id) ON DELETE CASCADE,
    sync_type VARCHAR(50) NOT NULL, -- 'email', 'calendar'
    status VARCHAR(50) NOT NULL,
    items_processed INTEGER DEFAULT 0,
    errors TEXT,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP
);
```

## 5. Security Design

### 5.1 OAuth2 Implementation

#### Gmail OAuth Flow
```
[Flutter App] → [Google Sign-In] → [Access Code] → [Backend Exchange] → [Refresh Token]
```

#### Outlook OAuth Flow
```
[Flutter App] → [Microsoft Authentication Library] → [Access Code] → [Backend Exchange] → [Refresh Token]
```

### 5.2 Token Management
```csharp
// JWT Token Structure
{
  "sub": "user_id",
  "email": "user@example.com",
  "accounts": [1, 2, 3],
  "exp": 1234567890,
  "iat": 1234567800,
  "iss": "personal-assistant"
}
```

### 5.3 Secrets Management
```yaml
# Kubernetes Secret Example
apiVersion: v1
kind: Secret
metadata:
  name: api-secrets
type: Opaque
stringData:
  gemini-api-key: "your-gemini-api-key"
  jwt-secret: "your-jwt-secret"
  db-connection-string: "your-db-connection"
```

## 6. Performance Design

### 6.1 Caching Strategy

#### Multi-Level Caching
```
Level 1: Flutter App (SQLite)
Level 2: Redis Cache (API responses)
Level 3: Database Query Cache
```

#### Cache Invalidation
```
User Action → Invalidate Related Cache → Background Refresh
```

### 6.2 Database Optimization

#### Indexing Strategy
```sql
-- Performance Indexes
CREATE INDEX idx_emails_account_date ON emails(account_id, date_received DESC);
CREATE INDEX idx_emails_unread ON emails(account_id, is_read) WHERE is_read = false;
CREATE INDEX idx_emails_category ON emails(account_id, category_id);
CREATE INDEX idx_ai_results_item_type ON ai_results(item_id, item_type);

-- Future Indexes
CREATE INDEX idx_calls_user_date ON calls(user_id, start_time DESC);
CREATE INDEX idx_appointments_user_time ON appointments(user_id, start_time);
```

#### Query Optimization
```csharp
// Efficient pagination with keyset pagination
public async Task<PagedResult<Email>> GetEmailsAsync(
    int accountId, 
    DateTime? cursor = null, 
    int limit = 20)
{
    var query = _context.Emails
        .Where(e => e.AccountId == accountId)
        .OrderByDescending(e => e.DateReceived)
        .Take(limit + 1);
    
    if (cursor.HasValue)
        query = query.Where(e => e.DateReceived < cursor.Value);
    
    var emails = await query.ToListAsync();
    var hasMore = emails.Count > limit;
    
    if (hasMore)
        emails.RemoveAt(emails.Count - 1);
    
    return new PagedResult<Email>
    {
        Items = emails,
        HasMore = hasMore,
        NextCursor = hasMore ? emails.LastOrDefault()?.DateReceived : null
    };
}
```

## 7. Error Handling Design

### 7.1 Error Response Structure
```json
{
  "success": false,
  "errors": [
    {
      "code": "ITEM_NOT_FOUND",
      "message": "The requested item could not be found",
      "details": {
        "itemType": "email",
        "itemId": 12345,
        "timestamp": "2023-11-15T10:30:00Z"
      }
    }
  ],
  "metadata": {
    "requestId": "req-123456789"
  }
}
```

### 7.2 Error Codes

#### Email Errors
- `EMAIL_NOT_FOUND` - Email doesn't exist
- `EMAIL_ACCESS_DENIED` - No permission to access email
- `EMAIL_SYNC_FAILED` - Email synchronization failed

#### Account Errors
- `ACCOUNT_NOT_FOUND` - Email account doesn't exist
- `ACCOUNT_AUTH_EXPIRED` - Authentication expired
- `ACCOUNT_SYNC_RATE_LIMITED` - Too many sync requests

#### AI Processing Errors
- `AI_SERVICE_UNAVAILABLE` - AI service down
- `AI_PROCESSING_FAILED` - AI processing error
- `AI_QUOTA_EXCEEDED` - AI usage quota exceeded

#### Future: Call Errors
- `CALL_NOT_FOUND` - Call recording doesn't exist
- `CALL_TRANSCRIPTION_FAILED` - Transcription processing failed
- `CALL_ACCESS_DENIED` - No permission to access call

#### Future: Appointment Errors
- `APPOINTMENT_CONFLICT` - Time slot already booked
- `CALENDAR_ACCESS_DENIED` - No calendar access
- `APPOINTMENT_NOT_FOUND` - Appointment doesn't exist

## 8. Testing Strategy

### 8.1 Unit Testing
- 80%+ code coverage
- Mock external dependencies
- Focus on business logic

### 8.2 Integration Testing
- API endpoint testing
- Database integration
- External service integration

### 8.3 End-to-End Testing
- User journey testing
- Cross-platform compatibility
- Performance testing under load

### 8.4 Future Testing
- Call recording and transcription testing
- Calendar synchronization testing
- Multi-provider communication testing