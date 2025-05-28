#!/bin/bash

# Database Reset Script
# This script provides options to reset the PostgreSQL database

set -e

echo "🗄️  Database Reset Script"
echo "========================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Check if PostgreSQL container is running
if ! docker-compose ps postgres | grep -q "Up"; then
    print_error "PostgreSQL container is not running. Please start it first with: ./startup.sh"
    exit 1
fi

echo "Choose what you want to reset:"
echo "1) Clear all data (keep tables structure)"
echo "2) Drop and recreate all tables" 
echo "3) Delete entire database and recreate"
echo "4) Delete Docker volume (complete reset)"
echo "5) Cancel"
echo ""
read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        print_status "Clearing all data from friends table..."
        docker exec -i ios_app_postgres psql -U admin -d friends_db -c "DELETE FROM friends;" > /dev/null 2>&1
        print_success "All data cleared from friends table"
        ;;
    2)
        print_status "Dropping and recreating tables..."
        docker exec -i ios_app_postgres psql -U admin -d friends_db -c "DROP TABLE IF EXISTS friends CASCADE;" > /dev/null 2>&1
        
        # Recreate tables using Python
        cd /Users/mkh/Desktop/steezy_pyswift/backend
        source venv/bin/activate 2>/dev/null || true
        python3 -c "
import sys
sys.path.append('app')
from database import engine
from models import Base
Base.metadata.create_all(bind=engine)
print('Tables recreated successfully')
"
        print_success "Tables dropped and recreated"
        ;;
    3)
        print_status "Dropping and recreating entire database..."
        docker exec -i ios_app_postgres psql -U admin -d postgres -c "DROP DATABASE IF EXISTS friends_db;" > /dev/null 2>&1
        docker exec -i ios_app_postgres psql -U admin -d postgres -c "CREATE DATABASE friends_db;" > /dev/null 2>&1
        
        # Recreate tables
        cd /Users/mkh/Desktop/steezy_pyswift/backend
        source venv/bin/activate 2>/dev/null || true
        python3 -c "
import sys
sys.path.append('app')
from database import engine
from models import Base
Base.metadata.create_all(bind=engine)
print('Database and tables recreated successfully')
"
        print_success "Database completely reset"
        ;;
    4)
        print_warning "This will delete ALL PostgreSQL data permanently!"
        read -p "Are you sure? Type 'yes' to confirm: " confirm
        if [ "$confirm" = "yes" ]; then
            print_status "Stopping containers and deleting volume..."
            docker-compose down
            docker volume rm backend_postgres_data 2>/dev/null || true
            print_status "Starting containers with fresh volume..."
            docker-compose up -d postgres
            sleep 5
            
            # Create database and tables
            docker exec -i ios_app_postgres psql -U admin -d postgres -c "CREATE DATABASE friends_db;" > /dev/null 2>&1
            cd /Users/mkh/Desktop/steezy_pyswift/backend
            source venv/bin/activate 2>/dev/null || true
            python3 -c "
import sys
sys.path.append('app')
from database import engine
from models import Base
Base.metadata.create_all(bind=engine)
print('Fresh database created successfully')
"
            print_success "Complete database reset with fresh Docker volume"
        else
            print_status "Reset cancelled"
        fi
        ;;
    5)
        print_status "Reset cancelled"
        exit 0
        ;;
    *)
        print_error "Invalid choice"
        exit 1
        ;;
esac

# Show current state
print_status "Current database state:"
ROW_COUNT=$(docker exec -i ios_app_postgres psql -U admin -d friends_db -tAc "SELECT COUNT(*) FROM friends;" 2>/dev/null || echo "0")
echo "  Friends table: $ROW_COUNT rows"
