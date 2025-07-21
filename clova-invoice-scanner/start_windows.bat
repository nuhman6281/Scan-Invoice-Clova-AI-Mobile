@echo off
setlocal enabledelayedexpansion

echo 🚀 Starting CLOVA Invoice Scanner on Windows...

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running. Please start Docker Desktop and try again.
    pause
    exit /b 1
)

REM Check if Docker Compose is available
docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker Compose is not available. Please install Docker Compose and try again.
    pause
    exit /b 1
)

REM Stop any existing containers
echo 🛑 Stopping existing containers...
docker-compose -f docker-compose.yml -f docker-compose.windows.yml down --remove-orphans

REM Build and start services with Windows-specific configuration
echo 🔨 Building and starting services...
docker-compose -f docker-compose.yml -f docker-compose.windows.yml up --build -d

REM Wait for services to be healthy
echo ⏳ Waiting for services to be ready...
timeout /t 10 /nobreak >nul

REM Check service health
echo 🏥 Checking service health...

REM Check Redis
docker-compose -f docker-compose.yml -f docker-compose.windows.yml exec -T redis redis-cli ping >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Redis health check failed, but continuing...
) else (
    echo ✅ Redis is healthy
)

REM Check PostgreSQL
docker-compose -f docker-compose.yml -f docker-compose.windows.yml exec -T postgres pg_isready -U scanner -d invoice_scanner >nul 2>&1
if errorlevel 1 (
    echo ⚠️  PostgreSQL health check failed, but continuing...
) else (
    echo ✅ PostgreSQL is healthy
)

REM Check Backend
echo ⏳ Waiting for backend to be ready...
set /a counter=0
set /a timeout=60
:backend_loop
curl -f http://localhost:3000/health >nul 2>&1
if not errorlevel 1 (
    echo ✅ Backend is healthy
    goto clova_check
)
timeout /t 2 /nobreak >nul
set /a counter+=2
if %counter% lss %timeout% goto backend_loop
echo ⚠️  Backend health check timed out, but continuing...

:clova_check
REM Check CLOVA Service
echo ⏳ Waiting for CLOVA service to be ready...
set /a counter=0
:clova_loop
curl -f http://localhost:8000/health >nul 2>&1
if not errorlevel 1 (
    echo ✅ CLOVA service is healthy
    goto end
)
timeout /t 2 /nobreak >nul
set /a counter+=2
if %counter% lss %timeout% goto clova_loop
echo ⚠️  CLOVA service health check timed out, but continuing...

:end
echo.
echo 🎉 CLOVA Invoice Scanner is starting up!
echo.
echo 📱 Services available at:
echo    • Backend API: http://localhost:3000
echo    • CLOVA AI Service: http://localhost:8000
echo    • Admin Portal: http://localhost:3000 (if configured)
echo    • Database Admin: http://localhost:8080
echo    • Redis Commander: http://localhost:8081
echo.
echo 📊 To view logs:
echo    • All services: docker-compose -f docker-compose.yml -f docker-compose.windows.yml logs -f
echo    • Redis only: docker-compose -f docker-compose.yml -f docker-compose.windows.yml logs -f redis
echo.
echo 🛑 To stop services:
echo    docker-compose -f docker-compose.yml -f docker-compose.windows.yml down
echo.
pause 