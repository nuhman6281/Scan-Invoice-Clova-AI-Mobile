#!/usr/bin/env python3
"""
Cross-platform setup script for Donut Project
Supports Windows, macOS, and Linux
"""

import os
import sys
import subprocess
import platform
import venv
from pathlib import Path

def print_status(message, color="blue"):
    """Print colored status message"""
    colors = {
        "red": "\033[0;31m",
        "green": "\033[0;32m", 
        "yellow": "\033[1;33m",
        "blue": "\033[0;34m",
        "nc": "\033[0m"
    }
    print(f"{colors.get(color, '')}[INFO]{colors['nc']} {message}")

def print_success(message):
    """Print success message"""
    print_status(message, "green")

def print_error(message):
    """Print error message"""
    print_status(message, "red")

def print_warning(message):
    """Print warning message"""
    print_status(message, "yellow")

def check_python_version():
    """Check if Python version is compatible"""
    version = sys.version_info
    if version.major < 3 or (version.major == 3 and version.minor < 7):
        print_error("Python 3.7+ is required. Current version: {}.{}".format(version.major, version.minor))
        return False
    print_success(f"Python {version.major}.{version.minor}.{version.micro} detected")
    return True

def check_pip():
    """Check if pip is available"""
    try:
        subprocess.run([sys.executable, "-m", "pip", "--version"], 
                      check=True, capture_output=True)
        print_success("pip is available")
        return True
    except subprocess.CalledProcessError:
        print_error("pip is not available")
        return False

def create_virtual_environment():
    """Create Python virtual environment"""
    venv_path = Path("donut_env")
    
    if venv_path.exists():
        print_warning("Virtual environment already exists")
        return True
    
    print_status("Creating virtual environment...")
    try:
        venv.create("donut_env", with_pip=True)
        print_success("Virtual environment created successfully")
        return True
    except Exception as e:
        print_error(f"Failed to create virtual environment: {e}")
        return False

def install_dependencies():
    """Install project dependencies"""
    print_status("Installing dependencies...")
    
    # Get the Python executable from the virtual environment
    system = platform.system().lower()
    if system == "windows":
        python_exe = "donut_env\\Scripts\\python.exe"
        pip_exe = "donut_env\\Scripts\\pip.exe"
    else:
        python_exe = "donut_env/bin/python"
        pip_exe = "donut_env/bin/pip"
    
    try:
        # Upgrade pip
        subprocess.run([python_exe, "-m", "pip", "install", "--upgrade", "pip"], 
                      check=True)
        print_success("pip upgraded")
        
        # Install the project in editable mode
        subprocess.run([pip_exe, "install", "-e", "."], check=True)
        print_success("Project installed in editable mode")
        
        # Install additional dependencies
        additional_deps = [
            "gradio", "fastapi", "uvicorn", "python-multipart", 
            "Pillow", "easyocr", "numpy", "structlog"
        ]
        
        for dep in additional_deps:
            subprocess.run([pip_exe, "install", dep], check=True)
            print_success(f"Installed {dep}")
        
        return True
        
    except subprocess.CalledProcessError as e:
        print_error(f"Failed to install dependencies: {e}")
        return False

def test_installation():
    """Test if the installation was successful"""
    print_status("Testing installation...")
    
    system = platform.system().lower()
    if system == "windows":
        python_exe = "donut_env\\Scripts\\python.exe"
    else:
        python_exe = "donut_env/bin/python"
    
    try:
        # Test basic import
        result = subprocess.run([python_exe, "-c", "import donut; print('✅ Donut imported successfully!')"], 
                              capture_output=True, text=True, check=True)
        print_success("Basic import test passed")
        print(result.stdout.strip())
        return True
    except subprocess.CalledProcessError as e:
        print_error(f"Import test failed: {e}")
        print_error(f"Error output: {e.stderr}")
        return False

def create_activation_scripts():
    """Create platform-specific activation scripts"""
    print_status("Creating activation scripts...")
    
    # Windows batch file
    with open("activate_env.bat", "w") as f:
        f.write("@echo off\n")
        f.write("echo Activating Donut environment...\n")
        f.write("call donut_env\\Scripts\\activate.bat\n")
        f.write("echo Environment activated!\n")
        f.write("echo Run 'deactivate' to exit the environment\n")
    
    # Unix shell script
    with open("activate_env.sh", "w") as f:
        f.write("#!/bin/bash\n")
        f.write("echo 'Activating Donut environment...'\n")
        f.write("source donut_env/bin/activate\n")
        f.write("echo 'Environment activated!'\n")
        f.write("echo 'Run \"deactivate\" to exit the environment'\n")
    
    # Make shell script executable on Unix systems
    if platform.system().lower() != "windows":
        os.chmod("activate_env.sh", 0o755)
    
    print_success("Activation scripts created")

def main():
    """Main setup function"""
    print("🚀 Donut Project Setup")
    print("=" * 50)
    
    # Check prerequisites
    if not check_python_version():
        sys.exit(1)
    
    if not check_pip():
        sys.exit(1)
    
    # Create virtual environment
    if not create_virtual_environment():
        sys.exit(1)
    
    # Install dependencies
    if not install_dependencies():
        sys.exit(1)
    
    # Test installation
    if not test_installation():
        sys.exit(1)
    
    # Create activation scripts
    create_activation_scripts()
    
    print("\n" + "=" * 50)
    print_success("🎉 Setup completed successfully!")
    print("=" * 50)
    
    print("\n📋 Next Steps:")
    print("1. Activate the environment:")
    if platform.system().lower() == "windows":
        print("   .\\activate_env.bat")
        print("   # or")
        print("   .\\donut_env\\Scripts\\Activate.ps1")
    else:
        print("   source activate_env.sh")
        print("   # or")
        print("   source donut_env/bin/activate")
    
    print("\n2. Run the demo:")
    print("   python app.py --task cord-v2 --port 7860")
    
    print("\n3. Open your browser and go to:")
    print("   http://localhost:7860")
    
    print("\n📚 For more information, see SETUP.md")

if __name__ == "__main__":
    main() 