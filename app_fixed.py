"""
Fixed Donut Demo
Uses the same approach as real_clova_service.py for proper CORD-v2 processing
"""
import argparse
import json
import gradio as gr
import torch
from PIL import Image
from donut import DonutModel


class FixedDonutProcessor:
    """Fixed Donut processor that properly handles CORD-v2 output"""
    
    def __init__(self, model_path="naver-clova-ix/donut-base-finetuned-cord-v2"):
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.model = None
        self.task_prompt = "<s_cord-v2>"
        self.model_path = model_path
        
    def load_model(self):
        """Load the Donut model with proper configuration"""
        print(f"Loading Donut model from: {self.model_path}")
        print(f"Device: {self.device}")
        
        # Load model with ignore_mismatched_sizes to handle weight mismatches
        self.model = DonutModel.from_pretrained(
            self.model_path,
            ignore_mismatched_sizes=True
        )
        
        # Move to device and set to eval mode
        if torch.cuda.is_available():
            self.model.half()
            self.model.to(self.device)
        
        self.model.eval()
        print("Model loaded successfully!")
        
    def process_image(self, image):
        """Process image and return structured result"""
        if self.model is None:
            return {"error": "Model not loaded"}
        
        try:
            # Convert gradio image to PIL
            if hasattr(image, 'shape'):  # numpy array from gradio
                pil_image = Image.fromarray(image)
            else:
                pil_image = image
            
            print(f"Processing image: {pil_image.size}")
            
            # Use the same approach as real_clova_service.py
            result = self.model.inference(image=pil_image, prompt=self.task_prompt)
            sequence = result["predictions"][0]
            
            print(f"Raw model output: {sequence}")
            
            # Parse the output
            parsed_result = self._parse_output(sequence)
            
            return parsed_result
            
        except Exception as e:
            print(f"Error processing image: {e}")
            return {"error": str(e)}
    
    def _parse_output(self, sequence):
        """Parse the model output into structured data"""
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
                        return self._extract_from_json(data)
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
                return self._extract_from_json(sequence)
            
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
    
    def _extract_from_json(self, data):
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


# Global processor instance
processor = FixedDonutProcessor()


def demo_process(input_img):
    """Gradio interface function"""
    result = processor.process_image(input_img)
    
    # Format the result for display
    if "error" in result:
        return f"Error: {result['error']}"
    
    # Create a formatted output
    output_lines = []
    
    if result.get("items"):
        output_lines.append("📋 Extracted Items:")
        for item in result["items"]:
            output_lines.append(f"  • {item['name']} - ${item['price']:.2f} x {item['quantity']} = ${item['total']:.2f}")
        
        output_lines.append(f"\n💰 Total Amount: ${result['total_amount']:.2f}")
        output_lines.append(f"🎯 Confidence: {result['confidence_score']:.1%}")
    
    if result.get("raw_output"):
        output_lines.append(f"\n📄 Raw Output:\n{result['raw_output']}")
    
    if result.get("raw_data"):
        output_lines.append(f"\n🔍 Raw Data:\n{json.dumps(result['raw_data'], indent=2)}")
    
    return "\n".join(output_lines) if output_lines else "No data extracted"


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--task", type=str, default="cord-v2")
    parser.add_argument("--pretrained_path", type=str, default="naver-clova-ix/donut-base-finetuned-cord-v2")
    parser.add_argument("--port", type=int, default=7860)
    parser.add_argument("--url", type=str, default=None)
    parser.add_argument("--sample_img_path", type=str)
    args, left_argv = parser.parse_known_args()

    # Load the model
    processor.load_model()

    # Prepare example
    example_sample = []
    if args.sample_img_path:
        example_sample.append(args.sample_img_path)

    # Create Gradio interface
    demo = gr.Interface(
        fn=demo_process,
        inputs="image",
        outputs="text",
        title="🍩 Fixed Donut CORD-v2 Invoice Scanner",
        description="Upload an invoice image to extract items and totals using the CORD-v2 model",
        examples=[example_sample] if example_sample else None,
    )
    
    print(f"Starting demo on port {args.port}")
    demo.launch(server_name=args.url, server_port=args.port) 