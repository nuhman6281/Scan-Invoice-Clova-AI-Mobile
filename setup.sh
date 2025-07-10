#!/bin/bash

# CLOVA AI Invoice Scanner Setup Script
set -e

echo "🚀 Setting up CLOVA AI Invoice Scanner..."

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

# Check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    print_success "Docker and Docker Compose are installed"
}

# Check if Node.js is installed
check_nodejs() {
    if ! command -v node &> /dev/null; then
        print_warning "Node.js is not installed. Installing Node.js dependencies will be skipped."
        return 1
    fi
    
    NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 16 ]; then
        print_warning "Node.js version is below 16. Some features may not work properly."
    fi
    
    print_success "Node.js is installed (version $(node --version))"
    return 0
}

# Check if Python is installed
check_python() {
    if ! command -v python3 &> /dev/null; then
        print_warning "Python 3 is not installed. Installing Python dependencies will be skipped."
        return 1
    fi
    
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f2)
    if [ "$PYTHON_VERSION" -lt 9 ]; then
        print_warning "Python version is below 3.9. Some features may not work properly."
    fi
    
    print_success "Python is installed (version $(python3 --version))"
    return 0
}

# Create necessary directories
create_directories() {
    print_status "Creating project directories..."
    
    mkdir -p backend
    mkdir -p clova-service
    mkdir -p mobile
    mkdir -p uploads
    mkdir -p docs
    
    print_success "Directories created"
}

# Install Node.js dependencies
install_nodejs_deps() {
    if [ -d "backend" ] && [ -f "backend/package.json" ]; then
        print_status "Installing Node.js dependencies..."
        cd backend
        npm install
        cd ..
        print_success "Node.js dependencies installed"
    else
        print_warning "Backend package.json not found. Skipping Node.js dependencies."
    fi
}

# Install Python dependencies
install_python_deps() {
    if [ -d "clova-service" ] && [ -f "clova-service/requirements.txt" ]; then
        print_status "Installing Python dependencies..."
        cd clova-service
        python3 -m pip install --upgrade pip
        python3 -m pip install -r requirements.txt
        cd ..
        print_success "Python dependencies installed"
    else
        print_warning "CLOVA service requirements.txt not found. Skipping Python dependencies."
    fi
}

# Start Docker services
start_services() {
    print_status "Starting Docker services..."
    
    # Stop any existing containers
    docker-compose down --remove-orphans 2>/dev/null || true
    
    # Start services
    docker-compose up -d
    
    print_success "Docker services started"
}

# Wait for services to be ready
wait_for_services() {
    print_status "Waiting for services to be ready..."
    
    # Wait for PostgreSQL
    print_status "Waiting for PostgreSQL..."
    timeout=60
    while ! docker-compose exec -T postgres pg_isready -U scanner -d invoice_scanner >/dev/null 2>&1; do
        if [ $timeout -le 0 ]; then
            print_error "PostgreSQL failed to start within 60 seconds"
            exit 1
        fi
        sleep 1
        timeout=$((timeout - 1))
    done
    print_success "PostgreSQL is ready"
    
    # Wait for CLOVA service
    print_status "Waiting for CLOVA service..."
    timeout=120
    while ! curl -f http://localhost:8000/health >/dev/null 2>&1; do
        if [ $timeout -le 0 ]; then
            print_error "CLOVA service failed to start within 120 seconds"
            exit 1
        fi
        sleep 2
        timeout=$((timeout - 2))
    done
    print_success "CLOVA service is ready"
    
    # Wait for Backend
    print_status "Waiting for Backend..."
    timeout=60
    while ! curl -f http://localhost:3000/health >/dev/null 2>&1; do
        if [ $timeout -le 0 ]; then
            print_error "Backend failed to start within 60 seconds"
            exit 1
        fi
        sleep 1
        timeout=$((timeout - 1))
    done
    print_success "Backend is ready"
}

# Run database migrations
run_migrations() {
    print_status "Running database migrations..."
    
    if [ -d "backend" ]; then
        cd backend
        
        # Wait a bit more for database to be fully ready
        sleep 5
        
        # Run migrations
        if command -v npx &> /dev/null; then
            npx prisma migrate deploy || print_warning "Migration failed, but continuing..."
            npx prisma generate || print_warning "Prisma client generation failed, but continuing..."
        else
            print_warning "npx not found. Skipping database migrations."
        fi
        
        cd ..
    else
        print_warning "Backend directory not found. Skipping database migrations."
    fi
}

# Seed database with sample data
seed_database() {
    print_status "Seeding database with sample data..."
    
    if [ -d "backend" ]; then
        cd backend
        
        if command -v npx &> /dev/null; then
            npx ts-node prisma/seed.ts || print_warning "Database seeding failed, but continuing..."
        else
            print_warning "npx not found. Skipping database seeding."
        fi
        
        cd ..
    else
        print_warning "Backend directory not found. Skipping database seeding."
    fi
}

# Show final status
show_status() {
    echo ""
    echo "🎉 Setup complete! Services are running on:"
    echo ""
    echo -e "${GREEN}✅ Backend API:${NC} http://localhost:3000"
    echo -e "${GREEN}✅ CLOVA Service:${NC} http://localhost:8000"
    echo -e "${GREEN}✅ Database:${NC} localhost:5432"
    echo -e "${GREEN}✅ API Documentation:${NC} http://localhost:3000/api/docs"
    echo -e "${GREEN}✅ CLOVA Docs:${NC} http://localhost:8000/docs"
    echo ""
    echo "📱 Next steps:"
    echo "1. Build the Flutter app: cd mobile && flutter pub get"
    echo "2. Test the API: curl http://localhost:3000/health"
    echo "3. Check the logs: docker-compose logs -f"
    echo ""
    echo "🛠️ Useful commands:"
    echo "- Stop services: docker-compose down"
    echo "- View logs: docker-compose logs -f [service_name]"
    echo "- Restart services: docker-compose restart"
    echo "- Update services: docker-compose pull && docker-compose up -d"
    echo ""
}

# Main execution
main() {
    echo "=========================================="
    echo "CLOVA AI Invoice Scanner Setup"
    echo "=========================================="
    echo ""
    
    # Check prerequisites
    check_docker
    NODEJS_AVAILABLE=$(check_nodejs)
    PYTHON_AVAILABLE=$(check_python)
    
    # Create directories
    create_directories
    
    # Install dependencies if available
    if [ "$NODEJS_AVAILABLE" = "0" ]; then
        install_nodejs_deps
    fi
    
    if [ "$PYTHON_AVAILABLE" = "0" ]; then
        install_python_deps
    fi
    
    # Start services
    start_services
    
    # Wait for services
    wait_for_services
    
    # Setup database
    run_migrations
    seed_database
    
    # Show final status
    show_status
}

# Run main function
main "$@"