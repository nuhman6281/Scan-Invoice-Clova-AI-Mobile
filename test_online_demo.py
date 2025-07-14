#!/usr/bin/env python3
"""
Test Online Demo - Shows how to use the working online demos
"""

import webbrowser
import time
import os

def open_online_demos():
    """Open all online demos in browser"""
    
    demos = {
        "CORD (Document Parsing)": "https://huggingface.co/spaces/naver-clova-ix/donut-base-finetuned-cord-v2",
        "RVL-CDIP (Classification)": "https://huggingface.co/spaces/nielsr/donut-rvlcdip",
        "DocVQA (Question Answering)": "https://huggingface.co/spaces/nielsr/donut-docvqa"
    }
    
    print("🌐 Opening Online Demos...")
    print("=" * 50)
    
    for name, url in demos.items():
        print(f"🔗 Opening {name}...")
        webbrowser.open(url)
        time.sleep(2)  # Wait between openings
    
    print("\n✅ All demos opened in your browser!")
    print("\n📝 Instructions:")
    print("1. Wait for each demo to load (30-60 seconds)")
    print("2. Upload your images")
    print("3. Get real AI results!")

def show_demo_instructions():
    """Show detailed instructions"""
    
    instructions = """
# 🍩 How to Use Online Demos for Real OCR Results

## 🎯 **CORD Demo (Document Parsing)**
**URL**: https://huggingface.co/spaces/naver-clova-ix/donut-base-finetuned-cord-v2

### Step-by-Step:
1. **Open the link** in your browser
2. **Wait for loading** (30-60 seconds - be patient!)
3. **Upload image** by clicking upload area or drag & drop
4. **Click Submit** or wait for auto-processing
5. **View results** - structured JSON with extracted data

### Example Results:
```json
{
  "menu": [
    {
      "nm": "Cappuccino",
      "cnt": "1", 
      "price": "4.50"
    },
    {
      "nm": "Croissant",
      "cnt": "2",
      "price": "3.25"
    }
  ],
  "total": {
    "total_price": "10.00",
    "cashprice": "15.00", 
    "changeprice": "5.00"
  }
}
```

## 🏷️ **RVL-CDIP Demo (Document Classification)**
**URL**: https://huggingface.co/spaces/nielsr/donut-rvlcdip

### Step-by-Step:
1. **Open the link**
2. **Upload any document image**
3. **Get classification** (invoice, letter, form, etc.)

### Example Results:
```json
{"class": "invoice"}
```

## ❓ **DocVQA Demo (Question Answering)**
**URL**: https://huggingface.co/spaces/nielsr/donut-docvqa

### Step-by-Step:
1. **Open the link**
2. **Upload document image**
3. **Type question** like "What is the total amount?"
4. **Get AI answer**

### Example Results:
```json
{"answer": "The total amount is $25.50"}
```

## 📸 **Test Images You Can Use:**
- Receipt images (for CORD)
- Any document (for RVL-CDIP)
- Documents with text (for DocVQA)

## ⚡ **Pro Tips:**
- **Be patient** - demos take 30-60 seconds to load
- **Use clear images** - better results with good quality
- **Try different images** - test various document types
- **Check the JSON output** - structured data is extracted

## 🎉 **Why These Work:**
- **Hosted on Hugging Face** - no local setup needed
- **Pre-configured models** - all compatibility issues solved
- **Real AI processing** - actual OCR and understanding
- **Instant results** - no model loading delays
    """
    
    print(instructions)

def main():
    """Main function"""
    print("🍩 Online Demo Guide")
    print("=" * 50)
    
    print("Choose an option:")
    print("1. Open all demos in browser")
    print("2. Show detailed instructions")
    print("3. Both")
    
    choice = input("Enter choice (1-3): ").strip()
    
    if choice in ["1", "3"]:
        open_online_demos()
    
    if choice in ["2", "3"]:
        show_demo_instructions()
    
    print("\n🎯 **Quick Start:**")
    print("1. Go to: https://huggingface.co/spaces/naver-clova-ix/donut-base-finetuned-cord-v2")
    print("2. Wait for it to load")
    print("3. Upload an image")
    print("4. Get real AI results!")

if __name__ == "__main__":
    main() 