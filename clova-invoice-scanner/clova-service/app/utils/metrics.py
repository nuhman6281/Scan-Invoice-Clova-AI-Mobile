"""
Metrics and monitoring utilities
"""

from prometheus_client import Counter, Histogram, Gauge, generate_latest
from fastapi import FastAPI

# Define metrics
REQUEST_COUNT = Counter(
    'clova_invoice_requests_total',
    'Total number of invoice processing requests',
    ['method', 'endpoint', 'status']
)

REQUEST_DURATION = Histogram(
    'clova_invoice_request_duration_seconds',
    'Request duration in seconds',
    ['method', 'endpoint']
)

PROCESSING_DURATION = Histogram(
    'clova_invoice_processing_duration_seconds',
    'Invoice processing duration in seconds',
    ['model_used']
)

MODEL_LOAD_STATUS = Gauge(
    'clova_model_loaded',
    'Model loading status (1=loaded, 0=not_loaded)',
    ['model_name']
)

def setup_metrics(app: FastAPI):
    """Setup metrics endpoints"""
    
    @app.get("/metrics")
    async def metrics():
        """Prometheus metrics endpoint"""
        return generate_latest() 