"""
Image processing utilities
"""

import cv2
import numpy as np
from PIL import Image
from typing import Tuple

def preprocess_image(image_path: str) -> np.ndarray:
    """Preprocess image for AI model input"""
    try:
        # Read image
        image = cv2.imread(image_path)
        if image is None:
            raise ValueError(f"Could not read image: {image_path}")
        
        # Convert BGR to RGB
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        
        return image
        
    except Exception as e:
        raise ValueError(f"Failed to preprocess image: {e}")

def enhance_image_quality(image: np.ndarray) -> np.ndarray:
    """Enhance image quality for better OCR results"""
    try:
        # Convert to grayscale for processing
        gray = cv2.cvtColor(image, cv2.COLOR_RGB2GRAY)
        
        # Apply CLAHE (Contrast Limited Adaptive Histogram Equalization)
        clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8,8))
        enhanced = clahe.apply(gray)
        
        # Denoise
        denoised = cv2.fastNlMeansDenoising(enhanced)
        
        # Convert back to RGB
        enhanced_rgb = cv2.cvtColor(denoised, cv2.COLOR_GRAY2RGB)
        
        return enhanced_rgb
        
    except Exception as e:
        # Return original image if enhancement fails
        return image

def resize_image(image: np.ndarray, max_size: Tuple[int, int] = (1024, 1024)) -> np.ndarray:
    """Resize image while maintaining aspect ratio"""
    try:
        height, width = image.shape[:2]
        max_width, max_height = max_size
        
        # Calculate scaling factor
        scale = min(max_width / width, max_height / height)
        
        if scale < 1:
            new_width = int(width * scale)
            new_height = int(height * scale)
            resized = cv2.resize(image, (new_width, new_height), interpolation=cv2.INTER_AREA)
            return resized
        
        return image
        
    except Exception as e:
        return image 