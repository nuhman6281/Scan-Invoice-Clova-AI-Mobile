#!/bin/bash

# Start Real CLOVA AI Invoice Scanner Service
# This script starts the real CLOVA AI service using the Donut model

set -e

echo "🚀 Starting Real CLOVA AI Invoice Scanner Service..."

# Check if we're in the right directory
if [ ! -f "real_clova_service.py" ]; then
    echo "❌ Error: real_clova_service.py not found in current directory"
    echo "Please run this script from the clova-service directory"
    exit 1
fi

# Activate Python environment
if [ -f "../../donut_env/bin/activate" ]; then
    echo "📦 Activating Python environment..."
    source ../../donut_env/bin/activate
else
    echo "⚠️  Warning: Python environment not found, using system Python"
fi

# Check Python and dependencies
echo "🔍 Checking Python environment..."
python -c "import torch; print(f'PyTorch: {torch.__version__}')"
python -c "import transformers; print(f'Transformers: {transformers.__version__}')"
python -c "from transformers import DonutProcessor; print('✅ DonutProcessor available')"

# Create uploads directory
mkdir -p uploads

# Start the real CLOVA service
echo "🤖 Starting Real CLOVA AI Service..."
echo "📍 Service will be available at: http://localhost:8000"
echo "📚 API Documentation: http://localhost:8000/docs"
echo "🔍 Health Check: http://localhost:8000/health"
echo ""
echo "⏳ Loading Donut model (this may take 1-2 minutes on first run)..."
echo ""

# Run the service
python real_clova_service.py
