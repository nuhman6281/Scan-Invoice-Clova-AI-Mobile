# Donut Project Setup Guide

## Current Status ✅

The Donut project has been successfully set up with the following components:

- ✅ Python virtual environment created (`donut_env`)
- ✅ Core dependencies installed (transformers, timm, datasets, pytorch-lightning, etc.)
- ✅ Donut module imported successfully
- ✅ Sample images available in `misc/` directory
- ✅ Gradio interface ready for web demos

## Issue ❌

The main blocker is the `sentencepiece` library installation, which is failing due to build issues on macOS with Python 3.13. This is a known compatibility issue.

## Solutions

### Option 1: Use Online Demos (Recommended) 🌐

The easiest way to try Donut is through the online demos:

1. **CORD (Document Parsing)**: https://huggingface.co/spaces/naver-clova-ix/donut-base-finetuned-cord-v2
2. **RVL-CDIP (Document Classification)**: https://huggingface.co/spaces/nielsr/donut-rvlcdip
3. **DocVQA (Document Q&A)**: https://huggingface.co/spaces/nielsr/donut-docvqa

### Option 2: Google Colab Demos 📊

Use the Google Colab notebooks mentioned in the README:

- [CORD Colab Demo](https://colab.research.google.com/drive/1NMSqoIZ_l39wyRD7yVjw2FIuU2aglzJi?usp=sharing)
- [Train Ticket Colab Demo](https://colab.research.google.com/drive/1YJBjllahdqNktXaBlq5ugPh1BCm8OsxI?usp=sharing)
- [RVL-CDIP Colab Demo](https://colab.research.google.com/drive/1iWOZHvao1W5xva53upcri5V6oaWT-P0O?usp=sharing)
- [DocVQA Colab Demo](https://colab.research.google.com/drive/1oKieslZCulFiquequ62eMGc-ZWgay4X3?usp=sharing)

### Option 3: Alternative Installation Methods 🔧

If you want to run locally, try these approaches:

#### Method A: Use conda (if available)

```bash
conda install -c conda-forge sentencepiece
```

#### Method B: Use Python 3.11 or 3.12

The sentencepiece build issues are more common with Python 3.13. Try with an older Python version:

```bash
# Create new environment with Python 3.11
python3.11 -m venv donut_env_311
source donut_env_311/bin/activate
pip install donut-python
```

#### Method C: Manual sentencepiece installation

```bash
# Install system dependencies
brew install protobuf cmake

# Set environment variables
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"
pip install sentencepiece
```

## Available Tasks

Once sentencepiece is working, you can run these tasks:

1. **Document Parsing (CORD)**: Extract structured data from receipts and invoices
2. **Document Classification (RVL-CDIP)**: Classify document types
3. **Document Q&A (DocVQA)**: Answer questions about document content
4. **Train Ticket Parsing**: Extract information from Chinese train tickets

## Sample Images

The project includes sample images in the `misc/` directory:

- `sample_image_cord_test_receipt_00004.png` - Receipt for parsing
- `sample_image_donut_document.png` - General document
- `sample_synthdog.png` - Synthetic document example

## Running the Demo

Once sentencepiece is installed, you can run:

```bash
# CORD task (document parsing)
python app.py --task cord --sample_img_path misc/sample_image_cord_test_receipt_00004.png

# RVL-CDIP task (document classification)
python app.py --task rvlcdip

# DocVQA task (document question answering)
python app.py --task docvqa
```

## Current Working Demo

Run the simple demo to see what's working:

```bash
python simple_demo.py
```

This will show the current status and provide links to online demos.

## Troubleshooting

If you continue having issues with sentencepiece:

1. Check the [sentencepiece installation guide](https://github.com/google/sentencepiece#installation)
2. Try using Docker with a pre-built environment
3. Use the online demos as they provide the full functionality without local setup issues

## Next Steps

1. Try the online demos to see Donut in action
2. If you need local installation, try the alternative methods above
3. Consider using the Google Colab notebooks for experimentation
