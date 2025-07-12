#!/usr/bin/env python3
"""
Test different Donut model variants and task prompts
"""

import torch
from transformers import DonutProcessor, VisionEncoderDecoderModel
from PIL import Image
import json

def test_model_variant(model_name, processor_name, task_prompt, description):
    print(f"\n{'='*60}")
    print(f"🧪 Testing: {description}")
    print(f"Model: {model_name}")
    print(f"Processor: {processor_name}")
    print(f"Task Prompt: {task_prompt}")
    print(f"{'='*60}")
    
    try:
        # Load model
        print("📦 Loading model...")
        processor = DonutProcessor.from_pretrained(processor_name)
        model = VisionEncoderDecoderModel.from_pretrained(model_name)
        
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
        decoder_input_ids = processor.tokenizer(
            task_prompt, 
            add_special_tokens=False, 
            return_tensors="pt"
        ).input_ids.to(device)
        
        # Generate prediction
        with torch.no_grad():
            outputs = model.generate(
                pixel_values,
                decoder_input_ids=decoder_input_ids,
                max_length=512,
                pad_token_id=processor.tokenizer.pad_token_id,
                eos_token_id=processor.tokenizer.eos_token_id,
                use_cache=True,
                do_sample=False,
                num_beams=1
            )
        
        # Decode result
        sequence = processor.batch_decode(outputs, skip_special_tokens=True)[0]
        
        print(f"📊 Raw output: '{sequence}'")
        print(f"📏 Length: {len(sequence)}")
        
        # Clean up
        if sequence.startswith(task_prompt):
            clean_sequence = sequence[len(task_prompt):].strip()
        else:
            clean_sequence = sequence.strip()
        
        print(f"🧹 Cleaned: '{clean_sequence}'")
        
        # Check if it's just dashes
        if clean_sequence.replace("-", "").strip() == "":
            print("❌ Output is only dashes - model not working properly")
            return False
        else:
            print("✅ Output contains actual content!")
            
            # Try JSON parsing
            try:
                data = json.loads(clean_sequence)
                print(f"✅ JSON parsing successful: {json.dumps(data, indent=2)}")
                return True
            except json.JSONDecodeError:
                print(f"⚠️  Not valid JSON, but has content: '{clean_sequence[:100]}...'")
                return True
                
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def main():
    print("🚀 Testing different Donut model variants...")
    
    # Test configurations
    configs = [
        {
            "model": "naver-clova-ix/donut-base",
            "processor": "naver-clova-ix/donut-base", 
            "prompt": "<s_cord>",
            "description": "Base Donut model with CORD prompt"
        },
        {
            "model": "naver-clova-ix/donut-base",
            "processor": "naver-clova-ix/donut-base",
            "prompt": "<s_cord-v2>", 
            "description": "Base Donut model with CORD-v2 prompt"
        },
        {
            "model": "naver-clova-ix/donut-base-finetuned-cord-v2",
            "processor": "naver-clova-ix/donut-base",
            "prompt": "<s_cord>",
            "description": "CORD-v2 fine-tuned model with CORD prompt"
        },
        {
            "model": "naver-clova-ix/donut-base-finetuned-cord-v2",
            "processor": "naver-clova-ix/donut-base", 
            "prompt": "<s_cord-v2>",
            "description": "CORD-v2 fine-tuned model with CORD-v2 prompt"
        },
        {
            "model": "naver-clova-ix/donut-base",
            "processor": "naver-clova-ix/donut-base",
            "prompt": "<s_rvlcdip>",
            "description": "Base Donut model with RVL-CDIP prompt (document classification)"
        }
    ]
    
    working_configs = []
    
    for config in configs:
        success = test_model_variant(
            config["model"],
            config["processor"], 
            config["prompt"],
            config["description"]
        )
        
        if success:
            working_configs.append(config)
    
    print(f"\n{'='*60}")
    print("📋 SUMMARY")
    print(f"{'='*60}")
    print(f"✅ Working configurations: {len(working_configs)}")
    print(f"❌ Failed configurations: {len(configs) - len(working_configs)}")
    
    if working_configs:
        print("\n🎉 Working configs:")
        for config in working_configs:
            print(f"  - {config['description']}")
    else:
        print("\n😞 No working configurations found")

if __name__ == "__main__":
    main() 