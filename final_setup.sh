#!/bin/bash

# Final Donut Setup Script - Handles all known issues
echo "🍩 Final Donut Setup Script"
echo "============================"

# Remove existing environment
if [ -d "donut_env" ]; then
    echo "Removing existing environment..."
    rm -rf donut_env
fi

# Install system dependencies
echo "Installing system dependencies..."
brew install libomp cmake protobuf sentencepiece

# Create new environment with Python 3.10
echo "Creating new environment with Python 3.10..."
python3.10 -m venv donut_env

# Activate environment
echo "Activating environment..."
source donut_env/bin/activate

# Set environment variables
export LDFLAGS="-L/opt/homebrew/opt/libomp/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libomp/include"
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"
export CMAKE_PREFIX_PATH="/opt/homebrew:$CMAKE_PREFIX_PATH"

# Upgrade pip
pip install --upgrade pip

# Install PyTorch first (CPU version to avoid CUDA issues)
echo "Installing PyTorch..."
pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu

# Install sentencepiece
echo "Installing sentencepiece..."
pip install sentencepiece

# Install donut-python
echo "Installing donut-python..."
pip install donut-python

# Install gradio
echo "Installing gradio..."
pip install gradio

# Test installation
echo "Testing installation..."
python -c "import donut; import sentencepiece; print('✅ All modules imported successfully!')"

# Create activation script with proper environment variables
cat >activate_donut.sh <<'EOF'
#!/bin/bash
echo "🍩 Activating Donut environment..."
source donut_env/bin/activate
export LDFLAGS="-L/opt/homebrew/opt/libomp/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libomp/include"
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"
export CMAKE_PREFIX_PATH="/opt/homebrew:$CMAKE_PREFIX_PATH"
echo "✅ Donut environment activated!"
echo "Run 'python app.py --task cord' to start the demo"
EOF

chmod +x activate_donut.sh

echo ""
echo "🎉 Setup complete! You can now run:"
echo "   ./activate_donut.sh"
echo "   python app.py --task cord"
echo ""
