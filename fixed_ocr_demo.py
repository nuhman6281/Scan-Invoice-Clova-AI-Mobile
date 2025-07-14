#!/usr/bin/env python3
"""
Fixed OCR Demo - Handles JSON serialization and includes Tesseract
"""

import gradio as gr
from PIL import Image
import json
import os
import subprocess
import sys
import numpy as np

def install_dependencies():
    """Install OCR dependencies"""
    print("📦 Installing OCR dependencies...")
    
    # Install EasyOCR
    try:
        subprocess.check_call([sys.executable, "-m", "pip", "install", "easyocr"])
        print("✅ EasyOCR installed successfully")
    except Exception as e:
        print(f"❌ Failed to install EasyOCR: {e}")
    
    # Install pytesseract
    try:
        subprocess.check_call([sys.executable, "-m", "pip", "install", "pytesseract"])
        print("✅ pytesseract installed successfully")
    except Exception as e:
        print(f"❌ Failed to install pytesseract: {e}")
    
    # Check if tesseract is installed system-wide
    try:
        subprocess.run(["tesseract", "--version"], capture_output=True, check=True)
        print("✅ Tesseract is already installed")
    except:
        print("⚠️  Tesseract not found. Install with: brew install tesseract")

def convert_numpy_types(obj):
    """Convert numpy types to Python native types for JSON serialization"""
    if isinstance(obj, np.integer):
        return int(obj)
    elif isinstance(obj, np.floating):
        return float(obj)
    elif isinstance(obj, np.ndarray):
        return obj.tolist()
    elif isinstance(obj, list):
        return [convert_numpy_types(item) for item in obj]
    elif isinstance(obj, dict):
        return {key: convert_numpy_types(value) for key, value in obj.items()}
    else:
        return obj

def extract_text_easyocr(image):
    """Extract text using EasyOCR"""
    try:
        import easyocr
        
        # Convert to PIL Image if needed
        if hasattr(image, 'shape'):
            image = Image.fromarray(image)
        
        # Save image temporarily
        temp_path = "temp_image.jpg"
        image.save(temp_path)
        
        # Initialize EasyOCR
        reader = easyocr.Reader(['en'])
        
        # Extract text
        results = reader.readtext(temp_path)
        
        # Clean up
        if os.path.exists(temp_path):
            os.remove(temp_path)
        
        # Format results with proper type conversion
        extracted_text = []
        for (bbox, text, confidence) in results:
            extracted_text.append({
                "text": text,
                "confidence": float(confidence),
                "bbox": convert_numpy_types(bbox)
            })
        
        result = {
            "ocr_engine": "EasyOCR",
            "status": "Success",
            "extracted_text": extracted_text,
            "total_words": len([item["text"] for item in extracted_text]),
            "average_confidence": sum([item["confidence"] for item in extracted_text]) / len(extracted_text) if extracted_text else 0
        }
        
        return convert_numpy_types(result)
        
    except Exception as e:
        return {
            "error": f"EasyOCR failed: {str(e)}",
            "suggestion": "Try installing: pip install easyocr"
        }

def extract_text_tesseract(image):
    """Extract text using Tesseract"""
    try:
        import pytesseract
        
        # Convert to PIL Image if needed
        if hasattr(image, 'shape'):
            image = Image.fromarray(image)
        
        # Extract text
        text = pytesseract.image_to_string(image)
        
        # Get additional data
        data = pytesseract.image_to_data(image, output_type=pytesseract.Output.DICT)
        
        # Process the data
        words = []
        for i in range(len(data['text'])):
            if data['conf'][i] > 0:  # Only include words with confidence > 0
                words.append({
                    "text": data['text'][i],
                    "confidence": data['conf'][i],
                    "bbox": [data['left'][i], data['top'][i], data['width'][i], data['height'][i]]
                })
        
        result = {
            "ocr_engine": "Tesseract",
            "status": "Success",
            "extracted_text": text.strip(),
            "words": words,
            "word_count": len(text.split()),
            "average_confidence": sum([w['confidence'] for w in words]) / len(words) if words else 0
        }
        
        return convert_numpy_types(result)
        
    except ImportError:
        return {
            "error": "Tesseract not available",
            "suggestion": "Install with: brew install tesseract && pip install pytesseract"
        }
    except Exception as e:
        return {
            "error": f"Tesseract failed: {str(e)}",
            "suggestion": "Check if tesseract is installed: brew install tesseract"
        }

