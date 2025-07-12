#!/bin/bash

# CLOVA AI Invoice Scanner - Stop All Services Script

echo "🛑 Stopping CLOVA AI Invoice Scanner System..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit

# Stop processes running on specific ports
print_status "Stopping services on ports 3000, 3002, and 8000..."

# Stop processes on port 3000 (Admin Portal)
if lsof -ti:3000 >/dev/null 2>&1; then
    lsof -ti:3000 | xargs kill -9
    print_status "Stopped service on port 3000"
fi

# Stop processes on port 3002 (Backend)
if lsof -ti:3002 >/dev/null 2>&1; then
    lsof -ti:3002 | xargs kill -9
    print_status "Stopped service on port 3002"
fi

# Stop processes on port 8000 (CLOVA AI)
if lsof -ti:8000 >/dev/null 2>&1; then
    lsof -ti:8000 | xargs kill -9
    print_status "Stopped service on port 8000"
fi

# Stop Docker services
print_status "Stopping Docker services..."
docker-compose down

print_success "All services stopped successfully!"
