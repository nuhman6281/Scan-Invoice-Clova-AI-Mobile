#!/usr/bin/env python3
"""
Alternative OCR Demo - Uses working OCR libraries for real results
This provides actual OCR functionality without the Donut model issues
"""

import gradio as gr
from PIL import Image
import json
import os
import subprocess
import sys

def install_ocr_dependencies():
    """Install alternative OCR libraries"""
    try:
        # Try to install EasyOCR
        subprocess.check_call([sys.executable, "-m", "pip", "install", "easyocr"])
        print("✅ EasyOCR installed successfully")
        return True
    except Exception as e:
        print(f"❌ Failed to install EasyOCR: {e}")
        return False

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
        
        # Format results
        extracted_text = []
        for (bbox, text, confidence) in results:
            extracted_text.append({
                "text": text,
                "confidence": float(confidence),
                "bbox": bbox
            })
        
        return {
            "ocr_engine": "EasyOCR",
            "status": "Success",
            "extracted_text": extracted_text,
            "total_words": len([item["text"] for item in extracted_text]),
            "average_confidence": sum([item["confidence"] for item in extracted_text]) / len(extracted_text) if extracted_text else 0
        }
        
    except Exception as e:
        return {
            "error": f"EasyOCR failed: {str(e)}",
            "suggestion": "Try installing: pip install easyocr"
        }

def extract_text_tesseract(image):
    """Extract text using Tesseract (if available)"""
    try:
        import pytesseract
        
        # Convert to PIL Image if needed
        if hasattr(image, 'shape'):
            image = Image.fromarray(image)
        
        # Extract text
        text = pytesseract.image_to_string(image)
        
        # Get additional data
        data = pytesseract.image_to_data(image, output_type=pytesseract.Output.DICT)
        
        return {
            "ocr_engine": "Tesseract",
            "status": "Success",
            "extracted_text": text.strip(),
            "word_count": len(text.split()),
            "confidence": "Available in detailed output"
        }
        
    except ImportError:
        return {
            "error": "Tesseract not available",
            "suggestion": "Install with: brew install tesseract && pip install pytesseract"
        }
    except Exception as e:
        return {
            "error": f"Tesseract failed: {str(e)}",
            "suggestion": "Check if tesseract is installed"
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
    else:
        result = {"error": "Unknown OCR method"}
    
    # Add image info to result
    result["image_info"] = image_info
    
    return json.dumps(result, indent=2)

def create_ocr_demo():
    """Create the OCR demo interface"""
    
    with gr.Blocks(title="Alternative OCR Demo") as demo:
        gr.Markdown("# 🔍 Alternative OCR Demo")
        gr.Markdown("## Real Text Extraction Without Donut Model Issues")
        
        gr.Markdown("""
        This demo uses alternative OCR libraries that work reliably:
        
        - **EasyOCR**: Modern OCR with good accuracy
        - **Tesseract**: Classic OCR engine (if installed)
        
        These provide real text extraction without the model compatibility issues.
        """)
        
        with gr.Tab("🔍 Text Extraction"):
            image_input = gr.Image(label="Upload Document Image")
            ocr_method = gr.Radio(
                choices=["easyocr", "tesseract"],
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
        
        with gr.Tab("📋 Installation Guide"):
            gr.Markdown("""
            ### Installing OCR Libraries
            
            **EasyOCR (Recommended):**
            ```bash
            pip install easyocr
            ```
            
            **Tesseract (macOS):**
            ```bash
            brew install tesseract
            pip install pytesseract
            ```
            
            **PaddleOCR (Alternative):**
            ```bash
            pip install paddleocr
            ```
            """)
        
        with gr.Tab("🎯 Working Hugging Face Demos"):
            gr.Markdown("""
            ### If Hugging Face demos have build errors, try these:
            
            **Alternative CORD Demo:**
            - https://huggingface.co/spaces/nielsr/donut-base-finetuned-cord-v2
            
            **Google Colab (Always Works):**
            - https://colab.research.google.com/drive/1NMSqoIZ_l39wyRD7yVjw2FIuU2aglzJi
            
            **Direct Model Usage:**
            ```python
            from transformers import DonutProcessor, VisionEncoderDecoderModel
            processor = DonutProcessor.from_pretrained("naver-clova-ix/donut-base-finetuned-cord-v2")
            model = VisionEncoderDecoderModel.from_pretrained("naver-clova-ix/donut-base-finetuned-cord-v2")
            ```
            """)
    
    return demo

def main():
    """Main function"""
    print("🔍 Starting Alternative OCR Demo...")
    print("=" * 50)
    
    # Try to install dependencies
    print("📦 Checking OCR dependencies...")
    install_ocr_dependencies()
    
    # Create and launch demo
    demo = create_ocr_demo()
    
    print("🚀 Launching OCR demo...")
    print("🔗 Access via: http://localhost:7863")
    print("🎯 This provides real OCR functionality!")
    
    demo.launch(
        server_name="0.0.0.0",
        server_port=7863,
        share=False,
        show_error=True
    )

if __name__ == "__main__":
    main() 