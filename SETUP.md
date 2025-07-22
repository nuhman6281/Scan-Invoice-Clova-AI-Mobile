# Donut Project Setup Guide

## Overview
This guide will help you set up the Donut (Document Understanding Transformer) project on any platform (Windows, macOS, Linux).

## Prerequisites

### Required Software
- **Python 3.7+** (3.11.0 recommended)
- **Git** (for cloning the repository)
- **pip** (Python package installer)

### Optional Software
- **Docker** (for containerized deployment)
- **Node.js** (for web development tools)

## Quick Setup

### 1. Clone the Repository
```bash
git clone <repository-url>
cd Scan-Invoice-Clova-AI-Mobile
```

### 2. Run the Setup Script
Choose the appropriate script for your platform:

**Windows:**
```powershell
.\setup.bat
```

**macOS/Linux:**
```bash
./setup.sh
```

**Cross-platform (Python):**
```bash
python setup_project.py
```

### 3. Activate the Environment
**Windows:**
```powershell
.\donut_env\Scripts\Activate.ps1
```

**macOS/Linux:**
```bash
source donut_env/bin/activate
```

## Manual Setup

If you prefer to set up manually or the automated script fails:

### 1. Create Virtual Environment
```bash
python -m venv donut_env
```

### 2. Activate Virtual Environment
**Windows:**
```powershell
.\donut_env\Scripts\Activate.ps1
```

**macOS/Linux:**
```bash
source donut_env/bin/activate
```

### 3. Install Dependencies
```bash
pip install --upgrade pip
pip install -e .
pip install gradio fastapi uvicorn python-multipart Pillow easyocr numpy structlog
```

### 4. Fix Compatibility Issues (if needed)
If you encounter import errors or compatibility issues:
```bash
pip install pyarrow==14.0.2 datasets==2.14.4 transformers==4.25.1
```

## Testing the Installation

### 1. Test Basic Import
```bash
python -c "import donut; print('✅ Donut imported successfully!')"
```

### 2. Run the Demo
```bash
python app.py --task cord-v2 --port 7860
```

The demo will be available at: http://localhost:7860

**Note:** The first run may take 1-2 minutes as it downloads the pre-trained model.

### 3. Test with Sample Images
The project includes sample images in the `misc/` folder:
- `misc/sample_image_cord_test_receipt_00004.png`
- `misc/sample_image_donut_document.png`
- `misc/sample_synthdog.png`

## Available Tasks

The Donut model supports several document understanding tasks:

### Document Parsing (CORD)
```bash
python app.py --task cord-v2
```

### Document Classification (RVL-CDIP)
```bash
python app.py --task rvlcdip
```

### Document VQA (DocVQA)
```bash
python app.py --task docvqa
```

### Train Ticket Parsing
```bash
python app.py --task zhtrainticket
```

## Training Custom Models

### 1. Prepare Dataset
Follow the dataset structure described in the main README.md

### 2. Configure Training
Edit the configuration files in `config/` directory

### 3. Start Training
```bash
python train.py --config config/train_cord.yaml --pretrained_model_name_or_path "naver-clova-ix/donut-base" --dataset_name_or_paths '["your-dataset"]' --exp_version "your_experiment"
```

## Troubleshooting

### Common Issues

#### 1. Port Already in Use
If port 7860 is already in use, specify a different port:
```bash
python app.py --task cord-v2 --port 7861
```

#### 2. Memory Issues
If you encounter memory issues, try:
- Reducing batch size in training
- Using CPU instead of GPU
- Closing other applications

#### 3. Import Errors
If you get import errors:
```bash
pip install --upgrade pip
pip install -r requirements.txt
```

#### 4. CUDA Issues
If you have CUDA issues:
```bash
pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu
```

#### 5. Transformers Compatibility Issues
If you get `cache_position` or similar errors:
```bash
pip install transformers==4.25.1 pyarrow==14.0.2 datasets==2.14.4
```

#### 6. PyArrow Compatibility Issues
If you get `PyExtensionType` errors:
```bash
pip install pyarrow==14.0.2
```

### Platform-Specific Issues

#### Windows
- Use PowerShell or Command Prompt
- Ensure Python is in PATH
- Use `.\` for script execution

#### macOS
- Use Terminal
- May need to install Xcode Command Line Tools
- Use `chmod +x setup.sh` to make scripts executable

#### Linux
- Use Terminal
- May need to install build essentials
- Use `chmod +x setup.sh` to make scripts executable

## Environment Variables

You can set these environment variables for customization:

```bash
export DONUT_MODEL_PATH="path/to/your/model"
export DONUT_CACHE_DIR="path/to/cache"
export CUDA_VISIBLE_DEVICES="0"  # GPU device to use
```

## Project Structure

```
Scan-Invoice-Clova-AI-Mobile/
├── app.py                 # Main demo application
├── train.py              # Training script
├── test.py               # Testing script
├── setup.py              # Package setup
├── setup_project.py      # Cross-platform setup script
├── setup.bat             # Windows setup script
├── setup.sh              # Unix setup script
├── config/               # Training configurations
├── dataset/              # Dataset directory
├── misc/                 # Sample images and resources
├── result/               # Training results
├── synthdog/             # Synthetic data generator
├── donut/                # Core Donut library
├── donut_env/            # Python virtual environment
└── clova-invoice-scanner/ # Main application
```

## Support

For issues and questions:
1. Check the troubleshooting section above
2. Review the main README.md
3. Check the project documentation
4. Open an issue on the repository

## License

This project is licensed under the MIT License - see the LICENSE file for details. 