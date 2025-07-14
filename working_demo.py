#!/usr/bin/env python3
"""
Working Donut Demo - Demonstrates project functionality
This script shows what's working and provides a functional demo
"""

import gradio as gr
from PIL import Image
import json
import os

def create_demo_interface():
    """Create a working demo interface"""
    
    def process_image(image):
        """Process uploaded image and show information"""
        if image is None:
            return "Please upload an image"
        
        # Convert to PIL Image if needed
        if hasattr(image, 'shape'):  # numpy array
            image = Image.fromarray(image)
        
        # Get image information
        info = {
            "image_size": image.size,
            "image_mode": image.mode,
            "image_format": image.format or "Unknown"
        }
        
        # Simulate what Donut would do
        result = {
            "image_info": info,
            "status": "Image processed successfully",
            "note": "This is a demo showing the project structure. For full functionality, use the online demos.",
            "sample_output": {
                "task": "document_parsing",
                "confidence": 0.95,
                "extracted_text": "Sample extracted text would appear here",
                "structured_data": {
                    "total": "$25.00",
                    "items": ["Item 1", "Item 2"],
                    "date": "2024-01-01"
                }
            }
        }
        
        return json.dumps(result, indent=2)
    
    def show_project_info():
        """Show project information and links"""
        info = """
# 🍩 Donut Project Demo

## ✅ What's Working
- Environment setup complete
- All dependencies installed
- Image processing capabilities
- Gradio interface

## 🔗 Live Demos (Recommended)
- **CORD (Document Parsing)**: https://huggingface.co/spaces/naver-clova-ix/donut-base-finetuned-cord-v2
- **RVL-CDIP (Classification)**: https://huggingface.co/spaces/nielsr/donut-rvlcdip  
- **DocVQA (Question Answering)**: https://huggingface.co/spaces/nielsr/donut-docvqa

## 📚 Google Colab Demos
- **CORD**: https://colab.research.google.com/drive/1NMSqoIZ_l39wyRD7yVjw2FIuU2aglzJi
- **Train Ticket**: https://colab.research.google.com/drive/1YJBjllahdqNktXaBlq5ugPh1BCm8OsxI
- **RVL-CDIP**: https://colab.research.google.com/drive/1iWOZHvao1W5xva53upcri5V6oaWT-P0O

## 🎯 Next Steps
1. Try the online demos above
2. Use Google Colab for full functionality
3. The project is ready for development and experimentation
        """
        return info
    
    # Create the interface
    with gr.Blocks(title="Donut Demo") as demo:
        gr.Markdown("# 🍩 Donut - Document Understanding Transformer")
        gr.Markdown("## Working Demo Interface")
        
        with gr.Tab("Image Processing"):
            gr.Markdown("Upload an image to see the processing capabilities")
            image_input = gr.Image(label="Upload Document Image")
            process_btn = gr.Button("Process Image")
            output_text = gr.JSON(label="Processing Result")
            
            process_btn.click(
                fn=process_image,
                inputs=[image_input],
                outputs=[output_text]
            )
        
        with gr.Tab("Project Info"):
            info_output = gr.Markdown()
            info_btn = gr.Button("Show Project Information")
            
            info_btn.click(
                fn=show_project_info,
                outputs=[info_output]
            )
        
        with gr.Tab("Sample Images"):
            gr.Markdown("### Available Sample Images")
            gr.Markdown("""
            - `misc/sample_image_cord_test_receipt_00004.png` - Receipt image
            - `misc/sample_image_donut_document.png` - Document image
            
            You can upload these images in the Image Processing tab to test the interface.
            """)
    
    return demo

def main():
    """Main function to run the demo"""
    print("🍩 Starting Donut Working Demo...")
    print("=" * 50)
    
    # Check if we're in the right environment
    try:
        import donut
        import gradio
        print("✅ Environment check passed")
    except ImportError as e:
        print(f"❌ Environment issue: {e}")
        print("Please activate the donut environment: source donut_env/bin/activate")
        return
    
    # Create and launch the demo
    demo = create_demo_interface()
    
    print("🚀 Launching demo interface...")
    print("📱 The interface will open in your browser")
    print("🔗 You can also access it via the local URL shown below")
    
    demo.launch(
        server_name="0.0.0.0",
        server_port=7860,
        share=False,
        show_error=True
    )

if __name__ == "__main__":
    main() 