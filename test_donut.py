#!/usr/bin/env python3
"""
Donut Test Script - Demonstrates project functionality
This script shows what's working and provides alternative solutions
"""

import argparse
import torch
from PIL import Image
import json
import os

def test_environment():
    """Test the environment setup"""
    print("🍩 Testing Donut Environment")
    print("=" * 50)
    
    # Test imports
    try:
        import donut
        print("✅ Donut module imported successfully")
    except ImportError as e:
        print(f"❌ Donut module import failed: {e}")
        return False
    
    try:
        import sentencepiece
        print("✅ SentencePiece imported successfully")
    except ImportError as e:
        print(f"❌ SentencePiece import failed: {e}")
        return False
    
    try:
        import transformers
        print(f"✅ Transformers version: {transformers.__version__}")
    except ImportError as e:
        print(f"❌ Transformers import failed: {e}")
        return False
    
    try:
        import gradio
        print(f"✅ Gradio version: {gradio.__version__}")
    except ImportError as e:
        print(f"❌ Gradio import failed: {e}")
        return False
    
    # Test CUDA availability
    if torch.cuda.is_available():
        print(f"✅ CUDA available: {torch.cuda.get_device_name(0)}")
    else:
        print("ℹ️  CUDA not available, will use CPU")
    
    return True

def test_image_loading():
    """Test image loading functionality"""
    print("\n📸 Testing Image Loading")
    print("=" * 30)
    
    sample_images = [
        "misc/sample_image_cord_test_receipt_00004.png",
        "misc/sample_image_donut_document.png"
    ]
    
    for img_path in sample_images:
        if os.path.exists(img_path):
            try:
                image = Image.open(img_path)
                print(f"✅ Loaded {img_path}: {image.size} ({image.mode})")
            except Exception as e:
                print(f"❌ Failed to load {img_path}: {e}")
        else:
            print(f"⚠️  Image not found: {img_path}")

def test_model_loading():
    """Test model loading with error handling"""
    print("\n🤖 Testing Model Loading")
    print("=" * 30)
    
    try:
        from donut import DonutModel
        
        # Try loading a smaller model first
        print("Attempting to load donut-base model...")
        model = DonutModel.from_pretrained("naver-clova-ix/donut-base")
        print("✅ Base model loaded successfully!")
        
        # Test inference with a simple prompt
        if os.path.exists("misc/sample_image_cord_test_receipt_00004.png"):
            image = Image.open("misc/sample_image_cord_test_receipt_00004.png")
            prompt = "<s_cord>"
            
            with torch.no_grad():
                result = model.inference(image=image, prompt=prompt)
                print("✅ Inference test successful!")
                print(f"   Prediction: {result['predictions'][0][:100]}...")
        
        return True
        
    except Exception as e:
        print(f"❌ Model loading failed: {e}")
        print("\n🔧 This is likely due to version compatibility issues.")
        print("   The model architecture has changed between versions.")
        return False

def show_alternative_solutions():
    """Show alternative solutions for using Donut"""
    print("\n🎯 Alternative Solutions")
    print("=" * 30)
    
    print("1. 🌐 Online Demos (Recommended):")
    print("   - CORD Demo: https://huggingface.co/spaces/naver-clova-ix/donut-base-finetuned-cord-v2")
    print("   - RVL-CDIP Demo: https://huggingface.co/spaces/nielsr/donut-rvlcdip")
    print("   - DocVQA Demo: https://huggingface.co/spaces/nielsr/donut-docvqa")
    
    print("\n2. 📚 Google Colab Demos:")
    print("   - CORD Colab: https://colab.research.google.com/drive/1NMSqoIZ_l39wyRD7yVjw2FIuU2aglzJi")
    print("   - Train Ticket Colab: https://colab.research.google.com/drive/1YJBjllahdqNktXaBlq5ugPh1BCm8OsxI")
    print("   - RVL-CDIP Colab: https://colab.research.google.com/drive/1iWOZHvao1W5xva53upcri5V6oaWT-P0O")
    
    print("\n3. 🔧 Fix Options:")
    print("   - Try different model versions")
    print("   - Use conda environment with specific package versions")
    print("   - Install from source with compatible versions")

def main():
    parser = argparse.ArgumentParser(description="Test Donut Project Setup")
    parser.add_argument("--full-test", action="store_true", help="Run full model loading test")
    args = parser.parse_args()
    
    print("🍩 Donut Project Test Suite")
    print("=" * 50)
    
    # Test environment
    env_ok = test_environment()
    
    # Test image loading
    test_image_loading()
    
    # Test model loading if requested
    if args.full_test:
        model_ok = test_model_loading()
    else:
        print("\n🤖 Model Loading Test (Skipped)")
        print("=" * 30)
        print("ℹ️  Use --full-test to attempt model loading")
        model_ok = False
    
    # Show alternatives
    show_alternative_solutions()
    
    # Summary
    print("\n📊 Test Summary")
    print("=" * 20)
    print(f"Environment: {'✅ OK' if env_ok else '❌ Issues'}")
    print(f"Model Loading: {'✅ OK' if model_ok else '❌ Issues (Expected)'}")
    
    if env_ok:
        print("\n🎉 Your Donut environment is properly set up!")
        print("   You can use the online demos or try the model loading with --full-test")
    else:
        print("\n⚠️  There are some environment issues to resolve")

if __name__ == "__main__":
    main() 