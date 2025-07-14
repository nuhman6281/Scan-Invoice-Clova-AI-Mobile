#!/usr/bin/env python3
"""
Simple Donut Demo - Basic functionality test
This script demonstrates the basic structure without requiring sentencepiece
"""

import argparse
import torch
from PIL import Image
import json

def main():
    parser = argparse.ArgumentParser(description="Simple Donut Demo")
    parser.add_argument("--image_path", type=str, default="misc/sample_image_cord_test_receipt_00004.png",
                       help="Path to the image file")
    args = parser.parse_args()
    
    print("🍩 Donut - Document Understanding Transformer")
    print("=" * 50)
    
    # Check if image exists
    try:
        image = Image.open(args.image_path)
        print(f"✅ Successfully loaded image: {args.image_path}")
        print(f"   Image size: {image.size}")
        print(f"   Image mode: {image.mode}")
    except Exception as e:
        print(f"❌ Error loading image: {e}")
        return
    
    # Check CUDA availability
    if torch.cuda.is_available():
        print(f"✅ CUDA is available: {torch.cuda.get_device_name(0)}")
    else:
        print("ℹ️  CUDA not available, will use CPU")
    
    # Try to import donut module
    try:
        import donut
        print("✅ Donut module imported successfully")
        
        # Show available tasks
        print("\n📋 Available tasks:")
        print("   - cord: Document parsing (receipts, invoices)")
        print("   - rvlcdip: Document classification")
        print("   - docvqa: Document question answering")
        print("   - zhtrainticket: Chinese train ticket parsing")
        
        print("\n🔗 Pre-trained models available:")
        print("   - naver-clova-ix/donut-base-finetuned-cord-v2")
        print("   - naver-clova-ix/donut-base-finetuned-rvlcdip")
        print("   - naver-clova-ix/donut-base-finetuned-docvqa")
        print("   - naver-clova-ix/donut-base-finetuned-zhtrainticket")
        
        print("\n⚠️  Note: To run the full demo, you need to install sentencepiece.")
        print("   The sentencepiece installation is failing due to build issues.")
        print("   You can try the online demos instead:")
        print("   - CORD Demo: https://huggingface.co/spaces/naver-clova-ix/donut-base-finetuned-cord-v2")
        print("   - RVL-CDIP Demo: https://huggingface.co/spaces/nielsr/donut-rvlcdip")
        print("   - DocVQA Demo: https://huggingface.co/spaces/nielsr/donut-docvqa")
        
    except ImportError as e:
        print(f"❌ Error importing donut module: {e}")
        return
    
    print("\n🎯 Next steps:")
    print("   1. Try the online demos at the links above")
    print("   2. Or try installing sentencepiece manually:")
    print("      pip install sentencepiece --no-deps")
    print("   3. Or use conda: conda install -c conda-forge sentencepiece")

if __name__ == "__main__":
    main() 