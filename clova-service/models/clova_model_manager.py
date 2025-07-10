import torch
import os
import logging
from typing import Optional, Dict, Any
from transformers import DonutProcessor, VisionEncoderDecoderModel
from craft_text_detector import load_craftnet_model, load_refinenet_model, get_prediction
import cv2
import numpy as np
from PIL import Image

logger = logging.getLogger(__name__)

class ClovaModelManager:
    """
    Manages CLOVA AI models for invoice processing
    - Donut model for receipt understanding
    - CRAFT models for text detection
    """
    
    def __init__(self):
        self.donut_processor = None
        self.donut_model = None
        self.craft_net = None
        self.refine_net = None
        self.device = self._get_device()
        
        logger.info(f"Initializing CLOVA Model Manager on device: {self.device}")
        self._load_models()
    
    def _get_device(self) -> str:
        """Determine the best available device (CUDA/CPU)"""
        if torch.cuda.is_available():
            device = "cuda"
            logger.info("CUDA is available, using GPU")
        else:
            device = "cpu"
            logger.info("CUDA not available, using CPU")
        return device
    
    def _load_models(self):
        """Load all required models"""
        try:
            # Load Donut model for receipt understanding
            logger.info("Loading Donut model...")
            self.donut_processor = DonutProcessor.from_pretrained("naver-clova-ix/donut-base")
            self.donut_model = VisionEncoderDecoderModel.from_pretrained(
                "naver-clova-ix/donut-base-finetuned-cord-v2"
            )
            self.donut_model.to(self.device)
            self.donut_model.eval()
            logger.info("Donut model loaded successfully")
            
            # Load CRAFT models for text detection
            logger.info("Loading CRAFT models...")
            self.craft_net = load_craftnet_model(cuda=(self.device == "cuda"))
            self.refine_net = load_refinenet_model(cuda=(self.device == "cuda"))
            logger.info("CRAFT models loaded successfully")
            
        except Exception as e:
            logger.error(f"Failed to load models: {str(e)}")
            raise e
    
    def process_with_donut(self, image_path: str) -> Dict[str, Any]:
        """
        Process image with Donut model for receipt understanding
        
        Args:
            image_path: Path to the image file
            
        Returns:
            Dictionary containing extracted items and confidence
        """
        try:
            # Load and preprocess image
            image = Image.open(image_path).convert('RGB')
            
            # Prepare input for Donut
            pixel_values = self.donut_processor(image, return_tensors="pt").pixel_values
            pixel_values = pixel_values.to(self.device)
            
            # Generate with task prompt for receipts
            task_prompt = "<s_cord-v2>"
            decoder_input_ids = self.donut_processor.tokenizer(
                task_prompt, add_special_tokens=False, return_tensors="pt"
            ).input_ids.to(self.device)
            
            # Generate output
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
            
            # Decode and parse result
            sequence = self.donut_processor.batch_decode(outputs.sequences)[0]
            result = self._parse_donut_output(sequence)
            
            return {
                "items": result.get("items", []),
                "confidence": result.get("confidence", 0.0),
                "model_used": "donut"
            }
            
        except Exception as e:
            logger.error(f"Error processing with Donut: {str(e)}")
            return {
                "items": [],
                "confidence": 0.0,
                "model_used": "donut",
                "error": str(e)
            }
    
    def process_with_craft(self, image_path: str) -> Dict[str, Any]:
        """
        Process image with CRAFT model for text detection
        
        Args:
            image_path: Path to the image file
            
        Returns:
            Dictionary containing extracted text and confidence
        """
        try:
            # Load image
            image = cv2.imread(image_path)
            if image is None:
                raise ValueError("Failed to load image")
            
            # Get text prediction
            prediction_result = get_prediction(
                image=image,
                craft_net=self.craft_net,
                refine_net=self.refine_net,
                text_threshold=0.7,
                link_threshold=0.4,
                low_text=0.4,
                cuda=(self.device == "cuda")
            )
            
            # Extract text regions
            text_regions = prediction_result['text']
            
            # Parse text into items (simplified parsing)
            items = self._parse_craft_text(text_regions)
            
            return {
                "items": items,
                "confidence": 0.6,  # Lower confidence for CRAFT
                "model_used": "craft"
            }
            
        except Exception as e:
            logger.error(f"Error processing with CRAFT: {str(e)}")
            return {
                "items": [],
                "confidence": 0.0,
                "model_used": "craft",
                "error": str(e)
            }
    
    def _parse_donut_output(self, sequence: str) -> Dict[str, Any]:
        """
        Parse Donut model output into structured data
        
        Args:
            sequence: Raw output sequence from Donut
            
        Returns:
            Parsed items and confidence
        """
        try:
            # Remove task prompt
            if sequence.startswith("<s_cord-v2>"):
                sequence = sequence[len("<s_cord-v2>"):]
            
            # Parse JSON-like structure
            import json
            import re
            
            # Extract JSON part
            json_match = re.search(r'\{.*\}', sequence)
            if json_match:
                json_str = json_match.group()
                data = json.loads(json_str)
                
                # Extract items from the parsed data
                items = []
                if "gt_parse" in data:
                    gt_parse = data["gt_parse"]
                    
                    # Handle different receipt formats
                    if "items" in gt_parse:
                        for item in gt_parse["items"]:
                            items.append({
                                "name": item.get("name", ""),
                                "price": float(item.get("price", 0)),
                                "quantity": int(item.get("quantity", 1)),
                                "category": item.get("category", "")
                            })
                    elif "menu" in gt_parse:
                        for item in gt_parse["menu"]:
                            items.append({
                                "name": item.get("name", ""),
                                "price": float(item.get("price", 0)),
                                "quantity": 1,
                                "category": ""
                            })
                
                return {
                    "items": items,
                    "confidence": data.get("confidence", 0.8)
                }
            
            return {"items": [], "confidence": 0.0}
            
        except Exception as e:
            logger.error(f"Error parsing Donut output: {str(e)}")
            return {"items": [], "confidence": 0.0}
    
    def _parse_craft_text(self, text_regions: list) -> list:
        """
        Parse CRAFT text regions into items
        
        Args:
            text_regions: List of detected text regions
            
        Returns:
            List of parsed items
        """
        items = []
        
        try:
            for text in text_regions:
                # Simple parsing logic for CRAFT output
                # This is a basic implementation - can be enhanced
                text = text.strip()
                
                # Skip empty or very short text
                if len(text) < 3:
                    continue
                
                # Try to extract price information
                import re
                price_match = re.search(r'(\d+\.?\d*)', text)
                price = float(price_match.group(1)) if price_match else 0.0
                
                # Extract name (everything before price)
                name = text
                if price_match:
                    name = text[:price_match.start()].strip()
                
                if name and price > 0:
                    items.append({
                        "name": name,
                        "price": price,
                        "quantity": 1,
                        "category": ""
                    })
            
        except Exception as e:
            logger.error(f"Error parsing CRAFT text: {str(e)}")
        
        return items
    
    def get_model_status(self) -> Dict[str, bool]:
        """Get status of loaded models"""
        return {
            "donut": self.donut_model is not None,
            "craft": self.craft_net is not None,
            "refine": self.refine_net is not None
        }