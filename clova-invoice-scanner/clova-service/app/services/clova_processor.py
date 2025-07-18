"""
CLOVA AI Processor Service
Integrates Donut and CRAFT models for invoice processing
"""

import os
import time
import uuid
import json
import asyncio
from pathlib import Path
from typing import Dict, Any, List, Optional, Tuple
from dataclasses import dataclass

import torch
import cv2
import numpy as np
from PIL import Image
import structlog

# CLOVA AI imports
from transformers import DonutProcessor, VisionEncoderDecoderModel
from craft_text_detector import (
    load_craftnet_model, 
    load_refinenet_model, 
    get_prediction,
    Craft
)

from app.config import settings
from app.models.invoice import InvoiceItem, ProcessingOptions
from app.utils.image_utils import preprocess_image, enhance_image_quality

logger = structlog.get_logger()

@dataclass
class ModelStatus:
    """Model status information"""
    name: str
    loaded: bool
    device: str
    memory_usage: Optional[str] = None
    last_used: Optional[float] = None

class ClovaProcessor:
    """
    CLOVA AI processor that combines Donut and CRAFT models
    for robust invoice processing
    """
    
    def __init__(self):
        self.donut_processor: Optional[DonutProcessor] = None
        self.donut_model: Optional[VisionEncoderDecoderModel] = None
        self.craft_net: Optional[torch.nn.Module] = None
        self.refine_net: Optional[torch.nn.Module] = None
        self.craft: Optional[Craft] = None
        
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.models_loaded = False
        self.processing_stats = {
            "total_processed": 0,
            "successful_scans": 0,
            "failed_scans": 0,
            "avg_processing_time": 0.0,
            "donut_usage": 0,
            "craft_usage": 0
        }
        
        logger.info(f"CLOVA processor initialized on device: {self.device}")
    
    async def initialize(self):
        """Initialize and load AI models"""
        try:
            logger.info("Loading CLOVA AI models...")
            
            # Load Donut model for receipt understanding
            await self._load_donut_model()
            
            # Load CRAFT models for text detection
            await self._load_craft_models()
            
            self.models_loaded = True
            logger.info("All CLOVA AI models loaded successfully")
            
        except Exception as e:
            logger.error(f"Failed to initialize CLOVA processor: {e}")
            raise
    
    async def _load_donut_model(self):
        """Load Donut model for document understanding"""
        try:
            logger.info("Loading Donut model...")
            
            # Load processor and model
            self.donut_processor = DonutProcessor.from_pretrained(
                "naver-clova-ix/donut-base"
            )
            
            self.donut_model = VisionEncoderDecoderModel.from_pretrained(
                "naver-clova-ix/donut-base-finetuned-cord-v2",
                ignore_mismatched_sizes=True  # Handle weight mismatches
            )
            
            # Move to device and set to eval mode
            self.donut_model.to(self.device)
            self.donut_model.eval()
            
            logger.info("Donut model loaded successfully")
            
        except Exception as e:
            logger.error(f"Failed to load Donut model: {e}")
            raise
    
    async def _load_craft_models(self):
        """Load CRAFT models for text detection"""
        try:
            logger.info("Loading CRAFT models...")
            
            # Load CRAFT models
            self.craft_net = load_craftnet_model(cuda=torch.cuda.is_available())
            self.refine_net = load_refinenet_model(cuda=torch.cuda.is_available())
            
            # Initialize CRAFT processor
            self.craft = Craft(
                output_dir=None,
                cuda=torch.cuda.is_available(),
                craft_net=self.craft_net,
                refine_net=self.refine_net
            )
            
            logger.info("CRAFT models loaded successfully")
            
        except Exception as e:
            logger.error(f"Failed to load CRAFT models: {e}")
            raise
    
    async def process_invoice(
        self,
        file_path: str,
        confidence_threshold: float = 0.7,
        use_fallback: bool = True
    ) -> Dict[str, Any]:
        """
        Process invoice image with CLOVA AI models
        
        Args:
            file_path: Path to the invoice image
            confidence_threshold: Minimum confidence score
            use_fallback: Whether to use CRAFT fallback
            
        Returns:
            Dictionary with extracted items and metadata
        """
        start_time = time.time()
        scan_id = str(uuid.uuid4())
        
        try:
            logger.info(f"Processing invoice: {file_path}")
            
            # Preprocess image
            image = await self._preprocess_image(file_path)
            
            # Primary processing with Donut
            donut_result = await self._process_with_donut(image)
            
            # Check confidence and use fallback if needed
            if use_fallback and donut_result.get('confidence_score', 0) < confidence_threshold:
                logger.info("Low confidence, using CRAFT fallback")
                craft_result = await self._process_with_craft(image)
                final_result = self._merge_results(donut_result, craft_result)
                model_used = "donut+craft"
                self.processing_stats["craft_usage"] += 1
            else:
                final_result = donut_result
                model_used = "donut"
                self.processing_stats["donut_usage"] += 1
            
            # Update processing stats
            processing_time = time.time() - start_time
            self._update_stats(processing_time, True)
            
            return {
                "scan_id": scan_id,
                "items": final_result.get("items", []),
                "total_amount": final_result.get("total_amount"),
                "confidence_score": final_result.get("confidence_score"),
                "model_used": model_used,
                "processing_time": processing_time,
                "metadata": {
                    "image_path": file_path,
                    "image_size": image.shape if hasattr(image, 'shape') else None,
                    "confidence_threshold": confidence_threshold,
                    "use_fallback": use_fallback
                }
            }
            
        except Exception as e:
            logger.error(f"Failed to process invoice: {e}")
            processing_time = time.time() - start_time
            self._update_stats(processing_time, False)
            
            return {
                "scan_id": scan_id,
                "error": str(e),
                "items": [],
                "total_amount": 0.0,
                "confidence_score": 0.0,
                "model_used": "none",
                "processing_time": processing_time
            }
    
    async def process_invoice_advanced(
        self,
        file_path: str,
        options: ProcessingOptions
    ) -> Dict[str, Any]:
        """
        Advanced invoice processing with custom options
        
        Args:
            file_path: Path to the invoice image
            options: Processing options
            
        Returns:
            Dictionary with extracted items and metadata
        """
        # Use the standard processing with options
        return await self.process_invoice(
            file_path=file_path,
            confidence_threshold=options.confidence_threshold,
            use_fallback=options.use_fallback
        )
    
    async def _preprocess_image(self, file_path: str) -> np.ndarray:
        """Preprocess image for AI processing"""
        try:
            # Load image
            image = cv2.imread(file_path)
            if image is None:
                raise ValueError(f"Could not load image: {file_path}")
            
            # Enhance image quality
            image = enhance_image_quality(image)
            
            # Preprocess for AI models
            image = preprocess_image(image)
            
            return image
            
        except Exception as e:
            logger.error(f"Failed to preprocess image: {e}")
            raise
    
    async def _process_with_donut(self, image: np.ndarray) -> Dict[str, Any]:
        """Process image with Donut model"""
        try:
            # Convert to PIL Image
            pil_image = Image.fromarray(cv2.cvtColor(image, cv2.COLOR_BGR2RGB))
            
            # Prepare input for Donut
            pixel_values = self.donut_processor(
                pil_image, 
                return_tensors="pt"
            ).pixel_values
            
            # Move to device
            pixel_values = pixel_values.to(self.device)
            
            # Generate with task prompt for receipts
            task_prompt = "<s_cord-v2>"
            decoder_input_ids = self.donut_processor.tokenizer(
                task_prompt, 
                add_special_tokens=False, 
                return_tensors="pt"
            ).input_ids.to(self.device)
            
            # Generate prediction
            with torch.no_grad():
                outputs = self.donut_model.generate(
                    pixel_values,
                    decoder_input_ids=decoder_input_ids,
                    max_length=self.donut_model.decoder.config.max_position_embeddings,
                    pad_token_id=self.donut_processor.tokenizer.pad_token_id,
                    eos_token_id=self.donut_processor.tokenizer.eos_token_id,
                    use_cache=True,
                    early_stopping=True,
                    do_sample=False
                )
            
            # Decode result
            sequence = self.donut_processor.batch_decode(outputs.sequences)[0]
            
            # Parse the result
            parsed_result = self._parse_donut_output(sequence)
            
            return parsed_result
            
        except Exception as e:
            logger.error(f"Donut processing failed: {e}")
            return {
                "items": [],
                "total_amount": 0.0,
                "confidence_score": 0.0,
                "error": str(e)
            }
    
    async def _process_with_craft(self, image: np.ndarray) -> Dict[str, Any]:
        """Process image with CRAFT model"""
        try:
            # Save image temporarily for CRAFT
            temp_path = f"/tmp/craft_temp_{uuid.uuid4()}.jpg"
            cv2.imwrite(temp_path, image)
            
            # Process with CRAFT
            prediction_result = get_prediction(
                image=temp_path,
                craft_net=self.craft_net,
                refine_net=self.refine_net,
                text_threshold=0.7,
                link_threshold=0.4,
                low_text=0.4,
                cuda=torch.cuda.is_available(),
                canvas_size=1280,
                mag_ratio=1.5,
                poly=False
            )
            
            # Clean up temp file
            os.remove(temp_path)
            
            # Extract text from CRAFT result
            extracted_text = self._extract_text_from_craft(prediction_result)
            
            # Parse text into structured data
            parsed_result = self._parse_craft_text(extracted_text)
            
            return parsed_result
            
        except Exception as e:
            logger.error(f"CRAFT processing failed: {e}")
            return {
                "items": [],
                "total_amount": 0.0,
                "confidence_score": 0.5,  # Lower confidence for CRAFT
                "error": str(e)
            }
    
    def _parse_donut_output(self, sequence: str) -> Dict[str, Any]:
        """Parse Donut model output into structured data"""
        try:
            # Remove task prompt
            if sequence.startswith("<s_cord-v2>"):
                sequence = sequence[len("<s_cord-v2>"):]
            
            # Try to parse as JSON
            try:
                data = json.loads(sequence)
                return self._extract_items_from_json(data)
            except json.JSONDecodeError:
                # Fallback: parse as text
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
                if isinstance(item, dict):
                    name = item.get("nm", "")
                    price = float(item.get("price", 0))
                    quantity = int(item.get("cnt", 1))
                    
                    items.append(InvoiceItem(
                        name=name,
                        price=price,
                        quantity=quantity,
                        category="food"
                    ))
                    
                    total_amount += price * quantity
        
        # Extract total
        if "total" in data and isinstance(data["total"], dict):
            total = data["total"].get("total_price", 0)
            if isinstance(total, str):
                total = float(total.replace(",", ""))
            total_amount = float(total)
        
        return {
            "items": items,
            "total_amount": total_amount,
            "confidence_score": 0.9,  # High confidence for structured data
            "raw_data": data
        }
    
    def _extract_items_from_text(self, text: str) -> Dict[str, Any]:
        """Extract items from text using regex patterns"""
        import re
        
        items = []
        total_amount = 0.0
        
        # Simple regex patterns for common receipt formats
        price_pattern = r'(\d+\.?\d*)'
        item_pattern = r'([A-Za-z\s]+)\s*(\d+\.?\d*)'
        
        lines = text.split('\n')
        for line in lines:
            line = line.strip()
            if not line:
                continue
            
            # Look for item-price patterns
            match = re.search(item_pattern, line)
            if match:
                name = match.group(1).strip()
                price = float(match.group(2))
                
                items.append(InvoiceItem(
                    name=name,
                    price=price,
                    quantity=1,
                    category="unknown"
                ))
                
                total_amount += price
        
        return {
            "items": items,
            "total_amount": total_amount,
            "confidence_score": 0.6,  # Lower confidence for text parsing
            "raw_text": text
        }
    
    def _extract_text_from_craft(self, prediction_result: Dict[str, Any]) -> List[str]:
        """Extract text from CRAFT prediction result"""
        texts = []
        
        if "text" in prediction_result:
            for text_data in prediction_result["text"]:
                if isinstance(text_data, list) and len(text_data) > 0:
                    texts.append(text_data[0])  # First element is usually the text
        
        return texts
    
    def _parse_craft_text(self, texts: List[str]) -> Dict[str, Any]:
        """Parse CRAFT extracted text into structured data"""
        items = []
        total_amount = 0.0
        
        for text in texts:
            # Simple parsing logic for CRAFT text
            # This can be enhanced with more sophisticated NLP
            if any(keyword in text.lower() for keyword in ['total', 'sum', 'amount']):
                # Try to extract total amount
                import re
                price_match = re.search(r'(\d+\.?\d*)', text)
                if price_match:
                    total_amount = float(price_match.group(1))
            else:
                # Try to extract item and price
                import re
                price_match = re.search(r'(\d+\.?\d*)', text)
                if price_match:
                    price = float(price_match.group(1))
                    name = text.replace(price_match.group(1), '').strip()
                    
                    if name:
                        items.append(InvoiceItem(
                            name=name,
                            price=price,
                            quantity=1,
                            category="unknown"
                        ))
        
        return {
            "items": items,
            "total_amount": total_amount,
            "confidence_score": 0.5,  # Lower confidence for CRAFT
            "raw_texts": texts
        }
    
    def _merge_results(
        self, 
        donut_result: Dict[str, Any], 
        craft_result: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Merge Donut and CRAFT results"""
        # Combine items from both results
        all_items = donut_result.get("items", []) + craft_result.get("items", [])
        
        # Remove duplicates based on name similarity
        unique_items = self._deduplicate_items(all_items)
        
        # Use the highest total amount
        total_amount = max(
            donut_result.get("total_amount", 0),
            craft_result.get("total_amount", 0)
        )
        
        # Average confidence scores
        donut_confidence = donut_result.get("confidence_score", 0)
        craft_confidence = craft_result.get("confidence_score", 0)
        avg_confidence = (donut_confidence + craft_confidence) / 2
        
        return {
            "items": unique_items,
            "total_amount": total_amount,
            "confidence_score": avg_confidence,
            "donut_result": donut_result,
            "craft_result": craft_result
        }
    
    def _deduplicate_items(self, items: List[InvoiceItem]) -> List[InvoiceItem]:
        """Remove duplicate items based on name similarity"""
        from difflib import SequenceMatcher
        
        unique_items = []
        for item in items:
            is_duplicate = False
            for existing_item in unique_items:
                similarity = SequenceMatcher(None, item.name.lower(), existing_item.name.lower()).ratio()
                if similarity > 0.8:  # 80% similarity threshold
                    is_duplicate = True
                    break
            
            if not is_duplicate:
                unique_items.append(item)
        
        return unique_items
    
    def _update_stats(self, processing_time: float, success: bool):
        """Update processing statistics"""
        self.processing_stats["total_processed"] += 1
        
        if success:
            self.processing_stats["successful_scans"] += 1
        else:
            self.processing_stats["failed_scans"] += 1
        
        # Update average processing time
        total_time = self.processing_stats["avg_processing_time"] * (self.processing_stats["total_processed"] - 1)
        self.processing_stats["avg_processing_time"] = (total_time + processing_time) / self.processing_stats["total_processed"]
    
    async def get_models_status(self) -> Dict[str, ModelStatus]:
        """Get status of loaded models"""
        return {
            "donut": ModelStatus(
                name="Donut",
                loaded=self.donut_model is not None,
                device=str(self.device),
                memory_usage=self._get_model_memory_usage(self.donut_model),
                last_used=time.time()
            ),
            "craft": ModelStatus(
                name="CRAFT",
                loaded=self.craft_net is not None,
                device=str(self.device),
                memory_usage=self._get_model_memory_usage(self.craft_net),
                last_used=time.time()
            )
        }
    
    def _get_model_memory_usage(self, model) -> Optional[str]:
        """Get memory usage of a model"""
        if model is None:
            return None
        
        try:
            if hasattr(model, 'parameters'):
                total_params = sum(p.numel() for p in model.parameters())
                return f"{total_params:,} parameters"
        except:
            pass
        
        return "Unknown"
    
    async def reload_models(self):
        """Reload all models"""
        logger.info("Reloading CLOVA AI models...")
        
        # Cleanup existing models
        await self.cleanup()
        
        # Reload models
        await self.initialize()
        
        logger.info("Models reloaded successfully")
    
    async def get_metrics(self) -> Dict[str, Any]:
        """Get processing metrics"""
        return {
            **self.processing_stats,
            "models_loaded": self.models_loaded,
            "device": str(self.device),
            "memory_usage": self._get_system_memory_usage()
        }
    
    def _get_system_memory_usage(self) -> Dict[str, Any]:
        """Get system memory usage"""
        try:
            import psutil
            memory = psutil.virtual_memory()
            return {
                "total": f"{memory.total / (1024**3):.2f} GB",
                "available": f"{memory.available / (1024**3):.2f} GB",
                "percent": f"{memory.percent:.1f}%"
            }
        except ImportError:
            return {"error": "psutil not available"}
    
    async def cleanup(self):
        """Cleanup resources"""
        try:
            # Clear CUDA cache if available
            if torch.cuda.is_available():
                torch.cuda.empty_cache()
            
            logger.info("CLOVA processor cleanup completed")
            
        except Exception as e:
            logger.error(f"Cleanup failed: {e}") 