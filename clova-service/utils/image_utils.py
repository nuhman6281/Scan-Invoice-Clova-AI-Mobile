import cv2
import numpy as np
from PIL import Image
import os
import logging
from typing import Tuple

logger = logging.getLogger(__name__)

def preprocess_image(image_path: str) -> str:
    """
    Preprocess image for CLOVA AI processing
    
    Args:
        image_path: Path to the input image
        
    Returns:
        Path to the preprocessed image
    """
    try:
        logger.info(f"Preprocessing image: {image_path}")
        
        # Load image
        image = cv2.imread(image_path)
        if image is None:
            raise ValueError(f"Failed to load image: {image_path}")
        
        # Convert BGR to RGB
        image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        
        # Resize image if too large
        height, width = image_rgb.shape[:2]
        max_size = 1024
        
        if max(height, width) > max_size:
            scale = max_size / max(height, width)
            new_width = int(width * scale)
            new_height = int(height * scale)
            image_rgb = cv2.resize(image_rgb, (new_width, new_height), interpolation=cv2.INTER_AREA)
            logger.info(f"Resized image from {width}x{height} to {new_width}x{new_height}")
        
        # Enhance image quality
        enhanced_image = enhance_image_quality(image_rgb)
        
        # Save preprocessed image
        output_path = generate_output_path(image_path)
        enhanced_image_pil = Image.fromarray(enhanced_image)
        enhanced_image_pil.save(output_path, 'JPEG', quality=95)
        
        logger.info(f"Preprocessing completed: {output_path}")
        return output_path
        
    except Exception as e:
        logger.error(f"Error preprocessing image: {str(e)}")
        # Return original path if preprocessing fails
        return image_path

def enhance_image_quality(image: np.ndarray) -> np.ndarray:
    """
    Enhance image quality for better OCR results
    
    Args:
        image: Input image as numpy array
        
    Returns:
        Enhanced image
    """
    try:
        # Convert to grayscale for processing
        gray = cv2.cvtColor(image, cv2.COLOR_RGB2GRAY)
        
        # Apply CLAHE (Contrast Limited Adaptive Histogram Equalization)
        clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8, 8))
        enhanced = clahe.apply(gray)
        
        # Denoise
        denoised = cv2.fastNlMeansDenoising(enhanced)
        
        # Sharpen
        kernel = np.array([[-1, -1, -1],
                          [-1,  9, -1],
                          [-1, -1, -1]])
        sharpened = cv2.filter2D(denoised, -1, kernel)
        
        # Convert back to RGB
        enhanced_rgb = cv2.cvtColor(sharpened, cv2.COLOR_GRAY2RGB)
        
        return enhanced_rgb
        
    except Exception as e:
        logger.error(f"Error enhancing image: {str(e)}")
        return image

def generate_output_path(original_path: str) -> str:
    """
    Generate output path for preprocessed image
    
    Args:
        original_path: Original image path
        
    Returns:
        Output path for preprocessed image
    """
    directory = os.path.dirname(original_path)
    filename = os.path.basename(original_path)
    name, ext = os.path.splitext(filename)
    
    output_filename = f"{name}_preprocessed{ext}"
    return os.path.join(directory, output_filename)

def validate_image(image_path: str) -> bool:
    """
    Validate image file
    
    Args:
        image_path: Path to the image file
        
    Returns:
        True if image is valid
    """
    try:
        # Check if file exists
        if not os.path.exists(image_path):
            logger.error(f"Image file does not exist: {image_path}")
            return False
        
        # Check file size
        file_size = os.path.getsize(image_path)
        max_size = 50 * 1024 * 1024  # 50MB
        if file_size > max_size:
            logger.error(f"Image file too large: {file_size} bytes")
            return False
        
        # Try to load image
        image = cv2.imread(image_path)
        if image is None:
            logger.error(f"Failed to load image: {image_path}")
            return False
        
        # Check image dimensions
        height, width = image.shape[:2]
        if height < 100 or width < 100:
            logger.error(f"Image too small: {width}x{height}")
            return False
        
        if height > 4000 or width > 4000:
            logger.error(f"Image too large: {width}x{height}")
            return False
        
        return True
        
    except Exception as e:
        logger.error(f"Error validating image: {str(e)}")
        return False

def get_image_info(image_path: str) -> dict:
    """
    Get image information
    
    Args:
        image_path: Path to the image file
        
    Returns:
        Dictionary with image information
    """
    try:
        image = cv2.imread(image_path)
        if image is None:
            return {}
        
        height, width = image.shape[:2]
        channels = image.shape[2] if len(image.shape) > 2 else 1
        
        return {
            "width": width,
            "height": height,
            "channels": channels,
            "file_size": os.path.getsize(image_path),
            "format": os.path.splitext(image_path)[1].lower()
        }
        
    except Exception as e:
        logger.error(f"Error getting image info: {str(e)}")
        return {}