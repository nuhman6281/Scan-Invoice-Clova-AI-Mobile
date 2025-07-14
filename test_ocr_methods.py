#!/usr/bin/env python3
"""
Test OCR Methods - Verify all OCR engines are working
"""

import subprocess
import sys
from PIL import Image

def test_tesseract():
    """Test Tesseract OCR"""
    print("🔍 Testing Tesseract...")
    try:
        import pytesseract
        
        # Test with a simple image
        if os.path.exists("misc/sample_image_cord_test_receipt_00004.png"):
            image = Image.open("misc/sample_image_cord_test_receipt_00004.png")
            text = pytesseract.image_to_string(image)
            print("✅ Tesseract working!")
            print(f"   Extracted text: {text[:100]}...")
            return True
        else:
            print("⚠️  No test image found")
            return False
            
    except Exception as e:
        print(f"❌ Tesseract failed: {e}")
        return False

def test_easyocr():
    """Test EasyOCR"""
    print("🔍 Testing EasyOCR...")
    try:
        import easyocr
        
        # Test initialization
        reader = easyocr.Reader(['en'])
        print("✅ EasyOCR working!")
        return True
        
    except Exception as e:
        print(f"❌ EasyOCR failed: {e}")
        return False

def test_paddleocr():
    """Test PaddleOCR"""
    print("🔍 Testing PaddleOCR...")
    try:
        from paddleocr import PaddleOCR
        
        # Test initialization
        ocr = PaddleOCR(use_angle_cls=True, lang='en')
        print("✅ PaddleOCR working!")
        return True
        
    except Exception as e:
        print(f"❌ PaddleOCR failed: {e}")
        return False

def install_missing():
    """Install missing OCR libraries"""
    print("📦 Installing missing OCR libraries...")
    
    libraries = [
        ("easyocr", "easyocr"),
        ("pytesseract", "pytesseract"),
        ("paddleocr", "paddleocr")
    ]
    
    for name, package in libraries:
        try:
            __import__(name)
            print(f"✅ {name} already installed")
        except ImportError:
            print(f"📦 Installing {package}...")
            try:
                subprocess.check_call([sys.executable, "-m", "pip", "install", package])
                print(f"✅ {package} installed successfully")
            except Exception as e:
                print(f"❌ Failed to install {package}: {e}")

def main():
    """Main function"""
    print("🔍 OCR Methods Test")
    print("=" * 50)
    
    # Install missing libraries
    install_missing()
    
    print("\n🧪 Testing OCR Engines...")
    
    # Test each OCR method
    results = {
        "Tesseract": test_tesseract(),
        "EasyOCR": test_easyocr(),
        "PaddleOCR": test_paddleocr()
    }
    
    print("\n📊 Test Results:")
    print("=" * 30)
    
    working_count = 0
    for name, working in results.items():
        status = "✅ Working" if working else "❌ Failed"
        print(f"{name}: {status}")
        if working:
            working_count += 1
    
    print(f"\n🎯 Summary: {working_count}/3 OCR engines working")
    
    if working_count > 0:
        print("✅ You have working OCR functionality!")
        print("🔗 Access the demo at: http://localhost:7864")
    else:
        print("❌ No OCR engines working. Check installations.")

if __name__ == "__main__":
    import os
    main() 