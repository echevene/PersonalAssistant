# CI/CD Pipeline for 5 Hours/Week Development

## Overview

For a developer with limited time, CI/CD must be **fully automated, reliable, and maintenance-free**. This pipeline handles all deployment, testing, and monitoring so you can focus on development.

## Design Principles

1. **Zero Manual Deployment** - Everything automated via GitHub Actions
2. **Fast Feedback** - Immediate testing and deployment on push
3. **Developer-Friendly** - Simple local development, complex production automated
4. **Time-Saving** - Pipeline does what you don't have time for

## Architecture

```
[Git Push] → [GitHub Actions] → [Automated Testing] → [Container Build] → [K8s Deployment] → [Monitoring]
```

## Backend CI/CD (.NET 8 API)

### GitHub Workflow: Backend CI/CD

```yaml
# .github/workflows/backend-ci.yml
name: Backend CI/CD

on:
  push:
    branches: [ main, develop ]
    paths: [ 'src/**', 'test/**' ]
  pull_request:
    branches: [ main ]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: personal-assistant-api

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
        
      - name: Setup .NET
        uses: actions/setup-dotnet@v3
        with:
          dotnet-version: '8.0.x'
          
      - name: Restore dependencies
        run: dotnet restore src/PersonalAssistant.Api/PersonalAssistant.Api.csproj
        
      - name: Build
        run: dotnet build src/PersonalAssistant.Api/PersonalAssistant.Api.csproj --no-restore
        
      - name: Run Tests
        run: dotnet test test/PersonalAssistant.Tests/PersonalAssistant.Tests.csproj --no-build --logger "trx;LogFilePath=test-results"
        
      - name: Upload Test Results
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: test-results
          path: test-results/
          
      - name: Code Coverage
        run: dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=cobertura
        
      - name: Upload Coverage
        uses: codecov/codecov-action@v3
        
  build-and-deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
      - name: Checkout
        uses: actions/checkout@v3
        
      - name: Setup .NET
        uses: actions/setup-dotnet@v3
        with:
          dotnet-version: '8.0.x'
          
      - name: Build Release
        run: dotnet publish src/PersonalAssistant.Api/PersonalAssistant.Api.csproj -c Release -o publish
        
      - name: Log in to Container Registry
        uses: docker/login-action@v2
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
          
      - name: Extract Metadata
        id: meta
        uses: docker/metadata-action@v4
        with:
          images: ${{ env.IMAGE_NAME }}
          
      - name: Build and Push Docker Image
        uses: docker/build-push-action@v4
        with:
          context: ./publish
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          
      - name: Deploy to Kubernetes
        run: |
          echo "${{ secrets.KUBECONFIG }}" | base64 -d > kubeconfig
          export KUBECONFIG=kubeconfig
          
          # Update deployment
          kubectl set image deployment/personal-assistant-api api=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
          
          # Wait for rollout
          kubectl rollout status deployment/personal-assistant-api
          
          # Run database migrations
          kubectl run migration --image=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }} --restart=Never --command -- dotnet PersonalAssistant.Api --migrate
```

### Database Migration Automation

```yaml
# .github/workflows/migrate.yml
name: Database Migration

on:
  workflow_dispatch:
  schedule:
    - cron: '0 2 * * *' # Daily at 2 AM

jobs:
  migrate:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy Migration Job
        run: |
          echo "${{ secrets.KUBECONFIG }}" | base64 -d > kubeconfig
          export KUBECONFIG=kubeconfig
          
          kubectl apply -f k8s/migration-job.yml
```

## Frontend CI/CD (Flutter)

### GitHub Workflow: Mobile App CI/CD

```yaml
# .github/workflows/mobile-ci.yml
name: Mobile CI/CD

on:
  push:
    branches: [ main, develop ]
    paths: [ 'lib/**', 'test/**' ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout
        uses: actions/checkout@v3
        
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.13.x'
          
      - name: Install Dependencies
        run: flutter pub get
        
      - name: Run Tests
        run: flutter test --coverage
        
      - name: Upload Test Results
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: test-results
          path: test/
          
  build-android:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
      - name: Checkout
        uses: actions/checkout@v3
        
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.13.x'
          
      - name: Build APK
        run: |
          flutter pub get
          flutter build apk --release
          
      - name: Sign APK
        run: |
          # Using APK signing service or local signing
          # Implementation depends on your signing strategy
          
      - name: Upload to App Store
        uses: actions/upload-artifact@v3
        with:
          name: android-apk
          path: build/app/outputs/flutter-apk/
```

## Kubernetes Deployment Configuration

### Backend Deployment

```yaml
# k8s/backend-deployment.yaml
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
        image: ghcr.io/echevene/personal-assistant-api:latest
        ports:
        - containerPort: 80
        env:
        - name: ConnectionStrings__DefaultConnection
          valueFrom:
            secretKeyRef:
              name: db-connection
              key: connection-string
        - name: Gemini__ApiKey
          valueFrom:
            secretKeyRef:
              name: ai-keys
              key: gemini-api-key
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health/ready
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: personal-assistant-api-service
spec:
  selector:
    app: personal-assistant-api
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
```

