@echo off
echo 🚀 Donut Project Setup for Windows
echo ================================================

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python is not installed or not in PATH
    echo Please install Python 3.7+ and try again
    pause
    exit /b 1
)

echo [SUCCESS] Python detected

REM Check if pip is available
python -m pip --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] pip is not available
    pause
    exit /b 1
)

echo [SUCCESS] pip is available

REM Create virtual environment if it doesn't exist
if not exist "donut_env" (
    echo [INFO] Creating virtual environment...
    python -m venv donut_env
    if errorlevel 1 (
        echo [ERROR] Failed to create virtual environment
        pause
        exit /b 1
    )
    echo [SUCCESS] Virtual environment created
) else (
    echo [WARNING] Virtual environment already exists
)

REM Activate virtual environment and install dependencies
echo [INFO] Installing dependencies...
call donut_env\Scripts\activate.bat

REM Upgrade pip
python -m pip install --upgrade pip
if errorlevel 1 (
    echo [ERROR] Failed to upgrade pip
    pause
    exit /b 1
)

REM Install project in editable mode
pip install -e .
if errorlevel 1 (
    echo [ERROR] Failed to install project
    pause
    exit /b 1
)

REM Install additional dependencies
echo [INFO] Installing additional dependencies...
pip install gradio fastapi uvicorn python-multipart Pillow easyocr numpy structlog
if errorlevel 1 (
    echo [ERROR] Failed to install additional dependencies
    pause
    exit /b 1
)

REM Test installation
echo [INFO] Testing installation...
python -c "import donut; print('✅ Donut imported successfully!')"
if errorlevel 1 (
    echo [ERROR] Import test failed
    pause
    exit /b 1
)

REM Create activation script
echo [INFO] Creating activation script...
(
echo @echo off
echo echo Activating Donut environment...
echo call donut_env\Scripts\activate.bat
echo echo Environment activated!
echo echo Run 'deactivate' to exit the environment
) > activate_env.bat

echo ================================================
echo [SUCCESS] 🎉 Setup completed successfully!
echo ================================================
echo.
echo 📋 Next Steps:
echo 1. Activate the environment:
echo    .\activate_env.bat
echo    # or
echo    .\donut_env\Scripts\Activate.ps1
echo.
echo 2. Run the demo:
echo    python app.py --task cord-v2 --port 7860
echo.
echo 3. Open your browser and go to:
echo    http://localhost:7860
echo.
echo 📚 For more information, see SETUP.md
echo.
pause 