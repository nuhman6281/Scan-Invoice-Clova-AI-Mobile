"""
CLOVA AI Invoice Scanner Service
Main FastAPI application for invoice processing with CLOVA AI models
"""

import os
import time
import asyncio
from pathlib import Path
from typing import Optional, Dict, Any, List

import uvicorn
from fastapi import FastAPI, File, UploadFile, HTTPException, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.gzip import GZipMiddleware
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
import structlog

from app.config import settings
from app.models.invoice import InvoiceRequest, InvoiceResponse, ProcessingStatus
from app.services.clova_processor import ClovaProcessor
from app.services.image_service import ImageService
from app.utils.logger import setup_logging
from app.utils.metrics import setup_metrics

# Setup logging
setup_logging()
logger = structlog.get_logger()

# Create FastAPI app
app = FastAPI(
    title="CLOVA AI Invoice Scanner",
    description="AI-powered invoice processing service using CLOVA Donut and CRAFT models",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

# Add middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.add_middleware(GZipMiddleware, minimum_size=1000)

# Setup metrics
setup_metrics(app)

# Initialize services
clova_processor = ClovaProcessor()
image_service = ImageService()

# Mount static files
if os.path.exists("uploads"):
    app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")

@app.on_event("startup")
async def startup_event():
    """Initialize services on startup"""
    logger.info("Starting CLOVA AI Invoice Scanner Service")
    
    try:
        # Initialize CLOVA processor
        await clova_processor.initialize()
        logger.info("CLOVA processor initialized successfully")
        
        # Create upload directory
        Path(settings.UPLOAD_DIR).mkdir(parents=True, exist_ok=True)
        logger.info(f"Upload directory ready: {settings.UPLOAD_DIR}")
        
    except Exception as e:
        logger.error(f"Failed to initialize services: {e}")
        raise

@app.on_event("shutdown")
async def shutdown_event():
    """Cleanup on shutdown"""
    logger.info("Shutting down CLOVA AI Invoice Scanner Service")
    await clova_processor.cleanup()

@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": "CLOVA AI Invoice Scanner Service",
        "version": "1.0.0",
        "status": "running"
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    try:
        # Check if models are loaded
        models_status = await clova_processor.get_models_status()
        
        return {
            "status": "healthy",
            "timestamp": time.time(),
            "models": models_status,
            "service": "clova-invoice-scanner"
        }
    except Exception as e:
        logger.error(f"Health check failed: {e}")
        raise HTTPException(status_code=503, detail="Service unhealthy")

@app.post("/process-invoice", response_model=InvoiceResponse)
async def process_invoice(
    background_tasks: BackgroundTasks,
    file: UploadFile = File(...),
    confidence_threshold: Optional[float] = 0.7,
    use_fallback: Optional[bool] = True
):
    """
    Process an invoice image using CLOVA AI models
    
    Args:
        file: Image file (JPEG, PNG, WebP)
        confidence_threshold: Minimum confidence score (0.0-1.0)
        use_fallback: Whether to use CRAFT fallback for low confidence
    
    Returns:
        InvoiceResponse with extracted items and metadata
    """
    start_time = time.time()
    
    try:
        # Validate file
        if not file.content_type.startswith('image/'):
            raise HTTPException(
                status_code=400, 
                detail="File must be an image (JPEG, PNG, WebP)"
            )
        
        logger.info(f"Processing invoice: {file.filename}")
        
        # Save uploaded file
        file_path = await image_service.save_upload(file)
        
        # Process with CLOVA AI
        result = await clova_processor.process_invoice(
            file_path=file_path,
            confidence_threshold=confidence_threshold,
            use_fallback=use_fallback
        )
        
        processing_time = time.time() - start_time
        
        # Add cleanup task
        background_tasks.add_task(image_service.cleanup_temp_file, file_path)
        
        return InvoiceResponse(
            success=True,
            scan_id=result.get("scan_id"),
            items=result.get("items", []),
            total_amount=result.get("total_amount"),
            confidence_score=result.get("confidence_score"),
            processing_time_ms=int(processing_time * 1000),
            model_used=result.get("model_used"),
            metadata=result.get("metadata", {})
        )
        
    except Exception as e:
        logger.error(f"Failed to process invoice: {e}")
        processing_time = time.time() - start_time
        
        return InvoiceResponse(
            success=False,
            error=str(e),
            processing_time_ms=int(processing_time * 1000)
        )

@app.post("/process-invoice-advanced", response_model=InvoiceResponse)
async def process_invoice_advanced(
    request: InvoiceRequest,
    background_tasks: BackgroundTasks
):
    """
    Advanced invoice processing with additional options
    
    Args:
        request: InvoiceRequest with image data and processing options
    
    Returns:
        InvoiceResponse with extracted items and metadata
    """
    start_time = time.time()
    
    try:
        logger.info("Processing invoice with advanced options")
        
        # Save image from base64 or URL
        file_path = await image_service.save_from_request(request)
        
        # Process with advanced options
        result = await clova_processor.process_invoice_advanced(
            file_path=file_path,
            options=request.options
        )
        
        processing_time = time.time() - start_time
        
        # Add cleanup task
        background_tasks.add_task(image_service.cleanup_temp_file, file_path)
        
        return InvoiceResponse(
            success=True,
            scan_id=result.get("scan_id"),
            items=result.get("items", []),
            total_amount=result.get("total_amount"),
            confidence_score=result.get("confidence_score"),
            processing_time_ms=int(processing_time * 1000),
            model_used=result.get("model_used"),
            metadata=result.get("metadata", {})
        )
        
    except Exception as e:
        logger.error(f"Failed to process invoice with advanced options: {e}")
        processing_time = time.time() - start_time
        
        return InvoiceResponse(
            success=False,
            error=str(e),
            processing_time_ms=int(processing_time * 1000)
        )

@app.get("/models/status")
async def get_models_status():
    """Get status of loaded AI models"""
    try:
        status = await clova_processor.get_models_status()
        return {
            "success": True,
            "models": status
        }
    except Exception as e:
        logger.error(f"Failed to get models status: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/models/reload")
async def reload_models():
    """Reload AI models (admin only)"""
    try:
        await clova_processor.reload_models()
        return {
            "success": True,
            "message": "Models reloaded successfully"
        }
    except Exception as e:
        logger.error(f"Failed to reload models: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/metrics")
async def get_metrics():
    """Get service metrics"""
    try:
        metrics = await clova_processor.get_metrics()
        return {
            "success": True,
            "metrics": metrics
        }
    except Exception as e:
        logger.error(f"Failed to get metrics: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.exception_handler(Exception)
async def global_exception_handler(request, exc):
    """Global exception handler"""
    logger.error(f"Unhandled exception: {exc}", exc_info=True)
    return JSONResponse(
        status_code=500,
        content={
            "success": False,
            "error": "Internal server error",
            "message": str(exc) if settings.DEBUG else "An unexpected error occurred"
        }
    )

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host=settings.HOST,
        port=settings.PORT,
        reload=settings.DEBUG,
        workers=settings.WORKERS,
        log_level="info"
    ) 