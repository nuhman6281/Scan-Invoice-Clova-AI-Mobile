#!/usr/bin/env python3
"""
CLOVA AI Invoice Scanner - Image Processing Test Script
This script tests the complete image processing flow without requiring external services
"""

import os
import sys
import json
import time
import base64
from pathlib import Path
from typing import Dict, Any, List
import uuid

# Mock database data
MOCK_SHOPS = [
    {
        "id": "shop-1",
        "name": "Walmart",
        "address": "123 Main St, City, State",
        "latitude": 40.7128,
        "longitude": -74.0060,
        "rating": 4.2,
        "isPremium": False,
        "category": "grocery"
    },
    {
        "id": "shop-2", 
        "name": "Target",
        "address": "456 Oak Ave, City, State",
        "latitude": 40.7589,
        "longitude": -73.9851,
        "rating": 4.0,
        "isPremium": False,
        "category": "retail"
    },
    {
        "id": "shop-3",
        "name": "Whole Foods",
        "address": "789 Pine St, City, State", 
        "latitude": 40.7505,
        "longitude": -73.9934,
        "rating": 4.5,
        "isPremium": True,
        "category": "organic"
    }
]

MOCK_PRODUCTS = [
    {
        "id": "prod-1",
        "shopId": "shop-1",
        "name": "Milk",
        "normalizedName": "milk",
        "category": "dairy",
        "price": 3.99,
        "brand": "Organic Valley",
        "isAvailable": True,
        "shop": MOCK_SHOPS[0]
    },
    {
        "id": "prod-2",
        "shopId": "shop-1", 
        "name": "Bread",
        "normalizedName": "bread",
        "category": "bakery",
        "price": 2.49,
        "brand": "Wonder",
        "isAvailable": True,
        "shop": MOCK_SHOPS[0]
    },
    {
        "id": "prod-3",
        "shopId": "shop-2",
        "name": "Milk",
        "normalizedName": "milk", 
        "category": "dairy",
        "price": 3.49,
        "brand": "Horizon",
        "isAvailable": True,
        "shop": MOCK_SHOPS[1]
    },
    {
        "id": "prod-4",
        "shopId": "shop-3",
        "name": "Organic Milk",
        "normalizedName": "organic milk",
        "category": "dairy", 
        "price": 4.99,
        "brand": "Organic Valley",
        "isAvailable": True,
        "shop": MOCK_SHOPS[2]
    },
    {
        "id": "prod-5",
        "shopId": "shop-1",
        "name": "Eggs",
        "normalizedName": "eggs",
        "category": "dairy",
        "price": 4.99,
        "brand": "Farm Fresh",
        "isAvailable": True,
        "shop": MOCK_SHOPS[0]
    },
    {
        "id": "prod-6",
        "shopId": "shop-2",
        "name": "Eggs",
        "normalizedName": "eggs",
        "category": "dairy",
        "price": 4.49,
        "brand": "Eggland's Best",
        "isAvailable": True,
        "shop": MOCK_SHOPS[1]
    }
]

class MockClovaService:
    """Mock CLOVA AI service for testing"""
    
    def __init__(self):
        self.processing_stats = {
            "total_processed": 0,
            "successful_scans": 0,
            "failed_scans": 0,
            "avg_processing_time": 0.0
        }
    
    def process_invoice(self, image_path: str) -> Dict[str, Any]:
        """Mock invoice processing"""
        print(f"🔍 Processing image: {image_path}")
        
        # Simulate processing time
        time.sleep(2)
        
        # Mock extracted items based on the image
        mock_items = [
            {
                "name": "Milk",
                "price": 4.99,
                "quantity": 2,
                "total": 9.98,
                "category": "dairy"
            },
            {
                "name": "Bread", 
                "price": 3.49,
                "quantity": 1,
                "total": 3.49,
                "category": "bakery"
            },
            {
                "name": "Eggs",
                "price": 5.99,
                "quantity": 1,
                "total": 5.99,
                "category": "dairy"
            }
        ]
        
        total_amount = sum(item["total"] for item in mock_items)
        
        self.processing_stats["total_processed"] += 1
        self.processing_stats["successful_scans"] += 1
        
        return {
            "success": True,
            "scan_id": str(uuid.uuid4()),
            "items": mock_items,
            "total_amount": total_amount,
            "confidence_score": 0.92,
            "model_used": "donut-mock",
            "processing_time": 2.1,
            "merchant": "Sample Store",
            "metadata": {
                "image_path": image_path,
                "image_size": "1024x768",
                "confidence_threshold": 0.7,
                "use_fallback": False
            }
        }

