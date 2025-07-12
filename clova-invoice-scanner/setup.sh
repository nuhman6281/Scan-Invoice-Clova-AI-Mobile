#!/bin/bash

# CLOVA AI Invoice Scanner - Complete Setup Script
# This script sets up the entire system: Backend, CLOVA Service, and Mobile App

set -e

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

# Check if running on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_status "Detected macOS"
    PLATFORM="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    print_status "Detected Linux"
    PLATFORM="linux"
else
    print_error "Unsupported operating system: $OSTYPE"
    exit 1
fi

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."

    # Check if Docker is installed
    if ! command -v docker &>/dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi

    # Check if Docker Compose is installed (try both v1 and v2)
    if ! command -v docker-compose &>/dev/null && ! docker compose version &>/dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi

    # Check if Node.js is installed
    if ! command -v node &>/dev/null; then
        print_error "Node.js is not installed. Please install Node.js 18+ first."
        exit 1
    fi

    # Check Node.js version
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 18 ]; then
        print_error "Node.js version 18+ is required. Current version: $(node -v)"
        exit 1
    fi

    # Check if Python is installed
    if ! command -v python3 &>/dev/null; then
        print_error "Python 3 is not installed. Please install Python 3.10+ first."
        exit 1
    fi

    # Check Python version
    PYTHON_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
    PYTHON_MAJOR=$(echo "$PYTHON_VERSION" | cut -d'.' -f1)
    PYTHON_MINOR=$(echo "$PYTHON_VERSION" | cut -d'.' -f2)

    if [ "$PYTHON_MAJOR" -lt 3 ] || ([ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 10 ]); then
        print_error "Python 3.10+ is required. Current version: $PYTHON_VERSION"
        exit 1
    fi

    # Check if Flutter is installed
    if ! command -v flutter &>/dev/null; then
        print_warning "Flutter is not installed. Mobile app setup will be skipped."
        FLUTTER_AVAILABLE=false
    else
        FLUTTER_AVAILABLE=true
        print_success "Flutter is available"
    fi

    print_success "Prerequisites check completed"
}

# Setup environment variables
setup_env() {
    print_status "Setting up environment variables..."

    # Create .env files
    cat >.env <<EOF
# CLOVA Invoice Scanner Environment Variables

# Database
DATABASE_URL=postgresql://scanner:password123@localhost:5432/invoice_scanner
REDIS_URL=redis://localhost:6379

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRES_IN=7d
JWT_REFRESH_EXPIRES_IN=30d

# CLOVA Service
CLOVA_SERVICE_URL=http://localhost:8000
CLOVA_SERVICE_TIMEOUT=30000

# Backend
PORT=3000
HOST=0.0.0.0
NODE_ENV=development

# Logging
LOG_LEVEL=info

# File Upload
MAX_FILE_SIZE=10485760
UPLOAD_DIR=uploads

# Rate Limiting
RATE_LIMIT_WINDOW=900000
RATE_LIMIT_MAX_REQUESTS=100

# CORS
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080,http://localhost:3001

# External APIs
GOOGLE_MAPS_API_KEY=your-google-maps-api-key
EOF

    # Create .env for CLOVA service
    cat >clova-service/.env <<EOF
# CLOVA AI Service Environment Variables

# Server
HOST=0.0.0.0
PORT=8000
WORKERS=1
DEBUG=true

# Logging
LOG_LEVEL=info

# Upload
UPLOAD_DIR=uploads
MAX_FILE_SIZE=10485760

# CORS
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080,http://localhost:3001

# Models
MODEL_CACHE_DIR=models
DONUT_MODEL_NAME=naver-clova-ix/donut-base-finetuned-cord-v2
CRAFT_MODEL_PATH=models/craft

# Processing
DEFAULT_CONFIDENCE_THRESHOLD=0.7
USE_FALLBACK=true
MAX_PROCESSING_TIME=300

# Monitoring
ENABLE_METRICS=true
METRICS_PORT=9090
EOF

    print_success "Environment variables configured"
}

# Setup backend
setup_backend() {
    print_status "Setting up Node.js backend..."

    cd backend

    # Install dependencies
    print_status "Installing Node.js dependencies..."
    npm install

    # Generate Prisma client
    print_status "Generating Prisma client..."
    npx prisma generate

    # Create database migrations
    print_status "Creating database migrations..."
    npx prisma migrate dev --name init

    # Build TypeScript
    print_status "Building TypeScript..."
    npm run build

    cd ..
    print_success "Backend setup completed"
}

# Setup CLOVA service
setup_clova_service() {
    print_status "Setting up Python CLOVA service..."

    cd clova-service

    # Create virtual environment
    print_status "Creating Python virtual environment..."
    python3 -m venv venv

    # Activate virtual environment
    source venv/bin/activate

    # Upgrade pip
    pip install --upgrade pip

    # Install dependencies
    print_status "Installing Python dependencies..."
    pip install -r requirements.txt

    # Create necessary directories
    mkdir -p uploads
    mkdir -p logs
    mkdir -p models

    # Download models (this will happen on first run)
    print_status "Models will be downloaded on first service start..."

    cd ..
    print_success "CLOVA service setup completed"
}