### Database Migration Job

```yaml
# k8s/migration-job.yml
apiVersion: batch/v1
kind: Job
metadata:
  name: db-migration
spec:
  template:
    spec:
      containers:
      - name: migration
        image: ghcr.io/echevene/personal-assistant-api:latest
        command: ["dotnet", "PersonalAssistant.Api", "--migrate"]
        env:
        - name: ConnectionStrings__DefaultConnection
          valueFrom:
            secretKeyRef:
              name: db-connection
              key: connection-string
      restartPolicy: OnFailure
  backoffLimit: 3
```

## Quality Gates

### Automated Testing Strategy
1. **Unit Tests** - Run on every PR/commit (target: 70% coverage)
2. **Integration Tests** - Test API endpoints and database
3. **Security Scanning** - CodeQL and dependency checks
4. **Performance Testing** - Basic load testing on staging

### Deployment Safety
1. **Rollback Capability** - Automatic rollback on health check failure
2. **Blue-Green Deployment** - Zero downtime for backend
3. **Canary Releases** - Test changes with small user segment
4. **Monitoring Alerts** - Immediate notification on issues

## Monitoring and Observability

### Health Checks

```csharp
// PersonalAssistant.Api/Endpoints/HealthController.cs
[ApiController]
[Route("health")]
public class HealthController : ControllerBase
{
    [HttpGet]
    public IActionResult Health()
    {
        var databaseHealth = CheckDatabaseConnection();
        var aiServiceHealth = CheckAIService();
        
        return Ok(new
        {
            status = databaseHealth && aiServiceHealth ? "healthy" : "unhealthy",
            timestamp = DateTime.UtcNow,
            services = new
            {
                database = databaseHealth ? "healthy" : "unhealthy",
                ai = aiServiceHealth ? "healthy" : "unhealthy"
            }
        });
    }
}
```

### Application Logging

```csharp
// Program.cs
builder.Services.AddLogging(logging =>
{
    logging.ClearProviders();
    logging.AddConsole();
    logging.AddSeq("http://localhost:5341"); // Your logging service
});

// Structured logging in services
_logger.LogInformation("Processing email {EmailId} for account {AccountId}", emailId, accountId);
```

## Developer Workflow

### Local Development Setup

```bash
# One-command setup
git clone https://github.com/echevene/PersonalAssistant.git
cd PersonalAssistant
./scripts/dev-setup.sh
```

### Development Database

```yaml
# docker-compose.dev.yml
version: '3.8'
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: personal_assistant_dev
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: dev_password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql
      
  redis:
    image: redis:7
    ports:
      - "6379:6379"
```

## Time-Saving Automations

### Pre-commit Hooks
```bash
# .husky/pre-commit
#!/bin/sh
# Run tests before commit
dotnet test
flutter test

# Format code
dotnet format
flutter format .
```

### Release Automation
```bash
# scripts/release.sh
#!/bin/sh
# Bump version
npm version patch

# Create release notes
gh release create v$(npm pkg get version) --generate-notes

# Tag and push
git tag v$(npm pkg get version)
git push origin v$(npm pkg get version)
```

## GitHub Secrets Management

### Required Secrets
1. `KUBECONFIG` - Kubernetes configuration
2. `DB_CONNECTION_STRING` - Database connection
3. `GEMINI_API_KEY` - AI service key
4. `APK_SIGNING_KEY` - Android app signing

### Setup Commands
```bash
# Configure secrets once
gh secret set KUBECONFIG <base64-kubeconfig>
gh secret set DB_CONNECTION_STRING <connection-string>
gh secret set GEMINI_API_KEY <api-key>
```

## Monitoring Dashboard

### Grafana Dashboard
1. **API Performance** - Response times, error rates
2. **Database Metrics** - Connection pool, query performance
3. **Application Metrics** - Email processing stats
4. **Infrastructure** - CPU, memory, network usage

### Alerting Rules
1. **High Error Rate** - >5% for 5 minutes
2. **Database Connection Failures** - Any failure
3. **High Memory Usage** - >80% for 10 minutes
4. **API Response Time** - >2 seconds for 5 minutes

## Benefits for 5 Hours/Week Developer

### Time Savings
- **Zero manual deployment** - Saves 2-3 hours per deployment
- **Automated testing** - Saves 1-2 hours per testing cycle
- **Instant feedback** - No waiting for manual processes
- **Rollback safety** - Quick recovery from issues

### Quality Assurance
- **Consistent testing** - Every change validated
- **Security scanning** - Automated vulnerability detection
- **Performance monitoring** - Early issue detection
- **Documentation updates** - Automated deployment notes

### Peace of Mind
- **Reliable deployments** - Automated and repeatable
- **Recovery capability** - Quick rollback if needed
- **Visibility** - Always know system status
- **Focus time** - Spend 5 hours on features, not operations

This CI/CD pipeline ensures your limited development time is spent entirely on feature development, while deployment, testing, and monitoring are fully automated.