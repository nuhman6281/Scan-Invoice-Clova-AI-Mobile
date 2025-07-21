# Windows Setup Guide for CLOVA Invoice Scanner

This guide helps you set up and run the CLOVA Invoice Scanner project on Windows systems.

## Prerequisites

1. **Docker Desktop for Windows**

   - Download and install from [Docker Desktop](https://www.docker.com/products/docker-desktop)
   - Ensure WSL 2 is enabled (Docker Desktop will guide you through this)
   - Make sure Docker Desktop is running

2. **Git for Windows**

   - Download and install from [Git for Windows](https://git-scm.com/download/win)

3. **Windows Terminal (Recommended)**
   - Install from Microsoft Store for better terminal experience

## Quick Start

### Option 1: Using the Windows Batch File (Recommended)

```cmd
# Double-click the batch file or run from command prompt
start_windows.bat
```

### Option 2: Using Docker Compose Directly

```cmd
# Navigate to the project directory
cd clova-invoice-scanner

# Start services with Windows-specific configuration
docker-compose -f docker-compose.yml -f docker-compose.windows.yml up --build -d
```

### Option 3: Using WSL/Bash (if you have WSL installed)

```bash
# Navigate to the project directory
cd clova-invoice-scanner

# Run the Windows startup script
./start_windows.sh
```

## What's Different for Windows?

### 1. Platform Architecture

- **Removed ARM64 platform constraints** that were causing issues on x86_64 Windows systems
- Services now use the default platform architecture

### 2. Redis Configuration

- **Added `--ignore-warnings ARM64-COW-BUG`** to suppress the ARM64 bug warning
- **Optimized memory settings** for Windows environments
- **Added file descriptor limits** to prevent connection issues

### 3. PostgreSQL Configuration

- **Optimized memory settings** for Windows
- **Added performance tuning** parameters

## Troubleshooting

### Redis Issues

#### Problem: Redis exits with ARM64-COW-BUG warning

**Solution**: The Windows configuration already includes `--ignore-warnings ARM64-COW-BUG` flag.

#### Problem: Transparent Huge Pages (THP) warning

**Solution**: This is a warning only and doesn't prevent Redis from running. The Windows configuration includes optimizations to minimize this impact.

#### Problem: Redis connection refused

**Solution**:

1. Check if Redis container is running: `docker ps`
2. Check Redis logs: `docker-compose -f docker-compose.yml -f docker-compose.windows.yml logs redis`
3. Restart Redis: `docker-compose -f docker-compose.yml -f docker-compose.windows.yml restart redis`

### Docker Issues

#### Problem: Docker Desktop not starting

**Solution**:

1. Ensure WSL 2 is properly installed and enabled
2. Restart your computer
3. Run Docker Desktop as administrator

#### Problem: Port conflicts

**Solution**:

1. Check if ports are in use: `netstat -ano | findstr :3000`
2. Stop conflicting services or change ports in `docker-compose.yml`

#### Problem: Volume mounting issues

**Solution**:

1. Ensure Docker Desktop has permission to access your project directory
2. Add the project directory to Docker Desktop's file sharing settings

### Performance Issues

#### Problem: Slow startup

**Solution**:

1. Increase Docker Desktop memory allocation (recommended: 4GB+)
2. Enable Docker Desktop's "Use the WSL 2 based engine" option
3. Ensure your project is on an SSD drive

#### Problem: High memory usage

**Solution**:

1. The Windows configuration includes memory limits for Redis (256MB)
2. Monitor with: `docker stats`

## Service URLs

Once running, access these services:

- **Backend API**: http://localhost:3000
- **CLOVA AI Service**: http://localhost:8000
- **Database Admin (Adminer)**: http://localhost:8080
- **Redis Commander**: http://localhost:8081

## Useful Commands

### View Logs

```cmd
# All services
docker-compose -f docker-compose.yml -f docker-compose.windows.yml logs -f

# Specific service
docker-compose -f docker-compose.yml -f docker-compose.windows.yml logs -f redis
docker-compose -f docker-compose.yml -f docker-compose.windows.yml logs -f postgres
docker-compose -f docker-compose.yml -f docker-compose.windows.yml logs -f backend
```

### Stop Services

```cmd
docker-compose -f docker-compose.yml -f docker-compose.windows.yml down
```

### Restart Services

```cmd
docker-compose -f docker-compose.yml -f docker-compose.windows.yml restart
```

### Clean Start (removes volumes)

```cmd
docker-compose -f docker-compose.yml -f docker-compose.windows.yml down -v
docker-compose -f docker-compose.yml -f docker-compose.windows.yml up --build -d
```

### Check Service Health

```cmd
# Redis
docker-compose -f docker-compose.yml -f docker-compose.windows.yml exec redis redis-cli ping

# PostgreSQL
docker-compose -f docker-compose.yml -f docker-compose.windows.yml exec postgres pg_isready -U scanner -d invoice_scanner

# Backend
curl http://localhost:3000/health

# CLOVA Service
curl http://localhost:8000/health
```

## Configuration Files

- **Main Docker Compose**: `docker-compose.yml`
- **Windows Override**: `docker-compose.windows.yml`
- **Windows Startup Script**: `start_windows.bat`
- **Bash Startup Script**: `start_windows.sh`

## Support

If you encounter issues:

1. Check the logs: `docker-compose -f docker-compose.yml -f docker-compose.windows.yml logs`
2. Ensure Docker Desktop is running and has sufficient resources
3. Try a clean start by removing volumes and rebuilding
4. Check Windows Event Viewer for system-level issues

## Performance Tips

1. **Allocate more memory to Docker Desktop** (4GB+ recommended)
2. **Use SSD storage** for better I/O performance
3. **Close unnecessary applications** to free up system resources
4. **Enable Docker Desktop's experimental features** for better performance
5. **Use WSL 2 backend** for better performance on Windows 10/11
