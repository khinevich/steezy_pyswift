#!/bin/bash

# FastAPI Backend Startup Script
# This script sets up and starts the entire development environment

set -e  # Exit on any error

echo "🚀 FastAPI Backend Startup Script"
echo "================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    print_error "docker-compose.yml not found. Please run this script from the backend directory."
    exit 1
fi

print_status "Starting FastAPI backend setup..."

# 1. Check if Docker is running
print_status "Checking if Docker is running..."
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker Desktop and try again."
    exit 1
fi
print_success "Docker is running"

# 2. Check if virtual environment exists and activate it
if [ -d "venv" ]; then
    print_status "Activating existing virtual environment..."
    source venv/bin/activate
    print_success "Virtual environment activated"
else
    print_warning "Virtual environment not found. Please create one first:"
    print_warning "python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt"
    exit 1
fi

# 3. Install/update Python dependencies
print_status "Installing Python dependencies..."
pip install -r requirements.txt > /dev/null 2>&1
print_success "Python dependencies installed"

# 4. Check and load environment variables
print_status "Checking environment variables..."
if [ ! -f ".env" ]; then
    print_error ".env file not found. Creating default .env file..."
    cat > .env << EOF
#fastapi outside docker
DATABASE_URL=postgresql://admin:admin@localhost:5432/friends_db

#fastapi inside docker
#DATABASE_URL=postgresql://admin:admin@postgres:5432/friends_db
EOF
    print_success "Created .env file"
fi

# Load environment variables
export $(grep -v '^#' .env | xargs)
print_success "Environment variables loaded"
echo "  DATABASE_URL: $DATABASE_URL"

# 5. Start PostgreSQL container
print_status "Starting PostgreSQL container..."
docker-compose up -d postgres

# Wait for PostgreSQL to be ready
print_status "Waiting for PostgreSQL to be ready..."
sleep 5

# Check if container is running
if ! docker-compose ps postgres | grep -q "Up"; then
    print_error "Failed to start PostgreSQL container"
    exit 1
fi
print_success "PostgreSQL container is running"

# 6. Check if database exists, create if it doesn't
print_status "Checking if database 'friends_db' exists..."
DB_EXISTS=$(docker exec -i ios_app_postgres psql -U admin -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='friends_db';" 2>/dev/null || echo "")

if [ -z "$DB_EXISTS" ]; then
    print_status "Creating database 'friends_db'..."
    docker exec -i ios_app_postgres psql -U admin -d postgres -c "CREATE DATABASE friends_db;" > /dev/null 2>&1
    print_success "Database 'friends_db' created"
else
    print_success "Database 'friends_db' already exists"
fi

# 7. Test database connection
print_status "Testing database connection..."
python3 -c "
import sys
import os
sys.path.insert(0, os.getcwd())
try:
    from app.database import engine
    from sqlalchemy import text
    with engine.connect() as conn:
        result = conn.execute(text('SELECT version();'))
        version = result.fetchone()[0]
    print('✓ Database connection successful')
    print(f'✓ PostgreSQL version: {version.split()[1]}')
except Exception as e:
    print(f'✗ Database connection failed: {e}')
    sys.exit(1)
"

# 8. Create/update database tables
print_status "Creating/updating database tables..."
python3 -c "
import sys
import os
# Add the backend directory to path so we can import app modules
sys.path.insert(0, os.getcwd())
try:
    # Import the app which will create tables automatically
    from app.main import app
    from app import models
    from app.database import engine
    
    # Create tables - this is the same as what main.py does
    models.Base.metadata.create_all(bind=engine)
    print('✓ Database tables created/updated')
except Exception as e:
    print(f'✗ Failed to create tables: {e}')
    import traceback
    traceback.print_exc()
    sys.exit(1)
"

# 9. Check what tables exist
print_status "Checking database tables..."
TABLES=$(docker exec -i ios_app_postgres psql -U admin -d friends_db -tAc "\dt" 2>/dev/null | cut -d'|' -f2 | tr -d ' ' | grep -v '^$' || echo "")
if [ -n "$TABLES" ]; then
    print_success "Database tables found:"
    echo "$TABLES" | while read table; do
        if [ -n "$table" ]; then
            echo "  - $table"
        fi
    done
else
    print_warning "No tables found in database"
fi

# 10. Run tests
print_status "Running tests to verify everything works..."
if python -m pytest tests/ -v --tb=short > /dev/null 2>&1; then
    print_success "All tests passed ✓"
else
    print_warning "Some tests failed. Running tests with output:"
    python -m pytest tests/ -v
fi

# 11. Kill any existing FastAPI server
print_status "Checking for existing FastAPI server..."
EXISTING_PID=$(lsof -ti :8000 2>/dev/null || echo "")
if [ -n "$EXISTING_PID" ]; then
    print_status "Stopping existing FastAPI server (PID: $EXISTING_PID)..."
    kill $EXISTING_PID 2>/dev/null || true
    sleep 2
fi

# 12. Start FastAPI server
print_status "Starting FastAPI server..."
echo ""
echo "🎉 Setup complete! Starting FastAPI server..."
echo "================================="
echo "Server will be available at:"
echo "  • API: http://localhost:8000"
echo "  • Docs: http://localhost:8000/docs"
echo "  • Redoc: http://localhost:8000/redoc"
echo ""
echo "Press Ctrl+C to stop the server"
echo "================================="

# Start the server (this will block)
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
