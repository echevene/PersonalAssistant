#!/bin/bash

# Developer Setup Script for Personal Assistant
# Run once to set up complete development environment

echo "🚀 Setting up Personal Assistant development environment..."

# Clone repository if needed
if [ ! -d "PersonalAssistant" ]; then
    echo "📦 Cloning repository..."
    git clone https://github.com/echevene/PersonalAssistant.git
    cd PersonalAssistant
else
    cd PersonalAssistant
    echo "📦 Repository already exists, pulling latest..."
    git pull origin main
fi

# Setup .NET environment
echo "🔧 Setting up .NET 8.0.2 LTS environment..."
dotnet --version
if [ $? -ne 0 ]; then
    echo "❌ .NET not found. Please install .NET 8.0.2 LTS SDK"
    exit 1
fi

# Verify correct version
DOTNET_VERSION=$(dotnet --version | grep -oP '[0-9]\+\.[0-9]\+\.[0-9]\+')
EXPECTED_VERSION="8.0.2"
if [ "$DOTNET_VERSION" != "$EXPECTED_VERSION" ]; then
    echo "⚠️ Warning: .NET version is $DOTNET_VERSION, expected $EXPECTED_VERSION LTS"
    echo "Please install correct .NET 8.0.2 LTS from https://dotnet.microsoft.com/download/dotnet/"
    read -p "Continue anyway? (y/n) " -n 1 -r
    if [[ $REPLY != "y" ]]; then
        exit 1
    fi
fi

# Restore .NET dependencies
echo "📚 Restoring .NET dependencies..."
dotnet restore src/PersonalAssistant.Api/PersonalAssistant.Api.csproj

# Setup Flutter environment
echo "📱 Setting up Flutter environment..."
flutter doctor
if [ $? -ne 0 ]; then
    echo "❌ Flutter not found. Please install Flutter SDK"
    exit 1
fi

# Install Flutter dependencies
echo "📚 Installing Flutter dependencies..."
flutter pub get

# Setup pre-commit hooks
echo "🪝 Setting up git hooks..."
if [ ! -d ".git/hooks" ]; then
    mkdir -p .git/hooks
fi

cat > .git/hooks/pre-commit << 'EOF'
#!/bin/sh
echo "🧪 Running pre-commit checks..."

# Run tests
echo "🧪 Running .NET tests..."
dotnet test --no-build --configuration Release
if [ $? -ne 0 ]; then
    echo "❌ .NET tests failed"
    exit 1
fi

# Run Flutter tests
echo "📱 Running Flutter tests..."
flutter test
if [ $? -ne 0 ]; then
    echo "❌ Flutter tests failed"
    exit 1
fi

# Format code
echo "✨ Formatting code..."
dotnet format --dry-run --check
if [ $? -ne 0 ]; then
    echo "❌ .NET code formatting issues found"
    exit 1
fi

flutter format --set-exit-if-changed .
if [ $? -ne 0 ]; then
    echo "❌ Flutter code formatting issues found"
    exit 1
fi

echo "✅ Pre-commit checks passed"
EOF

chmod +x .git/hooks/pre-commit

# Install pre-commit dependencies for local testing
echo "🔧 Installing local testing tools..."
dotnet tool install -g dotnet-reportgenerator-globaltool
npm install -g gitmoji-cli

# Start development services
echo "🐳 Starting development services..."
if [ -f "docker-compose.dev.yml" ]; then
    echo "🐳 Starting Docker services for development..."
    docker-compose -f docker-compose.dev.yml up -d
fi

# Setup IDE settings
echo "⚙️ Setting up IDE settings..."
if [ -d ".vscode" ]; then
    echo "⚙️ VS Code settings already exist"
else
    mkdir -p .vscode
fi

cat > .vscode/settings.json << 'EOF'
{
    "csharp.format.enable": true,
    "csharp.format.newLine": "\n",
    "csharp.format.braces": "allman",
    "dotnet.defaultSolution": "PersonalAssistant.sln",
    "dart.lineLength": 100,
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.organizeImports": true
    },
    "files.exclude": {
        "**/bin": true,
        "**/obj": true,
        "**/.git": true,
        "**/.DS_Store": true,
        "**/Thumbs.db": true,
        "**/node_modules": true
    }
}
EOF

# Create development environment file
echo "🔐 Creating development environment configuration..."
if [ ! -f "src/PersonalAssistant.Api/appsettings.Development.json" ]; then
    cat > src/PersonalAssistant.Api/appsettings.Development.json << 'EOF'
{
    "Logging": {
        "LogLevel": {
            "Default": "Information",
            "Microsoft.AspNetCore": "Warning"
        }
    },
    "ConnectionStrings": {
        "DefaultConnection": "Host=localhost;Port=5432;Database=personal_assistant_dev;Username=dev;Password=dev_password"
    },
    "Gemini": {
        "ApiKey": "your-gemini-api-key-here"
    },
    "Kubernetes": {
        "Namespace": "personal-assistant-dev"
    }
}
EOF
fi

echo ""
echo "✅ Development environment setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Update src/PersonalAssistant.Api/appsettings.Development.json with your Gemini API key"
echo "2. Run 'dotnet run' to start the API development server"
echo "3. Run 'cd src/PersonalAssistant.App && flutter run' to start the mobile app"
echo "4. Check 'http://localhost:5000/health' to verify API is running"
echo ""
echo "💡 Useful commands:"
echo "  - Run tests: dotnet test"
echo "  - Format code: dotnet format"
echo "  - Start API: dotnet run --project src/PersonalAssistant.Api"
echo "  - Start Flutter: cd src/PersonalAssistant.App && flutter run"
echo "  - Stop dev services: docker-compose -f docker-compose.dev.yml down"
echo ""