#!/bin/bash

# Quick fix for Donut setup with Python 3.10
echo "🍩 Quick Fix: Setting up Donut with Python 3.10"

# Remove existing environment
if [ -d "donut_env" ]; then
    echo "Removing existing environment..."
    rm -rf donut_env
fi

# Create new environment with Python 3.10
echo "Creating new environment with Python 3.10..."
python3.10 -m venv donut_env

# Activate environment
echo "Activating environment..."
source donut_env/bin/activate

# Set environment variables
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"
export CMAKE_PREFIX_PATH="/opt/homebrew:$CMAKE_PREFIX_PATH"

# Upgrade pip
pip install --upgrade pip

# Install sentencepiece first
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

echo ""
echo "🎉 Setup complete! You can now run:"
echo "   source donut_env/bin/activate"
echo "   python app.py --task cord"
echo ""
