#!/bin/bash

# Development Database Initialization Script

echo "🗄️ Initializing development database..."

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
until pg_isready -h localhost -U dev_user -p dev_password; do
  echo "⏳ PostgreSQL not ready yet..."
  sleep 2
done

echo "✅ PostgreSQL is ready!"

# Connect to PostgreSQL and create initial schema
PGPASSWORD=dev_password psql -h localhost -U dev_user -d personal_assistant_dev << 'EOF'

-- Create email processing tables
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS email_accounts (
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

CREATE TABLE IF NOT EXISTS email_processing_results (
    id SERIAL PRIMARY KEY,
    account_id INTEGER REFERENCES email_accounts(id) ON DELETE CASCADE,
    message_id VARCHAR(255) NOT NULL,
    processing_type VARCHAR(50) NOT NULL,
    result JSONB NOT NULL,
    confidence FLOAT,
    model_version VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(account_id, message_id, processing_type)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_email_processing_results_account ON email_processing_results(account_id);
CREATE INDEX IF NOT EXISTS idx_email_processing_results_type ON email_processing_results(processing_type);
CREATE INDEX IF NOT EXISTS idx_email_processing_results_created ON email_processing_results(created_at);

-- Insert test data
INSERT INTO users (email) VALUES ('dev@personal-assistant.com') ON CONFLICT (email) DO NOTHING;
EOF

echo "✅ Development database initialized successfully!"
echo "🔗 Connect to database: psql -h localhost -U dev_user -d personal_assistant_dev"
echo "🔑 Password: dev_password"