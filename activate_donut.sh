#!/bin/bash
echo "🍩 Activating Donut environment..."
source donut_env/bin/activate
export LDFLAGS="-L/opt/homebrew/opt/libomp/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libomp/include"
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"
export CMAKE_PREFIX_PATH="/opt/homebrew:$CMAKE_PREFIX_PATH"
echo "✅ Donut environment activated!"
echo "Run 'python app.py --task cord' to start the demo"
