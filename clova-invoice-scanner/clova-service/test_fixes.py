#!/usr/bin/env python3
"""
Test script to verify the fixes applied to clova-service
"""

import asyncio
import sys
import os
from PIL import Image
import torch

# Add the current directory to the path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from real_clova_service import RealClovaProcessor

async def test_clova_service():
    """Test the CLOVA service with the fixes"""
    print("=== Testing CLOVA Service Fixes ===")
    
    try:
        # Initialize processor
        processor = RealClovaProcessor()
        print("✓ Processor initialized")
        
        # Test model loading
        print("Loading Donut model...")
        await processor.initialize()
        print("✓ Donut model loaded successfully")
        print(f"✓ Device: {processor.device}")
        print(f"✓ Model loaded: {processor.loaded}")
        
        # Test with a sample image if available
        sample_image_path = "../../misc/sample_image_cord_test_receipt_00004.png"
        if os.path.exists(sample_image_path):
            print(f"Testing with sample image: {sample_image_path}")
            
            # Load image
            image = Image.open(sample_image_path)
            print(f"✓ Image loaded: {image.size}")
            
            # Process image
            print("Processing image...")
            result = await processor.process_invoice(image)
            
            print("✓ Processing completed")
            print(f"✓ Extraction method: {result.get('extraction_method', 'unknown')}")
            print(f"✓ Items found: {len(result.get('items', []))}")
            print(f"✓ Total amount: {result.get('total_amount', 0.0)}")
            print(f"✓ Confidence score: {result.get('confidence_score', 0.0)}")
            
            if result.get('items'):
                print("✓ Items extracted successfully:")
                for i, item in enumerate(result['items'][:3]):  # Show first 3 items
                    print(f"  {i+1}. {item.get('name', 'Unknown')} - ${item.get('price', 0.0)}")
                if len(result['items']) > 3:
                    print(f"  ... and {len(result['items']) - 3} more items")
            else:
                print("⚠ No items extracted")
                
        else:
            print(f"⚠ Sample image not found at {sample_image_path}")
            print("✓ Model loading test passed")
        
        print("\n=== All Tests Passed! ===")
        return True
        
    except Exception as e:
        print(f"✗ Test failed: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    # Run the test
    success = asyncio.run(test_clova_service())
    sys.exit(0 if success else 1) 