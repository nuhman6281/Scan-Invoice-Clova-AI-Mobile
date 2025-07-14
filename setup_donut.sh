#!/bin/bash

# Donut Project Setup Script
# This script sets up the Donut document understanding transformer project

set -e # Exit on any error

echo "🍩 Donut Project Setup Script"
echo "=============================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "README.md" ] || [ ! -f "app.py" ]; then
    print_error "Please run this script from the donut project root directory"
    exit 1
fi

print_step "1. Checking system requirements..."

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
    print_error "Homebrew is not installed. Please install it first:"
    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

# Check Python versions available
print_status "Checking available Python versions..."

PYTHON_VERSIONS=("3.11" "3.10" "3.9" "3.8")
SELECTED_PYTHON=""

for version in "${PYTHON_VERSIONS[@]}"; do
    if command -v "python${version}" &>/dev/null; then
        print_status "Found Python ${version}"
        if [ -z "$SELECTED_PYTHON" ]; then
            SELECTED_PYTHON="python${version}"
        fi
    fi
done

if [ -z "$SELECTED_PYTHON" ]; then
    print_warning "No compatible Python version found. Installing Python 3.11..."
    brew install python@3.11
    SELECTED_PYTHON="python3.11"
fi

print_status "Using Python: $SELECTED_PYTHON"

# Check if sentencepiece is installed
if brew list sentencepiece &>/dev/null; then
    print_status "sentencepiece is already installed via Homebrew"
else
    print_warning "Installing sentencepiece..."
    brew install sentencepiece
fi

# Install other system dependencies
print_step "2. Installing system dependencies..."

print_status "Installing cmake..."
brew install cmake

print_status "Installing protobuf..."
brew install protobuf

print_step "3. Setting up Python environment..."

# Remove existing environment if it exists
if [ -d "donut_env" ]; then
    print_warning "Removing existing virtual environment..."
    rm -rf donut_env
fi

# Create new virtual environment
print_status "Creating virtual environment with $SELECTED_PYTHON..."
$SELECTED_PYTHON -m venv donut_env

# Activate virtual environment
print_status "Activating virtual environment..."
source donut_env/bin/activate

# Upgrade pip
print_status "Upgrading pip..."
pip install --upgrade pip

# Set environment variables for sentencepiece
print_status "Setting up environment variables for sentencepiece..."
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"
export CMAKE_PREFIX_PATH="/opt/homebrew:$CMAKE_PREFIX_PATH"

print_step "4. Installing Python dependencies..."

# Install sentencepiece first
print_status "Installing sentencepiece..."
pip install sentencepiece

# Install donut-python
print_status "Installing donut-python..."
pip install donut-python

# Install additional dependencies
print_status "Installing additional dependencies..."
pip install gradio

print_step "5. Testing installation..."

# Test if everything works
print_status "Testing donut module import..."
python -c "import donut; print('✅ Donut module imported successfully')"

print_status "Testing sentencepiece import..."
python -c "import sentencepiece; print('✅ Sentencepiece module imported successfully')"

print_step "6. Setup complete!"

echo ""
echo "🎉 Donut project setup completed successfully!"
echo ""
echo "📋 Next steps:"
echo "   1. Activate the environment: source donut_env/bin/activate"
echo "   2. Run the demo: python app.py --task cord"
echo "   3. Or try: python simple_demo.py"
echo ""
echo "🔗 Available tasks:"
echo "   - cord: Document parsing (receipts, invoices)"
echo "   - rvlcdip: Document classification"
echo "   - docvqa: Document question answering"
echo "   - zhtrainticket: Chinese train ticket parsing"
echo ""
echo "📁 Sample images available in misc/ directory"
echo ""

# Create activation script
cat >activate_donut.sh <<'EOF'
#!/bin/bash
echo "🍩 Activating Donut environment..."
source donut_env/bin/activate
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"
export CMAKE_PREFIX_PATH="/opt/homebrew:$CMAKE_PREFIX_PATH"
echo "✅ Donut environment activated!"
echo "Run 'python app.py --task cord' to start the demo"
EOF

chmod +x activate_donut.sh

print_status "Created activate_donut.sh script for easy environment activation"
print_status "Run './activate_donut.sh' to activate the environment"

echo ""
echo "🚀 Ready to use Donut! 🍩"
