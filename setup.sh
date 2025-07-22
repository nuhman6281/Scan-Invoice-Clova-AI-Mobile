#!/bin/bash

# Donut Project Setup for macOS/Linux
# This script sets up the Donut project environment

set -e  # Exit on any error

echo "🚀 Donut Project Setup for macOS/Linux"
echo "================================================"

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

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    print_error "Python 3 is not installed"
    echo "Please install Python 3.7+ and try again"
    exit 1
fi

# Check Python version
python_version=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
required_version="3.7"

if [ "$(printf '%s\n' "$required_version" "$python_version" | sort -V | head -n1)" != "$required_version" ]; then
    print_error "Python 3.7+ is required. Current version: $python_version"
    exit 1
fi

print_success "Python $python_version detected"

# Check if pip is available
if ! python3 -m pip --version &> /dev/null; then
    print_error "pip is not available"
    exit 1
fi

print_success "pip is available"

# Create virtual environment if it doesn't exist
if [ ! -d "donut_env" ]; then
    print_status "Creating virtual environment..."
    python3 -m venv donut_env
    print_success "Virtual environment created"
else
    print_warning "Virtual environment already exists"
fi

# Activate virtual environment
print_status "Activating virtual environment..."
source donut_env/bin/activate

# Upgrade pip
print_status "Upgrading pip..."
python -m pip install --upgrade pip
print_success "pip upgraded"

# Install project in editable mode
print_status "Installing project in editable mode..."
pip install -e .
print_success "Project installed"

# Install additional dependencies
print_status "Installing additional dependencies..."
pip install gradio fastapi uvicorn python-multipart Pillow easyocr numpy structlog
print_success "Additional dependencies installed"

# Test installation
print_status "Testing installation..."
if python -c "import donut; print('✅ Donut imported successfully!')"; then
    print_success "Import test passed"
else
    print_error "Import test failed"
    exit 1
fi

# Create activation script
print_status "Creating activation script..."
cat > activate_env.sh << 'EOF'
#!/bin/bash
echo "Activating Donut environment..."
source donut_env/bin/activate
echo "Environment activated!"
echo 'Run "deactivate" to exit the environment'
EOF

chmod +x activate_env.sh
print_success "Activation script created"

echo ""
echo "================================================"
print_success "🎉 Setup completed successfully!"
echo "================================================"
echo ""
echo "📋 Next Steps:"
echo "1. Activate the environment:"
echo "   source activate_env.sh"
echo "   # or"
echo "   source donut_env/bin/activate"
echo ""
echo "2. Run the demo:"
echo "   python app.py --task cord-v2 --port 7860"
echo ""
echo "3. Open your browser and go to:"
echo "   http://localhost:7860"
echo ""
echo "📚 For more information, see SETUP.md"
echo "" 