# Setup mobile app
setup_mobile() {
    if [ "$FLUTTER_AVAILABLE" = false ]; then
        print_warning "Skipping mobile app setup (Flutter not available)"
        return
    fi

    print_status "Setting up Flutter mobile app..."

    cd mobile

    # Get Flutter dependencies
    print_status "Getting Flutter dependencies..."
    flutter pub get

    # Generate code
    print_status "Generating code..."
    flutter packages pub run build_runner build --delete-conflicting-outputs

    # Check Flutter setup
    print_status "Checking Flutter setup..."
    flutter doctor

    cd ..
    print_success "Mobile app setup completed"
}

# Setup Docker
setup_docker() {
    print_status "Setting up Docker containers..."

    # Create logs directory
    mkdir -p logs

    # Start services
    print_status "Starting Docker services..."
    docker compose up -d postgres redis

    # Wait for services to be ready
    print_status "Waiting for services to be ready..."
    sleep 10

    # Check if services are running
    if docker compose ps | grep -q "Up"; then
        print_success "Docker services are running"
    else
        print_error "Failed to start Docker services"
        exit 1
    fi
}

# Create startup scripts
create_startup_scripts() {
    print_status "Creating startup scripts..."

    # Backend startup script
    cat >start-backend.sh <<'EOF'
#!/bin/bash
cd backend
npm run dev
EOF
    chmod +x start-backend.sh

    # CLOVA service startup script
    cat >start-clova.sh <<'EOF'
#!/bin/bash
cd clova-service
source venv/bin/activate
python main.py
EOF
    chmod +x start-clova.sh

    # Mobile app startup script
    cat >start-mobile.sh <<'EOF'
#!/bin/bash
cd mobile
flutter run
EOF
    chmod +x start-mobile.sh

    # Full system startup script
    cat >start-all.sh <<'EOF'
#!/bin/bash
echo "Starting CLOVA Invoice Scanner System..."

# Start Docker services
echo "Starting Docker services..."
docker compose up -d

# Wait for services
sleep 5

# Start backend
echo "Starting backend..."
cd backend
npm run dev &
BACKEND_PID=$!

# Start CLOVA service
echo "Starting CLOVA service..."
cd ../clova-service
source venv/bin/activate
python main.py &
CLOVA_PID=$!

echo "System started!"
echo "Backend: http://localhost:3000"
echo "CLOVA Service: http://localhost:8000"
echo "API Docs: http://localhost:3000/docs"
echo "CLOVA Docs: http://localhost:8000/docs"

# Wait for processes
wait $BACKEND_PID $CLOVA_PID
EOF
    chmod +x start-all.sh

    print_success "Startup scripts created"
}

# Create documentation
create_documentation() {
    print_status "Creating documentation..."

    cat >QUICK_START.md <<'EOF'
# 🚀 Quick Start Guide - CLOVA Invoice Scanner

## Prerequisites
- Docker & Docker Compose
- Node.js 18+
- Python 3.10+
- Flutter (optional, for mobile app)

## Quick Start

### 1. Start the System
```bash
./start-all.sh
```

### 2. Access Services
- **Backend API**: http://localhost:3000
- **API Documentation**: http://localhost:3000/docs
- **CLOVA Service**: http://localhost:8000
- **CLOVA Documentation**: http://localhost:8000/docs

### 3. Test the System
```bash
# Test backend health
curl http://localhost:3000/health

# Test CLOVA service health
curl http://localhost:8000/health
```

### 4. Mobile App (Optional)
```bash
cd mobile
flutter run
```

## Individual Services

### Backend Only
```bash
./start-backend.sh
```

### CLOVA Service Only
```bash
./start-clova.sh
```

### Mobile App Only
```bash
./start-mobile.sh
```

## Development

### Backend Development
```bash
cd backend
npm run dev
```

### CLOVA Service Development
```bash
cd clova-service
source venv/bin/activate
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Mobile App Development
```bash
cd mobile
flutter run
```

## Troubleshooting

### Check Service Status
```bash
docker-compose ps
```

### View Logs
```bash
# Backend logs
docker-compose logs backend

# CLOVA service logs
docker-compose logs clova-service

# Database logs
docker-compose logs postgres
```

### Reset System
```bash
# Stop all services
docker-compose down

# Remove volumes (WARNING: This will delete all data)
docker-compose down -v

# Restart
./start-all.sh
```
EOF

    print_success "Documentation created"
}

# Main setup function
main() {
    print_status "Starting CLOVA AI Invoice Scanner setup..."

    # Check prerequisites
    check_prerequisites

    # Setup environment
    setup_env

    # Setup Docker
    setup_docker

    # Setup backend
    setup_backend

    # Setup CLOVA service
    setup_clova_service

    # Setup mobile app
    setup_mobile

    # Create startup scripts
    create_startup_scripts

    # Create documentation
    create_documentation

    print_success "🎉 CLOVA AI Invoice Scanner setup completed!"
    print_status ""
    print_status "Next steps:"
    print_status "1. Start the system: ./start-all.sh"
    print_status "2. Access the API docs: http://localhost:3000/docs"
    print_status "3. Test the CLOVA service: http://localhost:8000/docs"
    print_status "4. Run the mobile app: cd mobile && flutter run"
    print_status ""
    print_status "For more information, see QUICK_START.md"
}

# Run main function
main "$@"
