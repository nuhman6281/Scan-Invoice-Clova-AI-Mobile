#!/usr/bin/env python3
"""
Test script to check Donut model output directly
"""

import torch
from transformers import DonutProcessor, VisionEncoderDecoderModel
from PIL import Image
import json

def test_donut_model():
    print("🔍 Testing Donut model directly...")
    
    # Load model
    print("📦 Loading model...")
    processor = DonutProcessor.from_pretrained("naver-clova-ix/donut-base")
    model = VisionEncoderDecoderModel.from_pretrained("naver-clova-ix/donut-base-finetuned-cord-v2")
    
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model.to(device)
    model.eval()
    
    print(f"✅ Model loaded on {device}")
    
    # Load test image
    print("🖼️  Loading test image...")
    image_path = "../../misc/sample_image_cord_test_receipt_00004.png"
    image = Image.open(image_path)
    print(f"✅ Image loaded: {image.size}")
    
    # Process image
    print("🔍 Processing image...")
    pixel_values = processor(image, return_tensors="pt").pixel_values
    pixel_values = pixel_values.to(device)
    
    # Generate with task prompt
    task_prompt = "<s_cord-v2>"
    decoder_input_ids = processor.tokenizer(
        task_prompt, 
        add_special_tokens=False, 
        return_tensors="pt"
    ).input_ids.to(device)
    
    print(f"📝 Using task prompt: {task_prompt}")
    
    # Generate prediction
    with torch.no_grad():
        outputs = model.generate(
            pixel_values,
            decoder_input_ids=decoder_input_ids,
            max_length=512,
            pad_token_id=processor.tokenizer.pad_token_id,
            eos_token_id=processor.tokenizer.eos_token_id,
            use_cache=True,
            early_stopping=True,
            do_sample=False,
            num_beams=1
        )
    
    # Decode result
    sequence = processor.batch_decode(outputs, skip_special_tokens=True)[0]
    
    print("\n" + "="*50)
    print("📊 RAW MODEL OUTPUT:")
    print("="*50)
    print(f"Output: '{sequence}'")
    print(f"Length: {len(sequence)}")
    print(f"Type: {type(sequence)}")
    
    # Try to parse
    print("\n" + "="*50)
    print("🔍 PARSING ATTEMPTS:")
    print("="*50)
    
    # Remove task prompt
    if sequence.startswith("<s_cord-v2>"):
        clean_sequence = sequence[len("<s_cord-v2>"):].strip()
        print(f"After removing prompt: '{clean_sequence}'")
    else:
        clean_sequence = sequence.strip()
        print(f"After stripping: '{clean_sequence}'")
    
    # Try JSON parsing
    try:
        data = json.loads(clean_sequence)
        print(f"✅ JSON parsing successful: {json.dumps(data, indent=2)}")
    except json.JSONDecodeError as e:
        print(f"❌ JSON parsing failed: {e}")
        print(f"Raw text for manual inspection: '{clean_sequence}'")
    
    print("\n" + "="*50)
    print("✅ Test completed!")

if __name__ == "__main__":
    test_donut_model() 