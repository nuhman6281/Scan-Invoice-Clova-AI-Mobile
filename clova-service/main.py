from fastapi import FastAPI, File, UploadFile, HTTPException, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import uvicorn
import os
import tempfile
import shutil
from typing import List, Optional
import logging

from models.invoice_processor import InvoiceProcessor
from models.clova_model_manager import ClovaModelManager
from utils.image_utils import preprocess_image
from utils.logger import setup_logger

# Setup logging
logger = setup_logger()

# Initialize FastAPI app
app = FastAPI(
    title="CLOVA AI Invoice Scanner Service",
    description="AI-powered invoice scanning service using CLOVA Donut and CRAFT models",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize model manager
model_manager = None
invoice_processor = None

@app.on_event("startup")
async def startup_event():
    """Initialize models on startup"""
    global model_manager, invoice_processor
    
    logger.info("Starting CLOVA AI Invoice Scanner Service...")
    
    try:
        # Initialize model manager
        model_manager = ClovaModelManager()
        logger.info("CLOVA Model Manager initialized successfully")
        
        # Initialize invoice processor
        invoice_processor = InvoiceProcessor(model_manager)
        logger.info("Invoice Processor initialized successfully")
        
        logger.info("Service startup completed successfully")
        
    except Exception as e:
        logger.error(f"Failed to initialize models: {str(e)}")
        raise e

@app.on_event("shutdown")
async def shutdown_event():
    """Cleanup on shutdown"""
    logger.info("Shutting down CLOVA AI Invoice Scanner Service...")

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    try:
        # Check if models are loaded
        models_loaded = model_manager is not None and invoice_processor is not None
        
        return {
            "status": "healthy" if models_loaded else "unhealthy",
            "models_loaded": models_loaded,
            "service": "clova-invoice-scanner",
            "version": "1.0.0"
        }
    except Exception as e:
        logger.error(f"Health check failed: {str(e)}")
        return {
            "status": "unhealthy",
            "error": str(e),
            "service": "clova-invoice-scanner"
        }

@app.post("/process-invoice")
async def process_invoice(file: UploadFile = File(...)):
    """
    Process an invoice image and extract items
    
    Args:
        file: Uploaded invoice image file
        
    Returns:
        JSON response with extracted items and metadata
    """
    try:
        # Validate file
        if not file.content_type.startswith('image/'):
            raise HTTPException(status_code=400, detail="File must be an image")
        
        if file.size > 10 * 1024 * 1024:  # 10MB limit
            raise HTTPException(status_code=400, detail="File size too large (max 10MB)")
        
        logger.info(f"Processing invoice: {file.filename}")
        
        # Save uploaded file temporarily
        with tempfile.NamedTemporaryFile(delete=False, suffix='.jpg') as temp_file:
            shutil.copyfileobj(file.file, temp_file)
            temp_path = temp_file.name
        
        try:
            # Preprocess image
            processed_path = preprocess_image(temp_path)
            
            # Process with CLOVA AI
            result = invoice_processor.process_invoice(processed_path)
            
            logger.info(f"Successfully processed invoice: {file.filename}")
            
            return {
                "success": True,
                "items": result.get("items", []),
                "metadata": {
                    "confidence": result.get("confidence", 0.0),
                    "processing_time": result.get("processing_time", 0.0),
                    "model_used": result.get("model_used", "unknown")
                }
            }
            
        finally:
            # Cleanup temporary files
            try:
                os.unlink(temp_path)
                if processed_path != temp_path:
                    os.unlink(processed_path)
            except Exception as e:
                logger.warning(f"Failed to cleanup temp files: {str(e)}")
                
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error processing invoice: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Failed to process invoice: {str(e)}")

@app.get("/models/status")
async def get_model_status():
    """Get status of loaded models"""
    try:
        if model_manager is None:
            return {
                "status": "not_initialized",
                "models": {}
            }
        
        return {
            "status": "loaded",
            "models": {
                "donut": model_manager.donut_model is not None,
                "craft": model_manager.craft_net is not None,
                "refine": model_manager.refine_net is not None
            }
        }
    except Exception as e:
        logger.error(f"Error getting model status: {str(e)}")
        return {
            "status": "error",
            "error": str(e)
        }

@app.post("/models/reload")
async def reload_models():
    """Reload all models (admin endpoint)"""
    try:
        global model_manager, invoice_processor
        
        logger.info("Reloading models...")
        
        # Reinitialize models
        model_manager = ClovaModelManager()
        invoice_processor = InvoiceProcessor(model_manager)
        
        logger.info("Models reloaded successfully")
        
        return {
            "success": True,
            "message": "Models reloaded successfully"
        }
    except Exception as e:
        logger.error(f"Error reloading models: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Failed to reload models: {str(e)}")

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=False,
        log_level="info"
    )