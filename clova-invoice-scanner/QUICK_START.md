# 🚀 Quick Start Guide

## One-Command Startup

```bash
cd clova-invoice-scanner
./start_all.sh
```

## One-Command Shutdown

```bash
cd clova-invoice-scanner
./stop_all.sh
```

## Manual Startup (if needed)

### 1. Database

```bash
docker compose up -d postgres redis
```

### 2. Backend

```bash
cd backend
npm start
```

### 3. CLOVA AI

```bash
cd clova-service
source ../../donut_env/bin/activate
python real_clova_service.py
```

### 4. Admin Portal

```bash
cd admin-portal
npm run dev
```

## Service URLs

| Service      | URL                   | Port |
| ------------ | --------------------- | ---- |
| Backend API  | http://localhost:3002 | 3002 |
| CLOVA AI     | http://localhost:8000 | 8000 |
| Admin Portal | http://localhost:3000 | 3000 |

## Quick Tests

### Health Checks

```bash
curl http://localhost:3002/api/health
curl http://localhost:8000/health
```

### Test Invoice Scan

```bash
curl -X POST http://localhost:3002/api/scan \
  -F "image=@misc/sample_image_cord_test_receipt_00004.png" \
  -H "Authorization: Bearer test-token"
```

## Admin Login

- **URL**: http://localhost:3000
- **Email**: admin@example.com
- **Password**: admin123

## Troubleshooting

### Port Conflicts

```bash
lsof -i :3000 -i :3002 -i :8000
kill -9 <PID>
```

### Reset Database

```bash
cd backend
npx prisma migrate reset
npx prisma db seed
```

### Clear Caches

```bash
# Admin Portal
cd admin-portal && rm -rf .next

# Backend
cd backend && rm -rf node_modules && npm install
```

## System Requirements

- Docker & Docker Compose
- Node.js 18+
- Python 3.10
- 4GB+ RAM (2GB for AI model)
- macOS/Linux/Windows

## First Time Setup

If this is your first time running the system:

1. Ensure Docker is running
2. Run `./start_all.sh` - it will install dependencies automatically
3. Wait for all services to start (2-3 minutes)
4. Access admin portal at http://localhost:3000
