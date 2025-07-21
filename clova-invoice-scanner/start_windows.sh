#!/bin/bash

# Windows-specific startup script for CLOVA Invoice Scanner
# This script handles Windows-specific Docker configurations

set -e

echo "🚀 Starting CLOVA Invoice Scanner on Windows..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop and try again."
    exit 1
fi

# Check if Docker Compose is available
if ! docker compose version > /dev/null 2>&1; then
    echo "❌ Docker Compose is not available. Please install Docker Compose first."
    exit 1
fi

# Stop any existing containers
echo "🛑 Stopping existing containers..."
docker compose -f docker-compose.yml -f docker-compose.windows.yml down --remove-orphans

# Remove any existing volumes (optional - uncomment if you want to start fresh)
# echo "🗑️  Removing existing volumes..."
# docker compose -f docker-compose.yml -f docker-compose.windows.yml down -v

# Build and start services with Windows-specific configuration
echo "🔨 Building and starting services..."
docker compose -f docker-compose.yml -f docker-compose.windows.yml up --build -d

# Wait for services to be healthy
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check service health
echo "🏥 Checking service health..."

# Check Redis
if docker compose -f docker-compose.yml -f docker-compose.windows.yml exec -T redis redis-cli ping > /dev/null 2>&1; then
    echo "✅ Redis is healthy"
else
    echo "⚠️  Redis health check failed, but continuing..."
fi

# Check PostgreSQL
if docker compose -f docker-compose.yml -f docker-compose.windows.yml exec -T postgres pg_isready -U scanner -d invoice_scanner > /dev/null 2>&1; then
    echo "✅ PostgreSQL is healthy"
else
    echo "⚠️  PostgreSQL health check failed, but continuing..."
fi

# Check Backend
echo "⏳ Waiting for backend to be ready..."
timeout=60
counter=0
while [ $counter -lt $timeout ]; do
    if curl -f http://localhost:3000/health > /dev/null 2>&1; then
        echo "✅ Backend is healthy"
        break
    fi
    sleep 2
    counter=$((counter + 2))
done

if [ $counter -eq $timeout ]; then
    echo "⚠️  Backend health check timed out, but continuing..."
fi

# Check CLOVA Service
echo "⏳ Waiting for CLOVA service to be ready..."
counter=0
while [ $counter -lt $timeout ]; do
    if curl -f http://localhost:8000/health > /dev/null 2>&1; then
        echo "✅ CLOVA service is healthy"
        break
    fi
    sleep 2
    counter=$((counter + 2))
done

if [ $counter -eq $timeout ]; then
    echo "⚠️  CLOVA service health check timed out, but continuing..."
fi

echo ""
echo "🎉 CLOVA Invoice Scanner is starting up!"
echo ""
echo "📱 Services available at:"
echo "   • Backend API: http://localhost:3000"
echo "   • CLOVA AI Service: http://localhost:8000"
echo "   • Admin Portal: http://localhost:3000 (if configured)"
echo "   • Database Admin: http://localhost:8080"
echo "   • Redis Commander: http://localhost:8081"
echo ""
echo "📊 To view logs:"
echo "   • All services: docker compose -f docker-compose.yml -f docker-compose.windows.yml logs -f"
echo "   • Redis only: docker compose -f docker-compose.yml -f docker-compose.windows.yml logs -f redis"
echo ""
echo "🛑 To stop services:"
echo "   docker compose -f docker-compose.yml -f docker-compose.windows.yml down"
echo "" 