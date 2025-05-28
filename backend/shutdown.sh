#!/bin/bash

# FastAPI Backend Shutdown Script
# This script cleanly stops all services

set -e  # Exit on any error

echo "🛑 FastAPI Backend Shutdown Script"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# 1. Stop FastAPI server
print_status "Stopping FastAPI server..."
FASTAPI_PID=$(lsof -ti :8000 2>/dev/null || echo "")
if [ -n "$FASTAPI_PID" ]; then
    kill $FASTAPI_PID 2>/dev/null || true
    print_success "FastAPI server stopped"
else
    print_status "No FastAPI server running on port 8000"
fi

# 2. Stop Docker containers
print_status "Stopping Docker containers..."
if [ -f "docker-compose.yml" ]; then
    docker-compose down
    print_success "Docker containers stopped"
else
    print_status "docker-compose.yml not found, skipping container shutdown"
fi

print_success "Shutdown complete ✓"
echo ""
echo "To start everything again, run: ./startup.sh"
