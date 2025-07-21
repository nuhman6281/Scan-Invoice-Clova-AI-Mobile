@echo off
setlocal enabledelayedexpansion

REM CLOVA AI Invoice Scanner - Automated Startup Script (Windows)
echo 🚀 Starting CLOVA AI Invoice Scanner System...
echo ================================================================

REM Step 1: Start Database Services
echo [INFO] Starting database services (PostgreSQL & Redis)...
docker compose up -d postgres redis

REM Wait for database to be ready
echo [INFO] Waiting for database services to be ready...
timeout /t 30 /nobreak >nul

REM Step 2: Setup Backend
cd backend
if not exist node_modules (
    echo [INFO] Installing backend dependencies...
    npm install
)
echo [INFO] Running database migrations...
npx prisma migrate deploy
echo [INFO] Seeding database with test data...
npx prisma db seed
echo [INFO] Starting backend server...
start "Backend" cmd /c "npm start"

REM Wait for backend to be ready
set /a counter=0
set /a timeout=30
:wait_backend
curl -s http://localhost:3002/api/health >nul 2>&1
if not errorlevel 1 (
    echo [SUCCESS] Backend is running on http://localhost:3002
) else (
    timeout /t 2 /nobreak >nul
    set /a counter+=1
    if !counter! lss !timeout! goto wait_backend
    echo [ERROR] Backend failed to start
    exit /b 1
)
cd ..

REM Step 3: Start CLOVA AI Service
cd clova-service
if not exist ..\..\donut_env (
    echo [ERROR] Python virtual environment not found. Please run the setup script first.
    exit /b 1
)
echo [INFO] Starting CLOVA AI service...
start "CLOVA Service" cmd /c "..\..\donut_env\Scripts\activate && python real_clova_service.py"

REM Wait for CLOVA service to be ready
set /a counter=0
set /a timeout=30
:wait_clova
curl -s http://localhost:8000/health >nul 2>&1
if not errorlevel 1 (
    echo [SUCCESS] CLOVA AI service is running on http://localhost:8000
) else (
    timeout /t 2 /nobreak >nul
    set /a counter+=1
    if !counter! lss !timeout! goto wait_clova
    echo [ERROR] CLOVA AI service failed to start
    exit /b 1
)
cd ..

REM Step 4: Start Admin Portal
cd admin-portal
if not exist node_modules (
    echo [INFO] Installing admin portal dependencies...
    npm install
)
echo [INFO] Starting admin portal...
start "Admin Portal" cmd /c "npm run dev"

REM Wait for admin portal to be ready
set /a counter=0
set /a timeout=30
:wait_admin
curl -s http://localhost:3000 >nul 2>&1
if not errorlevel 1 (
    echo [SUCCESS] Admin portal is running on http://localhost:3000
) else (
    timeout /t 2 /nobreak >nul
    set /a counter+=1
    if !counter! lss !timeout! goto wait_admin
    echo [ERROR] Admin portal failed to start
    exit /b 1
)
cd ..

echo ================================================================
echo [SUCCESS] All services started successfully!
echo ================================================================
echo Backend API:     http://localhost:3002
echo CLOVA AI:        http://localhost:8000
echo Admin Portal:    http://localhost:3000
echo PostgreSQL:      localhost:5432
echo Redis:           localhost:6379
echo.
echo Admin Portal Login:
echo    Email:    admin@example.com
echo    Password: admin123
echo.
echo Test Commands:
echo    Health Check: curl http://localhost:3002/api/health
echo    CLOVA Health: curl http://localhost:8000/health
echo    Test Scan:    curl -X POST http://localhost:3002/api/scan -F "image=@misc/sample_image_cord_test_receipt_00004.png" -H "Authorization: Bearer test-token"
echo.
echo Press Ctrl+C in each service window to stop them, or run:
echo    docker compose down
pause 