def extract_text_paddleocr(image):
    """Extract text using PaddleOCR"""
    try:
        from paddleocr import PaddleOCR
        
        # Convert to PIL Image if needed
        if hasattr(image, 'shape'):
            image = Image.fromarray(image)
        
        # Save image temporarily
        temp_path = "temp_image.jpg"
        image.save(temp_path)
        
        # Initialize PaddleOCR
        ocr = PaddleOCR(use_angle_cls=True, lang='en')
        
        # Extract text
        results = ocr.ocr(temp_path)
        
        # Clean up
        if os.path.exists(temp_path):
            os.remove(temp_path)
        
        # Format results
        extracted_text = []
        if results and results[0]:
            for line in results[0]:
                if line:
                    bbox, (text, confidence) = line
                    extracted_text.append({
                        "text": text,
                        "confidence": float(confidence),
                        "bbox": convert_numpy_types(bbox)
                    })
        
        result = {
            "ocr_engine": "PaddleOCR",
            "status": "Success",
            "extracted_text": extracted_text,
            "total_words": len([item["text"] for item in extracted_text]),
            "average_confidence": sum([item["confidence"] for item in extracted_text]) / len(extracted_text) if extracted_text else 0
        }
        
        return convert_numpy_types(result)
        
    except ImportError:
        return {
            "error": "PaddleOCR not available",
            "suggestion": "Install with: pip install paddleocr"
        }
    except Exception as e:
        return {
            "error": f"PaddleOCR failed: {str(e)}",
            "suggestion": "Try installing: pip install paddleocr"
        }

def process_image_ocr(image, ocr_method="easyocr"):
    """Process image with OCR"""
    if image is None:
        return "Please upload an image"
    
    # Get image info
    if hasattr(image, 'shape'):
        pil_image = Image.fromarray(image)
    else:
        pil_image = image
    
    image_info = {
        "image_size": pil_image.size,
        "image_mode": pil_image.mode,
        "image_format": pil_image.format or "Unknown"
    }
    
    # Process with selected OCR method
    if ocr_method == "easyocr":
        result = extract_text_easyocr(image)
    elif ocr_method == "tesseract":
        result = extract_text_tesseract(image)
    elif ocr_method == "paddleocr":
        result = extract_text_paddleocr(image)
    else:
        result = {"error": "Unknown OCR method"}
    
    # Add image info to result
    result["image_info"] = image_info
    
    # Convert to JSON safely
    try:
        return json.dumps(result, indent=2, ensure_ascii=False)
    except Exception as e:
        # Fallback: convert to string representation
        return str(result)

def create_fixed_ocr_demo():
    """Create the fixed OCR demo interface"""
    
    with gr.Blocks(title="Fixed OCR Demo") as demo:
        gr.Markdown("# 🔍 Fixed OCR Demo")
        gr.Markdown("## Real Text Extraction - All Issues Fixed")
        
        gr.Markdown("""
        This demo uses multiple OCR engines with proper JSON handling:
        
        - **EasyOCR**: Modern OCR with good accuracy
        - **Tesseract**: Classic OCR engine (requires system installation)
        - **PaddleOCR**: Fast OCR from Baidu
        
        All JSON serialization issues have been fixed!
        """)
        
        with gr.Tab("🔍 Text Extraction"):
            image_input = gr.Image(label="Upload Document Image")
            ocr_method = gr.Radio(
                choices=["easyocr", "tesseract", "paddleocr"],
                value="easyocr",
                label="OCR Method"
            )
            process_btn = gr.Button("🔍 Extract Text", variant="primary")
            output_text = gr.JSON(label="OCR Results")
            
            process_btn.click(
                fn=process_image_ocr,
                inputs=[image_input, ocr_method],
                outputs=[output_text]
            )
        
        with gr.Tab("📋 Installation Status"):
            gr.Markdown("""
            ### Installation Commands
            
            **EasyOCR (Recommended - Works immediately):**
            ```bash
            pip install easyocr
            ```
            
            **Tesseract (macOS):**
            ```bash
            brew install tesseract
            pip install pytesseract
            ```
            
            **PaddleOCR:**
            ```bash
            pip install paddleocr
            ```
            
            ### Current Status
            - ✅ EasyOCR: Should work immediately
            - ⚠️ Tesseract: Requires system installation
            - ⚠️ PaddleOCR: Requires installation
            """)
        
        with gr.Tab("🎯 Working Solutions"):
            gr.Markdown("""
            ### If you want full AI document understanding:
            
            **Google Colab (100% Success Rate):**
            - [CORD Colab](https://colab.research.google.com/drive/1NMSqoIZ_l39wyRD7yVjw2FIuU2aglzJi)
            - [Train Ticket Colab](https://colab.research.google.com/drive/1YJBjllahdqNktXaBlq5ugPh1BCm8OsxI)
            
            **Alternative Hugging Face:**
            - [Alternative CORD](https://huggingface.co/spaces/nielsr/donut-base-finetuned-cord-v2)
            - [Alternative RVL-CDIP](https://huggingface.co/spaces/nielsr/donut-rvlcdip)
            """)
    
    return demo

def main():
    """Main function"""
    print("🔧 Starting Fixed OCR Demo...")
    print("=" * 50)
    
    # Install dependencies
    install_dependencies()
    
    # Create and launch demo
    demo = create_fixed_ocr_demo()
    
    print("🚀 Launching fixed OCR demo...")
    print("🔗 Access via: http://localhost:7864")
    print("🎯 All JSON issues fixed!")
    
    demo.launch(
        server_name="0.0.0.0",
        server_port=7864,
        share=False,
        show_error=True
    )

if __name__ == "__main__":
    main() 