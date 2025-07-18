#!/usr/bin/env python3
"""
Test script to test the CLOVA service with problematic images
"""

import requests
import json
import sys
import os

def test_service_with_image(image_path):
    """Test the service with a specific image"""
    if not os.path.exists(image_path):
        print(f"❌ Image not found: {image_path}")
        return False
    
    url = "http://localhost:8000/process-invoice"
    
    try:
        with open(image_path, 'rb') as f:
            files = {'file': (os.path.basename(image_path), f, 'image/png')}
            response = requests.post(url, files=files)
        
        if response.status_code == 200:
            result = response.json()
            print("✅ Service response received successfully")
            print(f"📊 Success: {result.get('success', False)}")
            print(f"🔍 Items found: {len(result.get('items', []))}")
            print(f"💰 Total amount: {result.get('total_amount', 0.0)}")
            print(f"🎯 Confidence score: {result.get('confidence_score', 0.0)}")
            print(f"⏱️ Processing time: {result.get('processing_time_ms', 0)}ms")
            
            if result.get('items'):
                print("\n📋 Extracted items:")
                for i, item in enumerate(result['items'][:5]):  # Show first 5 items
                    print(f"  {i+1}. {item.get('name', 'Unknown')} - ${item.get('price', 0.0)} (qty: {item.get('quantity', 1)})")
                if len(result['items']) > 5:
                    print(f"  ... and {len(result['items']) - 5} more items")
            
            if result.get('error'):
                print(f"⚠️ Error: {result['error']}")
                return False
            
            return True
        else:
            print(f"❌ Service returned error: {response.status_code}")
            print(f"Response: {response.text}")
            return False
            
    except requests.exceptions.ConnectionError:
        print("❌ Could not connect to service. Make sure it's running on http://localhost:8000")
        return False
    except Exception as e:
        print(f"❌ Test failed: {e}")
        return False

if __name__ == "__main__":
    # Test with the sample image
    sample_image = "../../misc/sample_image_cord_test_receipt_00004.png"
    
    print("=== Testing CLOVA Service ===")
    print(f"Testing with image: {sample_image}")
    
    success = test_service_with_image(sample_image)
    
    if success:
        print("\n✅ All tests passed!")
        sys.exit(0)
    else:
        print("\n❌ Tests failed!")
        sys.exit(1) 