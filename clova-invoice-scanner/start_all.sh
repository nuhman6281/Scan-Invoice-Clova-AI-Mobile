#!/bin/bash

# CLOVA AI Invoice Scanner - Automated Startup Script
# This script starts all components of the system in the correct order

set -e # Exit on any error

echo "🚀 Starting CLOVA AI Invoice Scanner System..."
echo "================================================"

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

# Function to check if a port is in use
check_port() {
    local port=$1
    if lsof -Pi :"$port" -sTCP:LISTEN -t >/dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to wait for a service to be ready
wait_for_service() {
    local url=$1
    local service_name=$2
    local max_attempts=30
    local attempt=1

    print_status "Waiting for $service_name to be ready..."

    while [ $attempt -le $max_attempts ]; do
        if curl -s "$url" >/dev/null 2>&1; then
            print_success "$service_name is ready!"
            return 0
        fi

        echo -n "."
        sleep 2
        attempt=$((attempt + 1))
    done

    print_error "$service_name failed to start after $max_attempts attempts"
    return 1
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if required tools are installed
if ! command -v node &>/dev/null; then
    print_error "Node.js is not installed. Please install Node.js and try again."
    exit 1
fi

if ! command -v python3 &>/dev/null; then
    print_error "Python 3 is not installed. Please install Python 3 and try again."
    exit 1
fi

# Step 1: Start Database Services
print_status "Step 1: Starting database services (PostgreSQL & Redis)..."
docker compose up -d postgres redis

# Wait for database to be ready
print_status "Waiting for database services to be ready..."
sleep 30

# Check if database services are running
if ! docker compose ps postgres | grep -q "Up"; then
    print_error "PostgreSQL failed to start"
    exit 1
fi

if ! docker compose ps redis | grep -q "Up"; then
    print_error "Redis failed to start"
    exit 1
fi

print_success "Database services are running"

# Step 2: Setup Backend
print_status "Step 2: Setting up backend..."
cd backend

# Check if node_modules exists, if not install dependencies
if [ ! -d "node_modules" ]; then
    print_status "Installing backend dependencies..."
    npm install
fi

# Run database migrations
print_status "Running database migrations..."
npx prisma migrate deploy

# Seed the database
print_status "Seeding database with test data..."
npx prisma db seed

# Start backend server
print_status "Starting backend server..."
npm start &
BACKEND_PID=$!

# Wait for backend to be ready
wait_for_service "http://localhost:3002/api/health" "Backend API"
if [ $? -ne 0 ]; then
    print_error "Backend failed to start"
    kill $BACKEND_PID 2>/dev/null || true
    exit 1
fi

print_success "Backend is running on http://localhost:3002"

# Step 3: Start CLOVA AI Service
print_status "Step 3: Starting CLOVA AI service..."
cd ../clova-service

# Check if Python virtual environment exists
if [ ! -d "../../donut_env" ]; then
    print_error "Python virtual environment not found. Please run the setup script first."
    exit 1
fi

# Activate Python virtual environment and start CLOVA service
print_status "Activating Python virtual environment..."
source ../../donut_env/bin/activate

print_status "Starting CLOVA AI service (this may take 1-2 minutes on first run)..."
python real_clova_service.py &
CLOVA_PID=$!

# Wait for CLOVA service to be ready
wait_for_service "http://localhost:8000/health" "CLOVA AI Service"
if [ $? -ne 0 ]; then
    print_error "CLOVA AI service failed to start"
    kill $BACKEND_PID $CLOVA_PID 2>/dev/null || true
    exit 1
fi

print_success "CLOVA AI service is running on http://localhost:8000"

# Step 4: Start Admin Portal
print_status "Step 4: Starting admin portal..."
cd ../admin-portal

# Check if node_modules exists, if not install dependencies
if [ ! -d "node_modules" ]; then
    print_status "Installing admin portal dependencies..."
    npm install
fi

# Start admin portal
print_status "Starting admin portal..."
npm run dev &
ADMIN_PID=$!

# Wait for admin portal to be ready
wait_for_service "http://localhost:3000" "Admin Portal"
if [ $? -ne 0 ]; then
    print_error "Admin portal failed to start"
    kill $BACKEND_PID $CLOVA_PID $ADMIN_PID 2>/dev/null || true
    exit 1
fi

print_success "Admin portal is running on http://localhost:3000"

# Final status
echo ""
echo "================================================"
print_success "🎉 All services started successfully!"
echo "================================================"
echo ""
echo "📱 Backend API:     http://localhost:3002"
echo "🤖 CLOVA AI:        http://localhost:8000"
echo "🖥️ Admin Portal:    http://localhost:3000"
echo "📊 PostgreSQL:      localhost:5432"
echo "🔴 Redis:           localhost:6379"
echo ""
echo "🔐 Admin Portal Login:"
echo "   Email:    admin@example.com"
echo "   Password: admin123"
echo ""
echo "📋 Test Commands:"
echo "   Health Check: curl http://localhost:3002/api/health"
echo "   CLOVA Health: curl http://localhost:8000/health"
echo "   Test Scan:    curl -X POST http://localhost:3002/api/scan -F 'image=@misc/sample_image_cord_test_receipt_00004.png' -H 'Authorization: Bearer test-token'"
echo ""
print_warning "Press Ctrl+C to stop all services"

# Function to cleanup on exit
cleanup() {
    echo ""
    print_status "🛑 Stopping all services..."

    # Kill background processes
    kill $BACKEND_PID $CLOVA_PID $ADMIN_PID 2>/dev/null || true

    # Stop database services
    cd "$SCRIPT_DIR"
    docker compose down

    print_success "All services stopped"
    exit 0
}

# Set up signal handlers
trap cleanup INT TERM

# Wait for interrupt
wait
