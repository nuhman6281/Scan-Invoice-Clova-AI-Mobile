"""
Mock CLOVA AI Invoice Scanner Service
Simulates real AI processing with realistic invoice data
"""

import os
import time
import uuid
import json
import random
from pathlib import Path
from typing import Dict, Any, List

import uvicorn
from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

# Create FastAPI app
app = FastAPI(
    title="CLOVA AI Invoice Scanner (Mock)",
    description="Mock AI-powered invoice processing service simulating CLOVA Donut model",
    version="1.0.0",
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Sample invoice data for different scenarios
SAMPLE_INVOICES = {
    "receipt": {
        "items": [
            
        ],
        "total_amount": 0.00,
        "merchant": "",
        "confidence": 0.00
    },
}

@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": "CLOVA AI Invoice Scanner Service (Mock)",
        "version": "1.0.0",
        "status": "running",
        "model_loaded": True,
        "note": "This is a mock service simulating real AI processing"
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "timestamp": time.time(),
        "model_loaded": True,
        "device": "mock-cpu",
        "service": "clova-invoice-scanner-mock"
    }

@app.post("/process-invoice")
async def process_invoice(file: UploadFile = File(...)):
    """
    Process an invoice image using mock AI
    
    Args:
        file: Image file (JPEG, PNG, WebP)
    
    Returns:
        JSON with extracted items and metadata
    """
    start_time = time.time()
    
    try:
        # Validate file
        if not file.content_type.startswith('image/'):
            raise HTTPException(
                status_code=400, 
                detail="File must be an image (JPEG, PNG, WebP)"
            )
        
        # Simulate processing time
        processing_delay = random.uniform(1.0, 3.0)
        time.sleep(processing_delay)
        
        # Select random invoice type based on filename or random choice
        invoice_type = random.choice(list(SAMPLE_INVOICES.keys()))
        invoice_data = SAMPLE_INVOICES[invoice_type]
        
        # Add some randomness to make it more realistic
        items = []
        for item in invoice_data["items"]:
            # Add slight price variations
            price_variation = random.uniform(0.95, 1.05)
            adjusted_price = round(item["price"] * price_variation, 2)
            adjusted_total = round(adjusted_price * item["quantity"], 2)
            
            items.append({
                "name": item["name"],
                "price": adjusted_price,
                "quantity": item["quantity"],
                "total": adjusted_total,
                "confidence": random.uniform(0.85, 0.98)
            })
        
        # Recalculate total
        total_amount = sum(item["total"] for item in items)
        
        processing_time = time.time() - start_time
        
        return {
            "success": True,
            "scan_id": str(uuid.uuid4()),
            "items": items,
            "total_amount": round(total_amount, 2),
            "merchant": invoice_data["merchant"],
            "confidence_score": invoice_data["confidence"],
            "processing_time_ms": int(processing_time * 1000),
            "model_used": "donut-mock",
            "metadata": {
                "filename": file.filename,
                "file_size": len(await file.read()),
                "invoice_type": invoice_type,
                "items_detected": len(items),
                "processing_delay": processing_delay
            }
        }
        
    except Exception as e:
        processing_time = time.time() - start_time
        
        return {
            "success": False,
            "error": str(e),
            "processing_time_ms": int(processing_time * 1000)
        }

@app.get("/models/status")
async def get_models_status():
    """Get model status"""
    return {
        "donut": {
            "loaded": True,
            "device": "mock-cpu",
            "memory_usage": "0 MB",
            "last_used": time.time()
        },
        "craft": {
            "loaded": False,
            "device": None,
            "memory_usage": None,
            "last_used": None
        }
    }

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000) 