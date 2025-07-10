import time
import logging
from typing import Dict, Any, List
from .clova_model_manager import ClovaModelManager

logger = logging.getLogger(__name__)

class InvoiceProcessor:
    """
    Main invoice processing pipeline that orchestrates CLOVA AI models
    """
    
    def __init__(self, model_manager: ClovaModelManager):
        self.model_manager = model_manager
        logger.info("Invoice Processor initialized")
    
    def process_invoice(self, image_path: str) -> Dict[str, Any]:
        """
        Process an invoice image using the complete pipeline
        
        Args:
            image_path: Path to the image file
            
        Returns:
            Dictionary containing extracted items, confidence, and metadata
        """
        start_time = time.time()
        
        try:
            logger.info(f"Starting invoice processing: {image_path}")
            
            # Step 1: Try Donut model first (primary method)
            donut_result = self.model_manager.process_with_donut(image_path)
            
            # Step 2: Check if Donut result is satisfactory
            if donut_result.get("confidence", 0) >= 0.7 and donut_result.get("items"):
                processing_time = time.time() - start_time
                logger.info(f"Donut processing successful, confidence: {donut_result['confidence']}")
                
                return {
                    "items": donut_result["items"],
                    "confidence": donut_result["confidence"],
                    "processing_time": processing_time,
                    "model_used": "donut"
                }
            
            # Step 3: Fallback to CRAFT if Donut confidence is low or no items found
            logger.info("Donut confidence low, trying CRAFT fallback")
            craft_result = self.model_manager.process_with_craft(image_path)
            
            # Step 4: Merge results if both models produced output
            if donut_result.get("items") and craft_result.get("items"):
                merged_items = self._merge_results(donut_result["items"], craft_result["items"])
                processing_time = time.time() - start_time
                
                return {
                    "items": merged_items,
                    "confidence": max(donut_result.get("confidence", 0), craft_result.get("confidence", 0)),
                    "processing_time": processing_time,
                    "model_used": "donut+craft"
                }
            
            # Step 5: Return the best available result
            if donut_result.get("items"):
                processing_time = time.time() - start_time
                return {
                    "items": donut_result["items"],
                    "confidence": donut_result["confidence"],
                    "processing_time": processing_time,
                    "model_used": "donut"
                }
            elif craft_result.get("items"):
                processing_time = time.time() - start_time
                return {
                    "items": craft_result["items"],
                    "confidence": craft_result["confidence"],
                    "processing_time": processing_time,
                    "model_used": "craft"
                }
            else:
                # No items found by either model
                processing_time = time.time() - start_time
                logger.warning("No items found by either model")
                return {
                    "items": [],
                    "confidence": 0.0,
                    "processing_time": processing_time,
                    "model_used": "none"
                }
                
        except Exception as e:
            processing_time = time.time() - start_time
            logger.error(f"Error in invoice processing: {str(e)}")
            return {
                "items": [],
                "confidence": 0.0,
                "processing_time": processing_time,
                "model_used": "error",
                "error": str(e)
            }
    
    def _merge_results(self, donut_items: List[Dict], craft_items: List[Dict]) -> List[Dict]:
        """
        Merge results from Donut and CRAFT models
        
        Args:
            donut_items: Items extracted by Donut model
            craft_items: Items extracted by CRAFT model
            
        Returns:
            Merged list of items
        """
        merged_items = []
        
        # Start with Donut items (higher confidence)
        merged_items.extend(donut_items)
        
        # Add CRAFT items that don't duplicate Donut items
        for craft_item in craft_items:
            is_duplicate = False
            
            for donut_item in donut_items:
                # Check for duplicates based on name similarity
                if self._is_similar_item(craft_item, donut_item):
                    is_duplicate = True
                    break
            
            if not is_duplicate:
                merged_items.append(craft_item)
        
        return merged_items
    
    def _is_similar_item(self, item1: Dict, item2: Dict) -> bool:
        """
        Check if two items are similar (potential duplicates)
        
        Args:
            item1: First item
            item2: Second item
            
        Returns:
            True if items are similar
        """
        name1 = item1.get("name", "").lower().strip()
        name2 = item2.get("name", "").lower().strip()
        
        # Exact match
        if name1 == name2:
            return True
        
        # Check if one name contains the other
        if name1 in name2 or name2 in name1:
            return True
        
        # Check price similarity (within 10%)
        price1 = item1.get("price", 0)
        price2 = item2.get("price", 0)
        
        if price1 > 0 and price2 > 0:
            price_diff = abs(price1 - price2) / max(price1, price2)
            if price_diff < 0.1:  # 10% threshold
                return True
        
        return False
    
    def validate_items(self, items: List[Dict]) -> List[Dict]:
        """
        Validate and clean extracted items
        
        Args:
            items: List of extracted items
            
        Returns:
            Validated and cleaned items
        """
        validated_items = []
        
        for item in items:
            # Basic validation
            if not item.get("name") or len(item["name"].strip()) == 0:
                continue
            
            if item.get("price", 0) <= 0:
                continue
            
            # Clean and normalize
            cleaned_item = {
                "name": item["name"].strip(),
                "price": float(item["price"]),
                "quantity": int(item.get("quantity", 1)),
                "category": item.get("category", "").strip()
            }
            
            validated_items.append(cleaned_item)
        
        return validated_items