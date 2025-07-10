FROM python:3.9-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create necessary directories
RUN mkdir -p uploads models temp logs

# Copy application code
COPY . .

# Set environment variables
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1
ENV MODEL_CACHE_DIR=/app/models

# Create model download script
RUN echo '#!/bin/bash\n\
echo "Downloading CLOVA models..."\n\
python -c "from transformers import DonutProcessor, VisionEncoderDecoderModel; DonutProcessor.from_pretrained(\"naver-clova-ix/donut-base\"); VisionEncoderDecoderModel.from_pretrained(\"naver-clova-ix/donut-base-finetuned-cord-v2\")"\n\
echo "Models downloaded successfully"\n\
' > /app/download_models.sh && chmod +x /app/download_models.sh

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Download models and start server
CMD ["/bin/bash", "-c", "/app/download_models.sh && uvicorn main:app --host 0.0.0.0 --port 8000"]