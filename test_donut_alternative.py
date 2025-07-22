"""
Alternative Donut Test using direct model generation
"""
import json
from PIL import Image
from donut import DonutModel
import torch
from transformers import DonutProcessor

def test_donut_alternative():
    """Test Donut using direct generation approach"""
    print("🧪 Testing Donut CORD-v2 Model (Alternative Method)")
    print("=" * 60)
    
    # Load processor and model separately
    print("📥 Loading processor...")
    processor = DonutProcessor.from_pretrained("naver-clova-ix/donut-base-finetuned-cord-v2")
    
    print("📥 Loading model...")
    model = DonutModel.from_pretrained("naver-clova-ix/donut-base-finetuned-cord-v2")
    
    # Set device
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f"🖥️  Using device: {device}")
    
    if torch.cuda.is_available():
        model.half()
        model.to(device)
    
    model.eval()
    print("✅ Model loaded successfully!")
    
    # Load sample image
    print("\n📷 Loading sample image...")
    try:
        image = Image.open("misc/sample_image_cord_test_receipt_00004.png")
        print(f"✅ Image loaded: {image.size}")
    except Exception as e:
        print(f"❌ Failed to load image: {e}")
        return
    
    # Process image using processor
    print("\n🔍 Processing image with processor...")
    task_prompt = "<s_cord-v2>"
    
    try:
        # Prepare inputs
        pixel_values = processor(image, return_tensors="pt").pixel_values
        if torch.cuda.is_available():
            pixel_values = pixel_values.half()
        
        # Prepare decoder inputs
        decoder_input_ids = processor.tokenizer(
            task_prompt, 
            add_special_tokens=False, 
            return_tensors="pt"
        ).input_ids
        
        if torch.cuda.is_available():
            decoder_input_ids = decoder_input_ids.to(device)
            pixel_values = pixel_values.to(device)
        
        # Generate
        print("Generating with model...")
        with torch.no_grad():
            outputs = model.generate(
                pixel_values,
                decoder_input_ids=decoder_input_ids,
                max_length=model.decoder.config.max_position_embeddings,
                early_stopping=True,
                pad_token_id=processor.tokenizer.pad_token_id,
                eos_token_id=processor.tokenizer.eos_token_id,
                use_cache=True,
                num_beams=1,
                bad_words_ids=[[processor.tokenizer.unk_token_id]],
                return_dict_in_generate=True,
            )
        
        # Decode the output
        sequence = processor.batch_decode(outputs.sequences, skip_special_tokens=True)[0]
        sequence = sequence.replace(processor.tokenizer.eos_token, "").replace(processor.tokenizer.pad_token, "")
        
        print("✅ Generation completed!")
        print(f"\n📄 Raw Output:")
        print(f"Type: {type(sequence)}")
        print(f"Length: {len(sequence)}")
        print(f"Content: '{sequence}'")
        
        # Parse the output
        print("\n🔧 Parsing output...")
        parsed_result = parse_output(sequence)
        
        print("\n📋 Parsed Result:")
        print(json.dumps(parsed_result, indent=2))
        
        # Display items if found
        if parsed_result.get("items"):
            print("\n🛒 Extracted Items:")
            for i, item in enumerate(parsed_result["items"], 1):
                print(f"  {i}. {item['name']} - ${item['price']:.2f} x {item['quantity']} = ${item['total']:.2f}")
            
            print(f"\n💰 Total Amount: ${parsed_result['total_amount']:.2f}")
        
    except Exception as e:
        print(f"❌ Error during processing: {e}")
        import traceback
        traceback.print_exc()

def parse_output(sequence):
    """Parse the model output"""
    try:
        # Remove task prompt if present
        if isinstance(sequence, str):
            if sequence.startswith("<s_cord-v2>"):
                sequence = sequence[len("<s_cord-v2>"):]
            elif sequence.startswith("<s_cord>"):
                sequence = sequence[len("<s_cord>"):]
            
            sequence = sequence.strip()
            
            # Try to parse as JSON
            if sequence.startswith('{') and sequence.endswith('}'):
                try:
                    data = json.loads(sequence)
                    return extract_from_json(data)
                except json.JSONDecodeError:
                    pass
            
            # If not JSON, return as text
            return {
                "raw_output": sequence,
                "items": [],
                "total_amount": 0.0,
                "confidence_score": 0.5
            }
        
        elif isinstance(sequence, dict):
            return extract_from_json(sequence)
        
        else:
            return {
                "raw_output": str(sequence),
                "items": [],
                "total_amount": 0.0,
                "confidence_score": 0.5
            }
            
    except Exception as e:
        print(f"Error parsing output: {e}")
        return {
            "error": f"Parsing failed: {str(e)}",
            "raw_output": str(sequence)
        }

def extract_from_json(data):
    """Extract items from JSON structure"""
    items = []
    total_amount = 0.0
    
    # Extract menu items
    if "menu" in data:
        for item in data["menu"]:
            try:
                name = item.get("nm", "Unknown Item")
                
                # Skip header items
                if any(keyword in name.upper() for keyword in ['STORES', 'NAME', 'RATE', 'TOTAL', 'QTY']):
                    continue
                
                # Handle price extraction
                price_str = item.get("price", "0")
                if isinstance(price_str, str):
                    price_str = price_str.replace("Rp. ", "").replace(",", "").replace(" ", "")
                    if not price_str.replace(".", "").replace("-", "").isdigit():
                        continue
                    try:
                        price = float(price_str)
                    except ValueError:
                        continue
                else:
                    price = float(price_str)
                
                # Handle quantity
                cnt = item.get("cnt", 1)
                if isinstance(cnt, dict):
                    quantity = 1
                elif isinstance(cnt, str):
                    cnt_str = cnt.replace(",", "").replace(" ", "")
                    if cnt_str.replace(".", "").isdigit():
                        quantity = int(float(cnt_str))
                    else:
                        quantity = 1
                else:
                    quantity = int(cnt)
                
                if price > 0:
                    item_total = price * quantity
                    items.append({
                        "name": name,
                        "price": price,
                        "quantity": quantity,
                        "total": item_total
                    })
                    total_amount += item_total
                    
            except (ValueError, TypeError) as e:
                print(f"Skipping invalid item: {item}, error: {e}")
                continue
    
    # Extract total from total section
    if "total" in data and "total_price" in data["total"]:
        total_str = data["total"]["total_price"]
        if isinstance(total_str, str):
            try:
                total_str = total_str.replace("Rp. ", "").replace(",", "").replace(" ", "")
                if total_str.replace(".", "").isdigit():
                    total_amount = float(total_str)
            except ValueError:
                pass
    
    return {
        "items": items,
        "total_amount": total_amount,
        "confidence_score": 0.9,
        "raw_data": data
    }

if __name__ == "__main__":
    test_donut_alternative() 