class MockDatabaseService:
    """Mock database service for testing"""
    
    def __init__(self):
        self.shops = MOCK_SHOPS
        self.products = MOCK_PRODUCTS
        self.scan_history = []
    
    def find_better_offers(self, items: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Find better-priced alternatives for items"""
        better_offers = []
        
        for item in items:
            item_name = item["name"].lower()
            item_price = item["price"]
            
            # Find similar products with better prices
            similar_products = []
            for product in self.products:
                if (item_name in product["normalizedName"].lower() or 
                    product["normalizedName"].lower() in item_name):
                    if product["price"] < item_price:
                        similar_products.append(product)
            
            if similar_products:
                # Sort by price (lowest first)
                similar_products.sort(key=lambda x: x["price"])
                
                better_offers.append({
                    "originalItem": item,
                    "betterOffers": [
                        {
                            "productId": product["id"],
                            "productName": product["name"],
                            "shopName": product["shop"]["name"],
                            "shopAddress": product["shop"]["address"],
                            "shopRating": product["shop"]["rating"],
                            "price": product["price"],
                            "savings": item_price - product["price"],
                            "savingsPercentage": round(((item_price - product["price"]) / item_price) * 100, 1)
                        }
                        for product in similar_products[:3]  # Top 3 alternatives
                    ]
                })
        
        return better_offers
    
    def save_scan_history(self, scan_data: Dict[str, Any]) -> str:
        """Save scan history"""
        scan_record = {
            "id": str(uuid.uuid4()),
            "scan_id": scan_data.get("scan_id"),
            "items_found": len(scan_data.get("items", [])),
            "alternatives_found": len(scan_data.get("better_offers", [])),
            "total_amount": scan_data.get("total_amount", 0),
            "confidence_score": scan_data.get("confidence_score", 0),
            "processing_time": scan_data.get("processing_time", 0),
            "created_at": time.time()
        }
        
        self.scan_history.append(scan_record)
        return scan_record["id"]

class ImageProcessingTest:
    """Complete image processing test"""
    
    def __init__(self):
        self.clova_service = MockClovaService()
        self.db_service = MockDatabaseService()
    
    def test_complete_flow(self, image_path: str) -> Dict[str, Any]:
        """Test the complete image processing flow"""
        print("🚀 Starting complete image processing test...")
        print("=" * 60)
        
        start_time = time.time()
        
        # Step 1: Process image with CLOVA AI
        print("📸 Step 1: Processing image with CLOVA AI...")
        clova_result = self.clova_service.process_invoice(image_path)
        
        if not clova_result["success"]:
            print("❌ CLOVA processing failed")
            return {"success": False, "error": "CLOVA processing failed"}
        
        print(f"✅ CLOVA processing completed:")
        print(f"   - Items found: {len(clova_result['items'])}")
        print(f"   - Total amount: ${clova_result['total_amount']:.2f}")
        print(f"   - Confidence: {clova_result['confidence_score']:.2f}")
        print(f"   - Model used: {clova_result['model_used']}")
        
        # Step 2: Find better offers
        print("\n🔍 Step 2: Finding better offers...")
        better_offers = self.db_service.find_better_offers(clova_result["items"])
        
        print(f"✅ Found {len(better_offers)} items with better alternatives")
        
        # Step 3: Calculate total savings
        total_savings = 0
        for offer in better_offers:
            if offer["betterOffers"]:
                best_offer = offer["betterOffers"][0]  # Lowest price
                total_savings += best_offer["savings"]
        
        # Step 4: Save scan history
        print("\n💾 Step 3: Saving scan history...")
        scan_data = {
            "scan_id": clova_result["scan_id"],
            "items": clova_result["items"],
            "total_amount": clova_result["total_amount"],
            "confidence_score": clova_result["confidence_score"],
            "processing_time": clova_result["processing_time"],
            "better_offers": better_offers
        }
        
        history_id = self.db_service.save_scan_history(scan_data)
        print(f"✅ Scan history saved with ID: {history_id}")
        
        # Step 5: Generate final response
        total_processing_time = time.time() - start_time
        
        final_response = {
            "success": True,
            "data": {
                "extractedItems": clova_result["items"],
                "total": clova_result["total_amount"],
                "merchant": clova_result.get("merchant", "Unknown"),
                "betterOffers": better_offers,
                "processingTime": total_processing_time,
                "totalSavings": total_savings,
                "scanId": clova_result["scan_id"]
            },
            "metadata": {
                "confidence_score": clova_result["confidence_score"],
                "model_used": clova_result["model_used"],
                "items_found": len(clova_result["items"]),
                "alternatives_found": len(better_offers)
            }
        }
        
        print("\n📊 Final Results:")
        print("=" * 60)
        print(f"✅ Processing completed successfully!")
        print(f"📦 Items extracted: {len(clova_result['items'])}")
        print(f"💰 Total amount: ${clova_result['total_amount']:.2f}")
        print(f"🛒 Better alternatives found: {len(better_offers)}")
        print(f"💵 Potential savings: ${total_savings:.2f}")
        print(f"⏱️ Total processing time: {total_processing_time:.2f}s")
        print(f"🎯 Confidence score: {clova_result['confidence_score']:.2f}")
        
        return final_response
    
    def print_detailed_results(self, result: Dict[str, Any]):
        """Print detailed results"""
        if not result["success"]:
            print("❌ Test failed")
            return
        
        data = result["data"]
        
        print("\n📋 Detailed Results:")
        print("=" * 60)
        
        # Print extracted items
        print("📦 Extracted Items:")
        for i, item in enumerate(data["extractedItems"], 1):
            print(f"   {i}. {item['name']} - ${item['price']:.2f} x {item['quantity']} = ${item['total']:.2f}")
        
        # Print better offers
        if data["betterOffers"]:
            print("\n🛒 Better Alternatives Found:")
            for offer in data["betterOffers"]:
                original = offer["originalItem"]
                print(f"\n   📍 {original['name']} (Original: ${original['price']:.2f}):")
                
                for alt in offer["betterOffers"]:
                    print(f"      • {alt['productName']} at {alt['shopName']}")
                    print(f"        Price: ${alt['price']:.2f} (Save: ${alt['savings']:.2f} - {alt['savingsPercentage']}%)")
                    print(f"        Address: {alt['shopAddress']}")
                    print(f"        Rating: {alt['shopRating']}/5.0")
        
        # Print summary
        print(f"\n💰 Summary:")
        print(f"   Total spent: ${data['total']:.2f}")
        print(f"   Potential savings: ${data['totalSavings']:.2f}")
        print(f"   Savings percentage: {(data['totalSavings'] / data['total'] * 100):.1f}%")
        
        # Print metadata
        metadata = result["metadata"]
        print(f"\n📊 Processing Metadata:")
        print(f"   Confidence score: {metadata['confidence_score']:.2f}")
        print(f"   Model used: {metadata['model_used']}")
        print(f"   Items found: {metadata['items_found']}")
        print(f"   Alternatives found: {metadata['alternatives_found']}")

def main():
    """Main test function"""
    print("🧾 CLOVA AI Invoice Scanner - Image Processing Test")
    print("=" * 60)
    
    # Check if test image exists
    image_path = "./test_receipt.png"
    if not os.path.exists(image_path):
        print(f"❌ Test image not found: {image_path}")
        print("Please ensure test_receipt.png exists in the current directory")
        return
    
    print(f"📸 Using test image: {image_path}")
    print(f"📁 Image size: {os.path.getsize(image_path)} bytes")
    
    # Create test instance
    test = ImageProcessingTest()
    
    try:
        # Run complete test
        result = test.test_complete_flow(image_path)
        
        # Print detailed results
        test.print_detailed_results(result)
        
        # Save results to file
        output_file = "test_results.json"
        with open(output_file, 'w') as f:
            json.dump(result, f, indent=2, default=str)
        
        print(f"\n💾 Results saved to: {output_file}")
        
        # Print statistics
        print(f"\n📈 Test Statistics:")
        print(f"   Total scans processed: {test.clova_service.processing_stats['total_processed']}")
        print(f"   Successful scans: {test.clova_service.processing_stats['successful_scans']}")
        print(f"   Failed scans: {test.clova_service.processing_stats['failed_scans']}")
        print(f"   Scan history entries: {len(test.db_service.scan_history)}")
        
        print("\n🎉 Test completed successfully!")
        
    except Exception as e:
        print(f"❌ Test failed with error: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()