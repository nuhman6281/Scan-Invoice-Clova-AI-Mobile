"""
Real CLOVA AI Invoice Scanner Service
Uses actual Donut model for real AI-powered invoice processing
"""

import os
import io
import time
import uuid
import json
import asyncio
from pathlib import Path
from typing import Dict, Any, List, Optional

import uvicorn
from fastapi import FastAPI, File, UploadFile, HTTPException, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import structlog

# Real AI imports
from transformers import DonutProcessor, VisionEncoderDecoderModel
from PIL import Image
import torch
import numpy as np

# Setup logging
structlog.configure(
    processors=[
        structlog.stdlib.filter_by_level,
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.JSONRenderer()
    ],
    logger_factory=structlog.stdlib.LoggerFactory(),
    wrapper_class=structlog.stdlib.BoundLogger,
    cache_logger_on_first_use=True,
)

logger = structlog.get_logger()

# Create FastAPI app
app = FastAPI(
    title="Real CLOVA AI Invoice Scanner",
    description="AI-powered invoice processing using actual CLOVA Donut model",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Global variables for models
donut_processor = None
donut_model = None
device = None
model_loaded = False

class RealClovaProcessor:
    """Real CLOVA AI processor using Donut model"""
    
    def __init__(self):
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.processor = None
        self.model = None
        self.loaded = False
        
    async def initialize(self):
        """Initialize and load Donut model"""
        try:
            logger.info(f"Loading Donut model on device: {self.device}")
            
            # Load Donut processor and model
            self.processor = DonutProcessor.from_pretrained("naver-clova-ix/donut-base")
            self.model = VisionEncoderDecoderModel.from_pretrained("naver-clova-ix/donut-base-finetuned-cord-v2")
            
            # Move to device and set to eval mode
            self.model.to(self.device)
            self.model.eval()
            
            self.loaded = True
            logger.info("Donut model loaded successfully")
            
        except Exception as e:
            logger.error(f"Failed to load Donut model: {e}")
            raise
    
    async def process_invoice(self, image: Image.Image) -> Dict[str, Any]:
        """Process invoice image with real Donut model"""
        if not self.loaded:
            raise Exception("Model not loaded")
        
        try:
            # Prepare image for Donut
            pixel_values = self.processor(image, return_tensors="pt").pixel_values
            pixel_values = pixel_values.to(self.device)
            
            # Generate with task prompt for receipts
            task_prompt = "<s_cord-v2>"
            decoder_input_ids = self.processor.tokenizer(
                task_prompt, 
                add_special_tokens=False, 
                return_tensors="pt"
            ).input_ids.to(self.device)
            
            logger.info(f"Processing image with task prompt: {task_prompt}")
            
            # Generate prediction
            with torch.no_grad():
                try:
                    outputs = self.model.generate(
                        pixel_values,
                        decoder_input_ids=decoder_input_ids,
                        max_length=512,
                        pad_token_id=self.processor.tokenizer.pad_token_id,
                        eos_token_id=self.processor.tokenizer.eos_token_id,
                        use_cache=True,
                        do_sample=False,
                        num_beams=1
                    )
                except Exception as gen_error:
                    logger.error(f"Model generation failed: {gen_error}")
                    # Return a fallback result
                    return {
                        "items": [],
                        "total_amount": 0.0,
                        "confidence_score": 0.0,
                        "error": f"Model generation failed: {str(gen_error)}"
                    }
            
            # Decode result
            try:
                sequence = self.processor.batch_decode(outputs, skip_special_tokens=True)[0]
            except Exception as decode_error:
                logger.error(f"Failed to decode model output: {decode_error}")
                return {
                    "items": [],
                    "total_amount": 0.0,
                    "confidence_score": 0.0,
                    "error": f"Failed to decode model output: {str(decode_error)}"
                }
            
            # Log the raw output for debugging
            logger.info(f"Raw Donut model output: '{sequence}'")
            logger.info(f"Output length: {len(sequence)}")
            logger.info(f"Output type: {type(sequence)}")
            
            # Parse the result
            result = self._parse_donut_output(sequence)
            
            # Log the parsed result
            logger.info(f"Parsed result: {result}")
            
            return result
            
        except Exception as e:
            logger.error(f"Donut processing failed: {e}")
            raise
    
    def _parse_donut_output(self, sequence: str) -> Dict[str, Any]:
        """Parse Donut model output into structured data"""
        try:
            logger.info(f"Starting to parse sequence: '{sequence}'")
            
            # Remove task prompt
            if sequence.startswith("<s_cord-v2>"):
                sequence = sequence[len("<s_cord-v2>"):]
                logger.info(f"Removed task prompt, remaining: '{sequence}'")
            
            # Clean up the sequence
            sequence = sequence.strip()
            logger.info(f"After stripping: '{sequence}'")
            
            # If sequence is empty or just dashes, return empty result
            if not sequence or sequence.replace("-", "").strip() == "":
                logger.warning("Sequence is empty or contains only dashes")
                return {
                    "items": [],
                    "total_amount": 0.0,
                    "confidence_score": 0.0,
                    "error": "No content extracted from image"
                }
            
            # Try to find JSON content in the sequence
            # Look for JSON-like patterns
            json_start = sequence.find('{')
            json_end = sequence.rfind('}')
            
            if json_start != -1 and json_end != -1 and json_end > json_start:
                json_content = sequence[json_start:json_end + 1]
                logger.info(f"Extracted JSON content: '{json_content}'")
                
                try:
                    data = json.loads(json_content)
                    logger.info(f"Successfully parsed JSON: {data}")
                    return self._extract_items_from_json(data)
                except json.JSONDecodeError as e:
                    logger.warning(f"JSON parsing failed for extracted content: {e}")
                    # Continue to text parsing fallback
            
            # If no JSON found or JSON parsing failed, try parsing as text
            logger.info("Attempting text parsing...")
            return self._extract_items_from_text(sequence)
                
        except Exception as e:
            logger.error(f"Failed to parse Donut output: {e}")
            return {
                "items": [],
                "total_amount": 0.0,
                "confidence_score": 0.0,
                "error": str(e)
            }
    
    def _extract_items_from_json(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """Extract items from JSON structure"""
        items = []
        total_amount = 0.0
        
        # Extract menu items
        if "menu" in data:
            for item in data["menu"]:
                name = item.get("nm", "Unknown Item")
                price = float(item.get("price", 0).replace("Rp. ", "").replace(",", ""))
                quantity = int(item.get("cnt", 1))
                item_total = price * quantity
                
                items.append({
                    "name": name,
                    "price": price,
                    "quantity": quantity,
                    "total": item_total
                })
                total_amount += item_total
        
        # Extract total from total section
        if "total" in data and "total_price" in data["total"]:
            total_str = data["total"]["total_price"]
            if isinstance(total_str, str):
                total_amount = float(total_str.replace("Rp. ", "").replace(",", ""))
        
        return {
            "items": items,
            "total_amount": total_amount,
            "confidence_score": 0.9,  # High confidence for successful parsing
            "raw_data": data
        }
    
    def _extract_items_from_text(self, text: str) -> Dict[str, Any]:
        """Extract items from text output"""
        # Simple text parsing fallback
        lines = text.split('\n')
        items = []
        total_amount = 0.0
        
        # Common price patterns
        price_patterns = [
            r'(\d+\.?\d*)',  # Basic numbers
            r'(\d+,\d+)',    # Numbers with commas
            r'(\d+\.\d{2})', # Decimal prices
        ]
        
        for line in lines:
            line = line.strip()
            if not line:
                continue
                
            # Skip lines that are likely headers or totals
            if any(keyword in line.lower() for keyword in ['total', 'subtotal', 'tax', 'amount', 'sum']):
                # Try to extract total amount
                import re
                for pattern in price_patterns:
                    matches = re.findall(pattern, line)
                    if matches:
                        try:
                            # Take the last number as it's likely the total
                            total_str = matches[-1].replace(',', '')
                            total_amount = float(total_str)
                            logger.info(f"Found total amount: {total_amount} from line: {line}")
                            break
                        except ValueError:
                            continue
                continue
            
            # Try to extract item and price
            if any(char.isdigit() for char in line):
                # Look for price at the end of line
                parts = line.split()
                if len(parts) >= 2:
                    # Try to find price (usually at the end)
                    for i in range(len(parts) - 1, -1, -1):
                        part = parts[i].replace(',', '').replace('$', '').replace('€', '').replace('£', '')
                        if part.replace('.', '').isdigit():
                            try:
                                price = float(part)
                                name = ' '.join(parts[:i])
                                if name and len(name.strip()) > 0:
                                    items.append({
                                        "name": name.strip(),
                                        "price": price,
                                        "quantity": 1,
                                        "total": price
                                    })
                                    logger.info(f"Extracted item: {name.strip()} - ${price}")
                                    break
                            except ValueError:
                                continue
        
        # If no items found but we have text, create a generic item
        if not items and text.strip():
            items.append({
                "name": "Extracted Content",
                "price": 0.0,
                "quantity": 1,
                "total": 0.0,
                "raw_text": text[:200] + "..." if len(text) > 200 else text
            })
        
        return {
            "items": items,
            "total_amount": total_amount,
            "confidence_score": 0.6,  # Lower confidence for text parsing
            "raw_text": text
        }

# Initialize processor
clova_processor = RealClovaProcessor()

@app.on_event("startup")
async def startup_event():
    """Initialize services on startup"""
    global model_loaded
    
    try:
        logger.info("Starting Real CLOVA AI Invoice Scanner Service")
        
        # Initialize CLOVA processor
        await clova_processor.initialize()
        model_loaded = True
        
        logger.info("Real CLOVA AI service initialized successfully")
        
    except Exception as e:
        logger.error(f"Failed to initialize services: {e}")
        model_loaded = False

@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": "Real CLOVA AI Invoice Scanner Service",
        "version": "1.0.0",
        "status": "running",
        "model_loaded": model_loaded
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    try:
        return {
            "status": "healthy" if model_loaded else "unhealthy",
            "timestamp": time.time(),
            "model_loaded": model_loaded,
            "device": str(clova_processor.device) if clova_processor else "unknown",
            "service": "real-clova-invoice-scanner"
        }
    except Exception as e:
        logger.error(f"Health check failed: {e}")
        raise HTTPException(status_code=503, detail="Service unhealthy")

@app.post("/process-invoice")
async def process_invoice(
    background_tasks: BackgroundTasks,
    file: UploadFile = File(...)
):
    """
    Process an invoice image using real CLOVA AI Donut model
    
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
        
        if not model_loaded:
            raise HTTPException(
                status_code=503,
                detail="AI model not loaded. Service is starting up."
            )
        
        logger.info(f"Processing invoice with real CLOVA AI: {file.filename}")
        
        # Read and process image
        image_data = await file.read()
        image = Image.open(io.BytesIO(image_data))
        
        # Process with real CLOVA AI
        result = await clova_processor.process_invoice(image)
        
        processing_time = time.time() - start_time
        
        return {
            "success": True,
            "scan_id": str(uuid.uuid4()),
            "items": result.get("items", []),
            "total_amount": result.get("total_amount"),
            "confidence_score": result.get("confidence_score"),
            "processing_time_ms": int(processing_time * 1000),
            "model_used": "donut-real",
            "metadata": {
                "filename": file.filename,
                "file_size": len(image_data),
                "image_size": image.size,
                "device": str(clova_processor.device),
                "raw_output": result.get("raw_data") or result.get("raw_text")
            }
        }
        
    except Exception as e:
        logger.error(f"Failed to process invoice: {e}")
        processing_time = time.time() - start_time
        
        return {
            "success": False,
            "error": str(e),
            "processing_time_ms": int(processing_time * 1000)
        }

@app.get("/models/status")
async def get_models_status():
    """Get status of loaded AI models"""
    try:
        return {
            "success": True,
            "models": {
                "donut": {
                    "loaded": model_loaded,
                    "device": str(clova_processor.device) if clova_processor else "unknown",
                    "model_name": "naver-clova-ix/donut-base-finetuned-cord-v2"
                }
            }
        }
    except Exception as e:
        logger.error(f"Failed to get models status: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.exception_handler(Exception)
async def global_exception_handler(request, exc):
    """Global exception handler"""
    logger.error(f"Unhandled exception: {exc}")
    return JSONResponse(
        status_code=500,
        content={"error": "Internal server error", "detail": str(exc)}
    )

if __name__ == "__main__":
    uvicorn.run(
        "real_clova_service:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    ) 