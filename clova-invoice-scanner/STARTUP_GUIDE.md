# CLOVA AI Invoice Scanner - Startup Guide

This guide provides step-by-step instructions to start all components of the CLOVA AI Invoice Scanner system after a system restart.

## System Overview

The system consists of the following components:

- **PostgreSQL Database** (Docker)
- **Redis Cache** (Docker)
- **Backend API** (Node.js/Express)
- **CLOVA AI Service** (Python/FastAPI)
- **Admin Portal** (Next.js)
- **Mobile App** (Flutter)

## Prerequisites

Ensure you have the following installed:

- Docker and Docker Compose
- Node.js (v18+)
- Python 3.10
- Flutter SDK
- Git

## Step-by-Step Startup Instructions

### 1. Start Database Services (Docker)

First, start the PostgreSQL and Redis services:

```bash
cd clova-invoice-scanner
docker compose up -d postgres redis
```

Wait for the services to be ready (about 30 seconds), then verify:

```bash
docker compose ps
```

### 2. Start Backend API

In a new terminal window:

```bash
cd clova-invoice-scanner/backend

# Install dependencies (if not already done)
npm install

# Run database migrations
npx prisma migrate deploy

# Seed the database with test data
npx prisma db seed

# Start the backend server
npm start
```

The backend will start on `http://localhost:3002`

### 3. Start CLOVA AI Service

In a new terminal window:

```bash
cd clova-invoice-scanner/clova-service

# Activate Python virtual environment
source ../../donut_env/bin/activate

# Start the CLOVA AI service
python real_clova_service.py
```

The CLOVA service will start on `http://localhost:8000`

**Note**: The first startup may take 1-2 minutes as it downloads and loads the AI model.

### 4. Start Admin Portal

In a new terminal window:

```bash
cd clova-invoice-scanner/admin-portal

# Install dependencies (if not already done)
npm install

# Start the admin portal
npm run dev
```

The admin portal will start on `http://localhost:3000`

### 5. Start Mobile App (Optional)

In a new terminal window:

```bash
cd clova-invoice-scanner/mobile

# Get Flutter dependencies
flutter pub get

# Start iOS Simulator (macOS)
open -a Simulator

# Run the app
flutter run
```

## Quick Startup Script

Create a startup script to automate the process:

```bash
# Create startup script
cat > clova-invoice-scanner/start_all.sh << 'EOF'
#!/bin/bash

echo "🚀 Starting CLOVA AI Invoice Scanner System..."

# Start database services
echo "📊 Starting database services..."
cd clova-invoice-scanner
docker compose up -d postgres redis

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
sleep 30

# Start backend
echo "🔧 Starting backend API..."
cd backend
npm start &
BACKEND_PID=$!

# Wait for backend
sleep 10

# Start CLOVA service
echo "🤖 Starting CLOVA AI service..."
cd ../clova-service
source ../../donut_env/bin/activate
python real_clova_service.py &
CLOVA_PID=$!

# Wait for CLOVA service
sleep 15

# Start admin portal
echo "🖥️ Starting admin portal..."
cd ../admin-portal
npm run dev &
ADMIN_PID=$!

echo "✅ All services started!"
echo "📱 Backend: http://localhost:3002"
echo "🤖 CLOVA AI: http://localhost:8000"
echo "🖥️ Admin Portal: http://localhost:3000"
echo ""
echo "Press Ctrl+C to stop all services"

# Wait for interrupt
trap "echo '🛑 Stopping services...'; kill $BACKEND_PID $CLOVA_PID $ADMIN_PID; docker compose down; exit" INT
wait
EOF

# Make script executable
chmod +x clova-invoice-scanner/start_all.sh
```

## Service URLs and Ports

| Service      | URL                   | Port | Status Check                            |
| ------------ | --------------------- | ---- | --------------------------------------- |
| Backend API  | http://localhost:3002 | 3002 | `curl http://localhost:3002/api/health` |
| CLOVA AI     | http://localhost:8000 | 8000 | `curl http://localhost:8000/health`     |
| Admin Portal | http://localhost:3000 | 3000 | Open in browser                         |
| PostgreSQL   | localhost             | 5432 | `docker compose ps postgres`            |
| Redis        | localhost             | 6379 | `docker compose ps redis`               |

## Verification Steps

After starting all services, verify they're working:

### 1. Check Database

```bash
docker compose ps
```

### 2. Check Backend

```bash
curl http://localhost:3002/api/health
```

### 3. Check CLOVA AI

```bash
curl http://localhost:8000/health
```

### 4. Test Invoice Processing

```bash
curl -X POST http://localhost:3002/api/scan \
  -F "image=@misc/sample_image_cord_test_receipt_00004.png" \
  -H "Authorization: Bearer test-token"
```

### 5. Access Admin Portal

Open http://localhost:3000 in your browser and log in with:

- Email: `admin@example.com`
- Password: `admin123`

## Troubleshooting

### Port Conflicts

If you get "Address already in use" errors:

```bash
# Find processes using ports
lsof -i :3000 -i :3002 -i :8000

# Kill processes if needed
kill -9 <PID>
```

### Database Issues

```bash
# Reset database
cd clova-invoice-scanner
docker compose down
docker compose up -d postgres redis
cd backend
npx prisma migrate reset
npx prisma db seed
```

### CLOVA AI Service Issues

```bash
# Check if Python environment is activated
which python
# Should show: /path/to/donut_env/bin/python

# Reinstall dependencies if needed
cd clova-invoice-scanner/clova-service
source ../../donut_env/bin/activate
pip install -r requirements.txt
```

### Admin Portal Issues

```bash
# Clear Next.js cache
cd clova-invoice-scanner/admin-portal
rm -rf .next
npm run dev
```

## Stopping All Services

To stop all services:

```bash
# Stop admin portal and CLOVA service (Ctrl+C in their terminals)
# Stop backend (Ctrl+C in its terminal)
# Stop database services
cd clova-invoice-scanner
docker compose down
```

## Environment Variables

Make sure these environment variables are set:

### Backend (.env)

```env
DATABASE_URL="postgresql://postgres:password@localhost:5432/clova_invoice_scanner"
REDIS_URL="redis://localhost:6379"
JWT_SECRET="your-secret-key"
CLOVA_SERVICE_URL="http://localhost:8000"
PORT=3002
```

### Admin Portal (.env.local)

```env
NEXT_PUBLIC_API_URL=http://localhost:3002/api
```

## Performance Notes

- **First startup**: CLOVA AI service may take 1-2 minutes to load the model
- **Memory usage**: The AI model requires ~2GB RAM
- **CPU usage**: Processing images uses significant CPU resources
- **Database**: PostgreSQL uses ~200MB RAM
- **Redis**: Uses ~50MB RAM

## Security Notes

- Change default passwords in production
- Use HTTPS in production
- Set up proper firewall rules
- Regularly update dependencies
- Monitor logs for suspicious activity

## Support

If you encounter issues:

1. Check the logs in each terminal window
2. Verify all services are running on correct ports
3. Ensure database is properly seeded
4. Check Python virtual environment is activated
5. Verify all dependencies are installed
