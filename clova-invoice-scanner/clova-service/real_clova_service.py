"""
Real CLOVA AI Invoice Scanner Service
Uses actual Donut model for real AI-powered invoice processing
"""

import asyncio
import io
import json
import math
import os
import time
import uuid
from typing import Any, Dict, List, Optional

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
from donut import DonutModel

# Setup logging
structlog.configure(
    processors=[
        structlog.stdlib.filter_by_level,
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.format_exc_info,
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
            
            # Load Donut model using the same approach as the root project
            self.model = DonutModel.from_pretrained(
                "naver-clova-ix/donut-base-finetuned-cord-v2",
                ignore_mismatched_sizes=True  # Handle weight mismatches
            )
            
            # Move to device and set to eval mode
            if torch.cuda.is_available():
                self.model.half()
                self.model.to(self.device)
            
            self.model.eval()
            
            self.loaded = True
            logger.info("Donut model loaded successfully")
            
        except Exception as e:
            logger.error(f"Failed to load Donut model: {e}")
            raise
    
    async def process_invoice(self, image: Image.Image) -> Dict[str, Any]:
        """Process invoice image with real Donut model"""
        print("=== STARTING INVOICE PROCESSING ===")
        logger.info("=== STARTING INVOICE PROCESSING ===")
        
        if not self.loaded:
            logger.error("Model not loaded - cannot process invoice")
            raise Exception("Model not loaded")
        
        logger.info(f"Model loaded successfully on device: {self.device}")
        
        try:
            # Prepare image for Donut
            logger.info("Preparing image for Donut processing...")
            logger.info(f"Input image size: {image.size}")
            logger.info(f"Input image mode: {image.mode}")
            
            # Use the same approach as the root project - DonutModel.inference()
            task_prompt = "<s_cord-v2>"
            logger.info(f"Using task prompt: '{task_prompt}'")
            
            # Generate prediction using DonutModel.inference()
            logger.info("Starting model inference...")
            try:
                result = self.model.inference(image=image, prompt=task_prompt)
                sequence = result["predictions"][0]
                logger.info(f"Model inference completed successfully")
                logger.info(f"Raw output: '{sequence}'")
                
            except Exception as gen_error:
                logger.error(f"Model inference failed: {gen_error}")
                logger.error(f"Error type: {type(gen_error)}")
                logger.error(f"Error details: {str(gen_error)}")
                # Return a fallback result
                return {
                    "items": [],
                    "total_amount": 0.0,
                    "confidence_score": 0.0,
                    "error": f"Model inference failed: {str(gen_error)}"
                }
            
            # Log the raw output for debugging
            print("=== RAW MODEL OUTPUT ANALYSIS ===")
            logger.info("=== RAW MODEL OUTPUT ANALYSIS ===")
            print(f"Raw Donut model output: {sequence}")
            logger.info(f"Raw Donut model output: {sequence}")
            print(f"Output type: {type(sequence)}")
            logger.info(f"Output type: {type(sequence)}")
            
            # Handle different output types
            if isinstance(sequence, dict):
                logger.info("Output is a dictionary - parsing directly")
                logger.info(f"Dictionary keys: {list(sequence.keys())}")
            elif isinstance(sequence, str):
                logger.info("Output is a string - parsing as text")
                logger.info(f"String length: {len(sequence)}")
                if len(sequence) > 0:
                    logger.info("First 100 characters:")
                    logger.info(f"'{sequence[:100]}'")
                    
                    if len(sequence) > 100:
                        logger.info("Characters 100-200:")
                        logger.info(f"'{sequence[100:200]}'")
                    
                    # Split by lines if there are newlines
                    if '\n' in sequence:
                        lines = sequence.split('\n')
                        logger.info(f"Output contains {len(lines)} lines:")
                        for i, line in enumerate(lines[:10]):  # Log first 10 lines
                            logger.info(f"Line {i+1}: '{line}'")
                        if len(lines) > 10:
                            logger.info(f"... and {len(lines) - 10} more lines")
                    else:
                        logger.info("Output is a single line (no newlines found)")
                else:
                    logger.warning("Output string is empty!")
            else:
                logger.warning(f"Unexpected output type: {type(sequence)}")
                logger.info(f"Output value: {sequence}")
            
            # Parse the result
            logger.info("=== PARSING MODEL OUTPUT ===")
            if isinstance(sequence, dict):
                # Direct dictionary parsing
                result = self._extract_items_from_json(sequence)
                result["extraction_method"] = "donut_direct"
            else:
                # String parsing (fallback)
                result = self._parse_donut_output(sequence)
            
            # If Donut failed to extract structured items, try OCR fallback
            logger.info("=== EXTRACTION METHOD SELECTION ===")
            if not result.get("items") and not result.get("error"):
                logger.info("Donut failed to extract structured items, trying OCR fallback...")
                ocr_result = await self._ocr_fallback(image)
                if ocr_result.get("items"):
                    logger.info("OCR fallback found items, using OCR result")
                    result = ocr_result
                    result["extraction_method"] = "ocr_fallback"
                else:
                    logger.info("OCR fallback also failed, using donut-only result")
                    result["extraction_method"] = "donut_only"
            else:
                logger.info("Donut successfully extracted items, using donut result")
                result["extraction_method"] = "donut"
            
            # Log the parsed result
            logger.info("=== FINAL PARSED RESULT ===")
            logger.info(f"Extraction method: {result.get('extraction_method', 'unknown')}")
            logger.info(f"Number of items found: {len(result.get('items', []))}")
            logger.info(f"Total amount: {result.get('total_amount', 0.0)}")
            logger.info(f"Confidence score: {result.get('confidence_score', 0.0)}")
            logger.info(f"Full parsed result: {result}")
            
            logger.info("=== INVOICE PROCESSING COMPLETED ===")
            return result
            
        except Exception as e:
            logger.error("=== INVOICE PROCESSING FAILED ===")
            logger.error(f"Donut processing failed: {e}")
            logger.error(f"Exception type: {type(e)}")
            logger.error(f"Exception details: {str(e)}")
            raise
    
    def _parse_donut_output(self, sequence: str) -> Dict[str, Any]:
        """Parse Donut model output into structured data"""
        logger.info("=== PARSING DONUT OUTPUT ===")
        try:
            logger.info(f"Input sequence length: {len(sequence)}")
            logger.info(f"Input sequence: '{sequence}'")
            
            # Remove task prompt
            if sequence.startswith("<s_cord-v2>"):
                sequence = sequence[len("<s_cord-v2>"):]
                logger.info(f"Removed task prompt, remaining length: {len(sequence)}")
                logger.info(f"Remaining sequence: '{sequence}'")
            elif sequence.startswith("<s_cord>"):
                sequence = sequence[len("<s_cord>"):]
                logger.info(f"Removed old task prompt, remaining length: {len(sequence)}")
                logger.info(f"Remaining sequence: '{sequence}'")
            else:
                logger.info("No task prompt found at start of sequence")
            
            # Clean up the sequence
            original_sequence = sequence
            sequence = sequence.strip()
            logger.info(f"After stripping whitespace:")
            logger.info(f"  Original length: {len(original_sequence)}")
            logger.info(f"  Stripped length: {len(sequence)}")
            logger.info(f"  Stripped sequence: '{sequence}'")
            
            # If sequence is empty or just dashes, return empty result
            if not sequence:
                logger.warning("Sequence is empty after stripping")
                return {
                    "items": [],
                    "total_amount": 0.0,
                    "confidence_score": 0.0,
                    "error": "No content extracted from image"
                }
            
            if sequence.replace("-", "").strip() == "":
                logger.warning("Sequence contains only dashes")
                return {
                    "items": [],
                    "total_amount": 0.0,
                    "confidence_score": 0.0,
                    "error": "No meaningful content extracted from image"
                }
            
            # Try to find JSON content in the sequence
            logger.info("=== JSON EXTRACTION ATTEMPT ===")
            json_start = sequence.find('{')
            json_end = sequence.rfind('}')
            
            logger.info(f"JSON start position: {json_start}")
            logger.info(f"JSON end position: {json_end}")
            
            if json_start != -1 and json_end != -1 and json_end > json_start:
                json_content = sequence[json_start:json_end + 1]
                logger.info(f"Extracted JSON content length: {len(json_content)}")
                logger.info(f"Extracted JSON content: '{json_content}'")
                
                try:
                    data = json.loads(json_content)
                    logger.info(f"Successfully parsed JSON: {data}")
                    logger.info("Calling _extract_items_from_json...")
                    result = self._extract_items_from_json(data)
                    logger.info(f"JSON extraction result: {result}")
                    return result
                except json.JSONDecodeError as e:
                    logger.warning(f"JSON parsing failed for extracted content: {e}")
                    logger.warning(f"JSON decode error type: {type(e)}")
                    logger.warning(f"JSON decode error details: {str(e)}")
                    # Continue to text parsing fallback
            else:
                logger.info("No JSON content found in sequence")
            
            # If no JSON found or JSON parsing failed, try parsing as text
            logger.info("=== TEXT PARSING ATTEMPT ===")
            logger.info("Attempting text parsing...")
            result = self._extract_items_from_text(sequence)
            logger.info(f"Text parsing result: {result}")
            return result
                
        except Exception as e:
            logger.error("=== PARSING FAILED ===")
            logger.error(f"Failed to parse Donut output: {e}")
            logger.error(f"Exception type: {type(e)}")
            logger.error(f"Exception details: {str(e)}")
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
                try:
                    name = item.get("nm", "Unknown Item")
                    
                    # Skip header items (store names, titles, etc.)
                    if any(keyword in name.upper() for keyword in ['STORES', 'NAME', 'RATE', 'TOTAL', 'QTY']):
                        continue
                    
                    # Handle price extraction with validation
                    price_str = item.get("price", "0")
                    if isinstance(price_str, str):
                        # Clean the price string
                        price_str = price_str.replace("Rp. ", "").replace(",", "").replace(" ", "")
                        
                        # Skip if it's not a valid number (like time, date, etc.)
                        if not price_str.replace(".", "").replace("-", "").isdigit():
                            continue
                        
                        try:
                            price = float(price_str)
                        except ValueError:
                            continue
                    else:
                        price = float(price_str)
                    
                    # Handle quantity extraction with validation
                    cnt = item.get("cnt", 1)
                    if isinstance(cnt, dict):
                        # If cnt is a dict, try to extract from unitprice or default to 1
                        quantity = 1
                    elif isinstance(cnt, str):
                        # Clean quantity string
                        cnt_str = cnt.replace(",", "").replace(" ", "")
                        if cnt_str.replace(".", "").isdigit():
                            quantity = int(float(cnt_str))
                        else:
                            quantity = 1
                    else:
                        quantity = int(cnt)
                    
                    # Only add items with valid prices
                    if price > 0:
                        item_total = price * quantity
                        
                        items.append({
                            "name": name,
                            "price": price,
                            "quantity": quantity,
                            "total": item_total
                        })
                        total_amount += item_total
                        
                except (ValueError, TypeError) as e:
                    logger.warning(f"Skipping invalid item: {item}, error: {e}")
                    continue
        
        # Extract total from total section
        if "total" in data and "total_price" in data["total"]:
            total_str = data["total"]["total_price"]
            if isinstance(total_str, str):
                try:
                    total_str = total_str.replace("Rp. ", "").replace(",", "").replace(" ", "")
                    if total_str.replace(".", "").isdigit():
                        total_amount = float(total_str)
                except ValueError:
                    pass  # Keep the calculated total_amount if parsing fails
        
        return {
            "items": items,
            "total_amount": total_amount,
            "confidence_score": 0.9,  # High confidence for successful parsing
            "raw_data": data
        }
    
    def _extract_items_from_text(self, text: str) -> Dict[str, Any]:
        """Extract items from text output"""
        logger.info("=== TEXT PARSING DETAILED LOG ===")
        logger.info(f"Input text length: {len(text)}")
        logger.info(f"Input text: '{text}'")
        
        # Simple text parsing fallback
        lines = text.split('\n')
        logger.info(f"Split into {len(lines)} lines")
        
        items = []
        total_amount = 0.0
        
        # Common price patterns
        price_patterns = [
            r'(\d+\.?\d*)',  # Basic numbers
            r'(\d+,\d+)',    # Numbers with commas
            r'(\d+\.\d{2})', # Decimal prices
        ]
        
        logger.info("=== PROCESSING EACH LINE ===")
        for line_num, line in enumerate(lines):
            original_line = line
            line = line.strip()
            logger.info(f"Line {line_num + 1}: '{original_line}' -> stripped: '{line}'")
            
            if not line:
                logger.info(f"Line {line_num + 1}: Empty line, skipping")
                continue
                
            # Skip lines that are likely headers or totals
            if any(keyword in line.lower() for keyword in ['total', 'subtotal', 'tax', 'amount', 'sum']):
                logger.info(f"Line {line_num + 1}: Contains total keyword, attempting to extract total")
                # Try to extract total amount
                import re
                for pattern_num, pattern in enumerate(price_patterns):
                    matches = re.findall(pattern, line)
                    logger.info(f"Line {line_num + 1}: Pattern {pattern_num + 1} '{pattern}' found matches: {matches}")
                    if matches:
                        try:
                            # Take the last number as it's likely the total
                            total_str = matches[-1].replace(',', '')
                            total_amount = float(total_str)
                            logger.info(f"Line {line_num + 1}: Found total amount: {total_amount} from line: {line}")
                            break
                        except ValueError as ve:
                            logger.warning(f"Line {line_num + 1}: ValueError converting '{matches[-1]}' to float: {ve}")
                            continue
                logger.info(f"Line {line_num + 1}: Skipping total line")
                continue
            
            # Try to extract item and price
            if any(char.isdigit() for char in line):
                logger.info(f"Line {line_num + 1}: Contains digits, attempting to extract item and price")
                # Look for price at the end of line
                parts = line.split()
                logger.info(f"Line {line_num + 1}: Split into {len(parts)} parts: {parts}")
                
                if len(parts) >= 2:
                    # Try to find price (usually at the end)
                    for i in range(len(parts) - 1, -1, -1):
                        part = parts[i].replace(',', '').replace('$', '').replace('€', '').replace('£', '')
                        logger.info(f"Line {line_num + 1}: Checking part {i} '{parts[i]}' -> cleaned: '{part}'")
                        
                        if part.replace('.', '').isdigit():
                            try:
                                price = float(part)
                                name = ' '.join(parts[:i])
                                logger.info(f"Line {line_num + 1}: Found potential price: {price}, name: '{name}'")
                                
                                if name and len(name.strip()) > 0:
                                    items.append({
                                        "name": name.strip(),
                                        "price": price,
                                        "quantity": 1,
                                        "total": price
                                    })
                                    logger.info(f"Line {line_num + 1}: Successfully extracted item: {name.strip()} - ${price}")
                                    break
                                else:
                                    logger.warning(f"Line {line_num + 1}: Name is empty after extracting price")
                            except ValueError as ve:
                                logger.warning(f"Line {line_num + 1}: ValueError converting '{part}' to float: {ve}")
                                continue
                        else:
                            logger.info(f"Line {line_num + 1}: Part '{part}' is not a valid number")
                else:
                    logger.info(f"Line {line_num + 1}: Not enough parts to extract item/price")
            else:
                logger.info(f"Line {line_num + 1}: No digits found, skipping")
        
        logger.info("=== PARSING SUMMARY ===")
        logger.info(f"Total items extracted: {len(items)}")
        logger.info(f"Total amount found: {total_amount}")
        logger.info(f"Items: {items}")
        
        # If no items found but we have text, create a generic item
        if not items and text.strip():
            logger.info("No items found, creating generic 'Extracted Content' item")
            items.append({
                "name": "Extracted Content",
                "price": 0.0,
                "quantity": 1,
                "total": 0.0,
                "raw_text": text[:200] + "..." if len(text) > 200 else text
            })
            logger.info(f"Created generic item with raw_text length: {len(text[:200] + '...' if len(text) > 200 else text)}")
        
        result = {
            "items": items,
            "total_amount": total_amount,
            "confidence_score": 0.6,  # Lower confidence for text parsing
            "raw_text": text
        }
        
        logger.info("=== TEXT PARSING COMPLETED ===")
        logger.info(f"Final result: {result}")
        return result

    async def _ocr_fallback(self, image: Image.Image) -> Dict[str, Any]:
        """OCR fallback when Donut fails to extract structured data"""
        try:
            import easyocr
            
            logger.info("Starting OCR fallback with EasyOCR...")
            
            # Initialize EasyOCR reader
            reader = easyocr.Reader(['en'])
            
            # Convert PIL image to numpy array
            import numpy as np
            image_array = np.array(image)
            
            # Extract text
            results = reader.readtext(image_array)
            
            # Extract all text lines
            text_lines = []
            for (bbox, text, confidence) in results:
                if confidence > 0.5:  # Only include confident detections
                    text_lines.append(text.strip())
            
            logger.info(f"OCR extracted {len(text_lines)} text lines: {text_lines}")
            
            # Parse text lines for items and prices
            items = []
            total_amount = 0.0
            
            # Common price patterns
            import re
            price_patterns = [
                r'(\d+\.\d{2})',  # Decimal prices like 5.99
                r'(\d+,\d+)',    # Prices with commas like 1,299
                r'(\d+)',        # Whole numbers
            ]
            
            for line in text_lines:
                line = line.strip()
                if not line:
                    continue
                
                # Skip lines that are likely headers or totals
                if any(keyword in line.lower() for keyword in ['total', 'subtotal', 'tax', 'amount', 'sum', 'receipt', 'invoice']):
                    # Try to extract total amount
                    for pattern in price_patterns:
                        matches = re.findall(pattern, line)
                        if matches:
                            try:
                                # Take the last number as it's likely the total
                                total_str = matches[-1].replace(',', '')
                                total_amount = float(total_str)
                                # Ensure the value is finite and reasonable
                                if not (float('inf') == total_amount or float('-inf') == total_amount or total_amount > 1000000):
                                    logger.info(f"Found total amount: {total_amount} from line: {line}")
                                    break
                                else:
                                    total_amount = 0.0
                            except (ValueError, OverflowError):
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
                            try:
                                price = float(part)
                                # Ensure the value is finite and reasonable
                                if not (float('inf') == price or float('-inf') == price or price > 1000000):
                                    # Item name is everything before the price
                                    item_name = ' '.join(parts[:i]).strip()
                                    if item_name:
                                        items.append({
                                            "name": item_name,
                                            "price": price,
                                            "quantity": 1,
                                            "total": price
                                        })
                                        logger.info(f"Found item: {item_name} - ${price}")
                                    break
                            except (ValueError, OverflowError):
                                continue
            
            # Ensure all values are JSON serializable
            import math
            
            def clean_value(val):
                if isinstance(val, float):
                    if math.isfinite(val):
                        return val
                    else:
                        return 0.0
                return val
            
            # Clean all values in items
            cleaned_items = []
            for item in items:
                cleaned_item = {
                    "name": item["name"],
                    "price": clean_value(item["price"]),
                    "quantity": item["quantity"],
                    "total": clean_value(item["total"])
                }
                cleaned_items.append(cleaned_item)
            
            return {
                "items": cleaned_items,
                "total_amount": clean_value(total_amount),
                "confidence_score": 0.7,  # Lower confidence for OCR
                "raw_text": text_lines,
                "extraction_method": "ocr_fallback"
            }
            
        except Exception as e:
            logger.error(f"OCR fallback failed: {e}")
            return {
                "items": [],
                "total_amount": 0.0,
                "confidence_score": 0.0,
                "error": f"OCR fallback failed: {str(e)}"
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
        
        # Clean the result to ensure JSON serialization
        def clean_for_json(obj):
            if isinstance(obj, dict):
                return {k: clean_for_json(v) for k, v in obj.items()}
            elif isinstance(obj, list):
                return [clean_for_json(item) for item in obj]
            elif isinstance(obj, float):
                if math.isfinite(obj):
                    return obj
                else:
                    return 0.0
            elif isinstance(obj, (int, str, bool, type(None))):
                return obj
            else:
                return str(obj)
        
        cleaned_result = clean_for_json(result)
        
        response_data = {
            "success": True,
            "scan_id": str(uuid.uuid4()),
            "items": cleaned_result.get("items", []),
            "total_amount": cleaned_result.get("total_amount", 0.0),
            "confidence_score": cleaned_result.get("confidence_score", 0.0),
            "processing_time_ms": int(processing_time * 1000),
            "model_used": "donut-real",
            "metadata": {
                "filename": file.filename,
                "file_size": len(image_data),
                "image_size": image.size,
                "device": str(clova_processor.device),
                "raw_output": cleaned_result.get("raw_data") or cleaned_result.get("raw_text")
            }
        }
        
        return response_data
        
    except Exception as e:
        logger.error(f"Failed to process invoice: {e}")
        processing_time = time.time() - start_time
        
        # Ensure error response is also JSON serializable
        def clean_for_json(obj):
            if isinstance(obj, dict):
                return {k: clean_for_json(v) for k, v in obj.items()}
            elif isinstance(obj, list):
                return [clean_for_json(item) for item in obj]
            elif isinstance(obj, float):
                if math.isfinite(obj):
                    return obj
                else:
                    return 0.0
            elif isinstance(obj, (int, str, bool, type(None))):
                return obj
            else:
                return str(obj)
        
        error_response = {
            "success": False,
            "error": str(e),
            "processing_time_ms": int(processing_time * 1000)
        }
        
        return clean_for_json(error_response)

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